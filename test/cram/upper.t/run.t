
  $ ../ppx.sh --output re input.re
  let upper = Upper.createElement();
  let upper_prop = Upper.createElement(~count, ());
  let upper_children_single = foo => Upper.createElement(~children=foo, ());
  let upper_children_multiple = (foo, bar) =>
    Upper.createElement(~children=[foo, bar], ());
  let upper_children =
    Page.createElement(
      ~children=Jsx.node("h1", [], [Jsx.string("Yep")]),
      ~moreProps="hgalo",
      (),
    );
  let upper_nested_module = Foo.Bar.createElement(~a=1, ~b="1", ());
  let upper_child_expr = Div.createElement(~children=Jsx.int(1), ());
  let upper_child_ident = Div.createElement(~children=lola, ());
  let upper_all_kinds_of_props =
    MyComponent.createElement(
      ~children=Jsx.node("div", [], [Jsx.text("hello")]),
      ~booleanAttribute=true,
      ~stringAttribute="string",
      ~intAttribute=1,
      ~forcedOptional=?Some("hello"),
      ~onclick="asdf",
      (),
    );
  let upper_ref_with_children =
    FancyButton.createElement(~children=Jsx.node("div", [], []), ());
