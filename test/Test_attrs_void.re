let log = ref([]);
let trace = (name, value) => {
  log := [name, ...log^];
  value;
};
let take_log = () => {
  let order = List.rev(log^);
  log := [];
  String.concat(",", order);
};

let dynamic_before_static =
  test("dynamic_before_static", () => {
    let v = "x";
    assert_string(
      JSX.render(<div class_=v tabindex=2 />),
      {|<div class="x" tabindex="2"></div>|},
    );
  });

let static_between_dynamic =
  test("static_between_dynamic", () => {
    let a = "a";
    let b = "b";
    assert_string(
      JSX.render(<div class_=a tabindex=2 id=b />),
      {|<div class="a" tabindex="2" id="b"></div>|},
    );
  });

let optional_before_static =
  test("optional_before_static", () => {
    let v = Some("x");
    assert_string(
      JSX.render(<div class_=?v tabindex=2 />),
      {|<div class="x" tabindex="2"></div>|},
    );
  });

let duplicate_attributes_keep_source_order =
  test("duplicate_attributes_keep_source_order", () => {
    let v = "dynamic";
    assert_string(
      JSX.render(<div id=v id="static" />),
      {|<div id="dynamic" id="static"></div>|},
    );
  });

let evaluation_order =
  test("evaluation_order", () => {
    ignore(
      JSX.render(
        <div class_={trace("class", "c")} id={trace("id", "i")}>
          {JSX.string(trace("child1", "a"))}
          {JSX.string(trace("child2", "b"))}
        </div>,
      ),
    );
    assert_string(take_log(), "class,id,child1,child2");
  });

let tests = (
  "Attributes and void elements",
  [
    dynamic_before_static,
    static_between_dynamic,
    optional_before_static,
    duplicate_attributes_keep_source_order,
    evaluation_order,
  ],
);
