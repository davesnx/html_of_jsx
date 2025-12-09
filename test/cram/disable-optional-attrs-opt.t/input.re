/* Test: Elements with optional attributes */
let optional_class = (~class_=?, ()) => <div ?class_ />;
let optional_id = (~id=?, ()) => <div ?id />;
let optional_multiple = (~class_=?, ~id=?, ()) => <div ?class_ ?id />;
let optional_with_children = (~class_=?, ()) =>
  <div ?class_> {JSX.string("hello")} </div>;
