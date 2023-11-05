let render_element element =
  let rec render_element element =
    match element with
    | Jsx.Null -> ""
    | Fragment children -> render_element children
    | List list ->
        list |> Array.map render_element |> Array.to_list |> String.concat ""
    | Component f -> render_element (f ())
    | Node { tag; attributes; _ } when Html.is_self_closing_tag tag ->
        Printf.sprintf "<%s%s />" tag (Attribute.to_string attributes)
    | Node { tag; attributes; children } ->
        Printf.sprintf "<%s%s>%s</%s>" tag
          (Attribute.to_string attributes)
          (children |> List.map render_element |> String.concat "")
          tag
    | Text text -> Html.encode text
  in
  render_element element

(* TODO: Add buffer *)
let render element = Printf.sprintf "<!DOCTYPE html>%s" (render_element element)
