module Styles = {
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
      ["display: flex", "flex-direction: column", Printf.sprintf("gap: %dpx", gap)]
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
    join(["display: flex", "justify-items: center", "padding-top: 7em", "padding-left: 25%", "padding-right: 25%"]);

  let h1 =
    join([
      "font-weight: 500",
      "font-size: calc((((((0.7rem + 0.13vw) * 1.25) * 1.25) * 1.25) * 1.25) * 1.25)",
      "letter-spacing: 0.8px",
      "line-height: 2",
      ...reset,
    ]);

  let link = (~bold, color) => {
    join([Printf.sprintf("color: %s", color), "text-decoration: underline"] @ (bold ? ["font-weight: bold"] : []));
  };

  let dimmed = "color: #666";
};

module Link = {
  let make = (~color, ~to_, ~bold=false, ~children, ()) => {
    <a
      href=to_
      onmouseover="this.style.opacity='0.6'"
      onmouseout="this.style.opacity='1'"
      style={Styles.link(~bold, color)}>
      children
    </a>;
  };
};

module Page = {
  let make = (~project_url, ()) => {
    <html lang="en" style=Styles.dark>
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title> "HTML OF JSX" </title>
        <link rel="shortcut icon" href="https://reasonml.github.io/img/icon_50.png" />
        <style type_="text/css">
          {| html {
              height: 100vh;
              width: 100vw;
              margin: 0;
              padding: 0;
              line-height: 1.5;
              tab-size: 4;
              font-family: ui-sans-serif, system-ui, sans-serif;
              font-feature-settings: normal;
              font-variation-settings: normal;
              -webkit-text-size-adjust: 100%;
              -webkit-tap-highlight-color: transparent;
            }
          |}
        </style>
      </head>
      <body style=Styles.body>
        <div>
          <main>
            <header style={Styles.stack(10)}>
              <div style={Styles.row(~spread=true, ~fullWidth=true, ~align=`center, 100)}>
                <Link color="#777" to_=project_url> <p> {JSX.string(project_url)} </p> </Link>
                <div style={Styles.row(4)}>
                  <span style=Styles.dimmed> "by " </span>
                  <Link to_="https://x.com/davesnx" color="#777"> "@davesnx" </Link>
                </div>
              </div>
            </header>
          </main>
          <div>
            <main style=Styles.Font.large>
              <div>
                <div style={Styles.spacer(~bottom=16, ())}> <h1 style=Styles.h1> "Html_of_jsx" </h1> </div>
                <div>
                  <div>
                    <p>
                      <span style=Styles.Font.semibold> "html_of_jsx" </span>
                      <span>
                        " is an implementation of JSX designed to render HTML on the server, without React or anything else. It's a minimal library that allows you to write components of HTML in a declarative way."
                      </span>
                    </p>
                    <div style={Styles.spacer(~bottom=8, ())} />
                    <p>
                      "Check the "
                      <Link
                        bold=true
                        to_="https://davesnx.github.io/html_of_jsx/html_of_jsx/index.html"
                        color="lightskyblue">
                        "Documentation"
                      </Link>
                    </p>
                    <div style={Styles.spacer(~bottom=8, ())} />
                  </div>
                </div>
              </div>
            </main>
          </div>
        </div>
      </body>
    </html>;
  };
};
