open Ppxlib
open Ast_builder.Default
module List = ListLabels

let issues_url = "https://github.com/davesnx/html_of_jsx/issues"

(* Flags to control optimizations *)
let disable_static_optimization = ref false

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
  match Html.findByName id name with
  | Ok p -> p
  | Error `ElementNotFound ->
      raise_errorf ~loc
        {|HTML tag '%s' doesn't exist.

If this is not correct, please open an issue at %s|}
        id issues_url
  | Error (`AttributeNotFound suggestion) ->
      let suggestion =
        match suggestion with
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
    (type_ : Html_attributes.kind) value =
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
  let open Html_attributes in
  match (prop, is_optional) with
  | Rich_attribute { type_ = String; _ }, false
  | Attribute { type_ = String; _ }, false ->
      [%expr Some ([%e attribute_name], `String [%e attribute_value])]
  | Rich_attribute { type_ = String; _ }, true
  | Attribute { type_ = String; _ }, true ->
      [%expr
        Stdlib.Option.map
          (fun v -> ([%e attribute_name], `String v))
          [%e attribute_value]]
  | Rich_attribute { type_ = Int; _ }, false
  | Attribute { type_ = Int; _ }, false ->
      [%expr Some ([%e attribute_name], `Int [%e attribute_value])]
  | Rich_attribute { type_ = Int; _ }, true | Attribute { type_ = Int; _ }, true
    ->
      [%expr
        Stdlib.Option.map
          (fun v -> ([%e attribute_name], `Int v))
          [%e attribute_value]]
  | Rich_attribute { type_ = Bool; _ }, false
  | Attribute { type_ = Bool; _ }, false ->
      [%expr Some ([%e attribute_name], `Bool [%e attribute_value])]
  | Rich_attribute { type_ = Bool; _ }, true
  | Attribute { type_ = Bool; _ }, true ->
      [%expr
        Stdlib.Option.map
          (fun v -> ([%e attribute_name], `Bool v))
          [%e attribute_value]]
  (* BooleanishString needs to transform bool into string *)
  | Rich_attribute { type_ = BooleanishString; _ }, false
  | Attribute { type_ = BooleanishString; _ }, false ->
      [%expr
        Some ([%e attribute_name], `String (Bool.to_string [%e attribute_value]))]
  | Rich_attribute { type_ = BooleanishString; _ }, true
  | Attribute { type_ = BooleanishString; _ }, true ->
      [%expr
        Stdlib.Option.map
          (fun v -> ([%e attribute_name], `String v))
          (Bool.to_string [%e attribute_value])]
  | Rich_attribute { type_ = Style; _ }, false
  | Attribute { type_ = Style; _ }, false ->
      [%expr Some ("style", `String [%e attribute_value])]
  | Rich_attribute { type_ = Style; _ }, true
  | Attribute { type_ = Style; _ }, true ->
      [%expr
        Stdlib.Option.map (fun v -> ("style", `String v)) [%e attribute_value]]
  | Event _, false ->
      [%expr Some ([%e attribute_name], `String [%e attribute_value])]
  | Event _, true ->
      [%expr
        Stdlib.Option.map
          (fun v -> ([%e attribute_name], `String v))
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
      let attribute_name = Html.getName attribute in
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
      [%expr Stdlib.List.filter_map Stdlib.Fun.id [%e attrs]]

let default_buffer_size = 1024

let generate_buffer_code ~loc parts =
  let buf_var = "__html_buf" in
  let buf_ident = pexp_ident ~loc { loc; txt = Lident buf_var } in
  let buf_pat = ppat_var ~loc { loc; txt = buf_var } in
  let buffer_size_expr = eint ~loc default_buffer_size in
  let generate_part_code part =
    match part with
    | Static_analysis.Static_str s ->
        let s_expr = estring ~loc s in
        [%expr Buffer.add_string [%e buf_ident] [%e s_expr]]
    | Static_analysis.Dynamic_string expr ->
        [%expr JSX.escape [%e buf_ident] [%e expr]]
    | Static_analysis.Dynamic_int expr ->
        (* Int.to_string cannot produce escapable characters, skip JSX.escape *)
        [%expr Buffer.add_string [%e buf_ident] (Int.to_string [%e expr])]
    | Static_analysis.Dynamic_float expr ->
        (* Float.to_string cannot produce escapable characters, skip JSX.escape *)
        [%expr Buffer.add_string [%e buf_ident] (Float.to_string [%e expr])]
    | Static_analysis.Dynamic_element expr ->
        [%expr JSX.write [%e buf_ident] [%e expr]]
  in

  let ops = List.map ~f:generate_part_code parts in
  let seq =
    List.fold_right ops ~init:[%expr ()] ~f:(fun op acc ->
        [%expr
          [%e op];
          [%e acc]])
  in

  [%expr
    let [%p buf_pat] = Buffer.create [%e buffer_size_expr] in
    [%e seq];
    JSX.unsafe (Buffer.contents [%e buf_ident])]

