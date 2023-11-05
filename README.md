# html_of_jsx

html_of_jsx is an implementation of JSX but designed to render HTML on the server

This library is extracted from [server-reason-react](https://github.com/ml-in-barcelona/server-reason-react) and simplified to just work with HTML5.

### As close as possible to HTML (no `className`, no `htmlFor`, etc.)

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

Html_jsx.render(<component />);
```

### Brings the power of interleaving expressions (stolen from JSX)

```reason
let component = (~name, ~children) => {
  <div>
    <h1> {"Hello, " ++ name ++ "!"} </h1>
    <h2> {children} </h2>
  </div>
};

Html_jsx.render(<component> {"This is a children!"} </component>)
```

### Minimalistic

Only 1 function to learn, `Html_jsx.render` the rest are your functions!

```reason
Html_jsx.render(<h1>{"Hello, world!"}</h1>)
```

### Supports children as list of elements

```reason
let component = (~name, ~children) => {
  <div>
    <h1> {"Hello, " ++ name ++ "!"} </h1>
    <h2> {children} </h2>
  </div>
};

Html_jsx.render(<component> {"This is a children!"} </component>)
```

### Works with [Reason](https://reasonml.github.io/) and [mlx](https://github.com/andreypopp/mlx)

```reason
let component = (~name) => {
  <div>
    <h1> {"Hello, " ++ name ++ "!"} </h1>
  </div>
};

Html_jsx.render(<component />)
```

```ml
let component ~name =
  <div>
    <h1> ("Hello, " ^ name ^ "!") </h1>
  </div>

Html_jsx.render <component />
```
