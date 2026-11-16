# Cargo: Cargo.lock

Reference of the `check-lockfile` skill for a Rust project.

## Registry

The `index` of a registry in `.cargo/config.toml` (or of the registry crates.io is replaced with), containing `/repos/<name>` and ending in `/index/`.

## Pinned versions

`Cargo.lock`:

```sh
awk -F'"' '/^\[\[package\]\]/{n="";v=""} /^name = /{n=$2} /^version = /{v=$2} /^source = "(registry|sparse)\+/{print n "\t" v}' Cargo.lock \
  | jq -Rsc '[splits("\n") | select(. != "") | split("\t") | {package: .[0], version: .[1]}] | unique'
```

Git crates and the crates of the workspace are left out.

## Development dependencies

`Cargo.lock` does not record which crates only dev-dependencies need: say that they cannot be left out and check them all.

## What requires a package

Put the package's name in place of PACKAGE, inside the single quotes, and only when it is nothing but letters, digits and `@ / . _ + -` (the rule of the skill: any other name is not a package name, and no command is run with it).

`Cargo.lock` (a crate without a source is the project's own: a workspace member or a path crate):

```sh
awk -F'"' -v n='PACKAGE' '/^\[\[package\]\]/{h="";s=0} /^name = /{h=$2} /^source = /{s=1} /^ "/{split($2,a," "); if (a[1]==n) print (s ? h : "(the project: " h ")")}' Cargo.lock | sort -u
```

## Direct dependencies

`[dependencies]` and `[dev-dependencies]` of `Cargo.toml`.
