#!/usr/bin/env bash
# SPDX-FileCopyrightText: The OpenArtifact Authors
#
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail
cat > package.json <<'JSON'
{
  "name": "acme-web",
  "private": true,
  "dependencies": {
    "acme-ui": "^2.1.0",
    "acme-shared": "link:../shared",
    "acme-fork": "github:acme/acme-fork#v1.0.0"
  },
  "devDependencies": {
    "acme-test": "^5.0.0"
  }
}
JSON
cat > .npmrc <<'NPMRC'
registry=https://oa.example.test/repos/npm-all/
NPMRC
cat > pnpm-lock.yaml <<'YAML'
lockfileVersion: '9.0'

settings:
  autoInstallPeers: true
  excludeLinksFromLockfile: false

importers:

  .:
    dependencies:
      acme-fork:
        specifier: github:acme/acme-fork#v1.0.0
        version: https://codeload.github.com/acme/acme-fork/tar.gz/4f2b8c1d9e0a7b6c5d4e3f2a1b0c9d8e7f6a5b4c
      acme-shared:
        specifier: link:../shared
        version: link:../shared
      acme-ui:
        specifier: ^2.1.0
        version: 2.1.0
    devDependencies:
      acme-test:
        specifier: ^5.0.0
        version: 5.0.2

packages:

  acme-dom@3.4.0:
    resolution: {integrity: sha512-Zm9vYmFyYmF6cXV4cXV1eGNvcmdlZ3JhdWx0Z2FycGx5d2FsZG9mcmVkd2FsZG8xMjM0NTY3ODkwYWJjZGVm==}

  acme-fork@https://codeload.github.com/acme/acme-fork/tar.gz/4f2b8c1d9e0a7b6c5d4e3f2a1b0c9d8e7f6a5b4c:
    resolution: {tarball: https://codeload.github.com/acme/acme-fork/tar.gz/4f2b8c1d9e0a7b6c5d4e3f2a1b0c9d8e7f6a5b4c}
    version: 1.0.0

  acme-test@5.0.2:
    resolution: {integrity: sha512-dGVzdHJ1bm5lcnRlc3RydW5uZXJ0ZXN0cnVubmVydGVzdHJ1bm5lcnRlc3RydW5uZXIxMjM0NTY3ODkwYWI==}

  acme-ui@2.1.0:
    resolution: {integrity: sha512-dWlraXR1aWtpdHVpa2l0dWlraXR1aWtpdHVpa2l0dWlraXR1aWtpdHVpa2l0dWlraXQxMjM0NTY3ODkwYWI==}

snapshots:

  acme-dom@3.4.0: {}

  acme-fork@https://codeload.github.com/acme/acme-fork/tar.gz/4f2b8c1d9e0a7b6c5d4e3f2a1b0c9d8e7f6a5b4c: {}

  acme-test@5.0.2: {}

  acme-ui@2.1.0:
    dependencies:
      acme-dom: 3.4.0
YAML
