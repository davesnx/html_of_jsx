# Changes

## 0.0.2

- Add `Jsx.unsafe` to allow unsafe HTML as children
- Fix HTML attributes formatting (charset, autocomplete, tabindex, inputmode, etc...)
- Enable HTMX attributes via `html_of_jsx.ppx -htmx`

## 0.0.1

- First working version of the ppx and library
- Supports most of features from [JSX](https://reasonml.github.io/docs/en/jsx) (uppercase components, fragments, optional attributes, punning)
- but with a few improvements (lowercase components, no need to add annotations)
- No React idioms (no `className`, no `htmlFor`, no `onChange`, etc...)
- Type-safe, validates attributes and their types ([it can be better thought](https://github.com/davesnx/html_of_jsx/issues/2))
- Minimal
  - `Html_of_jsx.render` to render an element to HTML
  - `Jsx.*` to construct DOM Elements and DOM nodes (`Jsx.text`, `Jsx.int`, `Jsx.null`, `Jsx.list`)
- Works with [Reason](https://reasonml.github.io) and [mlx](https://github.com/andreypopp/mlx)
- Supports some htmx under the ppx (`html_of_jsx.ppx -htmx`)
