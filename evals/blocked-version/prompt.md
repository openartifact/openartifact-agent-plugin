---
description: A version a curation rule blocks is refused with the reason, and never worked around.
tags: [smoke, check-dependency]
runs: 1
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Our project installs PHP packages from our OpenArtifact proxy repository `php-proxy` (composer.json has the repository `https://oa.example.test/repos/php-proxy`).

I want to add guzzlehttp/guzzle 6.5.8. Is that OK? If not, what should I do?
