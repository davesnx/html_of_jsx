(** https://alpinejs.dev/directives *)

open Html_attributes

let directive ?(type_ = String) name description =
  Rich_attribute
    {
      name = "x-" ^ name;
      jsxName = "x_" ^ String.map (function '-' -> '_' | c -> c) name;
      type_;
      description;
      url = "https://alpinejs.dev/directives/" ^ name;
    }

let transition ~jsx_suffix ~suffix description =
  Rich_attribute
    {
      name = "x-transition:" ^ suffix;
      jsxName = "x_transition_" ^ jsx_suffix;
      type_ = String;
      description;
      url = "https://alpinejs.dev/directives/transition";
    }

let attributes =
  [
    directive "data" "declare a new Alpine component and its data";
    directive "init" "run code when an element is initialized";
    directive "show" "toggle the visibility of an element";
    directive "text" "set the text content of an element";
    directive "html" "set the inner HTML of an element";
    directive "model" "bind the value of an input element to Alpine data";
    directive "modelable" "expose a property as the target of x-model";
    directive "for" "create DOM elements by iterating through a list";
    directive "if" "add or remove a block of HTML";
    directive "effect" "re-evaluate an expression when its dependencies change";
    directive ~type_:Bool "ignore" "prevent a block of HTML from initializing";
    directive "ref" "reference elements directly by their name";
    directive ~type_:Bool "cloak" "hide an element until Alpine is initialized";
    directive "teleport" "move a template to another part of the DOM";
    directive "id" "generate unique IDs scoped to the element";
    directive ~type_:Bool "transition" "apply the default CSS transitions";
    transition ~jsx_suffix:"enter" ~suffix:"enter"
      "classes applied during the entire entering phase";
    transition ~jsx_suffix:"enter_start" ~suffix:"enter-start"
      "classes added before the element is inserted";
    transition ~jsx_suffix:"enter_end" ~suffix:"enter-end"
      "classes added one frame after the element is inserted";
    transition ~jsx_suffix:"leave" ~suffix:"leave"
      "classes applied during the entire leaving phase";
    transition ~jsx_suffix:"leave_start" ~suffix:"leave-start"
      "classes added when the leaving transition is triggered";
    transition ~jsx_suffix:"leave_end" ~suffix:"leave-end"
      "classes added one frame after the leaving transition is triggered";
  ]

let prefixes = [ ("x_on_", "x-on:"); ("x_bind_", "x-bind:") ]
