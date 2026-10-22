  $ ../ppx.sh --output re input.re
  let lower = JSX.unsafe("<div></div>");
  let lower_empty_attr = JSX.unsafe("<div class=\"\"></div>");
  let lower_inline_styles = {
    let __html_v1 = Style.make(~backgroundColor="gainsboro", ());
    JSX.writer(
      75,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<div style=\"");
        JSX.escape(__html_buf, __html_v1);
        Stdlib.Buffer.add_string(__html_buf, "\"></div>");
        ();
      },
    );
  };
  let lower_opt_attr = {
    let __html_v2 = tabindex;
    JSX.writer(
      75,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<div");
        switch (__html_v2) {
        | Some(v) =>
          Stdlib.Buffer.add_string(__html_buf, " tabindex=\"");
          JSX.write_int(__html_buf, v);
          Stdlib.Buffer.add_char(__html_buf, '"');
        | None => ()
        };
        Stdlib.Buffer.add_string(__html_buf, "></div>");
        ();
      },
    );
  };
  let lowerWithChildAndProps = foo => {
    let __html_v3 = foo;
    JSX.writer(
      111,
      __html_buf => {
        Stdlib.Buffer.add_string(
          __html_buf,
          "<a tabindex=\"1\" href=\"https://example.com\">",
        );
        JSX.write(__html_buf, __html_v3);
        Stdlib.Buffer.add_string(__html_buf, "</a>");
        ();
      },
    );
  };
  let lower_child_static = JSX.unsafe("<div><span></span></div>");
  let lower_child_ident = {
    let __html_v4 = lolaspa;
    JSX.writer(
      75,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<div>");
        JSX.write(__html_buf, __html_v4);
        Stdlib.Buffer.add_string(__html_buf, "</div>");
        ();
      },
    );
  };
  let lower_child_single = JSX.unsafe("<div><div></div></div>");
  let lower_children_multiple = (foo, bar) =>
    lower(~children=JSX.list([foo, bar]), ());
  let lower_child_with_upper_as_children = {
    let __html_v5 = App.make();
    JSX.writer(
      75,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<div>");
        JSX.write(__html_buf, __html_v5);
        Stdlib.Buffer.add_string(__html_buf, "</div>");
        ();
      },
    );
  };
  let lower_children_nested = {
    let __html_v6 = "jsoo-react" |> s;
    let __html_v10 =
      examples
      |> List.map(e => {
           let __html_v7 = e.path;
           let __html_v9 = e.title |> s;
           JSX.writer(
             166,
             __html_buf => {
               Stdlib.Buffer.add_string(__html_buf, "<li>");
               {
                 Stdlib.Buffer.add_string(__html_buf, "<a href=\"");
                 JSX.escape(__html_buf, __html_v7);
                 Stdlib.Buffer.add_string(
                   __html_buf,
                   "\" onclick=\"console.log\">",
                 );
                 JSX.write(__html_buf, __html_v9);
                 Stdlib.Buffer.add_string(__html_buf, "</a>");
                 ();
               };
               Stdlib.Buffer.add_string(__html_buf, "</li>");
               ();
             },
           );
         })
      |> React.list;
    JSX.writer(
      245,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<div class=\"flex-container\">");
        {
          Stdlib.Buffer.add_string(__html_buf, "<div class=\"sidebar\">");
          {
            Stdlib.Buffer.add_string(__html_buf, "<h2 class=\"title\">");
            JSX.write(__html_buf, __html_v6);
            Stdlib.Buffer.add_string(__html_buf, "</h2>");
            ();
          };
          {
            Stdlib.Buffer.add_string(__html_buf, "<nav class=\"menu\">");
            {
              Stdlib.Buffer.add_string(__html_buf, "<ul>");
              JSX.write(__html_buf, __html_v10);
              Stdlib.Buffer.add_string(__html_buf, "</ul>");
              ();
            };
            Stdlib.Buffer.add_string(__html_buf, "</nav>");
            ();
          };
          Stdlib.Buffer.add_string(__html_buf, "</div>");
          ();
        };
        Stdlib.Buffer.add_string(__html_buf, "</div>");
        ();
      },
    );
  };
  let lower_ref_with_children = {
    let __html_v11 = children;
    JSX.writer(
      101,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<button class=\"FancyButton\">");
        JSX.write(__html_buf, __html_v11);
        Stdlib.Buffer.add_string(__html_buf, "</button>");
        ();
      },
    );
  };
  let lower_with_many_props =
    JSX.unsafe(
      "<div translate=\"yes\"><picture id=\"idpicture\"><img src=\"picture/img.png\" alt=\"test picture/img.png\" id=\"idimg\" /><source type=\"image/webp\" src=\"picture/img1.webp\" /><source type=\"image/jpeg\" src=\"picture/img2.jpg\" /></picture></div>",
    );
  let some_random_html_element =
    JSX.unsafe("<text dx=\"1 2\" dy=\"3 4\"></text>");
  let lower_case_component = lola(~id="33", ());
  let lower_case_component_being_html = JSX.unsafe("<div id=\"33\"></div>");
