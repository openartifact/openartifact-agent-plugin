#!/usr/bin/env python3
# SPDX-FileCopyrightText: The OpenArtifact Authors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Check the plugin's manifests and skills: valid JSON, the fields Claude Code
and Cursor require, and that the files agree with each other (one plugin name
and version, one MCP server, every skill with a name and a description).
Standard library only, so CI needs no extra tooling. Exits 1 on any problem."""

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
NAME_RE = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
VERSION_RE = re.compile(r"^[0-9]+\.[0-9]+\.[0-9]+([-+][0-9A-Za-z.-]+)?$")
CURSOR_VARIABLES = {"OA_URL", "API_TOKEN"}
SERVER = "openartifact"

problems: list[str] = []


def fail(msg: str) -> None:
    problems.append(msg)


def load(rel: str) -> dict:
    path = ROOT / rel
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        fail(f"{rel}: missing")
        return {}
    except json.JSONDecodeError as e:
        fail(f"{rel}: invalid JSON: {e}")
        return {}
    if not isinstance(data, dict):
        fail(f"{rel}: must be a JSON object")
        return {}
    return data


def check_manifests() -> None:
    claude = load(".claude-plugin/plugin.json")
    cursor = load(".cursor-plugin/plugin.json")
    market = load(".claude-plugin/marketplace.json")

    for rel, m in ((".claude-plugin/plugin.json", claude), (".cursor-plugin/plugin.json", cursor)):
        name = m.get("name", "")
        if not NAME_RE.match(name):
            fail(f"{rel}: name {name!r} must be lowercase kebab-case")
        if m.get("license") != "AGPL-3.0-or-later":
            fail(f"{rel}: license must be AGPL-3.0-or-later")
        if not m.get("description"):
            fail(f"{rel}: description is empty")
        if not isinstance(m.get("version"), str) or not VERSION_RE.match(m["version"]):
            fail(f"{rel}: version must be a version like 1.2.3, got {m.get('version')!r}")

    for field in ("name", "version"):
        if claude.get(field) != cursor.get(field):
            fail(f"plugin {field} differs: Claude {claude.get(field)!r}, Cursor {cursor.get(field)!r}")

    # Claude Code: the server URL and the token are plugin options, the token sensitive.
    opts = claude.get("userConfig", {})
    if not opts.get("api_token", {}).get("sensitive"):
        fail(".claude-plugin/plugin.json: userConfig.api_token must be sensitive")
    if "server_url" not in opts:
        fail(".claude-plugin/plugin.json: userConfig.server_url is missing")

    # Cursor: the same two as plugin variables, each defined as a string and required.
    variables = cursor.get("variables", {})
    required = set(variables.get("required", []))
    if required != CURSOR_VARIABLES:
        fail(f".cursor-plugin/plugin.json: variables.required must be OA_URL and API_TOKEN, got {sorted(required)}")
    defined = variables.get("properties", {})
    for name in sorted(CURSOR_VARIABLES):
        if not isinstance(defined.get(name), dict) or defined[name].get("type") != "string":
            fail(f".cursor-plugin/plugin.json: variables.properties.{name} must be defined with type string")

    if not market.get("owner", {}).get("name"):
        fail(".claude-plugin/marketplace.json: owner.name is required")
    entries = [p for p in market.get("plugins", []) if isinstance(p, dict)]
    if [p.get("name") for p in entries] != [claude.get("name")] or entries[0].get("source") != "./":
        fail(".claude-plugin/marketplace.json: must list this plugin once, with source ./")


def check_mcp(rel: str, url: str, auth: str, need_type: bool) -> None:
    servers = load(rel).get("mcpServers", {})
    if list(servers) != [SERVER]:
        fail(f"{rel}: must declare exactly the {SERVER!r} MCP server, got {sorted(servers)}")
        return
    s = servers[SERVER]
    if need_type and s.get("type") != "http":
        fail(f"{rel}: type must be http (a url without it is read as stdio)")
    if s.get("url") != url:
        fail(f"{rel}: url must be {url!r}, got {s.get('url')!r}")
    if s.get("headers", {}).get("Authorization") != auth:
        fail(f"{rel}: Authorization header must be {auth!r}")


def front_matter(text: str) -> dict:
    if not text.startswith("---\n"):
        return {}
    end = text.find("\n---\n", 4)
    if end < 0:
        return {}
    out = {}
    for line in text[4:end].splitlines():
        key, sep, value = line.partition(":")
        if sep:
            out[key.strip()] = value.strip()
    return out


def check_skills() -> None:
    skills = sorted(p for p in (ROOT / "skills").iterdir() if p.is_dir())
    if not skills:
        fail("skills/: no skills")
    for d in skills:
        rel = f"skills/{d.name}/SKILL.md"
        path = d / "SKILL.md"
        if not path.is_file():
            fail(f"{rel}: missing")
            continue
        fm = front_matter(path.read_text(encoding="utf-8"))
        if fm.get("name") != d.name:
            fail(f"{rel}: front matter name must be {d.name!r}, got {fm.get('name')!r}")
        if len(fm.get("description", "")) < 40:
            fail(f"{rel}: front matter needs a description that says when to use the skill")


def main() -> int:
    check_manifests()
    check_mcp(".mcp.json", "${user_config.server_url}/mcp", "Bearer ${user_config.api_token}", need_type=True)
    check_mcp("mcp.json", "${OA_URL}/mcp", "Bearer ${API_TOKEN}", need_type=False)
    check_skills()

    for p in problems:
        print(f"error: {p}", file=sys.stderr)
    if problems:
        return 1
    print("plugin checks passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
