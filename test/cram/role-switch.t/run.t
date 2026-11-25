  $ ../ppx.sh --output re input.re
  let switch_role = JSX.unsafe("<div role=\"switch\"></div>");
  $ ../ppx.sh --output re --flags="-disable-static-opt" input.re | grep 'switch_ =>'
              | `switch_ => "switch"
