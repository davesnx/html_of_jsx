  $ ../ppx.sh --output re input.re
  let decimal_attr = {
    let __html_v1 = 99999999999999999999;
    JSX.writer(
      75,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<div tabindex=\"");
        JSX.write_int(__html_buf, __html_v1);
        Stdlib.Buffer.add_string(__html_buf, "\"></div>");
        ();
      },
    );
  };
  let hex_attr = {
    let __html_v2 = 0xFFFFFFFFFFFFFFFF;
    JSX.writer(
      75,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<div tabindex=\"");
        JSX.write_int(__html_buf, __html_v2);
        Stdlib.Buffer.add_string(__html_buf, "\"></div>");
        ();
      },
    );
  };
  let int_child = {
    let __html_v3 = 99999999999999999999;
    JSX.writer(
      71,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<p>");
        JSX.write_int(__html_buf, __html_v3);
        Stdlib.Buffer.add_string(__html_buf, "</p>");
        ();
      },
    );
  };
  let format_arg = {
    let __html_v4 = 99999999999999999999;
    JSX.writer(
      71,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<p>");
        Stdlib.Printf.ksprintf(JSX.escape(__html_buf), "%d", __html_v4);
        Stdlib.Buffer.add_string(__html_buf, "</p>");
        ();
      },
    );
  };
