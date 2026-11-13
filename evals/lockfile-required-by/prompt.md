---
description: A held package the project does not require itself is traced to the direct dependency that pulls it in.
tags: [check-lockfile, scaffold]
runs: 1
max_turns: 20
allowed_tools: [Read, Glob, Grep, Skill, Bash]
---

Check this project's composer.lock against our OpenArtifact registry before I run composer install. If something is blocked, tell me what I should change.
