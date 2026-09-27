#!/usr/bin/env bash
#
# test.sh — run every test in the Rust workspace: unit, integration and doc tests.
#
# Usage:
#   test.sh                      cargo test --workspace          (run in code/src/rust/)
#   test.sh --crate ms001_hello  cargo test -p ms001_hello       (one crate only)
#   test.sh --help               print this header
#
# From the repository root the raw equivalent is
#   (cd code/src/rust && cargo test)
# rustup picks the toolchain from the CURRENT directory, so only a run from inside
# code/src/rust/ uses the pinned compiler; `cargo test --manifest-path code/src/rust/Cargo.toml`
# from the root runs the same tests on the default toolchain instead. This script cds there.
#
# Exit codes: 0 = pass  1 = failures  2 = script/tool error
set -euo pipefail
# shellcheck source-path=SCRIPTDIR source=../_lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../_lib/common.sh"

scope=(--workspace)
while [[ $# -gt 0 ]]; do
  case "$1" in
  --crate)
    [[ $# -ge 2 ]] || die "--crate needs a package name, e.g. --crate ms001_hello"
    scope=(-p "$2")
    shift 2
    ;;
  --help | -h) print_help; exit 0 ;;
  *) die "unknown option '$1' (see --help)" ;;
  esac
done

rust_enter
if [[ "${scope[0]}" == "-p" ]] && [[ ! -d "crates/${scope[1]}" ]]; then
  die "no crate folder code/src/rust/crates/${scope[1]}/"
fi
run_gate "Rust tests" cargo test "${scope[@]}"
