let single_empty_tag =
  case "single_empty_tag" @@ fun () ->
  let div = Jsx.node "div" [] [] in
  assert_string (Jsx.to_string div) "<div></div>"

let empty_string_attribute =
  case "empty_string_attribute" @@ fun () ->
  let div = Jsx.node "div" [ Jsx.Attribute.String ("class", "") ] [] in
  assert_string (Jsx.to_string div) "<div class=\"\"></div>"

let string_attributes =
  case "string_attributes" @@ fun () ->
  let a =
    Jsx.node "a"
      [
        Jsx.Attribute.String ("target", "_blank");
        Jsx.Attribute.String ("href", "google.html");
      ]
      []
  in
  assert_string (Jsx.to_string a)
    "<a href=\"google.html\" target=\"_blank\"></a>"

let bool_attributes =
  case "bool_attributes" @@ fun () ->
  let a =
    Jsx.node "input"
      [
        Jsx.Attribute.String ("type", "checkbox");
        Jsx.Attribute.String ("name", "cheese");
        Jsx.Attribute.Bool ("checked", true);
        Jsx.Attribute.Bool ("disabled", false);
      ]
      []
  in
  assert_string (Jsx.to_string a)
    "<input checked name=\"cheese\" type=\"checkbox\" />"

let truthy_attributes =
  case "truthy_attributes" @@ fun () ->
  let component =
    Jsx.node "input" [ Jsx.Attribute.String ("aria-hidden", "true") ] []
  in
  assert_string (Jsx.to_string component) "<input aria-hidden=\"true\" />"

let self_closing_tag =
  case "self_closing_tag" @@ fun () ->
  let input = Jsx.node "input" [] [] in
  assert_string (Jsx.to_string input) "<input />"

let dom_element_innerHtml =
  case "dom_element_innerHtml" @@ fun () ->
  let p = Jsx.node "p" [] [ Jsx.string "text" ] in
  assert_string (Jsx.to_string p) "<p>text</p>"

let children =
  case "children" @@ fun () ->
  let children = Jsx.node "div" [] [] in
  let div = Jsx.node "div" [] [ children ] in
  assert_string (Jsx.to_string div) "<div><div></div></div>"

let no_ignore_unkwnown_attributes_on_jsx =
  case "no_ignore_unkwnown_attributes_on_jsx" @@ fun () ->
  let div =
    Jsx.node "div"
      [
        Jsx.Attribute.String ("key", "uniqueKeyId");
        Jsx.Attribute.Bool ("suppressContentEditableWarning", true);
      ]
      []
  in
  assert_string (Jsx.to_string div)
    "<div suppressContentEditableWarning key=\"uniqueKeyId\"></div>"

