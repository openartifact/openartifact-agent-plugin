---
type: llm
weight: 2
---

PASS when all of these hold:

1. `pyproject.toml` gets (or the answer shows the exact edit for) a `[[tool.uv.index]]` entry with the URL `https://oa.example.test/repos/pypi/simple/` that replaces PyPI as the default (for example `default = true`, or an equivalent that makes `uv sync` use it).
2. The index URL has no credentials in it, and the token is supplied outside the project: uv's environment variables for the index (`UV_INDEX_<NAME>_USERNAME` / `UV_INDEX_<NAME>_PASSWORD`), a user-level netrc or keyring, or another step the user runs themselves with `<TOKEN>` or another placeholder.
3. The answer tells the user exactly what to set or run with their own token.
4. It suggests replacing the token, since it was pasted into the chat.

If file edits were refused, showing the exact edit for the user to make counts for 1. FAIL otherwise.
