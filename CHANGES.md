# Changes

## 0.0.5

- Make tests run in FreeBSD (https://github.com/davesnx/html_of_jsx/issues/22) (@davesnx)
- Fix: prefix with Stdlib all ppx generated code (https://github.com/davesnx/html_of_jsx/pull/23) (@tjdevries)
- Allow react attributes as props (via -react flag) (https://github.com/davesnx/html_of_jsx/pull#26) (@davesnx)
- Documentation: pushed old "features" document into the main index as seen https://davesnx.github.io/html_of_jsx/html_of_jsx/index.html

## 0.0.4

- [BREAKING] Handle HTML encoding for `'` (@davesnx)
- Handle HTML encoding for `"` (from `&#34;` to `&quot;`) (@davesnx)
- Improved performance of `JSX.render` (@davesnx)
- [BREAKING] Remove `Fragment` in favor of `JSX.list` (@davesnx)
- Remove unused `Component (unit -> element)` since it isn't needed (@davesnx)
- [BREAKING] Change attributes representation (@andreypopp)
- [BREAKING] Remove melange dependency (@andreypopp)
- [BREAKING] Lower the OCaml bound to 4.14 (@davesnx)
- Make lib wrapped (@andreypopp)

## 0.0.3

- [BREAKING] `Html_of_jsx.render` lives under `JSX.render` (removing the `Html_of_jsx` module entirely) (@lessp)
- [BREAKING] Module `Jsx` is turned into `JSX` (@lessp)
- [BREAKING] dune's library is now `html_of_jsx` instead of (`html_of_jsx.lib`) (@lessp)
- [BREAKING] `JSX.element` is opaque (can't see the type from outside), but we have a `JSX.Debug` module to inspect and re-construct `JSX.element` (cc @leostera) (@lessp)
- Improved performance of `JSX.render` (@lessp)
- add `hx-trigger` to htmx ppx #13 (@lessp)
- `htmlFor` -> `for_` (@lessp)
- Fix aria-autocomplete (@davesnx)

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
