let tag =
  case("tag", () => {
    let div = <div />;
    assert_string(JSX.render(div), {|<div></div>|});
  });

let empty_attribute =
  case("empty_attribute", () => {
    let div = <div class_="" />;
    assert_string(JSX.render(div), {|<div class=""></div>|});
  });

let bool_attribute =
  case("bool_attribute", () => {
    let div = <div hidden=true />;
    assert_string(JSX.render(div), {|<div hidden></div>|});
  });

let bool_attributes =
  case("bool_attributes", () => {
    let input =
      <input type_="checkbox" name="cheese" checked=true disabled=false />;
    assert_string(
      JSX.render(input),
      {|<input type="checkbox" name="cheese" checked />|},
    );
  });

let innerhtml =
  case("innerhtml", () => {
    let p = <p> {JSX.string("text")} </p>;
    assert_string(JSX.render(p), {|<p>text</p>|});
  });

let int_attribute =
  case("int_attribute", () => {
    let div = <div tabindex=1 />;
    assert_string(JSX.render(div), {|<div tabindex="1"></div>|});
  });

let style_attribute =
  case("style_attribute", () => {
    let div = <div style="background-color:gainsboro" />;
    assert_string(
      JSX.render(div),
      {|<div style="background-color:gainsboro"></div>|},
    );
  });

let link_as_attribute =
  case("link_as_attribute", () => {
    let link =
      <link as_="image" rel="preload" href="https://sancho.dev/blog" />;
    assert_string(
      JSX.render(link),
      {|<link as="image" rel="preload" href="https://sancho.dev/blog" />|},
    );
  });

let int_opt_attribute_some =
  case("int_opt_attribute_some", () => {
    let tabindex = Some(1);
    let div = <div ?tabindex />;
    assert_string(JSX.render(div), {|<div tabindex="1"></div>|});
  });

let int_opt_attribute_none =
  case("int_opt_attribute_none", () => {
    let tabindex = None;
    let div = <div ?tabindex />;
    assert_string(JSX.render(div), {|<div></div>|});
  });

let fragment =
  case("fragment", () => {
    let div = <> <div class_="md:w-1/3" /> <div class_="md:w-2/3" /> </>;
    assert_string(
      JSX.render(div),
      {|<div class="md:w-1/3"></div><div class="md:w-2/3"></div>|},
    );
  });

module Container = {
  let make = (~children=?, ()) => {
    switch (children) {
    | Some(child) => <div> child </div>
    | None => JSX.null
    };
  };
};

let children_uppercase =
  case("children_uppercase", () => {
    let component = <Container />;
    assert_string(JSX.render(component), "");
  });

let children_uppercase_children_case_optional =
  case("children_uppercase_children_optional", () => {
    let component = <Container> <span /> </Container>;
    assert_string(JSX.render(component), {|<div><span></span></div>|});
  });

let children_lowercase =
  case("children_lowercase", () => {
    let component = <div> <span /> </div>;
    assert_string(JSX.render(component), {|<div><span></span></div>|});
  });

let string_opt_attribute_some =
  case("string_opt_attribute_some", () => {
    let class_ = Some("foo");
    let div = <div ?class_ />;
    assert_string(JSX.render(div), {|<div class="foo"></div>|});
  });

let string_opt_attribute_none =
  case("string_opt_attribute_none", () => {
    let class_ = None;
    let div = <div ?class_ />;
    assert_string(JSX.render(div), {|<div></div>|});
  });

let bool_opt_attribute_some =
  case("bool_opt_attribute_some", () => {
    let hidden = Some(true);
    let div = <div ?hidden />;
    assert_string(JSX.render(div), {|<div hidden></div>|});
  });

let bool_opt_attribute_none =
  case("bool_opt_attribute_none", () => {
    let hidden = None;
    let div = <div ?hidden />;
    assert_string(JSX.render(div), {|<div></div>|});
  });

let style_opt_attribute_some =
  case("style_opt_attribute_some", () => {
    let style = Some("color: blue;");
    let div = <div ?style />;
    assert_string(JSX.render(div), {|<div style="color: blue;"></div>|});
  });

let style_opt_attribute_none =
  case("style_opt_attribute_none", () => {
    let style = None;
    let div = <div ?style />;
    assert_string(JSX.render(div), {|<div></div>|});
  });

