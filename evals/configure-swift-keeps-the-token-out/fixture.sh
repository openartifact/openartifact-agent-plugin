#!/usr/bin/env bash
# SPDX-FileCopyrightText: The OpenArtifact Authors
#
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail
cat > Package.swift <<'SWIFT'
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AcmeApp",
    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.5.0"),
    ],
    targets: [
        .executableTarget(name: "AcmeApp", dependencies: [.product(name: "Logging", package: "swift-log")]),
    ]
)
SWIFT
