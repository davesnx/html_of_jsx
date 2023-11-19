let () =
  Alcotest.run "Suite JSX"
    [ Test_without_transformation.tests; Test_reason.tests; Test_htmx.tests ]
