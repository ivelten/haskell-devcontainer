#!/usr/bin/env bash
set -euo pipefail

docker scout cves ivelten/haskell-devcontainer --format markdown > scout-report.md
