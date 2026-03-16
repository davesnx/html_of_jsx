
# Core


## Primitives

`html_of_jsx` uses JSX to describe the user interface, and then renders it to HTML.

JSX trees are built from values of type `JSX.element`. Each value needs to be wrapped with helpers to become elements:

```reasonml
JSX.string("Hello")   /* string -> JSX.element */
JSX.int(42)           /* int    -> JSX.element */
JSX.float(3.14)       /* float  -> JSX.element */
JSX.null              /* represents nothing    */
```
```mlx
JSX.string "Hello"    (* string -> JSX.element *)
JSX.int 42            (* int    -> JSX.element *)
JSX.float 3.14        (* float  -> JSX.element *)
JSX.null              (* represents nothing    *)
```
All text rendered through these helpers is HTML-escaped by default, so user input is safe from XSS attacks.


## HTML attributes

`html_of_jsx` sticks to standard HTML attributes: `tabindex`, `maxlength`, `value`, `placeholder`, `autocomplete`, etc... and avoids custom React attributes like `className` or `htmlFor`.

There are a few exceptions to this rule: we need to deviate for names such that are reserved as keywords in the language like `class_`, `for_`, check the list below for more details.

```reasonml
<input placeholder="Name" value="John" maxlength=50 />
<a href="/home" tabindex=1> {JSX.string("Home")} </a>
```
```mlx
<input placeholder="Name" value="John" maxlength=50 />
<a href="/home" tabindex=1> (JSX.string "Home") </a>
```

### Type-safety

Attributes are validated by element (ensure the element accepts the attribute) and by value type (ensure the value is of the correct type), so invalid attributes or wrong value types fail at compile time.

```reasonml
<h1 noop=1> {JSX.string("Hello, world!")} </h1>
/* Error: prop 'noop' is not valid on a 'h1' element. */

<h1 class_=1> {JSX.string("Hello, world!")} </h1>
/* Error: This expression has type int but an expression was expected of type string */

<div ?onClick />
/* Error: prop 'onClick' is not valid on a 'div' element.
   Hint: Maybe you mean 'onclick'? */
```
```mlx
<h1 noop=1> (JSX.string "Hello, world!") </h1>
(* Error: prop 'noop' is not valid on a 'h1' element. *)

<h1 class_=1> (JSX.string "Hello, world!") </h1>
(* Error: This expression has type int but an expression was expected of type string *)

<div ?onClick />
(* Error: prop 'onClick' is not valid on a 'div' element.
   Hint: Maybe you mean 'onclick'? *)
```

## Expressions inside JSX

Any expression can appear inside JSX. In Reason, expressions are wrapped with `{}`. In MLX, expressions are wrapped with `()`.

```reasonml
let status_badge = (~count, ()) => {
  <div>
    <span class_="badge">
      {
        JSX.string(
          if (count == 0) {
            "No items";
          } else {
            Int.to_string(count) ++ " items";
          },
        )
      }
    </span>
    <span class_="count"> {JSX.int(count)} </span>
  </div>;
};
```
```mlx
let status_badge ~count () =
  <div>
    <span class_="badge">
      (JSX.string (if count = 0 then "No items" else Int.to_string count ^ " items"))
    </span>
    <span class_="count">(JSX.int count)</span>
  </div>
```

## Components as functions

