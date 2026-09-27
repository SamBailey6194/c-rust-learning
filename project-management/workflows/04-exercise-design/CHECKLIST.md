---
workflow: 04-exercise-design
phase: specify
skills: []
---

# Exercise Design — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `project-management/REFERENCES.md` (GCC, valgrind and Rust sources) ·
> `project-management/src/04-EXERCISES/CLAUDE.md` (naming, status, no solutions) ·
> `code/docs/TESTING.md` (test harnesses) for supporting references.

## Execution Checklist

### Step 1 — Explain-first on the concept and its pitfalls

- [ ] The milestone's `Exercises` flag is not `N/A`
- [ ] The learner described how they would test the concept and predicted where they would go wrong

### Step 2 — Copy the template and fill the header

- [ ] The spec is named `EX-MS###-<TOPIC>.md` for its milestone and starts at `Status: Draft`
- [ ] The code location follows `code/src/c/ms###-<kebab>/` or `code/src/rust/crates/ms###_<snake>/`

### Step 3 — Set the constraints

- [ ] Every constraint row has a rule for this set
- [ ] Any exception to C17, the kernel coding style or the warning set has an ADR

### Step 4 — Write each exercise

- [ ] Every exercise has a problem, an interface, a contract with error cases, worked examples, test
      cases and a hints ladder
- [ ] Every exercise has at least one normal, one boundary and one error test case
- [ ] Every pitfall the learner predicted appears as a test case
- [ ] Expected results come from reasoning or sources, not from running code
- [ ] No solution code appears anywhere: not in a hint, an example or a comment

### Step 5 — Map the exercises to the mastery criteria

- [ ] Every mastery scenario that needs an exercise names one; no exercise is orphaned
- [ ] Reflection questions are written

### Step 6 — Set the status and link the spec

- [ ] `Status: Ready`, and the milestone links the spec by full path
- [ ] The milestone's `Tests`, `Memory` and `Lint` flags name the same exercise directory

### Step 7 — Commit by explicit path

- [ ] Committed on the milestone branch, files staged by name, scope `pm`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `project-management/REFERENCES.md` lists any new artefact type or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] The set climbs from recall to extension and proves every mastery scenario that needs it
- [ ] A learner could start `code/workflows/01-c-exercise/` or `code/workflows/03-rust-exercise/` from
      the spec alone
- [ ] The spec contains no solution
- [ ] British English throughout; dates DD/MM/YYYY
