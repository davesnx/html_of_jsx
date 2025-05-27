let single_empty_tag =
  test "single_empty_tag" @@ fun () ->
  let div = JSX.node "div" [] [] in
  assert_string (JSX.render div) "<div></div>"

let empty_string_attribute =
  test "empty_string_attribute" @@ fun () ->
  let div = JSX.node "div" [ ("class", `String "") ] [] in
  assert_string (JSX.render div) "<div class=\"\"></div>"

let string_attributes =
  test "string_attributes" @@ fun () ->
  let a =
    JSX.node "a"
      [ ("href", `String "google.html"); ("target", `String "_blank") ]
      []
  in
  assert_string (JSX.render a) "<a href=\"google.html\" target=\"_blank\"></a>"

let bool_attributes =
  test "bool_attributes" @@ fun () ->
  let a =
    JSX.node "input"
      [
        ("disabled", `Bool false);
        ("checked", `Bool true);
        ("name", `String "cheese");
        ("type", `String "checkbox");
      ]
      []
  in
  assert_string (JSX.render a)
    "<input checked name=\"cheese\" type=\"checkbox\" />"

let truthy_attributes =
  test "truthy_attributes" @@ fun () ->
  let component = JSX.node "input" [ ("aria-hidden", `String "true") ] [] in
  assert_string (JSX.render component) "<input aria-hidden=\"true\" />"

let self_closing_tag =
  test "self_closing_tag" @@ fun () ->
  let input = JSX.node "input" [] [] in
  assert_string (JSX.render input) "<input />"

let dom_element_innerHtml =
  test "dom_element_innerHtml" @@ fun () ->
  let p = JSX.node "p" [] [ JSX.string "text" ] in
  assert_string (JSX.render p) "<p>text</p>"

let children =
  test "children" @@ fun () ->
  let children = JSX.node "div" [] [] in
  let div = JSX.node "div" [] [ children ] in
  assert_string (JSX.render div) "<div><div></div></div>"

let no_ignore_unkwnown_attributes_on_jsx =
  test "no_ignore_unkwnown_attributes_on_jsx" @@ fun () ->
  let div =
    JSX.node "div"
      [
        ("suppressContentEditableWarning", `Bool true);
        ("key", `String "uniqueKeyId");
      ]
      []
  in
  assert_string (JSX.render div)
    "<div suppressContentEditableWarning key=\"uniqueKeyId\"></div>"

let ignore_nulls =
  test "ignore_nulls" @@ fun () ->
  let div = JSX.node "div" [] [] in
  let span = JSX.node "span" [] [] in
  let component = JSX.node "div" [] [ div; span; JSX.null ] in
  assert_string (JSX.render component) "<div><div></div><span></span></div>"

let list_and_texts =
  test "list_and_texts" @@ fun () ->
  let component =
    JSX.node "div" [] [ JSX.list [ JSX.string "foo"; JSX.string "bar" ] ]
  in
  assert_string (JSX.render component) "<div>foobar</div>"

let list =
  test "list" @@ fun () ->
  let component =
    JSX.node "p" []
      [
        JSX.list
          [
            JSX.node "span" [] [ JSX.string "foo" ];
            JSX.node "span" [] [ JSX.string "bar" ];
          ];
      ]
  in
  assert_string (JSX.render component) "<p><span>foo</span><span>bar</span></p>"

let inline_styles =
  test "inline_styles" @@ fun () ->
  let component =
    JSX.node "button" [ ("style", `String "color: red; border: none") ] []
  in
  assert_string (JSX.render component)
    "<button style=\"color: red; border: none\"></button>"

let encode_attributes =
  test "encode_attributes" @@ fun () ->
  let component =
    JSX.node "div"
      [ ("data-user-path", `String "what/the/path"); ("about", `String "\' <") ]
      [ JSX.string "& \"" ]
  in
  assert_string (JSX.render component)
    "<div data-user-path=\"what/the/path\" about=\"&apos; &lt;\">&amp; \
     &quot;</div>"

let make ~name () =
  JSX.node "button"
    [
      ("onclick", `String "doFunction('foo');");
      ("name", `String (name : string));
    ]
    []

let event =
  test "event" @@ fun () ->
  assert_string
    (JSX.render (make ~name:"json" ()))
    "<button onclick=\"doFunction(&apos;foo&apos;);\" name=\"json\"></button>"

let className =
  test "className" @@ fun () ->
  let div = JSX.node "div" [ ("class", `String "lol") ] [] in
  assert_string (JSX.render div) "<div class=\"lol\"></div>"

