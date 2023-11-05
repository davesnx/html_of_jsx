# html_of_jsx

**html_of_jsx** is an implementation of JSX designed to render HTML on the server, without React or anything else. It's a minimal library that allows you to write components of HTML in a declarative way.

- Supports all features from JSX
- Works with Reason and mlx
- Type-safe
- Minimal
  - `Html_of_jsx.render` to render an element to HTML
  - `Jsx.*` to construct elements and nodes (`Jsx.text`, `Jsx.int`, `Jsx.null`, `Jsx.list`)

## Installation

```sh
opan pin add html_of_jsx "https://github.com/davesnx/html_of_jsx"
```

```diff
+ (library html_of_jsx.lib)
+ (preprocess (pps html_of_jsx.ppx))
```

### [Documentation](https://davesnx.github.io/html_of_jsx/html_of_jsx/index.html)

Check the [Documentation](https://davesnx.github.io/html_of_jsx/html_of_jsx/index.html) to know more about the API and [features](https://davesnx.github.io/html_of_jsx/html_of_jsx/index.html#features).

## Usage

```reason
let element = <a href="https://x.com/davesnx">
  <span> {"Click me!"} </span>
</a>

let html: string = Html_of_jsx.render(element);
```

Check the [demo/server.re](./demo/server.re) file to see a full example with a [Dream](https://aantron.github.io/dream) HTTP server

### Credits

This library is extracted from [server-reason-react](https://github.com/ml-in-barcelona/server-reason-react) and simplified to just work with HTML5.
