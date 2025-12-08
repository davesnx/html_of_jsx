(* Benchmark comparing optimized (JSX.unsafe) vs unoptimized (JSX.node) rendering *)

(* Simple test case - static div with class *)
let optimized_simple = JSX.unsafe {|<div class="container"></div>|}
let unoptimized_simple = JSX.node "div" [ ("class", `String "container") ] []

(* Medium test case - nested static elements *)
let optimized_medium =
  JSX.unsafe
    {|<div class="wrapper"><header><h1>Title</h1></header><main><p>Content here</p></main><footer><span>Footer</span></footer></div>|}

let unoptimized_medium =
  JSX.node "div"
    [ ("class", `String "wrapper") ]
    [
      JSX.node "header" [] [ JSX.node "h1" [] [ JSX.string "Title" ] ];
      JSX.node "main" [] [ JSX.node "p" [] [ JSX.string "Content here" ] ];
      JSX.node "footer" [] [ JSX.node "span" [] [ JSX.string "Footer" ] ];
    ]

let optimized_page =
  Input.Page.make ~project_url:"https://github.com/davesnx/html_of_jsx" ()

(* the same page as input.re, but created manually to create the unoptimized version for fair comparison *)
let unoptimized_page =
  let styles_dark = "color-scheme: dark" in
  let styles_body =
    "display: flex; justify-items: center; padding-top: 7em; padding-left: \
     25%; padding-right: 25%"
  in
  let styles_h1 =
    "font-weight: 500; font-size: calc((((((0.7rem + 0.13vw) * 1.25) * 1.25) * \
     1.25) * 1.25) * 1.25); letter-spacing: 0.8px; line-height: 2; margin: 0; \
     padding: 0"
  in
  JSX.node "html"
    [ ("lang", `String "en"); ("style", `String styles_dark) ]
    [
      JSX.node "head" []
        [
          JSX.node "meta" [ ("charset", `String "UTF-8") ] [];
          JSX.node "meta"
            [
              ("name", `String "viewport");
              ("content", `String "width=device-width, initial-scale=1.0");
            ]
            [];
          JSX.node "title" [] [ JSX.string "HTML OF JSX" ];
          JSX.node "link"
            [
              ("rel", `String "shortcut icon");
              ("href", `String "https://reasonml.github.io/img/icon_50.png");
            ]
            [];
        ];
      JSX.node "body"
        [ ("style", `String styles_body) ]
        [
          JSX.node "div" []
            [
              JSX.node "main" []
                [
                  JSX.node "header" []
                    [
                      JSX.node "div" []
                        [
                          JSX.node "a"
                            [
                              ( "href",
                                `String "https://github.com/davesnx/html_of_jsx"
                              );
                            ]
                            [
                              JSX.node "p" []
                                [
                                  JSX.string
                                    "https://github.com/davesnx/html_of_jsx";
                                ];
                            ];
                          JSX.node "div" []
                            [
                              JSX.node "span" [] [ JSX.string "by " ];
                              JSX.node "a"
                                [ ("href", `String "https://x.com/davesnx") ]
                                [ JSX.string "@davesnx" ];
                            ];
                        ];
                    ];
                ];
              JSX.node "div" []
                [
                  JSX.node "main" []
                    [
                      JSX.node "div" []
                        [
                          JSX.node "div" []
                            [
                              JSX.node "h1"
                                [ ("style", `String styles_h1) ]
                                [ JSX.string "Html_of_jsx" ];
                            ];
                          JSX.node "div" []
                            [
                              JSX.node "div" []
                                [
                                  JSX.node "p" []
                                    [
                                      JSX.node "span" []
                                        [ JSX.string "html_of_jsx" ];
                                      JSX.node "span" []
                                        [
                                          JSX.string
                                            " is an implementation of JSX \
                                             designed to render HTML on the \
                                             server.";
                                        ];
                                    ];
                                  JSX.node "p" []
                                    [
                                      JSX.string "Check the ";
                                      JSX.node "a"
                                        [
                                          ( "href",
                                            `String
                                              "https://davesnx.github.io/html_of_jsx/html_of_jsx/index.html"
                                          );
                                        ]
                                        [ JSX.string "Documentation" ];
                                    ];
                                ];
                            ];
                        ];
                    ];
                ];
            ];
        ];
    ]

(* ============================================================ *)
(* Three escape implementations to compare                      *)
(* ============================================================ *)

