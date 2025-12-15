let simple_hx_boost =
  test("simple_hx_boost", () => {
    assert_string(JSX.render(<div hx_boost=true />), {|<div hx-boost="true"></div>|})
  });

/* SSE Extension Tests */
let sse_connect =
  test("sse_connect", () => {
    assert_string(
      JSX.render(<div hx_ext="sse" sse_connect="/events" />),
      {|<div hx-ext="sse" sse-connect="/events"></div>|},
    )
  });

let sse_swap =
  test("sse_swap", () => {
    assert_string(JSX.render(<div sse_swap="message" />), {|<div sse-swap="message"></div>|})
  });

let sse_close =
  test("sse_close", () => {
    assert_string(JSX.render(<div sse_close="done" />), {|<div sse-close="done"></div>|})
  });

let sse_complete =
  test("sse_complete", () => {
    assert_string(
      JSX.render(<div hx_ext="sse" sse_connect="/events" sse_swap="message"> {JSX.string("Loading...")} </div>),
      {|<div hx-ext="sse" sse-connect="/events" sse-swap="message">Loading...</div>|},
    )
  });

/* WebSocket Extension Tests */
let ws_connect =
  test("ws_connect", () => {
    assert_string(JSX.render(<div hx_ext="ws" ws_connect="/chat" />), {|<div hx-ext="ws" ws-connect="/chat"></div>|})
  });

let ws_send = test("ws_send", () => {
                assert_string(JSX.render(<form ws_send=true />), {|<form ws-send></form>|})
              });

let ws_complete =
  test("ws_complete", () => {
    assert_string(
      JSX.render(
        <div hx_ext="ws" ws_connect="/chat"> <form ws_send=true> <input type_="text" name="message" /> </form> </div>,
      ),
      {|<div hx-ext="ws" ws-connect="/chat"><form ws-send><input type="text" name="message" /></form></div>|},
    )
  });

/* Class-tools Extension Tests */
let classes =
  test("classes", () => {
    assert_string(
      JSX.render(<div hx_ext="class-tools" classes="add highlight:1s" />),
      {|<div hx-ext="class-tools" classes="add highlight:1s"></div>|},
    )
  });

/* Preload Extension Tests */
let preload =
  test("preload", () => {
    assert_string(
      JSX.render(<a hx_ext="preload" preload="mouseover" href="/page" />),
      {|<a hx-ext="preload" preload="mouseover" href="/page"></a>|},
    )
  });

/* Path-deps Extension Tests */
let path_deps =
  test("path_deps", () => {
    assert_string(
      JSX.render(<div hx_ext="path-deps" path_deps="/api/todos" hx_get="/todos" hx_trigger="path-deps" />),
      {|<div hx-ext="path-deps" path-deps="/api/todos" hx-get="/todos" hx-trigger="path-deps"></div>|},
    )
  });

/* Loading-states Extension Tests */
let loading_states_basic =
  test("loading_states_basic", () => {
    assert_string(
      JSX.render(<div data_loading_states=true data_loading=true />),
      {|<div data-loading-states data-loading></div>|},
    )
  });

let loading_states_class =
  test("loading_states_class", () => {
    assert_string(
      JSX.render(<div data_loading_class="is-loading" />),
      {|<div data-loading-class="is-loading"></div>|},
    )
  });

let loading_states_disable =
  test("loading_states_disable", () => {
    assert_string(JSX.render(<button data_loading_disable=true />), {|<button data-loading-disable></button>|})
  });

let loading_states_delay =
  test("loading_states_delay", () => {
    assert_string(
      JSX.render(<div data_loading=true data_loading_delay="200ms" />),
      {|<div data-loading data-loading-delay="200ms"></div>|},
    )
  });

let loading_states_target =
  test("loading_states_target", () => {
    assert_string(
      JSX.render(<div data_loading_target="#spinner" data_loading_class="visible" />),
      {|<div data-loading-target="#spinner" data-loading-class="visible"></div>|},
    )
  });

let tests = (
  "Htmx",
  [
    /* Core */
    simple_hx_boost,
    /* SSE Extension */
    sse_connect,
    sse_swap,
    sse_close,
    sse_complete,
    /* WebSocket Extension */
    ws_connect,
    ws_send,
    ws_complete,
    /* Class-tools Extension */
    classes,
    /* Preload Extension */
    preload,
    /* Path-deps Extension */
    path_deps,
    /* Loading-states Extension */
    loading_states_basic,
    loading_states_class,
    loading_states_disable,
    loading_states_delay,
    loading_states_target,
  ],
);
