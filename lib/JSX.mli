(** JSX module

    The JSX module provides a set of functions and render HTML elements in a
    declarative manner

    {[
      let html: string = JSX.render(
        <div>
          <h1> {JSX.string("Hello, World!")} </h1>
        </div>
      );
    ]} *)

type element
(** An abstract type that represents a JSX.element *)

val render : element -> string
(** Render a JSX.element as a string.

    This function takes a JSX.element and converts it into its corresponding
    HTML string representation.

    {[
      let html: string = JSX.render(
        <div>
          <h1> {JSX.string("Hello, World!")} </h1>
        </div>
      );

      Printf.printf "%s" html; /* <div><h1>Hello, World!</h1></div> */
    ]} *)

val float : float -> element
(** Helper to render a float.

    This function helps in rendering a float value as a JSX element.

    {[
      let element : JSX.element = JSX.float 3.14
    ]} *)

val fragment : element list -> element [@@deprecated "Use JSX.list instead"]

val int : int -> element
(** Helper to render an integer.

    This function helps in rendering an integer value as a JSX element.

    {[
      let element : JSX.element = JSX.int 42
    ]} *)

val list : element list -> element
(** Helper to render a list of elements.

    This function takes a list of JSX elements and returns a single JSX element
    that contains all of them. This is useful for rendering dynamic lists of
    elements.

    {[
      let element : JSX.element =
        JSX.list
          [ JSX.string "Item 1"; JSX.string "Item 2"; JSX.string "Item 3" ]
    ]} *)

type attribute =
  string * [ `Bool of bool | `Int of int | `Float of float | `String of string ]
(** Represents an attribute of an HTML element. It consists of a name and a
    value which can be of several types.

    This is used by the ppx to create the attributes of the HTML element, and
    rarely used directly. *)

val node : string -> attribute list -> element list -> element
(** The function to create an HTML DOM Node.

    It takes a tag name, a list of attributes, and a list of child elements to
    create an HTML node.

    {[
      let link : JSX.element =
        JSX.node
          ( "a",
            [ ("href", `String "https://ocaml.org") ],
            [ JSX.string "OCaml" ] )
    ]} *)

val null : element
(** Helper to represent nullability in JSX.

    This is useful to represent and pattern match against null or empty
    elements.

    {[
      let element : JSX.element = JSX.null
    ]} *)

val string : string -> element
(** Helper to represent an element as a string.

    This function allows you to directly render a string as a JSX element.

    {[
      let element : JSX.element = JSX.string "Hello, World!"
    ]} *)

val text : string -> element
[@@deprecated "Use JSX.string instead"]
(** A deprecated function to render a text string.

    This function is deprecated in favor of [JSX.string].

    {[
      let element : JSX.element = JSX.text "Hello, World!"
    ]} *)

val unsafe : string -> element
(** Helper to bypass HTML encoding and treat output as unsafe. This can lead to
    HTML escaping problems, XSS injections, and other security concerns. Use
    with caution.

    A common use case for bypassing the HTML encoding is to render a script o
    style tag.

    {[
      let content: string = "Raw HTML" in
      let script: JSX.element = <script> content </script>
    ]} *)

val escape : Buffer.t -> string -> unit
(** Escape a string and write it directly to a buffer. This escapes ampersand,
    less-than, greater-than, apostrophe, and double-quote characters.

    This is used internally by the PPX for optimized rendering.

    {[
      let buf = Buffer.create 256 in
      JSX.escape buf "<script>";
      Buffer.contents buf (* "&lt;script&gt;" *)
    ]} *)

val write : Buffer.t -> element -> unit
(** Write an element directly to a buffer. This is used internally by the ppx
    for optimized rendering when building HTML strings incrementally.

    {[
      let buf = Buffer.create 256 in
      JSX.write buf (JSX.string "Hello");
      Buffer.contents buf (* "Hello" *)
    ]} *)
