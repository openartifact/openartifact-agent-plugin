---
description: A 409 on twine upload to a repository with immutable releases is explained as a version that is already published, with a new version as the fix and no offer to delete or overwrite the release.
tags: [explain-install-failure, publish]
runs: 1
max_turns: 15
allowed_tools: [Read, Glob, Grep, Skill]
---

I rebuilt acme-billing 2.1.0 with a fix in the invoice rounding and tried to upload it again to our OpenArtifact repository `pypi-internal`:

```
$ twine upload --repository-url https://oa.example.test/repos/pypi-internal/ dist/*
Uploading acme_billing-2.1.0-py3-none-any.whl
ERROR    HTTPError: 409 Conflict from https://oa.example.test/repos/pypi-internal/
         Conflict
```

How do I get the fixed 2.1.0 up there?
