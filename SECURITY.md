<!--
SPDX-FileCopyrightText: The OpenArtifact Authors

SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Security Policy

## Reporting a vulnerability

Report security problems in this plugin **privately**, the same way as for OpenArtifact itself: by email to **morf3089@gmail.com**, as described in OpenArtifact's [security policy](https://github.com/openartifact/openartifact/blob/main/SECURITY.md). Do not open public issues or pull requests for security problems.

Problems in the plugin include, for example:

- a skill that runs a command built from text it does not control (a package name from a lockfile, a reason from the registry),
- a skill that follows instructions found in tool results, or that leads the agent around the registry's decisions,
- a skill or setup step that writes a token into the project, a command or the conversation.

A problem in the OpenArtifact server or its MCP tools (what they return, who may call them) belongs to the OpenArtifact report.

Include, where possible, the plugin version (`version` in `.claude-plugin/plugin.json`), the agent you use, and the prompt and files that reproduce it.

## Supported versions

Fixes are released as a new plugin version. Only the latest release is supported: update with `claude plugin update openartifact@openartifact` (Claude Code) or your agent's equivalent.
