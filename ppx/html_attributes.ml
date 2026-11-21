type polyvariant = { type_ : string; jsxName : string }

type kind =
  | String
  | Int
  | Bool
  | BooleanishString
  | Polyvariant of polyvariant list

type eventType =
  | Clipboard
  | Composition
  | Keyboard
  | Focus
  | Form
  | Mouse
  | Selection
  | Touch
  | UI
  | Wheel
  | Media
  | Image
  | Animation
  | Transition
  | Pointer
  | Inline
  | Drag

type attribute = { type_ : kind; name : string; jsxName : string }

type rich_attribute = {
  type_ : kind;
  name : string;
  jsxName : string;
  description : string;
  url : string;
}

type event = { type_ : eventType; jsxName : string }

type prop =
  | Attribute of attribute
  | Rich_attribute of rich_attribute
  | Event of event

type element = { tag : string; attributes : prop list }
