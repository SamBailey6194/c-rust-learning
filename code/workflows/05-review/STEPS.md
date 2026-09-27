---
workflow: 05-review
phase: verify
skills: []
---

# Code Review — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `code/REFERENCES.md` for the external sources (the kernel's coding-style document, the clippy lint
list, the N2310 draft of the C17 text) as you work through these steps:

| Step | Section |
| --- | --- |
| 1 | `code/docs/BUILD.md` — the gates the baseline must pass |
| 2–3 | The `EX-MS###-<TOPIC>.md` spec in `project-management/src/04-EXERCISES/` — the Spec axis |
| 4 | `code/docs/MEMORY-SAFETY.md`, `C-CODING-PRINCIPLES.md`, `RUST-CODING-PRINCIPLES.md`, `TESTING.md`, `CODING-PRINCIPLES.md` |
| 6 | `project-management/src/11-REVIEWS/REVIEW-MS000-TEMPLATE.md` — the record |

---

## Steps

### Step 1 — Confirm the baseline is green

Review starts from code that passes its own gates. For a C exercise and for the Rust workspace:

```bash
make -C code/src/c/msNNN-<kebab> test san memcheck lint
(cd code/src/rust && cargo fmt --check && cargo clippy --all-targets -- -D warnings && cargo test)
```

Claude verifies through the scripts: `bash code/src/scripts/c/test.sh`, `san.sh`, `memcheck.sh`,
`lint.sh`, and `bash code/src/scripts/rust/lint.sh`, `test.sh` — or all of them at once with
`bash code/src/scripts/gates/all.sh`. Anything red goes back to the building or fixing workflow first.

_Done when every gate for the code under review exits 0, and any gate that could not run is named as such._

---

### Step 2 — Fix the scope and read the spec

List the files under review (`git diff --stat main...HEAD` on the milestone branch shows what changed).
Open the spec and list its cases and error conditions. Ask the learner which part they are least sure of —
that is where the review starts.

_Done when the file list, the spec's case list and the learner's own concern are written down._

---

### Step 3 — Review the Spec axis

For each case and error condition in the spec, find the test that pins it and the code that satisfies it.
A spec case with no test is a finding even if the code handles it; a test with no spec case behind it is
worth a question.

_Done when every spec case is marked covered, covered-untested or missing._

---

### Step 4 — Review the five Standards dimensions, in order

Work through the dimensions from `CONTEXT.md` one at a time, reading the whole scope for each:

1. **Memory safety and UB** — every allocation's size and its free on every path, including error
   paths; every index and copy bounded; strings NUL-terminated; no read of uninitialised memory; no
   signed overflow or oversized shift; in Rust, each `unsafe` is covered by an `#[allow(unsafe_code)]`
   on the smallest enclosing item, and each `unsafe` block has a `SAFETY:` comment that states a real
   invariant.
2. **Error handling** — each call that can fail (`malloc`, `fopen`, `read`, `snprintf` truncation,
   `strtol`) is checked; the error reaches the caller; cleanup runs once on every exit path; in Rust,
   `?` and error types rather than `unwrap`.
3. **Idiomatic style** — kernel style in C (tab indentation, brace placement, `/* */` comments, line
   length, one declaration per line); rustfmt and clippy already enforce the Rust layout, so look at
   naming and API shape instead.
4. **Test quality** — expected values from an independent source, error paths tested, tests through the
   public interface, names that read as sentences.
5. **Readability** — names that say what, functions that do one thing, nesting no deeper than the style
   guide allows, no magic numbers.

_Done when each dimension has been read across the whole scope, with its findings noted._

---

### Step 5 — Write each finding as a pointer and a question

Each finding records: file and line; axis and dimension; the `code/docs/` section that decides it; a
severity — Blocking, Should fix or Suggestion, as the template defines them; and a question that leads to
the fix ("What happens to `buf` if the second `malloc` fails?"). Findings with no written standard behind
them are Suggestions.

_Done when every finding has all five parts and none contains rewritten code._

---

### Step 6 — Write the REVIEW record

Copy `project-management/src/11-REVIEWS/REVIEW-MS000-TEMPLATE.md` to
`project-management/src/11-REVIEWS/REVIEW-MS###-<DESC>.md`, fill every section, and replace every
`{PLACEHOLDER}`. Commit it with scope `pm`, staged by name.

_Done when the record exists, every placeholder is gone and the verdict matches the findings._

---

### Step 7 — Hand over and re-review what changed

Walk the learner through the findings, most severe first. The learner fixes bugs through
`code/workflows/07-debug/` and structure through `code/workflows/08-refactor/`. Re-run Step 1, then
re-review only the changed lines and update the record's status.

_Done when every blocking finding is resolved and re-checked, or accepted with a reason in the record._

---

## Update context files

1. Add every new file to the directory tree in the nearest `CONTEXT.md` that lists files individually.
2. Add any new external source cited by a finding to `code/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If a finding exposed a rule that no `code/docs/` guide states, say so in the record and raise it with
   the learner as a documentation gap, rather than inventing the rule in the review.
5. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
