let wat =
  case("wat", () => {
    assert_string(Html_of_jsx.render(<div hx_boost=true />), "<div></div>")
  });

let tests = ("Htmx", [wat]);
