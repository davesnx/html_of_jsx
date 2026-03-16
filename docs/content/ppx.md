
# ppx

The `html_of_jsx.ppx` preprocessor transforms JSX syntax into efficient HTML rendering code, validating attributes and their types at compile time.


## Settings

Pass flags after `html_of_jsx.ppx` in your dune `(preprocess ...)` stanza.


### `-htmx`

Enables htmx attributes (`hx_get`, `hx_post`, `hx_swap`, ...) and extension-specific attributes (`sse_connect`, `ws_send`, ...) on all HTML elements.

```dune
(preprocess (pps html_of_jsx.ppx -htmx))
```
Requires the `html_of_jsx.htmx` library for the `<Htmx />` script loader. See [`HTMX-mode`](./HTMX-mode.md).


### `-react`

Enables React DOM aliases: `className` maps to `class` and `htmlFor` maps to `for`. Useful as a migration bridge from React/Reason-React codebases.

```dune
(preprocess (pps html_of_jsx.ppx -react))
```
See [`React-compatibility`](./React-compatibility.md).


### `-disable-static-opt`

Disables compile-time static analysis and optimization. Every element falls back to the generic `JSX.node` constructor. Useful for debugging the ppx output.

```dune
(preprocess (pps html_of_jsx.ppx -disable-static-opt))
```
For details on what the static optimization does, see [`how-ppx-works`](./how-ppx-works.md).
