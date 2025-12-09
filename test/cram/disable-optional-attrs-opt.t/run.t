Test with -disable-optional-attrs-opt flag: elements with optional attrs should use JSX.node instead of buffer optimization
  $ ../ppx.sh --output re --flags="-disable-optional-attrs-opt" input.re
  let optional_class = (~class_=?, ()) =>
    JSX.node(
      "div",
      Stdlib.List.filter_map(
        Stdlib.Fun.id,
        [
          Stdlib.Option.map(
            v => ("class", `String(v)),
            class_: option(string),
          ),
        ],
      ),
      [],
    );
  let optional_id = (~id=?, ()) =>
    JSX.node(
      "div",
      Stdlib.List.filter_map(
        Stdlib.Fun.id,
        [Stdlib.Option.map(v => ("id", `String(v)), id: option(string))],
      ),
      [],
    );
  let optional_multiple = (~class_=?, ~id=?, ()) =>
    JSX.node(
      "div",
      Stdlib.List.filter_map(
        Stdlib.Fun.id,
        [
          Stdlib.Option.map(
            v => ("class", `String(v)),
            class_: option(string),
          ),
          Stdlib.Option.map(v => ("id", `String(v)), id: option(string)),
        ],
      ),
      [],
    );
  let optional_with_children = (~class_=?, ()) =>
    JSX.node(
      "div",
      Stdlib.List.filter_map(
        Stdlib.Fun.id,
        [
          Stdlib.Option.map(
            v => ("class", `String(v)),
            class_: option(string),
          ),
        ],
      ),
      [JSX.string("hello")],
    );
