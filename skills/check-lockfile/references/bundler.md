# Bundler: Gemfile.lock

Reference of the `check-lockfile` skill for a Ruby project.

## Registry

The `source` of the `Gemfile`, containing `/repos/<name>`.

## Pinned versions

`Gemfile.lock` (a gem locked for several platforms, `1.16.7-x86_64-linux`, is one version, the number before the platform):

```sh
awk '/^[^ ]/{s=$0; p=0} /^  specs:$/{p=1; next} s=="GEM" && p && /^    [^ ]/{v=$2; gsub(/[()]/,"",v); sub(/-.*/,"",v); print $1 "\t" v}' Gemfile.lock \
  | jq -Rsc '[splits("\n") | select(. != "") | split("\t") | {package: .[0], version: .[1]}] | unique'
```

Git and path gems are left out.

## Development dependencies

`Gemfile.lock` does not record which gems only the development or test groups need: say that they cannot be left out and check them all.

## What requires a package

Put the package's name in place of PACKAGE, inside the single quotes, and only when it is nothing but letters, digits and `@ / . _ + -` (the rule of the skill: any other name is not a package name, and no command is run with it).

`Gemfile.lock` (a requirer in the PATH section is the project's own gem):

```sh
awk -v n='PACKAGE' '/^[^ ]/{s=$0} /^    [^ ]/{h=$1} /^      [^ ]/{if ($1 == n) print (s == "PATH" ? "(the project: " h ")" : h)}' Gemfile.lock | sort -u
```

## Direct dependencies

The gems of the `Gemfile`.
