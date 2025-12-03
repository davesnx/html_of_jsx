Test with -no-static-opt flag: all elements should use JSX.node instead of JSX.unsafe
  $ ../ppx.sh --output re --flags="-no-static-opt" input.re
  let static_div = JSX.node("div", [], []);
  let static_with_class =
    JSX.node(
      "div",
      Stdlib.List.filter_map(
        Stdlib.Fun.id,
        [Some(("class", `String("container": string)))],
      ),
      [],
    );
  let nested_static =
    JSX.node("div", [], [JSX.node("span", [], [JSX.string("hello")])]);
  let dynamic_child = name => JSX.node("div", [], [JSX.string(name)]);