let generate_optional_attrs_code ~loc analysis =
  let tag_name, static_attrs, optional_attrs, children_parts, is_self_closing =
    match analysis with
    | Static_analysis.Has_optional_attrs
        {
          tag_name;
          static_attrs;
          optional_attrs;
          children_parts;
          is_self_closing;
        } ->
        (tag_name, static_attrs, optional_attrs, children_parts, is_self_closing)
    | _ -> assert false
  in
  let buf_var = "__html_buf" in
  let buf_ident = pexp_ident ~loc { loc; txt = Lident buf_var } in
  let buf_pat = ppat_var ~loc { loc; txt = buf_var } in
  let buffer_size_expr = eint ~loc default_buffer_size in
  let tag_name_expr = estring ~loc tag_name in
  let static_attrs_expr = estring ~loc static_attrs in

  (* Generate opening tag start (without closing >) *)
  let open_tag_start =
    [%expr
      Buffer.add_char [%e buf_ident] '<';
      Buffer.add_string [%e buf_ident] [%e tag_name_expr];
      Buffer.add_string [%e buf_ident] [%e static_attrs_expr]]
  in

  (* Generate opening tag end (closing > or />) *)
  let open_tag_end =
    if is_self_closing then [%expr Buffer.add_string [%e buf_ident] " />"]
    else [%expr Buffer.add_char [%e buf_ident] '>']
  in

  (* Generate code for each optional attribute *)
  let generate_optional_attr_code
      ((info : Static_analysis.attr_render_info), expr) =
    let html_name_expr = estring ~loc info.html_name in
    match info.is_boolean with
    | true ->
        (* Boolean attributes: add attribute name if Some true *)
        [%expr
          match [%e expr] with
          | Some true ->
              Buffer.add_char [%e buf_ident] ' ';
              Buffer.add_string [%e buf_ident] [%e html_name_expr]
          | Some false | None -> ()]
    | false ->
        (* String/int attributes: add attribute with value if Some *)
        let value_escape_code =
          match info.kind with
          | Html_attributes.String -> [%expr JSX.escape [%e buf_ident] v]
          | Html_attributes.Int ->
              [%expr Buffer.add_string [%e buf_ident] (Int.to_string v)]
          | Html_attributes.Bool ->
              [%expr Buffer.add_string [%e buf_ident] (Bool.to_string v)]
          | Html_attributes.BooleanishString ->
              [%expr Buffer.add_string [%e buf_ident] (Bool.to_string v)]
          | Html_attributes.Style -> [%expr JSX.escape [%e buf_ident] v]
        in
        [%expr
          match [%e expr] with
          | Some v ->
              Buffer.add_char [%e buf_ident] ' ';
              Buffer.add_string [%e buf_ident] [%e html_name_expr];
              Buffer.add_string [%e buf_ident] "=\"";
              [%e value_escape_code];
              Buffer.add_char [%e buf_ident] '"'
          | None -> ()]
  in

  let optional_attr_ops =
    List.map ~f:generate_optional_attr_code optional_attrs
  in

  (* Generate code for children *)
  let generate_part_code part =
    match part with
    | Static_analysis.Static_str s ->
        let s_expr = estring ~loc s in
        [%expr Buffer.add_string [%e buf_ident] [%e s_expr]]
    | Static_analysis.Dynamic_string expr ->
        [%expr JSX.escape [%e buf_ident] [%e expr]]
    | Static_analysis.Dynamic_int expr ->
        [%expr Buffer.add_string [%e buf_ident] (Int.to_string [%e expr])]
    | Static_analysis.Dynamic_float expr ->
        [%expr Buffer.add_string [%e buf_ident] (Float.to_string [%e expr])]
    | Static_analysis.Dynamic_element expr ->
        [%expr JSX.write [%e buf_ident] [%e expr]]
  in

  let children_ops = List.map ~f:generate_part_code children_parts in

  (* Generate closing tag *)
  let close_tag =
    if is_self_closing then [%expr Buffer.add_string [%e buf_ident] " />"]
    else
      [%expr
        Buffer.add_string [%e buf_ident] "</";
        Buffer.add_string [%e buf_ident] [%e tag_name_expr];
        Buffer.add_char [%e buf_ident] '>']
  in

  (* Combine all operations: open tag start, optional attrs, open tag end, children, close tag *)
  let all_ops =
    if is_self_closing then
      (* Self-closing tags: open tag start, optional attrs, open tag end (which includes />) *)
      (open_tag_start :: optional_attr_ops) @ [ open_tag_end ]
    else
      (* Regular tags: open tag start, optional attrs, open tag end (>), children, close tag *)
      (open_tag_start :: optional_attr_ops)
      @ [ open_tag_end ] @ children_ops @ [ close_tag ]
  in
  let seq =
    List.fold_right all_ops ~init:[%expr ()] ~f:(fun op acc ->
        [%expr
          [%e op];
          [%e acc]])
  in

  [%expr
    let [%p buf_pat] = Buffer.create [%e buffer_size_expr] in
    [%e seq];
    JSX.unsafe (Buffer.contents [%e buf_ident])]

