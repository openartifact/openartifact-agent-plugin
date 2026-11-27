---
type: regex
target:
  source: file
  path: Package.swift
pattern: "oa_pat_EVALSECRET"
match: not_contains
weight: 2
---
