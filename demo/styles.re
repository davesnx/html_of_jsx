let heading = ["margin: 0", "padding: 0"];

let join = String.concat("; ");
let h1 =
  join([
    "font-weight: 500",
    "font-size: calc((((((0.7rem + 0.13vw) * 1.25) * 1.25) * 1.25) * 1.25) * 1.25)",
    "letter-spacing: 0.8px;",
    "line-height: 2;",
    ...heading,
  ]);

let small = "font-size: 0.8rem";

let spacer = (~bottom=0, ~top=0, ~left=0, ~right=0, ()) =>
  join(
    (bottom != 0 ? [Printf.sprintf("margin-bottom: %dpx", bottom)] : [])
    @ (left != 0 ? [Printf.sprintf("margin-left: %dpx", left)] : [])
    @ (top != 0 ? [Printf.sprintf("margin-top: %dpx", top)] : [])
    @ (right != 0 ? [Printf.sprintf("margin-right: %dpx", right)] : []),
  );

let row = (~fullWidth=false, ~spread=false, gap) =>
  join(
    [
      "display: flex",
      "flex-direction: row",
      Printf.sprintf("gap: %dpx", gap),
    ]
    @ (fullWidth ? ["width: 100%"] : [])
    @ (spread ? ["justify-content: space-between"] : []),
  );

let stack = (~fullWidth=false, gap) =>
  join(
    [
      "display: flex",
      "flex-direction: column",
      Printf.sprintf("gap: %dpx", gap),
    ]
    @ (fullWidth ? ["width: 100%"] : []),
  );