let rewrite_node_unoptimized ~loc tag_name args children =
  let dom_node_name = estring ~loc tag_name in
  let attributes = transform_attributes ~loc ~tag_name args in
  match children with
  | Some children ->
      let childrens = pexp_list ~loc children in
      [%expr JSX.node [%e dom_node_name] [%e attributes] [%e childrens]]
  | None -> [%expr JSX.node [%e dom_node_name] [%e attributes] []]

let rewrite_node_optimized ~loc tag_name args children =
  let analysis =
    Static_analysis.analyze_element ~tag_name ~attrs:args ~children
  in

  match analysis with
  | Static_analysis.Fully_static html ->
      let html_with_doctype = Static_analysis.maybe_add_doctype tag_name html in
      let html_expr = estring ~loc html_with_doctype in
      [%expr JSX.unsafe [%e html_expr]]
  | Static_analysis.Needs_string_concat parts
  | Static_analysis.Needs_buffer parts ->
      generate_buffer_code ~loc parts
  | Static_analysis.Has_optional_attrs _ as optional_data ->
      generate_optional_attrs_code ~loc optional_data
  | Static_analysis.Cannot_optimize ->
      rewrite_node_unoptimized ~loc tag_name args children

let rewrite_node ~loc tag_name args children =
  if !disable_static_optimization then
    rewrite_node_unoptimized ~loc tag_name args children
  else rewrite_node_optimized ~loc tag_name args children

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

(* Extract children from a list expression for analysis *)
let extract_children_from_list expr =
  let rec extract acc = function
    | { pexp_desc = Pexp_construct ({ txt = Lident "[]"; _ }, None); _ } ->
        List.rev acc
    | {
        pexp_desc =
          Pexp_construct
            ( { txt = Lident "::"; _ },
              Some { pexp_desc = Pexp_tuple [ child; next ]; _ } );
        _;
      } ->
        extract (child :: acc) next
    | _ -> []
  in
  extract [] expr

(* Analyze fragment children and generate optimized code if possible *)
let optimize_fragment ~loc ~mapper children_expr =
  let children_list = extract_children_from_list children_expr in
  if children_list = [] then [%expr JSX.list []]
  else
    (* Analyze each child to see if we can optimize - check if they're static JSX elements *)
    let can_optimize, static_parts =
      List.fold_left
        ~f:(fun (can_opt, parts) child ->
          let transformed = mapper#expression child in
          (* Check if the transformed child is a static JSX.unsafe or JSX.string *)
          match transformed.pexp_desc with
          | Pexp_apply
              ( {
                  pexp_desc =
                    Pexp_ident
                      { txt = Ldot (Lident "JSX", ("unsafe" | "string")); _ };
                  _;
                },
                [ (Nolabel, arg) ] ) -> (
              match arg.pexp_desc with
              | Pexp_constant (Pconst_string (s, _, _)) ->
                  (can_opt, Static_analysis.Static_str s :: parts)
              | _ -> (false, parts))
          | _ -> (false, parts))
        ~init:(true, [])
        children_list
    in
    (* If all children are static, generate direct buffer writes *)
    if can_optimize && static_parts <> [] then
      let buf_var = "__html_buf" in
      let buf_ident = pexp_ident ~loc { loc; txt = Lident buf_var } in
      let buf_pat = ppat_var ~loc { loc; txt = buf_var } in
      let buffer_size_expr = eint ~loc default_buffer_size in
      let static_parts_rev = List.rev static_parts in
      let ops =
        List.map
          ~f:(function
            | Static_analysis.Static_str s ->
                let s_expr = estring ~loc s in
                [%expr Buffer.add_string [%e buf_ident] [%e s_expr]]
            | _ -> assert false)
          static_parts_rev
      in
      let seq =
        List.fold_right ops ~init:[%expr ()] ~f:(fun op acc ->
            [%expr
              [%e op];
              [%e acc]])
      in
      [%expr
        let [%p buf_pat] = Buffer.create [%e buffer_size_expr] in
        [%e seq];
        JSX.unsafe (Buffer.contents [%e buf_ident])]
    else
      (* Fall back to JSX.list for dynamic children - but generate sequential writes without list *)
      let transformed_children = transform_items_of_list ~loc ~mapper children_expr in
      (* For now, use JSX.list - we can optimize this further later *)
      [%expr JSX.list [%e transformed_children]]

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
                optimize_fragment ~loc ~mapper:self expr)
        | _ -> super#expression expr
      with Error err -> [%expr [%e err]]
  end

let () =
  let driver_args =
    [
      ( "Enable htmx attributes in HTML and SVG elements",
        "-htmx",
        Arg.Unit (fun () -> Extra_attributes.set Htmx) );
      ( "Enable react attributes in HTML and SVG elements",
        "-react",
        Arg.Unit (fun () -> Extra_attributes.set React) );
      ( "Disable static HTML optimization (use JSX.node for all elements)",
        "-disable-static-opt",
        Arg.Unit (fun () -> disable_static_optimization := true) );
    ]
  in

  List.iter
    ~f:(fun (doc, key, spec) -> Driver.add_arg key spec ~doc)
    driver_args;

  Driver.register_transformation "html_of_jsx.ppx"
    ~preprocess_impl:rewrite_jsx#structure
