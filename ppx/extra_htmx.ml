(** https://htmx.org/reference/ *)

open Html_attributes

let core_attributes =
  [
    Rich_attribute
      {
        name = "hx-boost";
        jsxName = "hx_boost";
        type_ = BooleanishString;
        description =
          "add or remove progressive enhancement for links and forms";
        url = "https://htmx.org/attributes/hx-boost";
      };
    Rich_attribute
      {
        name = "hx-get";
        jsxName = "hx_get";
        type_ = String;
        description = "issues a GET to the specified URL";
        url = "https://htmx.org/attributes/hx-get";
      };
    Rich_attribute
      {
        name = "hx-post";
        jsxName = "hx_post";
        type_ = String;
        description = "issues a POST to the specified URL";
        url = "https://htmx.org/attributes/hx-post";
      };
    Rich_attribute
      {
        name = "hx-push-url";
        jsxName = "hx_push_url";
        type_ = String;
        description =
          "pushes the URL into the browser location bar, creating a new \
           history entry";
        url = "https://htmx.org/attributes/hx-push-url";
      };
    Rich_attribute
      {
        name = "hx-select";
        jsxName = "hx_select";
        type_ = String;
        description = "select content to swap in from a response";
        url = "https://htmx.org/attributes/hx-select";
      };
    Rich_attribute
      {
        name = "hx-select-oob";
        jsxName = "hx_select_oob";
        type_ = String;
        description =
          "select content to swap in from a response, out of band (somewhere \
           other than the target)";
        url = "https://htmx.org/attributes/hx-select-oob";
      };
    Rich_attribute
      {
        name = "hx-swap";
        jsxName = "hx_swap";
        type_ = String;
        description =
          "marks content in a response to be out of band (should swap in \
           somewhere other than the target)";
        url = "https://htmx.org/attributes/hx-swap";
      };
    Rich_attribute
      {
        name = "hx-swap-oob";
        jsxName = "hx_swap_oob";
        type_ = String;
        description = "specifies the target element to be swapped";
        url = "https://htmx.org/attributes/hx-swap-oob";
      };
    Rich_attribute
      {
        name = "hx-target";
        jsxName = "hx_target";
        type_ = String;
        description = "specifies the event that triggers the request";
        url = "https://htmx.org/attributes/hx-target";
      };
    Rich_attribute
      {
        name = "hx-trigger";
        jsxName = "hx_trigger";
        type_ = String;
        description = "specifies the event that triggers the request";
        url = "https://htmx.org/attributes/hx-trigger";
      };
    Rich_attribute
      {
        name = "hx-vals";
        jsxName = "hx_vals";
        type_ = String;
        description =
          "adds values to the parameters to submit with the request \
           (JSON-formatted)";
        url = "https://htmx.org/attributes/hx-vals";
      };
  ]

let additional_attributes =
  [
    Rich_attribute
      {
        name = "hx-confirm";
        jsxName = "hx_confirm";
        type_ = String;
        description = "shows a confirm() dialog before issuing a request";
        url = "https://htmx.org/attributes/hx-confirm";
      };
    Rich_attribute
      {
        name = "hx-delete";
        jsxName = "hx_delete";
        type_ = String;
        description = "issues a DELETE to the specified URL";
        url = "https://htmx.org/attributes/hx-delete";
      };
    Rich_attribute
      {
        name = "hx-disable";
        jsxName = "hx_disable";
        type_ = Bool;
        description =
          "disables htmx processing for the given node and any children nodes";
        url = "https://htmx.org/attributes/hx-disable";
      };
    Rich_attribute
      {
        name = "hx-disabled-elt";
        jsxName = "hx_disabled_elt";
        type_ = String;
        description =
          "adds the `disabled` attribute to the specified elements while a \
           request is in flight";
        url = "https://htmx.org/attributes/hx-disabled-elt";
      };
    Rich_attribute
      {
        name = "hx-disinherit";
        jsxName = "hx_disinherit";
        type_ = String;
        description =
          "control and disable automatic attribute inheritance for child nodes";
        url = "https://htmx.org/attributes/hx-disinherit";
      };
    Rich_attribute
      {
        name = "hx-encoding";
        jsxName = "hx_encoding";
        type_ = String;
        description = "changes the request encoding type";
        url = "https://htmx.org/attributes/hx-encoding";
      };
    Rich_attribute
      {
        name = "hx-ext";
        jsxName = "hx_ext";
        type_ = String;
        description = "extensions to use for this element";
        url = "https://htmx.org/attributes/hx-ext";
      };
    Rich_attribute
      {
        name = "hx-headers";
        jsxName = "hx_headers";
        type_ = String;
        description =
          "adds to the headers that will be submitted with the request";
        url = "https://htmx.org/attributes/hx-headers";
      };
    Rich_attribute
      {
        name = "hx-history";
        jsxName = "hx_history";
        type_ = BooleanishString;
        description = "prevent sensitive data being saved to the history cache";
        url = "https://htmx.org/attributes/hx-history";
      };
    Rich_attribute
      {
        name = "hx-history-elt";
        jsxName = "hx_history_elt";
        type_ = Bool;
        description =
          "the element to snapshot and restore during history navigation";
        url = "https://htmx.org/attributes/hx-history-elt";
      };
    Rich_attribute
      {
        name = "hx-include";
        jsxName = "hx_include";
        type_ = String;
        description = "include additional data in requests";
        url = "https://htmx.org/attributes/hx-include";
      };
    Rich_attribute
      {
        name = "hx-indicator";
        jsxName = "hx_indicator";
        type_ = String;
        description =
          "the element to put the htmx-request class on during the request";
        url = "https://htmx.org/attributes/hx-indicator";
      };
    Rich_attribute
      {
        name = "hx-params";
        jsxName = "hx_params";
        type_ = String;
        description =
          "filters the parameters that will be submitted with a request";
        url = "https://htmx.org/attributes/hx-params";
      };
    Rich_attribute
      {
        name = "hx-patch";
        jsxName = "hx_patch";
        type_ = String;
        description = "issues a PATCH to the specified URL";
        url = "https://htmx.org/attributes/hx-patch";
      };
    Rich_attribute
      {
        name = "hx-preserve";
        jsxName = "hx_preserve";
        type_ = Bool;
        description = "specifies elements to keep unchanged between requests";
        url = "https://htmx.org/attributes/hx-preserve";
      };
    Rich_attribute
      {
        name = "hx-prompt";
        jsxName = "hx_prompt";
        type_ = String;
        description = "shows a prompt() before submitting a request";
        url = "https://htmx.org/attributes/hx-prompt";
      };
    Rich_attribute
      {
        name = "hx-put";
        jsxName = "hx_put";
        type_ = String;
        description = "issues a PUT to the specified URL";
        url = "https://htmx.org/attributes/hx-put";
      };
    Rich_attribute
      {
        name = "hx-replace-url";
        jsxName = "hx_replace_url";
        type_ = String;
        description = "replace the URL in the browser location bar";
        url = "https://htmx.org/attributes/hx-replace-url";
      };
    Rich_attribute
      {
        name = "hx-request";
        jsxName = "hx_request";
        type_ = String;
        description = "configures various aspects of the request";
        url = "https://htmx.org/attributes/hx-request";
      };
    Rich_attribute
      {
        name = "hx-sync";
        jsxName = "hx_sync";
        type_ = String;
        description =
          "control how requests made by different elements are synchronized";
        url = "https://htmx.org/attributes/hx-get";
      };
    Rich_attribute
      {
        name = "hx-validate";
        jsxName = "hx_validate";
        type_ = Bool;
        description = "force elements to validate themselves before a request";
        url = "https://htmx.org/attributes/hx-validate";
      };
  ]

(* hx-on:* event handlers - https://htmx.org/attributes/hx-on/
   Note: hx-on::event uses double colon for htmx-specific events,
   hx-on:event uses single colon for standard DOM events *)
let event_attributes =
  [
    (* htmx-specific events (use hx-on::event format) *)
    Rich_attribute
      {
        name = "hx-on::abort";
        jsxName = "hx_on__abort";
        type_ = String;
        description = "handle htmx:abort event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::after-on-load";
        jsxName = "hx_on__after_on_load";
        type_ = String;
        description = "handle htmx:afterOnLoad event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::after-process-node";
        jsxName = "hx_on__after_process_node";
        type_ = String;
        description = "handle htmx:afterProcessNode event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::after-request";
        jsxName = "hx_on__after_request";
        type_ = String;
        description = "handle htmx:afterRequest event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::after-settle";
        jsxName = "hx_on__after_settle";
        type_ = String;
        description = "handle htmx:afterSettle event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::after-swap";
        jsxName = "hx_on__after_swap";
        type_ = String;
        description = "handle htmx:afterSwap event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::before-cleanup";
        jsxName = "hx_on__before_cleanup";
        type_ = String;
        description =
          "handle htmx:beforeCleanupElement event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::before-on-load";
        jsxName = "hx_on__before_on_load";
        type_ = String;
        description = "handle htmx:beforeOnLoad event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::before-process-node";
        jsxName = "hx_on__before_process_node";
        type_ = String;
        description = "handle htmx:beforeProcessNode event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::before-request";
        jsxName = "hx_on__before_request";
        type_ = String;
        description = "handle htmx:beforeRequest event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::before-swap";
        jsxName = "hx_on__before_swap";
        type_ = String;
        description = "handle htmx:beforeSwap event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::before-send";
        jsxName = "hx_on__before_send";
        type_ = String;
        description = "handle htmx:beforeSend event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::config-request";
        jsxName = "hx_on__config_request";
        type_ = String;
        description = "handle htmx:configRequest event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::confirm";
        jsxName = "hx_on__confirm";
        type_ = String;
        description = "handle htmx:confirm event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::history-cache-error";
        jsxName = "hx_on__history_cache_error";
        type_ = String;
        description = "handle htmx:historyCacheError event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::history-cache-miss";
        jsxName = "hx_on__history_cache_miss";
        type_ = String;
        description = "handle htmx:historyCacheMiss event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::history-cache-miss-error";
        jsxName = "hx_on__history_cache_miss_error";
        type_ = String;
        description =
          "handle htmx:historyCacheMissError event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::history-cache-miss-load";
        jsxName = "hx_on__history_cache_miss_load";
        type_ = String;
        description =
          "handle htmx:historyCacheMissLoad event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::history-restore";
        jsxName = "hx_on__history_restore";
        type_ = String;
        description = "handle htmx:historyRestore event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::before-history-save";
        jsxName = "hx_on__before_history_save";
        type_ = String;
        description = "handle htmx:beforeHistorySave event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::load";
        jsxName = "hx_on__load";
        type_ = String;
        description = "handle htmx:load event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::no-sse-source-error";
        jsxName = "hx_on__no_sse_source_error";
        type_ = String;
        description = "handle htmx:noSSESourceError event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::oob-after-swap";
        jsxName = "hx_on__oob_after_swap";
        type_ = String;
        description = "handle htmx:oobAfterSwap event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::oob-before-swap";
        jsxName = "hx_on__oob_before_swap";
        type_ = String;
        description = "handle htmx:oobBeforeSwap event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::oob-error-no-target";
        jsxName = "hx_on__oob_error_no_target";
        type_ = String;
        description = "handle htmx:oobErrorNoTarget event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::prompt";
        jsxName = "hx_on__prompt";
        type_ = String;
        description = "handle htmx:prompt event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::pushed-into-history";
        jsxName = "hx_on__pushed_into_history";
        type_ = String;
        description = "handle htmx:pushedIntoHistory event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::response-error";
        jsxName = "hx_on__response_error";
        type_ = String;
        description = "handle htmx:responseError event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::send-error";
        jsxName = "hx_on__send_error";
        type_ = String;
        description = "handle htmx:sendError event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::sse-error";
        jsxName = "hx_on__sse_error";
        type_ = String;
        description = "handle htmx:sseError event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::sse-open";
        jsxName = "hx_on__sse_open";
        type_ = String;
        description = "handle htmx:sseOpen event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::swap-error";
        jsxName = "hx_on__swap_error";
        type_ = String;
        description = "handle htmx:swapError event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::target-error";
        jsxName = "hx_on__target_error";
        type_ = String;
        description = "handle htmx:targetError event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::timeout";
        jsxName = "hx_on__timeout";
        type_ = String;
        description = "handle htmx:timeout event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::validation:validate";
        jsxName = "hx_on__validation_validate";
        type_ = String;
        description = "handle htmx:validation:validate event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::validation:failed";
        jsxName = "hx_on__validation_failed";
        type_ = String;
        description = "handle htmx:validation:failed event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::validation:halted";
        jsxName = "hx_on__validation_halted";
        type_ = String;
        description = "handle htmx:validation:halted event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::xhr:abort";
        jsxName = "hx_on__xhr_abort";
        type_ = String;
        description = "handle htmx:xhr:abort event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::xhr:loadend";
        jsxName = "hx_on__xhr_loadend";
        type_ = String;
        description = "handle htmx:xhr:loadend event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::xhr:loadstart";
        jsxName = "hx_on__xhr_loadstart";
        type_ = String;
        description = "handle htmx:xhr:loadstart event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on::xhr:progress";
        jsxName = "hx_on__xhr_progress";
        type_ = String;
        description = "handle htmx:xhr:progress event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    (* Standard DOM events (use hx-on:event format with single colon) *)
    Rich_attribute
      {
        name = "hx-on:click";
        jsxName = "hx_on_click";
        type_ = String;
        description = "handle click event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on:submit";
        jsxName = "hx_on_submit";
        type_ = String;
        description = "handle submit event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on:change";
        jsxName = "hx_on_change";
        type_ = String;
        description = "handle change event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on:input";
        jsxName = "hx_on_input";
        type_ = String;
        description = "handle input event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on:focus";
        jsxName = "hx_on_focus";
        type_ = String;
        description = "handle focus event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on:blur";
        jsxName = "hx_on_blur";
        type_ = String;
        description = "handle blur event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on:keyup";
        jsxName = "hx_on_keyup";
        type_ = String;
        description = "handle keyup event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on:keydown";
        jsxName = "hx_on_keydown";
        type_ = String;
        description = "handle keydown event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on:keypress";
        jsxName = "hx_on_keypress";
        type_ = String;
        description = "handle keypress event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on:mouseenter";
        jsxName = "hx_on_mouseenter";
        type_ = String;
        description = "handle mouseenter event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on:mouseleave";
        jsxName = "hx_on_mouseleave";
        type_ = String;
        description = "handle mouseleave event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on:mouseover";
        jsxName = "hx_on_mouseover";
        type_ = String;
        description = "handle mouseover event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on:mouseout";
        jsxName = "hx_on_mouseout";
        type_ = String;
        description = "handle mouseout event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on:load";
        jsxName = "hx_on_load";
        type_ = String;
        description = "handle load event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
    Rich_attribute
      {
        name = "hx-on:scroll";
        jsxName = "hx_on_scroll";
        type_ = String;
        description = "handle scroll event with inline script";
        url = "https://htmx.org/attributes/hx-on";
      };
  ]

(* SSE (Server-Sent Events) extension attributes
   https://htmx.org/extensions/sse/ *)
let sse_attributes =
  [
    Rich_attribute
      {
        name = "sse-connect";
        jsxName = "sse_connect";
        type_ = String;
        description = "specifies the URL for SSE connection";
        url = "https://htmx.org/extensions/sse/";
      };
    Rich_attribute
      {
        name = "sse-swap";
        jsxName = "sse_swap";
        type_ = String;
        description = "specifies the SSE message name to swap content on";
        url = "https://htmx.org/extensions/sse/";
      };
    Rich_attribute
      {
        name = "sse-close";
        jsxName = "sse_close";
        type_ = String;
        description =
          "specifies the SSE message name that closes the connection";
        url = "https://htmx.org/extensions/sse/";
      };
  ]

(* WebSocket extension attributes
   https://htmx.org/extensions/ws/ *)
let ws_attributes =
  [
    Rich_attribute
      {
        name = "ws-connect";
        jsxName = "ws_connect";
        type_ = String;
        description = "specifies the URL for WebSocket connection";
        url = "https://htmx.org/extensions/ws/";
      };
    Rich_attribute
      {
        name = "ws-send";
        jsxName = "ws_send";
        type_ = Bool;
        description =
          "sends a message to the WebSocket when the element is triggered";
        url = "https://htmx.org/extensions/ws/";
      };
  ]

let attributes =
  core_attributes @ additional_attributes @ event_attributes @ sse_attributes
  @ ws_attributes
