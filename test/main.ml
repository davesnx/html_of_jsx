let () =
  Alcotest.run "html_of_jsx"
    [ Test_without_transformation.tests; Test_reason.tests; Test_htmx.tests ]
