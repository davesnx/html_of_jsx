
  $ ../ppx.sh --output re input.re
  let select_with_wrong_attribute = [%ocaml.error
    "[html_of_jsx] The attribute 'type_' is not valid on a 'select' element.\nHint: Maybe you mean 'typeof'?\n\nIf this is not correct, please open an issue at https://github.com/davesnx/html_of_jsx/issues."
  ];
