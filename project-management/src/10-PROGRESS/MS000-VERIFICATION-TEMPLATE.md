# VERIFICATION: MS000 — {Milestone Title}

_Template — copy to `MS###-VERIFICATION.md`, replace every `{PLACEHOLDER}`, delete the `[EXAMPLE]` rows
and the guidance comments. The evidence that one milestone's gates passed: every command, its exit code
and its summary lines pasted as printed, with the toolchain that produced them, so anyone can rerun the
same commands and compare._

| Field | Value |
| --- | --- |
| **Milestone** | MS### — {title} · `project-management/src/02-MILESTONES/MS###-{TITLE}.md` |
| **Plan** | `project-management/src/09-MILESTONE-PLANS/{NN}-PLAN-MS###-{DESCRIPTOR}.md` |
| **Branch** | `ms###/{short-kebab}` |
| **Commit** | `{short hash}` — `git rev-parse --short HEAD` at the start of the run |
| **Verified on** | {DD/MM/YYYY} |
| **Verified by** | Sam Bailey, through `project-management/workflows/11-verification/` |
| **Supports** | {`Verifying` / `In Progress` / `Blocked`} — see Section 5 |

<!-- One record per milestone. A re-run overwrites it: the file always describes the latest full run,
     and git keeps every earlier one. Never append a second dated run below the first.
     What clean output looks like, flag by flag: project-management/docs/VERIFICATION-GUIDE.md →
     "The commands, by flag" and "Reading a clean run correctly". Not restated here.
     Paste output as printed, trimmed to the summary lines; replace any absolute home path in it with
     the repo-relative path before committing — this repository is public. -->

---

## 1. What was verified

**Scope.** {The exercises and crates this milestone built, e.g. `code/src/c/ms###-{kebab}/` and
`code/src/rust/crates/ms###_{snake}/`, and the FLAGS rows that are not `N/A`.}

**Toolchain.** Pasted from `bash code/src/scripts/toolchain/check.sh` (exit `{0}`):

| Tool | Version |
| --- | --- |
| [EXAMPLE] gcc | 13.3.0 |
| [EXAMPLE] make | 4.3 |
| [EXAMPLE] gdb | 15.1 |
| [EXAMPLE] valgrind | 3.22.0 |
| [EXAMPLE] rustc | 1.92.0 |
| {tool} | {version as printed} |

---

## 2. Results

### 2.1 Gates

One row per gate whose flag is not `N/A`: the raw command first, then the script that wraps it.
**Exit** is the number the command returned. For a script row it follows the repository's contract —
`0` pass, `1` failures, `2` could not run — and a `2` is never a pass. A raw row carries the tool's own
code: `0` is a pass for all of them, but GNU make exits `2` on any failure and `cargo test` exits `101`,
so a non-zero raw exit is read from its evidence, and its script row says which it was.

