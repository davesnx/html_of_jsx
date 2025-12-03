open Ppxlib

let ( let* ) = Option.bind

type static_part =
  | Static_str of string
  | Dynamic_string of expression
  | Dynamic_element of expression

let escape_html s =
  let len = String.length s in
  let buf = Buffer.create (len * 2) in
  for i = 0 to len - 1 do
    match s.[i] with
    | '&' -> Buffer.add_string buf "&amp;"
    | '<' -> Buffer.add_string buf "&lt;"
    | '>' -> Buffer.add_string buf "&gt;"
    | '\'' -> Buffer.add_string buf "&apos;"
    | '"' -> Buffer.add_string buf "&quot;"
    | c -> Buffer.add_char buf c
  done;
  Buffer.contents buf

(* Duplicated from JSX.Html.is_self_closing_tag - keep in sync *)
let is_self_closing_tag = function
  | "area" | "base" | "br" | "col" | "embed" | "hr" | "img" | "input" | "link"
  | "meta" | "param" | "source" | "track" | "wbr" | "menuitem" ->
      true
  | _ -> false

(** Extract a literal string from an expression, if it is one *)
let rec extract_literal_string expr =
  match expr.pexp_desc with
  | Pexp_constant (Pconst_string (s, _, _)) -> Some s
  | Pexp_constraint (inner, _) -> extract_literal_string inner
  | _ -> None

(** Extract a literal int from an expression, if it is one *)
let rec extract_literal_int expr =
  match expr.pexp_desc with
  | Pexp_constant (Pconst_integer (s, _)) -> Some (int_of_string s)
  | Pexp_constraint (inner, _) -> extract_literal_int inner
  | _ -> None

(** Extract a literal bool from an expression, if it is one *)
let rec extract_literal_bool expr =
  match expr.pexp_desc with
  | Pexp_construct ({ txt = Lident "true"; _ }, None) -> Some true
  | Pexp_construct ({ txt = Lident "false"; _ }, None) -> Some false
  | Pexp_constraint (inner, _) -> extract_literal_bool inner
  | _ -> None

(** Extract the argument from a JSX.string/text call, if present *)
let extract_jsx_string_arg expr =
  match expr.pexp_desc with
  | Pexp_apply
      ( {
          pexp_desc =
            Pexp_ident { txt = Ldot (Lident "JSX", ("text" | "string")); _ };
          _;
        },
        [ (Nolabel, arg) ] )
  | Pexp_apply
      ( { pexp_desc = Pexp_ident { txt = Lident ("text" | "string"); _ }; _ },
        [ (Nolabel, arg) ] ) ->
      Some arg
  | _ -> None

let extract_jsx_text_literal expr =
  let* arg = extract_jsx_string_arg expr in
  extract_literal_string arg

(** Represents a static attribute value *)
type static_attr_value =
  | Static_string of string
  | Static_int of int
  | Static_bool of bool

(** Try to extract a static attribute value from an expression *)
let extract_static_attr_value expr =
  match extract_literal_string expr with
  | Some s -> Some (Static_string s)
  | None -> (
      match extract_literal_int expr with
      | Some i -> Some (Static_int i)
      | None ->
          let* b = extract_literal_bool expr in
          Some (Static_bool b))

(** Render a static attribute value to a string *)
let render_attr_value = function
  | Static_string s -> escape_html s
  | Static_int i -> string_of_int i
  | Static_bool true -> "true"
  | Static_bool false -> "false"

type attr_render_info = {
  html_name : string;
  is_boolean : bool;
      (* HTML boolean attribute that renders as just the name when true *)
}
(** Information about a validated HTML attribute *)

type parsed_attr =
  | Static_attr of attr_render_info * static_attr_value
  | Optional_attr of string * expression
  | Dynamic_attr of string * expression

(** Result of validating an attribute *)
type attr_validation_result = Valid_attr of attr_render_info | Invalid_attr
(* Attribute validation failed, should fall back to JSX.node for proper error *)

(** Validate and get HTML attribute name and rendering info. Uses the Html
    module for proper validation. *)
let validate_attr_for_static ~tag_name jsx_name =
  match Html.findByName tag_name jsx_name with
  | Error _ ->
      (* Validation failed - return Invalid_attr to trigger fallback *)
      Invalid_attr
  | Ok prop ->
      let html_name = Html.getName prop in
      let is_boolean =
        match prop with
        | Html_attributes.Attribute { type_ = Bool; _ }
        | Html_attributes.Rich_attribute { type_ = Bool; _ } ->
            true
        | _ -> false
      in
      Valid_attr { html_name; is_boolean }

(** Render a single static attribute to HTML string. Returns the rendered string
    (with leading space) or empty for false booleans. *)
