let case = (name, node, expected) => (name, JSX.render(node), expected);

let s = "a&b<c>\"d'e";
let id = "x\"y";
let n = 42;
let neg = (-7);
let f = 1.5;
let b_true = true;
let b_false = false;
let some_str = Some("o&k");
let none_str: option(string) = None;
let some_int = Some(5);
let none_int: option(int) = None;
let some_true = Some(true);
let some_false = Some(false);
let none_bool: option(bool) = None;

module Wrap = {
  let make = (~children=?, ()) =>
    switch (children) {
    | Some(c) => <section> c </section>
    | None => JSX.null
    };
};

module Pair = {
  let make = (~title, ~children, ()) =>
    <article> <h1> {JSX.string(title)} </h1> children </article>;
};

module Greeting = {
  let make = (~name, ()) => <p> {JSX.string("Hi " ++ name)} </p>;
};

let trace = ref([]);
let tick = label => {
  trace := [label, ...trace^];
  label;
};

let static_cases = [
  case("empty div", <div />, Some({|<div></div>|})),
  case("void br", <br />, Some({|<br />|})),
  case(
    "void img attrs",
    <img src="a.png" alt="x&y" />,
    Some({|<img src="a.png" alt="x&amp;y" />|}),
  ),
  case(
    "void input checkbox",
    <input type_=`checkbox name="c" checked=true disabled=false />,
    Some({|<input type="checkbox" name="c" checked />|}),
  ),
  case("void hr", <hr />, Some({|<hr />|})),
  case(
    "void meta",
    <meta charset="utf-8" />,
    Some({|<meta charset="utf-8" />|}),
  ),
  case(
    "void link",
    <link rel="stylesheet" href="a.css" />,
    Some({|<link rel="stylesheet" href="a.css" />|}),
  ),
  case("void wbr", <wbr />, Some({|<wbr />|})),
  case(
    "text escape",
    <p> {JSX.string("a&b<c>\"d'e")} </p>,
    Some({|<p>a&amp;b&lt;c&gt;&quot;d&apos;e</p>|}),
  ),
  case("bare string child", <p> "a&b" </p>, Some({|<p>a&amp;b</p>|})),
  case(
    "unsafe child",
    <p> {JSX.unsafe("<b>x</b>")} </p>,
    Some({|<p><b>x</b></p>|}),
  ),
  case("null child", <p> JSX.null </p>, Some({|<p></p>|})),
  case("int child", <p> {JSX.int(3)} </p>, Some({|<p>3</p>|})),
  case("neg int child", <p> {JSX.int(-3)} </p>, Some({|<p>-3</p>|})),
  case("hex int child", <p> {JSX.int(0x10)} </p>, Some({|<p>16</p>|})),
  case(
    "underscore int child",
    <p> {JSX.int(1_000)} </p>,
    Some({|<p>1000</p>|}),
  ),
  case("float child", <p> {JSX.float(1.5)} </p>, Some({|<p>1.5</p>|})),
  case("float whole child", <p> {JSX.float(2.)} </p>, Some({|<p>2.</p>|})),
  case(
    "neg float child",
    <p> {JSX.float(-2.5)} </p>,
    Some({|<p>-2.5</p>|}),
  ),
  case("float exp child", <p> {JSX.float(1e21)} </p>, None),
  case(
    "float underscore child",
    <p> {JSX.float(1_0.5)} </p>,
    Some({|<p>10.5</p>|}),
  ),
  case("float nan child", <p> {JSX.float(nan)} </p>, None),
  case("float infinity child", <p> {JSX.float(infinity)} </p>, None),
  case("float tiny child", <p> {JSX.float(1e-7)} </p>, None),
  case("float hexfloat child", <p> {JSX.float(0x1p3)} </p>, None),
  case(
    "format static",
    <p> {JSX.format("%s-%d-%c-%%", "a&b", 3, 'x')} </p>,
    Some({|<p>a&amp;b-3-x-%</p>|}),
  ),
  case(
    "format static literal text escaped",
    <p> {JSX.format("<%s>", "x")} </p>,
    Some({|<p>&lt;x&gt;</p>|}),
  ),
  case(
    "format dynamic",
    <p> {JSX.format("%s-%d", s, n)} </p>,
    Some({|<p>a&amp;b&lt;c&gt;&quot;d&apos;e-42</p>|}),
  ),
  case("format mixed", <p> {JSX.format("%s-%s", "lit", s)} </p>, None),
  case(
    "format padded",
    <p> {JSX.format("%5d|%-5s|", 3, "a")} </p>,
    Some({|<p>    3|a    |</p>|}),
  ),
  case("format float", <p> {JSX.format("%.2f", 1.005)} </p>, None),
  case(
    "format neg int literal",
    <p> {JSX.format("%d", -3)} </p>,
    Some({|<p>-3</p>|}),
  ),
  case(
    "format percent only",
    <p> {JSX.format("100%%")} </p>,
    Some({|<p>100%</p>|}),
  ),
  case(
    "format no args",
    <p> {JSX.format("plain & text")} </p>,
    Some({|<p>plain &amp; text</p>|}),
  ),
  case(
    "format string with quote in arg",
    <p> {JSX.format("%s", "\"")} </p>,
    Some({|<p>&quot;</p>|}),
  ),
  case("format %i", <p> {JSX.format("%i", 7)} </p>, Some({|<p>7</p>|})),
  case("format %S", <p> {JSX.format("%S", "a")} </p>, None),
  case("format %x", <p> {JSX.format("%x", 255)} </p>, Some({|<p>ff</p>|})),
  case(
    "format %B",
    <p> {JSX.format("%B", true)} </p>,
    Some({|<p>true</p>|}),
  ),
  case(
    "format %s with char arg dynamic",
    <p> {JSX.format("%c%c", 'a', '<')} </p>,
    Some({|<p>a&lt;</p>|}),
  ),
  case(
    "format fewer literal args",
    <p> {JSX.format("%s %s", "a", "b")} </p>,
    Some({|<p>a b</p>|}),
  ),
  case(
    "nested",
    <div> <span> <b> {JSX.string("x")} </b> </span> </div>,
    Some({|<div><span><b>x</b></span></div>|}),
  ),
  case(
    "siblings",
    <ul> <li> "a" </li> <li> "b" </li> </ul>,
    Some({|<ul><li>a</li><li>b</li></ul>|}),
  ),
  case("fragment static", <> <i /> <b /> </>, Some({|<i></i><b></b>|})),
  case("fragment empty", <> </>, Some("")),
  case("fragment single", <> <i /> </>, Some({|<i></i>|})),
  case("fragment text", <> "a&b" {JSX.int(1)} </>, Some({|a&amp;b1|})),
  case(
    "fragment nested",
    <> <> <i /> </> <> <b /> </> </>,
    Some({|<i></i><b></b>|}),
  ),
  case(
    "fragment in element",
    <div> <> <i /> <b /> </> </div>,
    Some({|<div><i></i><b></b></div>|}),
  ),
  case("fragment with null", <> JSX.null <i /> </>, Some({|<i></i>|})),
  case(
    "JSX.list child",
    <div> {JSX.list([<i />, <b />])} </div>,
    Some({|<div><i></i><b></b></div>|}),
  ),
  case(
    "JSX.array child",
    <div> {JSX.array([|<i />, <b />|])} </div>,
    Some({|<div><i></i><b></b></div>|}),
  ),
  case(
    "List.map child",
    <ul>
      {JSX.list(List.map(x => <li> {JSX.string(x)} </li>, ["a&", "b"]))}
    </ul>,
    Some({|<ul><li>a&amp;</li><li>b</li></ul>|}),
  ),
  case(
    "html static",
    <html> <body /> </html>,
    Some({|<!DOCTYPE html><html><body></body></html>|}),
  ),
  case("html empty", <html />, Some({|<!DOCTYPE html><html></html>|})),
  case(
    "html lang static",
    <html lang="en"> <body /> </html>,
    Some({|<!DOCTYPE html><html lang="en"><body></body></html>|}),
  ),
  case(
    "html dynamic child",
    <html> {JSX.string(s)} </html>,
    Some({|<!DOCTYPE html><html>a&amp;b&lt;c&gt;&quot;d&apos;e</html>|}),
  ),
  case(
    "html dynamic lang",
    <html lang=id />,
    Some({|<!DOCTYPE html><html lang="x&quot;y"></html>|}),
  ),
  case(
    "html opt lang",
    <html lang=?some_str />,
    Some({|<!DOCTYPE html><html lang="o&amp;k"></html>|}),
  ),
  case(
    "html dynamic lang and child",
    <html lang=id> {JSX.string(s)} </html>,
    None,
  ),
  case(
    "html element child dynamic",
    <html> <body> {JSX.string(s)} </body> </html>,
    None,
  ),
  case(
    "html component child",
    <html> <Greeting name="x" /> </html>,
    Some({|<!DOCTYPE html><html><p>Hi x</p></html>|}),
  ),
  case(
    "html in fragment",
    <> <html> <body /> </html> </>,
    Some({|<!DOCTYPE html><html><body></body></html>|}),
  ),
  case(
    "html in div",
    <div> <html /> </div>,
    Some({|<div><!DOCTYPE html><html></html></div>|}),
  ),
  case(
    "html in fragment dynamic",
    <> <html> {JSX.string(s)} </html> <i /> </>,
    None,
  ),
  case(
    "html in component children",
    <Wrap> <html> {JSX.string(s)} </html> </Wrap>,
    None,
  ),
  case(
    "html dynamic int child",
    <html> {JSX.int(n)} </html>,
    Some({|<!DOCTYPE html><html>42</html>|}),
  ),
  case(
    "html dynamic format child",
    <html> {JSX.format("%s", s)} </html>,
    None,
  ),
  case("html tabindex dynamic", <html tabindex=n />, None),
  case(
    "html in nested html",
    <html> <html> {JSX.string(s)} </html> </html>,
    None,
  ),
  case(
    "svg static",
    <svg viewBox="0 0 1 1"> <path d="M0 0" fill="none" /> </svg>,
    None,
  ),
  case("svg dynamic", <svg viewBox=id> <circle r="1" /> </svg>, None),
  case("svg opt", <svg viewBox=?some_str />, None),
  case("svg rect int attrs", <svg> <rect x="1" width="2" /> </svg>, None),
  case("svg text", <svg> <text> {JSX.string(s)} </text> </svg>, None),
  case("svg use", <svg> <use href="#a" /> </svg>, None),
  case(
    "svg a vs html a",
    <svg> <a href="x"> {JSX.string("t")} </a> </svg>,
    None,
  ),
  case("svg title", <svg> <title> {JSX.string(s)} </title> </svg>, None),
  case("svg stroke", <svg> <line x1="0" x2="1" stroke="red" /> </svg>, None),
  case("svg g", <svg> <g> <g /> </g> </svg>, None),
  case("svg image", <svg> <image href="x" /> </svg>, None),
];

let static_attr_cases = [
  case(
    "class static escape",
    <div class_="a\"b&c<d>e'f" />,
    Some({|<div class="a&quot;b&amp;c&lt;d&gt;e&apos;f"></div>|}),
  ),
  case("class empty", <div class_="" />, Some({|<div class=""></div>|})),
  case("int attr", <div tabindex=1 />, Some({|<div tabindex="1"></div>|})),
  case(
    "int attr zero",
    <div tabindex=0 />,
    Some({|<div tabindex="0"></div>|}),
  ),
  case(
    "int attr neg",
    <div tabindex=(-1) />,
    Some({|<div tabindex="-1"></div>|}),
  ),
  case(
    "int attr hex",
    <div tabindex=0x10 />,
    Some({|<div tabindex="16"></div>|}),
  ),
  case(
    "int attr underscore",
    <div tabindex=1_000 />,
    Some({|<div tabindex="1000"></div>|}),
  ),
  case("bool true", <div hidden=true />, Some({|<div hidden></div>|})),
  case("bool false", <div hidden=false />, Some({|<div></div>|})),
  case(
    "bool mix",
    <input disabled=true readonly=false required=true />,
    Some({|<input disabled required />|}),
  ),
  case(
    "booleanish true",
    <div spellcheck=true />,
    Some({|<div spellcheck="true"></div>|}),
  ),
  case(
    "booleanish false",
    <div spellcheck=false />,
    Some({|<div spellcheck="false"></div>|}),
  ),
  case(
    "booleanish draggable",
    <div draggable=true />,
    Some({|<div draggable="true"></div>|}),
  ),
  case("booleanish contenteditable", <div contenteditable=true />, None),
  case(
    "polyvariant static",
    <input type_=`email />,
    Some({|<input type="email" />|}),
  ),
  case(
    "polyvariant renamed",
    <input type_=`datetime_local />,
    Some({|<input type="datetime-local" />|}),
  ),
  case(
    "polyvariant img loading",
    <img src="a" loading=`lazy_ />,
    Some({|<img src="a" loading="lazy" />|}),
  ),
  case(
    "polyvariant a referrerpolicy",
    <a href="x" referrerpolicy=`no_referrer />,
    Some({|<a href="x" referrerpolicy="no-referrer"></a>|}),
  ),
  case(
    "polyvariant td align",
    <td align=`center />,
    Some({|<td align="center"></td>|}),
  ),
  case(
    "polyvariant th scope",
    <th scope=`col />,
    Some({|<th scope="col"></th>|}),
  ),
  case("polyvariant button type", <button type_=`submit />, None),
  case(
    "attr order",
    <a href="x" id="i" class_="c" />,
    Some({|<a href="x" id="i" class="c"></a>|}),
  ),
  case("attr named for", <label for_="x" />, None),
  case(
    "attr named as",
    <link as_="image" rel="preload" href="h" />,
    Some({|<link as="image" rel="preload" href="h" />|}),
  ),
  case(
    "data-attr style",
    <div style="color:red;font-family:'a'" />,
    Some({|<div style="color:red;font-family:&apos;a&apos;"></div>|}),
  ),
  case("onclick static", <button onclick="f(\"x\")" />, None),
  case("aria static", <div aria_label="a&b" />, None),
  case("role", <div role=`button />, None),
  case("htmx static", <button hx_get="/ab=?1&c=2" hx_target="#x" />, None),
  case("htmx boost true", <div hx_boost=true />, None),
  case("htmx boost dyn", <div hx_boost=b_true />, None),
  case("htmx boost opt", <div hx_boost=?{Some(false)} />, None),
  case(
    "htmx static + child",
    <div hx_post="/p"> {JSX.string(s)} </div>,
    None,
  ),
  case("htmx swap", <div hx_swap=`outerHTML hx_trigger="click" />, None),
];

