(** Used internally, no need to use *)

type t =
  | Bool of (string * bool)
  | String of (string * string)
  | Style of string
  | Event of (string * string)

let t_to_string attr =
  match attr with
  (* false attributes don't get rendered *)
  | Bool (_, false) -> ""
  (* true attributes render solely the attribute name *)
  | Bool (k, true) -> k
  | Style styles -> Printf.sprintf "style=\"%s\"" styles
  | Event (name, value) -> Printf.sprintf "%s=\"%s\"" name value
  | String (k, v) -> Printf.sprintf "%s=\"%s\"" k (Html.encode v)

let to_string attrs =
  match List.map t_to_string attrs with
  | [] -> ""
  | rest -> " " ^ (rest |> List.rev |> String.concat " " |> String.trim)
