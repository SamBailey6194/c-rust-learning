#!/usr/bin/env bash
#
# common.sh — shared helpers for every script under code/src/scripts/. Source it, never run it.
#
# Usage (from a script one folder below code/src/scripts/):
#   source "$(dirname "${BASH_SOURCE[0]}")/../_lib/common.sh"
#
# Provides:
#   PROJECT_ROOT          absolute path of the repository root
#   SCRIPT_SELF           absolute path of the script that sourced this file
#   log / bold            plain and bold output (bold only when stdout is a terminal)
#   die <message>         print "<script>: error: <message>" and exit 2
#   need_tool <tool> <install hint>
#                         exit 2 (COULD NOT RUN) with the hint when <tool> is missing
#   print_help            print the calling script's header comment (its --help text)
#   run_gate <label> <command...>
#                         run a command that checks code; map its exit status to the contract
#   c_make <target> [--path DIR] [--help]
#                         the whole body of the c/*.sh scripts: resolve an exercise, run make
#   rust_enter            check for cargo and cd into code/src/rust/ (the toolchain pin)
#
# Exit codes: 0 = pass  1 = failures  2 = script/tool error
#
# THE CONTRACT, AND WHY 2 IS NOT 1
# 0 means the check ran and found nothing. 1 means it ran and found something about the
# code. 2 means it could not run at all — a missing tool, a bad argument, a folder that is
# not there. "Could not look" is never reported as "looked, and it was clean": a gate that
# cannot fail is worse than no gate, because it is believed.

# Shared by every script, whether or not the caller set it first.
set -euo pipefail

# The script that sourced this file (BASH_SOURCE[1]), resolved to an absolute path now,
# before any caller changes directory, so --help still finds its header afterwards.
SCRIPT_SELF="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)/$(basename "${BASH_SOURCE[1]}")"
SCRIPT_NAME="${SCRIPT_NAME:-$(basename "$SCRIPT_SELF")}"

# This file lives in code/src/scripts/_lib/, four levels below the repository root.
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
export PROJECT_ROOT

log() { printf '%s\n' "$*"; }

bold() {
  if [[ -t 1 ]]; then
    printf '\033[1m%s\033[0m\n' "$*"
  else
    printf '%s\n' "$*"
  fi
}

die() {
  printf '%s: error: %s\n' "$SCRIPT_NAME" "$*" >&2
  exit 2
}

# need_tool gcc "sudo apt install build-essential"
need_tool() {
  local tool="$1" hint="${2:-}"
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf '%s: COULD NOT RUN — %s is not installed.\n' "$SCRIPT_NAME" "$tool" >&2
    [[ -n "$hint" ]] && printf '  Install it with: %s\n' "$hint" >&2
    exit 2
  fi
}

# The header comment at the top of the calling script, minus the shebang and the "# ".
print_help() {
  awk 'NR == 1 { next }
       /^#/ { sub(/^# ?/, ""); if (!started && $0 == "") next; started = 1; print; next }
       { exit }' "$SCRIPT_SELF"
}

# run_gate "C tests" make -C code/src/c test
# Runs a checking command and reports on the contract: its failure is a finding (1).
# Tool and argument problems are ruled out BEFORE this is called (need_tool, die), so a
# non-zero status here is about the code.
run_gate() {
  local label="$1"
  shift
  bold "==> $label: $*"
  if "$@"; then
    bold "PASS: $label"
    return 0
  fi
  bold "FAIL: $label" >&2
  exit 1
}

# resolve_exercise ms001-hello  ->  prints the exercise's absolute path, or dies (exit 2).
# Accepts a bare name, a path relative to the current directory, a repo-relative path or
# an absolute path.
resolve_exercise() {
  local want="$1" dir=""
  if [[ -d "$want" ]]; then
    dir="$(cd "$want" && pwd)"
  elif [[ -d "$PROJECT_ROOT/$want" ]]; then
    dir="$(cd "$PROJECT_ROOT/$want" && pwd)"
  elif [[ -d "$PROJECT_ROOT/code/src/c/$want" ]]; then
    dir="$(cd "$PROJECT_ROOT/code/src/c/$want" && pwd)"
  else
    die "no exercise folder '$want' (try a name such as ms001-hello)"
  fi
  [[ -f "$dir/Makefile" ]] || die "'$dir' has no Makefile, so it is not a C exercise"
  printf '%s\n' "$dir"
}

# c_make <target> "$@" — shared body of c/build.sh, test.sh, san.sh, memcheck.sh, lint.sh.
c_make() {
  local target="$1" dir="$PROJECT_ROOT/code/src/c"
  shift
  while [[ $# -gt 0 ]]; do
    case "$1" in
    --path)
      [[ $# -ge 2 ]] || die "--path needs an exercise folder, e.g. --path ms001-hello"
      dir="$(resolve_exercise "$2")"
      shift 2
      ;;
    --help | -h)
      print_help
      exit 0
      ;;
    *) die "unknown option '$1' (see --help)" ;;
    esac
  done

  need_tool make "sudo apt install make"
  need_tool gcc "sudo apt install build-essential"
  if [[ "$target" == "memcheck" ]]; then
    need_tool valgrind "sudo apt install valgrind"
  fi

  # Run from the repository root with a repo-relative path, so the command echoed below is
  # the same one the docs teach and can be copied as-is.
  cd "$PROJECT_ROOT"
  run_gate "C make $target" make -C "${dir#"$PROJECT_ROOT"/}" "$target"
}

# rust_enter — shared setup of the rust/*.sh scripts: cargo must exist, and every command
# runs from code/src/rust/, because rustup finds rust-toolchain.toml by walking up from the
# CURRENT directory. Run from anywhere else, cargo would use your default toolchain.
rust_enter() {
  need_tool cargo "https://rustup.rs, then run 'rustup toolchain install' inside code/src/rust/"
  [[ -f "$PROJECT_ROOT/code/src/rust/Cargo.toml" ]] || die "code/src/rust/Cargo.toml not found"
  cd "$PROJECT_ROOT/code/src/rust"
  # The pinned toolchain has to be usable here, or every later cargo failure would be
  # misread as a finding about the code.
  rustc --version >/dev/null 2>&1 ||
    die "the toolchain pinned in rust-toolchain.toml is not usable: run 'rustup toolchain install' in code/src/rust/"
}
