Since we generate invalid syntax for the argument of the make fn `(Props : <>)`
We need to output ML syntax here, otherwise refmt could not parse it.
  $ ../ppx.sh --output ml input.re
  let hello ~lola =
    let __html_buf = Buffer.create 128 in
    Buffer.add_string __html_buf "<div>";
    JSX.write __html_buf (React.string lola);
    Buffer.add_string __html_buf "</div>";
    ();
    JSX.unsafe (Buffer.contents __html_buf)
  
  let react_component_with_props = hello ~lola:"flores" ()
  
  let cositas ?lola =
    match lola with
    | ((Some lola) [@explicit_arity]) ->
        let __html_buf = Buffer.create 128 in
        Buffer.add_string __html_buf "<div>";
        JSX.write __html_buf (React.string lola);
        Buffer.add_string __html_buf "</div>";
        ();
        JSX.unsafe (Buffer.contents __html_buf)
    | None ->
        let __html_buf = Buffer.create 128 in
        Buffer.add_string __html_buf "<div>";
        JSX.write __html_buf (React.string "no lola");
        Buffer.add_string __html_buf "</div>";
        ();
        JSX.unsafe (Buffer.contents __html_buf)
  
  let react_component_with_optional_prop = hello ?lola:"flores" ()
  
  let div =
    JSX.list
      [
        JSX.unsafe "<div class=\"md:w-1/3\"></div>";
        JSX.unsafe "<div class=\"md:w-2/3\"></div>";
      ]
  
  let component = Container.make ~children:(JSX.unsafe "<span></span>") ()
