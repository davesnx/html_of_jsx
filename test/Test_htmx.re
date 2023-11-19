let wat =
  case("wat", () => {
    assert_string(Html_of_jsx.render(<div />), "<div></div>")
  });

let tests = ("Htmx", [wat]);
