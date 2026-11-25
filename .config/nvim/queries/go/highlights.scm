; extends

(selector_expression
  operand: (identifier) @_operand
  field: (field_identifier) @field_receiver
  (#has-ancestor? @field_receiver method_declaration)
  (#is-go-field-receiver? @field_receiver @_operand))

; Imports: see lua/go_imports.lua.
((import_spec
  name: (blank_identifier)) @import.blank
  (#set! priority 110))

((import_spec
  name: (dot)) @import.dot
  (#set! priority 110))

((import_spec
  !name
  path: (_) @module)
  (#go-import-fallback? @module)
  (#go-import-name! @module)
  (#set! priority 110))