let dynamic_attr_cases = [
  case(
    "dyn string attr",
    <div class_=id />,
    Some({|<div class="x&quot;y"></div>|}),
  ),
  case(
    "dyn string attr escape all",
    <div class_=s />,
    Some({|<div class="a&amp;b&lt;c&gt;&quot;d&apos;e"></div>|}),
  ),
  case(
    "dyn int attr",
    <div tabindex=n />,
    Some({|<div tabindex="42"></div>|}),
  ),
  case(
    "dyn neg int attr",
    <div tabindex=neg />,
    Some({|<div tabindex="-7"></div>|}),
  ),
  case("dyn min_int attr", <div tabindex=min_int />, None),
  case("dyn max_int attr", <div tabindex=max_int />, None),
  case(
    "dyn bool attr true",
    <div hidden=b_true />,
    Some({|<div hidden></div>|}),
  ),
  case("dyn bool attr false", <div hidden=b_false />, Some({|<div></div>|})),
  case(
    "dyn booleanish true",
    <div spellcheck=b_true />,
    Some({|<div spellcheck="true"></div>|}),
  ),
  case(
    "dyn booleanish false",
    <div spellcheck=b_false />,
    Some({|<div spellcheck="false"></div>|}),
  ),
  case(
    "dyn polyvariant",
    <input
      type_={
              if (b_true) {
                `email;
              } else {
                `text;
              }
            }
    />,
    Some({|<input type="email" />|}),
  ),
  case(
    "dyn polyvariant renamed",
    <input
      type_={
              if (b_true) {
                `datetime_local;
              } else {
                `text;
              }
            }
    />,
    Some({|<input type="datetime-local" />|}),
  ),
  case(
    "dyn polyvariant loading",
    <img
      src="a"
      loading={
                if (b_true) {
                  `lazy_;
                } else {
                  `eager;
                }
              }
    />,
    Some({|<img src="a" loading="lazy" />|}),
  ),
  case(
    "dyn void",
    <img src=id alt=s />,
    Some({|<img src="x&quot;y" alt="a&amp;b&lt;c&gt;&quot;d&apos;e" />|}),
  ),
  case(
    "dyn void int",
    <input maxlength=n />,
    Some({|<input maxlength="42" />|}),
  ),
  case(
    "dyn void bool",
    <input disabled=b_true />,
    Some({|<input disabled />|}),
  ),
  case("dyn mixed static+dyn", <div class_="a" id id="x" />, None),
  case("dyn static after dyn", <div id class_="c" tabindex=1 />, None),
  case(
    "dyn attrs + text child",
    <div id> "t&" </div>,
    Some({|<div id="x&quot;y">t&amp;</div>|}),
  ),
  case(
    "dyn attrs + dyn child",
    <div id> {JSX.string(s)} </div>,
    Some({|<div id="x&quot;y">a&amp;b&lt;c&gt;&quot;d&apos;e</div>|}),
  ),
  case(
    "dyn attrs + element child",
    <div id> <span class_=id /> </div>,
    Some({|<div id="x&quot;y"><span class="x&quot;y"></span></div>|}),
  ),
  case(
    "dyn attrs + static element child",
    <div id> <span /> </div>,
    Some({|<div id="x&quot;y"><span></span></div>|}),
  ),
  case(
    "dyn attrs + void child",
    <div id> <br /> </div>,
    Some({|<div id="x&quot;y"><br /></div>|}),
  ),
  case(
    "dyn attrs + int float child",
    <div id> {JSX.int(n)} {JSX.float(f)} </div>,
    Some({|<div id="x&quot;y">421.5</div>|}),
  ),
  case(
    "dyn attrs + format child",
    <div id> {JSX.format("%s=%d", s, n)} </div>,
    None,
  ),
  case(
    "dyn attrs + null child",
    <div id> JSX.null </div>,
    Some({|<div id="x&quot;y"></div>|}),
  ),
  case(
    "dyn attrs + fragment child",
    <div id> <> <i /> {JSX.string(s)} </> </div>,
    None,
  ),
  case(
    "dyn attrs + component child",
    <div id> <Greeting name=s /> </div>,
    None,
  ),
  case(
    "dyn attrs + list child",
    <div id> {JSX.list([<i />, <b />])} </div>,
    Some({|<div id="x&quot;y"><i></i><b></b></div>|}),
  ),
  case(
    "dyn attr on html",
    <html lang=id> <body /> </html>,
    Some({|<!DOCTYPE html><html lang="x&quot;y"><body></body></html>|}),
  ),
  case("dyn attr on svg", <svg viewBox=id />, None),
  case("dyn attr htmx", <div hx_get=id />, None),
  case("dyn attr htmx boost", <div hx_boost=b_true />, None),
  case(
    "dyn evaluated once",
    <div id={tick("a")} class_={tick("a")} />,
    None,
  ),
  case(
    "dyn attr with tag nested",
    <div id> <a href=id id> {JSX.string(id)} </a> </div>,
    None,
  ),
  case(
    "dyn attr and spliced child with let",
    <div id> {let q = "z";
              <span id=q />} </div>,
    None,
  ),
];

