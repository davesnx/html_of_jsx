let null_element =
  test "null_element" @@ fun () -> assert_string (JSX.pp JSX.null) ""

let string_element =
  test "string_element" @@ fun () ->
  assert_string (JSX.pp (JSX.string "hello")) "hello"

let int_element =
  test "int_element" @@ fun () -> assert_string (JSX.pp (JSX.int 42)) "42"

let float_element =
  test "float_element" @@ fun () ->
  assert_string (JSX.pp (JSX.float 3.14)) "3.14"

let unsafe_element =
  test "unsafe_element" @@ fun () ->
  assert_string (JSX.pp (JSX.unsafe "<b>bold</b>")) "<b>bold</b>"

let self_closing_no_attrs =
  test "self_closing_no_attrs" @@ fun () ->
  assert_string (JSX.pp (JSX.node "br" [] [])) "<br />"

let self_closing_with_attrs =
  test "self_closing_with_attrs" @@ fun () ->
  assert_string
    (JSX.pp
       (JSX.node "img"
          [ ("src", `String "logo.png"); ("alt", `String "Logo") ]
          []
       )
    )
    {|<img src="logo.png" alt="Logo" />|}

let empty_tag =
  test "empty_tag" @@ fun () ->
  assert_string (JSX.pp (JSX.node "div" [] [])) "<div></div>"

let empty_tag_with_attrs =
  test "empty_tag_with_attrs" @@ fun () ->
  assert_string
    (JSX.pp (JSX.node "div" [ ("class", `String "container") ] []))
    {|<div class="container"></div>|}

let tag_with_text =
  test "tag_with_text" @@ fun () ->
  assert_string (JSX.pp (JSX.node "p" [] [ JSX.string "hello" ])) "<p>hello</p>"

let tag_with_int_child =
  test "tag_with_int_child" @@ fun () ->
  assert_string (JSX.pp (JSX.node "span" [] [ JSX.int 42 ])) "<span>42</span>"

let tag_with_float_child =
  test "tag_with_float_child" @@ fun () ->
  assert_string
    (JSX.pp (JSX.node "span" [] [ JSX.float 3.14 ]))
    "<span>3.14</span>"

let bool_true_attr =
  test "bool_true_attr" @@ fun () ->
  assert_string
    (JSX.pp (JSX.node "input" [ ("required", `Bool true) ] []))
    "<input required />"

let bool_false_attr =
  test "bool_false_attr" @@ fun () ->
  assert_string
    (JSX.pp (JSX.node "input" [ ("disabled", `Bool false) ] []))
    "<input />"

let int_attr =
  test "int_attr" @@ fun () ->
  assert_string
    (JSX.pp (JSX.node "input" [ ("tabindex", `Int 1) ] []))
    {|<input tabindex="1" />|}

