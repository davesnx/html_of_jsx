  $ cat > input.re << EOF
  > let this_should_be_ok = <div className="random" />;
  > EOF

  $ ../ppx.sh --output re --flags="-react" input.re
  let this_should_be_ok =
    JSX.node(
      "div",
      Stdlib.List.filter_map(
        Stdlib.Fun.id,
        [Some(("class", `String("random": string)))],
      ),
      [],
    );
