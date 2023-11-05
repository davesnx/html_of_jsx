open Ppxlib
open Ast_builder.Default
module List = ListLabels

let repo_url = "https://github.com/davesnx/html_of_jsx"
let issues_url = "https://github.com/davesnx/html_of_jsx/issues"

let is_html_element tag =
  match tag with
  | "a" | "abbr" | "address" | "area" | "article" | "aside" | "audio" | "b"
  | "base" | "bdi" | "bdo" | "blockquote" | "body" | "br" | "button" | "canvas"
  | "caption" | "cite" | "code" | "col" | "colgroup" | "data" | "datalist"
  | "dd" | "del" | "details" | "dfn" | "dialog" | "div" | "dl" | "dt" | "em"
  | "embed" | "fieldset" | "figcaption" | "figure" | "footer" | "form" | "h1"
  | "h2" | "h3" | "h4" | "h5" | "h6" | "head" | "header" | "hgroup" | "hr"
  | "html" | "i" | "iframe" | "img" | "input" | "ins" | "kbd" | "label"
  | "legend" | "li" | "link" | "main" | "map" | "mark" | "math" | "menu"
  | "menuitem" | "meta" | "meter" | "nav" | "noscript" | "object" | "ol"
  | "optgroup" | "option" | "output" | "p" | "param" | "picture" | "pre"
  | "progress" | "q" | "rb" | "rp" | "rt" | "rtc" | "ruby" | "s" | "samp"
  | "script" | "search" | "section" | "select" | "slot" | "small" | "source"
  | "span" | "strong" | "style" | "sub" | "summary" | "sup" | "svg" | "table"
  | "tbody" | "td" | "template" | "textarea" | "tfoot" | "th" | "thead" | "time"
  | "title" | "tr" | "track" | "u" | "ul" | "var" | "video" | "wbr" ->
      true
  | _ -> false

let is_svg_element tag =
  match tag with
  | "animate" | "animateMotion" | "animateTransform" | "circle" | "clipPath"
  | "defs" | "desc" | "ellipse" | "feBlend" | "feColorMatrix"
  | "feComponentTransfer" | "feComposite" | "feConvolveMatrix"
  | "feDiffuseLighting" | "feDisplacementMap" | "feDistantLight"
  | "feDropShadow" | "feFlood" | "feFuncA" | "feFuncB" | "feFuncG" | "feFuncR"
  | "feGaussianBlur" | "feImage" | "feMerge" | "feMergeNode" | "feMorphology"
  | "feOffset" | "fePointLight" | "feSpecularLighting" | "feSpotLight"
  | "feTile" | "feTurbulence" | "filter" | "foreignObject" | "g" | "image"
  | "line" | "linearGradient" | "marker" | "mask" | "metadata" | "mpath"
  | "path" | "pattern" | "polygon" | "polyline" | "radialGradient" | "rect"
  | "stop" | "switch" | "symbol" | "text" | "textPath" | "tspan" | "use"
  | "view" ->
      true
  | _ -> false

(* There's no pexp_list on Ppxlib since isn't a constructor of the Parsetree *)
let pexp_list ~loc xs =
  List.fold_left (List.rev xs) ~init:[%expr []] ~f:(fun xs x ->
      [%expr [%e x] :: [%e xs]])

exception Error of expression

let raise_errorf ~loc fmt =
  let open Ast_builder.Default in
  Printf.ksprintf
    (fun msg ->
      let expr =
        pexp_extension ~loc (Location.error_extensionf ~loc "%s" msg)
      in
      raise (Error expr))
    fmt

let collect_props visit args =
  let rec go props = function
    | [] -> (None, props)
    | [ (Nolabel, arg) ] -> (Some (visit arg), props)
    | (Nolabel, prop) :: _ ->
        let loc = prop.pexp_loc in
        let error =
          [%expr
            [%ocaml.error
              "an argument without a label could only be the last one"]]
        in
        go ((Nolabel, visit error) :: props) []
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
  | e -> raise_errorf ~loc:e.pexp_loc "JSX: children prop should be a list"

