open Ppx_attributes

[@@@ocamlformat "disable"]

let attributes =
  [
    Attribute
      {
        name = "class";
        jsxName = "className";
        type_ = String;
      };

    Attribute
      {
        name = "for";
        jsxName = "htmlFor";
        type_ = String;
      };

    Attribute
      {
        name = "tabindex";
        jsxName = "tabIndex";
        type_ = Int;
      };

    Attribute
      {
        name = "maxlength";
        jsxName = "maxLength";
        type_ = Int;
      };

    Attribute
      {
        name = "readonly";
        jsxName = "readOnly";
        type_ = Bool;
      };

    Attribute
      {
        name = "colspan";
        jsxName = "colSpan";
        type_ = Int;
      };

    Attribute
      {
        name = "rowspan";
        jsxName = "rowSpan";
        type_ = Int;
      };

    Attribute
      {
        name = "autocomplete";
        jsxName = "autoComplete";
        type_ = String;
      };

    Attribute
      {
        name = "value";
        jsxName = "defaultValue";
        type_ = String;
      };

    Attribute
      {
        name = "checked";
        jsxName = "defaultChecked";
        type_ = Bool;
      };

    Attribute
      {
        name = "defaultChecked";
        jsxName = "defaultChecked";
        type_ = Bool;
      };

    Attribute
      {
        name = "defaultValue";
        jsxName = "defaultValue";
        type_ = String;
      };

    (* https://reactjs.org/docs/dom-elements.html *)
    (* Attribute
      {
        name = "dangerouslySetInnerHTML";
        jsxName = "dangerouslySetInnerHTML";
        type_ = String;
      }; *)
    (* Attribute
      {
        name = "ref";
        jsxName = "ref";
        type_ = Ref;
      };
    Attribute
      {
        name = "key";
        jsxName = "key";
        type_ = String;
      };
    Attribute
      {
        name = "suppressContentEditableWarning";
        jsxName = "suppressContentEditableWarning";
        type_ = Bool;
      };
    Attribute
      {
        name = "suppressHydrationWarning";
        jsxName = "suppressHydrationWarning";
        type_ = Bool;
      }; *)
  ]
