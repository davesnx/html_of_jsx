val render_element : Jsx.element -> string
(** Renders a single `Jsx.element` as string. This function is only used in testing *)

val render : Jsx.element -> string
(** Renders an element as a HTMLDocument. Appends the HTML5 header, traverses the tree and returns a string. *)
