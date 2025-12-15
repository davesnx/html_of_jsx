let simple_hx_boost =
  test("simple_hx_boost", () => {
    assert_string(JSX.render(<div hx_boost=true />), {|<div hx-boost="true"></div>|})
  });

let tests = ("Htmx", [simple_hx_boost]);
