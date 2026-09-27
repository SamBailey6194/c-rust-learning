---
workflow: 05-review
phase: verify
skills: []
---

# Code Review — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `code/docs/MEMORY-SAFETY.md` · `code/docs/C-CODING-PRINCIPLES.md` ·
> `code/docs/RUST-CODING-PRINCIPLES.md` · `code/docs/TESTING.md` · `code/docs/CODING-PRINCIPLES.md` ·
> `code/REFERENCES.md` for supporting references.

## Pre-Conditions

- [ ] The code under review is finished by its author, not mid-change
- [ ] Its spec (`EX-MS###-<TOPIC>.md`) or the agreed change description is at hand

---

## Execution Checklist

### Step 1 — Confirm the baseline is green

- [ ] C: `test`, `san`, `memcheck` and `lint` exit 0 for every exercise in scope
- [ ] Rust: `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings` and `cargo test` exit 0
- [ ] Any gate that could not run is reported as COULD NOT RUN, not as clean

### Step 2 — Fix the scope and read the spec

- [ ] The file list, the spec's cases and the learner's own biggest doubt are written down

### Step 3 — Review the Spec axis

- [ ] Every spec case and error condition is marked covered, covered-untested or missing

### Step 4 — Review the five Standards dimensions, in order

- [ ] Memory safety and UB read across the whole scope
- [ ] Error handling read across the whole scope
- [ ] Idiomatic style read across the whole scope (kernel style for C; naming and API shape for Rust)
- [ ] Test quality read across the whole scope
- [ ] Readability read across the whole scope

### Step 5 — Write each finding as a pointer and a question

- [ ] Every finding has a location, axis and dimension, `code/docs/` reference, severity and question
- [ ] No finding contains rewritten solution code
- [ ] Preferences with no written standard are labelled as suggestions

### Step 6 — Write the REVIEW record

- [ ] `project-management/src/11-REVIEWS/REVIEW-MS###-<DESC>.md` created from `REVIEW-MS000-TEMPLATE.md`
- [ ] Every `{PLACEHOLDER}` replaced; the verdict matches the findings
- [ ] Committed with scope `pm`, staged by name

### Step 7 — Hand over and re-review what changed

- [ ] Findings walked through with the learner, most severe first
- [ ] The baseline re-run after the fixes, and the changed lines re-reviewed
- [ ] The record's status updated to match

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show any new file
- [ ] `code/REFERENCES.md` lists any new external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] Both axes reviewed and reported separately
- [ ] Every blocking finding resolved and re-checked, or accepted with a reason in the record
- [ ] The REVIEW record is committed and ready for `project-management/workflows/12-review-and-reflect/`