let has_jsx_attr attrs =
  List.exists
    ~f:(function { attr_name = { txt = "JSX"; _ }; _ } -> true | _ -> false)
    attrs

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
  match Ppx_static_attributes.findByName id name with
  | Ok p -> p
  | Error `ElementNotFound ->
      raise
      @@ Location.raise_errorf ~loc
           "HTML tag '%s' doesn't exist.\n\
            If this isn't correct, please open an issue at %s" id issues_url
  | Error `AttributeNotFound -> (
      match Ppx_static_attributes.find_closest_name name with
      | None ->
          raise_errorf ~loc
            "prop '%s' isn't valid on a '%s' element.\n\
             If this isn't correct, please open an issue at %s." name id
            issues_url
      | Some suggestion ->
          raise_errorf ~loc
            "prop '%s' isn't valid on a '%s' element.\n\
             Hint: Maybe you mean '%s'?\n\n\
             If this isn't correct, please open an issue at %s." name id
            suggestion issues_url)

let add_attribute_type_constraint ~loc ~is_optional
    (type_ : Ppx_static_attributes.attributeType) value =
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
  let open Ppx_static_attributes in
  match (prop, is_optional) with
  | Attribute { type_ = String; _ }, false ->
      [%expr
        Some (Jsx.Attribute.String ([%e attribute_name], [%e attribute_value]))]
  | Attribute { type_ = String; _ }, true ->
      [%expr
        Option.map
          (fun v -> Jsx.Attribute.String ([%e attribute_name], v))
          [%e attribute_value]]
  | Attribute { type_ = Int; _ }, false ->
      [%expr
        Some
          (Jsx.Attribute.String
             ([%e attribute_name], string_of_int [%e attribute_value]))]
  | Attribute { type_ = Int; _ }, true ->
      [%expr
        Option.map
          (fun v -> Jsx.Attribute.String ([%e attribute_name], string_of_int v))
          [%e attribute_value]]
  | Attribute { type_ = Bool; _ }, false ->
      [%expr
        Some (Jsx.Attribute.Bool ([%e attribute_name], [%e attribute_value]))]
  | Attribute { type_ = Bool; _ }, true ->
      [%expr
        Option.map
          (fun v -> Jsx.Attribute.Bool ([%e attribute_name], v))
          [%e attribute_value]]
  (* BooleanishString needs to transform bool into string *)
  | Attribute { type_ = BooleanishString; _ }, false ->
      [%expr
        Some
          (Jsx.Attribute.String
             ([%e attribute_name], string_of_bool [%e attribute_value]))]
  | Attribute { type_ = BooleanishString; _ }, true ->
      [%expr
        Option.map
          (fun v -> Jsx.Attribute.String ([%e attribute_name], v))
          string_of_bool [%e attribute_value]]
  | Attribute { type_ = Style; _ }, false ->
      [%expr Some (Jsx.Attribute.Style [%e attribute_value])]
  | Attribute { type_ = Style; _ }, true ->
      [%expr Option.map (fun v -> Jsx.Attribute.Style v) [%e attribute_value]]
  | Event _, false ->
      [%expr
        Some (Jsx.Attribute.Event ([%e attribute_name], [%e attribute_value]))]
  | Event _, true ->
      [%expr
        Option.map
          (fun v -> Jsx.Attribute.Event ([%e attribute_name], v))
          [%e attribute_value]]

let is_optional = function Optional _ -> true | _ -> false

let transform_labelled ~loc ~tag_name props (prop_label, (value : expression)) =
  match prop_label with
  | Nolabel -> props
  | Optional name | Labelled name ->
      let is_optional = is_optional prop_label in
      let attribute = validate_attr ~loc tag_name name in
      let attribute_type =
        match attribute with
        | Attribute { type_; _ } -> type_
        | Event _ -> String
      in
      let attribute_name = Ppx_static_attributes.getName attribute in
      let attribute_name_expr = estring ~loc attribute_name in
      let attribute_value =
        add_attribute_type_constraint ~loc ~is_optional attribute_type value
      in
      let attribute_final =
        make_attribute ~loc ~is_optional ~prop:attribute attribute_name_expr
          attribute_value
      in
      [%expr [%e attribute_final] :: [%e props]]

