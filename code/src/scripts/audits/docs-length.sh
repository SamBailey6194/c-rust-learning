#!/usr/bin/env bash
#
# docs-length.sh — hold every instructional Markdown file to 300 cloc code lines.
#
# Usage:
#   docs-length.sh              check every instructional Markdown file in the repository
#   docs-length.sh --path DIR   check only files under DIR (a repo-relative path)
#   docs-length.sh --verbose    also list every file measured, with its count
#   docs-length.sh --self-test  prove the gate bites: 301 lines fail, 300 lines pass
#   docs-length.sh --help       print this header
#
# In scope (the rule is owned by code/docs/DOCUMENTATION-LENGTH.md):
#   * every CONTEXT.md, CLAUDE.md and AGENTS.md, wherever it sits
#   * **/docs/**/*.md, **/workflows/**/*.md and .claude/**/*.md
# Exempt:
#   * root-level *.md (README.md, REFERENCES.md, GAPS.md, ...)
#   * how-to/src/*.md and project-management/src/** (written in full for a reader)
#   * everything inside learning/, research/ and handoffs/ — except their CONTEXT.md and
#     CLAUDE.md, which the first bullet keeps in scope
#
# Measured with `cloc --include-lang=Markdown`, which counts CODE lines only: blank lines
# and HTML comments do not count. Over 300 fails; the fix is to split the file into a thin
# index plus a kebab-case/ sub-folder. At 270 or more (90%) the file is reported as a
# warning and the run still passes — the moment to split deliberately, before it is forced.
# Files come from git (tracked plus untracked, minus .gitignore), so build/ and target/
# output is never measured.
#
# Exit codes: 0 = pass  1 = failures  2 = script/tool error
set -euo pipefail
# shellcheck source-path=SCRIPTDIR source=../_lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../_lib/common.sh"

LIMIT=300
WARN_AT=270

# The tree to measure. Only --self-test changes it, to point at a scratch tree.
ROOT="${DOCS_LENGTH_ROOT:-$PROJECT_ROOT}"

scope=""
verbose=false
self_test=false
while [[ $# -gt 0 ]]; do
  case "$1" in
  --path)
    [[ $# -ge 2 ]] || die "--path needs a repo-relative directory or file"
    scope="${2#./}"
    scope="${scope%/}"
    shift 2
    ;;
  --verbose) verbose=true; shift ;;
  --self-test) self_test=true; shift ;;
  --help | -h) print_help; exit 0 ;;
  *) die "unknown option '$1' (see --help)" ;;
  esac
done

# ---------------------------------------------------------------------------------------
# Which files count
# ---------------------------------------------------------------------------------------

# Every Markdown file, repo-relative. Through git when ROOT is a work tree (so .gitignore
# is honoured and generated output never appears); otherwise through find.
list_markdown() {
  if [[ "$(git -C "$ROOT" rev-parse --show-toplevel 2>/dev/null)" == "$(cd "$ROOT" && pwd -P)" ]]; then
    git -C "$ROOT" -c core.quotePath=false ls-files --cached --others --exclude-standard -- '*.md'
  else
    (cd "$ROOT" && find . \( -name .git -o -name build -o -name target \) -prune \
      -o -type f -name '*.md' -print | sed 's|^\./||')
  fi | sort -u
}

