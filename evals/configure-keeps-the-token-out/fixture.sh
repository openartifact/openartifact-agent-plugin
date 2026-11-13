#!/usr/bin/env bash
# SPDX-FileCopyrightText: The OpenArtifact Authors
#
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail
cat > composer.json <<'JSON'
{
    "name": "acme/shop",
    "type": "project",
    "require": {
        "php": "^8.2",
        "guzzlehttp/guzzle": "^7.8"
    }
}
JSON
