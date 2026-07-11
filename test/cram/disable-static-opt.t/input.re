/* Test: Static elements that would normally be optimized */
let static_div = <div />;
let static_with_class = <div class_="container" />;
let nested_static = <div> <span> {JSX.string("hello")} </span> </div>;

/* Test: Dynamic child */
let dynamic_child = name => <div> {JSX.string(name)} </div>;

/* Test: Optional booleanish-string attribute (regression: Bool.to_string
   must be applied to the unwrapped value inside Option.map) */
let optional_booleanish = (~spellcheck=?, ()) => <div ?spellcheck />;
