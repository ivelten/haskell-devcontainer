# haskell-devcontainer

A ready-to-use Docker image for Haskell development, built on top of the [VS Code Dev Containers](https://containers.dev/) base image. Pull it, attach VS Code, and get a fully configured Haskell environment in seconds — no local toolchain required.

## Quick Start

```jsonc
// .devcontainer/devcontainer.json
{
  "image": "ivelten/haskell-devcontainer:latest"
}
```

## What's Inside

### Haskell Toolchain

| Tool | Version |
| --- | --- |
| GHC | 9.10.3 |
| Cabal | 3.12.1.0 |
| Stack | latest |
| GHCup | latest |

### Developer Tools

- **[HLS](https://github.com/haskell/haskell-language-server)** — Haskell Language Server for IDE features (completions, type hints, go-to-definition)
- **[Hoogle](https://hoogle.haskell.org/)** — Local Haskell API search database, pre-generated at build time
- **[Ormolu](https://github.com/tweag/ormolu)** — Opinionated, deterministic code formatter
- **[fast-tags](https://github.com/elaforge/fast-tags)** — Fast tag file generator for Haskell source
- **[cabal-gild](https://github.com/tfausak/cabal-gild)** — Formatter and linter for `.cabal` files
- **[direnv](https://direnv.net/)** — Per-directory environment variable loading, hooked into both `bash` and `zsh`

### Debugging (DAP)

Full [Debug Adapter Protocol](https://microsoft.github.io/debug-adapter-protocol/) support via:

- `haskell-dap`
- `ghci-dap`
- `haskell-debug-adapter`

### Other

- **[Claude Code CLI](https://github.com/anthropics/claude-code)** — Anthropic's AI coding assistant, available globally via `claude`
- **Node.js & npm** — Required runtime for the Claude Code CLI

## Platform Support

Images are built for both `linux/amd64` (Intel/AMD) and `linux/arm64` (Apple Silicon).

## CI/CD

The image is automatically built and published to Docker Hub on every push to `main` and on version tags (`v*.*.*`), via GitHub Actions. Versioned tags follow semver: pushing `v1.2.3` publishes `:1.2.3`, `:1.2`, `:1`, and `:latest`.

## Notes

- **Cabal jobs** are set to `$ncpus` for parallel builds.
- **Documentation generation** is disabled in Cabal to speed up package installs.
- The image runs as the non-root `vscode` user, as expected by the Dev Containers spec.
