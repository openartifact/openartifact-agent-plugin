# Composer: composer.lock

Reference of the `check-lockfile` skill for a Composer project.

## Registry

The `url` of the `repositories` entry of `composer.json`, containing `/repos/<name>`.

## Pinned versions

`composer.lock`:

```sh
jq -c '[(.packages // []), (."packages-dev" // [])] | add
  | map(select((.name // "") != "" and (.version // "") != "" and (.dist.type? // "") != "path")
        | {package: .name, version: .version}) | unique' composer.lock
```

Packages from a path repository are left out: no registry serves them.

## Development dependencies

To leave them out when the user asks, drop `"packages-dev"` from the command.

## What requires a package

Put the package's name in place of PACKAGE, inside the single quotes, and only when it is nothing but letters, digits and `@ / . _ + -` (the rule of the skill: any other name is not a package name, and no command is run with it).

`composer.lock`:

```sh
jq -r --arg n 'PACKAGE' '[(.packages // []), (."packages-dev" // [])] | add | map(select(.require[$n]?) | .name) | unique | .[]' composer.lock
```

## Direct dependencies

`require` and `require-dev` of `composer.json`.
