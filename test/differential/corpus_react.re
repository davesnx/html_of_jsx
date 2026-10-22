let case = (name, node, expected) => (name, JSX.render(node), expected);

let cls = "a\"b";
let for_ = Some("x&y");
let ro = true;

let cases = [
  case(
    "react static",
    <label className="c" htmlFor="f" />,
    Some({|<label class="c" for="f"></label>|}),
  ),
  case(
    "react dynamic",
    <label className=cls htmlFor="f"> {JSX.string("t")} </label>,
    Some({|<label class="a&quot;b" for="f">t</label>|}),
  ),
  case(
    "react optional",
    <label htmlFor=?for_ />,
    Some({|<label for="x&amp;y"></label>|}),
  ),
  case(
    "react readOnly static",
    <input readOnly=true />,
    Some({|<input readonly />|}),
  ),
  case(
    "react readOnly dynamic",
    <input readOnly=ro />,
    Some({|<input readonly />|}),
  ),
  case(
    "react tabIndex",
    <td colSpan=2 tabIndex=3 />,
    Some({|<td colspan="2" tabindex="3"></td>|}),
  ),
];
