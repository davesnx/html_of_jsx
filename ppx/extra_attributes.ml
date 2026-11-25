type t = Htmx | Alpinejs | React

let reference : t option ref = ref None
let set flag = reference := Some flag
let get () = !reference

let attributes_of_flags = function
  | None ->
      []
  | Some Htmx ->
      Extra_htmx.attributes
  | Some Alpinejs ->
      Extra_alpinejs.attributes
  | Some React ->
      Extra_react.attributes

let get_attributes () = attributes_of_flags (get ())