let float_attr =
  test "float_attr" @@ fun () ->
  assert_string
    (JSX.pp (JSX.node "div" [ ("data-ratio", `Float 1.5) ] []))
    {|<div data-ratio="1.5"></div>|}

let mixed_attr_types =
  test "mixed_attr_types" @@ fun () ->
  assert_string
    (JSX.pp
       (JSX.node "input"
          [
            ("type", `String "checkbox");
            ("checked", `Bool true);
            ("disabled", `Bool false);
            ("tabindex", `Int 3);
          ]
          []
       )
    )
    {|<input type="checkbox" checked tabindex="3" />|}

let multiple_text_children =
  test "multiple_text_children" @@ fun () ->
  assert_string
    (JSX.pp (JSX.node "p" [] [ JSX.string "hello "; JSX.string "world" ]))
    "<p>hello world</p>"

let mixed_inline_children =
  test "mixed_inline_children" @@ fun () ->
  assert_string
    (JSX.pp
       (JSX.node "p" []
          [
            JSX.string "count: ";
            JSX.int 42;
            JSX.string " (";
            JSX.float 3.14;
            JSX.string ")";
          ]
       )
    )
    "<p>count: 42 (3.14)</p>"

let single_node_child =
  test "single_node_child" @@ fun () ->
  assert_string
    (JSX.pp (JSX.node "div" [] [ JSX.node "p" [] [ JSX.string "hello" ] ]))
    "<div><p>hello</p></div>"

let multiple_node_children =
  test "multiple_node_children" @@ fun () ->
  assert_string
    (JSX.pp
       (JSX.node "div" []
          [
            JSX.node "p" [] [ JSX.string "one" ];
            JSX.node "p" [] [ JSX.string "two" ];
            JSX.node "p" [] [ JSX.string "three" ];
          ]
       )
    )
    "<div><p>one</p><p>two</p><p>three</p></div>"

let mixed_text_and_nodes =
  test "mixed_text_and_nodes" @@ fun () ->
  assert_string
    (JSX.pp
       (JSX.node "p" []
          [
            JSX.string "Hello ";
            JSX.node "strong" [] [ JSX.string "World" ];
            JSX.string "!";
          ]
       )
    )
    "<p>Hello <strong>World</strong>!</p>"

let fragment_children =
  test "fragment_children" @@ fun () ->
  assert_string
    (JSX.pp
       (JSX.node "div" []
          [
            JSX.list
              [
                JSX.node "span" [] [ JSX.string "a" ];
                JSX.node "span" [] [ JSX.string "b" ];
              ];
          ]
       )
    )
    "<div><span>a</span><span>b</span></div>"

let array_children =
  test "array_children" @@ fun () ->
  assert_string
    (JSX.pp
       (JSX.node "div" []
          [
            JSX.array
              [|
                JSX.node "span" [] [ JSX.string "x" ];
                JSX.node "span" [] [ JSX.string "y" ];
              |];
          ]
       )
    )
    "<div><span>x</span><span>y</span></div>"

let null_children_filtered =
  test "null_children_filtered" @@ fun () ->
  assert_string
    (JSX.pp ~width:30
       (JSX.node "div" []
          [ JSX.null; JSX.node "p" [] [ JSX.string "visible" ]; JSX.null ]
       )
    )
    "<div><p>visible</p></div>"

let empty_list_child =
  test "empty_list_child" @@ fun () ->
  assert_string (JSX.pp (JSX.node "div" [] [ JSX.list [] ])) "<div></div>"

let nested_fragments =
  test "nested_fragments" @@ fun () ->
  assert_string
    (JSX.pp
       (JSX.node "div" []
          [
            JSX.list
              [
                JSX.list
                  [
                    JSX.node "span" [] [ JSX.string "a" ];
                    JSX.node "span" [] [ JSX.string "b" ];
                  ];
                JSX.node "span" [] [ JSX.string "c" ];
              ];
          ]
       )
    )
    "<div><span>a</span><span>b</span><span>c</span></div>"

let two_levels_break =
  test "two_levels_break" @@ fun () ->
  assert_string
    (JSX.pp ~width:40
       (JSX.node "div" []
          [
            JSX.node "ul" []
              [
                JSX.node "li" [] [ JSX.string "Item 1" ];
                JSX.node "li" [] [ JSX.string "Item 2" ];
              ];
          ]
       )
    )
    {|<div>
  <ul>
    <li>Item 1</li>
    <li>Item 2</li>
  </ul>
</div>|}

let three_levels_break =
  test "three_levels_break" @@ fun () ->
  assert_string
    (JSX.pp ~width:30
       (JSX.node "div"
          [ ("class", `String "a") ]
          [
            JSX.node "section" []
              [
                JSX.node "ul" []
                  [
                    JSX.node "li" [] [ JSX.string "one" ];
                    JSX.node "li" [] [ JSX.string "two" ];
                  ];
              ];
          ]
       )
    )
    {|<div class="a">
  <section>
    <ul>
      <li>one</li>
      <li>two</li>
    </ul>
  </section>
</div>|}

