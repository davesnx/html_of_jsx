(* Benchmark comparing different optimizations *)

(* ============================================================ *)
(* JSON output support for CI integration                       *)
(* ============================================================ *)

let json_mode = ref false

(* Extract average throughput (ops/sec) from benchmark results *)
let extract_rate samples =
  let total_rate =
    List.fold_left
      (fun acc sample ->
        let rate =
          Int64.to_float sample.Benchmark.iters /. sample.Benchmark.wall
        in
        acc +. rate)
      0.0 samples
  in
  total_rate /. float_of_int (List.length samples)

(* Convert benchmark results to JSON format for github-action-benchmark *)
let results_to_json ~group_name results =
  List.map
    (fun (name, samples) ->
      let rate = extract_rate samples in
      Printf.sprintf {|{"name": "%s/%s", "unit": "ops/sec", "value": %.2f}|}
        group_name name rate)
    results

(* ============================================================ *)
(* 1. Escape function implementations                           *)
(* ============================================================ *)

(* Loop everything: flush-based, always scans entire string *)
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

(* Exception-based: single pass with early exit via exception (current JSX.escape) *)
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

let escape_tailrec = JSX.escape

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
(* Escape benchmark helpers                                     *)
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

let with_raphael name =
  let buf = Buffer.create 128 in
  Buffer.add_string buf "<div>";
  escape_raphael buf name;
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

let two_raphael a b =
  let buf = Buffer.create 128 in
  Buffer.add_string buf "<div>";
  escape_raphael buf a;
  escape_raphael buf b;
  Buffer.add_string buf "</div>";
  JSX.unsafe (Buffer.contents buf)

(* ============================================================ *)
(* Test data                                                    *)
(* ============================================================ *)

let test_name = "Hello, World!"
let test_a = "Hello"
let test_b = "World"
let escape_name = "<script>alert('XSS')</script>"
let escape_a = "a < b && c > d"
let escape_b = "\"quoted\" & 'apostrophe'"

let () =
  (* Parse command line arguments *)
  let args = Array.to_list Sys.argv in
  json_mode := List.mem "--json" args;

  (* ============================================================ *)
  (* ESCAPE FUNCTION COMPARISON                                   *)
  (* ============================================================ *)
  if not !json_mode then
    print_endline "=== 1. Escape Implementation Comparison ===\n";

  (* Use ~style:Nil in JSON mode to suppress verbose output *)
  let style = if !json_mode then Benchmark.Nil else Benchmark.Auto in

  if not !json_mode then print_endline "--- Single string WITHOUT escaping ---";
  let single_no_escape =
    Benchmark.throughputN ~style ~repeat:3 2
      [
        ("loop_all", (fun () -> with_loop_all test_name), ());
        ("exception", (fun () -> with_exception test_name), ());
        ("tailrec", (fun () -> with_tailrec test_name), ());
        ("raphael", (fun () -> with_raphael test_name), ());
      ]
  in
  if not !json_mode then Benchmark.tabulate single_no_escape;

  if not !json_mode then print_endline "\n--- Two strings WITHOUT escaping ---";
  let two_no_escape =
    Benchmark.throughputN ~style ~repeat:3 2
      [
        ("loop_all", (fun () -> two_loop_all test_a test_b), ());
        ("exception", (fun () -> two_exception test_a test_b), ());
        ("tailrec", (fun () -> two_tailrec test_a test_b), ());
        ("raphael", (fun () -> two_raphael test_a test_b), ());
      ]
  in
  if not !json_mode then Benchmark.tabulate two_no_escape;

  if not !json_mode then print_endline "\n--- Single string WITH escaping ---";
  let single_with_escape =
    Benchmark.throughputN ~style ~repeat:3 2
      [
        ("loop_all", (fun () -> with_loop_all escape_name), ());
        ("exception", (fun () -> with_exception escape_name), ());
        ("tailrec", (fun () -> with_tailrec escape_name), ());
        ("raphael", (fun () -> with_raphael escape_name), ());
      ]
  in
  if not !json_mode then Benchmark.tabulate single_with_escape;

  if not !json_mode then print_endline "\n--- Two strings WITH escaping ---";
  let two_with_escape =
    Benchmark.throughputN ~style ~repeat:3 2
      [
        ("loop_all", (fun () -> two_loop_all escape_a escape_b), ());
        ("exception", (fun () -> two_exception escape_a escape_b), ());
        ("tailrec", (fun () -> two_tailrec escape_a escape_b), ());
        ("raphael", (fun () -> two_raphael escape_a escape_b), ());
      ]
  in
  if not !json_mode then Benchmark.tabulate two_with_escape;

  if !json_mode then begin
    (* Output JSON for github-action-benchmark *)
    let all_json =
      results_to_json ~group_name:"single_no_escape" single_no_escape
      @ results_to_json ~group_name:"two_no_escape" two_no_escape
      @ results_to_json ~group_name:"single_with_escape" single_with_escape
      @ results_to_json ~group_name:"two_with_escape" two_with_escape
    in
    print_endline "[";
    print_endline (String.concat ",\n" all_json);
    print_endline "]"
  end
  else begin
    (* ============================================================ *)
    (* SUMMARY                                                      *)
    (* ============================================================ *)
    print_endline "\n=== Summary ===";
    print_endline
      "Escape: exception = current JSX.escape (fast path for no-escape case)"
  end
