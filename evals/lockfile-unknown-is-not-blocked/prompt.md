---
description: A whole lockfile is checked in one call; unknown is reported as not cached, not as blocked.
tags: [smoke, check-lockfile]
runs: 1
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Our project installs from the OpenArtifact group repository `php` (`https://oa.example.test/repos/php`). These are the versions our composer.lock pins:

- guzzlehttp/guzzle 6.5.8
- monolog/monolog 3.5.0
- symfony/console v6.4.3

Before I run composer install: will the registry serve all of them?
