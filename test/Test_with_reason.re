let assert_string = (left, right) => {
  Alcotest.check(Alcotest.string, "should be equal", right, left);
};

let tag = () => {
  let div = <div />;
  assert_string(Html_of_jsx.render_element(div), "<div></div>");
};

let empty_attribute = () => {
  let div = <div class_="" />;
  assert_string(Html_of_jsx.render_element(div), "<div class=\"\"></div>");
};

let bool_attribute = () => {
  let div = <div hidden=true />;
  assert_string(Html_of_jsx.render_element(div), "<div hidden></div>");
};

let bool_attributes = () => {
  let input =
    <input type_="checkbox" name="cheese" checked=true disabled=false />;
  assert_string(
    Html_of_jsx.render_element(input),
    "<input type=\"checkbox\" name=\"cheese\" checked />",
  );
};

let innerhtml = () => {
  let p = <p> {Jsx.text("text")} </p>;
  assert_string(Html_of_jsx.render_element(p), "<p>text</p>");
};

let int_attribute = () => {
  let div = <div tabIndex=1 />;
  assert_string(
    Html_of_jsx.render_element(div),
    "<div tabIndex=\"1\"></div>",
  );
};

let style_attribute = () => {
  let div = <div style="background-color:gainsboro" />;
  assert_string(
    Html_of_jsx.render_element(div),
    "<div style=\"background-color:gainsboro\"></div>",
  );
};

let link_as_attribute = () => {
  let link = <link as_="image" rel="preload" href="https://sancho.dev/blog" />;
  assert_string(
    Html_of_jsx.render_element(link),
    "<link as=\"image\" rel=\"preload\" href=\"https://sancho.dev/blog\" />",
  );
};

let int_opt_attribute_some = () => {
  let tabIndex = Some(1);
  let div = <div ?tabIndex />;
  assert_string(
    Html_of_jsx.render_element(div),
    "<div tabIndex=\"1\"></div>",
  );
};

let int_opt_attribute_none = () => {
  let tabIndex = None;
  let div = <div ?tabIndex />;
  assert_string(Html_of_jsx.render_element(div), "<div></div>");
};

let fragment = () => {
  let div = <> <div class_="md:w-1/3" /> <div class_="md:w-2/3" /> </>;
  assert_string(
    Html_of_jsx.render_element(div),
    "<div class=\"md:w-1/3\"></div><div class=\"md:w-2/3\"></div>",
  );
};

module Container = {
  [@react.component]
  let make = (~children=?, ()) => {
    switch (children) {
    | Some(child) => <div> child </div>
    | None => Jsx.null
    };
  };
};

let children_uppercase = () => {
  let component = <Container />;
  assert_string(Html_of_jsx.render_element(component), "");
};

let children_uppercase_children_optional = () => {
  let component = <Container> <span /> </Container>;
  assert_string(
    Html_of_jsx.render_element(component),
    "<div><span></span></div>",
  );
};

let children_lowercase = () => {
  let component = <div> <span /> </div>;
  assert_string(
    Html_of_jsx.render_element(component),
    "<div><span></span></div>",
  );
};

let string_opt_attribute_some = () => {
  let class_ = Some("foo");
  let div = <div ?class_ />;
  assert_string(
    Html_of_jsx.render_element(div),
    "<div class=\"foo\"></div>",
  );
};

let string_opt_attribute_none = () => {
  let class_ = None;
  let div = <div ?class_ />;
  assert_string(Html_of_jsx.render_element(div), "<div></div>");
};

let bool_opt_attribute_some = () => {
  let hidden = Some(true);
  let div = <div ?hidden />;
  assert_string(Html_of_jsx.render_element(div), "<div hidden></div>");
};

let bool_opt_attribute_none = () => {
  let hidden = None;
  let div = <div ?hidden />;
  assert_string(Html_of_jsx.render_element(div), "<div></div>");
};

let style_opt_attribute_some = () => {
  let style = Some("color: blue;");
  let div = <div ?style />;
  assert_string(
    Html_of_jsx.render_element(div),
    "<div style=\"color: blue;\"></div>",
  );
};

