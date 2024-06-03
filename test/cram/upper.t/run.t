
  $ ../ppx.sh --output re input.re
  let upper = Upper.make();
  let upper_prop = Upper.make(~count, ());
  let upper_children_single = foo => Upper.make(~children=foo, ());
  let upper_children_multiple = (foo, bar) =>
    Upper.make(~children=[foo, bar], ());
  let upper_children =
    Page.make(
      ~children=Jsx.node("h1", [], [Jsx.string("Yep")]),
      ~moreProps="hgalo",
      (),
    );
  let upper_nested_module = Foo.Bar.make(~a=1, ~b="1", ());
  let upper_child_expr = Div.make(~children=Jsx.int(1), ());
  let upper_child_ident = Div.make(~children=lola, ());
  let upper_all_kinds_of_props =
    MyComponent.make(
      ~children=Jsx.node("div", [], [Jsx.string("hello")]),
      ~booleanAttribute=true,
      ~stringAttribute="string",
      ~intAttribute=1,
      ~forcedOptional=?Some("hello"),
      ~onclick="asdf",
      (),
    );
  let upper_ref_with_children =
    FancyButton.make(~children=Jsx.node("div", [], []), ());
  let call =
    Link.make(
      ~children=Jsx.string("about"),
      ~to_="https://sancho.dev/about",
      ~color="grey",
      (),
    );
  let component = (~name) =>
    Jsx.node("div", [], [Jsx.node("h1", [], ["Hello, " ++ name ++ "!"])]);
  Html_of_jsx.render(component());
