# NuGet: packages.lock.json

Reference of the `check-lockfile` skill for a .NET project.

## Registry

A package source in `nuget.config` (or `NuGet.Config`), containing `/repos/<name>` and ending in `/v3/index.json`.

## Pinned versions

`packages.lock.json` (NuGet, every target framework; project references are left out):

```sh
jq -c '[.dependencies // {} | .[] | to_entries[] | select(.value.type != "Project")
  | select((.value.resolved // "") | test("^[^:/]+$")) | {package: .key, version: .value.resolved}] | unique' packages.lock.json
```

## Development dependencies

`packages.lock.json` does not record which packages only tests need: say that they cannot be left out and check them all.

## What requires a package

Put the package's name in place of PACKAGE, inside the single quotes, and only when it is nothing but letters, digits and `@ / . _ + -` (the rule of the skill: any other name is not a package name, and no command is run with it).

`packages.lock.json` (NuGet ids ignore case):

```sh
jq -r --arg n 'PACKAGE' '[.dependencies // {} | .[] | to_entries[] | select(.value.type != "Project")
  | select((.value.dependencies // {}) | keys | map(ascii_downcase) | index($n | ascii_downcase)) | .key] | unique | .[]' packages.lock.json
```

## Direct dependencies

The `PackageReference`s of the project files.
