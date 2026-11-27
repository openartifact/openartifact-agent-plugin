---
description: With a group that has no deploy target, the package installs from the group but publishes to the hosted member, because a publish to the group would be refused with 405.
tags: [configure-project, scaffold, groups]
runs: 1
max_turns: 20
allowed_tools: [Read, Glob, Grep, Skill, Edit, Write, Bash]
---

Set up this package for our OpenArtifact registry at https://oa.example.test: `npm ci` should install through it, and CI publishes new versions of @acme/ui-kit there with `npm run release`. The CI job has its token in `OPENARTIFACT_TOKEN`. Go ahead and make the changes, you do not need to ask me first.
