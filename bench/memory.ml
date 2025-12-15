(* Memory allocation benchmark for html_of_jsx

   Run with: dune exec ./bench/memory.exe

   Measures:
   1. Static object sizes (reachable words)
   2. Allocation costs (minor words allocated during construction)
   3. Comparison between list vs array for attributes
*)

let words_of obj = Obj.reachable_words (Obj.repr obj)

(* Run N iterations and measure total allocation *)
let measure_alloc_n n f =
  Gc.full_major ();
  let before = Gc.stat () in
  for _ = 1 to n do
    ignore (f () : 'a)
  done;
  let after = Gc.stat () in
  let minor_words =
    (after.minor_words -. before.minor_words) /. float_of_int n
  in
  let major_words =
    (after.major_words -. before.major_words) /. float_of_int n
  in
  (minor_words, major_words)

let () =
  Printf.printf "=== Memory Layout Benchmark ===\n\n";
  Printf.printf "--- Part 1: Static Object Sizes (reachable words) ---\n\n";

  (* Use Bytes.to_string to create unique strings and avoid compiler sharing *)
  let make_string s = Bytes.to_string (Bytes.of_string s) in
  let tag1 = make_string "div" in
  let val1 = make_string "container" in
  let val2 = make_string "wrapper" in

  let node_empty = JSX.node tag1 [] [] in
  Printf.printf "Empty Node (JSX.node \"div\" [] []): %d words (reachable)\n"
    (words_of node_empty);
  Printf.printf
    "  Note: includes string \"div\" (~2 words) - node record itself is 4 \
     words\n\n";

  let single_attr : JSX.attribute = (make_string "id", `String val1) in
  Printf.printf "Single attribute (\"id\", `String \"...\"):\n";
  Printf.printf "  Total reachable: %d words\n" (words_of single_attr);
  Printf.printf
    "  Breakdown: tuple header + 2 fields + variant block + string\n\n";

  (* Compare list vs array representation *)
  let attr1 : JSX.attribute = (make_string "id", `String val1) in
  let attr2 : JSX.attribute = (make_string "class", `String val2) in

  let attr_list = [ attr1; attr2 ] in
  let attr_array = [| attr1; attr2 |] in

  Printf.printf "2-element attribute list: %d words\n" (words_of attr_list);
  Printf.printf "2-element attribute array: %d words\n" (words_of attr_array);
  Printf.printf "  Delta (list - array): %d words\n\n"
    (words_of attr_list - words_of attr_array);

  (* More attributes *)
  let make_attr i =
    (Printf.sprintf "attr%d" i, `String (Printf.sprintf "value%d" i))
  in
  let attrs_5_list = List.init 5 make_attr in
  let attrs_5_array = Array.init 5 make_attr in

  Printf.printf "5-element attribute list: %d words\n" (words_of attrs_5_list);
  Printf.printf "5-element attribute array: %d words\n" (words_of attrs_5_array);
  Printf.printf "  Delta: %d words (%.1f words/element overhead for list)\n\n"
    (words_of attrs_5_list - words_of attrs_5_array)
    (float_of_int (words_of attrs_5_list - words_of attrs_5_array) /. 5.);

  Printf.printf "--- Part 2: Allocation Cost (words per construction) ---\n\n";

  let n = 10000 in

  let minor_node, major_node =
    measure_alloc_n n (fun () -> JSX.node "div" [] [])
  in
  Printf.printf "JSX.node \"div\" [] []:\n";
  Printf.printf "  %.1f minor words, %.1f major words\n\n" minor_node major_node;

  let minor_1attr, major_1attr =
    measure_alloc_n n (fun () ->
        JSX.node "div" [ ("class", `String "container") ] [])
  in
  Printf.printf "JSX.node with 1 attribute:\n";
  Printf.printf "  %.1f minor words, %.1f major words\n\n" minor_1attr
    major_1attr;

  let minor_3attr, major_3attr =
    measure_alloc_n n (fun () ->
        JSX.node "div"
          [
            ("class", `String "container");
            ("id", `String "main");
            ("style", `String "color: red");
          ]
          [])
  in
  Printf.printf "JSX.node with 3 attributes:\n";
  Printf.printf "  %.1f minor words, %.1f major words\n\n" minor_3attr
    major_3attr;

  let minor_nested, major_nested =
    measure_alloc_n n (fun () ->
        JSX.node "div"
          [ ("class", `String "wrapper") ]
          [
            JSX.node "span" [] [ JSX.string "Hello" ];
            JSX.node "span" [] [ JSX.string "World" ];
          ])
  in
  Printf.printf
    "Nested: <div class=\"wrapper\"><span>Hello</span><span>World</span></div>:\n";
  Printf.printf "  %.1f minor words, %.1f major words\n\n" minor_nested
    major_nested;

  Printf.printf "--- Part 3: List vs Array Construction Cost ---\n\n";

  (* Use Sys.opaque_identity to prevent compiler from optimizing away allocations *)
  let opaque = Sys.opaque_identity in

  let minor_list_3, _ =
    measure_alloc_n n (fun () ->
        [
          (opaque "a", `String (opaque "1"));
          (opaque "b", `String (opaque "2"));
          (opaque "c", `String (opaque "3"));
        ])
  in
  let minor_array_3, _ =
    measure_alloc_n n (fun () ->
        [|
          (opaque "a", `String (opaque "1"));
          (opaque "b", `String (opaque "2"));
          (opaque "c", `String (opaque "3"));
        |])
  in
  Printf.printf "3-element construction:\n";
  Printf.printf "  List: %.1f words\n" minor_list_3;
  Printf.printf "  Array: %.1f words\n" minor_array_3;
  if minor_list_3 > 0. then
    Printf.printf "  Savings: %.1f words (%.0f%%)\n\n"
      (minor_list_3 -. minor_array_3)
      ((minor_list_3 -. minor_array_3) /. minor_list_3 *. 100.)
  else Printf.printf "  (compiler optimized literals - see note below)\n\n";

  let minor_list_5, _ =
    measure_alloc_n n (fun () ->
        [
          (opaque "a", `String (opaque "1"));
          (opaque "b", `String (opaque "2"));
          (opaque "c", `String (opaque "3"));
          (opaque "d", `String (opaque "4"));
          (opaque "e", `String (opaque "5"));
        ])
  in
  let minor_array_5, _ =
    measure_alloc_n n (fun () ->
        [|
          (opaque "a", `String (opaque "1"));
          (opaque "b", `String (opaque "2"));
          (opaque "c", `String (opaque "3"));
          (opaque "d", `String (opaque "4"));
          (opaque "e", `String (opaque "5"));
        |])
  in
  Printf.printf "5-element construction:\n";
  Printf.printf "  List: %.1f words\n" minor_list_5;
  Printf.printf "  Array: %.1f words\n" minor_array_5;
  if minor_list_5 > 0. then
    Printf.printf "  Savings: %.1f words (%.0f%%)\n\n"
      (minor_list_5 -. minor_array_5)
      ((minor_list_5 -. minor_array_5) /. minor_list_5 *. 100.)
  else Printf.printf "  (compiler optimized literals - see note below)\n\n";

  Printf.printf "--- Part 4: Iteration Cost ---\n\n";

  let test_list = List.init 10 make_attr in
  let test_array = Array.of_list test_list in
  let sum = ref 0 in

  let minor_list_iter, _ =
    measure_alloc_n n (fun () ->
        sum := 0;
        List.iter (fun (k, _) -> sum := !sum + String.length k) test_list)
  in
  let minor_array_iter, _ =
    measure_alloc_n n (fun () ->
        sum := 0;
        Array.iter (fun (k, _) -> sum := !sum + String.length k) test_array)
  in
  Printf.printf "Iterating over 10 elements (no buffer ops):\n";
  Printf.printf "  List.iter: %.1f words\n" minor_list_iter;
  Printf.printf "  Array.iter: %.1f words\n" minor_array_iter;
  Printf.printf "  (Both should be ~0 - iteration itself doesn't allocate)\n";

  Printf.printf "\n--- Part 5: Full Render Allocation ---\n\n";

  let simple_node = JSX.node "div" [ ("class", `String "container") ] [] in
  let minor_render, _ = measure_alloc_n n (fun () -> JSX.render simple_node) in
  Printf.printf "JSX.render of simple node: %.1f words\n" minor_render;

  let optimized = JSX.unsafe {|<div class="container"></div>|} in
  let minor_render_opt, _ =
    measure_alloc_n n (fun () -> JSX.render optimized)
  in
  Printf.printf "JSX.render of JSX.unsafe: %.1f words\n" minor_render_opt;
  Printf.printf "  Savings: %.1f words (%.0f%%)\n\n"
    (minor_render -. minor_render_opt)
    ((minor_render -. minor_render_opt) /. minor_render *. 100.);

  Printf.printf "=== Summary ===\n\n";
  Printf.printf "Node record: 4 words (header + tag + attributes + children)\n";
  Printf.printf "Per-cons-cell overhead: 3 words (header + car + cdr)\n";
  if minor_list_5 > 0. && minor_array_5 > 0. then
    Printf.printf "List vs Array: List uses %.0f%% more allocation\n"
      ((minor_list_5 -. minor_array_5) /. minor_array_5 *. 100.)
  else
    Printf.printf
      "List vs Array: Compiler optimizes static literals (no alloc measured)\n";
  Printf.printf
    "Static optimization (JSX.unsafe) saves ~%.0f%% render allocation\n"
    ((minor_render -. minor_render_opt) /. minor_render *. 100.)
