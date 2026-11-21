let static_div = <div />;
let static_with_class = <div class_="container" />;
let nested_static = <div> <span> {JSX.string("hello")} </span> </div>;

let dynamic_child = name => <div> {JSX.string(name)} </div>;

let optional_booleanish = (~spellcheck=?, ()) => <div ?spellcheck />;

let fragment = name => <> <span /> {JSX.string(name)} </>;

let fragment_text = (a, b) => <> "text" {JSX.string(a)} {JSX.string(b)} </>;
let fragment_effects = f => <> {JSX.string(f("a"))} {JSX.string(f("b"))} </>;
