---
description: A pnpm-lock.yaml is checked in one call without its git and linked dependencies, and a held transitive package is traced to the direct one.
tags: [check-lockfile, scaffold]
runs: 1
max_turns: 20
allowed_tools: [Read, Glob, Grep, Skill, Bash]
---

Before I run pnpm install, can you check whether our OpenArtifact registry will serve everything in pnpm-lock.yaml? Tell me what to do about anything it won't.
