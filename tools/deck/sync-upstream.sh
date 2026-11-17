#!/usr/bin/env bash
# Merge upstream mkw-recomp into this fork's main. Resolve conflicts as SYNC.md says, then rebuild.
set -euo pipefail
cd "$(dirname "$0")/../.."
git remote add upstream https://github.com/adriadam10/mkw-recomp.git 2>/dev/null || true
git fetch upstream
git merge upstream/main
