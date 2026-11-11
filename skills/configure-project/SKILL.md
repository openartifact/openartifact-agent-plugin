---
name: configure-project
description: Configure this project's package manager (Composer, npm, pip, Go, Cargo, Maven, NuGet, ...) to install from the team's OpenArtifact registry. Use when the user asks to set up, point or connect the project to OpenArtifact or to the company registry, or when installs should go through OpenArtifact instead of the public registry.
---

# Configure a project for OpenArtifact

Use the `openartifact` MCP tools. Never invent registry URLs: take them from `client_setup`.

1. **Find the ecosystem** from the files in the project: `composer.json` (composer), `package.json` (npm), `pyproject.toml` / `requirements*.txt` (pypi), `go.mod` (go), `Cargo.toml` (cargo), `pom.xml` / `build.gradle*` (maven), `*.csproj` (nuget), `Gemfile` (rubygems). A project can have several (a Laravel app has composer and npm); handle each.
2. **Pick the repository** with `list_repositories(format=...)`. Prefer a **group** repository: it serves the team's own packages and the proxied public ones from one URL. If there are several candidates and nothing in the project or the conversation decides, ask the user which one to use; do not guess.
3. **Get the setup** with `client_setup(repository)`. Use its `configure` snippet for the client as the source of truth for URLs and commands.
4. **Apply it without committing a secret.** The snippets contain `<TOKEN>` (and sometimes `<USERNAME>`) placeholders:
   - Never write a real token into a file that is or could be committed (`composer.json`, a project `.npmrc` without an env var, `pip.conf` in the repo, `.cargo/config.toml` in the repo).
   - Prefer user-level credentials: for Composer `composer config --global http-basic.<host> token <TOKEN>`; for npm an `.npmrc` line that reads an environment variable (`//<host>/repos/<repo>/:_authToken=${OPENARTIFACT_TOKEN}`); for pip a user-level config or `PIP_INDEX_URL` in the environment.
   - Leave the placeholder in place and tell the user exactly which command to run with their own token, or which environment variable to set. Do not ask the user to paste a token into the chat.
   - Repository settings that contain no secret (the `repositories` entry of `composer.json`, a `registry=` line) may go into the project.
5. **Verify** with a harmless read, for example `composer show -a <a package the project already uses>` or `npm view <package> version`, once the user has supplied credentials. If it fails with 401 or 403, the token is missing or lacks `read` on the repository; if a single package fails, use the `explain-install-failure` skill.

Report what you changed, file by file, and what the user still has to do.
