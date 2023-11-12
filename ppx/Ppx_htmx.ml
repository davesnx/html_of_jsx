(** https://htmx.org/reference/ *)

(* TODO:
    - Events ?
   - How to make values on here available on the runtime (ppx_runtime_deps + using them here)
     - hx-headers or hx-vals want json
     - hx-replace-url is true | false | string
   - https://htmx.org/extensions/web-sockets/
   - https://htmx.org/extensions/server-sent-events/
    - Support for "js:" prefix on hx-request and hx-vals
*)

open Ppx_attributes

let core_attributes =
  [
    Attribute
      {
        name = "hx-boost";
        jsxName = "hx_boost";
        type_ = BooleanishString;
        (* description =
           Some "add or remove progressive enhancement for links and forms"; *)
        (* url = Some "https://htmx.org/attributes/hx-boost" *)
      };
    Attribute
      {
        name = "hx-get";
        jsxName = "hx_get";
        type_ = String;
        (* description =
           Some "issues a GET to the specified URL"; *)
        (* url = Some "https://htmx.org/attributes/hx-get/" *)
      };
    Attribute
      {
        name = "hx-post";
        jsxName = "hx_post";
        type_ =
          String
          (* description =
               Some "issues a POST to the specified URL"; *)
          (* url = Some "https://htmx.org/attributes/hx-post/" *);
      };
    (*
        Not sure how to support those

        Attribute
         {
           name = "hx-on";
           jsxName = "hx_on";
           type_ =
             String
             (* description =
                  Some "handle any event with a script inline"; *)
             (* url = Some "https://htmx.org/attributes/hx-on/" *);
         }; *)
    (* Attribute
       {
         name = "hx-push-url";
         jsxName = "hx_push_url";
         type_ =
           String
           (* description =
              Some "pushes the URL into the browser location bar, creating a new history entry"; *)
           (* url = Some "https://htmx.org/attributes/hx-get/" *);
       }; *)
    Attribute
      {
        name = "hx-select";
        jsxName = "hx_select";
        type_ =
          String
          (* description =
             Some "select content to swap in from a response"; *)
          (* url = Some "https://htmx.org/attributes/hx-select/" *);
      };
    Attribute
      {
        name = "hx-select-oob";
        jsxName = "hx_select_oob";
        type_ = String;
        (* description =
           Some "select content to swap in from a response, out of band (somewhere other than the target)"; *)
        (* url = Some "https://htmx.org/attributes/hx-select-oob/" *)
      };
    Attribute
      {
        name = "hx-swap";
        jsxName = "hx_swap";
        type_ =
          String
          (* description =
               Some "marks content in a response to be out of band (should swap in somewhere other than the target)"; *)
          (* url = Some "https://htmx.org/attributes/hx-swap/" *);
      };
    Attribute
      {
        name = "hx-swap-oob";
        jsxName = "hx_swap_oob";
        type_ =
          String
          (* description =
             Some "specifies the target element to be swapped"; *)
          (* url = Some "https://htmx.org/attributes/hx-swap-oob/" *);
      };
    Attribute
      {
        name = "hx-target";
        jsxName = "hx_target";
        type_ =
          String
          (* description =
             Some "specifies the event that triggers the request"; *)
          (* url = Some "https://htmx.org/attributes/hx-target/" *);
      };
    Attribute
      {
        name = "hx-vals";
        jsxName = "hx_vals";
        type_ =
          String
          (* description =
               Some "adds values to the parameters to submit with the request (JSON-formatted)"; *)
          (* url = Some "https://htmx.org/attributes/hx-vals/" *);
      };
  ]

let additional_attributes =
  [
    Attribute
      {
        name = "hx-confirm";
        jsxName = "hx_confirm";
        type_ =
          String
          (* description =
             Some "shows a confirm() dialog before issuing a request"; *)
          (* url = Some "https://htmx.org/attributes/hx-confirm/" *);
      };
    Attribute
      {
        name = "hx-delete";
        jsxName = "hx_delete";
        type_ =
          String
          (* description =
             Some "issues a DELETE to the specified URL"; *)
          (* url = Some "https://htmx.org/attributes/hx-delete/" *);
      };
    Attribute
      {
        name = "hx-disable";
        jsxName = "hx_disable";
        type_ =
          Bool
          (* description =
                 Some "disables htmx processing for the given node and any children nodes"; *)
          (* url = Some "https://htmx.org/attributes/hx-disable/" *);
      };
    Attribute
      {
        name = "hx-disabled-elt";
        jsxName = "hx_disabled_elt";
        type_ = String;
        (* description =
             Some "adds the `disabled` attribute to the specified elements while a request is in flight"; *)
        (* url = Some "https://htmx.org/attributes/hx-disabled-elt/" *)
      };
    Attribute
      {
        name = "hx-disinherit";
        jsxName = "hx_disinherit";
        type_ = String;
        (* description =
             Some "control and disable automatic attribute inheritance for child nodes"; *)
        (* url = Some "https://htmx.org/attributes/hx-disinherit/" *)
      };
    Attribute
      {
        name = "hx-encoding";
        jsxName = "hx_encoding";
        type_ =
          String
          (* description =
             Some "changes the request encoding type"; *)
          (* url = Some "https://htmx.org/attributes/hx-encoding/" *);
      };
    Attribute
      {
        name = "hx-ext";
        jsxName = "hx_ext";
        type_ =
          String
          (* description =
               Some "extensions to use for this element"; *)
          (* url = Some "https://htmx.org/attributes/hx-ext/" *);
      };
    Attribute
      {
        name = "hx-headers";
        jsxName = "hx_headers";
        type_ =
          String
          (* description =
             Some "adds to the headers that will be submitted with the request"; *)
          (* url = Some "https://htmx.org/attributes/hx-headers/" *);
      };
    Attribute
      {
        name = "hx-history";
        jsxName = "hx_history";
        type_ =
          BooleanishString
          (* description =
             Some "prevent sensitive data being saved to the history cache"; *)
          (* url = Some "https://htmx.org/attributes/hx-history/" *);
      };
    Attribute
      {
        name = "hx-history-elt";
        jsxName = "hx_history_elt";
        type_ = Bool;
        (* description =
             Some "the element to snapshot and restore during history navigation"; *)
        (* url = Some "https://htmx.org/attributes/hx-history-elt/" *)
      };
    Attribute
      {
        name = "hx-include";
        jsxName = "hx_include";
        type_ =
          String
          (* description =
             Some "include additional data in requests"; *)
          (* url = Some "https://htmx.org/attributes/hx-include/" *);
      };
    Attribute
      {
        name = "hx-indicator";
        jsxName = "hx_indicator";
        type_ =
          String
          (* description =
             Some "the element to put the htmx-request class on during the request"; *)
          (* url = Some "https://htmx.org/attributes/hx-indicator/" *);
      };
    Attribute
      {
        name = "hx-params";
        jsxName = "hx_params";
        type_ =
          String
          (* description =
             Some "filters the parameters that will be submitted with a request"; *)
          (* url = Some "https://htmx.org/attributes/hx-params/" *);
      };
    Attribute
      {
        name = "hx-patch";
        jsxName = "hx_patch";
        type_ =
          String
          (* description =
             Some "issues a PATCH to the specified URL"; *)
          (* url = Some "https://htmx.org/attributes/hx-patch/" *);
      };
    Attribute
      {
        name = "hx-preserve";
        jsxName = "hx_preserve";
        type_ =
          Bool
          (* description =
             Some "specifies elements to keep unchanged between requests"; *)
          (* url = Some "https://htmx.org/attributes/hx-preserve/" *);
      };
    Attribute
      {
        name = "hx-prompt";
        jsxName = "hx_prompt";
        type_ =
          String
          (* description =
             Some "shows a prompt() before submitting a request"; *)
          (* url = Some "https://htmx.org/attributes/hx-prompt/" *);
      };
    Attribute
      {
        name = "hx-put";
        jsxName = "hx_put";
        type_ =
          String
          (* description =
             Some "issues a PUT to the specified URL"; *)
          (* url = Some "https://htmx.org/attributes/hx-put/" *);
      };
    Attribute
      {
        name = "hx-replace-url";
        jsxName = "hx_replace_url";
        type_ = String;
        (* description =
           Some "replace the URL in the browser location bar"; *)
        (* url = Some "https://htmx.org/attributes/hx-replace-url/" *)
      };
    Attribute
      {
        name = "hx-request";
        jsxName = "hx_request";
        type_ =
          String
          (* description =
             Some "configures various aspects of the request"; *)
          (* url = Some "https://htmx.org/attributes/hx-request/" *);
      };
    Attribute
      {
        name = "hx-sync";
        jsxName = "hx_sync";
        type_ =
          String
          (* description = Some "control how requests made by different elements are synchronized
             "; *)
          (* url = Some "https://htmx.org/attributes/hx-get/" *);
      };
    Attribute
      {
        name = "hx-validate";
        jsxName = "hx_validate";
        type_ =
          Bool
          (* description =
             Some "force elements to validate themselves before a request"; *)
          (* url = Some "https://htmx.org/attributes/hx-validate/" *);
      };
  ]

let attributes = core_attributes @ additional_attributes