(* TODO: Fragments aren't supported yet *)
(* let fragment () =
   let div = Jsx.node "div" [] [] in
   let component = React.fragment ~children:(React.list [ div; div ]) () in
   assert_string (Jsx.to_string component) "<div></div><div></div>" *)

let ignore_nulls =
  case "ignore_nulls" @@ fun () ->
  let div = Jsx.node "div" [] [] in
  let span = Jsx.node "span" [] [] in
  let component = Jsx.node "div" [] [ div; span; Jsx.null ] in
  assert_string (Jsx.to_string component) "<div><div></div><span></span></div>"

(* let fragments_and_texts () =
   let component =
     Jsx.node "div" []
       [
         React.fragment ~children:(React.list [ Jsx.string "foo" ]) ();
         Jsx.string "bar";
         Jsx.node "b" [] [];
       ]
   in
   assert_string (Jsx.to_string component) "<div>foobar<b></b></div>" *)

let inline_styles =
  case "inline_styles" @@ fun () ->
  let component =
    Jsx.node "button" [ Jsx.Attribute.Style "color: red; border: none" ] []
  in
  assert_string (Jsx.to_string component)
    "<button style=\"color: red; border: none\"></button>"

let encode_attributes =
  case "encode_attributes" @@ fun () ->
  let component =
    Jsx.node "div"
      [
        Jsx.Attribute.String ("about", "\' <");
        Jsx.Attribute.String ("data-user-path", "what/the/path");
      ]
      [ Jsx.string "& \"" ]
  in
  assert_string (Jsx.to_string component)
    "<div data-user-path=\"what/the/path\" about=\"&#x27; &lt;\">&amp; \
     &quot;</div>"

let make ~name () =
  Jsx.node "button"
    [
      Jsx.Attribute.String ("name", (name : string));
      Jsx.Attribute.Event ("onclick", "doFunction('foo');");
    ]
    []

let event =
  case "event" @@ fun () ->
  assert_string
    (Jsx.to_string (make ~name:"json" ()))
    "<button onclick=\"doFunction('foo');\" name=\"json\"></button>"

let className =
  case "className" @@ fun () ->
  let div = Jsx.node "div" [ Jsx.Attribute.String ("class", "lol") ] [] in
  assert_string (Jsx.to_string div) "<div class=\"lol\"></div>"

let className_2 =
  case "className_2" @@ fun () ->
  let component =
    Jsx.node "div"
      [
        Jsx.Attribute.String ("class", "flex xs:justify-center overflow-hidden");
      ]
      []
  in
  assert_string (Jsx.to_string component)
    "<div class=\"flex xs:justify-center overflow-hidden\"></div>"

let render_with_doc_type =
  case "render_svg" @@ fun () ->
  let div =
    Jsx.node "div" []
      [ Jsx.node "span" [] [ Jsx.string "This is valid HTML5" ] ]
  in
  assert_string (Jsx.to_string div)
    "<div><span>This is valid HTML5</span></div>"

let jsx_unsafe =
  case "jsx_unsafe" @@ fun () ->
  let js_script =
    {| function showCopyToClipboardMessage() { var el = document.getElementById("copy_to_clipboard_message"); el.classList.remove("hidden"); setTimeout(() => { el.classList.add("hidden"); }, 3000); } |}
  in
  let app = Jsx.node "script" [] [ Jsx.unsafe js_script ] in
  assert_string (Jsx.to_string app)
    "<script> function showCopyToClipboardMessage() { var el = \
     document.getElementById(\"copy_to_clipboard_message\"); \
     el.classList.remove(\"hidden\"); setTimeout(() => { \
     el.classList.add(\"hidden\"); }, 3000); } </script>"

let render_svg =
  case "render_svg" @@ fun () ->
  let path =
    Jsx.node "path"
      [
        Jsx.Attribute.String
          ( "d",
            "M 5 3 C 3.9069372 3 3 3.9069372 3 5 L 3 19 C 3 20.093063 \
             3.9069372 21 5 21 L 19 21 C 20.093063 21 21 20.093063 21 19 L 21 \
             12 L 19 12 L 19 19 L 5 19 L 5 5 L 12 5 L 12 3 L 5 3 z M 14 3 L 14 \
             5 L 17.585938 5 L 8.2929688 14.292969 L 9.7070312 15.707031 L 19 \
             6.4140625 L 19 10 L 21 10 L 21 3 L 14 3 z" );
      ]
      []
  in
  let svg =
    Jsx.node "svg"
      [
        Jsx.Attribute.String ("xmlns", "http://www.w3.org/2000/svg");
        Jsx.Attribute.String ("viewBox", "0 0 24 24");
        Jsx.Attribute.String ("width", "24px");
        Jsx.Attribute.String ("height", "24px");
      ]
      [ path ]
  in
  assert_string (Jsx.to_string svg)
    "<svg height=\"24px\" width=\"24px\" viewBox=\"0 0 24 24\" \
     xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M 5 3 C 3.9069372 3 3 \
     3.9069372 3 5 L 3 19 C 3 20.093063 3.9069372 21 5 21 L 19 21 C 20.093063 \
     21 21 20.093063 21 19 L 21 12 L 19 12 L 19 19 L 5 19 L 5 5 L 12 5 L 12 3 \
     L 5 3 z M 14 3 L 14 5 L 17.585938 5 L 8.2929688 14.292969 L 9.7070312 \
     15.707031 L 19 6.4140625 L 19 10 L 21 10 L 21 3 L 14 3 z\"></path></svg>"

let tests =
  ( "render",
    [
      single_empty_tag;
      empty_string_attribute;
      string_attributes;
      bool_attributes;
      truthy_attributes;
      self_closing_tag;
      dom_element_innerHtml;
      children;
      no_ignore_unkwnown_attributes_on_jsx;
      ignore_nulls;
      inline_styles;
      encode_attributes;
      event;
      className;
      className_2;
      render_with_doc_type;
      render_svg;
      jsx_unsafe;
    ] )
