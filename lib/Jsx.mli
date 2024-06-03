module Attribute : sig
  type t =
    | Bool of (string * bool)
    | String of (string * string)
    | Style of string
    | Event of (string * string)

  val to_string : t list -> string
end

type element
(** The type that represents a Jsx.element *)

val to_string : element -> string
(** The function to convert a Jsx.element to a string. 

    {[
      let html: string = Jsx.to_string (
        <div>
          <h1> (Jsx.string "Hello, World!") </h1>
        </div>
      )
    ]}
*)

val float : float -> element
(** Helper to render a float *)

val fragment : element list -> element
(** Fragment  *)

val int : int -> element
(** Helper to render an integer *)

val list : element list -> element
(** Helper to render a list of elements *)

val node : string -> Attribute.t list -> element list -> element
(** The function to create a HTML DOM Node [https://developer.mozilla.org/en-US/docs/Web/API/Node]. Given the tag, list of attributes and list of childrens *)

val null : element
(** Helper to represent nullability in JSX, useful to pattern match *)

val string : string -> element
(** Helper to represent an element as a string *)

val text : string -> element
[@@deprecated "Use Jsx.string instead"]
(** Helper to render a text *)

val unsafe : string -> element
(** Helper to bypass HTML encoding and treat output as unsafe. This can lead to
    HTML scaping problems, XSS injections and other security concerns, use with caution. *)
