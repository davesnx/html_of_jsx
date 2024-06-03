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
  | Component of (unit -> element)
  | List of element list

let string txt = String txt
let unsafe txt = Unsafe txt
let null = Null
let int i = String (string_of_int i)
let float f = String (string_of_float f)
let list arr = List arr
let fragment arr = Fragment arr
let node tag attributes children = Node { tag; attributes; children }

(* TODO: Use buffer instead of Printf and String.concat *)
let to_string element =
  let rec render_element element =
    match element with
    | Null -> ""
    | Fragment list | List list ->
        list |> List.map render_element |> String.concat ""
    | Component f -> render_element (f ())
    | Node { tag; attributes; _ } when Html.is_self_closing_tag tag ->
        Printf.sprintf "<%s%s />" tag (Attribute.to_string attributes)
    | Node { tag; attributes; children } when tag == "html" ->
        Printf.sprintf "<!DOCTYPE html><%s%s>%s</%s>" tag
          (Attribute.to_string attributes)
          (children |> List.map render_element |> String.concat "")
          tag
    | Node { tag; attributes; children } ->
        Printf.sprintf "<%s%s>%s</%s>" tag
          (Attribute.to_string attributes)
          (children |> List.map render_element |> String.concat "")
          tag
    | String text -> Html.encode text
    | Unsafe text -> text
  in
  render_element element
