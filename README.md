# html_of_jsx

html_of_jsx is an implementation of JSX but designed to render HTML on the server

This library is extracted from [server-reason-react](https://github.com/ml-in-barcelona/server-reason-react) and simplified to just work with HTML5.

## Installation

```sh
opan pin add html_of_jsx "https://github.com/davesnx/html_of_jsx"
```

## Features

### It's just HTML (no `className`, no `htmlFor`, etc.)

```reason
let element = <a href="https://x.com/davesnx">
  <span> {"Click me!"} </span>
</a>
```

> Note: [reserved keywords](https://v2.ocaml.org/manual/lex.html#sss:keywords) aren't possible as props. For example `class` -> `class_` or `type` -> `type_`.

### Components are functions with labeled arguments

```reason
let component = (~name) => {
  <div>
    <h1> {"Hello, " ++ name ++ "!"} </h1>
  </div>
};

Html_of_jsx.render(<component />);
```

### Uppercase components default to `make`

```reason
module Button = {
  let make = (~children) => {
    <button> {children} </button>
  };
};

Html_of_jsx.render(<Button />);
// is equivalent to `Html_of_jsx.render(<Button.make />)`
```

### Brings the power of interleaving expressions (stolen from JSX)

```reason
let component = (~name, ~children) => {
  <div>
    <h1> {"Hello, " ++ name ++ "!"} </h1>
    <h2> {children} </h2>
  </div>
};

Html_of_jsx.render(<component> {"This is a children!"} </component>)
```

### Type-safe

HTML attributes are type-checked and only valid attributes are allowed

```reason
    <h1 noop=1> "Hello, world!" </h1>;
    ^^^
// Error: prop 'noop' isn't valid on a 'h1' element.

    <h1 class_=1>{"Hello, world!"}</h1>
               ^
// Error: This expression has type int but an expression was expected of type string
```

And also friendly, it recommends you the correct attribute if you misspell it

```reason

        let div = <div ?onClick />;
                  ^^^^
// Error: prop 'onClick' isn't valid on a 'div' element.
//        Hint: Maybe you mean 'onclick'?
```

### Minimalistic

Only 2 function to learn, the rest are your functions (aka components)!
- `Html_of_jsx.render` to render your HTML
- `Jsx.text` to inline text

The rest are helpers on `Jsx`, like (`Jsx.int`). Check the [documentation]() if you are curious

```reason
Html_of_jsx.render(<h1>{"Hello, world!"}</h1>)
```

### Supports children as list of elements

```reason
let component = (~name, ~children) => {
  <div>
    <h1> {"Hello, " ++ name ++ "!"} </h1>
    <h2> {children} </h2>
  </div>
};

Html_of_jsx.render(<component> {"This is a children!"} </component>)
```

### Supports fragments

```reason
let component = {
  <> <div class_="md:w-1/3" /> <div class_="md:w-2/3" /> </>;
};

Html_of_jsx.render(<component> {"This is a children!"} </component>)
```

### Works with [Reason](https://reasonml.github.io/) and [mlx](https://github.com/andreypopp/mlx)

```reason
let component = (~name) => {
  <div>
    <h1> {"Hello, " ++ name ++ "!"} </h1>
  </div>
};

Html_of_jsx.render(<component />)
```

```ml
let component ~name =
  <div>
    <h1> ("Hello, " ^ name ^ "!") </h1>
  </div>

Html_of_jsx.render <component />
```
