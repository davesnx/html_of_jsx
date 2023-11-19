type t = Htmx | Alpinejs | Custom_file of string

let reference : t option ref = ref None
let set flag = reference := Some flag
let set_htmx () = reference := Some Htmx
let get () = !reference

let reference_to_string = function
  | Htmx -> "Htmx"
  | Alpinejs -> "Alpine"
  | Custom_file _ -> "Custom"

let to_string = function None -> "None" | Some ref -> reference_to_string ref

let attributes_of_flags reference =
  match reference with
  | None -> []
  | Some Htmx -> Ppx_htmx.attributes
  | Some Alpinejs -> Ppx_alpinejs.attributes
  | Some (Custom_file _) -> (* Not implemented *) []

let load_attributes = lazy (attributes_of_flags (get ()))
