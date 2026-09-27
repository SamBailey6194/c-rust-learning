#!/usr/bin/env bash
#
# audit.sh — the supply-chain gate: cargo-deny over the Rust workspace's dependency graph.
#
# Usage:
#   audit.sh         cargo deny fetch, then cargo deny check --disable-fetch
#   audit.sh --help  print this header
#
# Checks advisories (RustSec: known vulnerabilities, unmaintained and yanked crates),
# licences, bans and sources against the policy in code/src/rust/deny.toml.
#
# The advisory database is fetched FIRST, on its own: a network failure there is exit 2
# (could not run), and only a completed check that finds something is exit 1. cargo-deny
# itself is not part of rustup; install the version CI pins (CARGO_DENY_VERSION in
# .github/workflows/syntax-rust.yml) with `cargo install --locked --version 0.19.0 cargo-deny`.
#
# Exit codes: 0 = pass  1 = failures  2 = script/tool error
set -euo pipefail
# shellcheck source-path=SCRIPTDIR source=../_lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../_lib/common.sh"

while [[ $# -gt 0 ]]; do
  case "$1" in
  --help | -h) print_help; exit 0 ;;
  *) die "unknown option '$1' (see --help)" ;;
  esac
done

rust_enter
need_tool cargo-deny "cargo install --locked --version 0.19.0 cargo-deny"

bold "==> cargo deny fetch   (RustSec advisory database)"
cargo deny fetch || die "could not fetch the advisory database (offline?), so nothing was checked"

run_gate "Rust supply chain" cargo deny check --disable-fetch