let onclick_inline_string =
  case("onclick_inline_string", () => {
    let onClick = "console.log('clicked')";
    let div = <div onclick=onClick />;
    assert_string(
      JSX.render(div),
      {|<div onclick="console.log('clicked')"></div>|},
    );
  });

let svg =
  case("svg", () => {
    assert_string(
      JSX.render(
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          width="24px"
          height="24px">
          <path
            d="M 5 3 C 3.9069372 3 3 3.9069372 3 5 L 3 19 C 3 20.093063 3.9069372 21 5 21 L 19 21 C 20.093063 21 21 20.093063 21 19 L 21 12 L 19 12 L 19 19 L 5 19 L 5 5 L 12 5 L 12 3 L 5 3 z M 14 3 L 14 5 L 17.585938 5 L 8.2929688 14.292969 L 9.7070312 15.707031 L 19 6.4140625 L 19 10 L 21 10 L 21 3 L 14 3 z"
          />
        </svg>,
      ),
      {|<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24px" height="24px"><path d="M 5 3 C 3.9069372 3 3 3.9069372 3 5 L 3 19 C 3 20.093063 3.9069372 21 5 21 L 19 21 C 20.093063 21 21 20.093063 21 19 L 21 12 L 19 12 L 19 19 L 5 19 L 5 5 L 12 5 L 12 3 L 5 3 z M 14 3 L 14 5 L 17.585938 5 L 8.2929688 14.292969 L 9.7070312 15.707031 L 19 6.4140625 L 19 10 L 21 10 L 21 3 L 14 3 z"></path></svg>|},
    )
  });

module Component = {
  let make = (~children: JSX.element, ~cosas as _, ()) => {
    <div> children </div>;
  };
};

let children_one_element =
  case("children_one_element", () => {
    assert_string(
      JSX.render(<Component cosas=true> <span /> </Component>),
      {|<div><span></span></div>|},
    )
  });

let children_multiple_elements =
  case("children_multiple_elements", () => {
    assert_string(
      JSX.render(
        <Component cosas=false>
          <> <div> <span /> </div> <span /> </>
        </Component>,
      ),
      {|<div><div><span></span></div><span></span></div>|},
    )
  });

module Text = {
  module Tag = {
    type t =
      | H1
      | H2;

    let unwrap =
      fun
      | H1 => "h1"
      | H2 => "h2";
  };

  let make = (~tagType, ~children: JSX.element, ()) => {
    JSX.node(tagType |> Tag.unwrap, [], [children]);
  };
};

let create_element_variadic =
  case("create_element_variadic", () => {
    let component = <Text tagType=Text.Tag.H1> {JSX.string("Hello")} </Text>;
    assert_string(JSX.render(component), {|<h1>Hello</h1>|});
    let component = <Text tagType=Text.Tag.H2> {JSX.string("Hello")} </Text>;
    assert_string(JSX.render(component), {|<h2>Hello</h2>|});
  });

let aria_props =
  case("aria_props", () => {
    let component =
      <h1 aria_hidden=true aria_label="send email" aria_atomic=true>
        {JSX.string("Hello")}
      </h1>;
    assert_string(
      JSX.render(component),
      {|<h1 aria-hidden="true" aria-label="send email" aria-atomic="true">Hello</h1>|},
    );
  });

let lowercase_component =
  case("lowercase_component", () => {
    let component = (~text, ()) => <h1> {JSX.string(text)} </h1>;

    assert_string(
      JSX.render(<component text="Hello" />),
      {|<h1>Hello</h1>|},
    );
  });

let tests = (
  "Reason with JSX",
  [
    tag,
    empty_attribute,
    bool_attribute,
    bool_attributes,
    innerhtml,
    int_attribute,
    svg,
    style_attribute,
    link_as_attribute,
    int_opt_attribute_some,
    int_opt_attribute_none,
    string_opt_attribute_some,
    string_opt_attribute_none,
    bool_opt_attribute_some,
    bool_opt_attribute_none,
    style_opt_attribute_some,
    style_opt_attribute_none,
    fragment,
    children_uppercase,
    children_lowercase,
    onclick_inline_string,
    children_one_element,
    children_multiple_elements,
    create_element_variadic,
    aria_props,
    lowercase_component,
  ],
);
