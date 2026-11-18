---
description: A ship-or-not question about a stored version reports the exploited vulnerability first with its fix, the license that needs a review, and what was checked, without calling it safe or approving anything.
tags: [review-artifact-security]
runs: 1
max_turns: 15
allowed_tools: [Read, Glob, Grep, Skill]
---

We want to ship acme/billing 2.1.0 from our OpenArtifact repository `php-internal` to customers this week. I'm an OpenArtifact admin. Based on what the registry knows, is there anything that should stop us?
