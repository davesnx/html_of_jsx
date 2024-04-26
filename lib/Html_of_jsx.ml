(* TODO: Use buffer instead of Printf and String.concat *)
let render element =
  let rec render_element element =
    let open Jsx in
    match element with
    | Null -> ""
    | Fragment list | List list ->
        list |> List.map render_element |> String.concat ""
    | Component f -> render_element (f ())
    | Node { tag; attributes; _ } when Html.is_self_closing_tag tag ->
        Printf.sprintf "<%s%s />" tag (Jsx.Attribute.to_string attributes)
    | Node { tag; attributes; children } when tag == "html" ->
        Printf.sprintf "<!DOCTYPE html><%s%s>%s</%s>" tag
          (Jsx.Attribute.to_string attributes)
          (children |> List.map render_element |> String.concat "")
          tag
    | Node { tag; attributes; children } ->
        Printf.sprintf "<%s%s>%s</%s>" tag
          (Jsx.Attribute.to_string attributes)
          (children |> List.map render_element |> String.concat "")
          tag
    | Text text -> Html.encode text
    | Unsafe text -> text
  in
  render_element element
