
# Module `JSX`

JSX module

The JSX module provides functions to render HTML elements in a declarative style.

```reasonml
  let html: string = JSX.render(
    <div>
      <h1> {JSX.string("Hello, World!")} </h1>
    </div>
  );
```
```mlx
  let html: string = JSX.render (
    <div>
      <h1>(JSX.string "Hello, World!")</h1>
    </div>
  );
```
```
type element
```
An abstract type that represents a JSX.element

```
val render : element -> string
```
Render a JSX.element as a string.

This function takes a JSX.element and converts it into its corresponding HTML string representation.

```reasonml
  let html: string = JSX.render(
    <div>
      <h1> {JSX.string("Hello, World!")} </h1>
    </div>
  );

  Printf.printf("%s", html); /* <div><h1>Hello, World!</h1></div> */
```
```mlx
  let html: string = JSX.render (
    <div>
      <h1>(JSX.string "Hello, World!")</h1>
    </div>

  Printf.printf "%s" html (* <div><h1>Hello, World!</h1></div> *)
```
```
val render_to_channel : Stdlib.out_channel -> element -> unit
```
Render a JSX.element directly to an output channel.

This function writes the HTML representation directly to the channel, avoiding the intermediate string allocation that `render` requires.

```reasonml
  JSX.render_to_channel(stdout,
    <div>
      <h1> {JSX.string("Hello, World!")} </h1>
    </div>
  );
```
```mlx
  JSX.render_to_channel stdout (
    <div>
      <h1>(JSX.string "Hello, World!")</h1>
    </div>
  );
```
```
val render_streaming : (string -> unit) -> element -> unit
```
Render a JSX.element using a streaming callback function.

This function renders the element and passes the result to the callback function, useful for frameworks that support streaming responses.

```reasonml
  JSX.render_streaming(html => Dream.write(stream, html),
    <div>
      <h1> {JSX.string("Hello, World!")} </h1>
    </div>
  );
```
```mlx
  JSX.render_streaming (fun html -> Dream.write stream html) (<div>
    <h1>(JSX.string "Hello, World!")</h1>
  </div>)
```
```
val float : float -> element
```
Helper to render a float.

This function helps in rendering a float value as a JSX element.

```reasonml
  let element : JSX.element = JSX.float(3.14);
```
```mlx
  let element : JSX.element = JSX.float 3.14
```
```
val fragment : children:element list -> unit -> element
```
```
val int : int -> element
```
Helper to render an integer.

This function helps in rendering an integer value as a JSX element.

```reasonml
  let element : JSX.element = JSX.int(42);
```
```mlx
  let element : JSX.element = JSX.int 42
```
```
val list : element list -> element
```
Helper to render a list of elements.

This function takes a list of JSX elements and returns a single JSX element that contains all of them. This is useful for rendering dynamic lists of elements.

```reasonml
  let element : JSX.element =
    JSX.list([ JSX.string("Item 1"), JSX.string("Item 2"), JSX.string("Item 3") ]);
```
```mlx
  let element : JSX.element =
    JSX.list
      [ JSX.string "Item 1"; JSX.string "Item 2"; JSX.string "Item 3" ]
```
```
val array : element array -> element
```
Helper to render an array of elements.

This function takes an array of JSX elements and returns a single JSX element that contains all of them. This is useful for rendering dynamic arrays of elements.

```reasonml
  let element : JSX.element =
    JSX.array
      [| JSX.string("Item 1"), JSX.string("Item 2"), JSX.string("Item 3") |]
```
```mlx
  let element : JSX.element =
    JSX.array
      [| JSX.string "Item 1"; JSX.string "Item 2"; JSX.string "Item 3" |]
```
```
type attribute =
  string
  * [ `Bool of bool | `Int of int | `Float of float | `String of string ]
```
Represents an attribute of an HTML element. It consists of a name and a value which can be of several types.

This is used by the ppx to create the attributes of the HTML element, and rarely used directly.

```
val node : string -> attribute list -> element list -> element
```
The function to create an HTML DOM Node.

It takes a tag name, a list of attributes, and a list of child elements to create an HTML node.

```reasonml
  let link : JSX.element =
     JSX.node("a",
       [ ("href", `String("https://ocaml.org") ],
       [ JSX.string("OCaml") ]);
```
```mlx
  let link : JSX.element =
    JSX.node "a"
      [ ("href", `String "https://ocaml.org") ]
      [ JSX.string "OCaml" ]
```
```
val null : element
```
Helper to represent nullability in JSX.

This is useful to represent and pattern match against null or empty elements.

```reasonml
  let element : JSX.element = JSX.null;
```
```mlx
  let element : JSX.element = JSX.null
```
```
val string : string -> element
```
Helper to represent an element as a string.

This function allows you to directly render a string as a JSX element.

```reasonml
  let element : JSX.element = JSX.string("Hello, World!");
```
```mlx
  let element : JSX.element = JSX.string "Hello, World!"
```
```
val text : string -> element
```
A deprecated function to render a text string.

This function is deprecated in favor of `JSX.string`.

```reasonml
  let element : JSX.element = JSX.text("Hello, World!");
```
```mlx
  let element : JSX.element = JSX.text "Hello, World!"
```
deprecated Use JSX.string instead
```
val stringf : ('a, unit, string, element) Stdlib.format4 -> 'a
```
Helper to render formatted text as a JSX element.

This formats a string using `Printf`\-style directives and then renders the result as escaped text, just like `JSX.string`.

```reasonml
  let element : JSX.element = JSX.stringf("Hello %s #%i", name, count);
```
```mlx
  let element : JSX.element = JSX.stringf "Hello %s #%i" name count
```
```
val unsafe : string -> element
```
Helper to bypass HTML encoding and treat output as unsafe. This can lead to HTML escaping problems, XSS injections, and other security concerns. Use with caution.

A common use case for bypassing the HTML encoding is to render a script or style tag.

```reasonml
  let content: string = "Raw HTML";
  let script: JSX.element = <script>{content}</script>
```
```mlx
  let content: string = "Raw HTML" in
  let script: JSX.element = <script> content </script>
```
```
val escape : Stdlib.Buffer.t -> string -> unit
```
Escape a string and write it directly to a buffer.

This escapes ampersand, less-than, greater-than, apostrophe, and double-quote characters.

This is an advanced function used mostly by the PPX for optimized rendering. Most users should prefer `JSX.string`.

```reasonml
  let buf = Buffer.create(256);
  JSX.escape(buf, "<script>");
  Buffer.contents(buf); /* "&lt;script&gt;" */
```
```mlx
  let buf = Buffer.create 256 in
  JSX.escape buf "<script>";
  Buffer.contents buf (* "&lt;script&gt;" *)
```
```
val write : Stdlib.Buffer.t -> element -> unit
```
Write an element directly to a buffer.

This is an advanced function used mostly by the PPX for optimized rendering when building HTML strings incrementally.

```reasonml
  let buf = Buffer.create(256);
  JSX.write(buf, (JSX.string "Hello"));
  Buffer.contents(buf); /* "Hello" */
```
```mlx
  let buf = Buffer.create 256 in
  JSX.write buf (JSX.string "Hello");
  Buffer.contents buf (* "Hello" *)
```