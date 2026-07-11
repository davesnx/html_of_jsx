(* https://github.com/facebook/react/blob/97d75c9c8bcddb0daed1ed062101c7f5e9b825f4/packages/react-dom-bindings/src/shared/omittedCloseTags.js *)
let is_self_closing_tag = function
  | "area"
  | "base"
  | "br"
  | "col"
  | "embed"
  | "hr"
  | "img"
  | "input"
  | "link"
  | "meta"
  | "param"
  | "source"
  | "track"
  | "wbr"
  | "menuitem" ->
      true
  | _ ->
      false

(* Escapes by copying runs of clean characters in bulk with
   [Buffer.add_substring] and only splicing in entities where needed. Clean
   strings are copied with a single [add_substring].

   These are top-level functions taking all state as arguments on purpose:
   inner recursive functions would capture [buf]/[s] and allocate a closure
   on every [escape] call, which is on the hot path of every dynamic
   string. *)
let rec escape_loop buf s length run_start i =
  if i = length then (
    if length > run_start then
      Buffer.add_substring buf s run_start (length - run_start)
  ) else
    match String.unsafe_get s i with
    | '&' ->
        escape_entity buf s length run_start i "&amp;"
    | '<' ->
        escape_entity buf s length run_start i "&lt;"
    | '>' ->
        escape_entity buf s length run_start i "&gt;"
    | '\'' ->
        escape_entity buf s length run_start i "&apos;"
    | '"' ->
        escape_entity buf s length run_start i "&quot;"
    | _ ->
        escape_loop buf s length run_start (i + 1)

and escape_entity buf s length run_start i entity =
  if i > run_start then Buffer.add_substring buf s run_start (i - run_start);
  Buffer.add_string buf entity;
  escape_loop buf s length (i + 1) (i + 1)

let escape buf s = escape_loop buf s (String.length s) 0 0

(* [true] when [escape] would write [s] unchanged *)
let rec is_clean_string_from s length i =
  i = length
  ||
  match String.unsafe_get s i with
  | '&' | '<' | '>' | '\'' | '"' ->
      false
  | _ ->
      is_clean_string_from s length (i + 1)

let is_clean_string s = is_clean_string_from s (String.length s) 0

type attribute =
  string * [ `Bool of bool | `Int of int | `Float of float | `String of string ]

let write_attribute out (attr : attribute) =
  let write_name_and_eq name =
    Buffer.add_char out ' ';
    Buffer.add_string out name;
    Buffer.add_char out '=';
    Buffer.add_char out '"'
  in
  match attr with
  | _name, `Bool false ->
      (* false attributes don't get rendered *)
      ()
  | name, `Bool true ->
      (* true attributes render only the attribute name *)
      Buffer.add_char out ' ';
      Buffer.add_string out name
  | name, `String value ->
      write_name_and_eq name;
      escape out value;
      Buffer.add_char out '"'
  | name, `Int value ->
      write_name_and_eq name;
      Buffer.add_string out (Int.to_string value);
      Buffer.add_char out '"'
  | name, `Float value ->
      write_name_and_eq name;
      Buffer.add_string out (Float.to_string value);
      Buffer.add_char out '"'

type element =
  | Null
  | String of string
  | Int of int
  | Float of float
  | Unsafe of string (* text without encoding *)
  | Node of {
      tag : string;
      attributes : attribute list;
      children : element list;
    }
  | List of element list
  | Array of element array

let string txt = String txt
let text = string
let format fmt = Printf.ksprintf string fmt
let unsafe txt = Unsafe txt
let null = Null
let int i = Int i
let float f = Float f
let list arr = List arr
let array arr = Array arr
let fragment ~children () = List children
let node tag attributes children = Node { tag; attributes; children }

let write out element =
  let rec write_list = function
    | [] ->
        ()
    | x :: xs ->
        write x;
        write_list xs
  and write_attributes = function
    | [] ->
        ()
    | attr :: rest ->
        write_attribute out attr;
        write_attributes rest
  and write element =
    match element with
    | Null ->
        ()
    | List list ->
        write_list list
    | Node { tag; attributes; _ } when is_self_closing_tag tag ->
        Buffer.add_char out '<';
        Buffer.add_string out tag;
        write_attributes attributes;
        Buffer.add_string out " />"
    | Node { tag; attributes; children } ->
        if tag = "html" then Buffer.add_string out "<!DOCTYPE html>";
        Buffer.add_char out '<';
        Buffer.add_string out tag;
        write_attributes attributes;
        Buffer.add_char out '>';
        write_list children;
        Buffer.add_string out "</";
        Buffer.add_string out tag;
        Buffer.add_char out '>'
    | String text ->
        escape out text
    | Unsafe text ->
        Buffer.add_string out text
    | Int i ->
        Buffer.add_string out (Int.to_string i)
    | Float f ->
        Buffer.add_string out (Float.to_string f)
    | Array arr ->
        for i = 0 to Array.length arr - 1 do
          write (Array.unsafe_get arr i)
        done
  in
  write element

let render element =
  match element with
  | Null ->
      ""
  | Unsafe out ->
      (* The ppx compiles most elements down to [Unsafe html], render is a
         no-op in that case: return the string without copying. *)
      out
  | String text when is_clean_string text ->
      (* Nothing to escape: return the string without copying. *)
      text
  | String text ->
      let out = Buffer.create (String.length text + 16) in
      escape out text;
      Buffer.contents out
  | Int i ->
      Int.to_string i
  | Float f ->
      Float.to_string f
  | element ->
      let out = Buffer.create 256 in
      write out element;
      Buffer.contents out

let render_to_channel (chan : out_channel) element =
  let out = Buffer.create 256 in
  write out element;
  Buffer.output_buffer chan out

let render_streaming (write_fn : string -> unit) element =
  let out = Buffer.create 256 in
  write out element;
  write_fn (Buffer.contents out)

let pp ?(width = 80) element =
  let module CF =
    (val Pretty_expressive.Printer.default_cost_factory ~page_width:width ())
  in
  let module P = Pretty_expressive.Printer.Make (CF) in
  let open P in
  let escape_to_string s =
    let buf = Buffer.create (String.length s) in
    escape buf s;
    Buffer.contents buf
  in
  let text_with_newlines s =
    match String.split_on_char '\n' s with
    | [] ->
        empty
    | [ line ] ->
        text line
    | line :: rest ->
        List.fold_left (fun acc l -> acc ^^ hard_nl ^^ text l) (text line) rest
  in
  let is_text_like = function
    | String _ | Int _ | Float _ | Unsafe _ | Null ->
        true
    | Node _ | List _ | Array _ ->
        false
  in
  let doc_of_attribute (attr : attribute) =
    match attr with
    | _, `Bool false ->
        empty
    | name, `Bool true ->
        text (" " ^ name)
    | name, `String value ->
        text (" " ^ name ^ "=\"" ^ escape_to_string value ^ "\"")
    | name, `Int value ->
        text (" " ^ name ^ "=\"" ^ Int.to_string value ^ "\"")
    | name, `Float value ->
        text (" " ^ name ^ "=\"" ^ Float.to_string value ^ "\"")
  in
  let doc_of_attributes attrs =
    List.fold_left (fun acc a -> acc ^^ doc_of_attribute a) empty attrs
  in
  let rec doc_of = function
    | Null ->
        empty
    | String s ->
        text_with_newlines (escape_to_string s)
    | Int i ->
        text (Int.to_string i)
    | Float f ->
        text (Float.to_string f)
    | Unsafe s ->
        text_with_newlines s
    | List elements ->
        doc_of_children elements
    | Array arr ->
        doc_of_children (Array.to_list arr)
    | Node { tag; attributes; _ } when is_self_closing_tag tag ->
        text ("<" ^ tag) ^^ doc_of_attributes attributes ^^ text " />"
    | Node { tag; attributes; children } -> (
        let prefix =
          if tag = "html" then
            text "<!DOCTYPE html>" ^^ hard_nl
          else
            empty
        in
        let open_tag =
          text ("<" ^ tag) ^^ doc_of_attributes attributes ^^ text ">"
        in
        let close_tag = text ("</" ^ tag ^ ">") in
        match children with
        | [] ->
            prefix ^^ open_tag ^^ close_tag
        | _ when List.for_all is_text_like children ->
            prefix ^^ open_tag ^^ doc_of_children children ^^ close_tag
        | _ ->
            let children_doc = doc_of_block_children children in
            prefix
            ^^ group
                 (open_tag
                 ^^ nest 2 (break ^^ children_doc)
                 ^^ break ^^ close_tag
                 )
      )
  and doc_of_children elements =
    List.fold_left (fun acc el -> acc ^^ doc_of el) empty elements
  and doc_of_block_children elements =
    let docs =
      List.filter_map
        (fun el -> match el with Null -> None | _ -> Some (doc_of el))
        elements
    in
    match docs with
    | [] ->
        empty
    | [ d ] ->
        d
    | d :: rest ->
        List.fold_left (fun acc d -> acc ^^ break ^^ d) d rest
  in
  pretty_format (doc_of element)
