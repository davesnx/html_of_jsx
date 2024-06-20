module Attribute = struct
  (** Used internally, no need to use *)

  type t =
    | Bool of (string * bool)
    | String of (string * string)
    | Style of string
    | Event of (string * string)

  let add_t_to_string b attr =
    match attr with
    (* false attributes don't get rendered *)
    | Bool (_, false) -> ()
    (* true attributes render solely the attribute name *)
    | Bool (k, true) ->
        Buffer.add_char b ' ';
        Buffer.add_string b k
    | Style styles ->
        Buffer.add_char b ' ';
        Buffer.add_string b "style=\"";
        Buffer.add_string b styles;
        Buffer.add_char b '"'
    | Event (name, value) ->
        Buffer.add_char b ' ';
        Buffer.add_string b name;
        Buffer.add_string b "=\"";
        Buffer.add_string b value;
        Buffer.add_char b '"'
    | String (name, value) ->
        Buffer.add_char b ' ';
        Buffer.add_string b name;
        Buffer.add_string b "=\"";
        Html.escape_and_add b value;
        Buffer.add_char b '"'

  let add_string b attrs =
    match attrs with
    | [] -> ()
    | _ -> attrs |> List.rev |> List.iter (fun attr -> add_t_to_string b attr)
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
  | Component of (unit -> element)
      (* Used to lazy define elements, mostly by the ppx *) [@warning "-37"]
  | List of element list

let string txt = String txt
let text = string
let unsafe txt = Unsafe txt
let null = Null
let int i = String (Int.to_string i)
let float f = String (Float.to_string f)
let list arr = List arr
let fragment arr = Fragment arr
let node tag attributes children = Node { tag; attributes; children }

let render element =
  let buffer = Buffer.create 1024 in

  let rec render_element element =
    match element with
    | Null -> ()
    | Fragment list | List list -> List.iter render_element list
    | Component f -> render_element (f ())
    | Node { tag; attributes; _ } when Html.is_self_closing_tag tag ->
        Buffer.add_char buffer '<';
        Buffer.add_string buffer tag;
        Attribute.add_string buffer attributes;
        Buffer.add_string buffer " />"
    | Node { tag; attributes; children } ->
        if tag = "html" then Buffer.add_string buffer "<!DOCTYPE html>"
        else (
          Buffer.add_char buffer '<';
          Buffer.add_string buffer tag;
          Attribute.add_string buffer attributes;
          Buffer.add_char buffer '>';
          List.iter render_element children;
          Buffer.add_string buffer "</";
          Buffer.add_string buffer tag;
          Buffer.add_char buffer '>')
    | String text -> Html.escape_and_add buffer text
    | Unsafe text -> Buffer.add_string buffer text
  in

  render_element element;

  Buffer.contents buffer

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
