---
description: With merge_proxy_versions on, a version only the public proxy has is installable through the group, and the answer says it comes from the public registry, not from the team's own acme-auth.
tags: [check-dependency, security]
runs: 1
max_turns: 15
allowed_tools: [Read, Glob, Grep, Skill]
---

Our Node project installs from our OpenArtifact repository `npm` (the `.npmrc` has `registry=https://oa.example.test/repos/npm/`). We use `acme-auth` 1.4.2, and I just saw that `acme-auth` 2.0.0 is out on npmjs.com.

Can I upgrade to `acme-auth@2.0.0`?
