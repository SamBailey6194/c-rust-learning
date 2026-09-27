#!/usr/bin/env bash
#
# check.sh — print the toolchain this repository builds with, as a Markdown table.
#
# Usage:
#   check.sh         print | Tool | Version | for every required and optional tool
#   check.sh --help  print this header
#
# Required (exit 2 if any is missing): gcc make gdb valgrind cargo rustc rustfmt clippy-driver
# Optional (reported, never fail):     qemu-system-x86_64 cloc cargo-deny
#
# The Rust tools are asked from inside code/src/rust/, so the versions shown are the ones
# rust-toolchain.toml pins there. If the rustc found there is not the pinned channel (for
# example a distribution rustc with no rustup), that is a finding: exit 1.
# The versions this repository expects are recorded in how-to/docs/TOOLCHAIN.md.
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

RUST_DIR="$PROJECT_ROOT/code/src/rust"

# version_of <tool> — print the tool's version number, or nothing if it is not installed.
# Each tool words its --version differently; the first dotted number is what we want.
version_of() {
  local tool="$1" out=""
  command -v "$tool" >/dev/null 2>&1 || return 0
  case "$tool" in
  gcc) out="$(gcc -dumpfullversion 2>/dev/null)" ;;
  gdb) out="$(gdb --version 2>/dev/null | head -n 1 | awk '{ print $NF }')" ;;
  cargo | rustc | rustfmt | clippy-driver)
    # Asked from code/src/rust/ so rustup applies the pin.
    out="$(cd "$RUST_DIR" && "$tool" --version 2>/dev/null | head -n 1)" ;;
  cargo-deny) out="$(cargo-deny --version 2>/dev/null | head -n 1)" ;;
  *) out="$("$tool" --version 2>/dev/null | head -n 1)" ;;
  esac
  printf '%s\n' "$out" | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n 1 || true
}

required=(gcc make gdb valgrind cargo rustc rustfmt clippy-driver)
optional=(qemu-system-x86_64 cloc cargo-deny)
missing=()

printf '| Tool | Version |\n'
printf '| --- | --- |\n'
for tool in "${required[@]}"; do
  v="$(version_of "$tool")"
  if [[ -z "$v" ]]; then
    missing+=("$tool")
    v="MISSING (required)"
  fi
  printf '| %s | %s |\n' "$tool" "$v"
done
for tool in "${optional[@]}"; do
  v="$(version_of "$tool")"
  printf '| %s | %s |\n' "$tool" "${v:-not installed (optional)}"
done

if [[ ${#missing[@]} -gt 0 ]]; then
  log ""
  log "COULD NOT RUN: required tool(s) missing: ${missing[*]}"
  log "Setup procedure: how-to/workflows/01-toolchain-setup/"
  exit 2
fi

# The pin, read from the file rather than restated here.
pinned="$(sed -n 's/^channel *= *"\([^"]*\)".*/\1/p' "$RUST_DIR/rust-toolchain.toml")"
active="$(version_of rustc)"
if [[ -n "$pinned" && "$active" != "$pinned" ]]; then
  log ""
  log "FAIL: rustc in code/src/rust/ is $active, but rust-toolchain.toml pins $pinned."
  log "      Is rustup installed and managing cargo? Run 'rustup toolchain install' there."
  exit 1
fi

log ""
log "PASS: every required tool is present; rustc matches the pin ($pinned)."
