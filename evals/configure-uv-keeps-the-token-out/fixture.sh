#!/usr/bin/env bash
# SPDX-FileCopyrightText: The OpenArtifact Authors
#
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail
cat > pyproject.toml <<'TOML'
[project]
name = "acme-reports"
version = "0.9.0"
requires-python = ">=3.12"
dependencies = [
    "httpx>=0.28",
    "jinja2>=3.1",
]
TOML
