type fixture = { name : string; ppx_target : string; total_target : string }

type run_result = {
  name : string;
  ppx_ms_runs : float list;
  total_ms_runs : float list;
  ppx_median_ms : float;
  total_median_ms : float;
}

type baseline_entry = { ppx_median_ms : float; total_median_ms : float }

type config = {
  runs : int;
  threshold_ppx_pct : float;
  threshold_total_pct : float;
  save_file : string option;
  compare_file : string option;
}

let fixtures =
  [
    {
      name = "static-heavy";
      ppx_target = "bench/compile_fixtures/static_heavy/static_heavy.mlx.pp.ml";
      total_target = "bench/compile_fixtures/static_heavy";
    };
    {
      name = "attr-heavy";
      ppx_target = "bench/compile_fixtures/attr_heavy/attr_heavy.mlx.pp.ml";
      total_target = "bench/compile_fixtures/attr_heavy";
    };
    {
      name = "nested-mixed";
      ppx_target = "bench/compile_fixtures/nested_mixed/nested_mixed.mlx.pp.ml";
      total_target = "bench/compile_fixtures/nested_mixed";
    };
  ]

let default_config =
  {
    runs = 5;
    threshold_ppx_pct = 10.0;
    threshold_total_pct = 10.0;
    save_file = None;
    compare_file = None;
  }

let parse_int v name =
  match int_of_string_opt v with
  | Some i when i > 0 ->
      i
  | _ ->
      invalid_arg (Printf.sprintf "Invalid positive integer for %s" name)

let parse_float v name =
  match float_of_string_opt v with
  | Some f when f >= 0.0 ->
      f
  | _ ->
      invalid_arg (Printf.sprintf "Invalid non-negative float for %s" name)

let parse_args () =
  let rec loop cfg = function
    | [] ->
        cfg
    | "--runs" :: v :: rest ->
        loop { cfg with runs = parse_int v "--runs" } rest
    | "--threshold-ppx" :: v :: rest ->
        loop
          { cfg with threshold_ppx_pct = parse_float v "--threshold-ppx" }
          rest
    | "--threshold-total" :: v :: rest ->
        loop
          { cfg with threshold_total_pct = parse_float v "--threshold-total" }
          rest
    | "--save" :: file :: rest ->
        loop { cfg with save_file = Some file } rest
    | "--compare" :: file :: rest ->
        loop { cfg with compare_file = Some file } rest
    | _ :: rest ->
        loop cfg rest
  in
  loop default_config (List.tl (Array.to_list Sys.argv))

let median xs =
  let sorted = List.sort compare xs in
  match sorted with
  | [] ->
      0.0
  | _ ->
      let n = List.length sorted in
      if n mod 2 = 1 then
        List.nth sorted (n / 2)
      else
        let a = List.nth sorted ((n / 2) - 1) in
        let b = List.nth sorted (n / 2) in
        (a +. b) /. 2.0

let run_command cmd =
  let t0 = Unix.gettimeofday () in
  let code = Sys.command cmd in
  let t1 = Unix.gettimeofday () in
  let elapsed_ms = (t1 -. t0) *. 1000.0 in
  if code <> 0 then failwith (Printf.sprintf "Command failed (%d): %s" code cmd);
  elapsed_ms

let measure_fixture runs fixture =
  let one_run () =
    ignore (run_command "dune clean");
    let ppx_ms = run_command ("dune build " ^ fixture.ppx_target) in
    ignore (run_command "dune clean");
    let total_ms = run_command ("dune build " ^ fixture.total_target) in
    (ppx_ms, total_ms)
  in
  let rec collect n ppx_acc total_acc =
    if n <= 0 then
      (List.rev ppx_acc, List.rev total_acc)
    else
      let ppx_ms, total_ms = one_run () in
      collect (n - 1) (ppx_ms :: ppx_acc) (total_ms :: total_acc)
  in
  let ppx_ms_runs, total_ms_runs = collect runs [] [] in
  {
    name = fixture.name;
    ppx_ms_runs;
    total_ms_runs;
    ppx_median_ms = median ppx_ms_runs;
    total_median_ms = median total_ms_runs;
  }

let pct_change ~baseline ~current =
  if baseline = 0.0 then
    0.0
  else
    (current -. baseline) /. baseline *. 100.0

let to_json config results =
  let runs_to_json xs =
    let parts = List.map (Printf.sprintf "%.3f") xs in
    "[" ^ String.concat ", " parts ^ "]"
  in
  let rows =
    List.map
      (fun r ->
        Printf.sprintf
          "    {\"name\": \"%s\", \"ppx_median_ms\": %.3f, \
           \"total_median_ms\": %.3f, \"ppx_ms_runs\": %s, \"total_ms_runs\": \
           %s}"
          r.name r.ppx_median_ms r.total_median_ms
          (runs_to_json r.ppx_ms_runs)
          (runs_to_json r.total_ms_runs)
      )
      results
  in
  Printf.sprintf
    "{\n\
    \  \"config\": {\"runs\": %d, \"threshold_ppx_pct\": %.2f, \
     \"threshold_total_pct\": %.2f},\n\
    \  \"results\": [\n\
     %s\n\
    \  ]\n\
     }"
    config.runs config.threshold_ppx_pct config.threshold_total_pct
    (String.concat ",\n" rows)

