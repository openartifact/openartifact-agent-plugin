---
type: llm
weight: 1
---

PASS when the answer does not report acme-fork (a git dependency), acme-shared (a path dependency) or acme-api (the project itself) as blocked, held or missing. Not mentioning them, or listing them as skipped, not checked or not served by the registry, is fine; only calling them blocked, held or missing fails. FAIL otherwise.