let optional_attr_cases = [
  case(
    "opt string some",
    <div class_=?some_str />,
    Some({|<div class="o&amp;k"></div>|}),
  ),
  case("opt string none", <div class_=?none_str />, Some({|<div></div>|})),
  case(
    "opt int some",
    <div tabindex=?some_int />,
    Some({|<div tabindex="5"></div>|}),
  ),
  case("opt int none", <div tabindex=?none_int />, Some({|<div></div>|})),
  case(
    "opt bool some true",
    <div hidden=?some_true />,
    Some({|<div hidden></div>|}),
  ),
  case(
    "opt bool some false",
    <div hidden=?some_false />,
    Some({|<div></div>|}),
  ),
  case("opt bool none", <div hidden=?none_bool />, Some({|<div></div>|})),
  case(
    "opt booleanish some true",
    <div spellcheck=?some_true />,
    Some({|<div spellcheck="true"></div>|}),
  ),
  case(
    "opt booleanish some false",
    <div spellcheck=?some_false />,
    Some({|<div spellcheck="false"></div>|}),
  ),
  case(
    "opt booleanish none",
    <div spellcheck=?none_bool />,
    Some({|<div></div>|}),
  ),
  case(
    "opt polyvariant some",
    <input type_=?{Some(`email)} />,
    Some({|<input type="email" />|}),
  ),
  case(
    "opt polyvariant renamed",
    <input type_=?{Some(`datetime_local)} />,
    Some({|<input type="datetime-local" />|}),
  ),
  case("opt polyvariant none", <input type_=?None />, Some({|<input />|})),
  case(
    "opt mixed with static",
    <div class_="a" id=?some_str tabindex=1 />,
    None,
  ),
  case(
    "opt mixed with dynamic",
    <div class_=id id=?some_str tabindex=?none_int hidden=b_true />,
    None,
  ),
  case(
    "opt then static",
    <div id=?none_str class_="a" />,
    Some({|<div class="a"></div>|}),
  ),
  case(
    "opt then static all none",
    <div id=?none_str class_=?none_str class_="a" />,
    None,
  ),
  case(
    "opt with child",
    <div id=?some_str> {JSX.string(s)} </div>,
    Some({|<div id="o&amp;k">a&amp;b&lt;c&gt;&quot;d&apos;e</div>|}),
  ),
  case(
    "opt with static child",
    <div id=?some_str> "t" </div>,
    Some({|<div id="o&amp;k">t</div>|}),
  ),
  case(
    "opt with element child",
    <div id=?none_str> <span id=?some_str /> </div>,
    Some({|<div><span id="o&amp;k"></span></div>|}),
  ),
  case(
    "opt void",
    <img src=?some_str alt=?none_str />,
    Some({|<img src="o&amp;k" />|}),
  ),
  case(
    "opt void bool",
    <input disabled=?some_true checked=?some_false />,
    Some({|<input disabled />|}),
  ),
  case(
    "opt on html",
    <html lang=?none_str> <body /> </html>,
    Some({|<!DOCTYPE html><html><body></body></html>|}),
  ),
  case(
    "opt on html dyn child",
    <html lang=?some_str> {JSX.string(s)} </html>,
    None,
  ),
  case("opt htmx", <div hx_get=?some_str hx_boost=?some_true />, None),
  case("opt htmx boost false", <div hx_boost=?some_false />, None),
  case(
    "opt passthrough var",
    {
      let class_ = Some("v");
      <div ?class_ />;
    },
    Some({|<div class="v"></div>|}),
  ),
  case(
    "opt svg",
    <svg viewBox=?some_str> <circle r=?some_str /> </svg>,
    None,
  ),
  case("opt event", <button onclick=?some_str />, None),
  case(
    "opt many",
    <div
      id=?some_str
      class_=?some_str
      title=?some_str
      tabindex=?some_int
      hidden=?some_true
    />,
    None,
  ),
];

