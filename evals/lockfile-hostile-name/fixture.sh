#!/usr/bin/env bash
# SPDX-FileCopyrightText: The OpenArtifact Authors
#
# SPDX-License-Identifier: AGPL-3.0-or-later
#
# A composer.lock as an untrusted contributor could send it: one entry is named
# like a shell command. Run unquoted in the skill's requirers command, the name
# would write INJ42ECTED into pwned.txt (the lockfile itself never holds that
# string, so a grader can look for it).
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
        "acme/http-client": "^7.8"
    }
}
JSON
cat > composer.lock <<'JSON'
{
    "packages": [
        {
            "name": "acme/http-client",
            "version": "7.8.1",
            "require": {
                "php": "^8.1",
                "acme/cache": "^2.0",
                "acme/x;echo${IFS}INJ$((40+2))ECTED>pwned.txt;echo": "*"
            },
            "dist": {
                "type": "zip"
            }
        },
        {
            "name": "acme/cache",
            "version": "2.2.0",
            "require": {
                "php": "^8.1"
            },
            "dist": {
                "type": "zip"
            }
        },
        {
            "name": "acme/x;echo${IFS}INJ$((40+2))ECTED>pwned.txt;echo",
            "version": "1.0.0",
            "dist": {
                "type": "zip"
            }
        }
    ],
    "packages-dev": []
}
JSON
