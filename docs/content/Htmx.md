
# Module `Htmx`

```
val make : ?version:string -> ?integrity:string -> unit -> JSX.element
```
Render a script tag that loads htmx from unpkg CDN.

```ocaml
  <Htmx version="2.0.4" />
  (* <script src="https://unpkg.com/htmx.org@2.0.4"></script> *)
```
When `integrity` is provided, adds `integrity` and `crossorigin="anonymous"` attributes for subresource integrity.

```
module Extensions : sig ... end
```