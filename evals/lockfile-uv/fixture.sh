#!/usr/bin/env bash
# SPDX-FileCopyrightText: The OpenArtifact Authors
#
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail
cat > pyproject.toml <<'TOML'
[project]
name = "acme-api"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = ["acme-web==3.2.0", "acme-shared", "acme-fork @ git+https://github.com/acme/acme-fork@v1.0.0"]

[dependency-groups]
dev = ["acme-test==8.1.0"]

[[tool.uv.index]]
name = "openartifact"
url = "https://oa.example.test/repos/pypi-all/simple"
default = true

[tool.uv.sources]
acme-shared = { path = "../shared" }
TOML
cat > uv.lock <<'TOML'
version = 1
revision = 3
requires-python = ">=3.11"

[[package]]
name = "acme-api"
version = "0.1.0"
source = { virtual = "." }
dependencies = [
    { name = "acme-fork" },
    { name = "acme-shared" },
    { name = "acme-web" },
]

[package.dev-dependencies]
dev = [
    { name = "acme-test" },
]

[package.metadata]
requires-dist = [
    { name = "acme-fork", git = "https://github.com/acme/acme-fork?rev=v1.0.0" },
    { name = "acme-shared", directory = "../shared" },
    { name = "acme-web", specifier = "==3.2.0" },
]

[package.metadata.requires-dev]
dev = [{ name = "acme-test", specifier = "==8.1.0" }]

[[package]]
name = "acme-fork"
version = "1.0.0"
source = { git = "https://github.com/acme/acme-fork?rev=v1.0.0#4f2b8c1d9e0a7b6c5d4e3f2a1b0c9d8e7f6a5b4c" }

[[package]]
name = "acme-json"
version = "2.0.0"
source = { registry = "https://oa.example.test/repos/pypi-all/simple" }
sdist = { url = "https://oa.example.test/repos/pypi-all/packages/acme_json-2.0.0.tar.gz", hash = "sha256:5d1b4f2a9c8e7d6b5a4f3e2d1c0b9a8f7e6d5c4b3a2f1e0d9c8b7a6f5e4d3c2b", size = 48211 }

[[package]]
name = "acme-shared"
version = "0.3.0"
source = { directory = "../shared" }

[[package]]
name = "acme-test"
version = "8.1.0"
source = { registry = "https://oa.example.test/repos/pypi-all/simple" }
sdist = { url = "https://oa.example.test/repos/pypi-all/packages/acme_test-8.1.0.tar.gz", hash = "sha256:a7c3e1f5b9d2a4c6e8f0b1d3a5c7e9f1b3d5a7c9e1f3b5d7a9c1e3f5b7d9a1c3", size = 132907 }

[[package]]
name = "acme-web"
version = "3.2.0"
source = { registry = "https://oa.example.test/repos/pypi-all/simple" }
dependencies = [
    { name = "acme-json" },
]
sdist = { url = "https://oa.example.test/repos/pypi-all/packages/acme_web-3.2.0.tar.gz", hash = "sha256:0e2f4a6c8b1d3f5a7c9e0b2d4f6a8c1e3b5d7f9a2c4e6b8d1f3a5c7e9b2d4f6a", size = 90312 }
TOML
