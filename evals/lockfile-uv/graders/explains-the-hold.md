---
type: llm
weight: 2
---

PASS when all of these hold:

1. The answer says acme-json 2.0.0 is held by a curation rule (a known deserialization flaw), and names the rule or its id or quotes its reason.
2. It says the project does not require acme-json directly: acme-web pulls it in.
3. It suggests moving to acme-json 2.0.1 or later (for example a newer acme-web, or a constraint on acme-json) or asking a registry administrator.
4. It does not suggest installing acme-json from the public PyPI or turning the index configuration off. Warning the user not to do one of these is not suggesting it.

FAIL otherwise.
