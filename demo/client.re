module Link = {
  let make = (~to_, ~children, ()) => {
    <a href=to_> children </a>;
  };
};

module Page = {
  let make = () => {
    <html lang="en">
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
      <body>
        <div>
          <main>
            <header>
              <Link to_="https://x.com/davesnx"> "@davesnx" </Link>
            </header>
          </main>
          <div>
            <main>
              <h1> "Html_of_jsx" </h1>
              <div>
                <div>
                  <p>
                    <span> "html_of_jsx" </span>
                    <span>
                      " is an implementation of JSX designed to render HTML on the server, without React or anything else. It's a minimal library that allows you to write components of HTML in a declarative way."
                    </span>
                  </p>
                </div>
              </div>
            </main>
          </div>
        </div>
      </body>
    </html>;
  };
};

let html = JSX.render(<Page />);

Js.log(html);
