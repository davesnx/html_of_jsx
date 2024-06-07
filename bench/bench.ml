let () =
  let html =
    Input.Page.make ~project_url:"https://github.com/davesnx/html_of_jsx" ()
  in

  let result =
    Benchmark.throughputN ~repeat:3 8
      [ ("to_string", JSX.render, html) (* add more benchmarks here *) ]
  in

  print_newline ();
  Benchmark.tabulate result
