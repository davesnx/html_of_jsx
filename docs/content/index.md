
# html\_of\_jsx

A JSX transformation and a library to write HTML in [Reason](https://reasonml.github.io) and [mlx](https://github.com/ocaml-mlx/mlx).


## Features

- Brings the *"component model"* to HTML
- Supports all of Reason's [JSX](https://reasonml.github.io/docs/en/jsx) features (uppercase components, fragments, optional attributes, punning) with a few improvements (lowercase components, no ppx annotation needed)
- Works with [Reason](https://reasonml.github.io) and [mlx](https://github.com/ocaml-mlx/mlx)
- **Type-safe**: each element only accepts its valid attributes, and attribute values are checked at compile time
- Sticks to HTML standard attributes: No React idioms (`className`, `htmlFor`, etc.)
- Integrates well with [htmx](https://htmx.org)
- Minimal core API
  
  - `JSX.render` to render a JSX element to an HTML string
  - Helpers: `JSX.string`, `JSX.stringf`, `JSX.int`, `JSX.float`, `JSX.null`, `JSX.list`, `JSX.array`, `JSX.unsafe`
  - Advanced rendering: `JSX.render_to_channel`, `JSX.render_streaming`
- Designed to work on the server, but can be used on the client side as well (with [Melange](https://melange.re) or [js\_of\_ocaml](https://ocsigen.org/js_of_ocaml/))

## Installation

```bash
opam install html_of_jsx -y
```
```dune
(libraries html_of_jsx)
(preprocess (pps html_of_jsx.ppx))
```
See [Getting started](./getting-started.md) for dune package manager, opam pin, and syntax setup.


## Usage

```reasonml
let element = <a href="https://x.com/davesnx">
  <span> {JSX.string("Click me!")} </span>
</a>;

let html = JSX.render(element);
/* <a href="https://x.com/davesnx"><span>Click me!</span></a> */
```
```mlx
let element = <a href="https://x.com/davesnx">
  <span>(JSX.string "Click me!")</span>
</a>

let html= JSX.render element
(* <a href="https://x.com/davesnx"><span>Click me!</span></a> *)
```
See [Core API](./core.md) for elements, children, components, and rendering.


## Credits

This library was extracted from [server-reason-react](https://github.com/ml-in-barcelona/server-reason-react) and later simplified to work only with HTML5.


## Links

- GitHub: [davesnx/html\_of\_jsx](https://github.com/davesnx/html_of_jsx)
- X: [x.com/davesnx](https://x.com/davesnx)
- OPAM: [html\_of\_jsx](https://opam.ocaml.org/packages/html_of_jsx/)
- Performance: [Making html\_of\_jsx 10x faster](https://sancho.dev/blog/making-html-of-jsx-10x-faster)

## Documentation

- [Getting started](./getting-started.md) — installation, dune setup, and first component
- [Core API](./core.md) — elements, children, and composition
- [ppx settings](./ppx.md) — ppx flags and settings
- [How the ppx works](./how-ppx-works.md) — JSX transformation, static analysis, and performance
- [Dream integration](./dream.md) — integrate with Dream
- [HTMX mode](./HTMX-mode.md) — htmx attributes and extensions
- [React compatibility](./React-compatibility.md) — React DOM prop aliases