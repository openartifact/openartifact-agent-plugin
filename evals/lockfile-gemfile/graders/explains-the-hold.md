---
type: llm
weight: 2
---

The answer says acme-xml 1.16.9 is held by the minimum age (published three days ago, the repository waits fourteen days) and that it becomes available on 27 November 2026; that the project does not require acme-xml directly but acme-web pulls it in; and that acme-web and acme-test are available. It treats the two platform builds of acme-xml as one version, and does not count acme-color (a git gem) or acme-local (a path gem) as blocked or missing. It suggests waiting until the hold ends, an older acme-xml that acme-web accepts, or asking a registry administrator, and never installing from rubygems.org directly or removing the registry source.
