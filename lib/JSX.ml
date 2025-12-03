module Html = struct
  (* https://github.com/facebook/react/blob/97d75c9c8bcddb0daed1ed062101c7f5e9b825f4/packages/react-dom-bindings/src/shared/omittedCloseTags.js *)
  let is_self_closing_tag = function
    | "area" | "base" | "br" | "col" | "embed" | "hr" | "img" | "input" | "link"
    | "meta" | "param" | "source" | "track" | "wbr" | "menuitem" ->
        true
    | _ -> false

  (* This function is borrowed from https://github.com/dbuenzli/htmlit/blob/62d8f21a9233791a5440311beac02a4627c3a7eb/src/htmlit.ml#L10-L28 *)
  let escape_and_add b s =
    let adds = Buffer.add_string in
    let len = String.length s in
    let max_idx = len - 1 in
    let flush b start i =
      if start < len then Buffer.add_substring b s start (i - start)
    in
    let rec loop start i =
      if i > max_idx then flush b start i
      else
        let next = i + 1 in
        match String.get s i with
        | '&' ->
            flush b start i;
            adds b "&amp;";
            loop next next
        | '<' ->
            flush b start i;
            adds b "&lt;";
            loop next next
        | '>' ->
            flush b start i;
            adds b "&gt;";
            loop next next
        | '\'' ->
            flush b start i;
            adds b "&apos;";
            loop next next
        | '\"' ->
            flush b start i;
            adds b "&quot;";
            loop next next
        | _ -> loop start next
    in
    loop 0 0
end

type attribute =
  string * [ `Bool of bool | `Int of int | `Float of float | `String of string ]

let write_attribute out (attr : attribute) =
  let write_name_value name value =
    Buffer.add_char out ' ';
    Buffer.add_string out name;
    Buffer.add_string out "=\"";
    Html.escape_and_add out value;
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
  | name, `String value -> write_name_value name value
  | name, `Int value -> write_name_value name (Int.to_string value)
  | name, `Float value -> write_name_value name (Float.to_string value)

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

let escape s =
  let needs_escape = ref false in
  let len = String.length s in
  for i = 0 to len - 1 do
    match String.unsafe_get s i with
    | '&' | '<' | '>' | '\'' | '"' -> needs_escape := true
    | _ -> ()
  done;
  if not !needs_escape then s
  else begin
    let buf = Buffer.create (len * 2) in
    Html.escape_and_add buf s;
    Buffer.contents buf
  end

let write out element =
  let rec write element =
    match element with
    | Null -> ()
    | List list -> List.iter write list
    | Node { tag; attributes; _ } when Html.is_self_closing_tag tag ->
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
    | String text -> Html.escape_and_add out text
    | Unsafe text -> Buffer.add_string out text
  in
  write element

let render element =
  let out = Buffer.create 1024 in
  write out element;
  Buffer.contents out
