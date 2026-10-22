let user_let_does_not_shadow_sibling =
  test("user_let_does_not_shadow_sibling", () => {
    let html = {
      let name = "outer";
      <div>
        {let name = "inner";
         <span> {JSX.string(name)} </span>}
        {JSX.string(name)}
      </div>;
    };
    assert_string(JSX.render(html), {|<div><span>inner</span>outer</div>|});
  });

let user_let_int_child =
  test("user_let_int_child", () => {
    let html = {
      let n = 1;
      <div> {let n = 2;
             <span> {JSX.int(n)} </span>} {JSX.int(n)} </div>;
    };
    assert_string(JSX.render(html), {|<div><span>2</span>1</div>|});
  });

let user_let_attribute_value =
  test("user_let_attribute_value", () => {
    let html = {
      let cls = "outer";
      <div class_=cls>
        {let cls = "inner";
         <span class_=cls />}
        <b class_=cls />
      </div>;
    };
    assert_string(
      JSX.render(html),
      {|<div class="outer"><span class="inner"></span><b class="outer"></b></div>|},
    );
  });

let user_let_fragment =
  test("user_let_fragment", () => {
    let html = {
      let name = "outer";
      <>
        {let name = "inner";
         <span> {JSX.string(name)} </span>}
        {JSX.string(name)}
      </>;
    };
    assert_string(JSX.render(html), {|<span>inner</span>outer|});
  });

let user_let_component =
  test("user_let_component", () => {
    module Comp = {
      let make = (~children, ()) => <p> children </p>;
    };
    let html = {
      let name = "outer";
      <div>
        {let name = "inner";
         <Comp> {JSX.string(name)} </Comp>}
        {JSX.string(name)}
      </div>;
    };
    assert_string(JSX.render(html), {|<div><p>inner</p>outer</div>|});
  });

let stdlib_float_shadowed =
  test("stdlib_float_shadowed", () => {
    module Float = {
      let to_string = _ => "SHADOW";
    };
    let f = 1.5;
    assert_string(
      JSX.render(<div> {JSX.float(f)} </div>),
      {|<div>1.5</div>|},
    );
  });

let stdlib_buffer_shadowed =
  test("stdlib_buffer_shadowed", () => {
    module Buffer = {
      let add_string = (_, _) => ();
      let add_char = (_, _) => ();
    };
    let name = "x";
    assert_string(
      JSX.render(<div id=name> {JSX.string(name)} </div>),
      {|<div id="x">x</div>|},
    );
  });

let stdlib_bool_printf_shadowed =
  test("stdlib_bool_printf_shadowed", () => {
    module Bool = {
      let to_string = _ => "SHADOW";
    };
    module Printf = {
      let ksprintf = (_, _, _) => ();
    };
    let b = true;
    let n = 3;
    assert_string(
      JSX.render(<div spellcheck=b hidden=b> {JSX.format("%d", n)} </div>),
      {|<div spellcheck="true" hidden>3</div>|},
    );
  });

let tests = (
  "Hygiene",
  [
    user_let_does_not_shadow_sibling,
    user_let_int_child,
    user_let_attribute_value,
    user_let_fragment,
    user_let_component,
    stdlib_float_shadowed,
    stdlib_buffer_shadowed,
    stdlib_bool_printf_shadowed,
  ],
);
