![Html_of_jsx logo](./docs/white-on-black.png#gh-dark-mode-only)
![Html_of_jsx logo](./docs/black-on-white.png#gh-light-mode-only)

### Render HTML with JSX

**html_of_jsx** is a JSX transformation and a library to write HTML in [OCaml](https://ocaml.org), [Reason](https://reasonml.github.io) and [mlx](https://github.com/ocaml-mlx/mlx).

## Features

- Brings the *"component model"* to HTML
- Supports all of the Reason's [JSX](https://reasonml.github.io/docs/en/jsx) features (uppercase components, fragments, optional attributes, punning)
- but with a few improvements (lowercase components, no need to add the ppx annotation)
- No React idioms (no `className`, no `htmlFor`, no `onChange`, etc...)
- Integrates well with [htmx](https://htmx.org)
- Type-safe, validates attributes and their types ([it can be better thought](https://github.com/davesnx/html_of_jsx/issues/2))
- Works with [OCaml](https://ocaml.org), [Reason](https://reasonml.github.io) and [mlx](https://github.com/ocaml-mlx/mlx)
- Minimal core API
  - `JSX.render` to render a JSX element to an HTML string
  - Helpers to construct nodes: `JSX.string`, `JSX.int`, `JSX.float`, `JSX.null`, `JSX.list`, `JSX.array`, `JSX.unsafe`
  - Advanced rendering: `JSX.render_to_channel`, `JSX.render_streaming`
- Designed to work on the server, but can be used on the client-side as well (with [Melange](https://melange.re) or [jsoo](https://ocsigen.org/js_of_ocaml/))

## Installation

```sh
opam install html_of_jsx
```

```clojure
(libraries html_of_jsx)
(preprocess (pps html_of_jsx.ppx))
```

## Usage

```reason
let element: JSX.element = <a href="https://x.com/davesnx">
  <span> {"Click me!"} </span>
</a>;

let html: string = JSX.render(element);
/* <a href="https://x.com/davesnx"><span>Click me!</span></a> */
```

Check the [demo/server.re](./demo/server.re) file to see a full example.

## Documentation

- Main docs: [html_of_jsx documentation](https://davesnx.github.io/html_of_jsx/)
- Getting started: setup and first render
- Components: props, children, fragments
- Rendering: string/channel/streaming APIs
- htmx: `-htmx` attributes and extension loaders
- React migration mode: `-react` attribute aliases

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development

```sh
# Install dependencies
make install

# Run tests
make test

# Build the project
make build

# Run the demo server
make demo
```

## Credits

This library was extracted from [server-reason-react](https://github.com/ml-in-barcelona/server-reason-react) and later simplified to work only with HTML5.

## License

[MIT](./LICENSE.md) © [David Sancho](https://github.com/davesnx)
