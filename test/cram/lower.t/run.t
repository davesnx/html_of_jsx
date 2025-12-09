  $ ../ppx.sh --output re input.re
  let lower = JSX.unsafe("<div></div>");
  let lower_empty_attr = JSX.unsafe("<div class=\"\"></div>");
  let lower_inline_styles =
    JSX.node(
      "div",
      Stdlib.List.filter_map(
        Stdlib.Fun.id,
        [
          Some((
            "style",
            `String(Style.make(~backgroundColor="gainsboro", ()): string),
          )),
        ],
      ),
      [],
    );
  let lower_opt_attr = {
    let __html_buf = Buffer.create(64);
    ();
    {
      Buffer.add_string(__html_buf, "<div");
      switch (tabindex) {
      | Some(__v) =>
        Buffer.add_string(__html_buf, " tabindex=\"");
        Buffer.add_string(__html_buf, Int.to_string(__v));
        Buffer.add_char(__html_buf, '"');
      | None => ()
      };
      Buffer.add_string(__html_buf, ">");
      ();
      Buffer.add_string(__html_buf, "</div>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let lowerWithChildAndProps = foo => {
    let __html_buf = Buffer.create(128);
    {
      Buffer.add_string(
        __html_buf,
        "<a tabindex=\"1\" href=\"https://example.com\">",
      );
      JSX.write(__html_buf, foo);
      Buffer.add_string(__html_buf, "</a>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let lower_child_static = JSX.unsafe("<div><span></span></div>");
  let lower_child_ident = {
    let __html_buf = Buffer.create(128);
    {
      Buffer.add_string(__html_buf, "<div>");
      JSX.write(__html_buf, lolaspa);
      Buffer.add_string(__html_buf, "</div>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let lower_child_single = JSX.unsafe("<div><div></div></div>");
  let lower_children_multiple = (foo, bar) => lower(~children=[foo, bar], ());
  let lower_child_with_upper_as_children = {
    let __html_buf = Buffer.create(128);
    {
      Buffer.add_string(__html_buf, "<div>");
      JSX.write(__html_buf, App.make());
      Buffer.add_string(__html_buf, "</div>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let lower_children_nested = {
    let __html_buf = Buffer.create(128);
    {
      Buffer.add_string(__html_buf, "<div class=\"flex-container\">");
      JSX.write(
        __html_buf,
        {
          let __html_buf = Buffer.create(256);
          {
            Buffer.add_string(__html_buf, "<div class=\"sidebar\">");
            JSX.write(
              __html_buf,
              {
                let __html_buf = Buffer.create(128);
                {
                  Buffer.add_string(__html_buf, "<h2 class=\"title\">");
                  JSX.write(__html_buf, "jsoo-react" |> s);
                  Buffer.add_string(__html_buf, "</h2>");
                  ();
                };
                JSX.unsafe(Buffer.contents(__html_buf));
              },
            );
            JSX.write(
              __html_buf,
              {
                let __html_buf = Buffer.create(128);
                {
                  Buffer.add_string(__html_buf, "<nav class=\"menu\">");
                  JSX.write(
                    __html_buf,
                    {
                      let __html_buf = Buffer.create(128);
                      {
                        Buffer.add_string(__html_buf, "<ul>");
                        JSX.write(
                          __html_buf,
                          examples
                          |> List.map(e => {
                               let __html_buf = Buffer.create(128);
                               {
                                 Buffer.add_string(__html_buf, "<li>");
                                 JSX.write(
                                   __html_buf,
                                   JSX.node(
                                     "a",
                                     Stdlib.List.filter_map(
                                       Stdlib.Fun.id,
                                       [
                                         Some((
                                           "href",
                                           `String(e.path: string),
                                         )),
                                         Some((
                                           "onclick",
                                           `String("console.log": string),
                                         )),
                                       ],
                                     ),
                                     [e.title |> s],
                                   ),
                                 );
                                 Buffer.add_string(__html_buf, "</li>");
                                 ();
                               };
                               JSX.unsafe(Buffer.contents(__html_buf));
                             })
                          |> React.list,
                        );
                        Buffer.add_string(__html_buf, "</ul>");
                        ();
                      };
                      JSX.unsafe(Buffer.contents(__html_buf));
                    },
                  );
                  Buffer.add_string(__html_buf, "</nav>");
                  ();
                };
                JSX.unsafe(Buffer.contents(__html_buf));
              },
            );
            Buffer.add_string(__html_buf, "</div>");
            ();
          };
          JSX.unsafe(Buffer.contents(__html_buf));
        },
      );
      Buffer.add_string(__html_buf, "</div>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let lower_ref_with_children = {
    let __html_buf = Buffer.create(128);
    {
      Buffer.add_string(__html_buf, "<button class=\"FancyButton\">");
      JSX.write(__html_buf, children);
      Buffer.add_string(__html_buf, "</button>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let lower_with_many_props =
    JSX.unsafe(
      "<div translate=\"yes\"><picture id=\"idpicture\"><img src=\"picture/img.png\" alt=\"test picture/img.png\" id=\"idimg\" /><source type=\"image/webp\" src=\"picture/img1.webp\" /><source type=\"image/jpeg\" src=\"picture/img2.jpg\" /></picture></div>",
    );
  let some_random_html_element =
    JSX.unsafe("<text dx=\"1 2\" dy=\"3 4\"></text>");
  let lower_case_component = lola(~id="33", ());
  let lower_case_component_being_html = JSX.unsafe("<div id=\"33\"></div>");
