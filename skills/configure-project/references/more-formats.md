# Swift, Dart/Flutter, R, CocoaPods, Eclipse p2 and Git LFS

Reference of the `configure-project` skill for formats that OpenArtifact 0.26.0 added. On an older server, `list_repositories(format=...)` finds no repository of these formats: say that the server does not offer the format, and do not set anything up.

As for every format: take the URL from `client_setup(repository)`, write the configuration yourself, keep the token in a user-level place, and leave `<TOKEN>` for the user.

| Format | Project files | Repository types | Publish |
|---|---|---|---|
| `swift` | `Package.swift`, `Package.resolved` | hosted, proxy, group | hosted only |
| `pub` | `pubspec.yaml`, `pubspec.lock` | hosted, proxy, group | hosted only |
| `cran` | `DESCRIPTION`, `renv.lock`, `.Rprofile` | hosted, proxy, group | hosted only |
| `cocoapods` | `Podfile`, `Podfile.lock`, `*.podspec` | proxy only | none |
| `p2` | a Tycho build: `pom.xml` with the `tycho-maven-plugin` or `<packaging>eclipse-plugin</packaging>`, `*.target` files | proxy only | none |
| `gitlfs` | `.gitattributes` with `filter=lfs`, `.lfsconfig` | hosted only | `git push` |

A Swift, Pub or CRAN group never takes a publish (it cannot have a deploy target): publish to a hosted repository, even when installs go through the group. CocoaPods, p2 and Git LFS have no groups, so step 2's group preference does not apply: pick the proxy (CocoaPods, p2) or the hosted repository (Git LFS).

## Swift (SwiftPM registry)

- **Registry:** `swift package-registry set <base_url>` in the project writes `.swiftpm/configuration/registries.json`, which holds no secret and may be committed; `--global` sets it for the user instead. Dependencies then use `.package(id: "scope.name", from: "1.0.0")`; a `.package(url:)` dependency still comes from its git host, not from the registry.
- **Token:** `swift package-registry login <base_url>/login --token <TOKEN>`, which the user runs; SwiftPM keeps it in the keychain or `~/.netrc`.
- SwiftPM sends no credentials over plain `http`: a private repository needs an `https` URL. If `base_url` is `http`, say so instead of adding `--allow-insecure-http` for a private repository.
- **Publish:** `swift package-registry publish scope.name 1.0.0 --url <hosted base_url>`.

## Dart and Flutter (pub)

- **Registry:** for every package, the user's environment (`PUB_HOSTED_URL=<base_url>`, in the shell profile or CI settings); for one dependency, `hosted: <base_url>` under it in `pubspec.yaml`, which holds no secret.
- **Token:** `dart pub token add <base_url>`, which the user runs and which prompts for the token (`flutter pub token add` for Flutter); in CI, `dart pub token add <base_url> --env-var OPENARTIFACT_TOKEN` stores only the variable's name. pub sends tokens only over `https`.
- **Publish:** `dart pub publish --server <hosted base_url>`, or `publish_to: <hosted base_url>` in `pubspec.yaml`.

## R (CRAN)

- **Registry:** `options(repos = c(oa = "<base_url>"))`. In a project `.Rprofile` that is committed, use the URL without credentials. With renv, the repository is also listed under `Repositories` in `renv.lock`, without credentials.
- **Token:** in the user's `~/.netrc` (`machine <host> login <USERNAME> password <TOKEN>`, `chmod 600`). `client_setup` also shows a URL with the credentials in it; that form goes only into the user's own `~/.Rprofile`, never into the project.
- **Publish:** `R CMD build` and an upload of the `.tar.gz` to the hosted repository (the `client_setup` snippet of that repository shows the URL). There is no publish command in R itself.

## CocoaPods

- **Registry:** `source '<base_url>'` at the top of the `Podfile`, holding no secret. Once a `source` is given, CocoaPods uses only the listed sources, so the proxy must mirror the trunk CDN the project resolves from.
- **Token:** `~/.netrc` (`machine <host> login oa password <TOKEN>`, `chmod 600`). CocoaPods matches it by host name without the port.
- Proxy only: pods are published to trunk or another spec repository, not to OpenArtifact.

## Eclipse p2 (Tycho)

- **Registry:** a `<repository>` with `<layout>p2</layout>`, an `<id>` and the `base_url` ending in `/` in the `pom.xml` (or as a location in the `.target` file).
- **Token:** a `<server>` with the same `<id>` in the user's `~/.m2/settings.xml`, never in the project.
- Proxy only: p2 sites are read, not published to.

## Git LFS

- **Registry:** `git config -f .lfsconfig lfs.url <base_url>`. `.lfsconfig` holds no secret and is meant to be committed, so every clone uses it. Keep the `.gitattributes` entries the project has.
- **Token:** through git's credential helper, which the user sets up with `<TOKEN>` (the `client_setup` snippet shows `git credential approve`). Never put credentials into `lfs.url`.
- There is nothing to install: objects are uploaded on `git push` and downloaded on checkout. Verify with `git lfs env`, which shows the endpoint, not with an install.
