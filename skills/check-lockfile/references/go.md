# Go: go.sum

Reference of the `check-lockfile` skill for a Go module.

## Registry

`GOPROXY` (in the environment, `go env GOPROXY`, or a `go.env` file), containing `/repos/<name>`.

## Pinned versions

`go.sum`:

```sh
awk 'NF >= 3 {v = $2; sub(/\/go\.mod$/, "", v); print $1 "\t" v}' go.sum | jq -Rsc '[splits("\n") | select(. != "") | split("\t") | {package: .[0], version: .[1]}] | unique'
```

Every module version of `go.sum` counts, also the ones it lists only as `/go.mod`: the go command fetches that file through the registry too, and a held version fails the build either way. `go.sum` has no local or git entries to leave out (a `replace` to a local path has no line in it).

A version such as `v0.0.0-20240613232115-7f521ea00fb8` is a pseudo-version: a commit, not a release. The registry knows it only once a build has fetched it. `unknown` for one is normal on a proxy that has not served it yet. A server older than the fix for this (OpenArtifact 0.24.x and before) answers `not_found` for every pseudo-version: when all the `not_found` answers are pseudo-versions, say that this server cannot tell for them, not that they are missing.

## Development dependencies

`go.sum` does not record which modules only tests need: say that they cannot be left out and check them all.

## What requires a package

`go.sum` records no requirers, so there is no command for it: say that the lockfile cannot tell. `go.mod` says whether the project requires the module itself: its `require` line has no `// indirect` comment. When the go command is installed and the modules are downloaded, `go mod why -m 'PACKAGE'` shows the chain of imports that needs it (the name inside the single quotes, and only when it is nothing but letters, digits and `@ / . _ + -`).

## Direct dependencies

The `require` lines of `go.mod` without `// indirect`.
