<!--
SPDX-FileCopyrightText: The OpenArtifact Authors

SPDX-License-Identifier: AGPL-3.0-or-later
-->

# OpenArtifact agent plugin

Use your [OpenArtifact](https://github.com/openartifact/openartifact) registry from a coding agent. The plugin connects the agent to OpenArtifact's MCP server and teaches it five things:

| Skill | What the agent does |
|---|---|
| `configure-project` | Points Composer, npm, pip, Go, Cargo and other package managers at your OpenArtifact repository, from the server's own setup snippets, without writing a token into the project |
| `check-dependency` | Before adding or upgrading a dependency, checks that the registry will serve that version (curation rules, minimum age, quarantine, license policy) and picks one it will |
| `check-lockfile` | Checks every dependency of a `composer.lock` or `package-lock.json` against the registry in one call, also through a group, and reports what is held, missing or not yet known (needs a server with the `check_dependencies` tool; older servers get a check of the direct dependencies) |
| `find-artifact` | Finds packages, files and images across the repositories you can read: by name, by project, by your role in a project ("shared with me") or by property (`prop:status=approved`), and gives the version list and download URL |
| `explain-install-failure` | Turns a 403 or 404 from the registry into the reason (with the rule, or when the version unlocks) and a fix that respects it |

The plugin is read-only: it only calls OpenArtifact's read tools, and the agent is told never to work around the registry (no public-registry fallback, no disabled config).

## Requirements

- An OpenArtifact server with MCP enabled (`MCP_ENABLED=true`, and `BASE_URL` set to the address clients reach). See [MCP server](https://github.com/openartifact/openartifact/blob/main/docs/integrations/mcp.md).
- An API token. A [read-only token](https://github.com/openartifact/openartifact/blob/main/docs/integrations/mcp.md#read-only-token) is enough and recommended.

## Claude Code

```sh
claude plugin marketplace add openartifact/openartifact-agent-plugin
claude plugin install openartifact@openartifact
```

Claude Code asks for the server URL and the token when the plugin is enabled; the token is kept in secure storage. To change them later, run `/plugin configure openartifact@openartifact` inside Claude Code.

## Cursor

The plugin also carries a Cursor manifest (`.cursor-plugin/plugin.json`, `mcp.json`). Cursor takes the server URL (`OA_URL`) and the token (`API_TOKEN`) as plugin variables, which a team administrator sets in the Cursor dashboard under **Plugins → Configure**.

## Development

Install from a local checkout and set the options (`claude plugin configure` only works on an installed plugin, so `--plugin-dir` alone cannot supply them):

```sh
claude plugin marketplace add .
claude plugin install openartifact@openartifact
claude mcp list            # after the options are set: plugin:openartifact:openartifact ... ✔ Connected
```

Set the options with `/plugin configure openartifact@openartifact` inside Claude Code: it prompts for them and keeps the token in secure storage. `claude plugin configure openartifact@openartifact` on its own only lists them.

For automation, pipe the options in from variables your secret store fills, so the token never appears on a command line or in shell history:

```sh
jq -n --arg url "$OA_URL" --arg token "$OA_TOKEN" '{server_url: $url, api_token: $token}' \
  | claude plugin configure openartifact@openartifact --values-stdin
```

Check the manifests with `python3 scripts/check-plugin.py` (what CI runs, with REUSE and workflow lint) and `claude plugin validate .`. To keep a test away from your own Claude Code setup, run these with `CLAUDE_CONFIG_DIR` pointing to an empty directory.

## Privacy

The plugin sends requests only to the OpenArtifact server you configure, with the token you give it. It has no server of its own, collects nothing and sends nothing anywhere else. What your OpenArtifact server logs is governed by whoever runs it.

## License

AGPL-3.0-or-later, the license of OpenArtifact. See [LICENSES](LICENSES/).