let four_levels_deep =
  test "four_levels_deep" @@ fun () ->
  assert_string
    (JSX.pp ~width:40
       (JSX.node "div"
          [ ("class", `String "a") ]
          [
            JSX.node "div"
              [ ("class", `String "b") ]
              [
                JSX.node "div"
                  [ ("class", `String "c") ]
                  [
                    JSX.node "div"
                      [ ("class", `String "d") ]
                      [ JSX.node "span" [] [ JSX.string "deep" ] ];
                  ];
              ];
          ]
       )
    )
    {|<div class="a">
  <div class="b">
    <div class="c">
      <div class="d">
        <span>deep</span>
      </div>
    </div>
  </div>
</div>|}

let siblings_at_same_depth =
  test "siblings_at_same_depth" @@ fun () ->
  assert_string
    (JSX.pp ~width:40
       (JSX.node "div" []
          [
            JSX.node "header" [] [ JSX.string "H" ];
            JSX.node "main" [] [ JSX.string "M" ];
            JSX.node "footer" [] [ JSX.string "F" ];
          ]
       )
    )
    {|<div>
  <header>H</header>
  <main>M</main>
  <footer>F</footer>
</div>|}

let single_child_chain_fits =
  test "single_child_chain_fits" @@ fun () ->
  (* <a><b><c><d>x</d></c></b></a> = 30 chars, fits at width 30 *)
  assert_string
    (JSX.pp ~width:30
       (JSX.node "a" []
          [
            JSX.node "b" []
              [ JSX.node "c" [] [ JSX.node "d" [] [ JSX.string "x" ] ] ];
          ]
       )
    )
    "<a><b><c><d>x</d></c></b></a>"

let single_child_chain_breaks =
  test "single_child_chain_breaks" @@ fun () ->
  assert_string
    (JSX.pp ~width:15
       (JSX.node "a" []
          [
            JSX.node "b" []
              [ JSX.node "c" [] [ JSX.node "d" [] [ JSX.string "x" ] ] ];
          ]
       )
    )
    {|<a>
  <b>
    <c>
      <d>x</d>
    </c>
  </b>
</a>|}

