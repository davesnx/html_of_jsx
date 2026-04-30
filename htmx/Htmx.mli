val make : ?version:string -> ?integrity:string -> unit -> JSX.element
(** Render a script tag that loads htmx from unpkg CDN.

    {[
      <Htmx version="2.0.4" />
      (* <script src="https://unpkg.com/htmx.org@2.0.4"></script> *)
    ]}

    When [integrity] is provided, adds [integrity] and [crossorigin="anonymous"]
    attributes for subresource integrity. *)

(** Helpers that load official htmx extensions from unpkg.

    Each function emits a [<script src="...">] tag for the matching [htmx-ext-*]
    package. Pin the version in production:

    {[
      <Htmx.Extensions.sse version="2.2.2" />
      (* <script src="https://unpkg.com/htmx-ext-sse@2.2.2"></script> *)
    ]}

    See {{:https://htmx.org/extensions/} the official extensions list}. *)
module Extensions : sig
  val sse : ?version:string -> unit -> JSX.element
  (** Loads [htmx-ext-sse]. *)

  val ws : ?version:string -> unit -> JSX.element
  (** Loads [htmx-ext-ws]. *)

  val class_tools : ?version:string -> unit -> JSX.element
  (** Loads [htmx-ext-class-tools]. *)

  val preload : ?version:string -> unit -> JSX.element
  (** Loads [htmx-ext-preload]. *)

  val path_deps : ?version:string -> unit -> JSX.element
  (** Loads [htmx-ext-path-deps]. *)

  val loading_states : ?version:string -> unit -> JSX.element
  (** Loads [htmx-ext-loading-states]. *)

  val response_targets : ?version:string -> unit -> JSX.element
  (** Loads [htmx-ext-response-targets]. *)

  val head_support : ?version:string -> unit -> JSX.element
  (** Loads [htmx-ext-head-support]. *)
end
