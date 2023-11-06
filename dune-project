(lang dune 3.8)

(cram enable)

(name html_of_jsx)

(license MIT)

(maintainers "David Sancho <dsnxmoreno@gmail.com>")

(authors "David Sancho <dsnxmoreno@gmail.com>")

(source
 (github davesnx/html_of_jsx))

(generate_opam_files true)

(implicit_transitive_deps false)

(package
 (name html_of_jsx)
 (synopsis "Render HTML writing JSX")
 (depends
  (ocaml (>= 5.0.0))
  (reason (>= 3.10.0))
  (ppxlib (and (> 0.23.0) (<= 0.31.0)))

  ;; Test dependencies
  (alcotest :with-test)

  ;; Documentation
  (odoc :with-doc)

  ;; Dev dependencies, using with-test so that consumers don't install them (until package is released in opam)
  (ocamlformat
   (and
    (= 0.26.1)
    :with-test))
  (ocaml-lsp-server :with-test)

  (tiny_httpd :with-test)
))
