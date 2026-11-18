---
type: llm
weight: 2
---

PASS when all of these hold:

1. The answer explains that the registry cannot tell yet because its proxy has not fetched (cached) these packages, and that this is not a block or a failure.
2. It gives a concrete way to warm it: oa check ... --fetch, or running composer install once through the registry.
3. It does not claim the packages are blocked, held, forbidden or missing.
4. It does not tell the user to bypass the registry. Warning the user not to do one of these is not suggesting it.

FAIL otherwise.
