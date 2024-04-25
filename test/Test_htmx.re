let simple_hx_boost =
  case("simple_hx_boost", () => {
    assert_string(
      Html_of_jsx.render(<div hx_boost=true />),
      {|<div hx-boost="true"></div>|},
    )
  });

let tests = ("Htmx", [simple_hx_boost]);
