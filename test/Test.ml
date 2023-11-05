let () =
  Alcotest.run "Suite JSX"
    [ Test_without_transformation.tests; Test_with_reason.tests ]
