![Html_of_jsx logo](./docs/logo-white.png#gh-dark-mode-only)
![Html_of_jsx logo](./docs/logo-black.png#gh-light-mode-only)

**html_of_jsx** is an implementation of JSX designed to render HTML on the server, without React or anything else. It's a minimal library that allows you to write components of HTML in a declarative way.

- Supports most of features from [JSX](https://reasonml.github.io/docs/en/jsx) (uppercase components, fragments, optional attributes, punning)
- but with a few improvements (lowercase components, no need to add annotations)
- No React idioms (no `className`, no `htmlFor`, no `onChange`, etc...)
- Type-safe, validates attributes and their types ([it can be better thought](https://github.com/davesnx/html_of_jsx/issues/2))
- Minimal
  - `Html_of_jsx.render` to render an element to HTML
  - `Jsx.*` to construct DOM Elements and DOM nodes (`Jsx.text`, `Jsx.int`, `Jsx.null`, `Jsx.list`)
- Works with OCaml, [Reason](https://reasonml.github.io) and [mlx](https://github.com/andreypopp/mlx)
- Integrates very well with Htmx

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
let element = <a href="https://x.com/davesnx">
  <span> {"Click me!"} </span>
</a>

let html: string = Html_of_jsx.render(element);
```

Check the [demo/server.re](./demo/server.re) file to see a full example.

## [Documentation](https://davesnx.github.io/html_of_jsx/html_of_jsx/index.html)

Check the [Documentation](https://davesnx.github.io/html_of_jsx/html_of_jsx/index.html) to know more about the API and it's [features](https://davesnx.github.io/html_of_jsx/html_of_jsx/features.html).

## Credits

This library was born from [server-reason-react](https://github.com/ml-in-barcelona/server-reason-react), extracted and simplified to work with HTML5.
