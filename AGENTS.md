## Learned User Preferences

- OCaml keyword conflicts in polyvariants: append underscore (`done_`, `lazy_`)
- Hyphens/slashes in attribute names become underscores (`aria-checked` → `aria_checked`)
- OCaml library for server-side HTML rendering via JSX (Reason and mlx syntax)
- PPX validates HTML/SVG/ARIA attribute names and types at compile time
- PPX flags: `-htmx` (htmx attributes), `-react` (React aliases), `-disable-static-opt` (debug)
- Attribute type system: String, Int, Bool, BooleanishString, Style, Polyvariant
- Polyvariant entries use `{ type_; jsxName }` — `type_` is the HTML value, `jsxName` the OCaml identifier
- Documentation lives in `docs/*.mld`, built with `dune build @doc-markdown`; the docs site generator is `site/main.mlx` (`main.exe`, YoCaml) and consumes odoc markdown from `_build/default/_doc/_markdown/html_of_jsx/`
- Build commands: `make build`, `make test`, `make docs-site`, `make docs-site-serve`
- Opam switch is local to the project directory; run `eval $(opam env --switch=. --set-switch)` first
- Htmx support includes `Htmx.Extensions.{sse,ws,class_tools,preload,path_deps,loading_states,response_targets,head_support}` helpers for loading extension scripts; each emits a `<script src="https://unpkg.com/htmx-ext-...">` tag. JSX usage: `<Htmx.Extensions.sse version="2.2.2" />` (lowercase function names; nested submodules were collapsed to keep odoc-generated docs to a single `Htmx.Extensions` page)
- Skip polyvariant migration for: values starting with numbers, empty strings, uppercase-only casing issues, overly complex multi-value combos
- YoCaml `Yocaml_unix.serve` refresh runs the full site program each request; fast no-op navigations depend on using YoCaml `Action`/`Cache` (mtime-based skips) rather than only raw `Eff` file reads/writes
