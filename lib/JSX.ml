module Attribute = struct
  (** Used internally, no need to use *)

  type t =
    | Bool of (string * bool)
    | String of (string * string)
    | Style of string
    | Event of (string * string)

  let t_to_string attr =
    match attr with
    (* false attributes don't get rendered *)
    | Bool (_, false) -> ""
    (* true attributes render solely the attribute name *)
    | Bool (k, true) -> k
    | Style styles -> Printf.sprintf "style=\"%s\"" styles
    | Event (name, value) -> Printf.sprintf "%s=\"%s\"" name value
    | String (k, v) -> Printf.sprintf "%s=\"%s\"" k (Html.encode v)

  let to_string attrs =
    match List.map t_to_string attrs with
    | [] -> ""
    | rest -> " " ^ (rest |> List.rev |> String.concat " " |> String.trim)
end

type node = {
  tag : string;
  attributes : Attribute.t list;
  children : element list;
}

and element =
  | Null
  | String of string
  | Unsafe of string (* text without encoding *)
  | Fragment of element list
  | Node of node
  | Component of (unit -> element) (* TODO: Is this unused? *) [@warning "-37"]
  | List of element list

let string txt = String txt
let text = string
let unsafe txt = Unsafe txt
let null = Null
let int i = String (string_of_int i)
let float f = String (string_of_float f)
let list arr = List arr
let fragment arr = Fragment arr
let node tag attributes children = Node { tag; attributes; children }

let to_string element =
  let buffer = Rope.Buffer.create 1024 in

  let rec render_element element =
    match element with
    | Null -> ()
    | Fragment list | List list -> List.iter render_element list
    | Component f -> render_element (f ())
    | Node { tag; attributes; _ } when Html.is_self_closing_tag tag ->
        Rope.Buffer.add_string buffer
          (Printf.sprintf "<%s%s />" tag (Attribute.to_string attributes))
    | Node { tag; attributes; children } when tag = "html" ->
        Rope.Buffer.add_string buffer
          (Printf.sprintf "<!DOCTYPE html><%s%s>" tag
             (Attribute.to_string attributes));

        List.iter render_element children;

        Rope.Buffer.add_string buffer (Printf.sprintf "</%s>" tag)
    | Node { tag; attributes; children } ->
        Rope.Buffer.add_string buffer
          (Printf.sprintf "<%s%s>" tag (Attribute.to_string attributes));

        List.iter render_element children;

        Rope.Buffer.add_string buffer (Printf.sprintf "</%s>" tag)
    | String text -> Rope.Buffer.add_string buffer (Html.encode text)
    | Unsafe text -> Rope.Buffer.add_string buffer text
  in

  render_element element;

  buffer |> Rope.Buffer.contents |> Rope.to_string

module Debug = struct
  type __node = {
    tag : string;
    attributes : Attribute.t list;
    children : __element list;
  }

  and __element =
    | Null
    | String of string
    | Unsafe of string
    | Fragment of __element list
    | Node of __node
    | Component of (unit -> __element)
    | List of __element list

  let view (el : element) : __element =
    let rec to_debug_element (el : element) : __element =
      match el with
      | Null -> Null
      | String str -> String str
      | Unsafe str -> Unsafe str
      | Fragment fragment -> Fragment (List.map to_debug_element fragment)
      | Node { tag; attributes; children } ->
          Node
            { tag; attributes; children = List.map to_debug_element children }
      | Component f -> Component (fun () -> to_debug_element (f ()))
      | List list -> List (List.map to_debug_element list)
    in
    to_debug_element el
end
