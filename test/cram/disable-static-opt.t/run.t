Test with -disable-static-opt flag: all elements should use JSX.node instead of JSX.unsafe
  $ ../ppx.sh --output re --flags="-disable-static-opt" input.re
  let static_div = JSX.node("div", [], []);
  let static_with_class =
    JSX.node("div", [("class", `String("container": string))], []);
  let nested_static =
    JSX.node("div", [], [JSX.node("span", [], [JSX.string("hello")])]);
  let dynamic_child = name => JSX.node("div", [], [JSX.string(name)]);
  let optional_booleanish = (~spellcheck=?, ()) =>
    JSX.node(
      "div",
      Stdlib.List.filter_map(
        Stdlib.Fun.id,
        [
          Stdlib.Option.map(
            v => ("spellcheck", `String(Stdlib.Bool.to_string(v))),
            spellcheck: option(bool),
          ),
        ],
      ),
      [],
    );
  let fragment = name =>
    JSX.list([JSX.node("span", [], []), JSX.string(name)]);
  let fragment_text = (a, b) =>
    JSX.list([JSX.string("text"), JSX.string(a), JSX.string(b)]);
  let fragment_effects = f => {
    let __html_v1 = JSX.string(f("a"));
    let __html_v2 = JSX.string(f("b"));
    JSX.list([__html_v1, __html_v2]);
  };
