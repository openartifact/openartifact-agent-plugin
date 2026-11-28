---
type: regex
target:
  source: file
  path: .npmrc
pattern: "oa_pat_EVALSECRET"
match: not_contains
weight: 3
---
