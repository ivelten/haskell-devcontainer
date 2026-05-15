# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-05-15

### Added

- Trivy Dockerfile misconfiguration scan as CI gate before build
- Trivy image vulnerability scan (amd64) as CI gate before multi-platform push
- SARIF results upload to GitHub Security tab

### Changed

- Compile direnv from source using `golang:1.26.3-bookworm` in a multi-stage build, replacing the prebuilt GitHub release binary — this embeds a patched Go stdlib and fixes all `stdlib` CVEs (CVE-2025-58183, CVE-2025-61726, CVE-2025-61728, CVE-2025-61729, CVE-2025-68121, CVE-2026-25679, CVE-2026-32280, CVE-2026-32281, CVE-2026-32283, CVE-2026-33671, CVE-2026-33811, CVE-2026-33814, CVE-2026-39820, CVE-2026-39836, CVE-2026-42499)
- Document hardened `devcontainer.json` with `--cap-drop=ALL`, `no-new-privileges`, `pids-limit`

### Removed

- `@anthropic-ai/claude-code` from the image — its precompiled binary bundles `picomatch` 4.0.3 (CVE-2025-47907) and cannot be updated independently; install it via `postCreateCommand` in your `devcontainer.json` instead: `"postCreateCommand": "npm install -g @anthropic-ai/claude-code"`
- `scout-report.sh` script, superseded by Trivy CI gates

## [1.0.1] - 2026-03-22

- Added `apt-get upgrade` to pick up Debian security patches (glibc, gnutls28, openssh, nodejs, node-proxy-agents)
- Replaced Debian-packaged Node.js 20 with Node.js 22 LTS from NodeSource to address vulnerable npm transitive dependencies (@babel/traverse, tar, undici, minimatch, flatted, serialize-javascript, http-cache-semantics)
- Installed direnv from GitHub releases instead of apt to avoid Go stdlib CVEs in the Debian-packaged binary
- `scout-report.sh` script for generating Docker Scout vulnerability reports
- `.gitignore` file

## [1.0.0] - 2026-03-10

- Initial release
- Haskell toolchain: GHC 9.10.3, Cabal 3.12.1.0, Stack, GHCup, HLS
- Developer tools: Hoogle, Ormolu, fast-tags, cabal-gild, direnv
- Debug Adapter Protocol support via haskell-dap, ghci-dap, haskell-debug-adapter
- Claude Code CLI
- Multi-platform support (linux/amd64, linux/arm64)
- GitHub Actions CI/CD with semver tagging

[1.1.0]: https://github.com/ivelten/haskell-devcontainer/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/ivelten/haskell-devcontainer/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/ivelten/haskell-devcontainer/releases/tag/v1.0.0
