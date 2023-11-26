(** https://htmx.org/reference/ *)

(* TODO:
    - How to make values on here available on the runtime (ppx_runtime_deps + using them here)
      - hx-headers or hx-vals wants json
      - hx-replace-url is true | false | string
    - Extensions?
       - https://htmx.org/extensions/web-sockets/
       - https://htmx.org/extensions/server-sent-events/
   - Events ?
     - Support for "js:" prefix on hx-request and hx-vals
*)

open Ppx_attributes

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
    (*
        Not sure how to support those

        Rich_attribute
         {
           name = "hx-on";
           jsxName = "hx_on";
           type_ =
             String;
            description =
                "handle any event with a script inline";
            url = "https://htmx.org/attributes/hx-on";
         }; *)
    (* Attribute
       {
         name = "hx-push-url";
         jsxName = "hx_push_url";
         type_ =
           String;
            description =
              "pushes the URL into the browser location bar, creating a new history entry";
            url = "https://htmx.org/attributes/hx-get";
       }; *)
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

let attributes = core_attributes @ additional_attributes
