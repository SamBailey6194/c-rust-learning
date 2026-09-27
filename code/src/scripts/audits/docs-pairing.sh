#!/usr/bin/env bash
#
# docs-pairing.sh — every directory carries CONTEXT.md + CLAUDE.md, in the house shape.
#
# Usage:
#   docs-pairing.sh              check the whole repository
#   docs-pairing.sh --path DIR   check only directories and files under DIR (repo-relative)
#   docs-pairing.sh --self-test  prove the gate bites on a scratch tree, then exit
#   docs-pairing.sh --help       print this header
#
# The rule is owned by code/docs/DOCUMENTATION-PAIRING.md: CONTEXT.md says what is here
# and why; CLAUDE.md says how to work here. This script checks the mechanical half.
#
# Pairing — every directory holds both files, unless it matches a glob in
# docs-pairing.exempt (beside this script): the root, .git, .github, skill folders, build
# output, support folders covered by a parent pair, and sandbox content.
#
# Shape — for every CONTEXT.md and CLAUDE.md found (.claude/CLAUDE.md, the manual, aside):
#   CLAUDE.md   line 1 is @./CONTEXT.md; line 2 is @./REFERENCES.md exactly when that file
#               sits beside it; an H1 "# CLAUDE.md — <path>/"; a "Read order:" line; exactly
#               four H2s, in order: Purpose (one line) · How to work here · Guardrails ·
#               Output & naming; and no directory tree.
#   CONTEXT.md  a "## Directory Tree" section, and no heading named Rules, Guardrails,
#               Constraints, Requirements, Prerequisites, Standards, Conventions or
#               Definition of done.
# What no script can judge — whether the opening paragraph explains anything — is left to
# review. Directories come from git (tracked plus untracked, minus .gitignore).
#
# Exit codes: 0 = pass  1 = failures  2 = script/tool error
set -euo pipefail
# shellcheck source-path=SCRIPTDIR source=../_lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../_lib/common.sh"

# The tree to check. Only --self-test changes it, to point at a scratch tree.
ROOT="${DOCS_PAIRING_ROOT:-$PROJECT_ROOT}"
EXEMPT_FILE="$(dirname "$SCRIPT_SELF")/docs-pairing.exempt"

scope=""
self_test=false
while [[ $# -gt 0 ]]; do
  case "$1" in
  --path)
    [[ $# -ge 2 ]] || die "--path needs a repo-relative directory"
    scope="${2#./}"
    scope="${scope%/}"
    [[ "$scope" != "." ]] || scope=""
    shift 2
    ;;
  --self-test) self_test=true; shift ;;
  --help | -h) print_help; exit 0 ;;
  *) die "unknown option '$1' (see --help)" ;;
  esac
done

# ---------------------------------------------------------------------------------------
# Inputs
# ---------------------------------------------------------------------------------------

# Every file, repo-relative: through git when ROOT is a work tree, else through find.
list_files() {
  if [[ "$(git -C "$ROOT" rev-parse --show-toplevel 2>/dev/null)" == "$(cd "$ROOT" && pwd -P)" ]]; then
    git -C "$ROOT" -c core.quotePath=false ls-files --cached --others --exclude-standard
  else
    (cd "$ROOT" && find . \( -name .git -o -name build -o -name target \) -prune \
      -o -type f -print | sed 's|^\./||')
  fi
}

# Every directory that holds a file, at any depth, plus the root itself (".").
list_dirs() {
  printf '.\n'
  list_files | awk -F/ '{ p = ""; for (i = 1; i < NF; i++) { p = (i == 1) ? $1 : p "/" $i; print p } }'
}

