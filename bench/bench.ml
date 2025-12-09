(* Benchmark comparing different optimizations *)

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
(* 2. Buffer size estimation benchmark                          *)
(* ============================================================ *)

(* Simulates PPX-generated code with fixed buffer size (1024) *)
let buffer_fixed_1024 a b c d e =
  let buf = Buffer.create 1024 in
  Buffer.add_string buf "<div class=\"container\">";
  JSX.escape buf a;
  JSX.escape buf b;
  JSX.escape buf c;
  JSX.escape buf d;
  JSX.escape buf e;
  Buffer.add_string buf "</div>";
  JSX.unsafe (Buffer.contents buf)

(* Simulates PPX-generated code with estimated buffer size *)
(* Static: 30 bytes, 5 strings * 32 = 160, total ~256 *)
let buffer_estimated a b c d e =
  let buf = Buffer.create 256 in
  Buffer.add_string buf "<div class=\"container\">";
  JSX.escape buf a;
  JSX.escape buf b;
  JSX.escape buf c;
  JSX.escape buf d;
  JSX.escape buf e;
  Buffer.add_string buf "</div>";
  JSX.unsafe (Buffer.contents buf)

(* Larger case: simulates a page-like structure *)
let buffer_fixed_page title desc content footer extra =
  let buf = Buffer.create 1024 in
  Buffer.add_string buf "<!DOCTYPE html><html><head><title>";
  JSX.escape buf title;
  Buffer.add_string buf "</title><meta name=\"description\" content=\"";
  JSX.escape buf desc;
  Buffer.add_string buf "\"></head><body><main>";
  JSX.escape buf content;
  Buffer.add_string buf "</main><footer>";
  JSX.escape buf footer;
  JSX.escape buf extra;
  Buffer.add_string buf "</footer></body></html>";
  JSX.unsafe (Buffer.contents buf)

(* Estimated: ~150 static + 5*32 = 310, rounded to 512 *)
let buffer_estimated_page title desc content footer extra =
  let buf = Buffer.create 512 in
  Buffer.add_string buf "<!DOCTYPE html><html><head><title>";
  JSX.escape buf title;
  Buffer.add_string buf "</title><meta name=\"description\" content=\"";
  JSX.escape buf desc;
  Buffer.add_string buf "\"></head><body><main>";
  JSX.escape buf content;
  Buffer.add_string buf "</main><footer>";
  JSX.escape buf footer;
  JSX.escape buf extra;
  Buffer.add_string buf "</footer></body></html>";
  JSX.unsafe (Buffer.contents buf)

(* ============================================================ *)
(* 3. Optional attributes optimization benchmark                *)
(* ============================================================ *)

(* Unoptimized: uses JSX.node with List.filter_map (generated when flag is disabled) *)
let optional_attrs_unoptimized ~class_ ~id ~title () =
  JSX.node "div"
    (Stdlib.List.filter_map Stdlib.Fun.id
       [
         Stdlib.Option.map (fun v -> ("class", `String v)) class_;
         Stdlib.Option.map (fun v -> ("id", `String v)) id;
         Stdlib.Option.map (fun v -> ("title", `String v)) title;
       ])
    [ JSX.string "content" ]

(* Optimized: direct buffer writes with conditionals (generated when flag is enabled) *)
let optional_attrs_optimized ~class_ ~id ~title () =
  let buf = Buffer.create 128 in
  Buffer.add_string buf "<div";
  (match class_ with
  | Some v ->
      Buffer.add_string buf " class=\"";
      JSX.escape buf v;
      Buffer.add_char buf '"'
  | None -> ());
  (match id with
  | Some v ->
      Buffer.add_string buf " id=\"";
      JSX.escape buf v;
      Buffer.add_char buf '"'
  | None -> ());
  (match title with
  | Some v ->
      Buffer.add_string buf " title=\"";
      JSX.escape buf v;
      Buffer.add_char buf '"'
  | None -> ());
  Buffer.add_string buf ">content</div>";
  JSX.unsafe (Buffer.contents buf)

(* With more attributes to amplify the difference *)
let optional_attrs_unoptimized_many ~a1 ~a2 ~a3 ~a4 ~a5 () =
  JSX.node "div"
    (Stdlib.List.filter_map Stdlib.Fun.id
       [
         Stdlib.Option.map (fun v -> ("data-a1", `String v)) a1;
         Stdlib.Option.map (fun v -> ("data-a2", `String v)) a2;
         Stdlib.Option.map (fun v -> ("data-a3", `String v)) a3;
         Stdlib.Option.map (fun v -> ("data-a4", `String v)) a4;
         Stdlib.Option.map (fun v -> ("data-a5", `String v)) a5;
       ])
    [ JSX.string "content" ]

let optional_attrs_optimized_many ~a1 ~a2 ~a3 ~a4 ~a5 () =
  let buf = Buffer.create 256 in
  Buffer.add_string buf "<div";
  (match a1 with
  | Some v ->
      Buffer.add_string buf " data-a1=\"";
      JSX.escape buf v;
      Buffer.add_char buf '"'
  | None -> ());
  (match a2 with
  | Some v ->
      Buffer.add_string buf " data-a2=\"";
      JSX.escape buf v;
      Buffer.add_char buf '"'
  | None -> ());
  (match a3 with
  | Some v ->
      Buffer.add_string buf " data-a3=\"";
      JSX.escape buf v;
      Buffer.add_char buf '"'
  | None -> ());
  (match a4 with
  | Some v ->
      Buffer.add_string buf " data-a4=\"";
      JSX.escape buf v;
      Buffer.add_char buf '"'
  | None -> ());
  (match a5 with
  | Some v ->
      Buffer.add_string buf " data-a5=\"";
      JSX.escape buf v;
      Buffer.add_char buf '"'
  | None -> ());
  Buffer.add_string buf ">content</div>";
  JSX.unsafe (Buffer.contents buf)

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

