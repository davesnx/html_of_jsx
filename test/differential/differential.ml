let failures = ref 0

let compare_cases ~suite opt noopt =
  List.iter2
    (fun (name, opt_html, expected) (name', noopt_html, _) ->
      assert (name = name');
      if opt_html <> noopt_html then (
        incr failures;
        Printf.printf "MISMATCH %s/%s\n  optimized:   %s\n  unoptimized: %s\n"
          suite name opt_html noopt_html
      );
      match expected with
      | Some expected when expected <> noopt_html ->
          incr failures;
          Printf.printf
            "UNEXPECTED %s/%s\n  expected:    %s\n  unoptimized: %s\n" suite
            name expected noopt_html
      | _ ->
          ()
    )
    opt noopt

let () =
  compare_cases ~suite:"core" Corpus_opt.cases Corpus_noopt.cases;
  compare_cases ~suite:"react" Corpus_react_opt.cases Corpus_react_noopt.cases;
  if !failures > 0 then (
    Printf.printf "%d failure(s)\n" !failures;
    exit 1
  )
