/**

This is a demo of a HTTP server that demostrates the possibility of Html_of_jsx.

It uses `tiny_httpd` to keep the dependencies to a minimum. It also contains a bunch of utilities to generate styles, which are unrelated to the project.

*/
module Httpd = Tiny_httpd;

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
        <meta
          name="viewport"
          content="width=device-width, initial-scale=1.0"
        />
        <title> "HTML OF JSX" </title>
        <link
          rel="shortcut icon"
          href="https://reasonml.github.io/img/icon_50.png"
        />
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
              <div
                style={Styles.row(
                  ~spread=true,
                  ~fullWidth=true,
                  ~align=`center,
                  100,
                )}>
                <Link color="grey" to_=project_url>
                  <p> {Jsx.text(project_url)} </p>
                </Link>
                <div style={Styles.row(4)}>
                  <span style=Styles.dimmed> "by " </span>
                  <Link to_="https://x.com/davesnx" color="grey">
                    "@davesnx"
                  </Link>
                </div>
              </div>
            </header>
          </main>
          <div>
            <main style=Styles.Font.large>
              <div>
                <div style={Styles.spacer(~bottom=16, ())}>
                  <h1 style=Styles.h1> "Html_of_jsx" </h1>
                </div>
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

let () = {
  let project_url = "https://github.com/davesnx/html_of_jsx";
  let server = Httpd.create();
  let addr = Httpd.addr(server);
  let port = Httpd.port(server);
  Httpd.add_route_handler(
    ~meth=`GET,
    server,
    Httpd.Route.(return),
    _req => {
      let html = Html_of_jsx.render(<Page project_url />);
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
