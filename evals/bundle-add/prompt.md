---
description: Adding a gem with bundle add first checks the version against the registry; a minimum-age hold names when it ends and proposes the newest available version, without a way around the registry.
tags: [check-dependency]
runs: 1
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Our Rails app installs gems from our OpenArtifact proxy repository `gems-proxy` (the Gemfile has `source "https://oa.example.test/repos/gems-proxy"`).

I'm about to run `bundle add sidekiq --version 8.1.0`. Anything I should know first?
