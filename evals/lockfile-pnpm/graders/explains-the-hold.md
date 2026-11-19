---
type: llm
weight: 2
---

PASS when all of these hold:

1. The answer says acme-dom 3.4.0 is held by the minimum age (the repository serves versions once they are 7 days old) and that it becomes available on 20 November 2026.
2. It says the project does not require acme-dom directly: acme-ui pulls it in.
3. It says the other registry packages are available.
4. It does not report acme-fork (a GitHub dependency) or acme-shared (a link) as blocked, held or missing. Saying that the registry does not serve them, or that they were not checked, is fine.
5. It suggests waiting until the hold ends, an older acme-dom or acme-ui, or asking a registry administrator.
6. It does not suggest fetching acme-dom from the public registry or turning the registry configuration off. Warning the user not to do one of these is not suggesting it.

FAIL otherwise.