let style_opt_attribute_none = () => {
  let style = None;
  let div = <div ?style />;
  assert_string(Html_of_jsx.render_element(div), "<div></div>");
};
let onclick_inline_string = () => {
  let onClick = "console.log('clicked')";
  let div = <div onclick=onClick />;
  assert_string(
    Html_of_jsx.render_element(div),
    "<div onclick=\"console.log('clicked')\"></div>",
  );
};

let svg = () => {
  assert_string(
    Html_of_jsx.render_element(
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
    "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"24px\" height=\"24px\"><path d=\"M 5 3 C 3.9069372 3 3 3.9069372 3 5 L 3 19 C 3 20.093063 3.9069372 21 5 21 L 19 21 C 20.093063 21 21 20.093063 21 19 L 21 12 L 19 12 L 19 19 L 5 19 L 5 5 L 12 5 L 12 3 L 5 3 z M 14 3 L 14 5 L 17.585938 5 L 8.2929688 14.292969 L 9.7070312 15.707031 L 19 6.4140625 L 19 10 L 21 10 L 21 3 L 14 3 z\"></path></svg>",
  );
};

module Component = {
  let make = (~children: Jsx.element, ~cosas as _) => {
    <div> children </div>;
  };
};

/* let children_one_element = () => {
     assert_string(
       Html_of_jsx.render_element(<Component cosas=true> <span /> </Component>),
       "<div><span></span></div>",
     );
   }; */

/* let children_multiple_elements = () => {
     assert_string(
       Html_of_jsx.render_element(
         <Component cosas=false> <div> <span /> </div> <span /> </Component>,
       ),
       "<div><div><span></span></div><span></span></div>",
     );
   }; */

let case = (title, fn) => Alcotest.test_case(title, `Quick, fn);

let assert_string = (left, right) =>
  Alcotest.check(Alcotest.string, "should be equal", right, left);

module Text = {
  module Tag = {
    type t =
      | H1;

    let unwrap =
      fun
      | H1 => "h1";
  };

  [@react.component]
  let make = (~tagType, ~children: Jsx.element) => {
    Jsx.node(tagType |> Tag.unwrap, [], [children]);
  };
};

/* let create_element_variadic = () => {
     let component = <Text tagType=Text.Tag.H1> {Jsx.text("Hello")} </Text>;
     assert_string(
       Html_of_jsx.render_element(component),
       "<h1 style=\"display:none\" class=\"foo\">Hello</h1>",
     );
   }; */

let aria_props = () => {
  let component =
    <h1 ariaHidden=true ariaLabel="send email" ariaAtomic=true>
      {Jsx.text("Hello")}
    </h1>;
  assert_string(
    Html_of_jsx.render_element(component),
    "<h1 aria-hidden=\"true\" aria-label=\"send email\" aria-atomic=\"true\">Hello</h1>",
  );
};

let _ =
  Alcotest.run(
    "server-reason-react.ppx",
    [
      (
        "renderToStaticMarkup",
        [
          case("div", tag),
          case("div_empty_attr", empty_attribute),
          case("div_bool_attr", bool_attribute),
          case("input_bool_attrs", bool_attributes),
          case("p_inner_html", innerhtml),
          case("div_int_attr", int_attribute),
          case("svg", svg),
          case("style_attr", style_attribute),
          case("link_as_attr", link_as_attribute),
          case("int_opt_attr_some", int_opt_attribute_some),
          case("int_opt_attr_none", int_opt_attribute_none),
          case("string_opt_attr_some", string_opt_attribute_some),
          case("string_opt_attr_none", string_opt_attribute_none),
          case("bool_opt_attr_some", bool_opt_attribute_some),
          case("bool_opt_attr_none", bool_opt_attribute_none),
          case("style_opt_attr_some", style_opt_attribute_some),
          case("style_opt_attr_none", style_opt_attribute_none),
          case("test_fragment", fragment),
          case("test_children_uppercase", children_uppercase),
          case("test_children_lowercase", children_lowercase),
          case("event_onclick_inline_string", onclick_inline_string),
          /* case("children_one_element", children_one_element), */
          /* case("children_multiple_elements", children_multiple_elements), */
          /* case("createElementVariadic", create_element_variadic), */
          case("aria_props", aria_props),
        ],
      ),
    ],
  );

let tests = ("Reason", []);
