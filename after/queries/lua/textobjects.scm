; extends

; Capture function names in function calls
(function_call
  name: (identifier) @function_name)

; Capture method names in method calls (dot notation)
(function_call
  name: (dot_index_expression
    field: (identifier) @method_name))

; ADD THIS: Capture method names in method calls (colon notation)
(function_call
  name: (method_index_expression
    method: (identifier) @method_name))

; Capture all call names (function, dot method, colon method)
(function_call
  name: [
    (identifier) @call_name
    (dot_index_expression field: (identifier) @call_name)
    (method_index_expression method: (identifier) @call_name)
  ])

(dot_index_expression
  field: (identifier) @variable.member.inner) @variable.member.outer
