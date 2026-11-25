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

let booleanish = (~spellcheck=?, ()) => <div ?spellcheck />;

let with_optionals = (~id=?, ~tabindex=?, ~disabled=?, ()) =>
  <button ?id ?tabindex ?disabled />;

let mixed = name => <div class_="container"> {JSX.string(name)} </div>;

let fragment = name => <> <span /> {JSX.string(name)} </>;

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
  check(
    "fragment",
    ~expected="<span></span>a &amp; b",
    ~actual=JSX.render(fragment("a & b")),
  );
};

let log = ref([]);
let trace = (name, value) => {
  log := [name, ...log^];
  value;
};

let () = {
  ignore(
    JSX.render(
      <div class_={trace("class", "c")} id={trace("id", "i")}>
        {JSX.string(trace("child1", "a"))}
        {JSX.string(trace("child2", "b"))}
      </div>,
    ),
  );
  check(
    "evaluation order",
    ~expected="class,id,child1,child2",
    ~actual=String.concat(",", List.rev(log^)),
  );
  let v = "x";
  check(
    "attribute order",
    ~expected="<div class=\"x\" tabindex=\"2\"></div>",
    ~actual=JSX.render(<div class_=v tabindex=2 />),
  );
};
