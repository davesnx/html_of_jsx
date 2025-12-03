(** Static analysis module for JSX optimization.

    This module determines if JSX expressions are "static" (compile-time
    constant) and can be pre-rendered to HTML strings at compile time. *)

open Ppxlib

(** Represents a part of a mixed static/dynamic expression *)
type static_part =
  | Static_str of string  (** A compile-time constant string *)
  | Dynamic_string of expression
      (** A runtime string expression (from JSX.string/text) *)
  | Dynamic_element of expression  (** A runtime JSX.element expression *)

(** The staticness of an expression *)
type staticness =
  | Static of string  (** Fully static - contains the rendered HTML *)
  | Dynamic  (** Contains runtime expressions that prevent optimization *)
  | Mixed of static_part list  (** Static structure with dynamic holes *)

(** HTML escape a string at compile time. Escapes ampersand, less-than,
    greater-than, apostrophe, and quote characters. *)
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

(** Check if a tag is self-closing (void element) *)
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

(** Check if an expression is a static JSX.text or JSX.string call with a
    literal argument *)
let extract_jsx_text_literal expr =
  match expr.pexp_desc with
  | Pexp_apply
      ( {
          pexp_desc =
            Pexp_ident { txt = Ldot (Lident "JSX", ("text" | "string")); _ };
          _;
        },
        [ (Nolabel, arg) ] ) ->
      extract_literal_string arg
  | Pexp_apply
      ( { pexp_desc = Pexp_ident { txt = Lident ("text" | "string"); _ }; _ },
        [ (Nolabel, arg) ] ) ->
      (* Also handle unqualified calls in case of local opens *)
      extract_literal_string arg
  | _ -> None

(** Represents a static attribute value *)
type static_attr_value =
  | Static_string of string
  | StaticInt of int
  | StaticBool of bool

(** Try to extract a static attribute value from an expression *)
let extract_static_attr_value expr =
  match extract_literal_string expr with
  | Some s -> Some (Static_string s)
  | None -> (
      match extract_literal_int expr with
      | Some i -> Some (StaticInt i)
      | None -> (
          match extract_literal_bool expr with
          | Some b -> Some (StaticBool b)
          | None -> None))

(** Render a static attribute value to a string *)
let render_attr_value = function
  | Static_string s -> escape_html s
  | StaticInt i -> string_of_int i
  | StaticBool true -> "true"
  | StaticBool false -> "false"

type attr_render_info = {
  html_name : string;
  is_boolean : bool;
      (* HTML boolean attribute that renders as just the name when true *)
}
(** Information about a validated HTML attribute *)

(** Represents a parsed attribute for static analysis *)
type parsed_attr =
  | StaticAttr of attr_render_info * static_attr_value  (** info, value *)
  | StaticBoolAttr of string * bool
      (** name, is_true - for boolean HTML attributes *)
  | OptionalAttr of string * expression
      (** name, value expr - optional attributes *)
  | DynamicAttr of string * expression  (** name, value expr - dynamic value *)

(** Result of validating an attribute *)
type attr_validation_result = ValidAttr of attr_render_info | InvalidAttr
(* Attribute validation failed, should fall back to JSX.node for proper error *)

(** Validate and get HTML attribute name and rendering info. Uses the Html
    module for proper validation. *)
