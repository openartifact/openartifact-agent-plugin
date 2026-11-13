---
type: llm
weight: 2
---

The answer explains that the registry cannot tell yet because its proxy has not fetched (cached) these packages, that this is not a block or a failure, and gives a concrete way to warm it: `oa check ... --fetch`, or running `composer install` once through the registry. It does NOT claim the packages are blocked, held, forbidden or missing, and does not tell the user to bypass the registry.
