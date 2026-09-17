Since we generate invalid syntax for the argument of the make fn `(Props : <>)`
We need to output ML syntax here, otherwise refmt could not parse it.
  $ ../ppx.sh --output ml input.re
  let hello ~lola =
    let __html_v1 = React.string lola in
    JSX.writer 75 (fun __html_buf ->
        Buffer.add_string __html_buf "<div>";
        JSX.write __html_buf __html_v1;
        Buffer.add_string __html_buf "</div>";
        ())
  
  let react_component_with_props = hello ~lola:"flores" ()
  
  let cositas ?lola =
    match lola with
    | ((Some lola) [@explicit_arity]) ->
        let __html_v2 = React.string lola in
        JSX.writer 75 (fun __html_buf ->
            Buffer.add_string __html_buf "<div>";
            JSX.write __html_buf __html_v2;
            Buffer.add_string __html_buf "</div>";
            ())
    | None ->
        let __html_v3 = React.string "no lola" in
        JSX.writer 75 (fun __html_buf ->
            Buffer.add_string __html_buf "<div>";
            JSX.write __html_buf __html_v3;
            Buffer.add_string __html_buf "</div>";
            ())
  
  let react_component_with_optional_prop = hello ?lola:"flores" ()
  
  let div =
    JSX.unsafe "<div class=\"md:w-1/3\"></div><div class=\"md:w-2/3\"></div>"
  
  let component = Container.make ~children:(JSX.unsafe "<span></span>") ()
