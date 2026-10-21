let local_string =
  test("local_string_is_not_the_jsx_helper", () => {
    let p = {
      let string = x => JSX.string(x ++ "?");
      <p> {string("a")} </p>;
    };
    assert_string(JSX.render(p), {|<p>a?</p>|});
  });

let local_int =
  test("local_int_is_not_the_jsx_helper", () => {
    let p = {
      let int = x => JSX.int(x + 1);
      <p> {int(1)} </p>;
    };
    assert_string(JSX.render(p), {|<p>2</p>|});
  });

let local_float =
  test("local_float_is_not_the_jsx_helper", () => {
    let p = {
      let float = x => JSX.float(x +. 0.5);
      <p> {float(1.)} </p>;
    };
    assert_string(JSX.render(p), {|<p>1.5</p>|});
  });

let local_text =
  test("local_text_is_not_the_jsx_helper", () => {
    let p = {
      let text = x => JSX.string(x ++ "?");
      <p> {text("a")} </p>;
    };
    assert_string(JSX.render(p), {|<p>a?</p>|});
  });

let local_format =
  test("local_format_is_not_the_jsx_helper", () => {
    let p = {
      let format = (_fmt, x) => JSX.string(x ++ "?");
      <p> {format("%s", "a")} </p>;
    };
    assert_string(JSX.render(p), {|<p>a?</p>|});
  });

let local_unsafe =
  test("local_unsafe_is_not_the_jsx_helper", () => {
    let p = {
      let unsafe = x => JSX.string(x);
      <p> {unsafe("<b>")} </p>;
    };
    assert_string(JSX.render(p), {|<p>&lt;b&gt;</p>|});
  });

let open_jsx_string =
  test("open_jsx_string", () => {
    let p = {
      JSX.(<p> {string("a<")} {int(1)} </p>);
    };
    assert_string(JSX.render(p), {|<p>a&lt;1</p>|});
  });

let qualified_helpers =
  test("qualified_helpers", () => {
    let p = <p> {JSX.string("a")} {JSX.int(1)} {JSX.unsafe("<b/>")} </p>;
    assert_string(JSX.render(p), {|<p>a1<b/></p>|});
  });

let int_literal_forms =
  test("int_literal_forms", () => {
    let div = <div tabindex=0x10 />;
    assert_string(JSX.render(div), {|<div tabindex="16"></div>|});
    let div = <div tabindex=1_000 />;
    assert_string(JSX.render(div), {|<div tabindex="1000"></div>|});
    let div = <div tabindex=(-3) />;
    assert_string(JSX.render(div), {|<div tabindex="-3"></div>|});
  });

let tests = (
  "Static values",
  [
    local_string,
    local_int,
    local_float,
    local_text,
    local_format,
    local_unsafe,
    open_jsx_string,
    qualified_helpers,
    int_literal_forms,
  ],
);
