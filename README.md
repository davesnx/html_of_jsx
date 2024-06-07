![Html_of_jsx logo](./docs/logo-white.png#gh-dark-mode-only)
![Html_of_jsx logo](./docs/logo-black.png#gh-light-mode-only)

### Render HTML with JSX

**html_of_jsx** is a JSX transformation to write HTML declaratively in [OCaml](https://ocaml.org), [Reason](https://reasonml.github.io) and [mlx](https://github.com/ocaml-mlx/mlx).

## Features

- Brings the component model to HTML
- Supports most of features from [JSX](https://reasonml.github.io/docs/en/jsx) (uppercase components, fragments, optional attributes, punning)
- but with a few improvements (lowercase components, no need to add annotations)
- No React idioms (no `className`, no `htmlFor`, no `onChange`, etc...)
- Integrates well with [htmx](https://htmx.org)
- Type-safe, validates attributes and their types ([it can be better thought](https://github.com/davesnx/html_of_jsx/issues/2))
- Works with [OCaml](https://ocaml.org), [Reason](https://reasonml.github.io) and [mlx](https://github.com/ocaml-mlx/mlx)
- Minimal
  - `JSX.render` to render a JSX element to a HTML string
  - `JSX.*` to construct DOM Elements and DOM nodes (`JSX.string`, `JSX.int`, `JSX.null`, `JSX.list`)
- Created to work on the server-side, but can be used on the client-side too (with [Melange](https://melange.re))

## Installation

```sh
opam install html_of_jsx
```

```diff
+ (library html_of_jsx.lib)
+ (preprocess (pps html_of_jsx.ppx))
```

## Usage

```reason
let element: JSX.element = <a href="https://x.com/davesnx">
  <span> {"Click me!"} </span>
</a>

let html: string = JSX.render(element);
```

Check the [demo/server.re](./demo/server.re) file to see a full example.

## [Documentation](https://davesnx.github.io/html_of_jsx/html_of_jsx/index.html)

Check the [Documentation](https://davesnx.github.io/html_of_jsx/html_of_jsx/index.html) to know more about the API and [features](https://davesnx.github.io/html_of_jsx/html_of_jsx/features.html).

## Credits

This library was extracted from [server-reason-react](https://github.com/ml-in-barcelona/server-reason-react) and later simplified to work only with HTML5.
