#!/usr/bin/env bash
# SPDX-FileCopyrightText: The OpenArtifact Authors
#
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail
cat > Gemfile <<'RUBY'
source "https://oa.example.test/repos/gems-all/"

gem "acme-web", "4.2.0"
gem "acme-local", path: "../acme-local"
gem "acme-color", git: "https://github.com/acme/acme-color", tag: "v3.1.1"

group :test do
  gem "acme-test", "5.25.1"
end
RUBY
cat > Gemfile.lock <<'LOCK'
GIT
  remote: https://github.com/acme/acme-color
  revision: accffb58fb0dedd17d68f484031a571fd905acb3
  tag: v3.1.1
  specs:
    acme-color (3.1.1)

PATH
  remote: ../acme-local
  specs:
    acme-local (0.1.0)
      acme-web (>= 4)

GEM
  remote: https://oa.example.test/repos/gems-all/
  specs:
    acme-test (5.25.1)
    acme-web (4.2.0)
      acme-xml (~> 1.16)
    acme-xml (1.16.9-aarch64-linux)
    acme-xml (1.16.9-x86_64-linux)

PLATFORMS
  aarch64-linux
  x86_64-linux

DEPENDENCIES
  acme-color!
  acme-local!
  acme-test (= 5.25.1)
  acme-web (= 4.2.0)

BUNDLED WITH
   2.6.8
LOCK
