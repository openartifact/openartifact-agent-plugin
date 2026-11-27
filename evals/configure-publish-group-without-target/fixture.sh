#!/usr/bin/env bash
# SPDX-FileCopyrightText: The OpenArtifact Authors
#
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail
cat > package.json <<'JSON'
{
  "name": "@acme/ui-kit",
  "version": "3.2.0",
  "main": "dist/index.js",
  "files": ["dist"],
  "scripts": { "build": "tsc -p .", "release": "npm run build && npm publish" },
  "dependencies": { "vue": "^3.5.13" },
  "devDependencies": { "typescript": "^5.7.2" }
}
JSON
