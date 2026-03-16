
# How the ppx works

A closer look at the JSX transformation, static analysis, and performance optimizations inside `html_of_jsx.ppx`.


## JSX transformation

Every JSX expression is rewritten into JSX calls at compile time. The transformation depends on the tag:


### Lowercase tags

A lowercase tag like `<div class_="card">` is validated against the HTML/SVG spec. The ppx checks that `class_` is a valid attribute for `div` and that its value is a `string`. Invalid attributes or wrong types produce a compile error.


### Uppercase tags

An uppercase tag like `<Card title="Hello" />` is resolved to `Card.make ~title:"Hello" ()`. The ppx does not validate props — that is left to the OCaml type checker via the module signature.

```reasonml
<Card title="Hello" />
/* compiles to: Card.make(~title="Hello", ()) */
```
```mlx
<Card title="Hello" />
(* compiles to: Card.make ~title:"Hello" () *)
```

## Static analysis

The ppx analyzes every JSX tree to determine how much of the output is known at compile time. Based on this analysis it picks one of several code paths, from most to least optimized:


### Fully static

When a tree contains no dynamic parts, the ppx pre-computes the entire HTML string as a string literal. The runtime cost is zero.

```reasonml
<div class_="banner"> <strong> "Hello" </strong> </div>
/* compiles to: JSX.unsafe "<div class=\"banner\"><strong>Hello</strong></div>" */
```
```mlx
<div class_="banner"> <strong> "Hello" </strong> </div>
(* compiles to: JSX.unsafe "<div class=\"banner\"><strong>Hello</strong></div>" *)
```

### The dynamic parts

When a tree mixes static and dynamic parts, the ppx:

- Pre-computes the static segments as string literals
- Estimates the total buffer size (static bytes \+ 64 bytes per dynamic part)
- Emits a sequence of `Buffer.add_string` calls
```reasonml
let greeting = (~name, ()) => {
  <div class_="greeting">
    <h1> {JSX.string("Hello, " ++ name ++ "!")} </h1>
  </div>;
};

/* compiles roughly to:
   let buf = Buffer.create(<estimated_size>);
   Buffer.add_string(buf, "<div class=\"greeting\"><h1>");
   JSX.escape(buf, "Hello, " ^ name ^ "!");
   Buffer.add_string(buf, "</h1></div>");
   JSX.unsafe(Buffer.contents(buf));
*/
```
```mlx
let greeting ~name () =
  <div class_="greeting">
    <h1>(JSX.string ("Hello, " ^ name ^ "!"))</h1>
  </div>

(* compiles roughly to:
   let buf = Buffer.create <estimated_size> in
   Buffer.add_string buf "<div class=\"greeting\"><h1>";
   JSX.escape buf ("Hello, " ^ name ^ "!");
   Buffer.add_string buf "</h1></div>";
   JSX.unsafe (Buffer.contents buf)
*)
```

### Coalesced static parts

Adjacent static strings are merged at compile time. For example, a closing tag followed by an opening tag (`</h1><p>`) becomes a single `Buffer.add_string` call rather than two.


### Dynamic attributes with static children

When all children are static but some attributes are dynamic, the ppx pre-computes the children HTML and only the attribute rendering happens at runtime.


### Optional attributes

When a component receives optional props, the ppx generates conditional attribute rendering while still pre-computing the static parts of the element.


### Fallback

When the tree cannot be analyzed (e.g. it contains spread expressions or complex control flow), the ppx falls back to `JSX.node`, which builds the element at runtime.


## Escaping

Dynamic string content is escaped through `JSX.escape`, which handles `&`, `<`, `>`, `'`, and `"`. Static strings are escaped at compile time during analysis, so there is no runtime escaping cost for them.


## Disabling optimizations

Pass `-disable-static-opt` to the ppx to force every element through `JSX.node`. This is useful when debugging, since the generated code is simpler to read:

```dune
(preprocess (pps html_of_jsx.ppx -disable-static-opt))
```

## Benchmarks

For a detailed walkthrough of the optimization pipeline and benchmarks, see [Making html\_of\_jsx 10x faster](https://sancho.dev/blog/making-html-of-jsx-10x-faster).
