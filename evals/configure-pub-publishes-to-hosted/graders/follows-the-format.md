---
type: llm
weight: 3
---

PASS when all of these hold:

1. Resolving goes through the group `https://oa.example.test/repos/pub/pub`, for example `PUB_HOSTED_URL` set to it (in CI or the user's environment).
2. Publishing goes to the hosted repository `https://oa.example.test/repos/pub/pub-internal` (`publish_to` in `pubspec.yaml`, or `dart pub publish --server` with that URL), not to the group's URL.
3. The answer explains why: a pub group does not take publishes (it would answer 405), so publishes go to the hosted repository.
4. The CI token is supplied without writing it down: `dart pub token add` with `--env-var OPENARTIFACT_TOKEN` (for the URLs CI uses) or an equivalent step that only names the variable.

If file edits were refused, showing the exact edit for the user to make counts as making it. FAIL otherwise.
