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

  let sse ?version () = extension_script ~package:"sse" ?version ()
  let ws ?version () = extension_script ~package:"ws" ?version ()
  let class_tools ?version () = extension_script ~package:"class-tools" ?version ()
  let preload ?version () = extension_script ~package:"preload" ?version ()
  let path_deps ?version () = extension_script ~package:"path-deps" ?version ()

  let loading_states ?version () =
    extension_script ~package:"loading-states" ?version ()

  let response_targets ?version () =
    extension_script ~package:"response-targets" ?version ()

  let head_support ?version () =
    extension_script ~package:"head-support" ?version ()
end
