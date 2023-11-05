/** This is a demo of a HTTP server that demostrates the possibility of Html_of_jsx.
  It uses `tiny_httpd` to keep the dependencies to a minimum */
module Httpd = Tiny_httpd;

module Styles = {
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
};

module Link = {
  let make = (~color, ~to_, ~bold=false, ~children, ()) => {
    <a
      href=to_
      onmouseover="this.style.opacity='0.6'"
      onmouseout="this.style.opacity='1'"
      style={Styles.join(
        [Printf.sprintf("color: %s", color), "text-decoration: underline"]
        @ (bold ? ["font-weight: bold"] : []),
      )}>
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
      <body
        class_="flex items-center justify-center"
        style="padding-top: 7em; padding-left: 25%; padding-right: 25%;">
        <div>
          <main>
            <header style={Styles.stack(10)}>
              <div style={Styles.row(~spread=true, ~fullWidth=true, 100)}>
                <Link
                  color="grey" to_="https://github.com/davesnx/html_of_jsx">
                  <p>
                    {Jsx.text("https://github.com/davesnx/html_of_jsx")}
                  </p>
                </Link>
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
          <div>
            <main class_="text-lg">
              <div>
                <div style={Styles.spacer(~bottom=32, ())}>
                  <h1 style=Styles.h1> {Jsx.text("Html_of_jsx")} </h1>
                </div>
                <div>
                  <div>
                    <p>
                      <span class_="font-semibold">
                        {Jsx.text("html_of_jsx")}
                      </span>
                      <span class_="font-light">
                        {Jsx.text(
                           " is an implementation of JSX designed to render HTML on the server, without React or anything else. It's a minimal library that allows you to write components of HTML in a declarative way.",
                         )}
                      </span>
                    </p>
                    <div style={Styles.spacer(~bottom=8, ())} />
                    <p>
                      {Jsx.text("Check the ")}
                      <Link
                        bold=true to_="https://ahrefs.com/" color="lightblue">
                        {Jsx.text("Documentation")}
                      </Link>
                    </p>
                    <div style={Styles.spacer(~bottom=8, ())} />
                  </div>
                </div>
                <div style={Styles.spacer(~bottom=28, ())} />
                <div style=Styles.small>
                  <Link
                    color="lightskyblue"
                    bold=true
                    to_="https://twitter.com/davesnx">
                    "Follow me on twttr "
                  </Link>
                  <Link
                    color="lightgrey"
                    bold=true
                    to_="https://github.com/davesnx">
                    "or Github (counts double as internet points)"
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

let () = {
  let server = Httpd.create();
  let addr = Httpd.addr(server);
  let port = Httpd.port(server);
  Httpd.add_route_handler(
    ~meth=`GET,
    server,
    Httpd.Route.(exact("hello") @/ string @/ return),
    (_name, _req) => {
      let html = Html_of_jsx.render(<Page scripts=["/static/app.js"] />);
      Httpd.Response.make_string(Ok(html));
    },
  );
  switch (
    Httpd.run(server, ~after_init=() =>
      Printf.printf("Listening on http://%s:%d\n%!", addr, port)
    )
  ) {
  | Ok () => ()
  | Error(e) => raise(e)
  };
};
