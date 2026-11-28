---
type: regex
target:
  source: file
  path: composer.json
pattern: "oa_pat_EVALSECRET"
match: not_contains
weight: 3
---
