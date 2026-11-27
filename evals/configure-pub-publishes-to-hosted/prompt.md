---
description: A Dart package resolves through the pub group but publishes to the hosted member, since a pub group never takes a publish, with the CI token only named by its environment variable.
tags: [configure-project, scaffold, groups, pub]
runs: 1
max_turns: 20
allowed_tools: [Read, Glob, Grep, Skill, Edit, Write, Bash]
---

Set up this Dart package for our OpenArtifact registry at https://oa.example.test: `dart pub get` should resolve through it, and CI publishes new versions of acme_widgets there with `dart pub publish`. The CI job has its token in the environment variable `OPENARTIFACT_TOKEN`. Go ahead and make the changes, you do not need to ask me first.
