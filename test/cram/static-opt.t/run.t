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
  let static_formatted_text =
    JSX.unsafe("<div>Hello &lt;b&gt; &lt; 7 100%</div>");
  let unsupported_static_formatted_text = {
    let __html_v1 = 3.14;
    JSX.writer(
      75,
      __html_buf => {
        Buffer.add_string(__html_buf, "<div>");
        Printf.ksprintf(JSX.escape(__html_buf), "Price %f", __html_v1);
        Buffer.add_string(__html_buf, "</div>");
        ();
      },
    );
  };
  let html_page =
    JSX.unsafe(
      "<!DOCTYPE html><html lang=\"en\"><head><title>Page</title></head><body></body></html>",
    );
  let static_html =
    JSX.unsafe("<!DOCTYPE html><html><body><div>static</div></body></html>");
  let dynamic_child = name => {
    let __html_v2 = name;
    JSX.writer(
      75,
      __html_buf => {
        Buffer.add_string(__html_buf, "<div>");
        JSX.escape(__html_buf, __html_v2);
        Buffer.add_string(__html_buf, "</div>");
        ();
      },
    );
  };
  let dynamic_two_strings = (a, b) => {
    let __html_v3 = a;
    let __html_v4 = b;
    JSX.writer(
      139,
      __html_buf => {
        Buffer.add_string(__html_buf, "<div>");
        JSX.escape(__html_buf, __html_v3);
        JSX.escape(__html_buf, __html_v4);
        Buffer.add_string(__html_buf, "</div>");
        ();
      },
    );
  };
  let dynamic_three_strings = (a, b, c) => {
    let __html_v5 = a;
    let __html_v6 = b;
    let __html_v7 = c;
    JSX.writer(
      199,
      __html_buf => {
        Buffer.add_string(__html_buf, "<p>");
        JSX.escape(__html_buf, __html_v5);
        JSX.escape(__html_buf, __html_v6);
        JSX.escape(__html_buf, __html_v7);
        Buffer.add_string(__html_buf, "</p>");
        ();
      },
    );
  };
  let dynamic_five_strings = (a, b, c, d, e) => {
    let __html_v8 = a;
    let __html_v9 = b;
    let __html_v10 = c;
    let __html_v11 = d;
    let __html_v12 = e;
    JSX.writer(
      333,
      __html_buf => {
        Buffer.add_string(__html_buf, "<span>");
        JSX.escape(__html_buf, __html_v8);
        JSX.escape(__html_buf, __html_v9);
        JSX.escape(__html_buf, __html_v10);
        JSX.escape(__html_buf, __html_v11);
        JSX.escape(__html_buf, __html_v12);
        Buffer.add_string(__html_buf, "</span>");
        ();
      },
    );
  };
  let dynamic_formatted_child = (name, initial, count) => {
    let __html_v13 = name;
    let __html_v14 = initial;
    let __html_v15 = count;
    JSX.writer(
      75,
      __html_buf => {
        Buffer.add_string(__html_buf, "<div>");
        Printf.ksprintf(
          JSX.escape(__html_buf),
          "Hello %s %c %i",
          __html_v13,
          __html_v14,
          __html_v15,
        );
        Buffer.add_string(__html_buf, "</div>");
        ();
      },
    );
  };
  let dynamic_attr = className => {
    let __html_v16 = className;
    JSX.writer(
      75,
      __html_buf => {
        Buffer.add_string(__html_buf, "<div class=\"");
        JSX.escape(__html_buf, __html_v16);
        Buffer.add_string(__html_buf, "\"></div>");
        ();
      },
    );
  };
  let dynamic_attr_with_string_child = (className, name) => {
    let __html_v17 = className;
    let __html_v18 = name;
    JSX.writer(
      139,
      __html_buf => {
        Buffer.add_string(__html_buf, "<div class=\"");
        JSX.escape(__html_buf, __html_v17);
        Buffer.add_string(__html_buf, "\">");
        JSX.escape(__html_buf, __html_v18);
        Buffer.add_string(__html_buf, "</div>");
        ();
      },
    );
  };
  let dynamic_attr_with_formatted_child = (className, name, count) => {
    let __html_v19 = className;
    let __html_v20 = name;
    let __html_v21 = count;
    JSX.writer(
      139,
      __html_buf => {
        Buffer.add_string(__html_buf, "<div class=\"");
        JSX.escape(__html_buf, __html_v19);
        Buffer.add_string(__html_buf, "\">");
        Printf.ksprintf(
          JSX.escape(__html_buf),
          "Hello %s %i",
          __html_v20,
          __html_v21,
        );
        Buffer.add_string(__html_buf, "</div>");
        ();
      },
    );
  };
  let dynamic_attr_with_mixed_child = (className, child) => {
    let __html_v22 = className;
    let __html_v23 = child;
    JSX.writer(
      139,
      __html_buf => {
        Buffer.add_string(__html_buf, "<div class=\"");
        JSX.escape(__html_buf, __html_v22);
        Buffer.add_string(__html_buf, "\">");
        JSX.write(__html_buf, __html_v23);
        Buffer.add_string(__html_buf, "</div>");
        ();
      },
    );
  };
  let dynamic_bool_attr_with_child = (disabled, name) => {
    let __html_v24 = disabled;
    let __html_v25 = name;
    JSX.writer(
      145,
      __html_buf => {
        Buffer.add_string(__html_buf, "<button");
        if (__html_v24) {
          Buffer.add_string(__html_buf, " disabled");
        };
        Buffer.add_string(__html_buf, ">");
        JSX.escape(__html_buf, __html_v25);
        Buffer.add_string(__html_buf, "</button>");
        ();
      },
    );
  };
  let dynamic_int_attr_with_child = (tabindex, name) => {
    let __html_v26 = tabindex;
    let __html_v27 = name;
    JSX.writer(
      139,
      __html_buf => {
        Buffer.add_string(__html_buf, "<div tabindex=\"");
        JSX.write_int(__html_buf, __html_v26);
        Buffer.add_string(__html_buf, "\">");
        JSX.escape(__html_buf, __html_v27);
        Buffer.add_string(__html_buf, "</div>");
        ();
      },
    );
  };
  let dynamic_attr_with_int_float_children = (className, count, price) => {
    let __html_v28 = className;
    let __html_v29 = count;
    let __html_v30 = price;
    JSX.writer(
      203,
      __html_buf => {
        Buffer.add_string(__html_buf, "<div class=\"");
        JSX.escape(__html_buf, __html_v28);
        Buffer.add_string(__html_buf, "\">");
        JSX.write_int(__html_buf, __html_v29);
        Buffer.add_string(__html_buf, Float.to_string(__html_v30));
        Buffer.add_string(__html_buf, "</div>");
        ();
      },
    );
  };
  let optional_and_dynamic = (~id=?, ~cls, ()) => {
    let __html_v31 = id;
    let __html_v32 = cls;
    JSX.writer(
      139,
      __html_buf => {
        Buffer.add_string(__html_buf, "<div");
        switch (__html_v31) {
        | Some(v) =>
          Buffer.add_string(__html_buf, " id=\"");
          JSX.escape(__html_buf, v);
          Buffer.add_char(__html_buf, '"');
        | None => ()
        };
        Buffer.add_string(__html_buf, " class=\"");
        JSX.escape(__html_buf, __html_v32);
        Buffer.add_string(__html_buf, "\"></div>");
        ();
      },
    );
  };
  let dynamic_element = child => {
    let __html_v33 = child;
    JSX.writer(
      75,
      __html_buf => {
        Buffer.add_string(__html_buf, "<div>");
        JSX.write(__html_buf, __html_v33);
        Buffer.add_string(__html_buf, "</div>");
        ();
      },
    );
  };
  let mixed_string_element = (name, child) => {
    let __html_v34 = name;
    let __html_v35 = child;
    JSX.writer(
      139,
      __html_buf => {
        Buffer.add_string(__html_buf, "<div>");
        JSX.escape(__html_buf, __html_v34);
        JSX.write(__html_buf, __html_v35);
        Buffer.add_string(__html_buf, "</div>");
        ();
      },
    );
  };
  let multiple_static_children =
    JSX.unsafe("<ul><li>one</li><li>two</li><li>three</li></ul>");
  let disabled_button = JSX.unsafe("<button disabled></button>");
  let enabled_button = JSX.unsafe("<button></button>");
  let escaped_content =
    JSX.unsafe(
      "<div>&lt;script&gt;alert(&apos;xss&apos;)&lt;/script&gt;</div>",
    );
  let static_fragment = JSX.unsafe("<div></div><span></span>");
  let dynamic_int = count => {
    let __html_v36 = count;
    JSX.writer(
      75,
      __html_buf => {
        Buffer.add_string(__html_buf, "<div>");
        JSX.write_int(__html_buf, __html_v36);
        Buffer.add_string(__html_buf, "</div>");
        ();
      },
    );
  };
  let dynamic_float = price => {
    let __html_v37 = price;
    JSX.writer(
      77,
      __html_buf => {
        Buffer.add_string(__html_buf, "<span>");
        Buffer.add_string(__html_buf, Float.to_string(__html_v37));
        Buffer.add_string(__html_buf, "</span>");
        ();
      },
    );
  };
  let mixed_int_string = (count, name) => {
    let __html_v38 = count;
    let __html_v39 = name;
    JSX.writer(
      135,
      __html_buf => {
        Buffer.add_string(__html_buf, "<p>");
        JSX.write_int(__html_buf, __html_v38);
        JSX.escape(__html_buf, __html_v39);
        Buffer.add_string(__html_buf, "</p>");
        ();
      },
    );
  };