(* Data for buffer/optional attrs benchmarks *)
let str1 = "Hello"
let str2 = "World"
let str3 = "This is some content"
let str4 = "Footer text"
let str5 = "Extra information"

let () =
  (* ============================================================ *)
  (* ESCAPE FUNCTION COMPARISON                                   *)
  (* ============================================================ *)
  print_endline "=== 1. Escape Implementation Comparison ===\n";

  print_endline "--- Single string WITHOUT escaping ---";
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

  print_endline "\n--- Two strings WITHOUT escaping ---";
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

  print_endline "\n--- Single string WITH escaping ---";
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

  print_endline "\n--- Two strings WITH escaping ---";
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

  (* ============================================================ *)
  (* BUFFER SIZE ESTIMATION                                       *)
  (* ============================================================ *)
  print_endline "\n=== 2. Buffer Size Estimation ===\n";

  print_endline "--- Small element with 5 dynamic strings ---";
  let buffer_small =
    Benchmark.throughputN ~repeat:3 2
      [
        ( "fixed (1024)",
          (fun () -> buffer_fixed_1024 str1 str2 str3 str4 str5),
          () );
        ( "estimated (256)",
          (fun () -> buffer_estimated str1 str2 str3 str4 str5),
          () );
      ]
  in
  Benchmark.tabulate buffer_small;

  print_endline "\n--- Page-like structure with 5 dynamic strings ---";
  let buffer_page =
    Benchmark.throughputN ~repeat:3 2
      [
        ( "fixed (1024)",
          (fun () -> buffer_fixed_page str1 str2 str3 str4 str5),
          () );
        ( "estimated (512)",
          (fun () -> buffer_estimated_page str1 str2 str3 str4 str5),
          () );
      ]
  in
  Benchmark.tabulate buffer_page;

  (* ============================================================ *)
  (* OPTIONAL ATTRIBUTES OPTIMIZATION                             *)
  (* ============================================================ *)
  print_endline "\n=== 3. Optional Attributes Optimization ===\n";

  print_endline "--- 3 optional attrs (all Some) ---";
  let opt_all_some =
    Benchmark.throughputN ~repeat:3 2
      [
        ( "JSX.node",
          (fun () ->
            optional_attrs_unoptimized ~class_:(Some "container")
              ~id:(Some "main") ~title:(Some "Title") ()),
          () );
        ( "buffer",
          (fun () ->
            optional_attrs_optimized ~class_:(Some "container")
              ~id:(Some "main") ~title:(Some "Title") ()),
          () );
      ]
  in
  Benchmark.tabulate opt_all_some;

  print_endline "\n--- 3 optional attrs (all None) ---";
  let opt_all_none =
    Benchmark.throughputN ~repeat:3 2
      [
        ( "JSX.node",
          (fun () ->
            optional_attrs_unoptimized ~class_:None ~id:None ~title:None ()),
          () );
        ( "buffer",
          (fun () ->
            optional_attrs_optimized ~class_:None ~id:None ~title:None ()),
          () );
      ]
  in
  Benchmark.tabulate opt_all_none;

  print_endline "\n--- 3 optional attrs (mixed) ---";
  let opt_mixed =
    Benchmark.throughputN ~repeat:3 2
      [
        ( "JSX.node",
          (fun () ->
            optional_attrs_unoptimized ~class_:(Some "container") ~id:None
              ~title:(Some "Title") ()),
          () );
        ( "buffer",
          (fun () ->
            optional_attrs_optimized ~class_:(Some "container") ~id:None
              ~title:(Some "Title") ()),
          () );
      ]
  in
  Benchmark.tabulate opt_mixed;

  print_endline "\n--- 5 optional attrs (all Some) ---";
  let opt_many_some =
    Benchmark.throughputN ~repeat:3 2
      [
        ( "JSX.node",
          (fun () ->
            optional_attrs_unoptimized_many ~a1:(Some "v1") ~a2:(Some "v2")
              ~a3:(Some "v3") ~a4:(Some "v4") ~a5:(Some "v5") ()),
          () );
        ( "buffer",
          (fun () ->
            optional_attrs_optimized_many ~a1:(Some "v1") ~a2:(Some "v2")
              ~a3:(Some "v3") ~a4:(Some "v4") ~a5:(Some "v5") ()),
          () );
      ]
  in
  Benchmark.tabulate opt_many_some;

  print_endline "\n--- 5 optional attrs (all None) ---";
  let opt_many_none =
    Benchmark.throughputN ~repeat:3 2
      [
        ( "JSX.node",
          (fun () ->
            optional_attrs_unoptimized_many ~a1:None ~a2:None ~a3:None ~a4:None
              ~a5:None ()),
          () );
        ( "buffer",
          (fun () ->
            optional_attrs_optimized_many ~a1:None ~a2:None ~a3:None ~a4:None
              ~a5:None ()),
          () );
      ]
  in
  Benchmark.tabulate opt_many_none;

  (* ============================================================ *)
  (* SUMMARY                                                      *)
  (* ============================================================ *)
  print_endline "\n=== Summary ===";
  print_endline
    "1. Escape: exception = current JSX.escape (fast path for no-escape case)";
  print_endline
    "2. Buffer: estimated sizes reduce reallocations for small outputs";
  print_endline
    "3. Optional attrs: buffer avoids List.filter_map allocation overhead"
