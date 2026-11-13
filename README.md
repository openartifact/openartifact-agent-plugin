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

Then set the server URL and an access token with `/plugin configure openartifact@openartifact` inside Claude Code; run the same command to change them later. Claude Code keeps the token in secure storage. Until both are set, the plugin's MCP server does not connect.

## Cursor

The plugin carries a Cursor manifest (`.cursor-plugin/plugin.json`, `mcp.json`). Cursor reads the server URL and the token from the plugin variables `OA_URL` and `API_TOKEN`, which a team administrator sets in the Cursor dashboard under **Plugins → Configure**. A plugin installed locally has no way to set them, so for one developer, give the plugin's MCP server its connection from your own MCP config instead:

1. Copy the plugin into Cursor's local plugin folder. Cursor skips a symlink to a folder elsewhere, so copy it:

   ```sh
   git clone https://github.com/openartifact/openartifact-agent-plugin.git
   mkdir -p ~/.cursor/plugins/local
   rsync -a --delete --exclude .git --exclude evals openartifact-agent-plugin/ ~/.cursor/plugins/local/openartifact/
   ```

2. Add a server named `openartifact` to `~/.cursor/mcp.json`, next to any servers already there, with the token read from an environment variable:

   ```json
   {
     "mcpServers": {
       "openartifact": {
         "url": "https://artifacts.example.com/mcp",
         "headers": { "Authorization": "Bearer ${env:OPENARTIFACT_TOKEN}" }
       }
     }
   }
   ```

   Cursor resolves `${env:...}` from its own environment, so set `OPENARTIFACT_TOKEN` where Cursor inherits it (for example start Cursor from a shell that exports it).

3. Run **Developer: Reload Window**. Open **Customize**: the five skills are listed under **Skills**. In **Customize → MCP**, open **Configure** on `openartifact`: it shows two sources. Turn off the **Plugin** source, so the server uses your `mcp.json` entry, and select **Reload**. The environment should show as connected.

Until a URL and token are set, the plugin's own server answers `fetch failed`, because its URL is the unresolved `${OA_URL}/mcp`.

Tested with Cursor 3.9 against OpenArtifact 0.24.0: the agent followed `check-lockfile` on a 132-package `composer.lock`, called `check_dependencies`, and reported the one held package with its rule and reason. Cursor plans differ in whether MCP and skills are included; check yours if Customize does not show them.

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

## Evals

`evals/` holds test prompts that run the skills in a real Claude Code session against mocked OpenArtifact tools (`evals/mocks/openartifact/`, no server needed) and score the answers:

| Case | Checks |
|---|---|
| `blocked-version` | a version a curation rule blocks is refused with the reason, and never worked around |
| `lockfile-unknown-is-not-blocked` | a lockfile is checked in one `check_dependencies` call, and `unknown` is reported as "not cached yet", not as blocked |
| `blocked-repository-403` | a 403 on every package from a blocked repository is not blamed on missing access |
| `configure-keeps-the-token-out` | project setup never writes the token into a file or repeats it in a command |

```sh
claude plugin eval . --case blocked-version --runs 1 --ablation none          # one case, once
claude plugin eval . --scaffold --allow-tools Edit Write                      # the whole suite
```

The last case creates a `composer.json` with a scaffold script and edits it, so it needs `--scaffold --allow-tools Edit Write`. Runs use your own Claude credentials and count against your usage: one run of one case costs about $0.10 at list price, and the default is each case's `runs` with and without the plugin. CI does not run them. Run the suite before a release and after changing a skill.

## Privacy

The plugin sends requests only to the OpenArtifact server you configure, with the token you give it. It has no server of its own, collects nothing and sends nothing anywhere else. What your OpenArtifact server logs is governed by whoever runs it.

## License

AGPL-3.0-or-later, the license of OpenArtifact. See [LICENSES](LICENSES/).
