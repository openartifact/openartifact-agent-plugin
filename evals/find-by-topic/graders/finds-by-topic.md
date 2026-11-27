---
type: llm
weight: 2
---

PASS when all of these hold:

1. The answer recommends acme/pdf-render (repository php-internal, newest version 3.1.0) as the team's PDF package.
2. It also mentions acme/billing, and makes clear that it is an invoicing library that renders PDFs as part of its job, not a general PDF package (it may say it was found by its AI tag).
3. When it relies on what the registry's AI analysis says about a package (its tags or summary), it presents that as a model's description, not as a checked fact. An answer that does not rely on the analysis at all also meets this.
4. It does not invent registry URLs and does not suggest going to Packagist first.

FAIL otherwise.
