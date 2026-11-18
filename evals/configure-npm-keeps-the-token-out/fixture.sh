#!/usr/bin/env bash
# SPDX-FileCopyrightText: The OpenArtifact Authors
#
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail
cat > package.json <<'JSON'
{
  "name": "acme-dashboard",
  "version": "1.4.0",
  "private": true,
  "scripts": { "build": "vite build" },
  "dependencies": { "vue": "^3.5.13" },
  "devDependencies": { "vite": "^6.0.7" }
}
JSON
cat > .npmrc <<'NPMRC'
save-exact=true
NPMRC
