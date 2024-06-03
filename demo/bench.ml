open JSX

let original_to_string element =
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

let to_string_with_buffer element =
  let buffer = Buffer.create 1024 in

  let rec render_element element =
    match element with
    | Null -> ()
    | Fragment list | List list -> List.iter render_element list
    | Component f -> render_element (f ())
    | Node { tag; attributes; _ } when Html.is_self_closing_tag tag ->
        Buffer.add_string buffer
          (Printf.sprintf "<%s%s />" tag (Attribute.to_string attributes))
    | Node { tag; attributes; children } when tag = "html" ->
        Buffer.add_string buffer
          (Printf.sprintf "<!DOCTYPE html><%s%s>" tag
             (Attribute.to_string attributes));
        List.iter render_element children;
        Buffer.add_string buffer (Printf.sprintf "</%s>" tag)
    | Node { tag; attributes; children } ->
        Buffer.add_string buffer
          (Printf.sprintf "<%s%s>" tag (Attribute.to_string attributes));
        List.iter render_element children;
        Buffer.add_string buffer (Printf.sprintf "</%s>" tag)
    | String text -> Buffer.add_string buffer (Html.encode text)
    | Unsafe text -> Buffer.add_string buffer text
  in

  render_element element;
  Buffer.contents buffer

let start () =
  let open Benchmark in
  let html =
    HTMLMock.Page.make ~project_url:"https://github.com/davesnx/html_of_jsx" ()
  in

  let res =
    throughputN ~repeat:3 8
      [
        ("original_to_string", original_to_string, html);
        ("to_string_with_buffer", to_string_with_buffer, html);
      ]
  in
  print_newline ();
  tabulate res
