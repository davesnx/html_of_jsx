module Attribute : sig
  type t =
    | Bool of (string * bool)
    | String of (string * string)
    | Style of string
    | Event of (string * string)

  val to_string : t list -> string
end

type element
(** The type that represents a JSX.element *)

val to_string : element -> string
(** The function to convert a JSX.element to a string. 

    {[
      let html: string = JSX.to_string (
        <div>
          <h1> (JSX.string "Hello, World!") </h1>
        </div>
      )
    ]}
*)

val string : string -> element
(** Helper to represent an element as a string *)

val unsafe : string -> element
(** Helper to bypass HTML encoding and treat output as unsafe. This can lead to
    HTML scaping problems, XSS injections and other security concerns, use with caution. *)

val null : element
(** Helper to represent nullability in JSX, useful to pattern match *)

val int : int -> element
(** Helper to render an integer *)

val float : float -> element
(** Helper to render an integer *)

val list : element list -> element

val fragment : element list -> element
(** Fragment  *)

val node : string -> Attribute.t list -> element list -> element
(** The function to create a HTML DOM Node [https://developer.mozilla.org/en-US/docs/Web/API/Node]. Given the tag, list of attributes and list of childrens *)
