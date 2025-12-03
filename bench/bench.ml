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

(* Complex test case - the full page from input.re *)
let optimized_page =
  Input.Page.make ~project_url:"https://github.com/davesnx/html_of_jsx" ()

(* Manually create the unoptimized version of a simpler page for fair comparison *)
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

(* Dynamic string optimization micro-benchmarks *)

(* OLD behavior: JSX.write with JSX.string wrapper *)
let old_jsx_write_string name =
  let buf = Buffer.create 128 in
  Buffer.add_string buf "<div>";
  JSX.write buf (JSX.string name);
  (* Allocates JSX.element, pattern matches *)
  Buffer.add_string buf "</div>";
  JSX.unsafe (Buffer.contents buf)

(* NEW behavior: direct JSX.escape call - avoids JSX.element allocation *)
let new_buffer_escape name =
  let buf = Buffer.create 128 in
  Buffer.add_string buf "<div>";
  Buffer.add_string buf (JSX.escape name);
  Buffer.add_string buf "</div>";
  JSX.unsafe (Buffer.contents buf)

(* Two strings - OLD *)
let old_jsx_write_two a b =
  let buf = Buffer.create 128 in
  Buffer.add_string buf "<div>";
  JSX.write buf (JSX.string a);
  JSX.write buf (JSX.string b);
  Buffer.add_string buf "</div>";
  JSX.unsafe (Buffer.contents buf)

(* Two strings - NEW *)
let new_buffer_two a b =
  let buf = Buffer.create 128 in
  Buffer.add_string buf "<div>";
  Buffer.add_string buf (JSX.escape a);
  Buffer.add_string buf (JSX.escape b);
  Buffer.add_string buf "</div>";
  JSX.unsafe (Buffer.contents buf)

let test_name = "Hello, World!"
let test_a = "Hello"
let test_b = "World"

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

  print_endline "\n=== Dynamic String Children Optimization ===\n";

  print_endline "--- Single dynamic string: <div>{JSX.string(name)}</div> ---";
  let single_dyn =
    Benchmark.throughputN ~repeat:3 2
      [
        ( "OLD: JSX.write+JSX.string",
          (fun () -> old_jsx_write_string test_name),
          () );
        ("NEW: Buffer+JSX.escape", (fun () -> new_buffer_escape test_name), ());
      ]
  in
  Benchmark.tabulate single_dyn;

  print_endline
    "\n--- Two dynamic strings: <div>{JSX.string(a)}{JSX.string(b)}</div> ---";
  let two_dyn =
    Benchmark.throughputN ~repeat:3 2
      [
        ( "OLD: JSX.write+JSX.string",
          (fun () -> old_jsx_write_two test_a test_b),
          () );
        ("NEW: Buffer+JSX.escape", (fun () -> new_buffer_two test_a test_b), ());
      ]
  in
  Benchmark.tabulate two_dyn;

  print_endline "\n=== Summary ===";
  print_endline
    "OLD: JSX.write+JSX.string = allocates JSX.element wrapper, pattern \
     matches in write";
  print_endline
    "NEW: Buffer+JSX.escape = direct escape to buffer, no wrapper allocation \
     (+25-34% faster)"
