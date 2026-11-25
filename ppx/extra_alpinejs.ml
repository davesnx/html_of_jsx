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

let events =
  [
    "click";
    "dblclick";
    "contextmenu";
    "mousedown";
    "mouseup";
    "mouseenter";
    "mouseleave";
    "mouseover";
    "mouseout";
    "mousemove";
    "pointerdown";
    "pointerup";
    "pointermove";
    "touchstart";
    "touchend";
    "touchmove";
    "wheel";
    "keydown";
    "keyup";
    "keypress";
    "input";
    "change";
    "submit";
    "reset";
    "focus";
    "blur";
    "focusin";
    "focusout";
    "scroll";
    "resize";
    "load";
    "error";
    "select";
    "toggle";
    "copy";
    "cut";
    "paste";
    "drag";
    "dragstart";
    "dragend";
    "dragenter";
    "dragleave";
    "dragover";
    "drop";
    "animationend";
    "transitionend";
  ]

let bindable =
  [
    "class";
    "style";
    "id";
    "href";
    "src";
    "alt";
    "title";
    "name";
    "type";
    "value";
    "checked";
    "disabled";
    "selected";
    "hidden";
    "readonly";
    "required";
    "placeholder";
    "for";
    "tabindex";
    "width";
    "height";
  ]

let on event =
  Rich_attribute
    {
      name = "x-on:" ^ event;
      jsxName = "x_on_" ^ event;
      type_ = String;
      description = "run an expression when " ^ event ^ " is dispatched";
      url = "https://alpinejs.dev/directives/on";
    }

let bind attribute =
  Rich_attribute
    {
      name = "x-bind:" ^ attribute;
      jsxName = "x_bind_" ^ attribute;
      type_ = String;
      description = "set the " ^ attribute ^ " attribute from an expression";
      url = "https://alpinejs.dev/directives/bind";
    }

let attributes =
  List.map on events @ List.map bind bindable
  @ [
      directive "data" "declare a new Alpine component and its data";
      directive "init" "run code when an element is initialized";
      directive "show" "toggle the visibility of an element";
      directive "text" "set the text content of an element";
      directive "html" "set the inner HTML of an element";
      directive "model" "bind the value of an input element to Alpine data";
      directive "modelable" "expose a property as the target of x-model";
      directive "for" "create DOM elements by iterating through a list";
      directive "if" "add or remove a block of HTML";
      directive "effect"
        "re-evaluate an expression when its dependencies change";
      directive ~type_:Bool "ignore" "prevent a block of HTML from initializing";
      directive "ref" "reference elements directly by their name";
      directive ~type_:Bool "cloak"
        "hide an element until Alpine is initialized";
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
