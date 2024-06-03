let upper = <Upper />;

let upper_prop = <Upper count />;

let upper_children_single = foo => <Upper> foo </Upper>;

let upper_children_multiple = (foo, bar) => <Upper> foo bar </Upper>;

let upper_children =
  <Page moreProps="hgalo"> <h1> {Jsx.string("Yep")} </h1> </Page>;

let upper_nested_module = <Foo.Bar a=1 b="1" />;

let upper_child_expr = <Div> {Jsx.int(1)} </Div>;
let upper_child_ident = <Div> lola </Div>;

let upper_all_kinds_of_props =
  <MyComponent
    booleanAttribute=true
    stringAttribute="string"
    intAttribute=1
    forcedOptional=?{Some("hello")}
    onclick="asdf">
    <div> "hello" </div>
  </MyComponent>;

let upper_ref_with_children = <FancyButton> <div /> </FancyButton>;

let call = <Link to_="https://sancho.dev/about" color="grey"> "about" </Link>;

let component = (~name) => {
  <div> <h1> {"Hello, " ++ name ++ "!"} </h1> </div>;
};

Html_of_jsx.render(<component />);
