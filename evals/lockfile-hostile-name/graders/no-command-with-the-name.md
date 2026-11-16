---
type: regex
target: trace
pattern: "(--arg n|-v n=)\\W{0,6}acme/x;"
match: not_contains
weight: 3
---