| Flag | Gate | Command | Exit | Evidence (pasted) |
| --- | --- | --- | --- | --- |
| Tests | C tests | `make -C code/src/c test` | {0} | [EXAMPLE] `check: 4 passed, 0 failed` |
| Tests | C tests (script) | `bash code/src/scripts/c/test.sh` | {0} | {last line} |
| Memory | ASan + UBSan | `make -C code/src/c san` | {0} | [EXAMPLE] no `ERROR: AddressSanitizer`, no `runtime error:` |
| Memory | valgrind | `make -C code/src/c memcheck` | {0} | [EXAMPLE] `ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)` |
| Lint | gcc analyser | `make -C code/src/c lint` | {0} | [EXAMPLE] no `analyzer-` diagnostic (under `-Werror`, `[-Werror=analyzer-…]`) |
| Tests | Rust tests | `(cd code/src/rust && cargo test)` | {0} | [EXAMPLE] `test result: ok. 3 passed; 0 failed; ...` |
| Lint | rustfmt | `(cd code/src/rust && cargo fmt --all --check)` | {0} | [EXAMPLE] no diff printed |
| Lint | clippy | `(cd code/src/rust && cargo clippy --all-targets -- -D warnings)` | {0} | [EXAMPLE] no `warning:` or `error:` line |
| QEMU | boot smoke test | {the `qemu-system-x86_64` line from the milestone} | {0} | {the serial-console line that proves the boot} |
| All | full suite | `bash code/src/scripts/gates/all.sh` | {0} | {the summary table's worst row} |

### 2.2 Skipped flags

| Flag | Reason (copied from the milestone) |
| --- | --- |
| [EXAMPLE] QEMU | N/A — no kernel boots before P4 |
| {flag} | {reason} |

### 2.3 Per test binary

<!-- (C milestones) One row per test binary, so a leak or a failure names its binary. "Seen red" records
     that each test was watched failing for the predicted reason before it passed
     (code/workflows/02-tdd-cycle/): a test that has never failed has not been tested. -->

| Exercise | Test binary | `check:` line | valgrind `ERROR SUMMARY` | Heap summary | Seen red |
| --- | --- | --- | --- | --- | --- |
| [EXAMPLE] `ms###-{kebab}` | `build/test_{unit}` | `check: 4 passed, 0 failed` | `0 errors from 0 contexts` | `All heap blocks were freed -- no leaks are possible` | Yes |

### 2.4 Debugger walkthrough

<!-- Keep when the Debugger flag is not N/A; otherwise list it under 2.2. -->

**Walkthrough asked for:** {the gdb task the flag names}.

```text
{the gdb commands typed and a short transcript excerpt showing what the milestone predicted}
```

### 2.5 QEMU boot

<!-- Keep when the QEMU flag is not N/A. Kernels and modules run in QEMU only, never on the host
     (.claude/CLAUDE.md owns the rule). -->

```text
{the exact qemu-system-x86_64 command line, then the serial-console lines that prove the boot}
```

### 2.6 Explain-back

| Question | Learner's answer (own words, no notes) | Named what the criterion asked? |
| --- | --- | --- |
| {the explain-back scenario from the milestone} | {answer} | {Yes / No — and what was missing} |

---

## 3. How to reproduce

From a clean checkout of the commit above, in this order:

```bash
git switch --detach {short hash}
bash code/src/scripts/toolchain/check.sh
make -C code/src/c clean
make -C code/src/c test
make -C code/src/c san
make -C code/src/c memcheck
make -C code/src/c lint
(cd code/src/rust && cargo fmt --all --check && cargo clippy --all-targets -- -D warnings && cargo test)
bash code/src/scripts/gates/all.sh
```

{Any milestone-specific step — seed files, a kernel build from the `06-KERNEL` plan, a QEMU command —
added in the order it runs.}

---

## 4. Outstanding gaps

Anything that failed, could not run, or passed with a caveat, each with the register entry that tracks
it. "None." is a valid entry.

| Item | Type | Tracked in |
| --- | --- | --- |
| [EXAMPLE] QEMU boot | Could not run — `flex` and `bison` missing | `GAPS.md` → {entry title} |
| [EXAMPLE] `-O2` warning sweep | Passed with a caveat — run once, not gated | `DEFERRED.md` → `DEFERRED (MS###)` |

---

## 5. Status line

<!-- The milestone status this record supports, in the words owned by
     project-management/docs/planning/MILESTONES.md → Statuses. This record never sets `Completed`:
     that follows the merge at project-management/workflows/13-pr-and-merge/. -->

**Supports `{Verifying}`** — {N} C checks and {N} Rust tests pass; sanitisers, valgrind and lints clean;
explain-back {answered}; verified {DD/MM/YYYY} at `{short hash}`.

<!-- Alternatives:
     Supports `In Progress` — {gate} failed; `project-management/src/13-BUGS/BUG-MS###-{DESCRIPTOR}-DD-MM-YYYY.md`.
     Supports `Blocked` — {gate} could not run; `GAPS.md` → {entry title}. -->

---

## Cross-references

- `project-management/src/02-MILESTONES/MS###-{TITLE}.md` — the milestone and its mastery criteria
- `project-management/src/09-MILESTONE-PLANS/{NN}-PLAN-MS###-{DESCRIPTOR}.md` — the plan whose As-Built
  summary this record fills
- `project-management/docs/VERIFICATION-GUIDE.md` — what counts as proof and what clean output looks like
- `code/workflows/06-memory-check/` — the sanitiser and valgrind procedure
- `how-to/workflows/03-quality-gates/` — `gates/all.sh`, its order and exit codes
- `project-management/src/11-REVIEWS/` · `project-management/src/12-FINDINGS/` — what follows this record
