@./CONTEXT.md

# CLAUDE.md — code/src/scripts/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `code/src/CONTEXT.md` → this folder's
`CONTEXT.md` (every script, what it wraps and what its exit codes mean, imported above) → this file →
the script's own `--help`.

## Purpose (one line)

The gate scripts: every check the repository relies on, each wrapping a raw command in one exit-code
contract — 0 pass, 1 failures, 2 could not run — shared by the learner, Claude and CI.

## How to work here

- **Routing:** running the gates and reading the results → `how-to/workflows/03-quality-gates/`; what a
  C target does → `code/docs/BUILD.md`; the documentation rules the audits enforce →
  `code/docs/DOCUMENTATION-LENGTH.md` and `code/docs/DOCUMENTATION-PAIRING.md`.
- **Teach the raw command, verify with the script:** when explaining, show the command the script wraps
  (its `--help` names it) so the learner learns the tool; when verifying Claude's own work, run the
  script, because only the script separates "failed" (1) from "could not run" (2).
- **Running everything:** `bash code/src/scripts/gates/all.sh` — every scripted gate in order and one
  summary table; `--skip rust/audit` when offline. CI's shell lint, Markdown lint and secrets scan are
  not in it (`how-to/workflows/03-quality-gates/`).
- **Tutor mode:** when a gate fails on the learner's exercise, ask what they think the report means
  before explaining it, and point at the `code/docs/` section that covers the failure; do not fix
  the exercise for them. Changing a script itself is ordinary repository work.
- **Concrete steps to add a script:** pick the folder by concern (`c/`, `rust/`, `audits/`,
  `toolchain/`, `gates/`) → copy the header shape of a sibling (summary, `Usage:` lines, why, the exact
  line `# Exit codes: 0 = pass  1 = failures  2 = script/tool error`) → `set -euo pipefail` and source
  `../_lib/common.sh` → `need_tool` for every tool it calls → map the tool's own exit codes onto 0/1/2 →
  add it to `gates/all.sh` if it is a gate, to the matching `.github/workflows/` file, and to the table
  in this `CONTEXT.md` → `bash -n` and ShellCheck it.
- **Definition of done:** `--help` prints the header; a missing tool exits 2 with an install hint; a
  planted failure exits 1 (an audit proves it with `--self-test`); `bash -n` and ShellCheck are clean,
  as `Syntax — Shell` checks in CI; this `CONTEXT.md` lists the script.

## Guardrails

- **Never report "could not run" as a pass.** A missing tool, a failed download or a bad argument is
  exit 2 and the words COULD NOT RUN — never exit 0, and never exit 1 either, which would blame code
  that was never checked.
- **Prove a detector before trusting it.** An audit ships with a `--self-test` that plants known
  problems in a scratch tree and checks it finds exactly those; run it after any change to the audit.
- **Keep scripts thin.** The logic belongs to the tool (make, cargo, cloc) and the policy to its config
  file (`code/src/c/mk/`, `code/src/rust/*.toml`); a script adds the contract, not a second copy of
  either.
- **Change `docs-pairing.exempt` only alongside `code/docs/DOCUMENTATION-PAIRING.md` Section 7.** The
  guide owns the exemption classes; the glob file is their machine-readable form.
- **Keep scripts public-safe.** No absolute home paths, no secrets, no machine-specific assumptions;
  every path is computed from `PROJECT_ROOT`.

## Output & naming

- **Hand-written:** every `*.sh`, `audits/docs-pairing.exempt`, and this pair.
- **Generated:** nothing is written into the repository — the self-tests build their scratch trees in
  a temporary directory and delete them.
- Scripts `kebab-case.sh`, one verb or noun per concern; the helper library lives in `_lib/` (a leading
  underscore means sourced, never run); indentation is two spaces (`.editorconfig`).
