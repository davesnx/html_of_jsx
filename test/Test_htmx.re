/* Core attributes */
let test_hx_boost =
  test("hx_boost", () => {
    assert_string(JSX.render(<div hx_boost=true />), {|<div hx-boost="true"></div>|})
  });

let test_hx_get =
  test("hx_get", () => {
    assert_string(JSX.render(<div hx_get="/api/data" />), {|<div hx-get="/api/data"></div>|})
  });

let test_hx_post =
  test("hx_post", () => {
    assert_string(JSX.render(<form hx_post="/api/submit" />), {|<form hx-post="/api/submit"></form>|})
  });

let test_hx_put =
  test("hx_put", () => {
    assert_string(JSX.render(<button hx_put="/api/update" />), {|<button hx-put="/api/update"></button>|})
  });

let test_hx_patch =
  test("hx_patch", () => {
    assert_string(JSX.render(<button hx_patch="/api/patch" />), {|<button hx-patch="/api/patch"></button>|})
  });

let test_hx_delete =
  test("hx_delete", () => {
    assert_string(JSX.render(<button hx_delete="/api/delete" />), {|<button hx-delete="/api/delete"></button>|})
  });

let test_hx_push_url =
  test("hx_push_url", () => {
    assert_string(JSX.render(<a hx_get="/page" hx_push_url="true" />), {|<a hx-get="/page" hx-push-url="true"></a>|})
  });

let test_hx_push_url_with_path =
  test("hx_push_url with path", () => {
    assert_string(
      JSX.render(<a hx_get="/page" hx_push_url="/custom-url" />),
      {|<a hx-get="/page" hx-push-url="/custom-url"></a>|},
    )
  });

let test_hx_select =
  test("hx_select", () => {
    assert_string(
      JSX.render(<div hx_get="/page" hx_select="#content" />),
      {|<div hx-get="/page" hx-select="#content"></div>|},
    )
  });

let test_hx_swap =
  test("hx_swap", () => {
    assert_string(
      JSX.render(<div hx_get="/data" hx_swap="outerHTML" />),
      {|<div hx-get="/data" hx-swap="outerHTML"></div>|},
    )
  });

let test_hx_target =
  test("hx_target", () => {
    assert_string(
      JSX.render(<button hx_get="/data" hx_target="#result" />),
      {|<button hx-get="/data" hx-target="#result"></button>|},
    )
  });

let test_hx_trigger =
  test("hx_trigger", () => {
    assert_string(
      JSX.render(<div hx_get="/data" hx_trigger="click" />),
      {|<div hx-get="/data" hx-trigger="click"></div>|},
    )
  });

let test_hx_vals =
  test("hx_vals", () => {
    assert_string(
      JSX.render(<form hx_post="/api" hx_vals={|{"key": "value"}|} />),
      {|<form hx-post="/api" hx-vals="{&quot;key&quot;: &quot;value&quot;}"></form>|},
    )
  });

/* Additional attributes */
let test_hx_confirm =
  test("hx_confirm", () => {
    assert_string(
      JSX.render(<button hx_delete="/item" hx_confirm="Are you sure?" />),
      {|<button hx-delete="/item" hx-confirm="Are you sure?"></button>|},
    )
  });

let test_hx_disable =
  test("hx_disable", () => {
    assert_string(JSX.render(<div hx_disable=true />), {|<div hx-disable></div>|})
  });

let test_hx_indicator =
  test("hx_indicator", () => {
    assert_string(
      JSX.render(<button hx_post="/api" hx_indicator="#spinner" />),
      {|<button hx-post="/api" hx-indicator="#spinner"></button>|},
    )
  });

let test_hx_include =
  test("hx_include", () => {
    assert_string(
      JSX.render(<button hx_post="/api" hx_include="[name=token]" />),
      {|<button hx-post="/api" hx-include="[name=token]"></button>|},
    )
  });

let test_hx_headers =
  test("hx_headers", () => {
    assert_string(
      JSX.render(<div hx_get="/api" hx_headers={|{"X-Custom": "value"}|} />),
      {|<div hx-get="/api" hx-headers="{&quot;X-Custom&quot;: &quot;value&quot;}"></div>|},
    )
  });

let test_hx_replace_url =
  test("hx_replace_url", () => {
    assert_string(
      JSX.render(<a hx_get="/page" hx_replace_url="true" />),
      {|<a hx-get="/page" hx-replace-url="true"></a>|},
    )
  });

let test_hx_preserve =
  test("hx_preserve", () => {
    assert_string(JSX.render(<div hx_preserve=true />), {|<div hx-preserve></div>|})
  });

let test_hx_prompt =
  test("hx_prompt", () => {
    assert_string(
      JSX.render(<button hx_post="/api" hx_prompt="Enter value:" />),
      {|<button hx-post="/api" hx-prompt="Enter value:"></button>|},
    )
  });

/* hx-on:* DOM event handlers */
let test_hx_on_click =
  test("hx_on_click", () => {
    assert_string(
      JSX.render(<button hx_on_click="handleClick()" />),
      {|<button hx-on:click="handleClick()"></button>|},
    )
  });

let test_hx_on_submit =
  test("hx_on_submit", () => {
    assert_string(JSX.render(<form hx_on_submit="validate()" />), {|<form hx-on:submit="validate()"></form>|})
  });

let test_hx_on_change =
  test("hx_on_change", () => {
    assert_string(
      JSX.render(<input hx_on_change="update(this.value)" />),
      {|<input hx-on:change="update(this.value)" />|},
    )
  });

let test_hx_on_keyup =
  test("hx_on_keyup", () => {
    assert_string(
      JSX.render(<input hx_on_keyup="search(this.value)" />),
      {|<input hx-on:keyup="search(this.value)" />|},
    )
  });