let transform_attributes ~loc ~tag_name args =
  match args with
  | [] -> [%expr []]
  | attrs -> (
      let list_of_attributes =
        attrs
        |> List.fold_left
             ~f:(transform_labelled ~loc ~tag_name)
             ~init:[%expr []]
      in
      match list_of_attributes with
      | [%expr []] -> [%expr []]
      | _ ->
          (* We need to filter attributes since optionals are represented as None *)
          [%expr List.filter_map Fun.id [%e list_of_attributes]])

let rewrite_node ~loc tag_name args children =
  let dom_node_name = estring ~loc tag_name in
  let attributes = transform_attributes ~loc ~tag_name args in
  match children with
  | Some children ->
      let childrens = pexp_list ~loc children in
      [%expr Jsx.node [%e dom_node_name] [%e attributes] [%e childrens]]
  | None -> [%expr Jsx.node [%e dom_node_name] [%e attributes] []]

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
                      [%expr Jsx.text [%e e]]
                  | _ -> e
                in
                mapper expression)
              children_expression
          in
          children := (children_expression.pexp_loc, children');
          None
      | arg_label, e -> Some (arg_label, mapper e))
  in
  let children_prop =
    match !children with _loc, [] -> None | _loc, children -> Some children
  in
  (children_prop, rest)

let revAstList ~loc expr =
  let rec revAstList_ acc = function
    | [%expr []] -> acc
    | [%expr [%e? hd] :: [%e? tl]] -> revAstList_ [%expr [%e hd] :: [%e acc]] tl
    | expr -> expr
  in
  revAstList_ [%expr []] expr

let list_have_tail listExpr =
  match listExpr with
  | Pexp_construct
      ({ txt = Lident "::"; _ }, Some { pexp_desc = Pexp_tuple _; _ })
  | Pexp_construct ({ txt = Lident "[]"; _ }, None) ->
      false
  | _ -> true

let transformChildrenIfList ~loc ~mapper children =
  let rec transformChildren_ children accum =
    match children with
    | [%expr []] -> revAstList ~loc accum
    | [%expr [%e? v] :: [%e? acc]] when list_have_tail acc.pexp_desc ->
        [%expr [%e mapper#expression v]]
    | [%expr [%e? v] :: [%e? acc]] ->
        transformChildren_ acc [%expr [%e mapper#expression v] :: [%e accum]]
    | notAList -> mapper#expression notAList
  in
  transformChildren_ children [%expr []]

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
            | Pexp_ident { txt = Lident name; loc = name_loc }
              when is_html_element name || is_svg_element name ->
                rewrite_node ~loc:name_loc name rest_of_args children
            (* Reason adds `createElement` as default when an uppercase is found,
               we change it back to make *)
            | Pexp_ident
                { txt = Ldot (modulePath, ("createElement" | "make")); loc } ->
                let id = { loc; txt = Ldot (modulePath, "make") } in
                rewrite_component ~loc:tag.pexp_loc id rest_of_args children
            | Pexp_ident id ->
                rewrite_component ~loc:tag.pexp_loc id rest_of_args children
            | _ -> assert false)
        | Pexp_apply (tag, _props) when has_jsx_attr expr.pexp_attributes ->
            let loc = expr.pexp_loc in
            [%expr
              [%ocaml.error "html_of_jsx.ppx: tag should be an identifier"]
                [%e tag]]
        (* Is a fragment? <></> *)
        (* It's represented in the AST as a list with [@JSX] *)
        | Pexp_construct
            ({ txt = Lident "::"; loc }, Some { pexp_desc = Pexp_tuple _; _ })
        | Pexp_construct ({ txt = Lident "[]"; loc }, None) -> (
            let jsxAttribute, nonJSXAttributes =
              List.partition
                ~f:(fun attribute -> attribute.attr_name.txt = "JSX")
                expr.pexp_attributes
            in
            match (jsxAttribute, nonJSXAttributes) with
            (* no JSX attribute *)
            | [], _ -> super#expression expr
            | _, _nonJSXAttributes ->
                let children = transformChildrenIfList ~loc ~mapper:self expr in
                [%expr Jsx.fragment [%e children]])
        | _ -> super#expression expr
      with Error err -> [%expr [%e err]]
  end

let () =
  Ppxlib.Driver.register_transformation "html_of_jsx.ppx"
    ~preprocess_impl:rewrite_jsx#structure
