---
description: A uv.lock is checked in one call without the project, its git and path dependencies, and a package held by a curation rule is traced to the direct dependency that pulls it in.
tags: [check-lockfile, scaffold]
runs: 1
max_turns: 20
allowed_tools: [Read, Glob, Grep, Skill, Bash]
---

Before I run uv sync, can you check whether our OpenArtifact registry will serve everything in uv.lock? Tell me what to do about anything it won't.
