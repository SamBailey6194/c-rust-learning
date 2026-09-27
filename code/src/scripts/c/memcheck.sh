#!/usr/bin/env bash
#
# memcheck.sh — run the C tests under valgrind memcheck
#
# Usage:
#   memcheck.sh                      make -C code/src/c memcheck
#   memcheck.sh --path ms001-hello   make -C code/src/c/ms001-hello memcheck
#   memcheck.sh --help               print this header
#
# Runs the plain (non-sanitised) build/test_* binaries under valgrind with
# --leak-check=full --show-leak-kinds=all --errors-for-leak-kinds=all --error-exitcode=1.
# ASan and valgrind never mix: this uses build/, san.sh uses build/san/.
#
# --path takes an exercise name (ms001-hello), a repo-relative path or an absolute path.
# The raw make command above is the lesson; this script adds only the exit-code contract
# and one PASS/FAIL line, so a local run and CI report the same way.
#
# Exit codes: 0 = pass  1 = failures  2 = script/tool error
set -euo pipefail
# shellcheck source-path=SCRIPTDIR source=../_lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../_lib/common.sh"

c_make memcheck "$@"
