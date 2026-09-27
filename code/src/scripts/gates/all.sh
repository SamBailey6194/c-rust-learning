#!/usr/bin/env bash
#
# all.sh — run every quality gate in order, then print one summary table.
#
# Usage:
#   all.sh                     run every gate below
#   all.sh --skip rust/audit   leave one gate out (repeatable); it shows as SKIPPED
#   all.sh --help              print this header
#
# Gates, in order (each is a script beside this folder):
#   toolchain/check   c/build   c/test   c/san   c/memcheck   c/lint
#   rust/build   rust/test   rust/lint   rust/audit
#   audits/docs-length   audits/docs-pairing
#
# Every gate runs even after one fails, so a single pass shows everything that needs
# attention. The summary marks each gate PASS (0), FAIL (1) or COULD NOT RUN (2), and the
# script exits with the worst of them: 2 beats 1 beats 0. A gate that could not run is
# never counted as a pass. The procedure around this script is
# how-to/workflows/03-quality-gates/.
#
# Exit codes: 0 = pass  1 = failures  2 = script/tool error
set -euo pipefail
# shellcheck source-path=SCRIPTDIR source=../_lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/../_lib/common.sh"

GATES=(
  toolchain/check
  c/build c/test c/san c/memcheck c/lint
  rust/build rust/test rust/lint rust/audit
  audits/docs-length audits/docs-pairing
)

skip=()
while [[ $# -gt 0 ]]; do
  case "$1" in
  --skip)
    [[ $# -ge 2 ]] || die "--skip needs a gate name, e.g. --skip rust/audit"
    [[ " ${GATES[*]} " == *" $2 "* ]] || die "no gate called '$2' (gates: ${GATES[*]})"
    skip+=("$2")
    shift 2
    ;;
  --help | -h) print_help; exit 0 ;;
  *) die "unknown option '$1' (see --help)" ;;
  esac
done

scripts_dir="$(cd "$(dirname "$SCRIPT_SELF")/.." && pwd)"
results=()
worst=0

for gate in "${GATES[@]}"; do
  if [[ " ${skip[*]} " == *" $gate "* ]]; then
    results+=("$gate|SKIPPED (by request)")
    continue
  fi
  log ""
  bold "################ $gate ################"
  rc=0
  bash "$scripts_dir/$gate.sh" || rc=$?
  case "$rc" in
  0) results+=("$gate|PASS") ;;
  1) results+=("$gate|FAIL") ;;
  *) results+=("$gate|COULD NOT RUN (exit $rc)"); rc=2 ;;
  esac
  if ((rc > worst)); then worst=$rc; fi
done

log ""
bold "Quality gates — summary"
log ""
printf '| Gate | Result |\n| --- | --- |\n'
for row in "${results[@]}"; do
  printf '| %s | %s |\n' "${row%%|*}" "${row#*|}"
done
log ""
case "$worst" in
0) bold "ALL GATES PASS" ;;
1) bold "SOME GATES FAILED — fix the FAIL rows above" ;;
*) bold "SOME GATES COULD NOT RUN — install what they asked for, then re-run" ;;
esac
exit "$worst"
