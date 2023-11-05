Since we generate invalid syntax for the argument of the make fn `(Props : <>)`
We need to output ML syntax here, otherwise refmt could not parse it.
  $ ../ppx.sh --output ml input.re
  let hello ~lola = Jsx.node "div" [] [ React.string lola ]
  let react_component_with_props = hello ~lola:"flores" ()