let component_cases = [
  case(
    "component no children",
    <Greeting name="x&y" />,
    Some({|<p>Hi x&amp;y</p>|}),
  ),
  case(
    "component children one",
    <Wrap> <span /> </Wrap>,
    Some({|<section><span></span></section>|}),
  ),
  case(
    "component children many",
    <Wrap> <span /> <i /> </Wrap>,
    Some({|<section><span></span><i></i></section>|}),
  ),
  case(
    "component children text",
    <Wrap> "a&b" </Wrap>,
    Some({|<section>a&amp;b</section>|}),
  ),
  case("component children dyn", <Wrap> {JSX.string(s)} </Wrap>, None),
  case("component none children", <Wrap />, Some("")),
  case("component pair", <Pair title=s> <i /> <b /> </Pair>, None),
  case(
    "component in element",
    <div> <Greeting name="a" /> <Greeting name="b" /> </div>,
    Some({|<div><p>Hi a</p><p>Hi b</p></div>|}),
  ),
  case(
    "component in element dynamic attr",
    <div id> <Greeting name="a" /> </div>,
    None,
  ),
  case(
    "component in fragment",
    <> <Greeting name="a" /> <i /> </>,
    Some({|<p>Hi a</p><i></i>|}),
  ),
  case(
    "component nested",
    <Wrap> <Wrap> <Greeting name="a" /> </Wrap> </Wrap>,
    Some({|<section><section><p>Hi a</p></section></section>|}),
  ),
  case(
    "component mixed children",
    <Pair title="t"> "x" {JSX.string(s)} <i id /> </Pair>,
    None,
  ),
  case(
    "component children single dynamic element",
    <Wrap> <div id> {JSX.string(s)} </div> </Wrap>,
    None,
  ),
  case(
    "component with fragment child",
    <Wrap> <> <i /> <b /> </> </Wrap>,
    Some({|<section><i></i><b></b></section>|}),
  ),
  case(
    "component wraps html",
    <Wrap> <html> <body /> </html> </Wrap>,
    Some({|<section><!DOCTYPE html><html><body></body></html></section>|}),
  ),
  case(
    "component children null",
    <Wrap> JSX.null </Wrap>,
    Some({|<section></section>|}),
  ),
  case(
    "component children list",
    <Wrap> {JSX.list([<i />, <b />])} </Wrap>,
    None,
  ),
  case("fragment fn", JSX.fragment(~children=<i />, ()), Some({|<i></i>|})),
];

