(* Benchmark comparison tool

   Usage:
     compare_results baseline.json new.json           # Human-readable output
     compare_results --markdown baseline.json new.json # Markdown for PR comments
*)

type result = { name : string; latency_us : float }

(* Parse JSON benchmark results file *)
let parse_json_file filename =
  let ic = open_in filename in
  let content = really_input_string ic (in_channel_length ic) in
  close_in ic;

  let results = ref [] in
  let lines = String.split_on_char '\n' content in

  (* Track current object's fields *)
  let current_name = ref None in
  let current_latency = ref None in

  let extract_string_value line key =
    try
      let pattern = "\"" ^ key ^ "\":" in
      let idx = Str.search_forward (Str.regexp_string pattern) line 0 in
      let start = idx + String.length pattern in
      let quote_start = String.index_from line start '"' in
      let quote_end = String.index_from line (quote_start + 1) '"' in
      Some (String.sub line (quote_start + 1) (quote_end - quote_start - 1))
    with Not_found | Invalid_argument _ -> None
  in

  let extract_float_value line key =
    try
      let pattern = "\"" ^ key ^ "\":" in
      let idx = Str.search_forward (Str.regexp_string pattern) line 0 in
      let start = idx + String.length pattern in
      (* Skip whitespace *)
      let start = ref start in
      while !start < String.length line && line.[!start] = ' ' do
        incr start
      done;
      (* Extract number *)
      let end_pos = ref !start in
      while
        !end_pos < String.length line
        &&
        let c = line.[!end_pos] in
        (c >= '0' && c <= '9') || c = '.' || c = '-'
      do
        incr end_pos
      done;
      if !end_pos > !start then
        Some (float_of_string (String.sub line !start (!end_pos - !start)))
      else None
    with Not_found | Invalid_argument _ | Failure _ -> None
  in

  List.iter
    (fun line ->
      (* Check for name field *)
      (match extract_string_value line "name" with
      | Some n -> current_name := Some n
      | None -> ());
      (* Check for latency_us field *)
      (match extract_float_value line "latency_us" with
      | Some l -> current_latency := Some l
      | None -> ());
      (* If we have all fields, create result *)
      match (!current_name, !current_latency) with
      | Some name, Some latency_us ->
          results := { name; latency_us } :: !results;
          current_name := None;
          current_latency := None
      | _ -> ())
    lines;

  List.rev !results

(* Format latency for display *)
let format_latency us =
  if us < 1.0 then Printf.sprintf "%.2f µs" us
  else if us < 10.0 then Printf.sprintf "%.1f µs" us
  else if us < 1000.0 then Printf.sprintf "%.0f µs" us
  else Printf.sprintf "%.1f ms" (us /. 1000.0)

(* Calculate percentage change (positive = regression, negative = improvement) *)
let calc_change baseline current = (current -. baseline) /. baseline *. 100.0

(* Compare results and output in human-readable format *)
let compare_text baseline_results new_results =
  Printf.printf "=== Benchmark Comparison ===\n\n";
  Printf.printf "%-28s %12s %12s %12s\n" "Scenario" "Baseline" "Current"
    "Change";
  Printf.printf "%s\n" (String.make 68 '-');

  let baseline_tbl = Hashtbl.create 20 in
  List.iter (fun r -> Hashtbl.add baseline_tbl r.name r) baseline_results;

  let improved = ref 0 in
  let regressed = ref 0 in
  let unchanged = ref 0 in

  List.iter
    (fun new_r ->
      match Hashtbl.find_opt baseline_tbl new_r.name with
      | None ->
          Printf.printf "%-28s %12s %12s %12s\n" new_r.name "NEW"
            (format_latency new_r.latency_us)
            "NEW"
      | Some base_r ->
          let change = calc_change base_r.latency_us new_r.latency_us in
          let change_str =
            if change > 0.0 then Printf.sprintf "+%.1f%%" change
            else Printf.sprintf "%.1f%%" change
          in
          let indicator =
            if change < -5.0 then (
              incr improved;
              " ✓")
            else if change > 5.0 then (
              incr regressed;
              " ✗")
            else (
              incr unchanged;
              "")
          in
          Printf.printf "%-28s %12s %12s %11s%s\n" new_r.name
            (format_latency base_r.latency_us)
            (format_latency new_r.latency_us)
            change_str indicator)
    new_results;

  Printf.printf "%s\n" (String.make 68 '-');
  Printf.printf "\nSummary: %d improved (>5%%), %d regressed, %d unchanged\n"
    !improved !regressed !unchanged;

  (* Return true if no regressions *)
  !regressed = 0

(* Compare results and output in markdown format for PR comments *)
let compare_markdown baseline_results new_results =
  Printf.printf "## Benchmark Results\n\n";
  Printf.printf "| Scenario | Baseline | Current | Change |\n";
  Printf.printf "|----------|----------|---------|--------|\n";

  let baseline_tbl = Hashtbl.create 20 in
  List.iter (fun r -> Hashtbl.add baseline_tbl r.name r) baseline_results;

  let improved = ref 0 in
  let regressed = ref 0 in
  let unchanged = ref 0 in

  List.iter
    (fun new_r ->
      match Hashtbl.find_opt baseline_tbl new_r.name with
      | None ->
          Printf.printf "| %s | NEW | %s | NEW |\n" new_r.name
            (format_latency new_r.latency_us)
      | Some base_r ->
          let change = calc_change base_r.latency_us new_r.latency_us in
          let change_str =
            if change < -5.0 then (
              incr improved;
              Printf.sprintf "**%.1f%%** ✓" change)
            else if change > 5.0 then (
              incr regressed;
              Printf.sprintf "**+%.1f%%** ⚠️" change)
            else (
              incr unchanged;
              if change > 0.0 then Printf.sprintf "+%.1f%%" change
              else Printf.sprintf "%.1f%%" change)
          in
          Printf.printf "| %s | %s | %s | %s |\n" new_r.name
            (format_latency base_r.latency_us)
            (format_latency new_r.latency_us)
            change_str)
    new_results;

  Printf.printf
    "\n**Summary**: %d improved (>5%%), %d regressed, %d unchanged\n" !improved
    !regressed !unchanged;

  (* Return true if no regressions *)
  !regressed = 0

let () =
  let args = Array.to_list Sys.argv in
  let markdown_mode = List.mem "--markdown" args in
  let files =
    List.filter
      (fun s ->
        (s <> "--markdown" && not (String.contains s '/'))
        || String.contains s '.')
      args
  in
  let files = List.tl files in
  (* Remove program name *)
  let files = List.filter (fun s -> s <> "--markdown") files in

  if List.length files < 2 then (
    Printf.eprintf "Usage: %s [--markdown] <baseline.json> <new.json>\n"
      Sys.argv.(0);
    exit 1);

  let baseline_file = List.nth files 0 in
  let new_file = List.nth files 1 in

  try
    let baseline = parse_json_file baseline_file in
    let new_results = parse_json_file new_file in
    let no_regressions =
      if markdown_mode then compare_markdown baseline new_results
      else compare_text baseline new_results
    in
    exit (if no_regressions then 0 else 1)
  with e ->
    Printf.eprintf "Error: %s\n" (Printexc.to_string e);
    exit 2
