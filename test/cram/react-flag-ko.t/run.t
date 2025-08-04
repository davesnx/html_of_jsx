  $ cat > input.re << EOF
  > let this_should_be_ko = <div className="random" />;
  > EOF

  $ ../ppx.sh --output re input.re
  let this_should_be_ko = [%ocaml.error
    "[html_of_jsx] The attribute 'className' is not valid on a 'div' element.\n\nIf this is not correct, please open an issue at https://github.com/davesnx/html_of_jsx/issues."
  ];
