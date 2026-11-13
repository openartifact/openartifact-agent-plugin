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
            "url": "https://oa.example.test/repos/php"
        }
    ],
    "require": {
        "php": "^8.2",
        "laravel/framework": "^10.0",
        "doctrine/dbal": "^3.6"
    }
}
JSON
cat > composer.lock <<'JSON'
{
    "packages": [
        {
            "name": "doctrine/dbal",
            "version": "3.6.4",
            "require": {
                "php": "^7.4 || ^8.0",
                "doctrine/cache": "^1.11|^2.0",
                "doctrine/event-manager": "^1|^2"
            },
            "dist": {
                "type": "zip"
            }
        },
        {
            "name": "doctrine/cache",
            "version": "2.2.0",
            "require": {
                "php": "~7.1 || ^8.0"
            },
            "dist": {
                "type": "zip"
            }
        },
        {
            "name": "doctrine/event-manager",
            "version": "2.0.0",
            "require": {
                "php": "^8.1"
            },
            "dist": {
                "type": "zip"
            }
        },
        {
            "name": "laravel/framework",
            "version": "v10.48.4",
            "require": {
                "php": "^8.1"
            },
            "dist": {
                "type": "zip"
            }
        }
    ],
    "packages-dev": []
}
JSON
