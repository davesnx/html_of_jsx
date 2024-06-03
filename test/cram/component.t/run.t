Since we generate invalid syntax for the argument of the make fn `(Props : <>)`
We need to output ML syntax here, otherwise refmt could not parse it.
  $ ../ppx.sh --output ml input.re
  let hello ~lola = Jsx.node "div" [] [ React.string lola ]
  let react_component_with_props = hello ~lola:"flores" ()
  
  let cositas ?lola =
    match lola with
    | ((Some lola) [@explicit_arity]) -> Jsx.node "div" [] [ React.string lola ]
    | None -> Jsx.node "div" [] [ React.string "no lola" ]
  
  let react_component_with_optional_prop = hello ?lola:"flores" ()
  
  let div =
    Jsx.fragment
      [
        Jsx.node "div"
          (List.filter_map Fun.id
             [ Some (Jsx.Attribute.String ("class", ("md:w-1/3" : string))) ])
          [];
        Jsx.node "div"
          (List.filter_map Fun.id
             [ Some (Jsx.Attribute.String ("class", ("md:w-2/3" : string))) ])
          [];
      ]
  
  let component = Container.make ~children:(Jsx.node "span" [] []) ()
