module Styles = {
  let heading = ["margin: 0", "padding: 0"];

  let join = String.concat("; ");
  let h1 =
    join([
      "font-weight: 500",
      "font-size: calc((((((0.7rem + 0.13vw) * 1.25) * 1.25) * 1.25) * 1.25) * 1.25)",
      "letter-spacing: 0.8px;",
      ...heading,
    ]);

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
};

module Link = {
  let make = (~color, ~to_, ~bold=false, ~children, ()) => {
    let color = Printf.sprintf("color: %s;", color);
    <a href=to_ style={Styles.join([color ] @ (bold ? ["font-weight: bold"] : []))}>
      children
    </a>;
  };
};

module Page = {
  let make = (~scripts=[], ()) => {
    <html lang="en" style="color-scheme: dark;">
      <head>
        <meta charSet="UTF-8" />
        <meta
          name="viewport"
          content="width=device-width, initial-scale=1.0"
        />
        <title> {Jsx.text("HTML OF JSX")} </title>
        <link
          rel="shortcut icon"
          href="https://reasonml.github.io/img/icon_50.png"
        />
        <style type_="text/css">
          {js|
        html {
          height: 100vh;
          width: 100vw;
          margin: 0;
          padding: 0;
        }
        |js}
        </style>
        <script src="https://cdn.tailwindcss.com" />
      </head>
      <body class_="flex items-center justify-center p-48">
        <div class_="css-1ph5f11 edndw0j0">
          <main class_="css-mnuiua e1a0yjcl0">
            <header style={Styles.stack(10)}>
              <div style={Styles.row(~spread=true, ~fullWidth=true, 100)}>
                <a href="https://sancho.dev/" class_="css-cre123 eh99vtg1">
                  <p class_="css-frpcvv edndw0j2"> {Jsx.text("@davesnx")} </p>
                </a>
                <div style={Styles.row(32)}>
                  <Link to_="https://sancho.dev/blog" color="grey">
                    {Jsx.text("blog")}
                  </Link>
                  <Link to_="https://sancho.dev/talks" color="grey">
                    {Jsx.text("talks")}
                  </Link>
                  <Link to_="https://sancho.dev/about" color="grey">
                    "about"
                  </Link>
                </div>
              </div>
            </header>
          </main>
          <div class_="css-1qyitdn e1y96j372">
            <main class_="css-mnuiua e1a0yjcl0">
              <div class_="css-xiwenu e1y96j370">
                <div style={Styles.spacer(~bottom=32, ())}>
                  <h1 style=Styles.h1> {Jsx.text("David Sancho")} </h1>
                </div>
                <div>
                  <div>
                    <p color="var(--c-body)" class_="css-tg7dnl e1yw4nh30">
                      <span>
                        {Jsx.text(
                           "I'm a Software Engineer based in Barcelona, making cute software with ",
                         )}
                      </span>
                      <a
                        href="http://reasonml.github.io/"
                        color="var(--c-body)"
                        class_="css-4htwjz eh99vtg0">
                        {Jsx.text("Reason")}
                      </a>
                      <span> {Jsx.text(" and ")} </span>
                      <a
                        href="https://ocaml.org/"
                        color="var(--c-body)"
                        class_="css-4htwjz eh99vtg0">
                        {Jsx.text("OCaml")}
                      </a>
                      <span> {Jsx.text(". I co-host ")} </span>
                      <a
                        href="https://www.twitch.tv/emelletv"
                        color="var(--c-body)"
                        class_="css-4htwjz eh99vtg0">
                        {Jsx.text("emelle.tv")}
                      </a>
                      <span>
                        {Jsx.text("a talk show about these languages.")}
                      </span>
                    </p>
                    <div style={Styles.spacer(~bottom=8, ())} />
                    <p color="var(--c-body)" class_="css-cypsmt e1yw4nh30">
                      {Jsx.text("I am currently working at ")}
                      <a
                        href="https://ahrefs.com/"
                        color="var(--c-body)"
                        class_="css-4htwjz eh99vtg0">
                        {Jsx.text("Ahrefs")}
                      </a>
                      {Jsx.text(", building user interfaces and tools.")}
                    </p>
                    <div style={Styles.spacer(~bottom=8, ())} />
                    <p color="var(--c-body)" class_="css-cypsmt e1yw4nh30">
                      {Jsx.text("You can read more about me on the ")}
                      <a
                        href="https://sancho.dev/about"
                        color="var(--c-body)"
                        class_="css-4htwjz eh99vtg0">
                        {Jsx.text("about")}
                      </a>
                      {Jsx.text(" page.")}
                    </p>
                  </div>
                </div>
                <div style={Styles.spacer(~bottom=28, ())} />
                <div style={Styles.row(32)}>
                  <Link color="lightskyblue" bold=true to_="https://twitter.com/davesnx">
                    "Twitter"
                  </Link>
                  <Link color="lightgrey" bold=true to_="https://github.com/davesnx">
                    "Github"
                  </Link>
                  <Link color="lightseagreen" bold=true to_="https://t.me/davesnx">
                    "Telegram"
                  </Link>
                  <Link
                    color="lightcoral"
                    bold=true
                    to_="https://www.strava.com/athletes/davesnx">
                    "Strava"
                  </Link>
                </div>
              </div>
            </main>
          </div>
        </div>
        {scripts |> List.map(src => <script src />) |> Jsx.list}
      </body>
    </html>;
  };
};

let index = _request => {
  let html = Html_of_jsx.render(<Page scripts=["/static/app.js"] />);
  Dream.html(html);
};

let interface =
  switch (Sys.getenv_opt("SERVER_INTERFACE")) {
  | Some(env) => env
  | None => "localhost"
  };

let router = Dream.router([Dream.get("/", index)]);

Dream.run(~port=8080, ~interface, router);
