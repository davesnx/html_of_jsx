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
  | Unsafe of string
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

module Debug = struct
  type nonrec element = element =
    | Null
    | String of string
    | Unsafe of string
    | Node of {
        tag : string;
        attributes : attribute list;
        children : element list;
      }
    | List of element list

  let view element = element
end