let test_hx_on_mouseenter =
  test("hx_on_mouseenter", () => {
    assert_string(
      JSX.render(<div hx_on_mouseenter="showTooltip()" />),
      {|<div hx-on:mouseenter="showTooltip()"></div>|},
    )
  });

/* hx-on::* htmx event handlers */
let test_hx_on__after_swap =
  test("hx_on__after_swap", () => {
    assert_string(
      JSX.render(<div hx_get="/data" hx_on__after_swap="handleSwap()" />),
      {|<div hx-get="/data" hx-on::after-swap="handleSwap()"></div>|},
    )
  });

let test_hx_on__before_request =
  test("hx_on__before_request", () => {
    assert_string(
      JSX.render(<div hx_get="/data" hx_on__before_request="showSpinner()" />),
      {|<div hx-get="/data" hx-on::before-request="showSpinner()"></div>|},
    )
  });

let test_hx_on__after_request =
  test("hx_on__after_request", () => {
    assert_string(
      JSX.render(<div hx_get="/data" hx_on__after_request="hideSpinner()" />),
      {|<div hx-get="/data" hx-on::after-request="hideSpinner()"></div>|},
    )
  });

let test_hx_on__response_error =
  test("hx_on__response_error", () => {
    assert_string(
      JSX.render(<div hx_get="/data" hx_on__response_error="handleError(event)" />),
      {|<div hx-get="/data" hx-on::response-error="handleError(event)"></div>|},
    )
  });

let test_hx_on__load =
  test("hx_on__load", () => {
    assert_string(
      JSX.render(<div hx_get="/data" hx_on__load="initComponent()" />),
      {|<div hx-get="/data" hx-on::load="initComponent()"></div>|},
    )
  });

let test_hx_on__confirm =
  test("hx_on__confirm", () => {
    assert_string(
      JSX.render(<button hx_delete="/item" hx_on__confirm="customConfirm(event)" />),
      {|<button hx-delete="/item" hx-on::confirm="customConfirm(event)"></button>|},
    )
  });

/* SSE extension attributes */
let test_sse_connect =
  test("sse_connect", () => {
    assert_string(
      JSX.render(<div hx_ext="sse" sse_connect="/events" />),
      {|<div hx-ext="sse" sse-connect="/events"></div>|},
    )
  });

let test_sse_swap =
  test("sse_swap", () => {
    assert_string(
      JSX.render(<div hx_ext="sse" sse_connect="/events" sse_swap="message" />),
      {|<div hx-ext="sse" sse-connect="/events" sse-swap="message"></div>|},
    )
  });

let test_sse_close =
  test("sse_close", () => {
    assert_string(
      JSX.render(<div sse_connect="/events" sse_close="done" />),
      {|<div sse-connect="/events" sse-close="done"></div>|},
    )
  });

/* WebSocket extension attributes */
let test_ws_connect =
  test("ws_connect", () => {
    assert_string(JSX.render(<div hx_ext="ws" ws_connect="/chat" />), {|<div hx-ext="ws" ws-connect="/chat"></div>|})
  });

let test_ws_send =
  test("ws_send", () => {
    assert_string(JSX.render(<form ws_send=true />), {|<form ws-send></form>|})
  });

/* Combined attributes */
let test_combined_attrs =
  test("combined attributes", () => {
    assert_string(
      JSX.render(
        <button
          hx_post="/api/submit"
          hx_target="#result"
          hx_swap="innerHTML"
          hx_confirm="Are you sure?"
          hx_indicator="#spinner"
        />,
      ),
      {|<button hx-post="/api/submit" hx-target="#result" hx-swap="innerHTML" hx-confirm="Are you sure?" hx-indicator="#spinner"></button>|},
    )
  });

let test_full_sse_example =
  test("full SSE example", () => {
    assert_string(
      JSX.render(<div hx_ext="sse" sse_connect="/events" sse_swap="message" sse_close="done" />),
      {|<div hx-ext="sse" sse-connect="/events" sse-swap="message" sse-close="done"></div>|},
    )
  });

let test_full_ws_example =
  test("full WebSocket example", () => {
    assert_string(
      JSX.render(<div hx_ext="ws" ws_connect="/chat"> <form ws_send=true /> </div>),
      {|<div hx-ext="ws" ws-connect="/chat"><form ws-send></form></div>|},
    )
  });

let tests = (
  "Htmx",
  [
    /* Core attributes */
    test_hx_boost,
    test_hx_get,
    test_hx_post,
    test_hx_put,
    test_hx_patch,
    test_hx_delete,
    test_hx_push_url,
    test_hx_push_url_with_path,
    test_hx_select,
    test_hx_swap,
    test_hx_target,
    test_hx_trigger,
    test_hx_vals,
    /* Additional attributes */
    test_hx_confirm,
    test_hx_disable,
    test_hx_indicator,
    test_hx_include,
    test_hx_headers,
    test_hx_replace_url,
    test_hx_preserve,
    test_hx_prompt,
    /* DOM event handlers */
    test_hx_on_click,
    test_hx_on_submit,
    test_hx_on_change,
    test_hx_on_keyup,
    test_hx_on_mouseenter,
    /* htmx event handlers */
    test_hx_on__after_swap,
    test_hx_on__before_request,
    test_hx_on__after_request,
    test_hx_on__response_error,
    test_hx_on__load,
    test_hx_on__confirm,
    /* SSE extension */
    test_sse_connect,
    test_sse_swap,
    test_sse_close,
    /* WebSocket extension */
    test_ws_connect,
    test_ws_send,
    /* Combined examples */
    test_combined_attrs,
    test_full_sse_example,
    test_full_ws_example,
  ],
);
