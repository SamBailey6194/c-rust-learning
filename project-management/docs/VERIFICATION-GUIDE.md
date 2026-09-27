---
type: guide
---

# Verification Guide — c-rust-learning

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

How mastery is proved here: which commands prove which flag, what a clean result actually looks like,
and what goes into the milestone's verification record in `project-management/src/10-PROGRESS/`. The
procedure that runs all of this is `project-management/workflows/11-verification/`; this guide defines
what counts as proof, and that workflow sequences it.

---

## Three kinds of proof

A milestone is `Completed` only when all three hold (status rules:
`project-management/docs/planning/MILESTONES.md` → _Statuses_):

1. **The gates pass.** Every flag that is not `N/A` has run its command, and the command exited `0`.
2. **The evidence is written down.** The commands, their exit codes and their summary lines are in the
   milestone's `10-PROGRESS` record, so anyone can rerun them and compare.
3. **The learner can explain it.** Passing tests prove the code works; they do not prove the concept is
   understood. The explain-back scenario in the mastery criteria is answered without notes, and the
   answer is recorded.

The first two are mechanical, and the third is the point. A milestone that passes every gate but cannot
be explained is `Verifying`, not `Completed`.

---

## The commands, by flag

**The command is the lesson.** Run the raw command first and read its output; the script beside it
wraps the same command and is what CI and the full gate run use. Targets and flags are owned by
`code/docs/BUILD.md`; the gate order by `how-to/workflows/03-quality-gates/`.

| Flag | Raw command | Script | Clean looks like |
| --- | --- | --- | --- |
| Tests (C) | `make -C code/src/c/ms007-dynamic-array test` | `bash code/src/scripts/c/test.sh` | exit `0`; each test binary prints `check: N passed, 0 failed` |
| Tests (Rust) | `cargo test` in `code/src/rust/` | `bash code/src/scripts/rust/test.sh` | exit `0`; every suite ends `test result: ok.` with `0 failed` |
| Memory (C) | `make -C code/src/c/ms007-dynamic-array san` | `bash code/src/scripts/c/san.sh` | exit `0`; no `ERROR: AddressSanitizer` block, no `runtime error:` line |
| Memory (C) | `make -C code/src/c/ms007-dynamic-array memcheck` | `bash code/src/scripts/c/memcheck.sh` | exit `0`; `ERROR SUMMARY: 0 errors from 0 contexts` and `All heap blocks were freed -- no leaks are possible` |
| Lint (C) | `make -C code/src/c/ms007-dynamic-array lint` | `bash code/src/scripts/c/lint.sh` | exit `0`; no `analyzer-` diagnostic (under `-Werror` one prints as `[-Werror=analyzer-…]` and fails the build) |
| Lint (Rust) | `cargo fmt --check` and `cargo clippy --all-targets -- -D warnings` in `code/src/rust/` | `bash code/src/scripts/rust/lint.sh` | both exit `0` with no diff and no warning |
| Debugger | a gdb session: `break`, `run`, `bt`, `print`, `watch` on the milestone's code | none: it is a walkthrough | a transcript excerpt showing the thing the milestone predicted |
| QEMU | `qemu-system-x86_64` with the command line from the milestone's `06-KERNEL` plan | none yet (planned at P4) | the serial console reaches the expected line (a busybox shell prompt, a module's `pr_info` message) |
| Notes | the `learning/` note exists and answers the recall question | — | the explain-back answer, recorded |
| Research | the `research/` note exists, one question, a citation per claim | — | the note path, cited from the spec or ADR it fed |

The full gate set in one go is `bash code/src/scripts/gates/all.sh`, which prints a summary table and
exits with the worst code any gate returned.

---

## Reading a clean run correctly

Most false "passes" come from misreading the output, not from the tools.

- **Exit `2` is not a pass.** Every script exits `0` (pass), `1` (failures) or `2` (could not run:
  a tool is missing or the script itself failed). A gate that could not run has proved nothing; install
  the tool (`how-to/workflows/01-toolchain-setup/`) or record the gap in `GAPS.md`.
- **UndefinedBehaviorSanitizer (UBSan) carries on by default.** A binary built with `-fsanitize=undefined`
  alone prints `runtime error: ...` and still exits `0`. The repository's `san` target adds
  `-fno-sanitize-recover=all` (`code/src/c/mk/flags.mk`) so the first report is fatal; a sanitised
  binary you build by hand does not, so read its output rather than trusting its exit code, or run it
  with `UBSAN_OPTIONS=halt_on_error=1`.
- **ASan and valgrind never share a binary.** `memcheck` runs the plain build in `build/`, `san` its own
  build in `build/san/`. Running valgrind on a sanitised binary produces noise, not evidence.
- **Each memory tool is blind somewhere.** valgrind does not see overruns of stack or global arrays;
  AddressSanitizer does not see reads of uninitialised memory. That is why the Memory flag runs both
  (`project-management/docs/SAFETY-GUIDE.md` → _C — undefined behaviour and memory bugs_).
- **`-O0` hides a few warnings.** Some diagnostics only fire when the optimiser runs; an occasional
  `make -C <exercise> clean all DBG="-g3 -O2"` is cheap insurance, and a new warning it finds is a finding.
- **A test that has never failed has not been tested.** The red step of `code/workflows/02-tdd-cycle/`
  is part of the evidence: the record says the test was seen to fail for the predicted reason.

---

## The verification record

One record per milestone, copied from
`project-management/src/10-PROGRESS/MS000-VERIFICATION-TEMPLATE.md` and named by that folder's
`CLAUDE.md` → _Output & naming_. It holds:

- **What was verified** — the milestone, the commit (`git rev-parse --short HEAD`) and the date.
- **The toolchain** — the table `bash code/src/scripts/toolchain/check.sh` prints, so the result can be
  tied to the exact gcc, valgrind and rustc versions that produced it.
- **Results, per flag** — for each flag that is not `N/A`: the command, its exit code, and the one or
  two summary lines from the table above, pasted, not paraphrased. `N/A` flags are listed as skipped,
  with the milestone's reason.
- **The explain-back** — the question, the learner's answer in their own words, and whether it named
  what the mastery criterion asked for.
- **How to reproduce** — the commands, in order, from a clean checkout.
- **Outstanding gaps** — anything that passed with a caveat, with the `GAPS.md` or `DEFERRED.md` entry
  that tracks it.
- **Status line** — the milestone status this record supports.

A record is evidence only if it can be rerun. "Tests pass" is a claim; `make -C
code/src/c/ms007-dynamic-array test` → exit `0`, `check: 14 passed, 0 failed` is evidence.

---

## When verification fails

A failing gate sends the milestone back to `In Progress`; that is information, not a setback. A defect
that took real investigation gets a record in `project-management/src/13-BUGS/` through
`code/workflows/07-debug/`, and a misconception the failure exposed is carried to
`project-management/src/12-FINDINGS/` by `12-review-and-reflect`. Then verification runs again from the
top: a partial rerun proves only the part that was rerun.

---

## Related

- `project-management/workflows/11-verification/` — the procedure that runs these checks and writes the record
- `how-to/workflows/03-quality-gates/` — the gate commands and their order
- `code/docs/TESTING.md` — the `check.h` harness and Rust test layout
- `code/docs/MEMORY-SAFETY.md` — the memory-bug classes behind the Memory flag
- `code/docs/DEBUGGING.md` — gdb and valgrind in depth
- `project-management/docs/SAFETY-GUIDE.md` — what a milestone has to plan for before any of this runs
