# Changes

## Unreleased

- PPX: generated code qualifies stdlib modules with `Stdlib.`, so local modules named `Buffer`, `Float`, `Printf` or `Bool` no longer change the rendered output (@davesnx)
- PPX: `-disable-static-opt` now also disables the fragment optimization (@davesnx)
- PPX: `let` bindings written by the user inside a child expression keep their scope instead of being hoisted into the parent and shadowing later siblings (@davesnx)
- Fix the static optimization treating unqualified `string`, `int`, `float`, `text`, `format` and `unsafe` calls as the `JSX` helpers when they are user-defined; only the qualified `JSX.*` forms are optimized now (@davesnx)
- Fix literal attribute values skipping type checking under the static optimization: `<div hidden="yes" tabindex="x" id=5 />` now fails to compile with an error at the value, and suffixed integer literals (`5l`) are no longer accepted as `int` (@davesnx)
- Fix the PPX crashing with `Failure("int_of_string")` on out-of-range integer literals; the compiler now reports its usual range error (@davesnx)
- Fix the static optimization reordering attributes (static ones first): `<div class_=v tabindex=2 />` now renders attributes in source order, as the unoptimized path does (@davesnx)
- [BREAKING] PPX: a void element (`<br>`, `<input>`, `<img>`, ...) with children is now a compile error instead of rendering `<br>x</br>` when optimized and dropping the children when unoptimized (@davesnx)
- Fix the unoptimized path (`-disable-static-opt` or fallback) evaluating attribute and child expressions right to left: both modes now evaluate attributes then children, left to right (@davesnx)
- Fix `JSX.render_streaming` not flushing after `JSX.int` and `JSX.float` leaves: a long list of numbers was emitted as one chunk (@davesnx)
- `JSX.render_streaming` raises `Invalid_argument`, before writing anything, when `chunk_size` is zero or negative; it used to emit empty chunks (@davesnx)
- [BREAKING] Rendering raises `Invalid_argument` when an attribute name is empty or contains whitespace, a control character, or one of `"`, `'`, `>`, `/`, `=`; it used to write the name unescaped. `render`, `write`, `render_to_channel`, `render_streaming` and `pp` all check it (@davesnx)
- `JSX.pp` prints the content of `pre`, `textarea`, `script` and `style` exactly as `render` does, and keeps inline elements (`a`, `b`, `span`, `code`, `img`, ...) on one line with no added breaks or spaces around them or around text (@davesnx)
- Document that `JSX.float` uses `Float.to_string` and that `JSX.format` gives exact control, and that `JSX.pp` is for reading and debugging (@davesnx)

## 0.1.1

- Fix the static optimization dropping `<!DOCTYPE html>` from `<html>` elements with dynamic attributes or children (@davesnx)
- PPX: elements compile to `JSX.writer` closures that write straight into the parent buffer, removing a buffer and two copies per component boundary; rendering an already built element value now re-runs its writes instead of returning a cached string (@davesnx)
- Fix optional attributes being dropped when the same element also has a dynamic (non-literal) attribute: `<div ?id class_=cls />` rendered without `id` (@davesnx)
- Write integers as digits straight into the render buffer (`JSX.write_int`) instead of allocating `Int.to_string` (@davesnx)
- PPX: emit one `Buffer.add_string` per run of static text around dynamic and optional attributes instead of one call per fragment (@davesnx)

## 0.1.0

