
# Integrate with Dream

Use html\_of\_jsx to render pages and fragments in a [Dream](https://aantron.github.io/dream/) web server.


## Dune setup

```dune
(executable
 (name server)
 (libraries dream html_of_jsx)
 (preprocess (pps html_of_jsx.ppx)))
```

## Rendering a page

Use `JSX.render` to produce an HTML string and return it with `Dream.html`:

```reasonml
let page = (~title, ~children, ()) => {
  <html lang="en">
    <head> <title> {JSX.string(title)} </title> </head>
    <body> {children} </body>
  </html>;
};

let () =
  Dream.run
  @@ Dream.router([
    Dream.get("/", _req =>
      Dream.html(JSX.render(
        <page title="Home">
          <h1> {JSX.string("Welcome")} </h1>
        </page>
      ))
    ),
  ]);
```
```mlx
let page ~title ~children () =
  <html lang="en">
    <head><title>(JSX.string title)</title></head>
    <body>(children)</body>
  </html>

let () =
  Dream.run
  @@ Dream.router [
    Dream.get "/" (fun _req ->
      Dream.html (JSX.render (
        <page title="Home">
          <h1>(JSX.string "Welcome")</h1>
        </page>
      ))
    );
  ]
```

## Streaming

For large pages, stream HTML chunks directly into the response body with `JSX.render_streaming`:

```reasonml
Dream.get("/stream", _req =>
  Dream.stream(~headers=[("Content-Type", "text/html")], stream => {
    JSX.render_streaming(
      chunk => Dream.write(stream, chunk),
      <page title="Streamed">
        <p> {JSX.string("This page is streamed")} </p>
      </page>,
    );
    Dream.close(stream);
  })
)
```
```mlx
Dream.get "/stream" (fun _req ->
  Dream.stream ~headers:[("Content-Type", "text/html")] (fun stream ->
    JSX.render_streaming
      (fun chunk -> Dream.write stream chunk)
      (<page title="Streamed">
        <p>(JSX.string "This page is streamed")</p>
      </page>);
    Dream.close stream))
```