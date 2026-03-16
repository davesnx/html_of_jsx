
# Getting started


## Installation


### From opam

```bash
opam install html_of_jsx -y
```

### From source (opam pin)

Pin a specific development commit from GitHub:

```bash
opam pin add html_of_jsx.dev "https://github.com/davesnx/html_of_jsx.git#01c813023e432cd4088b86ee21d5c3af2fc63bdc" -y
```

### With the dune package manager

Add `html_of_jsx` to the `depends` field in your `dune-project`:

```dune
(package
 (name my_app)
 (depends
  (ocaml (>= 4.14))
  (html_of_jsx (>= 0.1.0))))
```
Then lock and install:

```bash
dune pkg lock
dune build
```

## Dune setup

Every executable or library that uses JSX needs two things: the runtime library and the PPX preprocessor.

An executable:

```dune
(executable
 (name server)
 (libraries html_of_jsx)
 (preprocess (pps html_of_jsx.ppx)))
```
A library:

```dune
(library
 (name components)
 (libraries html_of_jsx)
 (preprocess (pps html_of_jsx.ppx)))
```
See [`ppx`](./ppx.md) for all available flags.


## Syntax setup

html\_of\_jsx works with two JSX-capable syntaxes: **Reason** and **mlx**.


### Reason

```bash
opam install reason -y
```
Reason files use the `.re` extension and work out of the box with dune.


### mlx

mlx lets you write JSX directly inside OCaml files.

```bash
opam install mlx ocamlformat-mlx ocamlmerlin-mlx -y
```
Add the dialect to your `dune-project`:

```ocaml
(dialect
 (name mlx)
 (implementation
  (extension mlx)
  (merlin_reader mlx)
  (format
   (run ocamlformat-mlx %{input-file}))
  (preprocess
   (run mlx-pp %{input-file}))))
```
Then name your files with the `.mlx` extension instead of `.ml`.


### Editor support

The `vscode-ocaml-platform` extension supports both Reason and mlx out of the box, including syntax highlighting, type information, and go-to-definition.


## Next

- [`core`](./core.md) for basic usage
- [`ppx`](./ppx.md) for ppx flags
- [`dream`](./dream.md) to integrate with Dream
- [`how-ppx-works`](./how-ppx-works.md) for a closer look at the JSX transformation.