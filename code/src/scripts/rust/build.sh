#!/usr/bin/env bash
#
# build.sh — compile every crate in the Rust workspace, tests and examples included.
#
# Usage:
#   build.sh             cargo build --workspace --all-targets   (run in code/src/rust/)
#   build.sh --release   the same, with optimisations (target/release/)
#   build.sh --help      print this header
#
# --all-targets builds the test and example code too, so a test that no longer compiles
# is caught here rather than first surfacing in test.sh.
#
# Exit codes: 0 = pass  1 = failures  2 = script/tool error
set -euo pipefail
# shellcheck source-path=SCRIPTDIR source=../_lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../_lib/common.sh"

profile=()
while [[ $# -gt 0 ]]; do
  case "$1" in
  --release) profile=(--release); shift ;;
  --help | -h) print_help; exit 0 ;;
  *) die "unknown option '$1' (see --help)" ;;
  esac
done

rust_enter
run_gate "Rust build" cargo build --workspace --all-targets "${profile[@]}"