Components are plain functions that return `JSX.element`. They use labelled arguments for their props, with a trailing `()` so labeled arguments are applied correctly (more info on [labelled arguments](https://ocaml.org/docs/labels)).

```reasonml
let greeting = (~name, ()) => {
  <div> <h1> {JSX.string("Hello, " ++ name ++ "!")} </h1> </div>;
};

let html = JSX.render(<greeting name="lola" />);
```
```mlx
let greeting ~name () =
  <div> <h1>(JSX.string ("Hello, " ^ name ^ "!"))</h1> </div>

let html = JSX.render (<greeting name="lola" />)
```

### Optional props with defaults

Labelled arguments can have default values, making them optional at the call site:

```reasonml
let badge = (~label, ~kind="info", ()) => {
  <span class_={"badge badge-" ++ kind}> {JSX.string(label)} </span>;
};

<badge label="Ready" />              /* kind defaults to "info" */
<badge label="Error" kind="danger" />
```
```mlx
let badge ~label ?(kind = "info") () =
  <span class_={"badge badge-" ^ kind}>(JSX.string label)</span>

<badge label="Ready" />              (* kind defaults to "info" *)
<badge label="Error" kind="danger" />
```

## The `children` property

`children` is a special property that receives nested elements from component invocation. This is the foundation for composition.

```reasonml
let hero = (~children, ()) => {
  <main class_="fancy-hero"> {children} </main>;
};

let html = JSX.render(
  <hero>
    <h1> {JSX.string("Welcome")} </h1>
    <p> {JSX.string("Composable content")}</p>
  </hero>,
);
/* <main class="fancy-hero"><h1>Welcome</h1><p>Composable content</p></main> */
```
```mlx
let hero ~children () =
  <main class_="fancy-hero">(children)</main>

let html = JSX.render (
  <hero>
    <h1>(JSX.string "Welcome")</h1>
    <p>(JSX.string "Composable content")</p>
  </hero>
)
(* <main class="fancy-hero"><h1>Welcome</h1><p>Composable content</p></main> *)
```

## Lists and fragments


### Rendering a list of elements

When you need to render a dynamic list, use `JSX.list` to turn an `element list` into a single element:

```reasonml
let items = ["This", "is", "an", "unordered", "list"];

let html = JSX.render(
  <ul>
    {items |> List.map(item => <li> {JSX.string(item)} </li>) |> JSX.list}
  </ul>,
);
```
```mlx
let items = ["This"; "is"; "an"; "unordered"; "list"]

let html = JSX.render (
  <ul>
    (items |> List.map (fun item -> <li>(JSX.string item)</li>) |> JSX.list)
  </ul>
)
```

### Fragments

Sometimes you need to return sibling elements without an extra wrapper. Use fragments for that:

```reasonml
let columns: JSX.element =
  <>
    <div class_="md:w-1/3" />
    <div class_="md:w-2/3" />
  </>

let html = JSX.render(columns);
```
```mlx
let columns: JSX.element =
  <JSX.fragment>
    <div class_="md:w-1/3" />
    <div class_="md:w-2/3" />
  </JSX.fragment>

let html = JSX.render columns
```

## Components as modules

Module components are identified by their uppercase name and require a `make` function that returns `JSX.element`. They are useful for namespacing related components or grouping internal helpers alongside the component.

```reasonml
module Button = {
  let make = (~children, ()) => {
    <button onclick="onClickHandler"> {children} </button>;
  };
};

let html = JSX.render(<Button> {JSX.string("Click me")} </Button>)
```
```mlx
module Button = struct
  let make ~children () =
    <button onclick="onClickHandler">(children)</button>
end

let html = JSX.render (<Button>(JSX.string "Click me")</Button>)
```

## Conditional rendering

Use pattern matching to conditionally include elements. `JSX.null` renders nothing, so you can use it as an "empty" branch:

```reasonml
let alert = (~message, ~visible, ()) => {
  if (visible) {
    <div class_="alert"> {JSX.string(message)} </div>;
  } else {
    JSX.null;
  };
};
```
```mlx
let alert ~message ~visible () =
  if visible then
    <div class_="alert">(JSX.string message)</div>
  else
    JSX.null
```
This works with any pattern match:

```reasonml
let user_greeting = (~user, ()) => {
  switch (user) {
  | Some(name) => <h1> {JSX.string("Welcome, " ++ name)} </h1>
  | None => <h1> {JSX.string("Welcome, guest")} </h1>
  };
};
```
```mlx
let user_greeting ~user () =
  match user with
  | Some name -> <h1>(JSX.string ("Welcome, " ^ name))</h1>
  | None -> <h1>(JSX.string "Welcome, guest")</h1>
```

## Unsafe HTML

All text is HTML-escaped by default. If you need to inject trusted raw HTML (e.g. a script tag or pre-rendered markup), use `JSX.unsafe`:

```reasonml
let analytics = JSX.unsafe({|<script>console.log("loaded")</script>|});
```
```mlx
let analytics = JSX.unsafe {|<script>console.log("loaded")</script>|}
```
Avoid passing user-generated input to `JSX.unsafe`.


## Rendering

`JSX.render` converts a `JSX.element` tree into an HTML string:

```reasonml
let html: string = JSX.render(<div> {JSX.string("Hello")} </div>);
```
```mlx
let html : string = JSX.render (<div>(JSX.string "Hello")</div>)
```
For cases where you want to avoid the intermediate string allocation, use `JSX.render_to_channel`:

```reasonml
JSX.render_to_channel(stdout, <div> {JSX.string("Hello")} </div>);
```
```mlx
JSX.render_to_channel stdout (<div>(JSX.string "Hello")</div>)
```
When your server provides a streaming callback (for example [Dream](./dream.md) web server), can use `JSX.render_streaming` to stream the HTML chunks directly into the response body:

```reasonml
JSX.render_streaming(
  chunk => Dream.write(stream, chunk),
  <main> <h1> {JSX.string("Streaming")} </h1> </main>,
);
```
```mlx
JSX.render_streaming
  (fun chunk -> Dream.write stream chunk)
  (<main> <h1>(JSX.string "Streaming")</h1> </main>)
```