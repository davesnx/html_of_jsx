Since we generate invalid syntax for the argument of the make fn `(Props : <>)`
We need to output ML syntax here, otherwise refmt could not parse it.
  $ ../ppx.sh --output ml input.re
  let hello ~lola = JSX.node "div" [] [ React.string lola ]
  let react_component_with_props = hello ~lola:"flores" ()
  
  let cositas ?lola =
    match lola with
    | ((Some lola) [@explicit_arity]) -> JSX.node "div" [] [ React.string lola ]
    | None -> JSX.node "div" [] [ React.string "no lola" ]
  
  let react_component_with_optional_prop = hello ?lola:"flores" ()
  
  let div =
    JSX.list
      [
        JSX.node "div"
          (Stdlib.List.filter_map Fun.id
             [ Some ("class", `String ("md:w-1/3" : string)) ])
          [];
        JSX.node "div"
          (Stdlib.List.filter_map Fun.id
             [ Some ("class", `String ("md:w-2/3" : string)) ])
          [];
      ]
  
  let component = Container.make ~children:(JSX.node "span" [] []) ()