let extract_string_value line key =
  try
    let pattern = "\"" ^ key ^ "\":" in
    let idx = Str.search_forward (Str.regexp_string pattern) line 0 in
    let start = idx + String.length pattern in
    let q1 = String.index_from line start '"' in
    let q2 = String.index_from line (q1 + 1) '"' in
    Some (String.sub line (q1 + 1) (q2 - q1 - 1))
  with Not_found | Invalid_argument _ -> None

let extract_float_value line key =
  try
    let pattern = "\"" ^ key ^ "\":" in
    let idx = Str.search_forward (Str.regexp_string pattern) line 0 in
    let p = ref (idx + String.length pattern) in
    while !p < String.length line && line.[!p] = ' ' do
      incr p
    done;
    let e = ref !p in
    while
      !e < String.length line
      &&
      let c = line.[!e] in
      (c >= '0' && c <= '9') || c = '.' || c = '-'
    do
      incr e
    done;
    if !e > !p then
      Some (float_of_string (String.sub line !p (!e - !p)))
    else
      None
  with Not_found | Invalid_argument _ | Failure _ -> None

let parse_baseline file =
  let ic = open_in file in
  let content = really_input_string ic (in_channel_length ic) in
  close_in ic;
  let tbl = Hashtbl.create 8 in
  let cur_name = ref None in
  let cur_ppx = ref None in
  let cur_total = ref None in
  String.split_on_char '\n' content
  |> List.iter (fun line ->
      ( match extract_string_value line "name" with
      | Some s ->
          cur_name := Some s
      | None ->
          ()
      );
      ( match extract_float_value line "ppx_median_ms" with
      | Some f ->
          cur_ppx := Some f
      | None ->
          ()
      );
      ( match extract_float_value line "total_median_ms" with
      | Some f ->
          cur_total := Some f
      | None ->
          ()
      );
      match (!cur_name, !cur_ppx, !cur_total) with
      | Some n, Some p, Some t ->
          Hashtbl.replace tbl n { ppx_median_ms = p; total_median_ms = t };
          cur_name := None;
          cur_ppx := None;
          cur_total := None
      | _ ->
          ()
  );
  tbl

let print_results cfg results baseline_tbl =
  let has_baseline = Hashtbl.length baseline_tbl > 0 in
  if has_baseline then (
    Printf.printf "%-14s %12s %12s %14s %14s %s\n" "Fixture" "PPX ms" "Total ms"
      "PPX delta" "Total delta" "Guardrail";
    print_endline (String.make 90 '-')
  ) else (
    Printf.printf "%-14s %12s %12s\n" "Fixture" "PPX ms" "Total ms";
    print_endline (String.make 42 '-')
  );
  let guardrail_failed = ref false in
  List.iter
    (fun r ->
      if has_baseline then
        match Hashtbl.find_opt baseline_tbl r.name with
        | Some b ->
            let ppx_delta =
              pct_change ~baseline:b.ppx_median_ms ~current:r.ppx_median_ms
            in
            let total_delta =
              pct_change ~baseline:b.total_median_ms ~current:r.total_median_ms
            in
            let ppx_bad = ppx_delta > cfg.threshold_ppx_pct in
            let total_bad = total_delta > cfg.threshold_total_pct in
            if ppx_bad || total_bad then guardrail_failed := true;
            let status =
              if ppx_bad || total_bad then
                "FAIL"
              else
                "OK"
            in
            Printf.printf "%-14s %12.1f %12.1f %13.1f%% %13.1f%% %s\n" r.name
              r.ppx_median_ms r.total_median_ms ppx_delta total_delta status
        | None ->
            Printf.printf "%-14s %12.1f %12.1f %s\n" r.name r.ppx_median_ms
              r.total_median_ms "NEW"
      else
        Printf.printf "%-14s %12.1f %12.1f\n" r.name r.ppx_median_ms
          r.total_median_ms
    )
    results;
  if has_baseline then (
    print_endline (String.make 90 '-');
    Printf.printf "Guardrail thresholds: PPX <= +%.1f%%, Total <= +%.1f%%\n"
      cfg.threshold_ppx_pct cfg.threshold_total_pct
  );
  !guardrail_failed

let () =
  let cfg = parse_args () in
  Printf.printf "Running compile benchmark (%d runs per fixture)...\n%!"
    cfg.runs;
  let results = List.map (measure_fixture cfg.runs) fixtures in
  let baseline_tbl =
    match cfg.compare_file with
    | Some file ->
        parse_baseline file
    | None ->
        Hashtbl.create 0
  in
  let guardrail_failed = print_results cfg results baseline_tbl in
  let json = to_json cfg results in
  ( match cfg.save_file with
  | Some file ->
      let oc = open_out file in
      output_string oc json;
      close_out oc
  | None ->
      ()
  );
  if guardrail_failed then
    exit 1
  else
    exit 0
