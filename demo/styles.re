let join = String.concat("; ");

let spacer = (~bottom=0, ~top=0, ~left=0, ~right=0, ()) =>
  join(
    (bottom != 0 ? [Printf.sprintf("margin-bottom: %dpx", bottom)] : [])
    @ (left != 0 ? [Printf.sprintf("margin-left: %dpx", left)] : [])
    @ (top != 0 ? [Printf.sprintf("margin-top: %dpx", top)] : [])
    @ (right != 0 ? [Printf.sprintf("margin-right: %dpx", right)] : []),
  );

module Align = {
  type t = [ | `center | `start | `end_];
  let to_s = align =>
    switch (align) {
    | `center => "center"
    | `start => "start"
    | `end_ => "end"
    };
};

let row = (~fullWidth=false, ~spread=false, ~align=`start, gap) =>
  join(
    [
      "display: flex",
      "flex-direction: row",
      Printf.sprintf("gap: %dpx", gap),
      Printf.sprintf("align-items: %s", Align.to_s(align)),
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

module Font = {
  let small = "font-size: 0.8rem";
  let large = "font-size: 1.2rem";
  let semibold = "font-weight: 600";
};

let reset = ["margin: 0", "padding: 0"];

let dark = "color-scheme: dark";

let body =
  join([
    "display: flex",
    "justify-items: center",
    "padding-top: 7em",
    "padding-left: 25%",
    "padding-right: 25%",
  ]);

let h1 =
  join([
    "font-weight: 500",
    "font-size: calc((((((0.7rem + 0.13vw) * 1.25) * 1.25) * 1.25) * 1.25) * 1.25)",
    "letter-spacing: 0.8px",
    "line-height: 2",
    ...reset,
  ]);

let link = (~bold, color) => {
  join(
    [Printf.sprintf("color: %s", color), "text-decoration: underline"]
    @ (bold ? ["font-weight: bold"] : []),
  );
};

let dimmed = "color: #666";
