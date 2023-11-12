type t = Htmx | Alpinejs | Custom_file of string

let reference : t option ref = ref None
let set flag = reference := Some flag
let set_htmx () = reference := Some Htmx
let get () = !reference

let attributes_of_flags = function
  | None -> []
  | Some Htmx -> Ppx_htmx.attributes
  | Some Alpinejs -> Ppx_alpinejs.attributes
  | Some (Custom_file _) -> (* Not implemented *) []
