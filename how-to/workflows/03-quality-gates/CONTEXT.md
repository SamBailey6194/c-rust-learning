# Workflow: Quality Gates

**Last Updated**: 27/09/2026

The same gates run here and in CI. Running them locally first turns a red pipeline into a failure you
can read in the terminal a minute after you caused it, while the change is still in your head. This
folder owns the gate list; every other file cites it.

## Directory Tree

```text
how-to/workflows/03-quality-gates/
├── CONTEXT.md · CLAUDE.md   ← when to use, the gate list (this file) · operating rules
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← one box per gate, plus the exit-code contract
```

## When to use this

- Before every commit that touches `code/`, and at the end of every study session
  (`how-to/workflows/02-daily-study-session/` Step 7).
- Before raising a pull request (`project-management/workflows/13-pr-and-merge/`).
- When CI has gone red and the failure needs reproducing locally.
- As the gate evidence for a milestone's verification record
  (`project-management/workflows/11-verification/`).

## The gate list

Each gate has a raw command (the lesson) and the script that wraps it (what CI and Claude run). Run C
commands from the repository root and Rust commands from inside `code/src/rust/`, so the toolchain pin
applies. Scripts live under `code/src/scripts/`.

| # | Gate | Raw command | Script | CI workflow |
| --- | --- | --- | --- | --- |
| 1 | C build, warnings as errors | `make -C code/src/c` | `c/build.sh` | Syntax — C |
| 2 | C tests | `make -C code/src/c test` | `c/test.sh` | Syntax — C |
| 3 | C sanitisers (ASan + UBSan) | `make -C code/src/c san` | `c/san.sh` | Syntax — C |
| 4 | C memcheck (valgrind) | `make -C code/src/c memcheck` | `c/memcheck.sh` | Syntax — C |
| 5 | C static analysis (`-fanalyzer`) | `make -C code/src/c lint` | `c/lint.sh` | Syntax — C |
| 6 | Rust build | `cargo build --all-targets` | `rust/build.sh` | Syntax — Rust |
| 7 | Rust tests | `cargo test` | `rust/test.sh` | Syntax — Rust |
| 8 | Rust format and lints | `cargo fmt --check` · `cargo clippy --all-targets -- -D warnings` | `rust/lint.sh` | Syntax — Rust |
| 9 | Rust dependency audit | `cargo deny check` | `rust/audit.sh` | Syntax — Rust |
| 10 | Docs length (≤ 300 cloc lines) | `cloc --include-lang=Markdown --quiet --csv <file>` | `audits/docs-length.sh` | Audit — Docs |
| 11 | Docs pairing (CONTEXT + CLAUDE) | — (script only) | `audits/docs-pairing.sh` | Audit — Docs |
| 12 | Shell lint | `shellcheck -x` over every `*.sh` | — | Syntax — Shell |
| 13 | Markdown lint | `npx --yes markdownlint-cli2` (from the root) | — | Markdown — Lint |
| 14 | Secrets scan (TruffleHog) | — | — | Audit — Secrets |

Gates 1 to 11 run locally, together, through the one-shot `code/src/scripts/gates/all.sh`. It starts with
the pre-flight `toolchain/check.sh` (a row in its summary, not a numbered gate), runs every gate even after
one fails, and prints one summary table. Gates 12 to 14 are CI gates; 12 and 13 can also run locally when
the tool is available (shellcheck is not installed on this machine yet; markdownlint-cli2 runs through
`npx`, and the root `.markdownlint-cli2.jsonc` supplies the file globs).

## Key concepts

- **One exit-code contract.** Every script exits 0 (pass), 1 (failures) or 2 (could not run: a tool is
  missing or the script itself broke). Exit 2 is not green. `gates/all.sh` marks each row PASS, FAIL or
  COULD NOT RUN and exits with the worst code it saw, where 2 outranks 1 and 1 outranks 0. A gate left out
  with `--skip` shows as SKIPPED, which is not a pass either.
- **Cheapest first.** C before Rust before docs, and within C the build before the slower runtime checks,
  so the fastest failure surfaces soonest.
- **ASan and valgrind use separate binaries.** `san` builds into `build/san/`; `memcheck` runs valgrind
  on the plain build in `build/`. Under valgrind an ASan binary stops before `main` runs.
- **Read the output as well as the exit code.** The summary table says which gate failed; the report above
  it says why. A gate that printed nothing it normally prints deserves a second look.
- **Local mirrors CI.** The CI workflows in `.github/workflows/` call the same scripts on `ubuntu-24.04`
  for gates 1 to 11, and run gates 12 to 14 with their tools directly.
  When local and CI disagree, the disagreement is the bug to fix.
- **Form, not judgement.** Green gates say the code builds, passes its tests and is memory-clean. Whether
  it is good code is `code/workflows/05-review/`.

## Cross-references

### Governing documents

- `code/docs/BUILD.md` — the flags and make targets behind gates 1 to 5
- `code/docs/DOCUMENTATION-LENGTH.md` and `code/docs/DOCUMENTATION-PAIRING.md` — the rules gates 10 and 11
  enforce
- `code/src/scripts/CONTEXT.md` — the scripts, their flags and the exit-code contract

### Related reading

- `how-to/docs/CLI-TOOLING.md` — each raw command with its options, grouped by intent
- `code/docs/MEMORY-SAFETY.md` — reading a sanitiser or valgrind report
- `code/workflows/06-memory-check/` — the deeper memory workflow when gate 3 or 4 fails
- `how-to/workflows/05-debugging-environment/` — when a gate exits 2
- `project-management/docs/git/PR-AND-CHECKS.md` — which CI checks a pull request waits for
