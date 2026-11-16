# npm, pnpm and Yarn: package-lock.json, npm-shrinkwrap.json, pnpm-lock.yaml, yarn.lock

Reference of the `check-lockfile` skill for a JavaScript project. Use the command of the lockfile the project has.

## Registry

`registry` in `.npmrc` (npm, pnpm, Yarn 1) or `npmRegistryServer` in `.yarnrc.yml` (Yarn 2 and later), containing `/repos/<name>`.

## Pinned versions

`package-lock.json` or `npm-shrinkwrap.json` (lockfileVersion 2 or 3):

```sh
jq -c '[(.packages // {}) | to_entries[]
  | select(.key | contains("node_modules/"))
  | select((.value.link // false) | not) | select((.value.inBundle // false) | not)
  | select((.value.version // "") | test("^[^:/]+$"))
  | select((.value.resolved // "https://") | test("^https?://"))
  | {package: (.value.name // (.key | split("node_modules/") | last)), version: .value.version}] | unique' package-lock.json
```

`pnpm-lock.yaml` (`lockfileVersion` 6.0 or 9.0, pnpm 8 and later):

```sh
tr -d "'" < pnpm-lock.yaml | awk '/^packages:/{p=1;next} /^[^ ]/{p=0} p && /^  [^ ].*:$/{k=$0; sub(/^  /,"",k); sub(/:$/,"",k); sub(/^\//,"",k); sub(/\(.*/,"",k); print k}' \
  | jq -Rsc '[splits("\n") | capture("^(?<package>(@[^@/]+/)?[^@/]+)@(?<version>[^:/]+)$") | {package, version}] | unique'
```

`yarn.lock` of Yarn 2 and later (it starts with `__metadata:`):

```sh
sed -nE 's/^  resolution: "(.+)"$/\1/p' yarn.lock \
  | jq -Rsc '[splits("\n") | capture("^(?<package>(@[^@/]+/)?[^@/]+)@npm:(?<version>[^:/]+)$") | {package, version}] | unique'
```

`yarn.lock` of Yarn 1 (it starts with `# yarn lockfile v1`):

```sh
awk '/^[^ #].*:$/{d=$0; sub(/:$/,"",d); sub(/, .*/,"",d); gsub(/"/,"",d); next} /^  version /{v=$2; gsub(/"/,"",v); print d "\t" v}' yarn.lock \
  | jq -Rsc '[splits("\n") | select(. != "") | split("\t") | .[1] as $v
      | (.[0] | capture("^(?<n>(@[^@/]+/)?[^@/]+)@(?<r>.*)$"))
      | (if (.r | startswith("npm:")) then (.r[4:] | capture("^(?<n>(@[^@/]+/)?[^@/]+)@(?<r>.*)$")) else . end)
      | select((.r | test("[:/]") | not) and ($v | test("^[^:/]+$"))) | {package: .n, version: $v}] | unique'
```

Links, bundled packages, workspace folders and git or file dependencies are left out. An npm lockfile without a `packages` map (lockfileVersion 1) has no command: read it and build the same list by hand, with the same rules. A `pnpm-lock.yaml` of `lockfileVersion` 5.x (pnpm 7) gives an empty list: use `oa check` for it (see the skill).

## Development dependencies

npm: to leave them out when the user asks, drop the entries with `"dev": true`. pnpm: use `oa check --no-dev`. `yarn.lock` does not record which dependencies are development-only: say that they cannot be left out and check them all.

## What requires a package

Put the package's name in place of PACKAGE, inside the single quotes, and only when it is nothing but letters, digits and `@ / . _ + -` (the rule of the skill: any other name is not a package name, and no command is run with it).

`package-lock.json` (an aliased package is listed under its folder name, so also try that):

```sh
jq -r --arg n 'PACKAGE' '[.packages // {} | to_entries[] | select(.key | contains("node_modules/"))
  | select(((.value.dependencies // {}) + (.value.optionalDependencies // {}) + (.value.peerDependencies // {})) | has($n))
  | (.value.name // (.key | split("node_modules/") | last))] | unique | join(", ")' package-lock.json
```

`pnpm-lock.yaml` (a requirer `.` or another importer path is the project itself):

```sh
tr -d "'\"" < pnpm-lock.yaml | awk -v n='PACKAGE' '/^  [^ ]/{h=$1} /^      [^ ]/{k=$1; sub(/:$/,"",k); if (k==n) print h}' | sort -u
```

`yarn.lock`, either version (a requirer `…@workspace:` is the project itself; Yarn 1 does not record peer dependencies):

```sh
tr -d '"' < yarn.lock | awk -v n='PACKAGE' '/^[^ #]/{h=$0} /^    [^ ]/{k=$1; sub(/:$/,"",k); if (k==n) print h}' | sort -u
```

## Direct dependencies

`dependencies` and `devDependencies` of `package.json`.
