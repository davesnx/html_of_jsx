let check = (~expected, ~actual, name) =>
  if (actual != expected) {
    Printf.eprintf(
      "%s failed:\n  expected: %s\n  actual:   %s\n",
      name,
      expected,
      actual,
    );
    exit(1);
  };

let counter = (~count) =>
  <div x_data="{ open: false }" x_init="setup()">
    <button x_on_click="open = !open" x_bind_class="{ active: open }">
      {JSX.string("Toggle")}
    </button>
    <span x_show="open" x_text=count x_cloak=true x_transition=true />
  </div>;

let () = {
  check(
    "directives",
    ~expected=
      {|<div x-data="{ open: false }" x-init="setup()"><button x-on:click="open = !open" x-bind:class="{ active: open }">Toggle</button><span x-show="open" x-text="count" x-cloak x-transition></span></div>|},
    ~actual=JSX.render(counter(~count="count")),
  );
  check(
    "transition classes",
    ~expected=
      {|<div x-transition:enter="ease-out" x-transition:enter-start="opacity-0" x-transition:leave-end="opacity-0"></div>|},
    ~actual=
      JSX.render(
        <div
          x_transition_enter="ease-out"
          x_transition_enter_start="opacity-0"
          x_transition_leave_end="opacity-0"
        />,
      ),
  );
  check(
    "kebab-case event names",
    ~expected={|<div x-on:my-event="go()" x-bind:aria-label="label"></div>|},
    ~actual=
      JSX.render(<div x_on_my_event="go()" x_bind_aria_label="label" />),
  );
  check(
    "template directives",
    ~expected=
      {|<template x-for="item in items" x-ref="list" x-id="[&apos;tab&apos;]"></template>|},
    ~actual=
      JSX.render(
        <template x_for="item in items" x_ref="list" x_id="['tab']" />,
      ),
  );
};
