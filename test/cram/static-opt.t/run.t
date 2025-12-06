Test static JSX optimization
  $ ../ppx.sh --output re input.re
  let empty_div = JSX.unsafe("<div></div>");
  let div_with_class = JSX.unsafe("<div class=\"container\"></div>");
  let div_with_multiple_attrs =
    JSX.unsafe("<div id=\"main\" class=\"container\"></div>");
  let br_tag = JSX.unsafe("<br />");
  let img_tag = JSX.unsafe("<img src=\"image.png\" alt=\"An image\" />");
  let input_tag = JSX.unsafe("<input type=\"text\" name=\"field\" />");
  let nested_static = JSX.unsafe("<div><span><b>hello</b></span></div>");
  let static_with_text = JSX.unsafe("<div>hello world</div>");
  let html_page =
    JSX.unsafe(
      "<!DOCTYPE html><html lang=\"en\"><head><title>Page</title></head><body></body></html>",
    );
  let static_html =
    JSX.unsafe("<!DOCTYPE html><html><body><div>static</div></body></html>");
  let dynamic_child = name => {
    let __html_buf = Buffer.create(128);
    {
      Buffer.add_string(__html_buf, "<div>");
      Buffer.add_string(__html_buf, JSX.escape(name));
      Buffer.add_string(__html_buf, "</div>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let dynamic_two_strings = (a, b) => {
    let __html_buf = Buffer.create(256);
    {
      Buffer.add_string(__html_buf, "<div>");
      Buffer.add_string(__html_buf, JSX.escape(a));
      Buffer.add_string(__html_buf, JSX.escape(b));
      Buffer.add_string(__html_buf, "</div>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let dynamic_three_strings = (a, b, c) => {
    let __html_buf = Buffer.create(256);
    {
      Buffer.add_string(__html_buf, "<p>");
      Buffer.add_string(__html_buf, JSX.escape(a));
      Buffer.add_string(__html_buf, JSX.escape(b));
      Buffer.add_string(__html_buf, JSX.escape(c));
      Buffer.add_string(__html_buf, "</p>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let dynamic_five_strings = (a, b, c, d, e) => {
    let __html_buf = Buffer.create(512);
    {
      Buffer.add_string(__html_buf, "<span>");
      Buffer.add_string(__html_buf, JSX.escape(a));
      Buffer.add_string(__html_buf, JSX.escape(b));
      Buffer.add_string(__html_buf, JSX.escape(c));
      Buffer.add_string(__html_buf, JSX.escape(d));
      Buffer.add_string(__html_buf, JSX.escape(e));
      Buffer.add_string(__html_buf, "</span>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let dynamic_attr = className =>
    JSX.node(
      "div",
      Stdlib.List.filter_map(
        Stdlib.Fun.id,
        [Some(("class", `String(className: string)))],
      ),
      [],
    );
  let dynamic_element = child => {
    let __html_buf = Buffer.create(128);
    {
      Buffer.add_string(__html_buf, "<div>");
      JSX.write(__html_buf, child);
      Buffer.add_string(__html_buf, "</div>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let mixed_string_element = (name, child) => {
    let __html_buf = Buffer.create(256);
    {
      Buffer.add_string(__html_buf, "<div>");
      Buffer.add_string(__html_buf, JSX.escape(name));
      JSX.write(__html_buf, child);
      Buffer.add_string(__html_buf, "</div>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let multiple_static_children =
    JSX.unsafe("<ul><li>one</li><li>two</li><li>three</li></ul>");
  let disabled_button = JSX.unsafe("<button disabled></button>");
  let enabled_button = JSX.unsafe("<button></button>");
  let escaped_content =
    JSX.unsafe(
      "<div>&lt;script&gt;alert(&apos;xss&apos;)&lt;/script&gt;</div>",
    );
  let static_fragment =
    JSX.list([JSX.unsafe("<div></div>"), JSX.unsafe("<span></span>")]);
  let dynamic_int = count => {
    let __html_buf = Buffer.create(64);
    {
      Buffer.add_string(__html_buf, "<div>");
      Buffer.add_string(__html_buf, Int.to_string(count));
      Buffer.add_string(__html_buf, "</div>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let dynamic_float = price => {
    let __html_buf = Buffer.create(64);
    {
      Buffer.add_string(__html_buf, "<span>");
      Buffer.add_string(__html_buf, Float.to_string(price));
      Buffer.add_string(__html_buf, "</span>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let mixed_int_string = (count, name) => {
    let __html_buf = Buffer.create(128);
    {
      Buffer.add_string(__html_buf, "<p>");
      Buffer.add_string(__html_buf, Int.to_string(count));
      Buffer.add_string(__html_buf, JSX.escape(name));
      Buffer.add_string(__html_buf, "</p>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
