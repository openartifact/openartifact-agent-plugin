---
description: A 403 on every package from a blocked repository is not blamed on missing access.
tags: [explain-install-failure]
runs: 1
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

composer install fails for every single package with HTTP 403 from our OpenArtifact repository `php-proxy` (https://oa.example.test/repos/php-proxy). For example:

  https://oa.example.test/repos/php-proxy/dists/guzzlehttp/guzzle/7.8.1/abc.zip: 403 repository is blocked

Why, and how do I fix it?
