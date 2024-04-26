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
 (synopsis "Render HTML with JSX")
 (description "html_of_jsx is an implementation of JSX designed to render HTML on the server, without React or anything else. It's a minimal library that allows you to write components of HTML in a declarative way.")
 (depends
  (ocaml (>= 5.0.0))
  (reason (>= 3.10.0))
  (ppxlib (> 0.23.0))

  ;; Test dependencies
  (alcotest :with-test)

  ;; Documentation
  (odoc :with-doc)

  ;; Dev dependencies
  (ocamlformat
   (and
    (= 0.26.1)
    :with-dev-setup))
  (ocaml-lsp-server :with-dev-setup)
  (tiny_httpd :with-dev-setup)
))
