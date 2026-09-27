# BUG: MS000 — {One-line defect title}

_Template — copy to `BUG-MS###-<DESCRIPTOR>-DD-MM-YYYY.md`, replace every `{PLACEHOLDER}`, delete the
`[EXAMPLE]` rows and the guidance comments. One defect in the code a milestone built, recorded with its
reproduction, the evidence behind its root cause, the fix, and the regression test — written first — that
keeps it fixed._

> A defect not owned by one milestone — a script under `code/src/scripts/`, a CI workflow, the shared rules
> in `code/src/c/mk/` — uses `BUG-<DESCRIPTOR>-DD-MM-YYYY.md` and marks the milestone rows
> `N/A — cross-cutting`.

| Field | Value |
| --- | --- |
| **Milestone** | MS### — {title} · `project-management/src/02-MILESTONES/MS###-{TITLE}.md` |
| **Plan** | `project-management/src/09-MILESTONE-PLANS/{NN}-PLAN-MS###-{DESCRIPTOR}.md` |
| **Where** | `code/src/c/ms###-{kebab}/{file}.c:{line}` / `code/src/rust/crates/ms###_{snake}/src/{file}.rs:{line}` |
| **Severity** | {Critical / High / Medium / Low} |
| **Date found** | {DD/MM/YYYY} |
| **Found during** | {build / `make test` / `make san` / `make memcheck` / review R-0NN / verification / QEMU boot} |
| **Fix state** | {Open / Fixed / Verified} |
| **Last Updated** | {DD/MM/YYYY} |

<!-- Severity: Critical — memory corruption or undefined behaviour, or a kernel panic in the QEMU guest;
     High — a wrong result on a case the spec lists; Medium — a wrong result on an edge case, or a leak;
     Low — a wrong message or a cosmetic fault.
     Fix state is this record's own: Open → Fixed (the fix is committed, code/workflows/07-debug/ Step 7)
     → Verified (the regression test and the full gate suite passed in the milestone's verification; set
     in the final commit of project-management/workflows/13-pr-and-merge/, so it reaches main with the
     merge). The milestone's status is separate and owned by
     project-management/docs/planning/MILESTONES.md. -->

---

## 1. Summary

{One line: what breaks, where, and what can be observed.}

_[EXAMPLE] `{function}()` in `code/src/c/ms###-{kebab}/{file}.c` writes one byte past its buffer when the
input is exactly {N} characters long, so `make memcheck` reports an invalid write._

## 2. Environment

<!-- Enough to rule out "only on my machine". Commands in brackets print each value. -->

| Aspect | Value |
| --- | --- |
| **Host** | {Ubuntu 24.04, x86_64} |
| **Commit** | `{short hash}` (`git rev-parse --short HEAD`) |
| **gcc** | {13.3.0} (`gcc --version`) |
| **Flags** | {`CSTD`, `WARN`, `DBG` from `code/src/c/mk/flags.mk`, or the exact command line} |
| **Build variant and -O level** | {plain `build/` / sanitised `build/san/` / an `-O2` sweep} · {-O0} |
| **valgrind** | {3.22.0} (`valgrind --version`) |
| **rustc / cargo** | {1.92.0} (`rustc -vV`, run inside `code/src/rust/`) |
| **Kernel / QEMU** | {kernel version and config fragment · `qemu-system-x86_64 --version`} — P4 onwards |

## 3. Reproduction steps

<!-- Numbered and deterministic, from a clean checkout. A kernel or module defect reproduces inside the
     QEMU guest only (.claude/CLAUDE.md owns the rule). -->

1. `git switch --detach {short hash}`
2. `make -C code/src/c/ms###-{kebab} clean test`
3. {the input or action that triggers the defect}
4. Observe: {the wrong outcome}

## 4. Expected vs Actual

| | Behaviour |
| --- | --- |
| **Expected** | {what the spec or the function's contract says should happen} |
| **Actual** | {what happens instead} |

## 5. Root-cause analysis

<!-- Evidence first, then the cause. Paste a trimmed excerpt from gdb, valgrind or a sanitiser — the
     lines that locate the fault — with absolute home paths replaced by repo-relative ones. Trace the
     cause to the line responsible, and say why no existing test caught it. -->

```text
[EXAMPLE]
==12345== Invalid write of size 1
==12345==    at 0x...: {function} ({file}.c:{line})
==12345==  Address 0x... is 0 bytes after a block of size 10 alloc'd
==12345==    at 0x...: malloc (in .../vgpreload_memcheck-amd64-linux.so)
```

**Cause.** {Why it happens — the underlying mistake, not the symptom.}

_[EXAMPLE] The loop bound uses `<=` where the buffer holds `len` bytes, so the last iteration writes
`buf[len]`. No test used an input of exactly the buffer's length._

| File | Lines | What is wrong there |
| --- | --- | --- |
| [EXAMPLE] `code/src/c/ms###-{kebab}/{file}.c` | {a–b} | {the off-by-one bound} |

**Misconception behind it?** {If the defect came from a wrong belief, name it — it becomes a candidate
for `project-management/src/12-FINDINGS/`.}

## 6. The fix

<!-- The learner writes the fix (tutor mode). This record describes the approach and points at the
     commit; it holds no diff. -->

**Approach:** {one or two lines — the corrected logic, bound or check}.

**Files touched:**

- [EXAMPLE] `code/src/c/ms###-{kebab}/{file}.c` — {what changed}
- **Commit:** `{short hash}`

## 7. Regression test — written first

Follow `code/workflows/07-debug/`: write the test that reproduces the defect, **watch it fail for the
predicted reason, then** fix the code and watch it pass. The test is what proves the bug is dead and
keeps it dead.

| Test | Location | Asserts |
| --- | --- | --- |
| [EXAMPLE] `test_{unit}_input_fills_buffer_exactly` | `code/src/c/ms###-{kebab}/test_{unit}.c` | {the boundary case returns the right value and stays in bounds} |

- **Red:** {the failing output before the fix — the `check:` line, or the valgrind or sanitiser report}
- **Green:** {the same test passing after the fix}

## 8. Impact

- **Blast radius:** {this function only / every exercise that copied the pattern / shared `mk/` rules}
- **Related records:** {`project-management/src/11-REVIEWS/REVIEW-MS###-{DESCRIPTOR}.md` → R-0NN ·
  `project-management/src/10-PROGRESS/MS###-VERIFICATION.md`}
- **Same pattern elsewhere?** {searched with `grep -rn '{pattern}' code/src/` — result}

## 9. Verification

```bash
make -C code/src/c/ms###-{kebab} test san memcheck lint
bash code/src/scripts/gates/all.sh
```

- [ ] Regression test written first, seen to fail for the predicted reason, now passing
- [ ] `make ... san` and `make ... memcheck` clean for the exercise
- [ ] `bash code/src/scripts/gates/all.sh` exits 0
- [ ] Root cause fixed, not the symptom masked
- [ ] **Fix state** set to `Fixed` on commit, then `Verified` once merged and re-verified
- [ ] Milestone re-verified from the first step of `project-management/workflows/11-verification/`

---

## Cross-references

- `code/workflows/07-debug/` — the procedure: reproduce, failing test first, root cause, fix
- `code/docs/DEBUGGING.md` · `code/docs/MEMORY-SAFETY.md` — gdb, valgrind and the sanitisers
- `project-management/src/10-PROGRESS/MS###-VERIFICATION.md` — the verification the fix reruns
- `project-management/src/11-REVIEWS/` — the review that may have raised it
- `project-management/src/12-FINDINGS/` — where the misconception behind it is recorded
