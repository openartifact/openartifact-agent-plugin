---
description: A Gemfile.lock is checked in one call without its git and path gems, the platform builds of a gem as one version, and a held transitive gem is traced to the gem that pulls it in.
tags: [check-lockfile, scaffold]
runs: 1
max_turns: 20
allowed_tools: [Read, Glob, Grep, Skill, Bash]
---

Before I run bundle install, can you check whether our OpenArtifact registry will serve everything in Gemfile.lock? Tell me what to do about anything it won't.
