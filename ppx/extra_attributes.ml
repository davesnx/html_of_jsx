type t = Htmx | Alpinejs | React | Custom_file of string

let reference : t option ref = ref None
let set flag = reference := Some flag
let get () = !reference

let attributes_of_flags = function
  | None -> []
  | Some Htmx -> Extra_htmx.attributes
  | Some Alpinejs -> Extra_alpinejs.attributes
  | Some React -> Extra_react.attributes
  | Some (Custom_file _) -> (* Not implemented *) []

(* A function that loads the attributes lazy, since we need to derive the list of attributes with the ppx flags. *)
let get_attributes () = attributes_of_flags (get ())
