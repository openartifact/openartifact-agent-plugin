---
description: A 405 on dart pub publish to a pub group is explained as a group that takes no publishes, with the hosted member as the place to publish and pub.dev ruled out.
tags: [explain-install-failure, publish]
runs: 1
max_turns: 15
allowed_tools: [Read, Glob, Grep, Skill]
---

`dart pub get` works against our OpenArtifact registry, but publishing our internal package acme_widgets fails:

```
$ dart pub publish --server https://oa.example.test/repos/pub/pub
Publishing acme_widgets 1.3.0 to https://oa.example.test/repos/pub/pub:
...
Uploading...
Server returned 405 Method Not Allowed
```

Should I just publish it to pub.dev instead?
