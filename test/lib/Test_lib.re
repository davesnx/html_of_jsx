/* Small testing library for common utilities on top of Alcotest, designed to be opened by default via `-open Test_lib` */

let test = (title, fn) => Alcotest.test_case(title, `Quick, fn);

let assert_string = (left, right) => {
  Alcotest.check(Alcotest.string, "should be equal", right, left);
};
