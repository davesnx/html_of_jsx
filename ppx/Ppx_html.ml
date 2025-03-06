(** List of HTML attributes that bring type-safety and validation based on their
    tag *)

open Ppx_attributes
(* TODO:
    - Add description + url in attributes
    - Ensure html names are correct (take a look at server-reason-react-ppx and mdn)
*)

[@@@ocamlformat "disable"]
(* This file is more like a spreadsheet, prefer to keep it with margin=300.
   Since @@@ocamlformat "margin=300" is not possible, we disable it entirely. *)

let attributeReferrerPolicy = String
(* | Empty | NoReferrer | NoReferrerWhenDowngrade | Origin |
   OriginWhencrossorigin | OriginWhenCrossOrigin | SameOrigin | StrictOrigin |
   StrictOriginWhenCrossOrigin | UnsafeUrl *)

let attributeAnchorTarget = String
(* | Self | Blank | Parent | Top | Custom of String *)

(* https://developer.mozilla.org/en-US/docs/Web/Events/Event_handlers *)
let globalEventHandlers =
  [
    Event { jsxName = "oncopy"; type_ = Clipboard };
    Event { jsxName = "oncopycapture"; type_ = Clipboard };
    Event { jsxName = "oncut"; type_ = Clipboard };
    Event { jsxName = "oncutcapture"; type_ = Clipboard };
    Event { jsxName = "onpaste"; type_ = Clipboard };
    Event { jsxName = "onpastecapture"; type_ = Clipboard };
    Event { jsxName = "oncompositionend"; type_ = Composition };
    Event { jsxName = "oncompositionendcapture"; type_ = Composition };
    Event { jsxName = "oncompositionstart"; type_ = Composition };
    Event { jsxName = "oncompositionstartcapture"; type_ = Composition };
    Event { jsxName = "oncompositionupdate"; type_ = Composition };
    Event { jsxName = "oncompositionupdatecapture"; type_ = Composition };
    Event { jsxName = "onfocus"; type_ = Focus };
    Event { jsxName = "onfocuscapture"; type_ = Focus };
    Event { jsxName = "onblur"; type_ = Focus };
    Event { jsxName = "onblurcapture"; type_ = Focus };
    Event { jsxName = "onchange"; type_ = Form };
    Event { jsxName = "onchangecapture"; type_ = Form };
    Event { jsxName = "onbeforeinput"; type_ = Form };
    Event { jsxName = "onbeforeinputcapture"; type_ = Form };
    Event { jsxName = "oninput"; type_ = Form };
    Event { jsxName = "oninputcapture"; type_ = Form };
    Event { jsxName = "onreset"; type_ = Form };
    Event { jsxName = "onresetcapture"; type_ = Form };
    Event { jsxName = "onsubmit"; type_ = Form };
    Event { jsxName = "onsubmitcapture"; type_ = Form };
    Event { jsxName = "oninvalid"; type_ = Form };
    Event { jsxName = "oninvalidcapture"; type_ = Form };
    Event { jsxName = "onload"; type_ = Media };
    Event { jsxName = "onloadcapture"; type_ = Media };
    Event { jsxName = "onerror"; type_ = Media };
    Event { jsxName = "onerrorcapture"; type_ = Media };
    Event { jsxName = "onkeydown"; type_ = Keyboard };
    Event { jsxName = "onkeydowncapture"; type_ = Keyboard };
    Event { jsxName = "onkeypress"; type_ = Keyboard };
    Event { jsxName = "onkeypresscapture"; type_ = Keyboard };
    Event { jsxName = "onkeyup"; type_ = Keyboard };
    Event { jsxName = "onkeyupcapture"; type_ = Keyboard };
    Event { jsxName = "onabort"; type_ = Media };
    Event { jsxName = "onabortcapture"; type_ = Media };
    Event { jsxName = "oncanplay"; type_ = Media };
    Event { jsxName = "oncanplaycapture"; type_ = Media };
    Event { jsxName = "oncanplaythrough"; type_ = Media };
    Event { jsxName = "oncanplaythroughcapture"; type_ = Media };
    Event { jsxName = "ondurationchange"; type_ = Media };
    Event { jsxName = "ondurationchangecapture"; type_ = Media };
    Event { jsxName = "onemptied"; type_ = Media };
    Event { jsxName = "onemptiedcapture"; type_ = Media };
    Event { jsxName = "onencrypted"; type_ = Media };
    Event { jsxName = "onencryptedcapture"; type_ = Media };
    Event { jsxName = "onended"; type_ = Media };
    Event { jsxName = "onendedcapture"; type_ = Media };
    Event { jsxName = "onloadeddata"; type_ = Media };
    Event { jsxName = "onloadeddatacapture"; type_ = Media };
    Event { jsxName = "onloadedmetadata"; type_ = Media };
    Event { jsxName = "onloadedmetadatacapture"; type_ = Media };
    Event { jsxName = "onloadstart"; type_ = Media };
    Event { jsxName = "onloadstartcapture"; type_ = Media };
    Event { jsxName = "onpause"; type_ = Media };
    Event { jsxName = "onpausecapture"; type_ = Media };
    Event { jsxName = "onplay"; type_ = Media };
    Event { jsxName = "onplaycapture"; type_ = Media };
    Event { jsxName = "onplaying"; type_ = Media };
    Event { jsxName = "onplayingcapture"; type_ = Media };
    Event { jsxName = "onprogress"; type_ = Media };
    Event { jsxName = "onprogresscapture"; type_ = Media };
    Event { jsxName = "onratechange"; type_ = Media };
    Event { jsxName = "onratechangecapture"; type_ = Media };
    Event { jsxName = "onseeked"; type_ = Media };
    Event { jsxName = "onseekedcapture"; type_ = Media };
    Event { jsxName = "onseeking"; type_ = Media };
    Event { jsxName = "onseekingcapture"; type_ = Media };
    Event { jsxName = "onstalled"; type_ = Media };
    Event { jsxName = "onstalledcapture"; type_ = Media };
    Event { jsxName = "onsuspend"; type_ = Media };
    Event { jsxName = "onsuspendcapture"; type_ = Media };
    Event { jsxName = "ontimeupdate"; type_ = Media };
    Event { jsxName = "ontimeupdatecapture"; type_ = Media };
    Event { jsxName = "onvolumechange"; type_ = Media };
    Event { jsxName = "onvolumechangecapture"; type_ = Media };
    Event { jsxName = "onwaiting"; type_ = Media };
    Event { jsxName = "onwaitingcapture"; type_ = Media };
    Event { jsxName = "onauxclick"; type_ = Mouse };
    Event { jsxName = "onauxclickcapture"; type_ = Mouse };
    Event { jsxName = "onclick"; type_ = Mouse };
    Event { jsxName = "onclickcapture"; type_ = Mouse };
    Event { jsxName = "oncontextmenu"; type_ = Mouse };
    Event { jsxName = "oncontextmenucapture"; type_ = Mouse };
    Event { jsxName = "ondoubleclick"; type_ = Mouse };
    Event { jsxName = "ondoubleclickcapture"; type_ = Mouse };
    Event { jsxName = "ondrag"; type_ = Drag };
    Event { jsxName = "ondragcapture"; type_ = Drag };
    Event { jsxName = "ondragend"; type_ = Drag };
    Event { jsxName = "ondragendcapture"; type_ = Drag };
    Event { jsxName = "ondragenter"; type_ = Drag };
    Event { jsxName = "ondragentercapture"; type_ = Drag };
    Event { jsxName = "ondragexit"; type_ = Drag };
    Event { jsxName = "ondragexitcapture"; type_ = Drag };
    Event { jsxName = "ondragleave"; type_ = Drag };
    Event { jsxName = "ondragleavecapture"; type_ = Drag };
    Event { jsxName = "ondragover"; type_ = Drag };
    Event { jsxName = "ondragovercapture"; type_ = Drag };
    Event { jsxName = "ondragstart"; type_ = Drag };
    Event { jsxName = "ondragstartcapture"; type_ = Drag };
    Event { jsxName = "ondrop"; type_ = Drag };
    Event { jsxName = "ondropcapture"; type_ = Drag };
    Event { jsxName = "onmousedown"; type_ = Mouse };
    Event { jsxName = "onmousedowncapture"; type_ = Mouse };
    Event { jsxName = "onmouseenter"; type_ = Mouse };
    Event { jsxName = "onmouseleave"; type_ = Mouse };
    Event { jsxName = "onmousemove"; type_ = Mouse };
    Event { jsxName = "onmousemovecapture"; type_ = Mouse };
    Event { jsxName = "onmouseout"; type_ = Mouse };
    Event { jsxName = "onmouseoutcapture"; type_ = Mouse };
    Event { jsxName = "onmouseover"; type_ = Mouse };
    Event { jsxName = "onmouseovercapture"; type_ = Mouse };
    Event { jsxName = "onmouseup"; type_ = Mouse };
    Event { jsxName = "onmouseupcapture"; type_ = Mouse };
    Event { jsxName = "onselect"; type_ = Selection };
    Event { jsxName = "onselectcapture"; type_ = Selection };
    Event { jsxName = "ontouchcancel"; type_ = Touch };
    Event { jsxName = "ontouchcancelcapture"; type_ = Touch };
    Event { jsxName = "ontouchend"; type_ = Touch };
    Event { jsxName = "ontouchendcapture"; type_ = Touch };
    Event { jsxName = "ontouchmove"; type_ = Touch };
    Event { jsxName = "ontouchmovecapture"; type_ = Touch };
    Event { jsxName = "ontouchstart"; type_ = Touch };
    Event { jsxName = "ontouchstartcapture"; type_ = Touch };
    Event { jsxName = "onpointerdown"; type_ = Pointer };
    Event { jsxName = "onpointerdowncapture"; type_ = Pointer };
    Event { jsxName = "onpointermove"; type_ = Pointer };
    Event { jsxName = "onpointermovecapture"; type_ = Pointer };
    Event { jsxName = "onpointerup"; type_ = Pointer };
    Event { jsxName = "onpointerupcapture"; type_ = Pointer };
    Event { jsxName = "onpointercancel"; type_ = Pointer };
    Event { jsxName = "onpointercancelcapture"; type_ = Pointer };
    Event { jsxName = "onpointerenter"; type_ = Pointer };
    Event { jsxName = "onpointerentercapture"; type_ = Pointer };
    Event { jsxName = "onpointerleave"; type_ = Pointer };
    Event { jsxName = "onpointerleavecapture"; type_ = Pointer };
    Event { jsxName = "onpointerover"; type_ = Pointer };
    Event { jsxName = "onpointerovercapture"; type_ = Pointer };
    Event { jsxName = "onpointerout"; type_ = Pointer };
    Event { jsxName = "onpointeroutcapture"; type_ = Pointer };
    Event { jsxName = "ongotpointercapture"; type_ = Pointer };
    Event { jsxName = "ongotpointercapturecapture"; type_ = Pointer };
    Event { jsxName = "onlostpointercapture"; type_ = Pointer };
    Event { jsxName = "onlostpointercapturecapture"; type_ = Pointer };
    Event { jsxName = "onscroll"; type_ = UI };
    Event { jsxName = "onscrollcapture"; type_ = UI };
    Event { jsxName = "onwheel"; type_ = Wheel };
    Event { jsxName = "onwheelcapture"; type_ = Wheel };
    Event { jsxName = "onanimationstart"; type_ = Animation };
    Event { jsxName = "onanimationstartcapture"; type_ = Animation };
    Event { jsxName = "onanimationend"; type_ = Animation };
    Event { jsxName = "onanimationendcapture"; type_ = Animation };
    Event { jsxName = "onanimationiteration"; type_ = Animation };
    Event { jsxName = "onanimationiterationcapture"; type_ = Animation };
    Event { jsxName = "ontransitionend"; type_ = Transition };
    Event { jsxName = "ontransitionendcapture"; type_ = Transition };
  ]

(* All the WAI-ARIA 1.1 attributes from https://www.w3.org/TR/wai-aria-1.1/ *)
let ariaAttributes =
  [
    (* Identifies the currently active element when DOM focus is on a composite
       widget, textbox, group, or application. *)
    Attribute { name = "aria-activedescendant"; jsxName = "aria_activedescendant"; type_ = String };

    (* Indicates whether assistive technologies will present all, or only parts
       of, the changed region based on the change notifications defined by the
       aria-relevant attribute. *)
    Attribute { name = "aria-atomic"; jsxName = "aria_atomic"; type_ = BooleanishString };

    (* Indicates whether inputting text could trigger display of one or more predictions of the user's intended value for an input and specifies how predictions would be
     * presented if they are made.
     *)
    Attribute { name = "aria-autocomplete"; jsxName = "aria_autocomplete"; type_ = String (* 'none' | 'inline' | 'list' | 'both' *) };

    (* Indicates an element is being modified and that assistive technologies
       MAY want to wait until the modifications are complete before exposing
       them to the user. *)
    Attribute { name = "aria-busy"; jsxName = "aria_busy"; type_ = BooleanishString };

    (* Indicates the current "checked" state of checkboxes, radio buttons, and other
    widgets.
    * @see aria-pressed @see aria-selected.
    *)
    Attribute { name = "aria-checked"; jsxName = "aria_checked"; type_ = String (* Bool | 'false' | 'mixed' | 'true' *) };

    (* Defines the total number of columns in a table, grid, or treegrid.
    * @see aria-colindex.
    *)
    Attribute { name = "aria-colcount"; jsxName = "aria_colcount"; type_ = Int };

    (* Defines an element's column index or position with respect to the total number of columns within a table,
    grid, or treegrid.
    * @see aria-colcount @see aria-colspan.
    *)
    Attribute { name = "aria-colindex"; jsxName = "aria_colindex"; type_ = Int };

    (* Defines the number of columns spanned by a cell or gridcell within a table, grid, or treegrid.
    * @see aria-colindex @see aria-rowspan.
    *)
    Attribute { name = "aria-colspan"; jsxName = "aria_colspan"; type_ = Int };

    (* Identifies the element (or elements) whose contents or presence are controlled by the current element.
    * @see aria-owns.
    *)
    Attribute { name = "aria-controls"; jsxName = "aria_controls"; type_ = String };

    (* Indicates the element that represents the current item within a container
       or set of related elements. *)
    Attribute { name = "aria-current"; jsxName = "aria_current"; type_ = String (* Bool | 'false' | 'true' | 'page' | 'step' | 'location' | 'date' | 'time' *) };

    (* Identifies the element (or elements) that describes the object.
     * @see aria-labelledby
     *)
    Attribute { name = "aria-describedby"; jsxName = "aria_describedby"; type_ = String };

    (* Identifies the element that provides a detailed, extended description for
       the object. * @see aria-describedby. *)
    Attribute { name = "aria-details"; jsxName = "aria_details"; type_ = String };

    (* Indicates that the element is perceivable but disabled, so it is not editable or otherwise operable.
    * @see aria-hidden @see aria-readonly.
    *)
    Attribute { name = "aria-disabled"; jsxName = "aria_disabled"; type_ = BooleanishString };

    (* Identifies the element that provides an error message for the object.
    * @see aria-invalid @see aria-describedby.
    *)
    Attribute { name = "aria-errormessage"; jsxName = "aria_errormessage"; type_ = String };

    (* Indicates whether the element, or another grouping element it controls,
       is currently expanded or collapsed. *)
    Attribute { name = "aria-expanded"; jsxName = "aria_expanded"; type_ = BooleanishString };

    (* Identifies the next element (or elements) in an alternate reading order of content which, at the user's discretion,
     * allows assistive technology to override the general default of reading in document source order.
     *)
    Attribute { name = "aria-flowto"; jsxName = "aria_flowto"; type_ = String };

    (* Indicates the availability and type of interactive popup element, such as
       menu or dialog, that can be triggered by an element. *)
    Attribute { name = "aria-haspopup"; jsxName = "aria_haspopup"; type_ = String (* Bool | 'false' | 'true' | 'menu' | 'listbox' | 'tree' | 'grid' | 'dialog'; *)};

    (* Indicates whether the element is exposed to an accessibility API.
     * @see aria-disabled.
     *)
    Attribute { name = "aria-hidden"; jsxName = "aria_hidden"; type_ = BooleanishString };

    (* Indicates the entered value does not conform to the format expected by the
    application.
    * @see aria-errormessage.
    *)
    Attribute { name = "aria-invalid"; jsxName = "aria_invalid"; type_ = String (* Bool | 'false' | 'true' | 'grammar' | 'spelling'; *) };

    (* Indicates keyboard shortcuts that an author has implemented to activate
       or give focus to an element. *)
    Attribute { name = "aria-keyshortcuts"; jsxName = "aria_keyshortcuts"; type_ = String };

    (* Defines a String value that labels the current element.
    * @see aria-labelledby.
    *)
    Attribute { name = "aria-label"; jsxName = "aria_label"; type_ = String };

    (* Identifies the element (or elements) that labels the current element.
    * @see aria-describedby.
    *)
    Attribute { name = "aria-labelledby"; jsxName = "aria_labelledby"; type_ = String };

    (* Defines the hierarchical level of an element within a structure. *)
    Attribute { name = "aria-level"; jsxName = "aria_level"; type_ = Int };

    (* Indicates that an element will be updated, and describes the types of
       updates the user agents, assistive technologies, and user can expect ;rom
       the live region. *)
    Attribute { name = "aria-live"; jsxName = "aria_live"; type_ = String (* 'off' | 'assertive' | 'polite' *) };

    (* Indicates whether an element is modal when displayed. *)

    Attribute { name = "aria-modal"; jsxName = "aria_modal"; type_ = BooleanishString };

    (* Indicates whether a text box accepts multiple lines of input or only a
       single line. *)
    Attribute { name = "aria-multiline"; jsxName = "aria_multiline"; type_ = BooleanishString };

    (* Indicates that the user may select more than one item from the current
       selectable descendants. *)
    Attribute { name = "aria-multiselectable"; jsxName = "aria_multiselectable"; type_ = BooleanishString };

    (* Indicates whether the element's orientation is horizontal, vertical, or
       unknown/ambiguous. *)
    Attribute { name = "aria-orientation"; jsxName = "aria_orientation"; type_ = String (* 'horizontal' | 'vertical' *) };

    (* Identifies an element (or elements) in order to define a visual, functional, or contextual parent/child relationship
     * between DOM elements where the DOM hierarchy cannot be used to represent the relationship.
     * @see aria-controls.
     *)
    Attribute { name = "aria-owns"; jsxName = "aria_owns"; type_ = String };

    (* Defines a short hint (a word or short phrase) intended to aid the user with data entry when the control has no
    value.
    * A hint could be a sample value or a brief description of the expected format.
    *)
    Attribute { name = "aria-placeholder"; jsxName = "aria_placeholder"; type_ = String };

    (* Defines an element's number or position in the current set of listitems
       or treeitems. Not required if all elements in the set are present in the
       DOM. * @see aria-setsize. *)
    Attribute { name = "aria-posinset"; jsxName = "aria_posinset"; type_ = Int };

    (* Indicates the current "pressed" state of toggle buttons.
    * @see aria-checked @see aria-selected.
    *)
    Attribute { name = "aria-pressed"; jsxName = "aria_pressed"; type_ = String (* Bool | 'false' | 'mixed' | 'true' *) };

    (* Indicates that the element is not editable, but is otherwise
    operable.
    * @see aria-disabled.
    *)
    Attribute { name = "aria-readonly"; jsxName = "aria_readonly"; type_ = BooleanishString };

    (* Indicates what notifications the user agent will trigger when the
    accessibility tree within a live region is modified.
    * @see aria-atomic.
    *)
    Attribute { name = "aria-relevant"; jsxName = "aria_relevant"; type_ = String (* 'additions' | 'additions removals' | 'additions text' | 'all' | 'removals' | 'removals additions' | 'removals text' | 'text' | 'text additions' | 'text removals' *) };

    (* Indicates that user input is required on the element before a form may be
       submitted. *)
    Attribute { name = "aria-required"; jsxName = "aria_required"; type_ = BooleanishString };

    (* Defines a human-readable, author-localized description for the role of an
       element. *)
    Attribute { name = "aria-roledescription"; jsxName = "aria_roledescription"; type_ = String };

    (* Defines the total number of rows in a table, grid, or treegrid.
    * @see aria-rowindex.
    *)
    Attribute { name = "aria-rowcount"; jsxName = "aria_rowcount"; type_ = Int };

    (* Defines an element's row index or position with respect to the total number of rows within a table, grid, or
    treegrid.
    * @see aria-rowcount @see aria-rowspan.
    *)
    Attribute { name = "aria-rowindex"; jsxName = "aria_rowindex"; type_ = Int };

    (* *)

    Attribute { name = "aria-rowindextext"; jsxName = "aria_rowindextext"; type_ = String };

    (* Defines the number of rows spanned by a cell or gridcell within a table, grid, or treegrid.
    * @see aria-rowindex @see aria-colspan.
    *)
    Attribute { name = "aria-rowspan"; jsxName = "aria_rowspan"; type_ = Int };

    (* Indicates the current "selected" state of various widgets.
    * @see aria-checked @see aria-pressed.
    *)
    Attribute { name = "aria-selected"; jsxName = "aria_selected"; type_ = BooleanishString };

    (* Defines the number of items in the current set of listitems or treeitems.
    Not required if all elements in the set are present in the DOM.
    * @see aria-posinset.
    *)
    Attribute { name = "aria-setsize"; jsxName = "aria_setsize"; type_ = Int };

    (* Indicates if items in a table or grid are sorted in ascending or
       descending order. *)
    Attribute { name = "aria-sort"; jsxName = "aria_sort"; type_ = String (* 'none' | 'ascending' | 'descending' | 'other' *) };

    (* Defines the maximum allowed value for a range widget. *)

    Attribute { name = "aria-valuemax"; jsxName = "aria_valuemax"; type_ = Int };

    (* Defines the minimum allowed value for a range widget. *)

    Attribute { name = "aria-valuemin"; jsxName = "aria_valuemin"; type_ = Int };

    (* Defines the current value for a range widget.
    * @see aria-valuetext.
    *)
    Attribute { name = "aria-valuenow"; jsxName = "aria_valuenow"; type_ = Int };

    (* Defines the human readable text alternative of aria-valuenow for a range
       widget. *)
    Attribute { name = "aria-valuetext"; jsxName = "aria_valuetext"; type_ = String };

  ]

(* All the WAI-ARIA 1.1 role attribute values from
   https://www.w3.org/TR/wai-aria-1.1/#role_definitions *)
let ariaRole = String
(* | Alert | Alertdialog | Application | Article | Banner | Button | Cell |
   Checkbox | Columnheader | Combobox | Complementary | Contentinfo | Definition
   | Dialog | Directory | Document | Feed | Figure | Form | Grid | Gridcell |
   Group | Heading | Img | Link | List | Listbox | Listitem | Log | Main |
   Marquee | Math | Menu | Menubar | Menuitem | Menuitemcheckbox | Menuitemradio
   | Navigation | None | Note | Option | Presentation | Progressbar | Radio |
   Radiogroup | Region | Row | Rowgroup | Rowheader | Scrollbar | Search |
   Searchbox | Separator | Slider | Spinbutton | Status | Switch | Tab | Table |
   Tablist | Tabpanel | Term | Textbox | Timer | Toolbar | Tooltip | Tree |
   Treegrid | Treeitem | Custom of String *)

let globalAttributes =
  [
    (* https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes *)
    (* Standard HTML Attributes *)
    Attribute { name = "accesskey"; jsxName = "accesskey"; type_ = String };
    Attribute { name = "autocapitalize"; jsxName = "autocapitalize"; type_ = String };
    (* Attribute { name = "contextMenu"; jsxName = "contextMenu"; type_ = String }; *)
    Attribute { name = "class"; jsxName = "class_"; type_ = String };
    Attribute { name = "contenteditable"; jsxName = "contenteditable"; type_ = BooleanishString };
    Attribute { name = "dir"; jsxName = "dir"; type_ = String };
    Attribute { name = "draggable"; jsxName = "draggable"; type_ = BooleanishString };
    Attribute { name = "hidden"; jsxName = "hidden"; type_ = Bool };
    Attribute { name = "id"; jsxName = "id"; type_ = String };
    Attribute { name = "itemprop"; jsxName = "itemprop"; type_ = String };
    Attribute { name = "itemscope"; jsxName = "itemscope"; type_ = Bool };
    Attribute { name = "itemtype"; jsxName = "itemtype"; type_ = String };
    Attribute { name = "itemid"; jsxName = "itemid"; type_ = String };
    Attribute { name = "itemref"; jsxName = "itemref"; type_ = String };
    Attribute { name = "lang"; jsxName = "lang"; type_ = String };
    Attribute { name = "placeholder"; jsxName = "placeholder"; type_ = String };
    Attribute { name = "part"; jsxName = "part"; type_ = String };
    Attribute { name = "nonce"; jsxName = "nonce"; type_ = String };
    Attribute { name = "slot"; jsxName = "slot"; type_ = String };
    Attribute { name = "spellcheck"; jsxName = "spellcheck"; type_ = BooleanishString };
    Attribute { name = "style"; jsxName = "style"; type_ = Style };
    Attribute { name = "tabindex"; jsxName = "tabindex"; type_ = Int };
    Attribute { name = "enterKeyHint"; jsxName = "enterKeyHint"; type_ = Int };
    (* data-* attributes are globaly available *)
    (* Experimental ; Attribute {name= "exportParts"; jsxName= "exportParts";
       type_= Int} *)
    Attribute { name = "title"; jsxName = "title"; type_ = String };
    Attribute { name = "translate"; jsxName = "translate"; type_ = String (* 'yes' | 'no' *) };

    (* Living Standard * Hints at the type of data that might be entered by the
       user while editing the element or its contents * @see
       https://html.spec.whatwg.org/multipage/interaction.html#input-modalities:-the-inputmode-attribute *)
    Attribute { name = "inputmode"; jsxName = "inputmode"; type_ = String (* 'none' | 'text' | 'tel' | 'url' | 'email' | 'numeric' | 'decimal' | 'search' *) };

    (* Specify that a standard HTML element should behave like a defined custom
       built-in element * @see
       https://html.spec.whatwg.org/multipage/custom-elements.html#attr-is *)
    Attribute { name = "is"; jsxName = "is"; type_ = String };
  ]

let elementAttributes =
  [
    (* Attribute { name = "radioGroup"; jsxName = "radioGroup"; type_ = String }; *)

    (* WAI-ARIA *)
    Attribute { name = "role"; jsxName = "role"; type_ = ariaRole };

    (* RDFa Attributes *)
    Attribute { name = "about"; jsxName = "about"; type_ = String };
    Attribute { name = "dataType"; jsxName = "dataType"; type_ = String };
    Attribute { name = "inlist"; jsxName = "inlist"; type_ = String (* any *) };
    Attribute { name = "prefix"; jsxName = "prefix"; type_ = String };
    Attribute { name = "property"; jsxName = "property"; type_ = String };
    Attribute { name = "resource"; jsxName = "resource"; type_ = String };
    Attribute { name = "typeof"; jsxName = "typeof"; type_ = String };
    Attribute { name = "vocab"; jsxName = "vocab"; type_ = String };

    (* Non-standard Attributes *)
    Attribute { name = "autocorrect"; jsxName = "autocorrect"; type_ = String };
    Attribute { name = "autosave"; jsxName = "autosave"; type_ = String };
    Attribute { name = "color"; jsxName = "color"; type_ = String };
    Attribute { name = "results"; jsxName = "results"; type_ = Int };
    Attribute { name = "security"; jsxName = "security"; type_ = String };
  ]

let anchorHTMLAttributes =
  [
    Attribute { name = "download"; jsxName = "download"; type_ = String (* any *) };
    Attribute { name = "href"; jsxName = "href"; type_ = String };
    Attribute { name = "hreflang"; jsxName = "hreflang"; type_ = String };
    Attribute { name = "media"; jsxName = "media"; type_ = String };
    Attribute { name = "ping"; jsxName = "ping"; type_ = String };
    Attribute { name = "rel"; jsxName = "rel"; type_ = String };
    Attribute { name = "target"; jsxName = "target"; type_ = attributeAnchorTarget };
    Attribute { name = "type"; jsxName = "type_"; type_ = String };
    Attribute { name = "referrerpolicy"; jsxName = "referrerpolicy"; type_ = attributeReferrerPolicy };
  ]

let areaHTMLAttributes =
  [
    Attribute { name = "alt"; jsxName = "alt"; type_ = String };
    Attribute { name = "coords"; jsxName = "coords"; type_ = String };
    Attribute { name = "download"; jsxName = "download"; type_ = String (* any *) };
    Attribute { name = "href"; jsxName = "href"; type_ = String };
    Attribute { name = "hreflang"; jsxName = "hreflang"; type_ = String };
    Attribute { name = "media"; jsxName = "media"; type_ = String };
    Attribute { name = "referrerpolicy"; jsxName = "referrerpolicy"; type_ = attributeReferrerPolicy };
    Attribute { name = "rel"; jsxName = "rel"; type_ = String };
    Attribute { name = "shape"; jsxName = "shape"; type_ = String };
    Attribute { name = "target"; jsxName = "target"; type_ = String };
  ]

let baseHTMLAttributes =
  [
    Attribute { name = "href"; jsxName = "href"; type_ = String };
    Attribute { name = "target"; jsxName = "target"; type_ = String };
  ]

let blockquoteHTMLAttributes =
  [
    Attribute { name = "cite"; jsxName = "cite"; type_ = String };
  ]

let buttonHTMLAttributes =
  [
    Attribute { name = "autofocus"; jsxName = "autofocus"; type_ = Bool };
    Attribute { name = "disabled"; jsxName = "disabled"; type_ = Bool };
    Attribute { name = "form"; jsxName = "form"; type_ = String };
    Attribute { name = "formaction"; jsxName = "formaction"; type_ = String };
    Attribute { name = "formenctype"; jsxName = "formenctype"; type_ = String };
    Attribute { name = "formmethod"; jsxName = "formmethod"; type_ = String };
    Attribute { name = "formnovalidate"; jsxName = "formnovalidate"; type_ = Bool };
    Attribute { name = "formtarget"; jsxName = "formtarget"; type_ = String };
    Attribute { name = "name"; jsxName = "name"; type_ = String };
    Attribute { name = "type"; jsxName = "type_"; type_ = String (* 'submit' | 'reset' | 'button' *) };
    Attribute { name = "value"; jsxName = "value"; type_ = String (* | ReadonlyArray<String> | number *) };
  ]

let canvasHTMLAttributes =
  [
    Attribute { name = "height"; jsxName = "height"; type_ = String (* number | *) };
    Attribute { name = "width"; jsxName = "width"; type_ = String (* number | *) }
  ]

let colHTMLAttributes =
  [
    Attribute { name = "span"; jsxName = "span"; type_ = Int (* number *) };
    Attribute { name = "width"; jsxName = "width"; type_ = String (* number | *) }
  ]

let colgroupHTMLAttributes =
  [
    Attribute { name = "span"; jsxName = "span"; type_ = Int (* number *) }
  ]

let dataHTMLAttributes =
  [
    Attribute { name = "value"; jsxName = "value"; type_ = String (* | ReadonlyArray<String> | number *) }
  ]

let detailsHTMLAttributes =
  [
    Attribute { name = "open"; jsxName = "open"; type_ = Bool }; Event { jsxName = "ontoggle"; type_ = Media }
  ]

let delHTMLAttributes =
  [
    Attribute { name = "cite"; type_ = String; jsxName = "cite" };
    Attribute { name = "datetime"; type_ = String; jsxName = "datetime" }
  ]

let dialogHTMLAttributes =
  [
    Attribute { name = "open"; jsxName = "open"; type_ = Bool }
  ]

let embedHTMLAttributes =
  [
    Attribute { name = "height"; jsxName = "height"; type_ = String (* number | *); };
    Attribute { name = "src"; jsxName = "src"; type_ = String; };
    Attribute { name = "type"; jsxName = "type"; type_ = String; };
    Attribute { name = "width"; type_ = String (* number | *); jsxName = "width" };
  ]

let fieldsetHTMLAttributes =
  [
    Attribute { name = "disabled"; jsxName = "disabled"; type_ = Bool };
    Attribute { name = "form"; jsxName = "form"; type_ = String };
    Attribute { name = "name"; jsxName = "name"; type_ = String };
  ]

(* https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form *)
let formHTMLAttributes =
  [
    Attribute { name = "acceptcharset"; jsxName = "acceptcharset"; type_ = String };
    Attribute { name = "action"; jsxName = "action"; type_ = String };
    Attribute { name = "autocomplete"; jsxName = "autocomplete"; type_ = String };
    Attribute { name = "enctype"; jsxName = "enctype"; type_ = String };
    Attribute { name = "method"; jsxName = "method_"; type_ = String };
    Attribute { name = "name"; jsxName = "name"; type_ = String };
    Attribute { name = "novalidate"; jsxName = "novalidate"; type_ = Bool };
    Attribute { name = "target"; jsxName = "target"; type_ = String };
  ]

(* https://developer.mozilla.org/en-US/docs/Web/HTML/Element/html *)
let htmlHTMLAttributes =
  [
    Attribute { name = "manifest"; jsxName = "manifest"; type_ = String };
    Attribute { name = "version"; jsxName = "version"; type_ = String };
    Attribute { name = "xmlns"; jsxName = "xmlns"; type_ = String };
  ]

(* https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe *)
let iframeHTMLAttributes =
  [
    Attribute { name = "allow"; jsxName = "allow"; type_ = String };
    Attribute { name = "allowfullscreen"; jsxName = "allowfullscreen"; type_ = Bool };
    (* Attribute { name = "allowTransparency"; jsxName = "allowTransparency"; type_ = Bool }; *)
    (* deprecated *) Attribute { name = "frameborder"; jsxName = "frameborder"; type_ = String (* number | *) };
    Attribute { name = "height"; jsxName = "height"; type_ = String (* number | *) };
    (* deprecated *) Attribute { name = "marginheight"; jsxName = "marginheight"; type_ = Int (* number *) };
    (* deprecated *) Attribute { name = "marginwidth"; jsxName = "marginwidth"; type_ = Int (* number *) };
    Attribute { name = "name"; jsxName = "name"; type_ = String };
    Attribute { name = "sandbox"; jsxName = "sandbox"; type_ = String };
    (* deprecated *) Attribute { name = "scrolling"; jsxName = "scrolling"; type_ = String };
    Attribute { name = "seamless"; jsxName = "seamless"; type_ = Bool };
    Attribute { name = "src"; jsxName = "src"; type_ = String };
    Attribute { name = "srcdoc"; jsxName = "srcdoc"; type_ = String };
    Attribute { name = "width"; jsxName = "width"; type_ = String (* number | *) };
  ]

(* https://developer.mozilla.org/en-US/docs/Web/HTML/Element/img *)
let imgHTMLAttributes =
  [
    Attribute { name = "alt"; jsxName = "alt"; type_ = String };
    Attribute { name = "crossorigin"; jsxName = "crossorigin"; type_ = String (* "anonymous" | "use-credentials" | "" *) };
    Attribute { name = "decoding"; jsxName = "decoding"; type_ = String (* "async" | "auto" | "sync" *) };
    Attribute { name = "height"; jsxName = "height"; type_ = String (* number | *) };
    Attribute { name = "sizes"; jsxName = "sizes"; type_ = String };
    Attribute { name = "src"; jsxName = "src"; type_ = String };
    Attribute { name = "srcset"; jsxName = "srcset"; type_ = String };
    Attribute { name = "usemap"; jsxName = "usemap"; type_ = String };
    Attribute { name = "width"; jsxName = "width"; type_ = String (* number | *) };
  ]

(* https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ins *)
let insHTMLAttributes =
  [
    Attribute { name = "cite"; jsxName = "cite"; type_ = String };
    Attribute { name = "datetime"; jsxName = "datetime"; type_ = String };
  ]

let inputTypeAttribute = String
(* | 'button' | 'checkbox' | 'color' | 'date' | 'datetime-local' | 'email' |
   'file' | 'hidden' | 'image' | 'month' | 'number' | 'password' | 'radio' |
   'range' | 'reset' | 'search' | 'submit' | 'tel' | 'text' | 'time' | 'url' |
   'week' | (String @ {}); *)

(* https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input *)
let inputHTMLAttributes =
  [
    Attribute { name = "accept"; jsxName = "accept"; type_ = String };
    Attribute { name = "alt"; jsxName = "alt"; type_ = String };
    Attribute { name = "autocomplete"; jsxName = "autocomplete"; type_ = String };
    Attribute { name = "autofocus"; jsxName = "autofocus"; type_ = Bool };
    Attribute { name = "capture"; jsxName = "capture"; type_ = String (* Bool | *) (* https://www.w3.org/TR/html-media-capture/ *) };
    Attribute { name = "checked"; jsxName = "checked"; type_ = Bool };
    Attribute { name = "crossorigin"; jsxName = "crossorigin"; type_ = String };
    Attribute { name = "disabled"; jsxName = "disabled"; type_ = Bool };
    Attribute { name = "form"; jsxName = "form"; type_ = String };
    Attribute { name = "formaction"; jsxName = "formaction"; type_ = String };
    Attribute { name = "formenctype"; jsxName = "formenctype"; type_ = String };
    Attribute { name = "formmethod"; jsxName = "formmethod"; type_ = String };
    Attribute { name = "formnovalidate"; jsxName = "formnovalidate"; type_ = Bool };
    Attribute { name = "formtarget"; jsxName = "formtarget"; type_ = String };
    Attribute { name = "height"; jsxName = "height"; type_ = String (* number | *) };
    Attribute { name = "list"; jsxName = "list"; type_ = String };
    Attribute { name = "max"; jsxName = "max"; type_ = String (* number | *) };
    Attribute { name = "maxlength"; jsxName = "maxlength"; type_ = Int (* number *) };
    Attribute { name = "min"; jsxName = "min"; type_ = String (* number | *) };
    Attribute { name = "minlength"; jsxName = "minlength"; type_ = Int (* number *) };
    Attribute { name = "multiple"; jsxName = "multiple"; type_ = Bool };
    Attribute { name = "name"; jsxName = "name"; type_ = String };
    Attribute { name = "pattern"; jsxName = "pattern"; type_ = String };
    Attribute { name = "placeholder"; jsxName = "placeholder"; type_ = String };
    Attribute { name = "readonly"; jsxName = "readonly"; type_ = Bool };
    Attribute { name = "required"; jsxName = "required"; type_ = Bool };
    Attribute { name = "size"; jsxName = "size"; type_ = Int (* number *) };
    Attribute { name = "src"; jsxName = "src"; type_ = String };
    Attribute { name = "step"; jsxName = "step"; type_ = String (* number | *) };
    Attribute { name = "type"; jsxName = "type_"; type_ = inputTypeAttribute };
    Attribute { name = "value"; jsxName = "value"; type_ = String (* | ReadonlyArray<String> | number *) };
    Attribute { name = "width"; jsxName = "width"; type_ = String (* number | *) };
  ]

let keygenHTMLAttributes =
  [
    Attribute { name = "autofocus"; jsxName = "autofocus"; type_ = Bool };
    Attribute { name = "challenge"; jsxName = "challenge"; type_ = String };
    Attribute { name = "disabled"; jsxName = "disabled"; type_ = Bool };
    Attribute { name = "form"; jsxName = "form"; type_ = String };
    Attribute { name = "keyType"; jsxName = "keyType"; type_ = String };
    Attribute { name = "keyParams"; jsxName = "keyParams"; type_ = String };
    Attribute { name = "name"; jsxName = "name"; type_ = String };
  ]

let labelHTMLAttributes =
  [
    Attribute { name = "form"; jsxName = "form"; type_ = String };
    Attribute { name = "for"; jsxName = "for_"; type_ = String };
  ]

(* https://developer.mozilla.org/en-US/docs/Web/HTML/Element/li *)
let liHTMLAttributes =
  [
    Attribute { name = "value"; jsxName = "value"; type_ = String (* | ReadonlyArray<String> | number *) }
  ]

(* https://developer.mozilla.org/en-US/docs/Web/HTML/Element/link *)
let linkHTMLAttributes =
  [
    Attribute { name = "as"; jsxName = "as_"; type_ = String };
    Attribute { name = "crossorigin"; jsxName = "crossorigin"; type_ = String };
    Attribute { name = "href"; jsxName = "href"; type_ = String };
    Attribute { name = "hreflang"; jsxName = "hreflang"; type_ = String };
    Attribute { name = "integrity"; jsxName = "integrity"; type_ = String };
    Attribute { name = "imagesrcset"; jsxName = "imagesrcset"; type_ = String };
    Attribute { name = "media"; jsxName = "media"; type_ = String };
    Attribute { name = "rel"; jsxName = "rel"; type_ = String };
    Attribute { name = "sizes"; jsxName = "sizes"; type_ = String };
    Attribute { name = "type"; jsxName = "type_"; type_ = String };
    Attribute { name = "charset"; jsxName = "charset"; type_ = String };
  ]

let mapHTMLAttributes =
  [
    Attribute { name = "name"; jsxName = "name"; type_ = String };
  ]

let menuHTMLAttributes =
  [
    Attribute { name = "type"; jsxName = "type_"; type_ = String };
  ]

let mediaHTMLAttributes =
  [
    Attribute { name = "autoplay"; jsxName = "autoplay"; type_ = Bool };
    Attribute { name = "controls"; jsxName = "controls"; type_ = Bool };
    (* Attribute { name = "controlsList"; jsxName = "controlsList"; type_ = String }; *)
    Attribute { name = "crossorigin"; jsxName = "crossorigin"; type_ = String };
    Attribute { name = "loop"; jsxName = "loop"; type_ = Bool };
    (* deprecated *)
    (* Attribute { name = "mediaGroup"; jsxName = "mediaGroup"; type_ = String }; *)
    Attribute { name = "muted"; jsxName = "muted"; type_ = Bool };
    Attribute { name = "playsinline"; jsxName = "playsinline"; type_ = Bool };
    Attribute { name = "preload"; jsxName = "preload"; type_ = String };
    Attribute { name = "src"; jsxName = "src"; type_ = String };
  ]

let metaHTMLAttributes =
  [
    Attribute { name = "charset"; jsxName = "charset"; type_ = String };
    Attribute { name = "content"; jsxName = "content"; type_ = String };
    Attribute { name = "http-equiv"; jsxName = "httpEquiv"; type_ = String };
    Attribute { name = "name"; jsxName = "name"; type_ = String };
    Attribute { name = "media"; jsxName = "media"; type_ = String };
  ]

let meterHTMLAttributes =
  [
    Attribute { name = "form"; jsxName = "form"; type_ = String };
    Attribute { name = "high"; jsxName = "high"; type_ = Int (* number *) };
    Attribute { name = "low"; jsxName = "low"; type_ = Int (* number *) };
    Attribute { name = "max"; jsxName = "max"; type_ = String (* number | *) };
    Attribute { name = "min"; jsxName = "min"; type_ = String (* number | *) };
    Attribute { name = "optimum"; jsxName = "optimum"; type_ = Int (* number *) };
    Attribute { name = "value"; jsxName = "value"; type_ = String (* | ReadonlyArray<String> | number *) };
  ]

let quoteHTMLAttributes =
  [
    Attribute { name = "cite"; jsxName = "cite"; type_ = String };
  ]

let objectHTMLAttributes =
  [
    Attribute { name = "classid"; jsxName = "classid"; type_ = String };
    Attribute { name = "data"; jsxName = "data"; type_ = String };
    Attribute { name = "form"; jsxName = "form"; type_ = String };
    Attribute { name = "height"; jsxName = "height"; type_ = String (* number | *) };
    Attribute { name = "name"; jsxName = "name"; type_ = String };
    Attribute { name = "type"; jsxName = "type_"; type_ = String };
    Attribute { name = "usemap"; jsxName = "usemap"; type_ = String };
    Attribute { name = "width"; jsxName = "width"; type_ = String (* number | *) };
    Attribute { name = "wmode"; jsxName = "wmode"; type_ = String };
  ]

let olHTMLAttributes =
  [
    Attribute { name = "reversed"; jsxName = "reversed"; type_ = Bool };
    Attribute { name = "start"; jsxName = "start"; type_ = Int (* number *) };
    Attribute { name = "type"; jsxName = "type_"; type_ = String (* '1' | 'a' | 'A' | 'i' | 'I' *) };
  ]

let optgroupHTMLAttributes =
  [
    Attribute { name = "disabled"; jsxName = "disabled"; type_ = Bool };
    Attribute { name = "label"; jsxName = "label"; type_ = String };
  ]

let optionHTMLAttributes =
  [
    Attribute { name = "disabled"; jsxName = "disabled"; type_ = Bool };
    Attribute { name = "label"; jsxName = "label"; type_ = String };
    Attribute { name = "selected"; jsxName = "selected"; type_ = Bool };
    Attribute { name = "value"; jsxName = "value"; type_ = String (* | ReadonlyArray<String> | number *) };
  ]

let outputHTMLAttributes =
  [
    Attribute { name = "form"; jsxName = "form"; type_ = String };
    Attribute { name = "for"; jsxName = "for_"; type_ = String };
    Attribute { name = "name"; jsxName = "name"; type_ = String };
  ]

let paramHTMLAttributes =
  [
    Attribute { name = "name"; jsxName = "name"; type_ = String };
    Attribute { name = "value"; jsxName = "value"; type_ = String (* | ReadonlyArray<String> | number *) };
  ]

let progressHTMLAttributes =
  [
    Attribute { name = "max"; jsxName = "max"; type_ = String (* number | *) };
    Attribute { name = "value"; jsxName = "value"; type_ = String (* | ReadonlyArray<String> | number *) };
  ]

let slotHTMLAttributes =
  [
    Attribute { name = "name"; jsxName = "name"; type_ = String };
  ]

let scriptHTMLAttributes =
  [
    (* deprecated *) Attribute { name = "async"; jsxName = "async"; type_ = Bool };
    (* deprecated *) Attribute { name = "charset"; jsxName = "charset"; type_ = String };
    (* deprecated *) Attribute { name = "language"; jsxName = "charset"; type_ = String };
    Attribute { name = "crossorigin"; jsxName = "crossorigin"; type_ = String };
    Attribute { name = "defer"; jsxName = "defer"; type_ = Bool };
    Attribute { name = "integrity"; jsxName = "integrity"; type_ = String };
    Attribute { name = "nomodule"; jsxName = "nomodule"; type_ = Bool };
    Attribute { name = "nonce"; jsxName = "nonce"; type_ = String };
    Attribute { name = "src"; jsxName = "src"; type_ = String };
    Attribute { name = "referrerpolicy"; jsxName = "referrerpolicy"; type_ = attributeReferrerPolicy };
    Attribute { name = "type"; jsxName = "type_"; type_ = String };
  ]

let selectHTMLAttributes =
  [
    Attribute { name = "autocomplete"; jsxName = "autocomplete"; type_ = String };
    Attribute { name = "autofocus"; jsxName = "autofocus"; type_ = Bool };
    Attribute { name = "disabled"; jsxName = "disabled"; type_ = Bool };
    Attribute { name = "form"; jsxName = "form"; type_ = String };
    Attribute { name = "multiple"; jsxName = "multiple"; type_ = Bool };
    Attribute { name = "name"; jsxName = "name"; type_ = String };
    Attribute { name = "required"; jsxName = "required"; type_ = Bool };
    Attribute { name = "size"; jsxName = "size"; type_ = Int (* number *) };
    Attribute { name = "value"; jsxName = "value"; type_ = String (* | ReadonlyArray<String> | number *) };
    Event { jsxName = "onchange"; type_ = Form };
  ]

let sourceHTMLAttributes =
  [
    Attribute { name = "height"; jsxName = "height"; type_ = String (* number | *) };
    Attribute { name = "media"; jsxName = "media"; type_ = String };
    Attribute { name = "sizes"; jsxName = "sizes"; type_ = String };
    Attribute { name = "src"; jsxName = "src"; type_ = String };
    Attribute { name = "srcset"; jsxName = "srcset"; type_ = String };
    Attribute { name = "type"; jsxName = "type_"; type_ = String };
    Attribute { name = "width"; jsxName = "width"; type_ = String (* number | *) };
  ]

let styleHTMLAttributes =
  [
    Attribute { name = "media"; jsxName = "media"; type_ = String };
    Attribute { name = "nonce"; jsxName = "nonce"; type_ = String };
    Attribute { name = "scoped"; jsxName = "scoped"; type_ = Bool };
    Attribute { name = "type"; jsxName = "type_"; type_ = String }
  ]

let tableHTMLAttributes =
  [
    Attribute { name = "cellpadding"; jsxName = "cellpadding"; type_ = String (* number | *) };
    Attribute { name = "cellspacing"; jsxName = "cellspacing"; type_ = String (* number | *) };
    Attribute { name = "summary"; jsxName = "summary"; type_ = String };
    Attribute { name = "width"; jsxName = "width"; type_ = String (* number | *) };
  ]

let textareaHTMLAttributes =
  [
    Attribute { name = "autocomplete"; jsxName = "autocomplete"; type_ = String };
    Attribute { name = "autofocus"; jsxName = "autofocus"; type_ = String };
    Attribute { name = "cols"; jsxName = "cols"; type_ = Int (* number *) };
    Attribute { name = "dirname"; jsxName = "dirname"; type_ = String };
    Attribute { name = "disabled"; jsxName = "disabled"; type_ = Bool };
    Attribute { name = "form"; jsxName = "form"; type_ = String };
    Attribute { name = "maxlength"; jsxName = "maxlength"; type_ = Int (* number *) };
    Attribute { name = "minlength"; jsxName = "minlength"; type_ = Int (* number *) };
    Attribute { name = "name"; jsxName = "name"; type_ = String };
    Attribute { name = "placeholder"; jsxName = "placeholder"; type_ = String };
    Attribute { name = "readonly"; jsxName = "readonly"; type_ = Bool };
    Attribute { name = "required"; jsxName = "required"; type_ = Bool };
    Attribute { name = "rows"; jsxName = "rows"; type_ = Int (* number *) };
    Attribute { name = "value"; jsxName = "value"; type_ = String (* | ReadonlyArray<String> | number *) };
    Attribute { name = "wrap"; jsxName = "wrap"; type_ = String };
  ]

let tdHTMLAttributes =
  [
    Attribute { name = "align"; jsxName = "align"; type_ = String (* type_= "left" | "center" | "right" | "justify" | "char" *) };
    Attribute { name = "colspan"; jsxName = "colspan"; type_ = Int (* number *) };
    Attribute { name = "headers"; jsxName = "headers"; type_ = String };
    Attribute { name = "rowspan"; jsxName = "rowspan"; type_ = Int (* number *) };
    Attribute { name = "scope"; jsxName = "scope"; type_ = String };
    Attribute { name = "abbr"; jsxName = "abbr"; type_ = String };
    Attribute { name = "height"; jsxName = "height"; type_ = String (* number | *) };
    Attribute { name = "width"; jsxName = "width"; type_ = String (* number | *) };
    Attribute { name = "valign"; jsxName = "valign"; type_ = String (* "top" | "middle" | "bottom" | "baseline" *) };
  ]

let thHTMLAttributes =
  [
    Attribute { name = "align"; jsxName = "align"; type_ = String (* "left" | "center" | "right" | "justify" | "char" *) };
    Attribute { name = "colspan"; jsxName = "colspan"; type_ = Int (* number *) };
    Attribute { name = "headers"; jsxName = "headers"; type_ = String };
    Attribute { name = "rowspan"; jsxName = "rowspan"; type_ = Int (* number *) };
    Attribute { name = "scope"; jsxName = "scope"; type_ = String };
    Attribute { name = "abbr"; jsxName = "abbr"; type_ = String };
  ]

let timeHTMLAttributes =
  [
    Attribute { name = "datetime"; jsxName = "datetime"; type_ = String };
  ]

let trackHTMLAttributes =
  [
    Attribute { name = "default"; jsxName = "default"; type_ = Bool };
    Attribute { name = "kind"; jsxName = "kind"; type_ = String };
    Attribute { name = "label"; jsxName = "label"; type_ = String };
    Attribute { name = "src"; jsxName = "src"; type_ = String };
    Attribute { name = "srclang"; jsxName = "srclang"; type_ = String };
  ]

let videoHTMLAttributes =
  [
    Attribute { name = "height"; jsxName = "height"; type_ = String (* number | *) };
    Attribute { name = "playsinline"; jsxName = "playsinline"; type_ = Bool };
    Attribute { name = "poster"; jsxName = "poster"; type_ = String };
    Attribute { name = "width"; jsxName = "width"; type_ = String (* number | *) };
    Attribute { name = "disablePictureInPicture"; jsxName = "disablepictureinpicture"; type_ = Bool };
  ]

module SVG = struct
  (* "https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/" *)

  let coreAttributes =
    (* https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/Core *)
    [
      Attribute { name = "id"; jsxName = "id"; type_ = String };
      Attribute { name = "lang"; jsxName = "lang"; type_ = String };
      Attribute { name = "tabindex"; jsxName = "tabindex"; type_ = String };
      Attribute { name = "xmlBase"; jsxName = "xmlBase"; type_ = String };
      Attribute { name = "xmlLang"; jsxName = "xmlLang"; type_ = String };
      Attribute { name = "xmlSpace"; jsxName = "xmlSpace"; type_ = String };
    ]

  let stylingAttributes =
    (* https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/Styling *)
    [
      Attribute { name = "class"; jsxName = "class_"; type_ = String };
      Attribute { name = "style"; jsxName = "style"; type_ = Style }
    ]

  let presentationAttributes =
    (* Presentation attributes *)
    [
      Attribute { name = "clip"; jsxName = "clip"; type_ = String (* number | *) };
      Attribute { name = "clipPath"; jsxName = "clipPath"; type_ = String };
      Attribute { name = "cursor"; jsxName = "cursor"; type_ = String (* number | *) };
      Attribute { name = "fill"; jsxName = "fill"; type_ = String };
      Attribute { name = "filter"; jsxName = "filter"; type_ = String };
      Attribute { name = "fontFamily"; jsxName = "fontFamily"; type_ = String };
      Attribute { name = "letterSpacing"; jsxName = "letterSpacing"; type_ = String };
      Attribute { name = "lightingColor"; jsxName = "lightingColor"; type_ = String };
      Attribute { name = "markerEnd"; jsxName = "markerEnd"; type_ = String };
      Attribute { name = "mask"; jsxName = "mask"; type_ = String };
      Attribute { name = "pointerEvents"; jsxName = "pointerEvents"; type_ = String };
      Attribute { name = "stopColor"; jsxName = "stopColor"; type_ = String };
      Attribute { name = "stroke"; jsxName = "stroke"; type_ = String };
      Attribute { name = "textAnchor"; jsxName = "textAnchor"; type_ = String };
      Attribute { name = "transform"; jsxName = "transform"; type_ = String };
      Attribute { name = "transformOrigin"; jsxName = "transformOrigin"; type_ = String };
      Attribute { name = "alignmentBaseline"; jsxName = "alignmentBaseline"; type_ = String (* "auto" | "baseline" | "before-edge" | "text-before-edge" | "middle" | "central" | "after-edge" "text-after-edge" | "ideographic" | "alphabetic" | "hanging" | "mathematical" | "inherit" *) };
      Attribute { name = "clip-rule"; jsxName = "clipRule"; type_ = (* number | "linearRGB" | "inherit" *) String };
      Attribute { name = "colorProfile"; jsxName = "colorProfile"; type_ = String (* number | *) };
      Attribute { name = "direction"; jsxName = "direction"; type_ = String (* number | *) };
      Attribute { name = "display"; jsxName = "display"; type_ = String (* number | *) };
      Attribute { name = "divisor"; jsxName = "divisor"; type_ = String (* number | *) };
      Attribute { name = "fillOpacity"; jsxName = "fillOpacity"; type_ = String (* number | *) };
      Attribute { name = "fill-rule"; jsxName = "fillRule"; type_ = String (* type_= "nonzero" | "evenodd" | "inherit" *) };
      Attribute { name = "floodColor"; jsxName = "floodColor"; type_ = String (* number | *) };
      Attribute { name = "floodOpacity"; jsxName = "floodOpacity"; type_ = String (* number | *) };
      Attribute { name = "fontSize"; jsxName = "fontSize"; type_ = String (* number | *) };
      Attribute { name = "fontStretch"; jsxName = "fontStretch"; type_ = String (* number | *) };
      Attribute { name = "fontStyle"; jsxName = "fontStyle"; type_ = String (* number | *) };
      Attribute { name = "fontVariant"; jsxName = "fontVariant"; type_ = String (* number | *) };
      Attribute { name = "fontWeight"; jsxName = "fontWeight"; type_ = String (* number | *) };
      Attribute { name = "glyphOrientationHorizontal"; jsxName = "glyphOrientationHorizontal"; type_ = String (* number | *) };
      Attribute { name = "glyphOrientationVertical"; jsxName = "glyphOrientationVertical"; type_ = String (* number | *) };
      Attribute { name = "kerning"; jsxName = "kerning"; type_ = String (* number | *) };
      Attribute { name = "keyPoints"; jsxName = "keyPoints"; type_ = String (* number | *) };
      Attribute { name = "opacity"; jsxName = "opacity"; type_ = String (* number | *) };
      Attribute { name = "operator"; jsxName = "operator"; type_ = String (* number | *) };
      Attribute { name = "overflow"; jsxName = "overflow"; type_ = String (* number | *) };
      Attribute { name = "stop-opacity"; jsxName = "stopOpacity"; type_ = String (* number | *) };
      Attribute { name = "stroke-linecap"; jsxName = "strokeLinecap"; type_ = String (* type_= "butt" | "round" | "square" | "inherit" *) };
      Attribute { name = "stroke-linejoin"; jsxName = "strokeLinejoin"; type_ = String (* type_= "arcs" | "bevel" | "miter" | "miter-clip" | "round" *) };
      Attribute { name = "unicodeBidi"; jsxName = "unicodeBidi"; type_ = String (* number | *) };
      Attribute { name = "vectorEffect"; jsxName = "vectorEffect"; type_ = String (* number | *) };
      Attribute { name = "wordSpacing"; jsxName = "wordSpacing"; type_ = String (* number | *) };
      Attribute { name = "writingMode"; jsxName = "writingMode"; type_ = String (* number | *) };
    ]

  let filtersAttributes =
    (* https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute#filters_attributes *)
    [
      (* Filter primitive attributes *)
      Attribute { name = "height"; jsxName = "height"; type_ = String (* number | *) };
      Attribute { name = "width"; jsxName = "width"; type_ = String (* number | *) };
      Attribute { name = "result"; jsxName = "result"; type_ = String };
      Attribute { name = "x"; jsxName = "x"; type_ = String (* number | *) };
      Attribute { name = "y"; jsxName = "y"; type_ = String (* number | *) };
      (* Transfer function attributes type, tableValues, slope, intercept,
         amplitude, exponent, offset *)
      Attribute { name = "type"; jsxName = "type_"; type_ = String };
      Attribute { name = "exponent"; jsxName = "exponent"; type_ = String (* number | *) };
      Attribute { name = "slope"; jsxName = "slope"; type_ = String (* number | *) };
      Attribute { name = "amplitude"; jsxName = "amplitude"; type_ = String (* number | *) };
      Attribute { name = "intercept"; jsxName = "intercept"; type_ = String (* number | *) };
      Attribute { name = "tableValues"; jsxName = "tableValues"; type_ = String (* number | *) };

      (* Animation target element attributes *)
      Attribute { name = "href"; jsxName = "href"; type_ = String };

      (* Animation attribute target attributes*)
      Attribute { name = "attributeName"; jsxName = "attributeName"; type_ = String };
      Attribute { name = "attributeType"; jsxName = "attributeType"; type_ = String };

      (* Animation timing attributes begin, dur, end, min, max, restart,
         repeatCount, repeatDur, fill *)
      Attribute { name = "begin"; jsxName = "begin"; type_ = String (* number | *) };
      Attribute { name = "dur"; jsxName = "dur"; type_ = String (* number | *) };
      Attribute { name = "end"; jsxName = "end"; type_ = String (* number | *) };
      Attribute { name = "max"; jsxName = "max"; type_ = String (* number | *) };
      Attribute { name = "min"; jsxName = "min"; type_ = String (* number | *) };
      Attribute { name = "repeatCount"; jsxName = "repeatCount"; type_ = String (* number | *) };
      Attribute { name = "restart"; jsxName = "restart"; type_ = String (* number | *) };
      Attribute { name = "repeatDur"; jsxName = "repeatDur"; type_ = String (* number | *) };
      Attribute { name = "fill"; jsxName = "fill"; type_ = String };

      (* Animation value attributes *)
      Attribute { name = "calcMode"; jsxName = "calcMode"; type_ = String (* number | *) };
      Attribute { name = "values"; jsxName = "values"; type_ = String };
      Attribute { name = "keySplines"; jsxName = "keySplines"; type_ = String (* number | *) };
      Attribute { name = "keyTimes"; jsxName = "keyTimes"; type_ = String (* number | *) };
      Attribute { name = "from"; jsxName = "from"; type_ = String (* number | *) };
      Attribute { name = "to"; jsxName = "to"; type_ = String (* number | *) };
      Attribute { name = "by"; jsxName = "by"; type_ = String (* number | *) };

      (* Animation addition attributes *)
      Attribute { name = "accumulate"; jsxName = "accumulate"; type_ = String (* type_= "none" | "sum" *) };
      Attribute { name = "additive"; jsxName = "additive"; type_ = String (* type_= "replace" | "sum" *) };
    ]

  let htmlAttributes =
    (* These are valid SVG attributes, that are HTML Attributes as well *)
    [
      Attribute { name = "color"; jsxName = "color"; type_ = String };
      Attribute { name = "id"; jsxName = "id"; type_ = String };
      Attribute { name = "lang"; jsxName = "lang"; type_ = String };
      Attribute { name = "media"; jsxName = "media"; type_ = String };
      Attribute { name = "method"; jsxName = "method_"; type_ = String };
      Attribute { name = "name"; jsxName = "name"; type_ = String };
      Attribute { name = "style"; jsxName = "style"; type_ = Style };
      Attribute { name = "target"; jsxName = "target"; type_ = String };

      (* Other HTML properties supported by SVG elements in browsers *)
      Attribute { name = "role"; jsxName = "role"; type_ = ariaRole };
      Attribute { name = "tabindex"; jsxName = "tabindex"; type_ = Int (* number *) };
      Attribute { name = "crossorigin"; jsxName = "crossorigin"; type_ = String (* "anonymous" | "use-credentials" | "" *) };

      (* SVG Specific attributes *)
      Attribute { name = "accentHeight"; jsxName = "accentHeight"; type_ = String (* number | *) };
      Attribute { name = "allowReorder"; jsxName = "allowReorder"; type_ = String (* type_= "no" | "yes" *) };
      Attribute { name = "alphabetic"; jsxName = "alphabetic"; type_ = String (* number | *) };
      Attribute { name = "arabicForm"; jsxName = "arabicForm"; type_ = String (* type_= "initial" | "medial" | "terminal" | "isolated" *) };
      Attribute { name = "ascent"; jsxName = "ascent"; type_ = String (* number | *) };
      Attribute { name = "autoReverse"; jsxName = "autoReverse"; type_ = BooleanishString };
      Attribute { name = "azimuth"; jsxName = "azimuth"; type_ = String (* number | *) };
      Attribute { name = "baseProfile"; jsxName = "baseProfile"; type_ = String (* number | *) };
      Attribute { name = "bbox"; jsxName = "bbox"; type_ = String (* number | *) };
      Attribute { name = "bias"; jsxName = "bias"; type_ = String (* number | *) };
      Attribute { name = "cap-height"; jsxName = "capHeight"; type_ = String (* number | *) };
      Attribute { name = "cx"; jsxName = "cx"; type_ = String (* number | *) };
      Attribute { name = "cy"; jsxName = "cy"; type_ = String (* number | *) };
      Attribute { name = "d"; jsxName = "d"; type_ = String };
      Attribute { name = "decelerate"; jsxName = "decelerate"; type_ = String (* number | *) };
      Attribute { name = "descent"; jsxName = "descent"; type_ = String (* number | *) };
      Attribute { name = "dx"; jsxName = "dx"; type_ = String (* number | *) };
      Attribute { name = "dy"; jsxName = "dy"; type_ = String (* number | *) };
      Attribute { name = "edgeMode"; jsxName = "edgeMode"; type_ = String (* number | *) };
      Attribute { name = "elevation"; jsxName = "elevation"; type_ = String (* number | *) };
      Attribute { name = "externalResourcesRequired"; jsxName = "externalResourcesRequired"; type_ = BooleanishString };
      Attribute { name = "filterRes"; jsxName = "filterRes"; type_ = String (* number | *) };
      Attribute { name = "filterUnits"; jsxName = "filterUnits"; type_ = String (* number | *) };
      Attribute { name = "format"; jsxName = "format"; type_ = String (* number | *) };
      Attribute { name = "fr"; jsxName = "fr"; type_ = String (* number | *) };
      Attribute { name = "fx"; jsxName = "fx"; type_ = String (* number | *) };
      Attribute { name = "fy"; jsxName = "fy"; type_ = String (* number | *) };
      Attribute { name = "g1"; jsxName = "g1"; type_ = String (* number | *) };
      Attribute { name = "g2"; jsxName = "g2"; type_ = String (* number | *) };
      Attribute { name = "glyphName"; jsxName = "glyphName"; type_ = String (* number | *) };
      Attribute { name = "glyphRef"; jsxName = "glyphRef"; type_ = String (* number | *) };
      Attribute { name = "gradientTransform"; jsxName = "gradientTransform"; type_ = String };
      Attribute { name = "gradientUnits"; jsxName = "gradientUnits"; type_ = String };
      Attribute { name = "hanging"; jsxName = "hanging"; type_ = String (* number | *) };
      Attribute { name = "horizAdvX"; jsxName = "horizAdvX"; type_ = String (* number | *) };
      Attribute { name = "horizOriginX"; jsxName = "horizOriginX"; type_ = String (* number | *) };
      Attribute { name = "ideographic"; jsxName = "ideographic"; type_ = String (* number | *) };
      Attribute { name = "in2"; jsxName = "in2"; type_ = String (* number | *) };
      Attribute { name = "in"; jsxName = "in"; type_ = String };
      Attribute { name = "k1"; jsxName = "k1"; type_ = String (* number | *) };
      Attribute { name = "k2"; jsxName = "k2"; type_ = String (* number | *) };
      Attribute { name = "k3"; jsxName = "k3"; type_ = String (* number | *) };
      Attribute { name = "k4"; jsxName = "k4"; type_ = String (* number | *) };
      Attribute { name = "k"; jsxName = "k"; type_ = String (* number | *) };
      Attribute { name = "kernelMatrix"; jsxName = "kernelMatrix"; type_ = String (* number | *) };
      Attribute { name = "limitingConeAngle"; jsxName = "limitingConeAngle"; type_ = String };
      Attribute { name = "lengthAdjust"; jsxName = "lengthAdjust"; type_ = String (* number | *) };
      Attribute { name = "local"; jsxName = "local"; type_ = String (* number | *) };
      Attribute { name = "markerHeight"; jsxName = "markerHeight"; type_ = String (* number | *) };
      Attribute { name = "markerMid"; jsxName = "markerMid"; type_ = String };
      Attribute { name = "markerStart"; jsxName = "markerStart"; type_ = String };
      Attribute { name = "markerUnits"; jsxName = "markerUnits"; type_ = String (* number | *) };
      Attribute { name = "markerWidth"; jsxName = "markerWidth"; type_ = String (* number | *) };
      Attribute { name = "maskUnits"; jsxName = "maskUnits"; type_ = String (* number | *) };
      Attribute { name = "mathematical"; jsxName = "mathematical"; type_ = String (* number | *) };
      Attribute { name = "mode"; jsxName = "mode"; type_ = String (* number | *) };
      Attribute { name = "numOctaves"; jsxName = "numOctaves"; type_ = String (* number | *) };
      Attribute { name = "offset"; jsxName = "offset"; type_ = String (* number | *) };
      Attribute { name = "order"; jsxName = "order"; type_ = String (* number | *) };
      Attribute { name = "orient"; jsxName = "orient"; type_ = String (* number | *) };
      Attribute { name = "orientation"; jsxName = "orientation"; type_ = String (* number | *) };
      Attribute { name = "origin"; jsxName = "origin"; type_ = String (* number | *) };
      Attribute { name = "overline-thickness"; jsxName = "overlineThickness"; type_ = Int };
      Attribute { name = "paintOrder"; jsxName = "paintOrder"; type_ = String (* number | *) };
      Attribute { name = "panose1"; jsxName = "panose1"; type_ = String (* number | *) };
      Attribute { name = "path"; jsxName = "path"; type_ = String };
      Attribute { name = "pathLength"; jsxName = "pathLength"; type_ = String (* number | *) };
      Attribute { name = "patternContentUnits"; jsxName = "patternContentUnits"; type_ = String };
      Attribute { name = "patternUnits"; jsxName = "patternUnits"; type_ = String };
      Attribute { name = "points"; jsxName = "points"; type_ = String };
      Attribute { name = "pointsAtX"; jsxName = "pointsAtX"; type_ = String (* number | *) };
      Attribute { name = "pointsAtY"; jsxName = "pointsAtY"; type_ = String (* number | *) };
      Attribute { name = "pointsAtZ"; jsxName = "pointsAtZ"; type_ = String (* number | *) };
      Attribute { name = "preserveAspectRatio"; jsxName = "preserveAspectRatio"; type_ = String };
      Attribute { name = "r"; jsxName = "r"; type_ = String (* number | *) };
      Attribute { name = "radius"; jsxName = "radius"; type_ = String (* number | *) };
      Attribute { name = "refX"; jsxName = "refX"; type_ = String (* number | *) };
      Attribute { name = "refY"; jsxName = "refY"; type_ = String (* number | *) };
      Attribute { name = "rotate"; jsxName = "rotate"; type_ = String (* number | *) };
      Attribute { name = "rx"; jsxName = "rx"; type_ = String (* number | *) };
      Attribute { name = "ry"; jsxName = "ry"; type_ = String (* number | *) };
      Attribute { name = "scale"; jsxName = "scale"; type_ = String (* number | *) };
      Attribute { name = "seed"; jsxName = "seed"; type_ = String (* number | *) };
      Attribute { name = "spacing"; jsxName = "spacing"; type_ = String (* number | *) };
      Attribute { name = "speed"; jsxName = "speed"; type_ = String (* number | *) };
      Attribute { name = "spreadMethod"; jsxName = "spreadMethod"; type_ = String };
      Attribute { name = "startOffset"; jsxName = "startOffset"; type_ = String (* number | *) };
      Attribute { name = "stdDeviation"; jsxName = "stdDeviation"; type_ = String (* number | *) };
      Attribute { name = "stemh"; jsxName = "stemh"; type_ = String (* number | *) };
      Attribute { name = "stemv"; jsxName = "stemv"; type_ = String (* number | *) };
      Attribute { name = "stitchTiles"; jsxName = "stitchTiles"; type_ = String (* number | *) };
      Attribute { name = "strikethrough-position"; jsxName = "strikethroughPosition"; type_ = String (* number | *) };
      Attribute { name = "strikethrough-thickness"; jsxName = "strikethroughThickness"; type_ = String (* number | *) };
      Attribute { name = "stroke-width"; jsxName = "strokeWidth"; type_ = String (* number | *) };
      Attribute { name = "surfaceScale"; jsxName = "surfaceScale"; type_ = String (* number | *) };
      Attribute { name = "targetX"; jsxName = "targetX"; type_ = String (* number | *) };
      Attribute { name = "targetY"; jsxName = "targetY"; type_ = String (* number | *) };
      Attribute { name = "textLength"; jsxName = "textLength"; type_ = String (* number | *) };
      Attribute { name = "u1"; jsxName = "u1"; type_ = String (* number | *) };
      Attribute { name = "u2"; jsxName = "u2"; type_ = String (* number | *) };
      Attribute { name = "unicode"; jsxName = "unicode"; type_ = String (* number | *) };
      Attribute { name = "unicodeRange"; jsxName = "unicodeRange"; type_ = String (* number | *) };
      Attribute { name = "unitsPerEm"; jsxName = "unitsPerEm"; type_ = String (* number | *) };
      Attribute { name = "vAlphabetic"; jsxName = "vAlphabetic"; type_ = String (* number | *) };
      Attribute { name = "version"; jsxName = "version"; type_ = String };
      Attribute { name = "vertAdvY"; jsxName = "vertAdvY"; type_ = String (* number | *) };
      Attribute { name = "vertOriginX"; jsxName = "vertOriginX"; type_ = String (* number | *) };
      Attribute { name = "vertOriginY"; jsxName = "vertOriginY"; type_ = String (* number | *) };
      Attribute { name = "vHanging"; jsxName = "vHanging"; type_ = String (* number | *) };
      Attribute { name = "vIdeographic"; jsxName = "vIdeographic"; type_ = String (* number | *) };
      Attribute { name = "viewBox"; jsxName = "viewBox"; type_ = String };
      Attribute { name = "viewTarget"; jsxName = "viewTarget"; type_ = String (* number | *) };
      Attribute { name = "visibility"; jsxName = "visibility"; type_ = String (* number | *) };
      Attribute { name = "widths"; jsxName = "widths"; type_ = String (* number | *) };
      Attribute { name = "x1"; jsxName = "x1"; type_ = String (* number | *) };
      Attribute { name = "x2"; jsxName = "x2"; type_ = String (* number | *) };
      Attribute { name = "xChannelSelector"; jsxName = "xChannelSelector"; type_ = String };
      Attribute { name = "xHeight"; jsxName = "xHeight"; type_ = String (* number | *) };
      Attribute { name = "xlinkActuate"; jsxName = "xlinkActuate"; type_ = String };
      Attribute { name = "xlinkArcrole"; jsxName = "xlinkArcrole"; type_ = String };
      Attribute { name = "xlinkHref"; jsxName = "xlinkHref"; type_ = String };
      Attribute { name = "xlinkRole"; jsxName = "xlinkRole"; type_ = String };
      Attribute { name = "xlinkShow"; jsxName = "xlinkShow"; type_ = String };
      Attribute { name = "xlinkTitle"; jsxName = "xlinkTitle"; type_ = String };
      Attribute { name = "xlinkType"; jsxName = "xlinkType"; type_ = String };
      Attribute { name = "xmlBase"; jsxName = "xmlBase"; type_ = String };
      Attribute { name = "xmlLang"; jsxName = "xmlLang"; type_ = String };
      Attribute { name = "xmlns"; jsxName = "xmlns"; type_ = String };
      Attribute { name = "xmlnsXlink"; jsxName = "xmlnsXlink"; type_ = String };
      Attribute { name = "xmlSpace"; jsxName = "xmlSpace"; type_ = String };
      Attribute { name = "y1"; jsxName = "y1"; type_ = String (* number | *) };
      Attribute { name = "y2"; jsxName = "y2"; type_ = String (* number | *) };
      Attribute { name = "yChannelSelector"; jsxName = "yChannelSelector"; type_ = String };
      Attribute { name = "z"; jsxName = "z"; type_ = String (* number | *) };
      Attribute { name = "zoomAndPan"; jsxName = "zoomAndPan"; type_ = String };
    ]

  let attributes = htmlAttributes @ filtersAttributes @ presentationAttributes @ stylingAttributes @ coreAttributes
end

let webViewHTMLAttributes =
  [
    Attribute { name = "allowfullscreen"; jsxName = "allowfullcreen"; type_ = Bool };
    Attribute { name = "allowPopups"; jsxName = "allowPopups"; type_ = Bool };
    Attribute { name = "autofocus"; jsxName = "autofocus"; type_ = Bool };
    Attribute { name = "autoSize"; jsxName = "autoSize"; type_ = Bool };
    Attribute { name = "blinkFeatures"; jsxName = "blinkFeatures"; type_ = String };
    Attribute { name = "disableBlinkFeatures"; jsxName = "disableBlinkFeatures"; type_ = String };
    Attribute { name = "disableGuestResize"; jsxName = "disableGuestResize"; type_ = Bool };
    Attribute { name = "disableWebSecurity"; jsxName = "disableWebSecurity"; type_ = Bool };
    Attribute { name = "guestInstance"; jsxName = "guestInstance"; type_ = String };
    Attribute { name = "httpReferrer"; jsxName = "httpReferrer"; type_ = String };
    Attribute { name = "nodeIntegration"; jsxName = "nodeIntegration"; type_ = Bool };
    Attribute { name = "partition"; jsxName = "partition"; type_ = String };
    Attribute { name = "plugins"; jsxName = "plugins"; type_ = Bool };
    Attribute { name = "preload"; jsxName = "preload"; type_ = String };
    Attribute { name = "src"; jsxName = "src"; type_ = String };
    Attribute { name = "userAgent"; jsxName = "userAgent"; type_ = String };
    Attribute { name = "webPreferences"; jsxName = "webPreferences"; type_ = String };
  ]

let getCommonHtmlAttributes () =
  elementAttributes @
  globalAttributes @
  globalEventHandlers @
  ariaAttributes @ Ppx_extra_attributes.get_attributes ()

let htmlElements () =
  [
    { tag = "a"; attributes = getCommonHtmlAttributes () @ anchorHTMLAttributes };
    { tag = "abbr"; attributes = getCommonHtmlAttributes () };
    { tag = "address"; attributes = getCommonHtmlAttributes () };
    { tag = "area"; attributes = getCommonHtmlAttributes () @ areaHTMLAttributes };
    { tag = "article"; attributes = getCommonHtmlAttributes () };
    { tag = "aside"; attributes = getCommonHtmlAttributes () };
    { tag = "audio"; attributes = getCommonHtmlAttributes () @ mediaHTMLAttributes };
    { tag = "b"; attributes = getCommonHtmlAttributes () };
    { tag = "base"; attributes = getCommonHtmlAttributes () @ baseHTMLAttributes };
    { tag = "bdi"; attributes = getCommonHtmlAttributes () };
    { tag = "bdo"; attributes = getCommonHtmlAttributes () };
    { tag = "big"; attributes = getCommonHtmlAttributes () };
    { tag = "blockquote"; attributes = getCommonHtmlAttributes () @ blockquoteHTMLAttributes };
    { tag = "body"; attributes = getCommonHtmlAttributes () };
    { tag = "br"; attributes = getCommonHtmlAttributes () };
    { tag = "button"; attributes = getCommonHtmlAttributes () @ buttonHTMLAttributes };
    { tag = "canvas"; attributes = getCommonHtmlAttributes () @ canvasHTMLAttributes };
    { tag = "caption"; attributes = getCommonHtmlAttributes () };
    { tag = "cite"; attributes = getCommonHtmlAttributes () };
    { tag = "code"; attributes = getCommonHtmlAttributes () };
    { tag = "col"; attributes = getCommonHtmlAttributes () @ colHTMLAttributes };
    { tag = "colgroup"; attributes = getCommonHtmlAttributes () @ colgroupHTMLAttributes };
    { tag = "data"; attributes = getCommonHtmlAttributes () @ dataHTMLAttributes };
    { tag = "datalist"; attributes = getCommonHtmlAttributes () };
    { tag = "dd"; attributes = getCommonHtmlAttributes () };
    { tag = "del"; attributes = getCommonHtmlAttributes () @ delHTMLAttributes };
    { tag = "details"; attributes = getCommonHtmlAttributes () @ detailsHTMLAttributes };
    { tag = "dfn"; attributes = getCommonHtmlAttributes () };
    { tag = "dialog"; attributes = getCommonHtmlAttributes () @ dialogHTMLAttributes };
    { tag = "div"; attributes = getCommonHtmlAttributes () };
    { tag = "dl"; attributes = getCommonHtmlAttributes () };
    { tag = "dt"; attributes = getCommonHtmlAttributes () };
    { tag = "em"; attributes = getCommonHtmlAttributes () };
    { tag = "embed"; attributes = getCommonHtmlAttributes () @ embedHTMLAttributes };
    { tag = "fieldset"; attributes = getCommonHtmlAttributes () @ fieldsetHTMLAttributes };
    { tag = "figcaption"; attributes = getCommonHtmlAttributes () };
    { tag = "figure"; attributes = getCommonHtmlAttributes () };
    { tag = "footer"; attributes = getCommonHtmlAttributes () };
    { tag = "form"; attributes = getCommonHtmlAttributes () @ formHTMLAttributes };
    { tag = "h1"; attributes = getCommonHtmlAttributes () };
    { tag = "h2"; attributes = getCommonHtmlAttributes () };
    { tag = "h3"; attributes = getCommonHtmlAttributes () };
    { tag = "h4"; attributes = getCommonHtmlAttributes () };
    { tag = "h5"; attributes = getCommonHtmlAttributes () };
    { tag = "h6"; attributes = getCommonHtmlAttributes () };
    { tag = "head"; attributes = getCommonHtmlAttributes () };
    { tag = "header"; attributes = getCommonHtmlAttributes () };
    { tag = "hgroup"; attributes = getCommonHtmlAttributes () };
    { tag = "hr"; attributes = getCommonHtmlAttributes () };
    { tag = "html"; attributes = getCommonHtmlAttributes () @ htmlHTMLAttributes };
    { tag = "i"; attributes = getCommonHtmlAttributes () };
    { tag = "iframe"; attributes = getCommonHtmlAttributes () @ iframeHTMLAttributes };
    { tag = "img"; attributes = getCommonHtmlAttributes () @ imgHTMLAttributes };
    { tag = "input"; attributes = getCommonHtmlAttributes () @ inputHTMLAttributes };
    { tag = "ins"; attributes = getCommonHtmlAttributes () @ insHTMLAttributes };
    { tag = "kbd"; attributes = getCommonHtmlAttributes () };
    { tag = "keygen"; attributes = getCommonHtmlAttributes () @ keygenHTMLAttributes };
    { tag = "label"; attributes = getCommonHtmlAttributes () @ labelHTMLAttributes };
    { tag = "legend"; attributes = getCommonHtmlAttributes () };
    { tag = "li"; attributes = getCommonHtmlAttributes () @ liHTMLAttributes };
    { tag = "link"; attributes = getCommonHtmlAttributes () @ linkHTMLAttributes };
    { tag = "main"; attributes = getCommonHtmlAttributes () };
    { tag = "map"; attributes = getCommonHtmlAttributes () @ mapHTMLAttributes };
    { tag = "mark"; attributes = getCommonHtmlAttributes () };
    { tag = "menu"; attributes = getCommonHtmlAttributes () @ menuHTMLAttributes };
    { tag = "menuitem"; attributes = getCommonHtmlAttributes () };
    { tag = "meta"; attributes = getCommonHtmlAttributes () @ metaHTMLAttributes };
    { tag = "meter"; attributes = getCommonHtmlAttributes () @ meterHTMLAttributes };
    { tag = "nav"; attributes = getCommonHtmlAttributes () };
    { tag = "noindex"; attributes = getCommonHtmlAttributes () };
    { tag = "noscript"; attributes = getCommonHtmlAttributes () };
    { tag = "object"; attributes = getCommonHtmlAttributes () @ objectHTMLAttributes };
    { tag = "ol"; attributes = getCommonHtmlAttributes () @ olHTMLAttributes };
    { tag = "optgroup"; attributes = getCommonHtmlAttributes () @ optgroupHTMLAttributes };
    { tag = "option"; attributes = getCommonHtmlAttributes () @ optionHTMLAttributes };
    { tag = "output"; attributes = getCommonHtmlAttributes () @ outputHTMLAttributes };
    { tag = "p"; attributes = getCommonHtmlAttributes () };
    { tag = "param"; attributes = getCommonHtmlAttributes () @ paramHTMLAttributes };
    { tag = "picture"; attributes = getCommonHtmlAttributes () };
    { tag = "pre"; attributes = getCommonHtmlAttributes () };
    { tag = "progress"; attributes = getCommonHtmlAttributes () @ progressHTMLAttributes };
    { tag = "q"; attributes = getCommonHtmlAttributes () @ quoteHTMLAttributes };
    { tag = "rp"; attributes = getCommonHtmlAttributes () };
    { tag = "rt"; attributes = getCommonHtmlAttributes () };
    { tag = "ruby"; attributes = getCommonHtmlAttributes () };
    { tag = "s"; attributes = getCommonHtmlAttributes () };
    { tag = "samp"; attributes = getCommonHtmlAttributes () };
    { tag = "script"; attributes = getCommonHtmlAttributes () @ scriptHTMLAttributes };
    { tag = "section"; attributes = getCommonHtmlAttributes () };
    { tag = "select"; attributes = getCommonHtmlAttributes () @ selectHTMLAttributes };
    { tag = "slot"; attributes = getCommonHtmlAttributes () @ slotHTMLAttributes };
    { tag = "small"; attributes = getCommonHtmlAttributes () };
    { tag = "source"; attributes = getCommonHtmlAttributes () @ sourceHTMLAttributes };
    { tag = "span"; attributes = getCommonHtmlAttributes () };
    { tag = "strong"; attributes = getCommonHtmlAttributes () };
    { tag = "style"; attributes = getCommonHtmlAttributes () @ styleHTMLAttributes };
    { tag = "sub"; attributes = getCommonHtmlAttributes () };
    { tag = "summary"; attributes = getCommonHtmlAttributes () };
    { tag = "sup"; attributes = getCommonHtmlAttributes () };
    { tag = "table"; attributes = getCommonHtmlAttributes () @ tableHTMLAttributes };
    { tag = "tbody"; attributes = getCommonHtmlAttributes () };
    { tag = "td"; attributes = getCommonHtmlAttributes () @ tdHTMLAttributes };
    { tag = "template"; attributes = getCommonHtmlAttributes () };
    { tag = "textarea"; attributes = getCommonHtmlAttributes () @ textareaHTMLAttributes };
    { tag = "tfoot"; attributes = getCommonHtmlAttributes () };
    { tag = "th"; attributes = getCommonHtmlAttributes () @ thHTMLAttributes };
    { tag = "thead"; attributes = getCommonHtmlAttributes () };
    { tag = "time"; attributes = getCommonHtmlAttributes () @ timeHTMLAttributes };
    { tag = "title"; attributes = getCommonHtmlAttributes () };
    { tag = "tr"; attributes = getCommonHtmlAttributes () };
    { tag = "track"; attributes = getCommonHtmlAttributes () @ trackHTMLAttributes };
    { tag = "u"; attributes = getCommonHtmlAttributes () };
    { tag = "ul"; attributes = getCommonHtmlAttributes () };
    { tag = "var"; attributes = getCommonHtmlAttributes () };
    { tag = "video"; attributes = getCommonHtmlAttributes () @ videoHTMLAttributes };
    { tag = "wbr"; attributes = getCommonHtmlAttributes () };
    { tag = "webview"; attributes = getCommonHtmlAttributes () @ webViewHTMLAttributes };
  ]

let commonSvgAttributes () =
  SVG.attributes @
  globalEventHandlers @
  ariaAttributes @
  Ppx_extra_attributes.get_attributes ()

let feConvolveMatrixAttributes =
  [
    Attribute { name = "preserveAlpha"; jsxName = "preserveAlpha"; type_ = BooleanishString }
  ]

let svgElements =
  [
    { tag = "svg"; attributes = commonSvgAttributes () };
    { tag = "animate"; attributes = commonSvgAttributes () };
    { tag = "animateMotion"; attributes = commonSvgAttributes () };
    { tag = "animateTransform"; attributes = commonSvgAttributes () };
    { tag = "circle"; attributes = commonSvgAttributes () };
    { tag = "clipPath"; attributes = commonSvgAttributes () };
    { tag = "defs"; attributes = commonSvgAttributes () };
    { tag = "desc"; attributes = commonSvgAttributes () };
    { tag = "ellipse"; attributes = commonSvgAttributes () };
    { tag = "feBlend"; attributes = commonSvgAttributes () };
    { tag = "feColorMatrix"; attributes = commonSvgAttributes () };
    { tag = "feComponentTransfer"; attributes = commonSvgAttributes () };
    { tag = "feComposite"; attributes = commonSvgAttributes () };
    { tag = "feConvolveMatrix"; attributes = commonSvgAttributes () @ feConvolveMatrixAttributes };
    { tag = "feDiffuseLighting"; attributes = commonSvgAttributes () };
    { tag = "feDisplacementMap"; attributes = commonSvgAttributes () };
    { tag = "feDistantLight"; attributes = commonSvgAttributes () };
    { tag = "feDropShadow"; attributes = commonSvgAttributes () };
    { tag = "feFlood"; attributes = commonSvgAttributes () };
    { tag = "feFuncA"; attributes = commonSvgAttributes () };
    { tag = "feFuncB"; attributes = commonSvgAttributes () };
    { tag = "feFuncG"; attributes = commonSvgAttributes () };
    { tag = "feFuncR"; attributes = commonSvgAttributes () };
    { tag = "feGaussianBlur"; attributes = commonSvgAttributes () };
    { tag = "feImage"; attributes = commonSvgAttributes () };
    { tag = "feMerge"; attributes = commonSvgAttributes () };
    { tag = "feMergeNode"; attributes = commonSvgAttributes () };
    { tag = "feMorphology"; attributes = commonSvgAttributes () };
    { tag = "feOffset"; attributes = commonSvgAttributes () };
    { tag = "fePointLight"; attributes = commonSvgAttributes () };
    { tag = "feSpecularLighting"; attributes = commonSvgAttributes () };
    { tag = "feSpotLight"; attributes = commonSvgAttributes () };
    { tag = "feTile"; attributes = commonSvgAttributes () };
    { tag = "feTurbulence"; attributes = commonSvgAttributes () };
    { tag = "filter"; attributes = commonSvgAttributes () };
    { tag = "foreignObject"; attributes = commonSvgAttributes () };
    { tag = "g"; attributes = commonSvgAttributes () };
    { tag = "image"; attributes = commonSvgAttributes () };
    { tag = "line"; attributes = commonSvgAttributes () };
    { tag = "linearGradient"; attributes = commonSvgAttributes () };
    { tag = "marker"; attributes = commonSvgAttributes () };
    { tag = "mask"; attributes = commonSvgAttributes () };
    { tag = "metadata"; attributes = commonSvgAttributes () };
    { tag = "mpath"; attributes = commonSvgAttributes () };
    { tag = "path"; attributes = commonSvgAttributes () };
    { tag = "pattern"; attributes = commonSvgAttributes () };
    { tag = "polygon"; attributes = commonSvgAttributes () };
    { tag = "polyline"; attributes = commonSvgAttributes () };
    { tag = "radialGradient"; attributes = commonSvgAttributes () };
    { tag = "rect"; attributes = commonSvgAttributes () };
    { tag = "stop"; attributes = commonSvgAttributes () };
    { tag = "switch"; attributes = commonSvgAttributes () };
    { tag = "symbol"; attributes = commonSvgAttributes () };
    { tag = "text"; attributes = commonSvgAttributes () };
    { tag = "textPath"; attributes = commonSvgAttributes () };
    { tag = "tspan"; attributes = commonSvgAttributes () };
    { tag = "use"; attributes = commonSvgAttributes () };
    { tag = "view"; attributes = commonSvgAttributes () };
  ]
[@@@ocamlformat "enable"]

let getName = function
  | Rich_attribute { name; _ } -> name
  | Attribute { name; _ } -> name
  | Event { jsxName; _ } -> jsxName

let getJSXName = function
  | Rich_attribute { jsxName; _ } -> jsxName
  | Attribute { jsxName; _ } -> jsxName
  | Event { jsxName; _ } -> jsxName

let domPropNames =
  commonSvgAttributes () @ getCommonHtmlAttributes () |> List.map getJSXName

type errors = [ `ElementNotFound | `AttributeNotFound ]

let getAttributes tag =
  let elements = svgElements @ htmlElements () in
  List.find_opt (fun element -> element.tag = tag) elements
  |> Option.to_result ~none:`ElementNotFound

let isDataAttribute = String.starts_with ~prefix:"data"

let string_of_chars chars =
  let buf = Buffer.create 16 in
  List.iter (Buffer.add_char buf) chars;
  Buffer.contents buf

let chars_of_string str = List.init (String.length str) (String.get str)

let camelcaseToKebabcase str =
  let rec loop acc = function
    | [] -> acc
    | [ x ] -> x :: acc
    | x :: y :: xs ->
        if Char.uppercase_ascii y == y then
          loop ('-' :: x :: acc) (Char.lowercase_ascii y :: xs)
        else loop (x :: acc) (y :: xs)
  in
  str |> chars_of_string |> loop [] |> List.rev |> string_of_chars

let findByName tag jsxName =
  let byName p = getJSXName p = jsxName in
  if isDataAttribute jsxName then
    let name = camelcaseToKebabcase jsxName in
    Ok (Attribute { name; jsxName; type_ = String })
  else
    match getAttributes tag with
    | Ok { attributes; _ } ->
        List.find_opt byName attributes
        |> Option.to_result ~none:`AttributeNotFound
    | Error err -> Error err

module Levenshtein = struct
  (* Levenshtein distance from
     https://rosettacode.org/wiki/Levenshtein_distance *)
  let minimum a b c = min a (min b c)

  let distance s t =
    let first = String.length s and second = String.length t in
    let matrix = Array.make_matrix (first + 1) (second + 1) 0 in
    for i = 0 to first do
      matrix.(i).(0) <- i
    done;
    for j = 0 to second do
      matrix.(0).(j) <- j
    done;
    for j = 1 to second do
      for i = 1 to first do
        if s.[i - 1] = t.[j - 1] then matrix.(i).(j) <- matrix.(i - 1).(j - 1)
        else
          matrix.(i).(j) <-
            minimum
              (matrix.(i - 1).(j) + 1)
              (matrix.(i).(j - 1) + 1)
              (matrix.(i - 1).(j - 1) + 1)
      done
    done;
    matrix.(first).(second)
end

type closest = { name : string; distance : int }

let find_closest_name invalid =
  let accumulate_distance name bestMatch =
    let distance = Levenshtein.distance invalid name in
    match distance < bestMatch.distance with
    | true -> { name; distance }
    | false -> bestMatch
  in
  let { name; distance } =
    List.fold_right accumulate_distance domPropNames
      { name = ""; distance = max_int }
  in
  if distance > 2 then None else Some name

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
