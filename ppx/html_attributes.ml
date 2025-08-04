(** List of attributes that bring type-safety and attribute validation based on
    the tag. Used at compile-time by the ppx. *)

type kind =
  | String
  | Int
  | Bool
  | BooleanishString
    (* BooleanishString are attributes that are boolean values but represented as strings on the DOM.
       https://github.com/facebook/react/blob/a17467e7e2cd8947c595d1834889b5d184459f12/packages/react-dom-bindings/src/server/ReactFizzConfigDOM.js#L1165-L1176
    *)
  | Style

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