- [BREAKING] Component invocations now group multiple children with `JSX.list`, so components receive `JSX.element` for both single and multiple children. `JSX.fragment` now accepts `JSX.element` to follow the same convention. (@davesnx)
- [BREAKING] Renamed `JSX.stringf` -> `JSX.format` (@davesnx)
- Massive PPX compile-time improvement: the HTML attribute database is now built once instead of being reconstructed on every attribute lookup (6-8x faster on attribute-heavy files) (@davesnx)
- Fix escaping of constant `JSX.string` children inside fragments: `<> {JSX.string("<script>")} </>` was inlined without HTML-encoding (@davesnx)
- [BREAKING] Fix ill-typed generated code for optional booleanish attributes (e.g. `?spellcheck`) when the static optimization is disabled (@davesnx)
- Fragments now use the same optimized buffer codegen as elements: constant children collapse at compile time and dynamic children are spliced into a single buffer instead of allocating a `JSX.list` (@davesnx)
- `JSX.render_streaming` now streams for real: chunks are emitted incrementally every `?chunk_size` bytes (default 4096) instead of buffering the whole document (@davesnx)
- `JSX.escape` copies runs of clean characters in bulk instead of char-by-char after the first escape; `JSX.render` returns clean strings and int/float elements without buffer copies (@davesnx)
- The unoptimized attribute path (`-disable-static-opt` or fallback) no longer allocates `Some`/`filter_map` wrappers when no optional attribute is present (@davesnx)
- Benchmarks: scenarios now construct elements inside the timed function (several scenarios previously measured rendering of a prebuilt static string, i.e. a no-op); added a `large-mixed` compile-time fixture that guards against PPX attribute-lookup regressions (@davesnx)
- Add zero-copy fast path in `JSX.render`: `Unsafe`/`Null`/`String` elements skip the intermediate buffer entirely, making rendering of fully optimized trees free (@davesnx)
- PPX buffer splicing: nested JSX elements now write directly into the parent's buffer instead of materializing an intermediate buffer and string per element, cutting render time up to ~50% and allocations up to ~60% on dynamic pages (@davesnx)

## 0.0.9

- Fix `data-attributes` being rendered as `data_-attributes` (@davesnx)
- Add `JSX.pp` for pretty-printing HTML with indentation, powered by `pretty_expressive` (@davesnx)
- Add `JSX.stringf` for escaped `Printf`-style text formatting and teach the PPX to optimize literal-only `stringf` calls at compile time (@davesnx)
- Improve runtime render speed in `JSX.write` by replacing iterator-heavy paths with direct recursion and indexed array traversal (@davesnx)
- Reduce default render buffer sizes (`1024 -> 256`) and improve PPX-generated buffer capacity estimation for dynamic/optional attribute code paths (@davesnx)
- Add a compile-time fast path for static HTML escaping in `ppx/static_analysis.ml` to avoid buffer work when no escaping is required (@davesnx)
- Extend static optimization coverage for dynamic attributes: elements with dynamic attrs and dynamic string/mixed children now generate buffer-based optimized code instead of falling back to `JSX.node` (@davesnx)

## 0.0.8

- Create `html_of_jsx.htmx` library with script and extension support
- Remove temporal string on each JSX.escape, and make escape faster (#9c64ba4)
- Skip escape for Int/Float attribute values (#8e8cf26)
- Adds JSX.array (#3154012)
- Add `Polyvariant` attribute type for type-safe enumerated HTML attributes (e.g. `target`, `loading`, `dir`, `role`, ARIA attributes, SVG attributes)
- Add polyvariant validation test suite (keyword escaping, identifier validity, consistency checks)

## 0.0.7

- Static HTML optimization: elements with static content are now pre-rendered at compile time for ~10x faster rendering (@davesnx)
- Add `-disable-static-opt` flag to disable static HTML optimization (use `JSX.node` for all elements) (@davesnx)
- [BREAKING] Remove `JSX.Debug` module (the opaque `JSX.element` type is no longer inspectable) (@davesnx)

## 0.0.6

- Support OCaml 5.3 (https://github.com/davesnx/html_of_jsx/pull/29) (@davesnx)

## 0.0.5

- Make tests run in FreeBSD (https://github.com/davesnx/html_of_jsx/issues/22) (@davesnx)
- Fix: prefix with Stdlib all ppx generated code (https://github.com/davesnx/html_of_jsx/pull/23) (@tjdevries)
- Allow react attributes as props (via -react flag) (https://github.com/davesnx/html_of_jsx/pull/26) (@davesnx)
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
