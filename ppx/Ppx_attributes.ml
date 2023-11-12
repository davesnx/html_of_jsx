(** List of attributes that bring type-safety and attribute validation based on the tag. Used at compile-time by the ppx. *)

[@@@ocamlformat "disable"]
(* This file is more like a spreadsheet, prefer to keep it with margin=300.
   Since @@@ocamlformat "margin=300" isn't possible, we disable it *)

type attributeType =
  | String
  | Int
  | Bool
  (* attributes that are boolean values, rendered as strings
   https://github.com/facebook/react/blob/a17467e7e2cd8947c595d1834889b5d184459f12/packages/react-dom-bindings/src/server/ReactFizzConfigDOM.js#L1165-L1176
  *)
  | BooleanishString
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

type attribute = {
  type_ : attributeType;
  name : string;
  jsxName : string;
}

type event = {
  type_ : eventType;
  jsxName : string;
}

type prop =
  | Attribute of attribute
  | Event of event

type element = {
  tag : string;
  attributes : prop list;
}
