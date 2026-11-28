---
type: llm
weight: 3
---

PASS when all of these hold:

1. It explains that `pub` is a group, and that a pub group does not take publishes (it has no deploy target and cannot have one), which is why the server answers 405.
2. It tells the user to publish to the hosted repository `pub-internal` (`dart pub publish --server https://oa.example.test/repos/pub/pub-internal`, or `publish_to` with that URL), and that installs can keep going through the group.
3. It advises against pub.dev: publishing there would make the team's internal package public.

FAIL otherwise.
