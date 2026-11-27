---
type: llm
weight: 3
---

PASS when all of these hold:

1. Installs go through the group: the registry for installs is `https://oa.example.test/repos/npm/` (in `.npmrc` or `package.json`).
2. Publishing also goes to the group's URL `https://oa.example.test/repos/npm/` (for example `publishConfig.registry` in `package.json`, or the registry `npm publish` uses), not to `https://oa.example.test/repos/npm-internal/`.
3. The answer says that a publish sent to the group is stored in the hosted repository `npm-internal`.
4. The answer says the CI token needs write access on `npm-internal` (the group's own permissions do not matter for it).
5. The token is not written into any file in clear: only a reference to `OPENARTIFACT_TOKEN` (such as `${OPENARTIFACT_TOKEN}`) or a step the user runs.

If file edits were refused, showing the exact edit for the user to make counts as making it. FAIL otherwise.
