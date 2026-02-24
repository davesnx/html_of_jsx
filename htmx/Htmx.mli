val make : ?version:string -> ?integrity:string -> unit -> JSX.element
(** Render a script tag that loads htmx from unpkg CDN.

    {[
      <Htmx version="2.0.4" />
      (* <script src="https://unpkg.com/htmx.org@2.0.4"></script> *)
    ]}

    When [integrity] is provided, adds [integrity] and [crossorigin="anonymous"]
    attributes for subresource integrity. *)

module Extensions : sig
  module SSE : sig
    val make : ?version:string -> unit -> JSX.element
  end

  module WS : sig
    val make : ?version:string -> unit -> JSX.element
  end

  module Class_tools : sig
    val make : ?version:string -> unit -> JSX.element
  end

  module Preload : sig
    val make : ?version:string -> unit -> JSX.element
  end

  module Path_deps : sig
    val make : ?version:string -> unit -> JSX.element
  end

  module Loading_states : sig
    val make : ?version:string -> unit -> JSX.element
  end

  module Response_targets : sig
    val make : ?version:string -> unit -> JSX.element
  end

  module Head_support : sig
    val make : ?version:string -> unit -> JSX.element
  end
end
