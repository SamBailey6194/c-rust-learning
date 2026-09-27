#!/usr/bin/env bash
#
# san.sh — run the C tests under AddressSanitizer + UndefinedBehaviorSanitizer
#
# Usage:
#   san.sh                      make -C code/src/c san
#   san.sh --path ms001-hello   make -C code/src/c/ms001-hello san
#   san.sh --help               print this header
#
# Rebuilds every exercise into build/san/ with -fsanitize=address,undefined (and UBSan
# recovery off, so the first report fails the run), then runs the tests there. Catches
# out-of-bounds access, use-after-free, leaks and undefined behaviour at runtime.
#
# --path takes an exercise name (ms001-hello), a repo-relative path or an absolute path.
# The raw make command above is the lesson; this script adds only the exit-code contract
# and one PASS/FAIL line, so a local run and CI report the same way.
#
# Exit codes: 0 = pass  1 = failures  2 = script/tool error
set -euo pipefail
# shellcheck source-path=SCRIPTDIR source=../_lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../_lib/common.sh"

c_make san "$@"
