  $ ../ppx.sh --output re input.re
  let br_with_children = [%ocaml.error
    "[html_of_jsx] <br> is a void element and cannot have children"
  ];
  let input_with_children = [%ocaml.error
    "[html_of_jsx] <input> is a void element and cannot have children"
  ];
  let br_without_children = JSX.unsafe("<br />");

  $ ../ppx.sh --output re --flags="-disable-static-opt" input.re
  let br_with_children = [%ocaml.error
    "[html_of_jsx] <br> is a void element and cannot have children"
  ];
  let input_with_children = [%ocaml.error
    "[html_of_jsx] <input> is a void element and cannot have children"
  ];
  let br_without_children = JSX.node("br", [], []);