let doctype_html =
  test "doctype_html" @@ fun () ->
  assert_string
    (JSX.pp ~width:40
       (JSX.node "html"
          [ ("lang", `String "en") ]
          [ JSX.node "head" [] []; JSX.node "body" [] [] ]
       )
    )
    {|<!DOCTYPE html>
<html lang="en">
  <head></head>
  <body></body>
</html>|}

let full_page =
  test "full_page" @@ fun () ->
  assert_string
    (JSX.pp ~width:40
       (JSX.node "html"
          [ ("lang", `String "en") ]
          [
            JSX.node "head" []
              [
                JSX.node "meta" [ ("charset", `String "utf-8") ] [];
                JSX.node "title" [] [ JSX.string "Test" ];
              ];
            JSX.node "body" []
              [
                JSX.node "h1" [] [ JSX.string "Hello" ];
                JSX.node "p" [] [ JSX.string "World" ];
              ];
          ]
       )
    )
    {|<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Test</title>
  </head>
  <body>
    <h1>Hello</h1>
    <p>World</p>
  </body>
</html>|}

let self_closing_tags_in_context =
  test "self_closing_tags_in_context" @@ fun () ->
  assert_string
    (JSX.pp ~width:40
       (JSX.node "form" []
          [
            JSX.node "input"
              [ ("type", `String "text"); ("name", `String "user") ]
              [];
            JSX.node "br" [] [];
            JSX.node "input" [ ("type", `String "submit") ] [];
          ]
       )
    )
    {|<form>
  <input type="text" name="user" />
  <br />
  <input type="submit" />
</form>|}

let wide_width_single_line =
  test "wide_width_single_line" @@ fun () ->
  assert_string
    (JSX.pp ~width:200
       (JSX.node "div"
          [ ("class", `String "container") ]
          [
            JSX.node "h1" [] [ JSX.string "Hello" ];
            JSX.node "p" [] [ JSX.string "World" ];
          ]
       )
    )
    {|<div class="container"><h1>Hello</h1><p>World</p></div>|}

let narrow_width_forces_break =
  test "narrow_width_forces_break" @@ fun () ->
  assert_string
    (JSX.pp ~width:30
       (JSX.node "div"
          [ ("class", `String "container") ]
          [
            JSX.node "h1" [] [ JSX.string "Hello" ];
            JSX.node "p" [] [ JSX.string "World" ];
          ]
       )
    )
    {|<div class="container">
  <h1>Hello</h1>
  <p>World</p>
</div>|}

let very_narrow_deep_break =
  test "very_narrow_deep_break" @@ fun () ->
  assert_string
    (JSX.pp ~width:20
       (JSX.node "div" []
          [
            JSX.node "ul" []
              [
                JSX.node "li" [] [ JSX.string "A" ];
                JSX.node "li" [] [ JSX.string "B" ];
              ];
          ]
       )
    )
    {|<div>
  <ul>
    <li>A</li>
    <li>B</li>
  </ul>
</div>|}

let width_boundary_fits =
  test "width_boundary_fits" @@ fun () ->
  (* <div><span>ok</span></div> = 26 chars, fits at width 26 *)
  assert_string
    (JSX.pp ~width:26
       (JSX.node "div" [] [ JSX.node "span" [] [ JSX.string "ok" ] ])
    )
    "<div><span>ok</span></div>"

let width_boundary_breaks =
  test "width_boundary_breaks" @@ fun () ->
  (* <div><span>ok</span></div> = 26 chars, overflows at width 25 *)
  assert_string
    (JSX.pp ~width:25
       (JSX.node "div" [] [ JSX.node "span" [] [ JSX.string "ok" ] ])
    )
    {|<div>
  <span>ok</span>
</div>|}

let default_width_is_80 =
  test "default_width_is_80" @@ fun () ->
  (* 79 x's + <p></p> = 86 chars. At width 80, text stays inline *)
  let text = String.make 74 'x' in
  assert_string
    (JSX.pp (JSX.node "p" [] [ JSX.string text ]))
    ("<p>" ^ text ^ "</p>")

let long_text_stays_inline =
  test "long_text_stays_inline" @@ fun () ->
  let long = String.make 120 'a' in
  assert_string
    (JSX.pp ~width:80 (JSX.node "p" [] [ JSX.string long ]))
    ("<p>" ^ long ^ "</p>")

let long_attribute_value =
  test "long_attribute_value" @@ fun () ->
  let long_class = String.make 100 'z' in
  assert_string
    (JSX.pp ~width:80 (JSX.node "div" [ ("class", `String long_class) ] []))
    ({|<div class="|} ^ long_class ^ {|"></div>|})

let many_attributes =
  test "many_attributes" @@ fun () ->
  assert_string
    (JSX.pp
       (JSX.node "input"
          [
            ("type", `String "text");
            ("name", `String "email");
            ("placeholder", `String "Enter your email address");
            ("required", `Bool true);
            ("class", `String "form-input");
          ]
          []
       )
    )
    {|<input type="text" name="email" placeholder="Enter your email address" required class="form-input" />|}

let many_children =
  test "many_children" @@ fun () ->
  let items =
    List.init 10 (fun i ->
        JSX.node "li" [] [ JSX.string (Printf.sprintf "Item %d" (i + 1)) ]
    )
  in
  assert_string
    (JSX.pp ~width:40 (JSX.node "ul" [] items))
    {|<ul>
  <li>Item 1</li>
  <li>Item 2</li>
  <li>Item 3</li>
  <li>Item 4</li>
  <li>Item 5</li>
  <li>Item 6</li>
  <li>Item 7</li>
  <li>Item 8</li>
  <li>Item 9</li>
  <li>Item 10</li>
</ul>|}

let long_tag_with_many_attrs_and_children =
  test "long_tag_with_many_attrs_and_children" @@ fun () ->
  assert_string
    (JSX.pp ~width:40
       (JSX.node "div"
          [
            ("class", `String "container mx-auto");
            ("id", `String "main");
            ("data-theme", `String "dark");
          ]
          [
            JSX.node "h1" [] [ JSX.string "Title" ];
            JSX.node "p" [] [ JSX.string "Paragraph" ];
            JSX.node "footer" [] [ JSX.string "End" ];
          ]
       )
    )
    {|<div class="container mx-auto" id="main" data-theme="dark">
  <h1>Title</h1>
  <p>Paragraph</p>
  <footer>End</footer>
</div>|}

let wide_table_row =
  test "wide_table_row" @@ fun () ->
  let cells =
    List.init 8 (fun i ->
        JSX.node "td" [] [ JSX.string (Printf.sprintf "C%d" (i + 1)) ]
    )
  in
  assert_string
    (JSX.pp ~width:40 (JSX.node "table" [] [ JSX.node "tr" [] cells ]))
    {|<table>
  <tr>
    <td>C1</td>
    <td>C2</td>
    <td>C3</td>
    <td>C4</td>
    <td>C5</td>
    <td>C6</td>
    <td>C7</td>
    <td>C8</td>
  </tr>
</table>|}

let escaping_text_content =
  test "escaping_text_content" @@ fun () ->
  assert_string
    (JSX.pp (JSX.node "p" [] [ JSX.string "1 < 2 & 3 > 0" ]))
    "<p>1 &lt; 2 &amp; 3 &gt; 0</p>"

let escaping_attribute_values =
  test "escaping_attribute_values" @@ fun () ->
  assert_string
    (JSX.pp
       (JSX.node "div" [ ("title", `String {|He said "hello" & 'bye'|}) ] [])
    )
    {|<div title="He said &quot;hello&quot; &amp; &apos;bye&apos;"></div>|}

let escaping_ampersand_sequences =
  test "escaping_ampersand_sequences" @@ fun () ->
  assert_string
    (JSX.pp
       (JSX.node "a" [ ("href", `String "?a=1&b=2") ] [ JSX.string "link" ])
    )
    {|<a href="?a=1&amp;b=2">link</a>|}

let unsafe_with_newlines =
  test "unsafe_with_newlines" @@ fun () ->
  assert_string
    (JSX.pp (JSX.node "script" [] [ JSX.unsafe "var x = 1;\nvar y = 2;" ]))
    "<script>var x = 1;\nvar y = 2;</script>"

let unsafe_multiline_style =
  test "unsafe_multiline_style" @@ fun () ->
  assert_string
    (JSX.pp
       (JSX.node "style" []
          [ JSX.unsafe "body {\n  margin: 0;\n  padding: 0;\n}" ]
       )
    )
    "<style>body {\n  margin: 0;\n  padding: 0;\n}</style>"

let deeply_nested_single_child =
  test "deeply_nested_single_child" @@ fun () ->
  let el =
    List.fold_left
      (fun child tag -> JSX.node tag [] [ child ])
      (JSX.string "leaf")
      [ "e"; "d"; "c"; "b"; "a" ]
  in
  assert_string (JSX.pp ~width:80 el) "<a><b><c><d><e>leaf</e></d></c></b></a>"

let deeply_nested_single_child_breaks =
  test "deeply_nested_single_child_breaks" @@ fun () ->
  let el =
    List.fold_left
      (fun child tag -> JSX.node tag [] [ child ])
      (JSX.string "leaf")
      [ "e"; "d"; "c"; "b"; "a" ]
  in
  assert_string (JSX.pp ~width:10 el)
    {|<a>
  <b>
    <c>
      <d>
        <e>leaf</e>
      </d>
    </c>
  </b>
</a>|}

let only_null_children =
  test "only_null_children" @@ fun () ->
  assert_string
    (JSX.pp (JSX.node "div" [] [ JSX.null; JSX.null; JSX.null ]))
    "<div></div>"

let pp_matches_render_semantics =
  test "pp_matches_render_semantics" @@ fun () ->
  (* At a sufficiently wide width, pp should produce the same output as render
     (minus the DOCTYPE handling, which render also does) *)
  let el =
    JSX.node "div"
      [ ("class", `String "test") ]
      [ JSX.node "span" [] [ JSX.string "hello" ] ]
  in
  assert_string (JSX.pp ~width:200 el) (JSX.render el)

let fragment_at_top_level =
  test "fragment_at_top_level" @@ fun () ->
  assert_string
    (JSX.pp
       (JSX.list
          [
            JSX.node "p" [] [ JSX.string "one" ];
            JSX.node "p" [] [ JSX.string "two" ];
          ]
       )
    )
    "<p>one</p><p>two</p>"

let empty_fragment =
  test "empty_fragment" @@ fun () -> assert_string (JSX.pp (JSX.list [])) ""

let empty_array =
  test "empty_array" @@ fun () -> assert_string (JSX.pp (JSX.array [||])) ""

let node_with_unsafe_child =
  test "node_with_unsafe_child" @@ fun () ->
  assert_string
    (JSX.pp (JSX.node "div" [] [ JSX.unsafe "<span>raw</span>" ]))
    "<div><span>raw</span></div>"

let complex_real_world =
  test "complex_real_world" @@ fun () ->
  assert_string
    (JSX.pp ~width:60
       (JSX.node "nav"
          [ ("class", `String "navbar") ]
          [
            JSX.node "a"
              [ ("href", `String "/"); ("class", `String "logo") ]
              [ JSX.string "Home" ];
            JSX.node "ul"
              [ ("class", `String "nav-links") ]
              [
                JSX.node "li" []
                  [
                    JSX.node "a"
                      [ ("href", `String "/about") ]
                      [ JSX.string "About" ];
                  ];
                JSX.node "li" []
                  [
                    JSX.node "a"
                      [ ("href", `String "/contact") ]
                      [ JSX.string "Contact" ];
                  ];
              ];
          ]
       )
    )
    {|<nav class="navbar">
  <a href="/" class="logo">Home</a>
  <ul class="nav-links">
    <li><a href="/about">About</a></li>
    <li><a href="/contact">Contact</a></li>
  </ul>
</nav>|}

let svg_rendering =
  test "svg_rendering" @@ fun () ->
  assert_string
    (JSX.pp ~width:60
       (JSX.node "svg"
          [
            ("width", `String "24");
            ("height", `String "24");
            ("viewBox", `String "0 0 24 24");
          ]
          [
            JSX.node "circle"
              [
                ("cx", `String "12"); ("cy", `String "12"); ("r", `String "10");
              ]
              [];
            JSX.node "path" [ ("d", `String "M12 2L22 22H2Z") ] [];
          ]
       )
    )
    {|<svg width="24" height="24" viewBox="0 0 24 24">
  <circle cx="12" cy="12" r="10"></circle>
  <path d="M12 2L22 22H2Z"></path>
</svg>|}

let tests =
  ( "pp",
    [
      null_element;
      string_element;
      int_element;
      float_element;
      unsafe_element;
      self_closing_no_attrs;
      self_closing_with_attrs;
      empty_tag;
      empty_tag_with_attrs;
      tag_with_text;
      tag_with_int_child;
      tag_with_float_child;
      bool_true_attr;
      bool_false_attr;
      int_attr;
      float_attr;
      mixed_attr_types;
      multiple_text_children;
      mixed_inline_children;
      single_node_child;
      multiple_node_children;
      mixed_text_and_nodes;
      fragment_children;
      array_children;
      null_children_filtered;
      empty_list_child;
      nested_fragments;
      two_levels_break;
      three_levels_break;
      four_levels_deep;
      siblings_at_same_depth;
      single_child_chain_fits;
      single_child_chain_breaks;
      doctype_html;
      full_page;
      self_closing_tags_in_context;
      wide_width_single_line;
      narrow_width_forces_break;
      very_narrow_deep_break;
      width_boundary_fits;
      width_boundary_breaks;
      default_width_is_80;
      long_text_stays_inline;
      long_attribute_value;
      many_attributes;
      many_children;
      long_tag_with_many_attrs_and_children;
      wide_table_row;
      escaping_text_content;
      escaping_attribute_values;
      escaping_ampersand_sequences;
      unsafe_with_newlines;
      unsafe_multiline_style;
      deeply_nested_single_child;
      deeply_nested_single_child_breaks;
      only_null_children;
      pp_matches_render_semantics;
      fragment_at_top_level;
      empty_fragment;
      empty_array;
      node_with_unsafe_child;
      complex_real_world;
      svg_rendering;
    ]
  )
