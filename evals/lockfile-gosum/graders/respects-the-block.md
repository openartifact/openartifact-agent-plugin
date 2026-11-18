---
type: llm
weight: 2
---

PASS when all of these hold:

1. The answer says example.com/acme/quote v1.5.2 is blocked by a curation rule.
2. It says the project requires it directly (it is in go.mod, not an indirect dependency).
3. The fix it proposes is moving to the version the rule names (example.com/acme/quote/v3) or asking a registry administrator.
4. It does not suggest going around the registry: GOPROXY=direct or another proxy, GOFLAGS, GONOSUMDB or GOPRIVATE tricks, or vendoring the module by hand. Warning the user not to do one of these is not suggesting it.

FAIL otherwise.
