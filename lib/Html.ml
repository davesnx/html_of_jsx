(** Used internally, no need to use *)

(* https://github.com/facebook/react/blob/97d75c9c8bcddb0daed1ed062101c7f5e9b825f4/packages/react-dom-bindings/src/shared/omittedCloseTags.js *)
let is_self_closing_tag = function
  | "area" | "base" | "br" | "col" | "embed" | "hr" | "img" | "input" | "link"
  | "meta" | "param" | "source" | "track" | "wbr" | "menuitem" ->
      true
  | _ -> false

(* This function is borrowed from https://github.com/dbuenzli/htmlit/blob/62d8f21a9233791a5440311beac02a4627c3a7eb/src/htmlit.ml#L10-L28 *)
let escape_and_add b s =
  let adds = Buffer.add_string in
  let len = String.length s in
  let max_idx = len - 1 in
  let flush b start i =
    if start < len then Buffer.add_substring b s start (i - start)
  in
  let rec loop start i =
    if i > max_idx then flush b start i
    else
      let next = i + 1 in
      match String.get s i with
      | '&' ->
          flush b start i;
          adds b "&amp;";
          loop next next
      | '<' ->
          flush b start i;
          adds b "&lt;";
          loop next next
      | '>' ->
          flush b start i;
          adds b "&gt;";
          loop next next
      | '\'' ->
          flush b start i;
          adds b "&apos;";
          loop next next
      | '\"' ->
          flush b start i;
          adds b "&quot;";
          loop next next
      | _ -> loop start next
  in
  loop 0 0

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
