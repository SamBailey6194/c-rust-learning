# PLAN-MS000 — {Milestone Title} (Template)

_Template — copy to `<exec-order>-PLAN-MS###-<DESCRIPTOR>.md`, replace every `{PLACEHOLDER}`, delete the
`[EXAMPLE]` rows and the guidance comments. This is the page a milestone is studied and built from:
written at `project-management/workflows/09-milestone-plans/` after the milestone's specs and ADRs, and
before any study starts._

| Field | Value |
| --- | --- |
| **Milestone** | MS### — {title} · `project-management/src/02-MILESTONES/MS###-{TITLE}.md` |
| **Phase · Track** | {P1–P6 / U1–U3 / L1–L6 / S1–S3} — {phase name} · {C / Rust / Kernel / OS / UI / LLM / Security} (`project-management/src/01-ROADMAP/ROADMAP.md`) |
| **Sprint** | `project-management/src/03-STUDY-SPRINTS/SPRINT-##.md` |
| **Exec-order** | {NN} — this milestone's position in the build order of the whole roadmap |
| **Branch** | `ms###/{short-kebab}` |
| **Date** | {DD/MM/YYYY} |
| **Author** | Sam Bailey |
| **Status** | {the milestone's status, copied from its `**Status:**` line} |

<!-- HOW TO USE THIS TEMPLATE (delete this block in the real plan)
  - Filename and the exec-order rule: project-management/src/09-MILESTONE-PLANS/CLAUDE.md →
    Output & naming. 00- belongs to this template alone.
  - Status words are owned by project-management/docs/planning/MILESTONES.md → Statuses; the plan
    mirrors the milestone and never invents a state.
  - Section markers: (always) keep it · (if it applies) keep it or delete it with a one-line reason ·
    (after verification) leave as a stub until 11-verification fills it.
  - The plan is a map, not a solution. No exercise code goes here; code lives in code/src/.
  - Cite and link resources by chapter or section; do not paste their text.
  - Backtick every path, command and identifier. Dates DD/MM/YYYY. -->

---

## Goal and scope

<!-- (always) Two or three sentences. Point at the milestone's "Why this matters" rather than
     restating it; say what this plan adds: the route. -->

**Goal.** {What the learner can do at the end that they cannot do now, in one sentence.}

**Unlocks.** {The next milestone or phase gate that depends on this one.}

**In scope.** {The concepts and exercises this plan covers.}

**Out of scope.** {What is deliberately left out, each item mirrored under Deferred items.}

---

## Starting point

<!-- (always) The Explain-first answers from workflow 09 Step 1, in the learner's own words. The
     prediction becomes risk R-1 below and is checked again at 11-verification Step 1. -->

| Question | Learner's answer |
| --- | --- |
| What do I already know about this? | {answer} |
| Which part do I expect to find hardest, and why? | {answer — becomes risk R-1} |
| Which explain-back scenario closes the milestone? | {the scenario's title from the milestone's Mastery Criteria} |

---

## Inputs

<!-- (always) Every artefact this plan rests on, by full repo-relative path. A flagged spec with no
     file yet means the plan is premature: go back to the spec workflow. -->

| Artefact | Path | Note |
| --- | --- | --- |
| Milestone | `project-management/src/02-MILESTONES/MS###-{TITLE}.md` | mastery criteria and FLAGS |
| Sprint | `project-management/src/03-STUDY-SPRINTS/SPRINT-##.md` | {capacity, neighbours} |
| [EXAMPLE] Exercise spec | `project-management/src/04-EXERCISES/EX-MS###-{TOPIC}.md` | {N exercises} |
| [EXAMPLE] Project spec | `project-management/src/05-PROJECTS/PROJ-MS###-{NAME}.md` | {capstone} |
| [EXAMPLE] Kernel plan | `project-management/src/06-KERNEL/KERNEL-PLAN-MS###-{DESCRIPTOR}.md` | {QEMU only} |
| [EXAMPLE] Decision | `project-management/src/08-DECISIONS/ADR-MS###-{DECISION}-DD-MM-YYYY.md` | {what it settles for this plan} |
| [EXAMPLE] Carried in | `DEFERRED.md` → `DEFERRED (MS###)` · `GAPS.md` → {entry title} | {what it asks of this milestone} |
| [EXAMPLE] Earlier finding | `project-management/src/12-FINDINGS/FINDING-MS###-{DESCRIPTOR}-DD-MM-YYYY.md` | {row carried into this milestone} |

---

## Resources and chapters

<!-- (always) One row per concept, primary sources first: the WG14 working drafts and cppreference
     for C; The Rust Programming Language and the Rust Reference for Rust; docs.kernel.org for the
     kernel; the GNU make, gdb and valgrind manuals for the tools; installed man pages. Name the exact
     chapter or section. The external sources index is the root REFERENCES.md. -->

| Concept | Source | Chapter / section | Before exercise |
| --- | --- | --- | --- |
| [EXAMPLE] Formatted output and truncation | `man 3 snprintf` | RETURN VALUE | 1 |
| [EXAMPLE] Automatic header dependencies | GNU make manual — <https://www.gnu.org/software/make/manual/make.html> | Generating Prerequisites Automatically | 2 |
| [EXAMPLE] Ownership | The Rust Programming Language — <https://doc.rust-lang.org/book/> | Chapter 4 | 3 |
| {concept} | {source and link} | {chapter or section} | {N} |

---

## Exercise order

<!-- (always) Smallest concept first, each exercise building on the last. The spec says WHAT each
     exercise asks; this table says the ORDER, WHERE the code lives and HOW it is built. -->

| # | Exercise | Spec | Code location | Code workflow | Needs first |
| --- | --- | --- | --- | --- | --- |
| 1 | [EXAMPLE] {exercise name} | `project-management/src/04-EXERCISES/EX-MS###-{TOPIC}.md` → Exercise 1 | `code/src/c/ms###-{kebab}/` | `code/workflows/01-c-exercise/` + `02-tdd-cycle/` | {concept; `/teach` session first?} |
| 2 | [EXAMPLE] {crate name} | `project-management/src/04-EXERCISES/EX-MS###-{TOPIC}.md` → Exercise 2 | `code/src/rust/crates/ms###_{snake}/` | `code/workflows/03-rust-exercise/` | {concept} |
| 3 | [EXAMPLE] {FFI bridge} | {spec} | {both locations} | `code/workflows/04-ffi-bridge/` | {concept} |

**Study notes.** {Where the `/teach` notes go: `learning/<track>-NN-<topic>/`, created by
`.claude/skills/teach/SKILL.md`.}

---

## Dependencies

<!-- (if it applies) Delete when the milestone depends on nothing but MS001. -->

**Blocked by:** {milestones or gaps that land first — or "None."}

**Blocks:** {milestones that wait on this one — or "None."}

**Can start now:** {the slice that is startable today, independent of the blockers.}

---

## Verification commands

<!-- (always) One row per mastery criterion: the raw command (the lesson) and the script that wraps
     it (what CI and 11-verification call). Targets and flags: code/docs/BUILD.md. Gate order and
     exit codes: how-to/workflows/03-quality-gates/. What "clean" output looks like:
     project-management/docs/VERIFICATION-GUIDE.md → The commands, by flag. Keep only the rows whose
     flag is not N/A in the milestone. -->

| Flag | Criterion | Raw command | Script |
| --- | --- | --- | --- |
| Tests | [EXAMPLE] every C test passes | `make -C code/src/c/ms###-{kebab} test` | `bash code/src/scripts/c/test.sh` |
| Memory | [EXAMPLE] no sanitiser report | `make -C code/src/c/ms###-{kebab} san` | `bash code/src/scripts/c/san.sh` |
| Memory | [EXAMPLE] valgrind clean, no leaks | `make -C code/src/c/ms###-{kebab} memcheck` | `bash code/src/scripts/c/memcheck.sh` |
| Lint | [EXAMPLE] analyser clean | `make -C code/src/c/ms###-{kebab} lint` | `bash code/src/scripts/c/lint.sh` |
| Tests | [EXAMPLE] every Rust test passes | `(cd code/src/rust && cargo test -p ms###_{snake})` | `bash code/src/scripts/rust/test.sh` |
| Lint | [EXAMPLE] format and clippy clean | `(cd code/src/rust && cargo fmt --all --check && cargo clippy --all-targets -- -D warnings)` | `bash code/src/scripts/rust/lint.sh` |
| Debugger | [EXAMPLE] {the gdb walkthrough the flag names} | `gdb -q code/src/c/ms###-{kebab}/build/test_{unit}` | none — a walkthrough |
| QEMU | [EXAMPLE] boots to a shell | {the `qemu-system-x86_64` line from the kernel plan} | none yet (planned — added at P4) |

Cargo runs from inside `code/src/rust/` so rustup honours the pinned `rust-toolchain.toml`
(`project-management/src/08-DECISIONS/ADR-MS001-RUST-EDITION-2024-TOOLCHAIN-PIN-27-09-2026.md`).
Every milestone closes with the full suite:

```bash
bash code/src/scripts/gates/all.sh   # exit 0 pass · 1 failures · 2 could not run
```

---

## Risks

<!-- (always) R-1 is the learner's own prediction from Starting point. A missing tool is a typical
     risk: the kernel build dependencies (flex, bison, libelf-dev, dwarves) and clang/LLVM for
     Rust-for-Linux were not installed on 27/09/2026. A risk that already blocks progress also gets a
     GAPS.md entry. -->

| ID | Risk | Trigger | Likelihood | Response |
| --- | --- | --- | --- | --- |
| R-1 | {the learner's prediction} | {what will show it has happened} | Low / Medium / High | {extra `/teach` session, smaller exercise, re-drill} |
| [EXAMPLE] R-2 | A required tool is missing | `bash code/src/scripts/toolchain/check.sh` exits 2 | Low | install via `how-to/workflows/01-toolchain-setup/`; `GAPS.md` entry; milestone `Blocked` |

---

## Deferred items

<!-- (always) Everything under "Out of scope" above, each with the milestone that picks it up and a
     matching DEFERRED.md entry carrying a DEFERRED (MS###) marker. "None." is a valid entry. -->

- [EXAMPLE] **{topic}** — {why it waits} — picked up by MS### · `DEFERRED.md` → `DEFERRED (MS###)`

---

## As-Built summary

<!-- (after verification) Leave the pending line in place until project-management/workflows/
     11-verification/ Step 10 fills this section. Writing it earlier records intent as evidence. -->

_Pending — filled at `project-management/workflows/11-verification/` from the verification record._

- **Built as planned:** {exercises and crates that match the plan}
- **Planned but not built:** {and where each went: `DEFERRED.md`, a later milestone}
- **Built but not planned:** {and why it was needed}
- **Deviations and why:** {changes of order, scope or approach}
- **Evidence:** `project-management/src/10-PROGRESS/MS###-VERIFICATION.md`

---

## Definition of Done

<!-- (always) -->

- [ ] Every input above exists and is linked by full repo-relative path
- [ ] Every concept has a cited primary source with a chapter or section
- [ ] Every exercise has a spec, a code location, a code workflow and a prerequisite concept
- [ ] Every mastery criterion has a raw command and a script, runnable on the host in
  `how-to/docs/TOOLCHAIN.md`
- [ ] Every risk has a trigger and a response; every deferral is in `DEFERRED.md`
- [ ] The learner has explained the plan back without reading from it
- [ ] The milestone links back to this plan
- [ ] As-Built summary filled at `11-verification`, and the milestone `Completed` only after the merge

---

## Cross-references

- `project-management/src/02-MILESTONES/MS###-{TITLE}.md` — the milestone this plan serves
- `project-management/src/08-DECISIONS/` — the ADRs it rests on
- `project-management/src/10-PROGRESS/MS###-VERIFICATION.md` — the record that closes it
- `project-management/workflows/09-milestone-plans/` — the procedure that writes it
- `project-management/workflows/10-study-and-build/` — the procedure that follows it
- `code/docs/BUILD.md` · `how-to/workflows/03-quality-gates/` — targets, flags and gate order
