  $ cat > input.re << EOF
  > let this_should_be_ok = <div className="random" />;
  > EOF

  $ ../ppx.sh --output re --flags="-react" input.re
  let this_should_be_ok = JSX.unsafe("<div class=\"random\"></div>");