# Order matters: the CONTEXT.md/CLAUDE.md/AGENTS.md check comes first, so the pair inside
# an otherwise exempt tree (learning/CONTEXT.md, the root CONTEXT.md) is still measured.
is_instructional() {
  local p="$1" base="${1##*/}"
  case "$base" in CONTEXT.md | CLAUDE.md | AGENTS.md) return 0 ;; esac
  case "$p" in learning/* | research/* | handoffs/*) return 1 ;; esac
  [[ "$p" == */* ]] || return 1 # root-level *.md
  case "$p" in project-management/src/* | how-to/src/*) return 1 ;; esac
  case "$p" in docs/* | */docs/* | workflows/* | */workflows/* | .claude/*) return 0 ;; esac
  return 1
}

in_scope() {
  [[ -z "$scope" || "$1" == "$scope" || "$1" == "$scope"/* ]]
}

# ---------------------------------------------------------------------------------------
# --self-test: build a scratch tree whose right answer is known, and check the verdict
# ---------------------------------------------------------------------------------------

# lines <n> <file> — write n Markdown code lines.
lines() {
  mkdir -p "$(dirname "$2")"
  awk -v n="$1" 'BEGIN { for (i = 1; i <= n; i++) printf "Line %d of the self-test.\n", i }' >"$2"
}

run_self_test() {
  need_tool cloc "sudo apt install cloc"
  local tmp out rc fails measured problems=0
  tmp="$(mktemp -d)"
  # shellcheck disable=SC2064  # expand $tmp now: it is local to this function
  trap "rm -rf '$tmp'" EXIT

  lines 301 "$tmp/code/docs/OVER-LIMIT.md"         # in scope, one line over: FAIL
  lines 300 "$tmp/code/docs/AT-LIMIT.md"           # in scope, exactly at the limit: pass
  lines 301 "$tmp/learning/CONTEXT.md"             # pair inside a sandbox: FAIL
  lines 400 "$tmp/learning/c-01-demo/NOTES.md"     # sandbox content: exempt
  lines 400 "$tmp/README.md"                       # root-level: exempt
  lines 400 "$tmp/how-to/src/MACHINE-SETUP.md"     # how-to/src: exempt
  lines 400 "$tmp/project-management/src/01-ROADMAP/ROADMAP.md" # PM artefact: exempt
  # Blank lines and HTML comments are not code lines: 300 code lines still pass.
  lines 300 "$tmp/code/workflows/01-demo/STEPS.md"
  printf '\n<!-- a comment -->\n\n' >>"$tmp/code/workflows/01-demo/STEPS.md"

  if command -v git >/dev/null 2>&1; then
    git -C "$tmp" init -q # exercise the same git listing the real run uses
  fi

  expect() { # expect <description> <command...> — the command's success is the assertion
    local desc="$1"
    shift
    if "$@"; then log "  ok    $desc"; else log "  FAIL  $desc"; problems=1; fi
  }

  bold "docs-length self-test"
  rc=0
  out="$(DOCS_LENGTH_ROOT="$tmp" bash "$SCRIPT_SELF" 2>&1)" || rc=$?
  fails="$(printf '%s\n' "$out" | awk '$1 == "FAIL" { print $3 }' | sort | paste -sd' ' -)"
  expect "a 301-line file makes the run exit 1 (got $rc)" test "$rc" -eq 1
  expect "exactly the two over-limit files are flagged (got: ${fails:-none})" \
    test "$fails" = "code/docs/OVER-LIMIT.md learning/CONTEXT.md"

  rm "$tmp/code/docs/OVER-LIMIT.md" "$tmp/learning/CONTEXT.md"
  rc=0
  out="$(DOCS_LENGTH_ROOT="$tmp" bash "$SCRIPT_SELF" 2>&1)" || rc=$?
  measured="$(printf '%s\n' "$out" | sed -n 's/^docs-length: \([0-9]*\) instructional.*/\1/p')"
  expect "300-line files (and exempt 400-line ones) pass with exit 0 (got $rc)" test "$rc" -eq 0
  expect "the passing run measured 2 files, not 0 (got ${measured:-none})" test "$measured" = 2

  if [[ $problems -ne 0 ]]; then
    bold "FAIL: docs-length self-test — the gate cannot be trusted" >&2
    printf '%s\n' "$out" >&2
    exit 1
  fi
  bold "PASS: docs-length self-test"
  exit 0
}

$self_test && run_self_test

# ---------------------------------------------------------------------------------------
# The real run
# ---------------------------------------------------------------------------------------

need_tool cloc "sudo apt install cloc"
[[ -z "$scope" || -e "$ROOT/$scope" ]] || die "--path '$scope' does not exist under the repository root"

mapfile -t all_md < <(list_markdown)
[[ ${#all_md[@]} -gt 0 ]] || die "no Markdown files found under $ROOT"

targets=()
for f in "${all_md[@]}"; do
  [[ -f "$ROOT/$f" ]] || continue # tracked but deleted in the work tree
  in_scope "$f" || continue
  is_instructional "$f" || continue
  targets+=("$f")
done

log "docs-length: ${#targets[@]} instructional Markdown files measured (limit $LIMIT cloc code lines)"
if [[ ${#targets[@]} -eq 0 ]]; then
  log "PASS: nothing in scope${scope:+ under $scope}."
  exit 0
fi

# One cloc run over the whole list. --skip-uniqueness matters: by default cloc silently
# drops files whose content duplicates another, and a duplicated file is still a file.
list_file="$(mktemp)"
counts="$(mktemp)"
trap 'rm -f "$list_file" "$counts"' EXIT
printf '%s\n' "${targets[@]}" >"$list_file"
(cd "$ROOT" && cloc --by-file --csv --quiet --skip-uniqueness --include-lang=Markdown \
  --list-file="$list_file") >"$counts" || die "cloc failed, so nothing was measured"

# CSV rows: language,filename,blank,comment,code. A file cloc skipped (empty) counts as 0.
declare -A code_lines=()
while IFS=$'\t' read -r name code; do
  code_lines["$name"]="$code"
done < <(awk -F, '$1 == "Markdown" { n = NF; f = $2; for (i = 3; i <= n - 3; i++) f = f "," $i; print f "\t" $n }' "$counts")

over=0
warned=0
for f in "${targets[@]}"; do
  n="${code_lines[$f]:-0}"
  if ((n > LIMIT)); then
    printf 'FAIL  %4d  %s   (over %d: split into a thin index + kebab-case/ sub-folder)\n' "$n" "$f" "$LIMIT"
    over=$((over + 1))
  elif ((n >= WARN_AT)); then
    printf 'WARN  %4d  %s   (at 90%% of the limit: plan the split now)\n' "$n" "$f"
    warned=$((warned + 1))
  elif $verbose; then
    printf 'ok    %4d  %s\n' "$n" "$f"
  fi
done

if ((over > 0)); then
  bold "FAIL: $over file(s) over $LIMIT cloc code lines. Rule: code/docs/DOCUMENTATION-LENGTH.md" >&2
  exit 1
fi
note=""
((warned == 0)) || note=" ($warned near the limit)"
bold "PASS: every instructional file is within $LIMIT lines$note."
