---
description: A version that used to install and is now missing is traced in the repository's activity to who moved it to the trash and when, with a restore by an administrator or an available version as the fix.
tags: [explain-install-failure]
runs: 1
max_turns: 15
allowed_tools: [Read, Glob, Grep, Skill]
---

Our PHP project installs from our OpenArtifact hosted repository `php-internal` (composer.json has the repository `https://oa.example.test/repos/php-internal`). It installed fine last week, and now `composer install` fails:

```
Your requirements could not be resolved to an installable set of packages.

  Problem 1
    - Root composer.json requires acme/billing 1.9.0, found acme/billing[2.0.3, 2.1.0] but it does not match the constraint.
```

Nobody changed composer.json. What happened, and what should I do?
