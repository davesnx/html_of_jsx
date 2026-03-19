
# Module `Ppx`

```
module List = Stdlib.ListLabels
```
```
val issues_url : string
```
```
val disable_static_optimization : bool Stdlib.ref
```
```
val pexp_list : 
  loc:Ppxlib.location ->
  Ppxlib_ast.Ast.expression list ->
  Ppxlib_ast.Ast.expression
```
```
exception Error of Ppxlib.expression
```
```
val raise_errorf : 
  loc:Ppxlib__.Location.t ->
  ('a, unit, string, 'b) Stdlib.format4 ->
  'a
```
```
val unwrap_children : 
  f:(Ppxlib.expression -> 'a) ->
  'a list ->
  Ppxlib.expression ->
  'a list
```
```
val is_jsx : Ppxlib.attribute -> bool
```
```
val has_jsx_attr : Ppxlib.attribute list -> bool
```
```
val rewrite_component : 
  loc:Ppxlib__.Location.t ->
  Ppxlib__.Import.longident Ppxlib__.Import.loc ->
  (Ppxlib__.Import.arg_label * Ppxlib__.Import.expression) list ->
  Ppxlib_ast.Ast.expression list option ->
  Ppxlib__.Import.expression
```
```
val validate_attr : 
  loc:Ppxlib__.Location.t ->
  string ->
  string ->
  Ppx__.Html_attributes.prop
```
```
val build_polyvariant_type : 
  loc:Ppxlib.location ->
  Ppx__.Html_attributes.polyvariant list ->
  Ppxlib__.Import.core_type
```
```
val add_attribute_type_constraint : 
  loc:Ppxlib.location ->
  is_optional:bool ->
  Ppx__.Html_attributes.kind ->
  Ppxlib_ast.Ast.expression ->
  Ppxlib_ast.Ast.expression
```
```
val polyvariant_to_string_match : 
  loc:Ppxlib.location ->
  Ppx__.Html_attributes.polyvariant list ->
  Ppxlib__.Import.expression ->
  Ppxlib__.Import.expression
```
```
val make_attribute : 
  loc:Ppxlib.location ->
  is_optional:bool ->
  prop:Ppx__.Html_attributes.prop ->
  Ppxlib_ast.Ast.expression ->
  Ppxlib_ast.Ast.expression ->
  Ppxlib_ast.Ast.expression
```
```
val is_optional : Ppxlib.arg_label -> bool
```
```
val transform_labelled : 
  loc:'a ->
  tag_name:string ->
  Ppxlib.expression ->
  (Ppxlib.arg_label * Ppxlib_ast.Ast.expression) ->
  Ppxlib.expression
```
```
val transform_attributes : 
  loc:Ppxlib.location ->
  tag_name:string ->
  (Ppxlib.arg_label * Ppxlib_ast.Ast.expression) list ->
  Ppxlib_ast.Ast.expression
```
```
val default_buffer_size : int
```
```
val generate_dynamic_stringf_code :
  loc:Ppxlib.location ->
  buf_ident:Ppxlib_ast.Ast.expression ->
  Ppxlib_ast.Ast.expression ->
  (Ppxlib__.Import.arg_label * Ppxlib__.Import.expression) list ->
  Ppxlib__.Import.expression
```
```
val generate_buffer_code : 
  loc:Ppxlib__.Location.t ->
  parts:Ppx__.Static_analysis.static_part list ->
  static_size:int ->
  dynamic_count:int ->
  Ppxlib_ast.Ast.expression
```
```
val generate_dynamic_attrs_code : 
  loc:Ppxlib__.Location.t ->
  Ppx__.Static_analysis.element_analysis ->
  Ppxlib_ast.Ast.expression
```
```
val generate_optional_attrs_code : 
  loc:Ppxlib__.Location.t ->
  Ppx__.Static_analysis.element_analysis ->
  Ppxlib_ast.Ast.expression
```
```
val rewrite_node_unoptimized : 
  loc:Ppxlib__.Location.t ->
  string ->
  (Ppxlib.arg_label * Ppxlib_ast.Ast.expression) list ->
  Ppxlib_ast.Ast.expression list option ->
  Ppxlib_ast.Ast.expression
```
```
val rewrite_node_optimized : 
  loc:Ppxlib__.Location.t ->
  string ->
  (Ppxlib.arg_label * Ppxlib_ast.Ast.expression) list ->
  Ppxlib_ast.Ast.expression list option ->
  Ppxlib_ast.Ast.expression
```
```
val rewrite_node : 
  loc:Ppxlib__.Location.t ->
  string ->
  (Ppxlib.arg_label * Ppxlib_ast.Ast.expression) list ->
  Ppxlib_ast.Ast.expression list option ->
  Ppxlib_ast.Ast.expression
```
```
val split_args : 
  mapper:(Ppxlib_ast.Ast.expression -> 'a) ->
  (Ppxlib.arg_label * Ppxlib.expression) list ->
  'a list option * (Ppxlib.arg_label * 'a) list
```
```
val reverse_pexp_list : 
  loc:Ppxlib.location ->
  Ppxlib_ast.Ast.expression ->
  Ppxlib_ast.Ast.expression
```
```
val list_have_tail : Ppxlib.expression_desc -> bool
```
```
val transform_items_of_list : 
  loc:Ppxlib.location ->
  mapper:
    < expression : Ppxlib_ast.Ast.expression -> Ppxlib_ast.Ast.expression.. > ->
  Ppxlib_ast.Ast.expression ->
  Ppxlib_ast.Ast.expression
```
```
val extract_children_from_list : Ppxlib.expression -> Ppxlib.expression list
```
```
val optimize_fragment : 
  loc:Ppxlib.location ->
  mapper:
    < expression : Ppxlib_ast.Ast.expression -> Ppxlib_ast.Ast.expression.. > ->
  Ppxlib.expression ->
  Ppxlib_ast.Ast.expression
```
```
val rewrite_jsx : Ppxlib.Ast_traverse.map
```