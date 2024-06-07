(** Declaratively create HTML elements with JSX using OCaml/Reason.

  {[
    let html: string = JSX.render (
      <div>
        <h1> {JSX.string("Hello, World!")} </h1>
      </div>
    )
  ]}
*)

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

val render : element -> string
(** Render a JSX.element to a string.

    {[
      let html: string = JSX.render (
        <div>
          <h1> (JSX.string "Hello, World!") </h1>
        </div>
      )
    ]}
*)

val float : float -> element
(** Helper to render a float *)

val fragment : element list -> element
(** Fragment *)

val int : int -> element
(** Helper to render an integer *)

val list : element list -> element
(** Helper to render a list of elements *)

val node : string -> Attribute.t list -> element list -> element
(** The function to create a HTML DOM Node [https://developer.mozilla.org/en-US/docs/Web/API/Node]. Given the tag, list of attributes and list of children.

  {[
    JSX.node(
      "a",
      [JSX.Attribute.String(("href", "https://ocaml.org"))],
      [JSX.string("OCaml")],
    );
  ]}
*)

val null : element
(** Helper to represent nullability in JSX, useful to pattern match *)

val string : string -> element
(** Helper to represent an element as a string *)

val text : string -> element
[@@deprecated "Use JSX.string instead"]
(** Helper to render a text *)

val unsafe : string -> element
(** Helper to bypass HTML encoding and treat output as unsafe. This can lead to
    HTML scaping problems, XSS injections and other security concerns, use with caution. *)

(** Provides ways to inspect a JSX.element. *)
module Debug : sig
  type __node = {
    tag : string;
    attributes : Attribute.t list;
    children : __element list;
  }
  (** Type for inspection of a node *)

  and __element =
    | Null
    | String of string
    | Unsafe of string (* text without encoding *)
    | Fragment of __element list
    | Node of __node
    | Component of (unit -> __element)
    | List of __element list

  val view : element -> __element
  (** A function to inspect a JSX.element.

     {[
      let debug: JSX.Debug.__element =
        JSX.Debug.view(
          <div>
            <h1> {JSX.string("Hello, World!")} </h1>
          </div>
        );

      switch (debug) {
        | JSX.Debug.Node {tag; attributes; children} -> Printf.printf("Node: %s", tag)
        | _ -> ()
      }
     ]}
  *)
end
