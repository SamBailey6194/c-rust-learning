#!/usr/bin/env bash
#
# test.sh — build and run every C exercise's tests
#
# Usage:
#   test.sh                      make -C code/src/c test
#   test.sh --path ms001-hello   make -C code/src/c/ms001-hello test
#   test.sh --help               print this header
#
# Builds, then runs each build/test_* binary. The first failing test binary stops the run
# and names its exercise; check.h prints each failed CHECK as file:line.
#
# --path takes an exercise name (ms001-hello), a repo-relative path or an absolute path.
# The raw make command above is the lesson; this script adds only the exit-code contract
# and one PASS/FAIL line, so a local run and CI report the same way.
#
# Exit codes: 0 = pass  1 = failures  2 = script/tool error
set -euo pipefail
# shellcheck source-path=SCRIPTDIR source=../_lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../_lib/common.sh"

c_make test "$@"
