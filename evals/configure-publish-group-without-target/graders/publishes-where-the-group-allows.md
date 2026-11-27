---
type: llm
weight: 3
---

PASS when all of these hold:

1. Installs go through the group: the registry for installs is `https://oa.example.test/repos/npm/` (in `.npmrc` or `package.json`).
2. Publishing goes to the hosted repository `https://oa.example.test/repos/npm-internal/` (for example `publishConfig.registry` in `package.json`), not to the group's URL.
3. The answer explains why: the group has no deploy target, so a publish sent to it would be refused (405).
4. The answer does not change the group's settings and does not tell the user to set a deploy target as a step they must do; mentioning that an administrator could set one is fine.
5. The token is not written into any file in clear: only a reference to `OPENARTIFACT_TOKEN` (such as `${OPENARTIFACT_TOKEN}`) or a step the user runs.

If file edits were refused, showing the exact edit for the user to make counts as making it. FAIL otherwise.
