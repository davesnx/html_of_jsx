
# html\_of\_jsx

A JSX transformation and a library to write HTML in \<a href="https://reasonml.github.io" target="\_blank" rel="noopener noreferrer"\>Reason\</a\> and \<a href="https://github.com/ocaml-mlx/mlx" target="\_blank" rel="noopener noreferrer"\>mlx\</a\>.


## Features

- Brings the *"component model"* to HTML
- Supports all of Reason's \<a href="https://reasonml.github.io/docs/en/jsx" target="\_blank" rel="noopener noreferrer"\>JSX\</a\> features (uppercase components, fragments, optional attributes, punning) with a few improvements (lowercase components, no ppx annotation needed)
- Works with \<a href="https://reasonml.github.io" target="\_blank" rel="noopener noreferrer"\>Reason\</a\> and \<a href="https://github.com/ocaml-mlx/mlx" target="\_blank" rel="noopener noreferrer"\>mlx\</a\>
- **Type-safe**: each element only accepts its valid attributes, and attribute values are checked at compile time
- Sticks to HTML standard attributes: No React idioms (`className`, `htmlFor`, etc.)
- Integrates well with \<a href="https://htmx.org" target="\_blank" rel="noopener noreferrer"\>htmx\</a\>
- Minimal core API
  
  - `JSX.render` to render a JSX element to an HTML string
  - Helpers: `JSX.string`, `JSX.int`, `JSX.float`, `JSX.null`, `JSX.list`, `JSX.array`, `JSX.unsafe`
  - Advanced rendering: `JSX.render_to_channel`, `JSX.render_streaming`
- Designed to work on the server, but can be used on the client side as well (with \<a href="https://melange.re" target="\_blank" rel="noopener noreferrer"\>Melange\</a\> or \<a href="https://ocsigen.org/js\_of\_ocaml/" target="\_blank" rel="noopener noreferrer"\>js\_of\_ocaml\</a\>)

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

This library was extracted from \<a href="https://github.com/ml-in-barcelona/server-reason-react" target="\_blank" rel="noopener noreferrer"\>server-reason-react\</a\> and later simplified to work only with HTML5.


## Links

- GitHub: \<a href="https://github.com/davesnx/html\_of\_jsx" target="\_blank" rel="noopener noreferrer"\>davesnx/html\_of\_jsx\</a\>
- X: \<a href="https://x.com/davesnx" target="\_blank" rel="noopener noreferrer"\>x.com/davesnx\</a\>
- OPAM: \<a href="https://opam.ocaml.org/packages/html\_of\_jsx/" target="\_blank" rel="noopener noreferrer"\>html\_of\_jsx\</a\>
- Performance: \<a href="https://sancho.dev/blog/making-html-of-jsx-10x-faster" target="\_blank" rel="noopener noreferrer"\>Making html\_of\_jsx 10x faster\</a\>

## Documentation

- [Getting started](./getting-started.md) — installation, dune setup, and first component
- [Core API](./core.md) — elements, children, and composition
- [ppx settings](./ppx.md) — ppx flags and settings
- [How the ppx works](./how-ppx-works.md) — JSX transformation, static analysis, and performance
- [Dream integration](./dream.md) — integrate with Dream
- [HTMX mode](./HTMX-mode.md) — htmx attributes and extensions
- [React compatibility](./React-compatibility.md) — React DOM prop aliases