(* 1. Loop everything: flush-based, always scans entire string *)
let escape_loop_all buf s =
  let len = String.length s in
  let max_idx = len - 1 in
  let flush start i =
    if start < len then Buffer.add_substring buf s start (i - start)
  in
  let rec loop start i =
    if i > max_idx then flush start i
    else
      let next = i + 1 in
      match String.get s i with
      | '&' ->
          flush start i;
          Buffer.add_string buf "&amp;";
          loop next next
      | '<' ->
          flush start i;
          Buffer.add_string buf "&lt;";
          loop next next
      | '>' ->
          flush start i;
          Buffer.add_string buf "&gt;";
          loop next next
      | '\'' ->
          flush start i;
          Buffer.add_string buf "&apos;";
          loop next next
      | '"' ->
          flush start i;
          Buffer.add_string buf "&quot;";
          loop next next
      | _ -> loop start next
  in
  loop 0 0

(* 2. Exception-based: single pass with early exit via exception *)
let escape_exception buf s =
  let len = String.length s in
  let exception Needs_escape of int in
  try
    for i = 0 to len - 1 do
      match String.unsafe_get s i with
      | '&' | '<' | '>' | '\'' | '"' -> raise (Needs_escape i)
      | _ -> ()
    done;
    Buffer.add_string buf s
  with Needs_escape start ->
    if start > 0 then Buffer.add_substring buf s 0 start;
    for i = start to len - 1 do
      match String.unsafe_get s i with
      | '&' -> Buffer.add_string buf "&amp;"
      | '<' -> Buffer.add_string buf "&lt;"
      | '>' -> Buffer.add_string buf "&gt;"
      | '\'' -> Buffer.add_string buf "&apos;"
      | '"' -> Buffer.add_string buf "&quot;"
      | c -> Buffer.add_char buf c
    done

(* 3. Tail-recursive: current JSX.escape implementation *)
let escape_tailrec = JSX.escape

(* 4. Hybrid: fast path check + flush-based batching *)
let rec find_first s len i =
  if i >= len then -1
  else
    match String.unsafe_get s i with
    | '&' | '<' | '>' | '\'' | '"' -> i
    | _ -> find_first s len (i + 1)

let escape_raphael buf s =
  let len = String.length s in
  let rec go i =
    if i >= len then ()
    else
      let first = find_first s len i in
      if first < 0 then Buffer.add_substring buf s i (len - i)
      else begin
        if first > i then Buffer.add_substring buf s i (first - i);
        (match String.unsafe_get s first with
        | '&' -> Buffer.add_string buf "&amp;"
        | '<' -> Buffer.add_string buf "&lt;"
        | '>' -> Buffer.add_string buf "&gt;"
        | '\'' -> Buffer.add_string buf "&apos;"
        | '"' -> Buffer.add_string buf "&quot;"
        | _ -> ());
        go (first + 1)
      end
  in
  go 0

(* ============================================================ *)
(* Benchmark helpers using each implementation                  *)
(* ============================================================ *)

let with_loop_all name =
  let buf = Buffer.create 128 in
  Buffer.add_string buf "<div>";
  escape_loop_all buf name;
  Buffer.add_string buf "</div>";
  JSX.unsafe (Buffer.contents buf)

let with_exception name =
  let buf = Buffer.create 128 in
  Buffer.add_string buf "<div>";
  escape_exception buf name;
  Buffer.add_string buf "</div>";
  JSX.unsafe (Buffer.contents buf)

let with_tailrec name =
  let buf = Buffer.create 128 in
  Buffer.add_string buf "<div>";
  escape_tailrec buf name;
  Buffer.add_string buf "</div>";
  JSX.unsafe (Buffer.contents buf)

let two_loop_all a b =
  let buf = Buffer.create 128 in
  Buffer.add_string buf "<div>";
  escape_loop_all buf a;
  escape_loop_all buf b;
  Buffer.add_string buf "</div>";
  JSX.unsafe (Buffer.contents buf)

let two_exception a b =
  let buf = Buffer.create 128 in
  Buffer.add_string buf "<div>";
  escape_exception buf a;
  escape_exception buf b;
  Buffer.add_string buf "</div>";
  JSX.unsafe (Buffer.contents buf)

let two_tailrec a b =
  let buf = Buffer.create 128 in
  Buffer.add_string buf "<div>";
  escape_tailrec buf a;
  escape_tailrec buf b;
  Buffer.add_string buf "</div>";
  JSX.unsafe (Buffer.contents buf)

