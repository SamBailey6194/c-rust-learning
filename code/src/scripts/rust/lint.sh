#!/usr/bin/env bash
#
# lint.sh — rustfmt and clippy over the Rust workspace, warnings as errors.
#
# Usage:
#   lint.sh         cargo fmt --all --check
#                   cargo clippy --workspace --all-targets -- -D warnings
#   lint.sh --fix   run `cargo fmt --all` first (rewrites layout only), then the checks
#   lint.sh --help  print this header
#
# Both checks always run, so one pass shows every problem. The lint levels themselves live
# in code/src/rust/Cargo.toml ([workspace.lints]); `-D warnings` turns every remaining
# warning, pedantic ones included, into an error — the same bar CI applies.
#
# Exit codes: 0 = pass  1 = failures  2 = script/tool error
set -euo pipefail
# shellcheck source-path=SCRIPTDIR source=../_lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../_lib/common.sh"

fix=false
while [[ $# -gt 0 ]]; do
  case "$1" in
  --fix) fix=true; shift ;;
  --help | -h) print_help; exit 0 ;;
  *) die "unknown option '$1' (see --help)" ;;
  esac
done

rust_enter

# A missing component is "could not run" (2), never a lint finding (1).
cargo fmt --version >/dev/null 2>&1 ||
  die "rustfmt is missing from the pinned toolchain: rustup component add rustfmt"
cargo clippy --version >/dev/null 2>&1 ||
  die "clippy is missing from the pinned toolchain: rustup component add clippy"

if $fix; then
  bold "==> cargo fmt --all   (rewriting layout)"
  cargo fmt --all || die "cargo fmt could not format the workspace (a syntax error?)"
fi

failed=0
bold "==> Rust format: cargo fmt --all --check"
if cargo fmt --all --check; then
  bold "PASS: Rust format"
else
  bold "FAIL: Rust format — run lint.sh --fix, or cargo fmt --all" >&2
  failed=1
fi

bold "==> Rust clippy: cargo clippy --workspace --all-targets -- -D warnings"
if cargo clippy --workspace --all-targets -- -D warnings; then
  bold "PASS: Rust clippy"
else
  bold "FAIL: Rust clippy" >&2
  failed=1
fi

exit "$failed"
