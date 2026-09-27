---
workflow: 01-c-exercise
phase: build
skills: [teach, handoff]
---

# C Exercise — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `code/docs/BUILD.md` (targets and flags) · `code/docs/C-CODING-PRINCIPLES.md` (style, errors) ·
> `code/workflows/06-memory-check/` (reading the reports) · `code/REFERENCES.md` for supporting references.

## Pre-Conditions

- [ ] An `EX-MS###-<TOPIC>.md` spec exists in `project-management/src/04-EXERCISES/`
- [ ] Work is on the milestone branch `ms###/<short-kebab>` (`project-management/docs/git/BRANCHES.md`)
- [ ] `bash code/src/scripts/toolchain/check.sh` exits 0 (gcc, make, gdb and valgrind present)

---

## Execution Checklist

### Step 1 — Read the spec and restate the objective

- [ ] The learner restated the objective, interface and error cases in their own words
- [ ] The learner described an approach before any help was given

### Step 2 — Create the exercise folder, its pair and its Makefile

- [ ] `code/src/c/msNNN-<kebab>/` created, `NNN` matching the spec's milestone
- [ ] `CONTEXT.md` (objective, concepts, tree) and `CLAUDE.md` (tutor rules, commands) written
- [ ] Header declares the interface with documented parameters, return value and error cases
- [ ] `Makefile` sets `PROG`, `SRCS`, `TEST_SRCS` and includes `../mk/exercise.mk` — nothing else

### Step 3 — Write the tests first

- [ ] Tests cover normal, boundary and error cases, with expected values from the spec or another
      independent source
- [ ] Every new test was seen red on its assertion before the implementation existed

### Step 4 — Implement until green

- [ ] The learner wrote the implementation; Claude wrote no solution code unasked
- [ ] Code follows kernel coding style (tabs, brace placement, `/* */` comments, line length)
- [ ] Every call that can fail has its failure checked and handled

### Step 5 — Run the tests

- [ ] `make -C code/src/c/msNNN-<kebab> test` exits 0; every binary reports `0 failed`

### Step 6 — Run the sanitisers

- [ ] `make ... san` exits 0 with no AddressSanitizer, LeakSanitizer or UBSan report

### Step 7 — Run valgrind

- [ ] `make ... memcheck` exits 0; every run ends `ERROR SUMMARY: 0 errors`

### Step 8 — Run the static analyzer

- [ ] `make ... lint` exits 0 with no `analyzer-` diagnostic (printed as `[-Werror=analyzer-…]`)
- [ ] No warning was silenced by a pragma, a dropped flag or an unexplained cast

### Step 9 — Record the learning note and hand back

- [ ] A note in the learner's own words exists under `learning/c-NN-<topic>/NOTES/`
- [ ] The note is logged in that topic's `PROGRESS.md` with a review date
- [ ] Committed with scope `c`, each path staged by name, `build/` not staged

---

## Context

- [ ] `code/src/c/CONTEXT.md` lists the new exercise in its directory tree
- [ ] `code/REFERENCES.md` lists any new external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] `test`, `san`, `memcheck` and `lint` all exit 0 for this exercise
- [ ] The scripts confirm the same result (`bash code/src/scripts/c/test.sh --path msNNN-<kebab>`, then
      `san.sh`, `memcheck.sh` and `lint.sh` with the same option)
- [ ] The exercise folder has its `CONTEXT.md` + `CLAUDE.md` pair
- [ ] The learning note exists and the PM step (`project-management/workflows/10-study-and-build/`) has
      been handed the result
