#!/usr/bin/env bash
# SPDX-FileCopyrightText: The OpenArtifact Authors
#
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail
cat > pubspec.yaml <<'YAML'
name: acme_widgets
description: Shared Flutter widgets of the Acme apps.
version: 1.3.0

environment:
  sdk: ^3.5.0

dependencies:
  flutter:
    sdk: flutter
  intl: ^0.19.0
YAML
