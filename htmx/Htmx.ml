let cdn_base = "https://unpkg.com"
let script_node src = JSX.node "script" [ ("src", `String src) ] []

let make ?(version = "2.0.4") ?integrity () =
  let src = Printf.sprintf "%s/htmx.org@%s" cdn_base version in
  match integrity with
  | None ->
      script_node src
  | Some hash ->
      JSX.node "script"
        [
          ("src", `String src);
          ("integrity", `String hash);
          ("crossorigin", `String "anonymous");
        ]
        []

module Extensions = struct
  let extension_script ~package ?version () =
    let src =
      match version with
      | Some v ->
          Printf.sprintf "%s/htmx-ext-%s@%s" cdn_base package v
      | None ->
          Printf.sprintf "%s/htmx-ext-%s" cdn_base package
    in
    script_node src

  module SSE = struct
    let make ?version () = extension_script ~package:"sse" ?version ()
  end

  module WS = struct
    let make ?version () = extension_script ~package:"ws" ?version ()
  end

  module Class_tools = struct
    let make ?version () = extension_script ~package:"class-tools" ?version ()
  end

  module Preload = struct
    let make ?version () = extension_script ~package:"preload" ?version ()
  end

  module Path_deps = struct
    let make ?version () = extension_script ~package:"path-deps" ?version ()
  end

  module Loading_states = struct
    let make ?version () =
      extension_script ~package:"loading-states" ?version ()
  end

  module Response_targets = struct
    let make ?version () =
      extension_script ~package:"response-targets" ?version ()
  end

  module Head_support = struct
    let make ?version () = extension_script ~package:"head-support" ?version ()
  end
end
