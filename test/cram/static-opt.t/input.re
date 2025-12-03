/* Test: Fully static elements */
let empty_div = <div />;
let div_with_class = <div class_="container" />;
let div_with_multiple_attrs = <div id="main" class_="container" />;

/* Test: Self-closing tags */
let br_tag = <br />;
let img_tag = <img src="image.png" alt="An image" />;
let input_tag = <input type_="text" name="field" />;

/* Test: Nested static elements */
let nested_static = <div><span><b>{JSX.string("hello")}</b></span></div>;
let static_with_text = <div>{JSX.string("hello world")}</div>;

/* Test: DOCTYPE for html tag */
let html_page = <html lang="en"><head><title>{JSX.string("Page")}</title></head><body /></html>;
let static_html = <html><body><div>{JSX.string("static")}</div></body></html>;

/* Test: Mixed static/dynamic */
let dynamic_child = name => <div>{JSX.string(name)}</div>;
let dynamic_attr = className => <div class_={className} />;

/* Test: Multiple children */
let multiple_static_children = <ul><li>{JSX.string("one")}</li><li>{JSX.string("two")}</li><li>{JSX.string("three")}</li></ul>;

/* Test: Boolean attributes */
let disabled_button = <button disabled=true />;
let enabled_button = <button disabled=false />;

/* Test: Special characters in content (escaping) */
let escaped_content = <div>{JSX.string("<script>alert('xss')</script>")}</div>;

/* Test: Fragment optimization */
let static_fragment = <> <div /> <span /> </>;