let className_2 =
  test "className_2" @@ fun () ->
  let component =
    JSX.node "div"
      [ ("class", `String "flex xs:justify-center overflow-hidden") ]
      []
  in
  assert_string (JSX.render component)
    "<div class=\"flex xs:justify-center overflow-hidden\"></div>"

let render_with_doc_type =
  test "render_svg" @@ fun () ->
  let div =
    JSX.node "div" []
      [ JSX.node "span" [] [ JSX.string "This is valid HTML5" ] ]
  in
  assert_string (JSX.render div) "<div><span>This is valid HTML5</span></div>"

let jsx_unsafe =
  test "jsx_unsafe" @@ fun () ->
  let js_script =
    {| function showCopyToClipboardMessage() { var el = document.getElementById("copy_to_clipboard_message"); el.classList.remove("hidden"); setTimeout(() => { el.classList.add("hidden"); }, 3000); } |}
  in
  let app = JSX.node "script" [] [ JSX.unsafe js_script ] in
  assert_string (JSX.render app)
    "<script> function showCopyToClipboardMessage() { var el = \
     document.getElementById(\"copy_to_clipboard_message\"); \
     el.classList.remove(\"hidden\"); setTimeout(() => { \
     el.classList.add(\"hidden\"); }, 3000); } </script>"

let render_svg =
  test "render_svg" @@ fun () ->
  let path =
    JSX.node "path"
      [
        ( "d",
          `String
            "M 5 3 C 3.9069372 3 3 3.9069372 3 5 L 3 19 C 3 20.093063 \
             3.9069372 21 5 21 L 19 21 C 20.093063 21 21 20.093063 21 19 L 21 \
             12 L 19 12 L 19 19 L 5 19 L 5 5 L 12 5 L 12 3 L 5 3 z M 14 3 L 14 \
             5 L 17.585938 5 L 8.2929688 14.292969 L 9.7070312 15.707031 L 19 \
             6.4140625 L 19 10 L 21 10 L 21 3 L 14 3 z" );
      ]
      []
  in
  let svg =
    JSX.node "svg"
      [
        ("height", `String "24px");
        ("width", `String "24px");
        ("viewBox", `String "0 0 24 24");
        ("xmlns", `String "http://www.w3.org/2000/svg");
      ]
      [ path ]
  in
  assert_string (JSX.render svg)
    "<svg height=\"24px\" width=\"24px\" viewBox=\"0 0 24 24\" \
     xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M 5 3 C 3.9069372 3 3 \
     3.9069372 3 5 L 3 19 C 3 20.093063 3.9069372 21 5 21 L 19 21 C 20.093063 \
     21 21 20.093063 21 19 L 21 12 L 19 12 L 19 19 L 5 19 L 5 5 L 12 5 L 12 3 \
     L 5 3 z M 14 3 L 14 5 L 17.585938 5 L 8.2929688 14.292969 L 9.7070312 \
     15.707031 L 19 6.4140625 L 19 10 L 21 10 L 21 3 L 14 3 z\"></path></svg>"

let obj =
  object
    method make () ~children = JSX.node "div" [] [ JSX.string children ]
  end

(* The point of this test is to verify that --
 * assuming our jsx provider has properly output the object component
 * we can process it -- this avoids having to add any mlx files to our test
 * or having to extend ReasonML *)
let object_children =
  test "object_children" @@ fun () ->
  let str = (obj#make () ~children:"test" [@JSX]) in
  assert_string (JSX.render str) "<div>test</div>"

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
      list;
      list_and_texts;
      encode_attributes;
      event;
      className;
      className_2;
      render_with_doc_type;
      render_svg;
      jsx_unsafe;
      object_children;
    ] )
