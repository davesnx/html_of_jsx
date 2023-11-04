open Ppxlib
open Ast_builder.Default
module List = ListLabels

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

let rewrite_node ~loc name args children =
  let name = estring ~loc name in

  let make_props =
    match args with
    | [] -> [%expr []]
    | props ->
        List.fold_left
          ~f:(fun xs (label, x) ->
            match label with
            | Nolabel -> xs
            | Optional name | Labelled name ->
                let make =
                  pexp_ident ~loc:x.pexp_loc
                    {
                      txt =
                        Longident.parse
                          (Printf.sprintf "React_server.React.Html_props.%s"
                             name);
                      loc = x.pexp_loc;
                    }
                in
                [%expr [%e make] [%e x] :: [%e xs]])
          ~init:[%expr []] props
  in
  match children with
  | None -> [%expr Element.node [%e name] [%e make_props] []]
  | Some childrens ->
      [%expr
        Element.node [%e name] [%e make_props] [%e pexp_list ~loc childrens]]

type props = {
  children : expression list;
  args : (arg_label * expression) list;
}

let split_props ~mapper args =
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
                      [%expr Html_jsx.text [%e e]]
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

let rewrite_jsx =
  object (self)
    inherit Ast_traverse.map as super

    method! expression expr =
      try
        match expr.pexp_desc with
        | Pexp_apply (({ pexp_desc = Pexp_ident _tagname; _ } as tag), props)
          when has_jsx_attr expr.pexp_attributes -> (
            let children, rest_of_props =
              split_props ~mapper:self#expression props
            in
            match tag.pexp_desc with
            | Pexp_ident { txt = Lident name; loc = name_loc }
              when is_html_element name ->
                rewrite_node ~loc:name_loc name rest_of_props children
            | Pexp_ident id ->
                rewrite_component ~loc:tag.pexp_loc id rest_of_props children
            | _ -> assert false)
        | Pexp_apply (tag, _props) when has_jsx_attr expr.pexp_attributes ->
            let loc = expr.pexp_loc in
            [%expr
              [%ocaml.error "html-jsx.ppx: tag should be an identifier"]
                [%e tag]]
        | _ -> super#expression expr
      with Error err -> [%expr [%e err]]
  end

let () =
  Ppxlib.Driver.register_transformation "html-jsx.ppx"
    ~preprocess_impl:rewrite_jsx#structure
