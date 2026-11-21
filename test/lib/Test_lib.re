let test = (title, fn) => Alcotest.test_case(title, `Quick, fn);

let assert_string = (left, right) => {
  Alcotest.check(Alcotest.string, "should be equal", right, left);
};
