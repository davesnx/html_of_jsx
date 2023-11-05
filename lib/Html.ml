(** Used internally, no need to use *)

(* https://github.com/facebook/react/blob/97d75c9c8bcddb0daed1ed062101c7f5e9b825f4/packages/react-dom-bindings/src/shared/omittedCloseTags.js *)
let is_self_closing_tag = function
  | "area" | "base" | "br" | "col" | "embed" | "hr" | "img" | "input" | "link"
  | "meta" | "param" | "source" | "track" | "wbr" | "menuitem" ->
      true
  | _ -> false

(* Based on https://github.com/facebook/react/blob/97d75c9c8bcddb0daed1ed062101c7f5e9b825f4/packages/react-dom-bindings/src/server/escapeTextForBrowser.js#L51-L98 *)
(* https://discuss.ocaml.org/t/html-encoding-of-string/4289/4 *)
let encode s =
  let buffer = Buffer.create (String.length s * 2) in
  s
  |> String.iter (function
       | '&' -> Buffer.add_string buffer "&amp;"
       | '<' -> Buffer.add_string buffer "&lt;"
       | '>' -> Buffer.add_string buffer "&gt;"
       | '"' -> Buffer.add_string buffer "&quot;"
       | '\'' -> Buffer.add_string buffer "&#x27;"
       | c -> Buffer.add_char buffer c);
  Buffer.contents buffer

let is_html_element tag =
  match tag with
  | "a" | "abbr" | "address" | "area" | "article" | "aside" | "audio" | "b"
  | "base" | "bdi" | "bdo" | "blockquote" | "body" | "br" | "button" | "canvas"
  | "caption" | "cite" | "code" | "col" | "colgroup" | "data" | "datalist"
  | "dd" | "del" | "details" | "dfn" | "dialog" | "div" | "dl" | "dt" | "em"
  | "embed" | "fieldset" | "figcaption" | "figure" | "footer" | "form" | "h1"
  | "h2" | "h3" | "h4" | "h5" | "h6" | "head" | "header" | "hgroup" | "hr"
  | "html" | "i" | "iframe" | "img" | "input" | "ins" | "kbd" | "label"
  | "legend" | "li" | "link" | "main" | "map" | "mark" | "math" | "menu"
  | "menuitem" | "meta" | "meter" | "nav" | "noscript" | "object" | "ol"
  | "optgroup" | "option" | "output" | "p" | "param" | "picture" | "pre"
  | "progress" | "q" | "rb" | "rp" | "rt" | "rtc" | "ruby" | "s" | "samp"
  | "script" | "search" | "section" | "select" | "slot" | "small" | "source"
  | "span" | "strong" | "style" | "sub" | "summary" | "sup" | "svg" | "table"
  | "tbody" | "td" | "template" | "textarea" | "tfoot" | "th" | "thead" | "time"
  | "title" | "tr" | "track" | "u" | "ul" | "var" | "video" | "wbr" ->
      true
  | _ -> false

let is_svg_element tag =
  match tag with
  | "animate" | "animateMotion" | "animateTransform" | "circle" | "clipPath"
  | "defs" | "desc" | "ellipse" | "feBlend" | "feColorMatrix"
  | "feComponentTransfer" | "feComposite" | "feConvolveMatrix"
  | "feDiffuseLighting" | "feDisplacementMap" | "feDistantLight"
  | "feDropShadow" | "feFlood" | "feFuncA" | "feFuncB" | "feFuncG" | "feFuncR"
  | "feGaussianBlur" | "feImage" | "feMerge" | "feMergeNode" | "feMorphology"
  | "feOffset" | "fePointLight" | "feSpecularLighting" | "feSpotLight"
  | "feTile" | "feTurbulence" | "filter" | "foreignObject" | "g" | "image"
  | "line" | "linearGradient" | "marker" | "mask" | "metadata" | "mpath"
  | "path" | "pattern" | "polygon" | "polyline" | "radialGradient" | "rect"
  | "stop" | "switch" | "symbol" | "text" | "textPath" | "tspan" | "use"
  | "view" ->
      true
  | _ -> false