load_exemptions() {
  [[ -f "$EXEMPT_FILE" ]] || die "exemption list not found: ${EXEMPT_FILE#"$PROJECT_ROOT"/}"
  local line
  exempt=()
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -n "$line" ]] && exempt+=("$line")
  done <"$EXEMPT_FILE"
  [[ ${#exempt[@]} -gt 0 ]] || die "the exemption list is empty, which is surely a mistake"
}

is_exempt() {
  local glob
  for glob in "${exempt[@]}"; do
    # shellcheck disable=SC2053  # the right-hand side IS a glob, deliberately unquoted
    [[ "$1" == $glob ]] && return 0
  done
  return 1
}

in_scope() {
  [[ -z "$scope" || "$1" == "$scope" || "$1" == "$scope"/* ]]
}

# ---------------------------------------------------------------------------------------
# Checks — each prints one line per problem: KIND  PATH  — what is wrong
# ---------------------------------------------------------------------------------------

problems=0
report() { # report <MISSING|SHAPE> <path> <message>
  printf '%-8s %s  — %s\n' "$1" "$2" "$3"
  problems=$((problems + 1))
}

# Headings outside code fences, one per line ("## Title").
headings() {
  awk '/^(```|~~~)/ { fence = !fence; next } !fence && /^#+ / { print }' "$1"
}

check_claude() { # check_claude <repo-relative path>
  local rel="$1" f="$ROOT/$1" dir line1 line2 h2 want
  dir="$(dirname "$f")"
  line1="$(sed -n 1p "$f")"
  line2="$(sed -n 2p "$f")"
  [[ "$line1" == "@./CONTEXT.md" ]] || report SHAPE "$rel" "line 1 is not @./CONTEXT.md"
  if [[ -f "$dir/REFERENCES.md" ]]; then
    [[ "$line2" == "@./REFERENCES.md" ]] ||
      report SHAPE "$rel" "REFERENCES.md sits beside it, so line 2 should be @./REFERENCES.md"
  elif [[ "$line2" == "@./REFERENCES.md" ]]; then
    report SHAPE "$rel" "line 2 imports @./REFERENCES.md, but there is no REFERENCES.md here"
  fi
  headings "$f" | grep -q '^# CLAUDE\.md — ' ||
    report SHAPE "$rel" "no H1 of the form '# CLAUDE.md — <path>/'"
  grep -q '^Read order:' "$f" || report SHAPE "$rel" "no 'Read order:' line"
  h2="$(headings "$f" | grep '^## ' | paste -sd'|' -)"
  want="## Purpose (one line)|## How to work here|## Guardrails|## Output & naming"
  [[ "$h2" == "$want" ]] ||
    report SHAPE "$rel" "H2s are '${h2:-none}', expected exactly: ${want//|/ · }"
  if grep -qE '(├|└)──' "$f"; then
    report SHAPE "$rel" "contains a directory tree (trees belong in CONTEXT.md)"
  fi
}

check_context() { # check_context <repo-relative path>
  local rel="$1" f="$ROOT/$1" banned
  headings "$f" | grep -qx '## Directory Tree' || report SHAPE "$rel" "no '## Directory Tree' section"
  banned="$(headings "$f" | sed 's/^#* //' |
    grep -ixE 'rules|guardrails|constraints|requirements|prerequisites|standards|conventions|definition of done' |
    paste -sd',' - || true)"
  [[ -z "$banned" ]] || report SHAPE "$rel" "banned heading(s) in a CONTEXT.md: $banned (move to CLAUDE.md)"
}

# ---------------------------------------------------------------------------------------
# --self-test: a scratch tree whose right answer is known
# ---------------------------------------------------------------------------------------

# good_pair <dir> — write a CONTEXT.md + CLAUDE.md that pass every shape check.
# (The backticks in the printf formats below are a literal Markdown code fence.)
# shellcheck disable=SC2016
good_pair() {
  mkdir -p "$1"
  printf '# %s/ — Demo\n\nWhy this folder exists.\n\n## Directory Tree\n\n```text\n%s/\n```\n\n## Cross-references\n\n- none\n' \
    "$1" "$1" >"$1/CONTEXT.md"
  printf '@./CONTEXT.md\n\n# CLAUDE.md — %s/\n\nRead order: this file.\n\n## Purpose (one line)\n\nDemo.\n\n## How to work here\n\n- demo\n\n## Guardrails\n\n- **Demo.**\n\n## Output & naming\n\n- demo\n' \
    "$1" >"$1/CLAUDE.md"
}

run_self_test() {
  local tmp rc out got want
  tmp="$(mktemp -d)"
  # shellcheck disable=SC2064  # expand $tmp now: it is local to this function
  trap "rm -rf '$tmp'" EXIT
  (
    cd "$tmp"
    # shellcheck disable=SC2016  # a literal Markdown code fence, not a command substitution
    printf '# Root\n\n## Directory Tree\n\n```text\n./\n```\n' >CONTEXT.md # root: CONTEXT.md only
    for d in good code code/src code/src/c code/src/c/ms001-hello; do good_pair "$d"; done
    mkdir -p code/src/c/mk code/src/c/ms001-hello/build .claude/skills/teach
    : >code/src/c/mk/flags.mk                  # exempt support folder
    : >code/src/c/ms001-hello/build/greet.o    # exempt build output
    : >.claude/skills/teach/SKILL.md           # exempt skill folder
    good_pair .claude
    good_pair .claude/skills
    good_pair missing-claude && rm missing-claude/CLAUDE.md           # MISSING
    good_pair bad-h2s && sed -i '/^## Guardrails/d' bad-h2s/CLAUDE.md # SHAPE
    good_pair banned && printf '\n## Rules\n\n- no\n' >>banned/CONTEXT.md # SHAPE
    good_pair tree && printf '\n├── x  ← a tree\n' >>tree/CLAUDE.md    # SHAPE
  )
  command -v git >/dev/null 2>&1 && git -C "$tmp" init -q

  bold "docs-pairing self-test"
  local bad=0
  rc=0
  out="$(DOCS_PAIRING_ROOT="$tmp" bash "$SCRIPT_SELF" 2>&1)" || rc=$?
  got="$(printf '%s\n' "$out" | awk '$1 == "MISSING" || $1 == "SHAPE" { print $1 ":" $2 }' | sort -u | paste -sd' ' -)"
  want="MISSING:missing-claude/ SHAPE:bad-h2s/CLAUDE.md SHAPE:banned/CONTEXT.md SHAPE:tree/CLAUDE.md"
  if [[ $rc -eq 1 ]]; then log "  ok    broken pairs make the run exit 1"; else log "  FAIL  expected exit 1, got $rc"; bad=1; fi
  if [[ "$got" == "$want" ]]; then
    log "  ok    exactly the four planted problems are reported (exempt folders are not)"
  else
    log "  FAIL  reported: ${got:-nothing}"
    log "        expected: $want"
    bad=1
  fi

  rm -rf "$tmp/missing-claude" "$tmp/bad-h2s" "$tmp/banned" "$tmp/tree"
  rc=0
  out="$(DOCS_PAIRING_ROOT="$tmp" bash "$SCRIPT_SELF" 2>&1)" || rc=$?
  if [[ $rc -eq 0 ]]; then log "  ok    a clean tree passes with exit 0"; else log "  FAIL  clean tree gave exit $rc"; bad=1; fi

  if [[ $bad -ne 0 ]]; then
    printf '%s\n' "$out" >&2
    bold "FAIL: docs-pairing self-test — the gate cannot be trusted" >&2
    exit 1
  fi
  bold "PASS: docs-pairing self-test"
  exit 0
}

$self_test && run_self_test

# ---------------------------------------------------------------------------------------
# The real run
# ---------------------------------------------------------------------------------------

[[ -z "$scope" || -d "$ROOT/$scope" ]] || die "--path '$scope' is not a directory under the repository root"
load_exemptions

mapfile -t dirs < <(list_dirs | sort -u)
checked=0
for d in "${dirs[@]}"; do
  [[ -d "$ROOT/$d" ]] || continue
  in_scope "$d" || continue
  is_exempt "$d" && continue
  checked=$((checked + 1))
  [[ -f "$ROOT/$d/CONTEXT.md" ]] || report MISSING "$d/" "no CONTEXT.md"
  [[ -f "$ROOT/$d/CLAUDE.md" ]] || report MISSING "$d/" "no CLAUDE.md"
done

files=0
while IFS= read -r f; do
  [[ -f "$ROOT/$f" ]] || continue
  in_scope "$f" || continue
  case "$f" in
  .claude/CLAUDE.md) continue ;; # the manual: its own shape, owned by itself
  CLAUDE.md | */CLAUDE.md) check_claude "$f" ;;
  CONTEXT.md | */CONTEXT.md) check_context "$f" ;;
  *) continue ;;
  esac
  files=$((files + 1))
done < <(list_files | sort -u)

log "docs-pairing: $checked directories need a pair; $files CONTEXT.md/CLAUDE.md files shape-checked"
if ((problems > 0)); then
  bold "FAIL: $problems problem(s). Rule: code/docs/DOCUMENTATION-PAIRING.md" >&2
  exit 1
fi
bold "PASS: every directory is paired and every pair is in shape."
