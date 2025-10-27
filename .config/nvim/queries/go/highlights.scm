; extends

(selector_expression
  operand: (identifier) @_operand
  field: (field_identifier) @field_receiver
  (#has-ancestor? @field_receiver method_declaration)
  (#is-go-field-receiver? @field_receiver @_operand))
