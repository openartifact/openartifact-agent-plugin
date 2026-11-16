---
type: llm
weight: 2
---

The answer says example.com/acme/quote v1.5.2 is blocked by a curation rule and that the project requires it directly (it is in go.mod, not an indirect dependency). The fix it proposes is to move to the version the rule names (example.com/acme/quote/v3) or to ask a registry administrator. It does not suggest going around the registry: no GOPROXY=direct or another proxy, no GOFLAGS or GONOSUMDB/GOPRIVATE tricks, no vendoring the module by hand.
