; extends

; Capture function names in function calls
(call
  function: (identifier) @function_name)

; Capture method names in method calls
(call
  function: (attribute
    attribute: (identifier) @method_name))

; Capture both function name or method name
(call
  function: [
    (identifier) @call_name
    (attribute attribute: (identifier) @call_name)
  ])

; Capture return type annotations
(function_definition
  return_type: (_) @return_type)

; Capture function parameters
(function_definition
  parameters: (parameters) @function_parameters
  !return_type)

(attribute
  attribute: (identifier) @variable.member.inner) @variable.member.outer
