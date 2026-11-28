---
description: A 403 on npm publish through a group with a deploy target is traced to write access on the hosted member the publish goes to, not on the group, with an administrator granting it as the fix.
tags: [explain-install-failure, publish]
runs: 1
max_turns: 15
allowed_tools: [Read, Glob, Grep, Skill]
---

Our CI publishes @acme/ui-kit to our OpenArtifact group `npm` (`publishConfig.registry` is `https://oa.example.test/repos/npm/`, the same URL we install from). The admin made the CI token with write permission on the `npm` repository, but the release job fails:

```
npm notice Publishing to https://oa.example.test/repos/npm/ with tag latest and default access
npm error code E403
npm error 403 403 Forbidden - PUT https://oa.example.test/repos/npm/@acme%2fui-kit - write access denied
```

Installs with the same token work. Why does publishing fail?
