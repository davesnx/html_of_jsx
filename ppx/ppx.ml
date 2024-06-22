open Ppxlib
open Ast_builder.Default
module List = ListLabels

let repo_url = "https://github.com/davesnx/html_of_jsx"
let issues_url = "https://github.com/davesnx/html_of_jsx/issues"

(* There's no pexp_list on Ppxlib since is not a constructor of the Parsetree *)
let pexp_list ~loc xs =
  List.fold_left (List.rev xs) ~init:[%expr []] ~f:(fun xs x ->
      [%expr [%e x] :: [%e xs]])

exception Error of expression

let raise_errorf ~loc fmt =
  let open Ast_builder.Default in
  Printf.ksprintf
    (fun msg ->
      let expr =
        pexp_extension ~loc
          (Location.error_extensionf ~loc "[html_of_jsx] %s" msg)
      in
      raise (Error expr))
    fmt

let collect_props visit args =
  let rec go props = function
    | [] -> (None, props)
    | [ (Nolabel, arg) ] -> (Some (visit arg), props)
    | (Nolabel, prop) :: _ ->
        let loc = prop.pexp_loc in
        raise_errorf ~loc
          "an argument without a label could only be the last one"
    | (proplab, prop) :: xs -> go ((proplab, visit prop) :: props) xs
  in
  go [] args

let rec unwrap_children ~f children = function
  | { pexp_desc = Pexp_construct ({ txt = Lident "[]"; _ }, None); _ } ->
      List.rev children
  | {
      pexp_desc =
        Pexp_construct
          ( { txt = Lident "::"; _ },
            Some { pexp_desc = Pexp_tuple [ child; next ]; _ } );
      _;
    } ->
      unwrap_children ~f (f child :: children) next
  | e -> raise_errorf ~loc:e.pexp_loc "children prop should be a list"

let is_jsx = function
  | { attr_name = { txt = "JSX"; _ }; _ } -> true
  | _ -> false

let has_jsx_attr attrs = List.exists ~f:is_jsx attrs

let rewrite_component ~loc tag args children =
  let component = pexp_ident ~loc tag in
  let props =
    match children with
    | None -> args
    | Some [ children ] -> (Labelled "children", children) :: args
    | Some children ->
        (Labelled "children", [%expr [%e pexp_list ~loc children]]) :: args
  in
  pexp_apply ~loc component props

let validate_attr ~loc id name =
  match Ppx_html.findByName id name with
  | Ok p -> p
  | Error `ElementNotFound ->
      raise_errorf ~loc
        {|HTML tag '%s' doesn't exist.

If this is not correct, please open an issue at %s|}
        id issues_url
  | Error `AttributeNotFound ->
      let suggestion =
        match Ppx_html.find_closest_name name with
        | Some suggestion ->
            Printf.sprintf "Hint: Maybe you mean '%s'?\n" suggestion
        | None -> ""
      in

      raise_errorf ~loc
        {|The attribute '%s' is not valid on a '%s' element.
%s
If this is not correct, please open an issue at %s.|}
        name id suggestion issues_url

let add_attribute_type_constraint ~loc ~is_optional
    (type_ : Ppx_attributes.attributeType) value =
  match (type_, is_optional) with
  | String, true -> [%expr ([%e value] : string option)]
  | String, false -> [%expr ([%e value] : string)]
  | Int, false -> [%expr ([%e value] : int)]
  | Int, true -> [%expr ([%e value] : int option)]
  | Bool, false -> [%expr ([%e value] : bool)]
  | Bool, true -> [%expr ([%e value] : bool option)]
  | BooleanishString, false -> [%expr ([%e value] : bool)]
  | BooleanishString, true -> [%expr ([%e value] : bool option)]
  (* We treat `Style` as string *)
  | Style, false -> [%expr ([%e value] : string)]
  | Style, true -> [%expr ([%e value] : string option)]

let make_attribute ~loc ~is_optional ~prop attribute_name attribute_value =
  let open Ppx_attributes in
  match (prop, is_optional) with
  | Rich_attribute { type_ = String; _ }, false
  | Attribute { type_ = String; _ }, false ->
      [%expr
        Some (JSX.Attribute.String ([%e attribute_name], [%e attribute_value]))]
  | Rich_attribute { type_ = String; _ }, true
  | Attribute { type_ = String; _ }, true ->
      [%expr
        Stdlib.Option.map
          (fun v -> JSX.Attribute.String ([%e attribute_name], v))
          [%e attribute_value]]
  | Rich_attribute { type_ = Int; _ }, false
  | Attribute { type_ = Int; _ }, false ->
      [%expr
        Some
          (JSX.Attribute.String
             ([%e attribute_name], string_of_int [%e attribute_value]))]
  | Rich_attribute { type_ = Int; _ }, true | Attribute { type_ = Int; _ }, true
    ->
      [%expr
        Stdlib.Option.map
          (fun v -> JSX.Attribute.String ([%e attribute_name], string_of_int v))
          [%e attribute_value]]
  | Rich_attribute { type_ = Bool; _ }, false
  | Attribute { type_ = Bool; _ }, false ->
      [%expr
        Some (JSX.Attribute.Bool ([%e attribute_name], [%e attribute_value]))]
  | Rich_attribute { type_ = Bool; _ }, true
  | Attribute { type_ = Bool; _ }, true ->
      [%expr
        Stdlib.Option.map
          (fun v -> JSX.Attribute.Bool ([%e attribute_name], v))
          [%e attribute_value]]
  (* BooleanishString needs to transform bool into string *)
  | Rich_attribute { type_ = BooleanishString; _ }, false
  | Attribute { type_ = BooleanishString; _ }, false ->
      [%expr
        Some
          (JSX.Attribute.String
             ([%e attribute_name], string_of_bool [%e attribute_value]))]
  | Rich_attribute { type_ = BooleanishString; _ }, true
  | Attribute { type_ = BooleanishString; _ }, true ->
      [%expr
        Stdlib.Option.map
          (fun v -> JSX.Attribute.String ([%e attribute_name], v))
          string_of_bool [%e attribute_value]]
  | Rich_attribute { type_ = Style; _ }, false
  | Attribute { type_ = Style; _ }, false ->
      [%expr Some (JSX.Attribute.Style [%e attribute_value])]
  | Rich_attribute { type_ = Style; _ }, true
  | Attribute { type_ = Style; _ }, true ->
      [%expr
        Stdlib.Option.map (fun v -> JSX.Attribute.Style v) [%e attribute_value]]
  | Event _, false ->
      [%expr
        Some (JSX.Attribute.Event ([%e attribute_name], [%e attribute_value]))]
  | Event _, true ->
      [%expr
        Stdlib.Option.map
          (fun v -> JSX.Attribute.Event ([%e attribute_name], v))
          [%e attribute_value]]

let is_optional = function Optional _ -> true | _ -> false

let transform_labelled ~loc:_parentLoc ~tag_name props (prop_label, value) =
  let loc = props.pexp_loc in
  match prop_label with
  | Nolabel -> props
  | Optional name | Labelled name ->
      let is_optional = is_optional prop_label in
      let attribute = validate_attr ~loc tag_name name in
      let attribute_type =
        match attribute with
        | Rich_attribute { type_; _ } -> type_
        | Attribute { type_; _ } -> type_
        | Event _ -> String
      in
      let attribute_name = Ppx_html.getName attribute in
      let attribute_name_expr = estring ~loc attribute_name in
      let attribute_value =
        add_attribute_type_constraint ~loc ~is_optional attribute_type value
      in
      let attribute_final =
        make_attribute ~loc ~is_optional ~prop:attribute attribute_name_expr
          attribute_value
      in
      [%expr [%e attribute_final] :: [%e props]]

let transform_attributes ~loc ~tag_name attrs =
  let attrs =
    List.rev attrs
    |> List.fold_left ~f:(transform_labelled ~loc ~tag_name) ~init:[%expr []]
  in
  match attrs with
  | [%expr []] -> [%expr []]
  | attrs ->
      (* We need to filter attributes since optionals are represented as None *)
      [%expr List.filter_map Fun.id [%e attrs]]

let rewrite_node ~loc tag_name args children =
  let dom_node_name = estring ~loc tag_name in
  let attributes = transform_attributes ~loc ~tag_name args in
  match children with
  | Some children ->
      let childrens = pexp_list ~loc children in
      [%expr JSX.node [%e dom_node_name] [%e attributes] [%e childrens]]
  | None -> [%expr JSX.node [%e dom_node_name] [%e attributes] []]

let split_args ~mapper args =
  let children = ref (Location.none, []) in
  let rest =
    List.filter_map args ~f:(function
      | Labelled "children", children_expression ->
          let children' =
            unwrap_children []
              ~f:(fun e ->
                let expression =
                  match e.pexp_desc with
                  | Pexp_constant (Pconst_string _) ->
                      let loc = e.pexp_loc in
                      [%expr JSX.string [%e e]]
                  | _ -> e
                in
                mapper expression)
              children_expression
          in
          children := (children_expression.pexp_loc, children');
          None
      | arg_label, expression -> Some (arg_label, mapper expression))
  in
  let children_prop =
    match !children with _, [] -> None | _loc, children -> Some children
  in
  (children_prop, rest)

let reverse_pexp_list ~loc expr =
  let rec go acc = function
    | [%expr []] -> acc
    | [%expr [%e? hd] :: [%e? tl]] -> go [%expr [%e hd] :: [%e acc]] tl
    | expr -> expr
  in
  go [%expr []] expr

let list_have_tail expr =
  match expr with
  | Pexp_construct
      ({ txt = Lident "::"; _ }, Some { pexp_desc = Pexp_tuple _; _ })
  | Pexp_construct ({ txt = Lident "[]"; _ }, None) ->
      false
  | _ -> true

let transform_items_of_list ~loc ~mapper children =
  let rec run_mapper children accum =
    match children with
    | [%expr []] -> reverse_pexp_list ~loc accum
    | [%expr [%e? v] :: [%e? acc]] when list_have_tail acc.pexp_desc ->
        [%expr [%e mapper#expression v]]
    | [%expr [%e? v] :: [%e? acc]] ->
        run_mapper acc [%expr [%e mapper#expression v] :: [%e accum]]
    | notAList -> mapper#expression notAList
  in
  run_mapper children [%expr []]

let rewrite_jsx =
  object (self)
    inherit Ast_traverse.map as super

    method! expression expr =
      try
        match expr.pexp_desc with
        | Pexp_apply (({ pexp_desc = Pexp_ident _; _ } as tag), args)
          when has_jsx_attr expr.pexp_attributes -> (
            let children, rest_of_args =
              split_args ~mapper:self#expression args
            in
            match tag.pexp_desc with
            (* div() [@JSX] *)
            | Pexp_ident { txt = Lident name; loc = name_loc }
              when Html.is_html_element name || Html.is_svg_element name ->
                rewrite_node ~loc:name_loc name rest_of_args children
            (* Reason adds `createElement` as default when an uppercase is found,
               we change it back to make *)
            (* Foo.createElement() [@JSX] *)
            | Pexp_ident
                { txt = Ldot (modulePath, ("createElement" | "make")); loc } ->
                let id = { loc; txt = Ldot (modulePath, "make") } in
                rewrite_component ~loc:tag.pexp_loc id rest_of_args children
            (* local_function() [@JSX] *)
            | Pexp_ident id ->
                rewrite_component ~loc:tag.pexp_loc id rest_of_args children
            | _ -> assert false)
        (* div() [@JSX] *)
        | Pexp_apply (_tag, _props) when has_jsx_attr expr.pexp_attributes ->
            raise_errorf ~loc:expr.pexp_loc "tag should be an identifier"
        (* <> </> is represented as a list in the Parsetree with [@JSX] *)
        | Pexp_construct
            ({ txt = Lident "::"; loc }, Some { pexp_desc = Pexp_tuple _; _ })
        | Pexp_construct ({ txt = Lident "[]"; loc }, None) -> (
            let jsx_attr, rest_attributes =
              List.partition ~f:is_jsx expr.pexp_attributes
            in
            match (jsx_attr, rest_attributes) with
            | [], _ -> super#expression expr
            | _, _rest_attributes ->
                let children = transform_items_of_list ~loc ~mapper:self expr in
                [%expr JSX.list [%e children]])
        | _ -> super#expression expr
      with Error err -> [%expr [%e err]]
  end

let () =
  let driver_args =
    [
      ( "-htmx",
        Arg.Unit (fun _ -> Ppx_extra_attributes.set_htmx ()),
        "Enable htmx props" );
      (* ( "-custom",
         Arg.String (fun file -> Static_attributes.extra_properties := Some file),
         "FILE Load inferred types from server cmo file FILE." ); *)
    ]
  in

  List.iter
    ~f:(fun (key, spec, doc) -> Driver.add_arg key spec ~doc)
    driver_args;
  Driver.register_transformation "html_of_jsx.ppx"
    ~preprocess_impl:rewrite_jsx#structure
