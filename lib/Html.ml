(* https://github.com/facebook/react/blob/97d75c9c8bcddb0daed1ed062101c7f5e9b825f4/packages/react-dom-bindings/src/shared/omittedCloseTags.js *)
let is_self_closing_tag = function
  | "area" | "base" | "br" | "col" | "embed" | "hr" | "img" | "input" | "link"
  | "meta" | "param" | "source" | "track" | "wbr" | "menuitem" ->
      true
  | _ -> false

let render_one element =
  let rec render_element element =
    match element with
    | Element.Null -> ""
    | Fragment children -> render_element children
    | List list ->
        list |> Array.map render_element |> Array.to_list |> String.concat ""
    | Component f -> render_element (f ())
    | Node { tag; attributes; _ } when is_self_closing_tag tag ->
        Printf.sprintf "<%s%s />" tag (Attribute.to_string attributes)
    | Node { tag; attributes; children } ->
        Printf.sprintf "<%s%s>%s</%s>" tag
          (Attribute.to_string attributes)
          (children |> List.map render_element |> String.concat "")
          tag
    | Text text -> Encoding.encode text
  in
  render_element element

(* TODO: Add buffer *)
(* TODO: Add html header *)
let render element = render_one element
