---
type: regex
target:
  source: file
  path: package.json
pattern: "repos/npm-internal"
match: not_contains
weight: 2
---
