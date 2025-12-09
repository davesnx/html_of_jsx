/* Test: Elements with dynamic content that trigger buffer estimation */
let dynamic_string = name => <div> {JSX.string(name)} </div>;
let dynamic_int = count => <div> {JSX.int(count)} </div>;
let dynamic_element = child => <div> child </div>;
let mixed = (name, child) => <div> {JSX.string(name)} child </div>;