let dynamic_child_cases = [
  case(
    "dyn string child",
    <p> {JSX.string(s)} </p>,
    Some({|<p>a&amp;b&lt;c&gt;&quot;d&apos;e</p>|}),
  ),
  case(
    "dyn string child clean",
    <p> {JSX.string("clean")} </p>,
    Some({|<p>clean</p>|}),
  ),
  case(
    "dyn string child empty",
    <p> {JSX.string("")} </p>,
    Some({|<p></p>|}),
  ),
  case("dyn int child", <p> {JSX.int(n)} </p>, Some({|<p>42</p>|})),
  case("dyn neg int child", <p> {JSX.int(neg)} </p>, Some({|<p>-7</p>|})),
  case("dyn min_int child", <p> {JSX.int(min_int)} </p>, None),
  case("dyn float child", <p> {JSX.float(f)} </p>, Some({|<p>1.5</p>|})),
  case("dyn float nan child", <p> {JSX.float(nan)} </p>, None),
  case("dyn float neg zero child", <p> {JSX.float(-0.)} </p>, None),
  case("dyn float neg zero var", <p> {JSX.float(-0.)} </p>, None),
  case(
    "dyn float expr child",
    <p> {JSX.float(1. +. 2.)} </p>,
    Some({|<p>3.</p>|}),
  ),
  case(
    "dyn format child",
    <p> {JSX.format("%s:%d:%c", s, n, 'x')} </p>,
    None,
  ),
  case(
    "dyn format float child",
    <p> {JSX.format("%.1f", f)} </p>,
    Some({|<p>1.5</p>|}),
  ),
  case(
    "dyn format with only literal args mixed",
    <p> {JSX.format("%d%s", n, "<")} </p>,
    Some({|<p>42&lt;</p>|}),
  ),
  case("dyn element child", <p> {JSX.unsafe(s)} </p>, None),
  case(
    "dyn mixed children",
    <p>
      "a"
      {JSX.string(s)}
      {JSX.int(n)}
      <i />
      {JSX.float(f)}
      {JSX.format("%s", s)}
      "z"
    </p>,
    None,
  ),
  case("dyn two strings", <p> {JSX.string(s)} {JSX.string(s)} </p>, None),
  case("dyn two elements", <div> <span id /> <span id /> </div>, None),
  case(
    "dyn nested 3",
    <div> <div id> <div id> {JSX.string(s)} </div> </div> </div>,
    None,
  ),
  case(
    "dyn nested 4 siblings",
    <div>
      <p> {JSX.string(s)} </p>
      <p> {JSX.string(s)} </p>
      <p> {JSX.int(n)} </p>
      <p> {JSX.float(f)} </p>
    </div>,
    None,
  ),
  case(
    "dyn fragment",
    <> {JSX.string(s)} {JSX.int(n)} </>,
    Some({|a&amp;b&lt;c&gt;&quot;d&apos;e42|}),
  ),
  case("dyn fragment elements", <> <div id /> <div id /> </>, None),
  case("dyn fragment with static", <> "a" {JSX.string(s)} "b" </>, None),
  case(
    "dyn fragment nested",
    <> <> {JSX.string(s)} </> <> {JSX.int(n)} </> </>,
    None,
  ),
  case(
    "dyn fragment in div",
    <div> <> {JSX.string(s)} <i /> </> </div>,
    None,
  ),
  case(
    "dyn fragment in dyn div",
    <div id> <> {JSX.string(s)} <i /> </> </div>,
    None,
  ),
  case("dyn fragment single", <> {JSX.string(s)} </>, None),
  case("dyn fragment format", <> {JSX.format("%s", s)} </>, None),
  case(
    "dyn child nested let",
    <div> {let a = "q&";
           <span> {JSX.string(a)} </span>} </div>,
    Some({|<div><span>q&amp;</span></div>|}),
  ),
  case(
    "dyn child let shadows sibling",
    {
      let name = "outer";
      <div>
        {let name = "inner";
         <span> {JSX.string(name)} </span>}
        {JSX.string(name)}
      </div>;
    },
    Some({|<div><span>inner</span>outer</div>|}),
  ),
  case(
    "dyn child let shadows sibling attr child",
    {
      let name = "outer";
      <div> {let name = "inner";
             <span id=name />} <p id=name /> </div>;
    },
    Some({|<div><span id="inner"></span><p id="outer"></p></div>|}),
  ),
  case(
    "dyn child let shadows sibling fragment",
    {
      let name = "outer";
      <>
        {let name = "inner";
         <span> {JSX.string(name)} </span>}
        {JSX.string(name)}
      </>;
    },
    Some({|<span>inner</span>outer|}),
  ),
  case(
    "dyn child let shadows sibling int",
    {
      let n = 1;
      <div> {let n = 2;
             <span> {JSX.int(n)} </span>} {JSX.int(n)} </div>;
    },
    Some({|<div><span>2</span>1</div>|}),
  ),
  case(
    "dyn child let shadows sibling component",
    {
      let name = "outer";
      <div>
        {let name = "inner";
         <span> {JSX.string(name)} </span>}
        <Greeting name />
      </div>;
    },
    Some({|<div><span>inner</span><p>Hi outer</p></div>|}),
  ),
  case(
    "dyn child let shadows later sibling elements",
    {
      let c = "outer";
      <div> {let c = "inner";
             <span id=c />} {let d = c;
                             <span id=d />} </div>;
    },
    Some({|<div><span id="inner"></span><span id="outer"></span></div>|}),
  ),
  case(
    "dyn child let side effect order",
    {
      trace := [];
      let r =
        <div>
          {JSX.string(tick("a"))}
          {JSX.string(tick("b"))}
          {JSX.string(tick("c"))}
        </div>;
      JSX.string(String.concat(",", List.rev(trace^))) |> ignore;
      r;
    },
    None,
  ),
  case(
    "dyn child effect trace",
    {
      trace := [];
      let _ =
        <div>
          {JSX.string(tick("a"))}
          <span> {JSX.string(tick("b"))} </span>
          {JSX.string(tick("c"))}
        </div>;
      JSX.string(String.concat(",", List.rev(trace^)));
    },
    Some("a,b,c"),
  ),
  case(
    "dyn child effect trace fragment",
    {
      trace := [];
      let _ =
        <>
          {JSX.string(tick("a"))}
          <span> {JSX.string(tick("b"))} </span>
          {JSX.string(tick("c"))}
        </>;
      JSX.string(String.concat(",", List.rev(trace^)));
    },
    Some("a,b,c"),
  ),
  case(
    "dyn child effect trace attrs",
    {
      trace := [];
      let _ = <div id={tick("a")}> {JSX.string(tick("b"))} </div>;
      JSX.string(String.concat(",", List.rev(trace^)));
    },
    Some("a,b"),
  ),
  case(
    "dyn child effect trace static opt",
    {
      trace := [];
      let _ = <div> {JSX.string("x")} {JSX.string(tick("a"))} </div>;
      JSX.string(String.concat(",", List.rev(trace^)));
    },
    Some("a"),
  ),
  case(
    "dyn child effect trace list",
    {
      trace := [];
      let _ =
        <div>
          {JSX.list([JSX.string(tick("a")), JSX.string(tick("b"))])}
          {JSX.string(tick("c"))}
        </div>;
      JSX.string(String.concat(",", List.rev(trace^)));
    },
    None,
  ),
  case(
    "dyn child unused discarded",
    {
      trace := [];
      let _ = <div> {JSX.string(tick("a"))} </div>;
      JSX.string(String.concat(",", trace^));
    },
    Some("a"),
  ),
  case(
    "dyn child value restriction",
    <div> {JSX.string(if (b_true) {"yes"} else {"no"})} </div>,
    Some({|<div>yes</div>|}),
  ),
  case(
    "dyn child match",
    <div>
      {switch (some_str) {
       | Some(x) => JSX.string(x)
       | None => JSX.null
       }}
    </div>,
    Some({|<div>o&amp;k</div>|}),
  ),
  case(
    "dyn child ifelse",
    <div>
      {if (b_true) {
         <i />;
       } else {
         <b />;
       }}
    </div>,
    Some({|<div><i></i></div>|}),
  ),
  case(
    "dyn child ifelse in dyn",
    <div id>
      {if (b_true) {
         <i />;
       } else {
         <b />;
       }}
    </div>,
    Some({|<div id="x&quot;y"><i></i></div>|}),
  ),
  case(
    "dyn child let pattern",
    <div>
      {let (a, b) = ("1", "2");
       <span> {JSX.string(a)} {JSX.string(b)} </span>}
    </div>,
    Some({|<div><span>12</span></div>|}),
  ),
  case(
    "dyn child let and",
    <div>
      {let a = "1"
       and b = "2";
       <span> {JSX.string(a)} {JSX.string(b)} </span>}
    </div>,
    Some({|<div><span>12</span></div>|}),
  ),
  case(
    "dyn child let underscore",
    <div> {let _ = tick("u");
           <span> {JSX.string("x")} </span>} </div>,
    None,
  ),
  case(
    "dyn child let fun",
    <div> {let f = x => x ++ "!";
           <span> {JSX.string(f(s))} </span>} </div>,
    None,
  ),
  case(
    "dyn child let shadow outer builtin",
    <div>
      {let string = x => JSX.string(x ++ "?");
       <span> {string("a")} </span>}
    </div>,
    None,
  ),
  case(
    "local string fn",
    {
      let string = x => JSX.string(x ++ "?");
      <p> {string("a")} </p>;
    },
    None,
  ),
  case(
    "local int fn",
    {
      let int = _ => JSX.string("shadowed");
      <p> {int(1)} </p>;
    },
    None,
  ),
  case(
    "local text fn",
    {
      let text = _ => JSX.string("shadowed");
      <p> {text("a")} </p>;
    },
    None,
  ),
  case(
    "local float fn",
    {
      let float = _ => JSX.string("shadowed");
      <p> {float(1.)} </p>;
    },
    None,
  ),
  case(
    "local format fn",
    {
      let format = _ => JSX.string("shadowed");
      <p> {format("a")} </p>;
    },
    None,
  ),
  case(
    "local unsafe fn",
    {
      let unsafe = _ => JSX.string("<shadowed>");
      <p> {unsafe("<a>")} </p>;
    },
    None,
  ),
  case(
    "deep nesting",
    <div>
      <div>
        <div> <div> <div> <div id> {JSX.string(s)} </div> </div> </div> </div>
      </div>
    </div>,
    None,
  ),
  case(
    "pre/script/style raw",
    <script> {JSX.unsafe("if (a < b && c) {}")} </script>,
    Some({|<script>if (a < b && c) {}</script>|}),
  ),
  case(
    "script escaped string",
    <script> {JSX.string("a<b")} </script>,
    None,
  ),
  case("style child", <style> {JSX.string("a > b {}")} </style>, None),
  case("textarea", <textarea> {JSX.string("a&b")} </textarea>, None),
  case("title", <title> {JSX.string(s)} </title>, None),
  case(
    "table",
    <table>
      <tbody> <tr> <td colspan=2 id> {JSX.string(s)} </td> </tr> </tbody>
    </table>,
    None,
  ),
  case(
    "select option",
    <select>
      <option value=id selected=b_true> {JSX.string(s)} </option>
    </select>,
    None,
  ),
  case(
    "form",
    <form action=id method_=`post>
      <input name=id value=s />
      <button type_=`submit> "Go" </button>
    </form>,
    None,
  ),
];

let cases =
  List.concat([
    static_cases,
    static_attr_cases,
    dynamic_attr_cases,
    optional_attr_cases,
    component_cases,
    dynamic_child_cases,
  ]);
