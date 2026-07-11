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

/* Optional booleanish-string attribute: regression test for the unoptimized
   path generating `Bool.to_string(v: bool option)`. */
let booleanish = (~spellcheck=?, ()) => <div ?spellcheck />;

/* Optional string, int and bool attributes through the JSX.node path. */
let with_optionals = (~id=?, ~tabindex=?, ~disabled=?, ()) =>
  <button ?id ?tabindex ?disabled />;

/* Static + dynamic mix through the JSX.node path. */
let mixed = name => <div class_="container"> {JSX.string(name)} </div>;

let () = {
  check(
    "booleanish some",
    ~expected="<div spellcheck=\"true\"></div>",
    ~actual=JSX.render(booleanish(~spellcheck=true, ())),
  );
  check(
    "booleanish none",
    ~expected="<div></div>",
    ~actual=JSX.render(booleanish()),
  );
  check(
    "optionals all set",
    ~expected="<button id=\"a\" tabindex=\"1\" disabled></button>",
    ~actual=
      JSX.render(with_optionals(~id="a", ~tabindex=1, ~disabled=true, ())),
  );
  check(
    "optionals none",
    ~expected="<button></button>",
    ~actual=JSX.render(with_optionals()),
  );
  check(
    "mixed",
    ~expected="<div class=\"container\">Hello &amp; bye</div>",
    ~actual=JSX.render(mixed("Hello & bye")),
  );
};
