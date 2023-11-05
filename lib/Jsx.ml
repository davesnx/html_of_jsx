type node = {
  tag : string;
  attributes : Attribute.t list;
  children : element list;
}

and element =
  | Null
  | Text of string
  | Fragment of element list
  | Node of node
  | Component of (unit -> element)
  | List of element list

let text txt = Text txt
let null = Null
let int i = Text (string_of_int i)
let float f = Text (string_of_float f)
let list arr = List arr
let fragment arr = Fragment arr
let node tag attributes children = Node { tag; attributes; children }
