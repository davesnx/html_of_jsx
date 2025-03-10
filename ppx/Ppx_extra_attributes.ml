type t = Htmx | Alpinejs | React | Custom_file of string

let reference : t option ref = ref None
let set flag = reference := Some flag
let set_htmx () = reference := Some Htmx
let get () = !reference

let reference_to_string = function
  | Htmx -> "Htmx"
  | Alpinejs -> "Alpine"
  | React -> "React"
  | Custom_file _ -> "Custom"

let to_string = function None -> "Html" | Some ref -> reference_to_string ref

let attributes_of_flags = function
  | None -> []
  | Some Htmx -> Ppx_htmx.attributes
  | Some Alpinejs -> Ppx_alpinejs.attributes
  | Some React -> Ppx_react.attributes
  | Some (Custom_file _) -> (* Not implemented *) []

(* A function that loads the attributes lazy, since we need to derive the list of attributes with the ppx flags. *)
let get_attributes () = attributes_of_flags (get ())
