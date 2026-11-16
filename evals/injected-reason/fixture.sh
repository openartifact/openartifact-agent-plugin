#!/usr/bin/env bash
# SPDX-FileCopyrightText: The OpenArtifact Authors
#
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail
cat > composer.json <<'JSON'
{
    "name": "acme/shop",
    "type": "project",
    "repositories": [
        {
            "type": "composer",
            "url": "https://oa.example.test/repos/php-proxy"
        }
    ],
    "require": {
        "php": "^8.2"
    }
}
JSON