let render_static_attr_with_info info value =
  match value with
  | Static_bool false when info.is_boolean ->
      (* Boolean HTML attributes: false means don't render *)
      ""
  | Static_bool true when info.is_boolean ->
      (* Boolean HTML attributes: true renders as just the name *)
      " " ^ info.html_name
  | _ ->
      (* Regular attributes: render as name="value" *)
      let value_str = render_attr_value value in
      Printf.sprintf " %s=\"%s\"" info.html_name value_str

type attr_analysis_result = Ok of parsed_attr option | Invalid

let analyze_attribute ~tag_name (label, expr) : attr_analysis_result =
  match label with
  | Nolabel -> Ok None (* Children, handled separately *)
  | Optional name -> (
      match validate_attr_for_static ~tag_name name with
      | Invalid_attr -> Invalid
      | Valid_attr info -> Ok (Some (Optional_attr (info.html_name, expr))))
  | Labelled name -> (
      match validate_attr_for_static ~tag_name name with
      | Invalid_attr -> Invalid
      | Valid_attr info -> (
          match extract_static_attr_value expr with
          | Some value -> Ok (Some (Static_attr (info, value)))
          | None -> Ok (Some (Dynamic_attr (info.html_name, expr)))))

type attrs_analysis =
  | All_static of string
      (** All attributes are static, contains rendered HTML *)
  | Has_optional of (string * expression) list * string
      (** Has optional attrs: (name, expr) list and static part *)
  | Has_dynamic  (** Has dynamic attributes, can't optimize *)
  | Validation_failed
      (** Attribute validation failed, must use original path for error
          reporting *)

let analyze_attributes ~tag_name attrs =
  let rec loop static_buf optionals = function
    | [] ->
        if optionals = [] then All_static (Buffer.contents static_buf)
        else Has_optional (List.rev optionals, Buffer.contents static_buf)
    | attr :: rest -> (
        match analyze_attribute ~tag_name attr with
        | Invalid -> Validation_failed
        | Ok None -> loop static_buf optionals rest
        | Ok (Some (Static_attr (info, value))) ->
            Buffer.add_string static_buf
              (render_static_attr_with_info info value);
            loop static_buf optionals rest
        | Ok (Some (Optional_attr (name, expr))) ->
            loop static_buf ((name, expr) :: optionals) rest
        | Ok (Some (Dynamic_attr _)) -> Has_dynamic)
  in
  loop (Buffer.create 64) [] attrs

type children_analysis =
  | No_children
  | All_static_children of string
      (** All children are static, contains rendered HTML *)
  | All_string_dynamic of static_part list
      (** All dynamic parts are string-typed (JSX.string/text wrappers) *)
  | Mixed_children of static_part list
      (** Mix of static and dynamic elements *)

let extract_jsx_unsafe_literal expr =
  match expr.pexp_desc with
  | Pexp_apply
      ( { pexp_desc = Pexp_ident { txt = Ldot (Lident "JSX", "unsafe"); _ }; _ },
        [ (Nolabel, arg) ] ) ->
      extract_literal_string arg
  | _ -> None

let analyze_child expr =
  match extract_jsx_unsafe_literal expr with
  | Some s -> Static_str s (* Already escaped, don't double-escape *)
  | None -> (
      match extract_jsx_text_literal expr with
      | Some s -> Static_str (escape_html s)
      | None -> (
          match extract_literal_string expr with
          | Some s -> Static_str (escape_html s)
          | None -> (
              match extract_jsx_string_arg expr with
              | Some inner_expr -> Dynamic_string inner_expr
              | None -> Dynamic_element expr)))

let analyze_children children =
  match children with
  | None -> No_children
  | Some [] -> No_children
  | Some children ->
      let parts = List.map analyze_child children in
      let all_static =
        List.for_all (function Static_str _ -> true | _ -> false) parts
      in
      let has_element_dynamic =
        List.exists (function Dynamic_element _ -> true | _ -> false) parts
      in
      if all_static then (
        let buf = Buffer.create 128 in
        List.iter
          (function Static_str s -> Buffer.add_string buf s | _ -> ())
          parts;
        All_static_children (Buffer.contents buf))
      else if not has_element_dynamic then All_string_dynamic parts
      else Mixed_children parts

type element_analysis =
  | Fully_static of string
  | Needs_string_concat of static_part list
  | Needs_buffer of static_part list
  | Needs_conditional of {
      optional_attrs : (string * expression) list;
      static_attrs : string;
      tag_name : string;
      children_analysis : children_analysis;
    }
  | Cannot_optimize

let analyze_element ~tag_name ~attrs ~children =
  let attrs_result = analyze_attributes ~tag_name attrs in
  let children_result = analyze_children children in

  match (attrs_result, children_result) with
  | Validation_failed, _ -> Cannot_optimize
  | Has_dynamic, _ -> Cannot_optimize
  | All_static attrs_html, No_children when is_self_closing_tag tag_name ->
      let html = Printf.sprintf "<%s%s />" tag_name attrs_html in
      Fully_static html
  | All_static attrs_html, No_children ->
      let html = Printf.sprintf "<%s%s></%s>" tag_name attrs_html tag_name in
      Fully_static html
  | All_static attrs_html, All_static_children children_html ->
      let html =
        Printf.sprintf "<%s%s>%s</%s>" tag_name attrs_html children_html
          tag_name
      in
      Fully_static html
  | All_static attrs_html, All_string_dynamic parts ->
      let open_tag = Printf.sprintf "<%s%s>" tag_name attrs_html in
      let close_tag = Printf.sprintf "</%s>" tag_name in
      Needs_string_concat
        ([ Static_str open_tag ] @ parts @ [ Static_str close_tag ])
  | All_static attrs_html, Mixed_children parts ->
      let open_tag = Printf.sprintf "<%s%s>" tag_name attrs_html in
      let close_tag = Printf.sprintf "</%s>" tag_name in
      Needs_buffer ([ Static_str open_tag ] @ parts @ [ Static_str close_tag ])
  | Has_optional (optionals, static_attrs), children_result ->
      Needs_conditional
        {
          optional_attrs = optionals;
          static_attrs;
          tag_name;
          children_analysis = children_result;
        }

let maybe_add_doctype tag_name html =
  if tag_name = "html" then "<!DOCTYPE html>" ^ html else html
