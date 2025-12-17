(* Benchmark comparison tool *)

type benchmark_result = {
  name : string;
  value : float;
  unit : string; [@warning "-69"]
}

let extract_number s =
  try
    let rec find_digit i =
      if i >= String.length s then None
      else
        match s.[i] with
        | '0' .. '9' | '.' | '-' ->
            let rec find_end j =
              if j >= String.length s then j
              else
                match s.[j] with '0' .. '9' | '.' -> find_end (j + 1) | _ -> j
            in
            let end_pos = find_end (i + 1) in
            Some (String.sub s i (end_pos - i))
        | _ -> find_digit (i + 1)
    in
    find_digit 0
  with _ -> None

let parse_json_file filename =
  let ic = open_in filename in
  let content = really_input_string ic (in_channel_length ic) in
  close_in ic;

  (* Simple JSON parsing for our format: {"name": "...", "unit": "...", "value": 123.45} *)
  let results = ref [] in
  let lines = String.split_on_char '\n' content in
  List.iter
    (fun line ->
      if String.contains line '"' && String.contains line ':' then
        try
          (* Skip "name": and find the actual name value *)
          let value_idx = String.index line ':' in
          let after_colon =
            String.sub line (value_idx + 1) (String.length line - value_idx - 1)
          in
          let actual_name_start = String.index after_colon '"' in
          let actual_name_end =
            String.index_from after_colon (actual_name_start + 1) '"'
          in
          let name =
            String.sub after_colon (actual_name_start + 1)
              (actual_name_end - actual_name_start - 1)
          in

          (* Find "value": and extract number *)
          let value_start = String.index line 'v' in
          let value_substr =
            String.sub line value_start (String.length line - value_start)
          in
          let value = extract_number value_substr in

          match value with
          | Some v ->
              results :=
                { name; unit = "ops/sec"; value = float_of_string v }
                :: !results
          | None -> ()
        with _ -> ())
    lines;
  List.rev !results

let compare_results baseline_file new_file =
  let baseline = parse_json_file baseline_file in
  let new_results = parse_json_file new_file in

  (* Create hash table for quick lookup *)
  let baseline_tbl = Hashtbl.create 100 in
  List.iter (fun r -> Hashtbl.add baseline_tbl r.name r.value) baseline;

  Printf.printf "=== Benchmark Comparison ===\n\n";
  Printf.printf "%-50s %12s %12s %10s\n" "Benchmark" "Baseline" "New" "Change";
  Printf.printf "%s\n" (String.make 88 '-');

  let improvements = ref 0 in
  let regressions = ref 0 in
  let total_change = ref 0.0 in
  let count = ref 0 in

  List.iter
    (fun new_r ->
      match Hashtbl.find_opt baseline_tbl new_r.name with
      | None ->
          Printf.printf "%-50s %12s %12.2f %10s\n" new_r.name "NEW" new_r.value
            "NEW"
      | Some baseline_val ->
          let change_pct =
            (new_r.value -. baseline_val) /. baseline_val *. 100.0
          in
          let change_str =
            if change_pct > 0.0 then Printf.sprintf "+%.1f%%" change_pct
            else Printf.sprintf "%.1f%%" change_pct
          in
          let indicator =
            if change_pct > 2.0 then "✓" (* Improvement > 2% *)
            else if change_pct < -2.0 then "✗" (* Regression > 2% *)
            else "=" (* Within noise *)
          in
          Printf.printf "%-50s %12.2f %12.2f %9s %s\n" new_r.name baseline_val
            new_r.value change_str indicator;

          if change_pct > 2.0 then incr improvements;
          if change_pct < -2.0 then incr regressions;
          total_change := !total_change +. change_pct;
          incr count)
    new_results;

  Printf.printf "%s\n" (String.make 88 '-');
  if !count > 0 then
    Printf.printf "Average change: %.1f%%\n"
      (!total_change /. float_of_int !count);
  Printf.printf "Improvements: %d  Regressions: %d\n" !improvements !regressions;
  Printf.printf "\n";

  (* Return true if net improvement *)
  !improvements > !regressions

let () =
  if Array.length Sys.argv < 3 then (
    Printf.eprintf "Usage: %s <baseline.json> <new.json>\n" Sys.argv.(0);
    exit 1);

  let baseline = Sys.argv.(1) in
  let new_file = Sys.argv.(2) in

  try
    let is_improvement = compare_results baseline new_file in
    exit (if is_improvement then 0 else 1)
  with e ->
    Printf.eprintf "Error: %s\n" (Printexc.to_string e);
    exit 2
