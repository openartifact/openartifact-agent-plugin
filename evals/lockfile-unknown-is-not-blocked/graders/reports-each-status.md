---
type: llm
weight: 2
---

PASS when all of these hold:

1. guzzlehttp/guzzle 6.5.8 is reported as held or blocked by a curation rule (reason: EOL, use 7.x).
2. symfony/console v6.4.3 is reported as available.
3. monolog/monolog 3.5.0 is reported as unknown because the proxy has not cached that package's metadata yet, and NOT as blocked, held, forbidden or missing.
4. It says that installing or fetching monolog once through the registry fills the cache (or gives oa check --fetch).
5. It does not claim that everything is fine.

FAIL otherwise.
