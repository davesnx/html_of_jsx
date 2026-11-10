  $ jsx-ppx-standalone --impl input.ml -o temp.ml
  $ ocamlformat --enable-outside-detected-project --impl temp.ml
  let empty = JSX.list []
  let texts = JSX.unsafe "ab"
  let ident xs = JSX.list xs
  let mapped xs = JSX.list (List.map (fun x -> JSX.string x) xs)
  let empty_spread = JSX.list ([] : JSX.element list)
  
  let nested xs =
    let __html_v1 = JSX.list xs in
    JSX.writer 75 (fun __html_buf ->
        Stdlib.Buffer.add_string __html_buf "<div>";
        JSX.write __html_buf __html_v1;
        Stdlib.Buffer.add_string __html_buf "</div>";
        ())
  
  let call f = JSX.list (f ())
  let comp children = Foo.make () ?children
  let comp2 children = Foo.make () ~title:"x" ?children
  
  let div_opt children =
    [%ocaml.error
      "[html_of_jsx] The attribute 'children' is not valid on a 'div' element.\n\n\
       If this is not correct, please open an issue at \
       https://github.com/davesnx/html_of_jsx/issues."]

  $ jsx-ppx-standalone --impl input.ml -o temp.ml -disable-static-opt
  $ ocamlformat --enable-outside-detected-project --impl temp.ml
  let empty = JSX.list []
  let texts = JSX.list [ JSX.string "a"; JSX.string "b" ]
  let ident xs = JSX.list xs
  let mapped xs = JSX.list (List.map (fun x -> JSX.string x) xs)
  let empty_spread = JSX.list ([] : JSX.element list)
  let nested xs = JSX.node "div" [] [ JSX.list xs ]
  let call f = JSX.list (f ())
  let comp children = Foo.make () ?children
  let comp2 children = Foo.make () ~title:"x" ?children
  
  let div_opt children =
    [%ocaml.error
      "[html_of_jsx] The attribute 'children' is not valid on a 'div' element.\n\n\
       If this is not correct, please open an issue at \
       https://github.com/davesnx/html_of_jsx/issues."]
