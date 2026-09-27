#!/usr/bin/env bash
#
# lint.sh — compile every C source with gcc's static analyser
#
# Usage:
#   lint.sh                      make -C code/src/c lint
#   lint.sh --path ms001-hello   make -C code/src/c/ms001-hello lint
#   lint.sh --help               print this header
#
# Compiles every source and test file with -fanalyzer (plus the full warning set and
# -Werror) into build/lint/. The analyser follows paths through the code looking for
# leaks, double free, use after free and NULL dereference; any finding fails the run.
#
# --path takes an exercise name (ms001-hello), a repo-relative path or an absolute path.
# The raw make command above is the lesson; this script adds only the exit-code contract
# and one PASS/FAIL line, so a local run and CI report the same way.
#
# Exit codes: 0 = pass  1 = failures  2 = script/tool error
set -euo pipefail
# shellcheck source-path=SCRIPTDIR source=../_lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../_lib/common.sh"

c_make lint "$@"