let validate_attr_for_static ~tag_name jsx_name =
  match Html.findByName tag_name jsx_name with
  | Error _ ->
      (* Validation failed - return InvalidAttr to trigger fallback *)
      InvalidAttr
  | Ok prop ->
      let html_name = Html.getName prop in
      (* Check if it's a boolean HTML attribute *)
      let is_boolean =
        match html_name with
        | "disabled" | "checked" | "readonly" | "required" | "autofocus"
        | "autoplay" | "controls" | "loop" | "muted" | "default" | "defer"
        | "async" | "hidden" | "novalidate" | "formnovalidate" | "multiple"
        | "selected" | "open" | "allowfullscreen" | "seamless" | "itemscope"
        | "reversed" | "scoped" | "nomodule" | "playsinline" ->
            true
        | _ -> false
      in
      ValidAttr { html_name; is_boolean }

(** Render a single static attribute to HTML string. Returns the rendered string
    (with leading space) or empty for false booleans. *)
let render_static_attr_with_info info value =
  match value with
  | StaticBool false when info.is_boolean ->
      (* Boolean HTML attributes: false means don't render *)
      ""
  | StaticBool true when info.is_boolean ->
      (* Boolean HTML attributes: true renders as just the name *)
      " " ^ info.html_name
  | _ ->
      (* Regular attributes: render as name="value" *)
      let value_str = render_attr_value value in
      Printf.sprintf " %s=\"%s\"" info.html_name value_str

(** Result of analyzing an attribute *)
type attr_analysis_result =
  | AttrOk of parsed_attr option
  | AttrInvalid (* Validation failed *)

(** Analyze an attribute to determine its staticness *)
let analyze_attribute ~tag_name (label, expr) : attr_analysis_result =
  match label with
  | Nolabel -> AttrOk None (* Children, handled separately *)
  | Optional name -> (
      match validate_attr_for_static ~tag_name name with
      | InvalidAttr -> AttrInvalid
      | ValidAttr info -> AttrOk (Some (OptionalAttr (info.html_name, expr))))
  | Labelled name -> (
      match validate_attr_for_static ~tag_name name with
      | InvalidAttr -> AttrInvalid
      | ValidAttr info -> (
          match extract_static_attr_value expr with
          | Some value -> AttrOk (Some (StaticAttr (info, value)))
          | None -> AttrOk (Some (DynamicAttr (info.html_name, expr)))))

(** Result of analyzing attributes *)
type attrs_analysis =
  | All_static of string
      (** All attributes are static, contains rendered HTML *)
  | Has_optional of (string * expression) list * string
      (** Has optional attrs: (name, expr) list and static part *)
  | Has_dynamic  (** Has dynamic attributes, can't optimize *)
  | Validation_failed
      (** Attribute validation failed, must use original path for error
          reporting *)

(** Analyze all attributes of an element *)
let analyze_attributes ~tag_name attrs =
  let rec loop static_buf optionals = function
    | [] ->
        if optionals = [] then All_static (Buffer.contents static_buf)
        else Has_optional (List.rev optionals, Buffer.contents static_buf)
    | attr :: rest -> (
        match analyze_attribute ~tag_name attr with
        | AttrInvalid -> Validation_failed
        | AttrOk None -> loop static_buf optionals rest
        | AttrOk (Some (StaticAttr (info, value))) ->
            let rendered = render_static_attr_with_info info value in
            Buffer.add_string static_buf rendered;
            loop static_buf optionals rest
        | AttrOk (Some (StaticBoolAttr (name, true))) ->
            Buffer.add_char static_buf ' ';
            Buffer.add_string static_buf name;
            loop static_buf optionals rest
        | AttrOk (Some (StaticBoolAttr (_, false))) ->
            loop static_buf optionals rest
        | AttrOk (Some (OptionalAttr (name, expr))) ->
            loop static_buf ((name, expr) :: optionals) rest
        | AttrOk (Some (DynamicAttr _)) -> Has_dynamic)
  in
  loop (Buffer.create 64) [] attrs

(** Result of analyzing children *)
type children_analysis =
  | NoChildren
  | All_static_children of string
      (** All children are static, contains rendered HTML *)
  | All_string_dynamic of static_part list
      (** All dynamic parts are string-typed (JSX.string/text wrappers) *)
  | Mixed_children of static_part list
      (** Mix of static and dynamic elements *)

(** Extract content from JSX.unsafe("...") call if it has a string literal *)
let extract_jsx_unsafe_literal expr =
  match expr.pexp_desc with
  | Pexp_apply
      ( { pexp_desc = Pexp_ident { txt = Ldot (Lident "JSX", "unsafe"); _ }; _ },
        [ (Nolabel, arg) ] ) ->
      extract_literal_string arg
  | _ -> None

(** Check if an expression is a JSX.string or JSX.text call with a dynamic
    argument. Returns Some expr if it's a string wrapper, None otherwise. *)
let extract_jsx_string_wrapper expr =
  match expr.pexp_desc with
  | Pexp_apply
      ( {
          pexp_desc =
            Pexp_ident { txt = Ldot (Lident "JSX", ("text" | "string")); _ };
          _;
        },
        [ (Nolabel, arg) ] ) ->
      Some arg
  | Pexp_apply
      ( { pexp_desc = Pexp_ident { txt = Lident ("text" | "string"); _ }; _ },
        [ (Nolabel, arg) ] ) ->
      (* Also handle unqualified calls in case of local opens *)
      Some arg
  | _ -> None

(** Analyze a single child expression for staticness *)
let analyze_child expr =
  (* Check for JSX.unsafe("...") - already rendered static HTML *)
  match extract_jsx_unsafe_literal expr with
  | Some s -> Static_str s (* Already escaped, don't double-escape *)
  | None -> (
      (* Check for JSX.text/string with literal *)
      match extract_jsx_text_literal expr with
      | Some s -> Static_str (escape_html s)
      | None -> (
          (* Check for plain string literal *)
          match extract_literal_string expr with
          | Some s -> Static_str (escape_html s)
          | None -> (
              (* Check for JSX.string/text with dynamic argument *)
              match extract_jsx_string_wrapper expr with
              | Some inner_expr -> Dynamic_string inner_expr
              | None -> Dynamic_element expr)))

(** Analyze all children of an element. Note: This is called with
    already-processed children from the PPX. *)
let analyze_children children =
  match children with
  | None -> NoChildren
  | Some [] -> NoChildren
  | Some children ->
      let parts = List.map analyze_child children in
      (* Check if all parts are static *)
      let all_static =
        List.for_all (function Static_str _ -> true | _ -> false) parts
      in
      (* Check if all dynamic parts are string-typed (no element-typed) *)
      let has_element_dynamic =
        List.exists (function Dynamic_element _ -> true | _ -> false) parts
      in
      if all_static then (
        let buf = Buffer.create 128 in
        List.iter
          (function Static_str s -> Buffer.add_string buf s | _ -> ())
          parts;
        All_static_children (Buffer.contents buf))
      else if not has_element_dynamic then
        (* All dynamic parts are string-typed - can use string concatenation *)
        All_string_dynamic parts
      else
        (* Has element-typed dynamics - needs Buffer with JSX.write *)
        Mixed_children parts

(** Overall analysis result for a JSX element *)
type element_analysis =
  | Fully_static of string  (** Can be rendered entirely at compile time *)
  | Needs_string_concat of static_part list
      (** Can use string concatenation - all dynamics are string-typed *)
  | Needs_buffer of static_part list  (** Needs runtime Buffer assembly *)
  | Needs_conditional of {
      optional_attrs : (string * expression) list;
      static_attrs : string;
      tag_name : string;
      children_analysis : children_analysis;
    }  (** Needs conditional for optional attributes *)
  | Cannot_optimize  (** Fall back to JSX.node *)

(** Analyze a complete JSX element *)
let analyze_element ~tag_name ~attrs ~children =
  let attrs_result = analyze_attributes ~tag_name attrs in
  let children_result = analyze_children children in

  match (attrs_result, children_result) with
  | Validation_failed, _ ->
      (* Attribute validation failed - must use original path to get proper error *)
      Cannot_optimize
  | Has_dynamic, _ ->
      (* Dynamic attributes prevent optimization *)
      Cannot_optimize
  | All_static attrs_html, NoChildren when is_self_closing_tag tag_name ->
      (* Self-closing tag with static attrs, no children *)
      let html = Printf.sprintf "<%s%s />" tag_name attrs_html in
      Fully_static html
  | All_static attrs_html, NoChildren ->
      (* Regular tag with static attrs, no children *)
      let html = Printf.sprintf "<%s%s></%s>" tag_name attrs_html tag_name in
      Fully_static html
  | All_static attrs_html, All_static_children children_html ->
      (* Fully static element with children *)
      let html =
        Printf.sprintf "<%s%s>%s</%s>" tag_name attrs_html children_html
          tag_name
      in
      Fully_static html
  | All_static attrs_html, All_string_dynamic parts ->
      (* Static attrs with string-typed dynamic children - can use string concat *)
      let open_tag = Printf.sprintf "<%s%s>" tag_name attrs_html in
      let close_tag = Printf.sprintf "</%s>" tag_name in
      Needs_string_concat
        ([ Static_str open_tag ] @ parts @ [ Static_str close_tag ])
  | All_static attrs_html, Mixed_children parts ->
      (* Static attrs but mixed children (has element-typed) - needs Buffer *)
      let open_tag = Printf.sprintf "<%s%s>" tag_name attrs_html in
      let close_tag = Printf.sprintf "</%s>" tag_name in
      Needs_buffer ([ Static_str open_tag ] @ parts @ [ Static_str close_tag ])
  | Has_optional (optionals, static_attrs), children_result ->
      (* Has optional attributes - needs conditional *)
      Needs_conditional
        {
          optional_attrs = optionals;
          static_attrs;
          tag_name;
          children_analysis = children_result;
        }

(** Add DOCTYPE prefix for html tag *)
let maybe_add_doctype tag_name html =
  if tag_name = "html" then "<!DOCTYPE html>" ^ html else html
