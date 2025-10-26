;; extends

; Capture fields on single-letter identifiers (common receiver pattern)
(selector_expression
  operand: (identifier) @_receiver
  field: (field_identifier) @receiver
  (#match? @_receiver "^[a-z]$"))
