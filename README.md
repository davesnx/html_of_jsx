# html_of_jsx

**html_of_jsx** is an implementation of JSX designed to render HTML on the server, without React or anything else. It's a simple library that allows you to write HTML in a declarative way with the component model.

## Installation

```sh
opan pin add html_of_jsx "https://github.com/davesnx/html_of_jsx"
```

```diff
+ (library html_of_jsx.lib)
+ (preprocess (pps html_of_jsx.ppx))
```

## Usage

```reason
let element = <a href="https://x.com/davesnx">
  <span> {"Click me!"} </span>
</a>

let html: string = Html_of_jsx.render(element);
```

### [Documentation](https://davesnx.github.io/html_of_jsx/html_of_jsx/index.html)

[Documentation](https://davesnx.github.io/html_of_jsx/html_of_jsx/index.html)

### Credits

This library is extracted from [server-reason-react](https://github.com/ml-in-barcelona/server-reason-react) and simplified to just work with HTML5.
