  $ ../ppx.sh --output re input.re
  let bool_attr_with_string = {
    let __html_v1 = [%ocaml.error
      "[html_of_jsx] The attribute 'hidden' expects a bool."
    ];
    JSX.writer(
      75,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<div");
        if (__html_v1) {
          Stdlib.Buffer.add_string(__html_buf, " hidden");
        };
        Stdlib.Buffer.add_string(__html_buf, "></div>");
        ();
      },
    );
  };
  let int_attr_with_string = {
    let __html_v2 = [%ocaml.error
      "[html_of_jsx] The attribute 'tabindex' expects an int."
    ];
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
  let string_attr_with_int = {
    let __html_v3 = [%ocaml.error
      "[html_of_jsx] The attribute 'id' expects a string."
    ];
    JSX.writer(
      75,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<div id=\"");
        JSX.escape(__html_buf, __html_v3);
        Stdlib.Buffer.add_string(__html_buf, "\"></div>");
        ();
      },
    );
  };
  let bool_attr_with_int = {
    let __html_v4 = [%ocaml.error
      "[html_of_jsx] The attribute 'hidden' expects a bool."
    ];
    JSX.writer(
      75,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<div");
        if (__html_v4) {
          Stdlib.Buffer.add_string(__html_buf, " hidden");
        };
        Stdlib.Buffer.add_string(__html_buf, "></div>");
        ();
      },
    );
  };
  let int_attr_with_suffix = {
    let __html_v5 = [%ocaml.error
      "[html_of_jsx] The attribute 'tabindex' expects an int."
    ];
    JSX.writer(
      75,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<div tabindex=\"");
        JSX.write_int(__html_buf, __html_v5);
        Stdlib.Buffer.add_string(__html_buf, "\"></div>");
        ();
      },
    );
  };
  let int_child_with_suffix = {
    let __html_v6 = [%ocaml.error "[html_of_jsx] JSX.int expects an int."];
    JSX.writer(
      71,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<p>");
        JSX.write_int(__html_buf, __html_v6);
        Stdlib.Buffer.add_string(__html_buf, "</p>");
        ();
      },
    );
  };
  let polyvariant_with_string = {
    let __html_v7 = [%ocaml.error
      "[html_of_jsx] The attribute 'type_' expects one of `button | `checkbox | `color | `date | `datetime_local | `email | `file | `hidden | `image | `month | `number | `password | `radio | `range | `reset | `search | `submit | `tel | `text | `time | `url | `week."
    ];
    JSX.writer(
      73,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<input type=\"");
        Stdlib.Buffer.add_string(
          __html_buf,
          [@warning "-8"]
          (
            switch (
              (
                __html_v7: [
                  | `button
                  | `checkbox
                  | `color
                  | `date
                  | `datetime_local
                  | `email
                  | `file
                  | `hidden
                  | `image
                  | `month
                  | `number
                  | `password
                  | `radio
                  | `range
                  | `reset
                  | `search
                  | `submit
                  | `tel
                  | `text
                  | `time
                  | `url
                  | `week
                ]
              )
            ) {
            | `button => "button"
            | `checkbox => "checkbox"
            | `color => "color"
            | `date => "date"
            | `datetime_local => "datetime-local"
            | `email => "email"
            | `file => "file"
            | `hidden => "hidden"
            | `image => "image"
            | `month => "month"
            | `number => "number"
            | `password => "password"
            | `radio => "radio"
            | `range => "range"
            | `reset => "reset"
            | `search => "search"
            | `submit => "submit"
            | `tel => "tel"
            | `text => "text"
            | `time => "time"
            | `url => "url"
            | `week => "week"
            }
          ),
        );
        Stdlib.Buffer.add_string(__html_buf, "\" />");
        ();
      },
    );
  };
  let polyvariant_unknown_tag = {
    let __html_v8 = [%ocaml.error
      "[html_of_jsx] The attribute 'type_' expects one of `button | `checkbox | `color | `date | `datetime_local | `email | `file | `hidden | `image | `month | `number | `password | `radio | `range | `reset | `search | `submit | `tel | `text | `time | `url | `week."
    ];
    JSX.writer(
      73,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<input type=\"");
        Stdlib.Buffer.add_string(
          __html_buf,
          [@warning "-8"]
          (
            switch (
              (
                __html_v8: [
                  | `button
                  | `checkbox
                  | `color
                  | `date
                  | `datetime_local
                  | `email
                  | `file
                  | `hidden
                  | `image
                  | `month
                  | `number
                  | `password
                  | `radio
                  | `range
                  | `reset
                  | `search
                  | `submit
                  | `tel
                  | `text
                  | `time
                  | `url
                  | `week
                ]
              )
            ) {
            | `button => "button"
            | `checkbox => "checkbox"
            | `color => "color"
            | `date => "date"
            | `datetime_local => "datetime-local"
            | `email => "email"
            | `file => "file"
            | `hidden => "hidden"
            | `image => "image"
            | `month => "month"
            | `number => "number"
            | `password => "password"
            | `radio => "radio"
            | `range => "range"
            | `reset => "reset"
            | `search => "search"
            | `submit => "submit"
            | `tel => "tel"
            | `text => "text"
            | `time => "time"
            | `url => "url"
            | `week => "week"
            }
          ),
        );
        Stdlib.Buffer.add_string(__html_buf, "\" />");
        ();
      },
    );
  };
  let booleanish_with_string = {
    let __html_v9 = [%ocaml.error
      "[html_of_jsx] The attribute 'spellcheck' expects a bool."
    ];
    JSX.writer(
      75,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<div spellcheck=\"");
        Stdlib.Buffer.add_string(__html_buf, Stdlib.Bool.to_string(__html_v9));
        Stdlib.Buffer.add_string(__html_buf, "\"></div>");
        ();
      },
    );
  };
  let string_child_with_int = {
    let __html_v10 = [%ocaml.error "[html_of_jsx] JSX.string expects a string."];
    JSX.writer(
      71,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<p>");
        JSX.escape(__html_buf, __html_v10);
        Stdlib.Buffer.add_string(__html_buf, "</p>");
        ();
      },
    );
  };
  let float_child_with_int = {
    let __html_v11 = [%ocaml.error "[html_of_jsx] JSX.float expects a float."];
    JSX.writer(
      71,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<p>");
        Stdlib.Buffer.add_string(
          __html_buf,
          Stdlib.Float.to_string(__html_v11),
        );
        Stdlib.Buffer.add_string(__html_buf, "</p>");
        ();
      },
    );
  };
  let string_attr_with_big_int = {
    let __html_v12 = [%ocaml.error
      "[html_of_jsx] The attribute 'title' expects a string."
    ];
    JSX.writer(
      75,
      __html_buf => {
        Stdlib.Buffer.add_string(__html_buf, "<div title=\"");
        JSX.escape(__html_buf, __html_v12);
        Stdlib.Buffer.add_string(__html_buf, "\"></div>");
        ();
      },
    );
  };
