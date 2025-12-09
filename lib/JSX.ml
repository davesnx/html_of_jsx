(* https://github.com/facebook/react/blob/97d75c9c8bcddb0daed1ed062101c7f5e9b825f4/packages/react-dom-bindings/src/shared/omittedCloseTags.js *)
let is_self_closing_tag = function
  | "area" | "base" | "br" | "col" | "embed" | "hr" | "img" | "input" | "link"
  | "meta" | "param" | "source" | "track" | "wbr" | "menuitem" ->
      true
  | _ -> false

(* Hybrid escape: exception-based fast path for no-escape case (common),
   char-by-char loop when escaping is needed. Benchmarks show this is
   10-15% faster than tail-recursive find + loop for typical HTML content. *)
let escape buf s =
  let len = String.length s in
  let exception Needs_escape of int in
  try
    for i = 0 to len - 1 do
      match String.unsafe_get s i with
      | '&' | '<' | '>' | '\'' | '"' -> raise_notrace (Needs_escape i)
      | _ -> ()
    done;
    Buffer.add_string buf s (* Fast path: no escaping needed *)
  with Needs_escape first ->
    if first > 0 then Buffer.add_substring buf s 0 first;
    for i = first to len - 1 do
      match String.unsafe_get s i with
      | '&' -> Buffer.add_string buf "&amp;"
      | '<' -> Buffer.add_string buf "&lt;"
      | '>' -> Buffer.add_string buf "&gt;"
      | '\'' -> Buffer.add_string buf "&apos;"
      | '"' -> Buffer.add_string buf "&quot;"
      | c -> Buffer.add_char buf c
    done

type attribute =
  string * [ `Bool of bool | `Int of int | `Float of float | `String of string ]

let write_attribute out (attr : attribute) =
  let write_name_and_value name value =
    Buffer.add_string out name;
    Buffer.add_string out "=\"";
    escape out value;
    Buffer.add_char out '"'
  in
  match attr with
  | _name, `Bool false ->
      (* false attributes don't get rendered *)
      ()
  | name, `Bool true ->
      (* true attributes render solely the attribute name *)
      Buffer.add_char out ' ';
      Buffer.add_string out name
  | name, `String value ->
      Buffer.add_char out ' ';
      write_name_and_value name value
  | name, `Int value ->
      Buffer.add_char out ' ';
      write_name_and_value name (Int.to_string value)
  | name, `Float value ->
      Buffer.add_char out ' ';
      write_name_and_value name (Float.to_string value)

type element =
  | Null
  | String of string
  | Unsafe of string (* text without encoding *)
  | Node of {
      tag : string;
      attributes : attribute list;
      children : element list;
    }
  | List of element list

let string txt = String txt
let text = string
let unsafe txt = Unsafe txt
let null = Null
let int i = String (Int.to_string i)
let float f = String (Float.to_string f)
let list arr = List arr
let fragment arr = List arr
let node tag attributes children = Node { tag; attributes; children }

let write out element =
  let rec write element =
    match element with
    | Null -> ()
    | List list -> List.iter write list
    | Node { tag; attributes; _ } when is_self_closing_tag tag ->
        Buffer.add_char out '<';
        Buffer.add_string out tag;
        List.iter (write_attribute out) attributes;
        Buffer.add_string out " />"
    | Node { tag; attributes; children } ->
        if tag = "html" then Buffer.add_string out "<!DOCTYPE html>";
        Buffer.add_char out '<';
        Buffer.add_string out tag;
        List.iter (write_attribute out) attributes;
        Buffer.add_char out '>';
        List.iter write children;
        Buffer.add_string out "</";
        Buffer.add_string out tag;
        Buffer.add_char out '>'
    | String text -> escape out text
    | Unsafe text -> Buffer.add_string out text
  in
  write element

let render element =
  let out = Buffer.create 1024 in
  write out element;
  Buffer.contents out
