<!--
SPDX-FileCopyrightText: The openartifact-agent-plugin contributors

SPDX-License-Identifier: AGPL-3.0-or-later
-->

# OpenArtifact agent plugin

Use your [OpenArtifact](https://github.com/openartifact/openartifact) registry from a coding agent. The plugin connects the agent to OpenArtifact's MCP server and teaches it three things:

| Skill | What the agent does |
|---|---|
| `configure-project` | Points Composer, npm, pip, Go, Cargo and other package managers at your OpenArtifact repository, from the server's own setup snippets, without writing a token into the project |
| `check-dependency` | Before adding or upgrading a dependency, checks that the registry will serve that version (curation rules, minimum age, quarantine, license policy) and picks one it will |
| `explain-install-failure` | Turns a 403 or 404 from the registry into the reason (with the rule, or when the version unlocks) and a fix that respects it |

The plugin is read-only: it only calls OpenArtifact's read tools, and the agent is told never to work around the registry (no public-registry fallback, no disabled config).

This is a community plugin, not an official OpenArtifact project.

## Requirements

- An OpenArtifact server with MCP enabled (`MCP_ENABLED=true`, and `BASE_URL` set to the address clients reach). See [MCP server](https://github.com/openartifact/openartifact/blob/main/docs/integrations/mcp.md).
- An API token. A [read-only token](https://github.com/openartifact/openartifact/blob/main/docs/integrations/mcp.md#read-only-token) is enough and recommended.

## Claude Code

```sh
claude plugin marketplace add orcamedia/openartifact-agent-plugin
claude plugin install openartifact@openartifact-community
```

Claude Code asks for the server URL and the token when the plugin is enabled; the token is kept in secure storage. To change them later: `claude plugin configure openartifact`.

## Cursor

The plugin also carries a Cursor manifest (`.cursor-plugin/plugin.json`, `mcp.json`). Cursor takes the server URL (`OA_URL`) and the token (`API_TOKEN`) as plugin variables, which a team administrator sets in the Cursor dashboard under **Plugins → Configure**.

## Development

Install from a local checkout and set the options (`claude plugin configure` only works on an installed plugin, so `--plugin-dir` alone cannot supply them):

```sh
claude plugin marketplace add .
claude plugin install openartifact@openartifact-community
echo '{"server_url":"https://artifacts.example.com","api_token":"oa_pat_..."}' \
  | claude plugin configure openartifact@openartifact-community --values-stdin
# without --values-stdin the command only lists the options; /plugin configure inside Claude Code also sets them
claude mcp list                                               # plugin:openartifact:openartifact ... ✔ Connected
```

Check the manifests with `claude plugin validate .`. To keep a test away from your own Claude Code setup, run these with `CLAUDE_CONFIG_DIR` pointing to an empty directory.

## Privacy

The plugin sends requests only to the OpenArtifact server you configure, with the token you give it. It has no server of its own, collects nothing and sends nothing anywhere else. What your OpenArtifact server logs is governed by whoever runs it.

## License

AGPL-3.0-or-later, the license of OpenArtifact. See [LICENSES](LICENSES/).
