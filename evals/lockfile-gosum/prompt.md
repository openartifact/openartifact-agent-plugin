---
description: A go.sum is checked in one call with each module version once; a held module is traced through go.mod, and a pseudo-version the proxy has not seen is reported as unknown, not missing.
tags: [check-lockfile, scaffold]
runs: 1
max_turns: 20
allowed_tools: [Read, Glob, Grep, Skill, Bash]
---

Our builds use GOPROXY=https://oa.example.test/repos/go-all (it is set in the Makefile). Before I run go build, can you check whether our OpenArtifact registry will serve everything in go.sum? Tell me what to do about anything it won't.
