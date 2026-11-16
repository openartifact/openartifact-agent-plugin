# Python: uv.lock, poetry.lock, pylock.toml

Reference of the `check-lockfile` skill for a Python project. Use the command of the lockfile the project has.

## Registry

The index `url` of `[[tool.uv.index]]` or `[[tool.poetry.source]]` in `pyproject.toml`, or `UV_INDEX_URL`, `PIP_INDEX_URL`, `uv.toml`, `pip.conf`, containing `/repos/<name>` and ending in `/simple`.

## Pinned versions

`uv.lock`:

```sh
awk -F'"' '/^\[\[package\]\]/{n="";v=""} /^name = /{n=$2} /^version = /{v=$2} /^source = \{ registry = /{print n "\t" v}' uv.lock \
  | jq -Rsc '[splits("\n") | select(. != "") | split("\t") | {package: (.[0] | ascii_downcase | gsub("[-_.]+"; "-")), version: .[1]}] | unique'
```

`poetry.lock` (a package from PyPI has no `[package.source]`; one of type `legacy` comes from another index, such as OpenArtifact):

```sh
awk -F'"' 'function out(){ if (n != "" && ok) print n "\t" v }
  /^\[\[package\]\]/{out(); n=""; v=""; ok=1; t=1; next} /^\[/{t=0; s=($0=="[package.source]"); next}
  t && /^name = /{n=$2} t && /^version = /{v=$2} s && /^type = /{ok=($2=="legacy")} END{out()}' poetry.lock \
  | jq -Rsc '[splits("\n") | select(. != "") | split("\t") | {package: (.[0] | ascii_downcase | gsub("[-_.]+"; "-")), version: .[1]}] | unique'
```

`pylock.toml` (PEP 751, as `uv export` and `pip lock` write it; also `pylock.<name>.toml`: name that file in the command, in single quotes):

```sh
awk -F'"' 'function out(){ if (n != "" && v != "" && !x) print n "\t" v }
  /^\[\[packages\]\]/{out(); n=""; v=""; x=0; t=1; next} /^\[packages\.(vcs|directory|archive)\]/{x=1} /^\[/{t=0; next}
  t && /^name = /{n=$2} t && /^version = /{v=$2} t && /^(vcs|directory|archive) = /{x=1} END{out()}' pylock.toml \
  | jq -Rsc '[splits("\n") | select(. != "") | split("\t") | {package: (.[0] | ascii_downcase | gsub("[-_.]+"; "-")), version: .[1]}] | unique'
```

Git, directory, file and URL packages are left out, and the project itself.

## Development dependencies

uv and Poetry 2: use `oa check --no-dev`. `pylock.toml` and the `poetry.lock` of Poetry 1.5 to 1.8 (no `groups` lines) do not record which dependencies are development-only: say that they cannot be left out and check them all.

## What requires a package

Put the package's name in place of PACKAGE, inside the single quotes, and only when it is nothing but letters, digits and `@ / . _ + -` (the rule of the skill: any other name is not a package name, and no command is run with it).

`uv.lock` (`(the project)` is a workspace member, the project itself):

```sh
awk -F'"' -v n='PACKAGE' '/^\[\[package\]\]/{h=""} /^name = /{h=$2} /^source = \{ (virtual|editable) = /{h="(the project)"} /\{ name = "/{if ($2 == n) print h}' uv.lock | sort -u
```

`poetry.lock` (give PACKAGE lowercase, with `-` for `_` and `.`):

```sh
awk -v n='PACKAGE' '/^\[\[package\]\]/{d=0; next} /^\[/{d=($0=="[package.dependencies]"); next}
  /^name = /{h=$3; gsub(/"/,"",h)} d && /^[^ ]/{k=tolower($1); gsub(/"/,"",k); gsub(/[-_.]+/,"-",k); if (k==n) print h}' poetry.lock | sort -u
```

A `pylock.toml` of `uv export` or `pip lock` records no requirers at all: say that the lockfile cannot tell, and look in `pyproject.toml` whether the project requires the package itself.

## Direct dependencies

`dependencies` and the dependency groups of `pyproject.toml`.
