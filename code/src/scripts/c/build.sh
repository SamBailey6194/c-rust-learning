#!/usr/bin/env bash
#
# build.sh — build every C exercise, warnings as errors
#
# Usage:
#   build.sh                      make -C code/src/c all
#   build.sh --path ms001-hello   make -C code/src/c/ms001-hello all
#   build.sh --help               print this header
#
# Builds each exercise's program and test binaries into its build/ folder with the flags in
# code/src/c/mk/flags.mk (-std=c17, the full warning set, -Werror). Any warning fails.
#
# --path takes an exercise name (ms001-hello), a repo-relative path or an absolute path.
# The raw make command above is the lesson; this script adds only the exit-code contract
# and one PASS/FAIL line, so a local run and CI report the same way.
#
# Exit codes: 0 = pass  1 = failures  2 = script/tool error
set -euo pipefail
# shellcheck source-path=SCRIPTDIR source=../_lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../_lib/common.sh"

c_make all "$@"
