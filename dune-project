(lang dune 3.15)
(generate_opam_files true)
(implicit_transitive_deps false)
(using melange 0.1)

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
  (reason (>= 3.10.0))
  (ppxlib (> 0.23.0))
  melange

  ;; Test dependencies
  (alcotest :with-test)
  (benchmark :with-test)

  ;; Documentation
  (odoc :with-doc)

  ;; Dev dependencies
  (ocamlformat
   (and
    (= 0.26.1) (or
    :with-dev-setup :with-test)))
  (ocaml-lsp-server :with-dev-setup)
  (tiny_httpd :with-dev-setup)
))
