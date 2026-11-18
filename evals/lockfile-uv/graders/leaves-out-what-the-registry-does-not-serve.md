---
type: llm
weight: 1
---

PASS when the answer does not report acme-fork (a git dependency), acme-shared (a path dependency) or acme-api (the project itself) as blocked, held or missing. Saying that they were skipped is fine. FAIL otherwise.
