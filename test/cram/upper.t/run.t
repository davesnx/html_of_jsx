
  $ ../ppx.sh --output re input.re
  let upper = Upper.make();
  let upper_prop = Upper.make(~count, ());
  let upper_children_single = foo => Upper.make(~children=foo, ());
  let upper_children_multiple = (foo, bar) =>
    Upper.make(~children=[foo, bar], ());
  let upper_children =
    Page.make(
      ~children=JSX.node("h1", [], [JSX.string("Yep")]),
      ~moreProps="hgalo",
      (),
    );
  let upper_nested_module = Foo.Bar.make(~a=1, ~b="1", ());
  let upper_child_expr = Div.make(~children=JSX.int(1), ());
  let upper_child_ident = Div.make(~children=lola, ());
  let upper_all_kinds_of_props =
    MyComponent.make(
      ~children=JSX.node("div", [], [JSX.string("hello")]),
      ~booleanAttribute=true,
      ~stringAttribute="string",
      ~intAttribute=1,
      ~forcedOptional=?Some("hello"),
      ~onclick="asdf",
      (),
    );
  let upper_ref_with_children =
    FancyButton.make(~children=JSX.node("div", [], []), ());
  let call =
    Link.make(
      ~children=JSX.string("about"),
      ~to_="https://sancho.dev/about",
      ~color="grey",
      (),
    );
  let component = (~name) =>
    JSX.node("div", [], [JSX.node("h1", [], ["Hello, " ++ name ++ "!"])]);
  JSX.render(component());
