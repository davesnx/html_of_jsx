(lang dune 3.16)
(generate_opam_files true)
(implicit_transitive_deps false)

(name html_of_jsx)
(maintainers "David Sancho <dsnxmoreno@gmail.com>")
(authors "David Sancho <dsnxmoreno@gmail.com>")
(license MIT)
(source
 (github davesnx/html_of_jsx))

(package
 (name html_of_jsx)
 ; There's a bug with pushing documentation with dune-release
 ; (documentation https://davesnx.github.io/html_of_jsx/html_of_jsx/index.html)
 (synopsis "Render HTML with JSX")
 (description "html_of_jsx is a JSX transformation that allows you to write HTML declaratively.")
 (depends
  (ocaml (>= 4.14))
  (ppxlib (>= 0.25.0))

  ;; Test dependencies
  (alcotest :with-test)
  (benchmark :with-test)
  (reason (and (>= 3.10.0) :with-test))

  ;; Documentation
  (odoc :with-doc)

  ;; Dev dependencies
  (ocamlformat
   (and
    (= 0.26.1) (or
    :with-dev-setup :with-test)))
  (ocaml-lsp-server :with-dev-setup)
  (tiny_httpd :with-dev-setup)
  (mlx :with-dev-setup)
  (ocamlformat-mlx :with-dev-setup)
))

(dialect
 (name mlx)
 (implementation
  (extension mlx)
  (merlin_reader mlx)
  (format
   (run ocamlformat-mlx %{input-file}))
  (preprocess
   (run mlx-pp %{input-file}))))
