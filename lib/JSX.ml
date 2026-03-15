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

let escape buf s =
  let length = String.length s in
  if length = 0 then
    ()
  else
    let exception First_char_to_escape of int in
    match
      for i = 0 to length - 1 do
        match String.unsafe_get s i with
        | '&' | '<' | '>' | '\'' | '"' ->
            raise_notrace (First_char_to_escape i)
        | _ ->
            ()
      done
    with
    | exception First_char_to_escape first ->
        if first > 0 then Buffer.add_substring buf s 0 first;
        for i = first to length - 1 do
          match String.unsafe_get s i with
          | '&' ->
              Buffer.add_string buf "&amp;"
          | '<' ->
              Buffer.add_string buf "&lt;"
          | '>' ->
              Buffer.add_string buf "&gt;"
          | '\'' ->
              Buffer.add_string buf "&apos;"
          | '"' ->
              Buffer.add_string buf "&quot;"
          | c ->
              Buffer.add_char buf c
        done
    | _ ->
        Buffer.add_string buf s

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