let with_raphael name =
  let buf = Buffer.create 128 in
  Buffer.add_string buf "<div>";
  escape_raphael buf name;
  Buffer.add_string buf "</div>";
  JSX.unsafe (Buffer.contents buf)

let two_raphael a b =
  let buf = Buffer.create 128 in
  Buffer.add_string buf "<div>";
  escape_raphael buf a;
  escape_raphael buf b;
  Buffer.add_string buf "</div>";
  JSX.unsafe (Buffer.contents buf)

let test_name = "Hello, World!"
let test_a = "Hello"
let test_b = "World"

(* Strings that require escaping *)
let escape_name = "<script>alert('XSS')</script>"
let escape_a = "a < b && c > d"
let escape_b = "\"quoted\" & 'apostrophe'"

let () =
  print_endline "=== Static JSX Optimization Benchmark ===\n";

  print_endline "--- Simple case: <div class=\"container\"></div> ---";
  let simple_result =
    Benchmark.throughputN ~repeat:3 3
      [
        ("optimized (JSX.unsafe)", JSX.render, optimized_simple);
        ("unoptimized (JSX.node)", JSX.render, unoptimized_simple);
      ]
  in
  Benchmark.tabulate simple_result;

  print_endline "\n--- Medium case: Nested static HTML ---";
  let medium_result =
    Benchmark.throughputN ~repeat:3 3
      [
        ("optimized (JSX.unsafe)", JSX.render, optimized_medium);
        ("unoptimized (JSX.node)", JSX.render, unoptimized_medium);
      ]
  in
  Benchmark.tabulate medium_result;

  print_endline "\n--- Complex case: Full page (simplified) ---";
  let page_result =
    Benchmark.throughputN ~repeat:3 5
      [
        ("optimized (JSX.unsafe)", JSX.render, optimized_page);
        ("unoptimized (JSX.node)", JSX.render, unoptimized_page);
      ]
  in
  Benchmark.tabulate page_result;

  print_endline "\n=== Escape Implementation Comparison ===\n";

  print_endline "--- Single string WITHOUT escaping: <div>{name}</div> ---";
  let single_no_escape =
    Benchmark.throughputN ~repeat:3 2
      [
        ("loop_all", (fun () -> with_loop_all test_name), ());
        ("exception", (fun () -> with_exception test_name), ());
        ("tailrec", (fun () -> with_tailrec test_name), ());
        ("raphael", (fun () -> with_raphael test_name), ());
      ]
  in
  Benchmark.tabulate single_no_escape;

  print_endline "\n--- Two strings WITHOUT escaping: <div>{a}{b}</div> ---";
  let two_no_escape =
    Benchmark.throughputN ~repeat:3 2
      [
        ("loop_all", (fun () -> two_loop_all test_a test_b), ());
        ("exception", (fun () -> two_exception test_a test_b), ());
        ("tailrec", (fun () -> two_tailrec test_a test_b), ());
        ("raphael", (fun () -> two_raphael test_a test_b), ());
      ]
  in
  Benchmark.tabulate two_no_escape;

  print_endline "\n--- Single string WITH escaping: <div>{name}</div> ---";
  let single_with_escape =
    Benchmark.throughputN ~repeat:3 2
      [
        ("loop_all", (fun () -> with_loop_all escape_name), ());
        ("exception", (fun () -> with_exception escape_name), ());
        ("tailrec", (fun () -> with_tailrec escape_name), ());
        ("raphael", (fun () -> with_raphael escape_name), ());
      ]
  in
  Benchmark.tabulate single_with_escape;

  print_endline "\n--- Two strings WITH escaping: <div>{a}{b}</div> ---";
  let two_with_escape =
    Benchmark.throughputN ~repeat:3 2
      [
        ("loop_all", (fun () -> two_loop_all escape_a escape_b), ());
        ("exception", (fun () -> two_exception escape_a escape_b), ());
        ("tailrec", (fun () -> two_tailrec escape_a escape_b), ());
        ("raphael", (fun () -> two_raphael escape_a escape_b), ());
      ]
  in
  Benchmark.tabulate two_with_escape;

  print_endline "\n=== Summary ===";
  print_endline "loop_all  = flush-based, always scans entire string";
  print_endline "exception = single pass, early exit via exception";
  print_endline "tailrec   = tail-recursive find + char-by-char loop";
  print_endline "raphael    = tail-recursive find + flush-based batching"
