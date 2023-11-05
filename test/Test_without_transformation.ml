let assert_string left right =
  Alcotest.check Alcotest.string "should be equal" right left

let case title fn = Alcotest.test_case title `Quick fn

let single_empty_tag =
  case "single_empty_tag" @@ fun () ->
  let div = Jsx.node "div" [] [] in
  assert_string (Html_of_jsx.render_element div) "<div></div>"

let empty_string_attribute =
  case "empty_string_attribute" @@ fun () ->
  let div = Jsx.node "div" [ Attribute.String ("class", "") ] [] in
  assert_string (Html_of_jsx.render_element div) "<div class=\"\"></div>"

let string_attributes =
  case "string_attributes" @@ fun () ->
  let a =
    Jsx.node "a"
      [
        Attribute.String ("href", "google.html");
        Attribute.String ("target", "_blank");
      ]
      []
  in
  assert_string
    (Html_of_jsx.render_element a)
    "<a href=\"google.html\" target=\"_blank\"></a>"

let bool_attributes =
  case "bool_attributes" @@ fun () ->
  let a =
    Jsx.node "input"
      [
        Attribute.String ("type", "checkbox");
        Attribute.String ("name", "cheese");
        Attribute.Bool ("checked", true);
        Attribute.Bool ("disabled", false);
      ]
      []
  in
  assert_string
    (Html_of_jsx.render_element a)
    "<input type=\"checkbox\" name=\"cheese\" checked />"

let truthy_attributes =
  case "truthy_attributes" @@ fun () ->
  let component =
    Jsx.node "input" [ Attribute.String ("aria-hidden", "true") ] []
  in
  assert_string
    (Html_of_jsx.render_element component)
    "<input aria-hidden=\"true\" />"

let self_closing_tag =
  case "self_closing_tag" @@ fun () ->
  let input = Jsx.node "input" [] [] in
  assert_string (Html_of_jsx.render_element input) "<input />"

let dom_element_innerHtml =
  case "dom_element_innerHtml" @@ fun () ->
  let p = Jsx.node "p" [] [ Jsx.text "text" ] in
  assert_string (Html_of_jsx.render_element p) "<p>text</p>"

let children =
  case "children" @@ fun () ->
  let children = Jsx.node "div" [] [] in
  let div = Jsx.node "div" [] [ children ] in
  assert_string (Html_of_jsx.render_element div) "<div><div></div></div>"

let no_ignore_unkwnown_attributes_on_jsx =
  case "no_ignore_unkwnown_attributes_on_jsx" @@ fun () ->
  let div =
    Jsx.node "div"
      [
        Attribute.String ("key", "uniqueKeyId");
        Attribute.Bool ("suppressContentEditableWarning", true);
      ]
      []
  in
  assert_string
    (Html_of_jsx.render_element div)
    "<div key=\"uniqueKeyId\" suppressContentEditableWarning></div>"

(* TODO: Fragments aren't supported yet *)
(* let fragment () =
   let div = Jsx.node "div" [] [] in
   let component = React.fragment ~children:(React.list [ div; div ]) () in
   assert_string (Html_of_jsx.render_element component) "<div></div><div></div>" *)

let ignore_nulls =
  case "ignore_nulls" @@ fun () ->
  let div = Jsx.node "div" [] [] in
  let span = Jsx.node "span" [] [] in
  let component = Jsx.node "div" [] [ div; span; Jsx.null ] in
  assert_string
    (Html_of_jsx.render_element component)
    "<div><div></div><span></span></div>"

(* let fragments_and_texts () =
   let component =
     Jsx.node "div" []
       [
         React.fragment ~children:(React.list [ Jsx.text "foo" ]) ();
         Jsx.text "bar";
         Jsx.node "b" [] [];
       ]
   in
   assert_string (Html_of_jsx.render_element component) "<div>foobar<b></b></div>" *)

let inline_styles =
  case "inline_styles" @@ fun () ->
  let component =
    Jsx.node "button" [ Attribute.Style "color: red; border: none" ] []
  in
  assert_string
    (Html_of_jsx.render_element component)
    "<button style=\"color: red; border: none\"></button>"

let encode_attributes =
  case "encode_attributes" @@ fun () ->
  let component =
    Jsx.node "div"
      [
        Attribute.String ("about", "\' <");
        Attribute.String ("data-user-path", "what/the/path");
      ]
      [ Jsx.text "& \"" ]
  in
  assert_string
    (Html_of_jsx.render_element component)
    "<div about=\"&#x27; &lt;\" data-user-path=\"what/the/path\">&amp; \
     &quot;</div>"

let make ~name () =
  Jsx.node "button"
    [
      Attribute.String ("name", (name : string));
      Attribute.Event ("onclick", "doFunction('foo');");
    ]
    []

let event =
  case "event" @@ fun () ->
  assert_string
    (Html_of_jsx.render_element (make ~name:"json" ()))
    "<button name=\"json\" onclick=\"doFunction('foo');\"></button>"

let className =
  case "className" @@ fun () ->
  let div = Jsx.node "div" [ Attribute.String ("class", "lol") ] [] in
  assert_string (Html_of_jsx.render_element div) "<div class=\"lol\"></div>"

let className_2 =
  case "className_2" @@ fun () ->
  let component =
    Jsx.node "div"
      [ Attribute.String ("class", "flex xs:justify-center overflow-hidden") ]
      []
  in
  assert_string
    (Html_of_jsx.render_element component)
    "<div class=\"flex xs:justify-center overflow-hidden\"></div>"

let render_with_doc_type =
  case "render_svg" @@ fun () ->
  let div =
    Jsx.node "div" [] [ Jsx.node "span" [] [ Jsx.text "This is valid HTML5" ] ]
  in
  assert_string
    (Html_of_jsx.render_element div)
    "<div><span>This is valid HTML5</span></div>"

let render_svg =
  case "render_svg" @@ fun () ->
  let path =
    Jsx.node "path"
      [
        Attribute.String
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
        Attribute.String ("xmlns", "http://www.w3.org/2000/svg");
        Attribute.String ("viewBox", "0 0 24 24");
        Attribute.String ("width", "24px");
        Attribute.String ("height", "24px");
      ]
      [ path ]
  in
  assert_string
    (Html_of_jsx.render_element svg)
    "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" \
     width=\"24px\" height=\"24px\"><path d=\"M 5 3 C 3.9069372 3 3 3.9069372 \
     3 5 L 3 19 C 3 20.093063 3.9069372 21 5 21 L 19 21 C 20.093063 21 21 \
     20.093063 21 19 L 21 12 L 19 12 L 19 19 L 5 19 L 5 5 L 12 5 L 12 3 L 5 3 \
     z M 14 3 L 14 5 L 17.585938 5 L 8.2929688 14.292969 L 9.7070312 15.707031 \
     L 19 6.4140625 L 19 10 L 21 10 L 21 3 L 14 3 z\"></path></svg>"

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
    ] )
