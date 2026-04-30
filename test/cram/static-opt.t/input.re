/* Test: Fully static elements */
let empty_div = <div />;
let div_with_class = <div class_="container" />;
let div_with_multiple_attrs = <div id="main" class_="container" />;

/* Test: Self-closing tags */
let br_tag = <br />;
let img_tag = <img src="image.png" alt="An image" />;
let input_tag = <input type_=`text name="field" />;

/* Test: Nested static elements */
let nested_static =
  <div> <span> <b> {JSX.string("hello")} </b> </span> </div>;
let static_with_text = <div> {JSX.string("hello world")} </div>;
let static_formatted_text =
  <div> {JSX.format("Hello %s %c %i 100%%", "<b>", '<', 7)} </div>;
let unsupported_static_formatted_text =
  <div> {JSX.format("Price %f", 3.14)} </div>;

/* Test: DOCTYPE for html tag */
let html_page =
  <html lang="en">
    <head> <title> {JSX.string("Page")} </title> </head>
    <body />
  </html>;
let static_html =
  <html> <body> <div> {JSX.string("static")} </div> </body> </html>;

/* Test: String-typed dynamic children (uses string concat optimization) */
let dynamic_child = name => <div> {JSX.string(name)} </div>;
let dynamic_two_strings = (a, b) =>
  <div> {JSX.string(a)} {JSX.string(b)} </div>;
let dynamic_three_strings = (a, b, c) =>
  <p> {JSX.string(a)} {JSX.string(b)} {JSX.string(c)} </p>;
let dynamic_five_strings = (a, b, c, d, e) =>
  <span>
    {JSX.string(a)}
    {JSX.string(b)}
    {JSX.string(c)}
    {JSX.string(d)}
    {JSX.string(e)}
  </span>;
let dynamic_formatted_child = (name, initial, count) =>
  <div> {JSX.format("Hello %s %c %i", name, initial, count)} </div>;

/* Test: Dynamic attributes */
let dynamic_attr = className => <div class_=className />;
let dynamic_attr_with_string_child = (className, name) =>
  <div class_=className> {JSX.string(name)} </div>;
let dynamic_attr_with_formatted_child = (className, name, count) =>
  <div class_=className> {JSX.format("Hello %s %i", name, count)} </div>;
let dynamic_attr_with_mixed_child = (className, child) =>
  <div class_=className> child </div>;
let dynamic_bool_attr_with_child = (disabled, name) =>
  <button disabled=disabled> {JSX.string(name)} </button>;
let dynamic_int_attr_with_child = (tabindex, name) =>
  <div tabindex=tabindex> {JSX.string(name)} </div>;
let dynamic_attr_with_int_float_children = (className, count, price) =>
  <div class_=className> {JSX.int(count)} {JSX.float(price)} </div>;

/* Test: Element-typed dynamic children (uses Buffer) */
let dynamic_element = child => <div> child </div>;
let mixed_string_element = (name, child) =>
  <div> {JSX.string(name)} child </div>;

/* Test: Multiple children */
let multiple_static_children =
  <ul>
    <li> {JSX.string("one")} </li>
    <li> {JSX.string("two")} </li>
    <li> {JSX.string("three")} </li>
  </ul>;

/* Test: Boolean attributes */
let disabled_button = <button disabled=true />;
let enabled_button = <button disabled=false />;

/* Test: Special characters in content (escaping) */
let escaped_content =
  <div> {JSX.string("<script>alert('xss')</script>")} </div>;

/* Test: Fragment optimization */
let static_fragment = <> <div /> <span /> </>;

/* Test: Int/Float escape-free optimization */
let dynamic_int = count => <div> {JSX.int(count)} </div>;
let dynamic_float = price => <span> {JSX.float(price)} </span>;
let mixed_int_string = (count, name) =>
  <p> {JSX.int(count)} {JSX.string(name)} </p>;
