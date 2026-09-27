# Workflow: Code Review

**Last Updated**: 27/09/2026

A green test run says the code does what the tests ask; it says nothing about the case nobody wrote a test
for, the error path that leaks, or a style that will not survive the kernel phase. Review reads the code
against `code/docs/` so those surface while they are still cheap, and writes them down so the lesson
outlives the session.

## Directory Tree

```text
code/workflows/05-review/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- When an exercise or crate is finished — tests green and `code/workflows/06-memory-check/` clean — and
  before its `ms###/<short-kebab>` branch is merged.
- When the learner asks for a review of any code under `code/src/`.
- Not for the merge mechanics (branch, checks, PR), which belong to
  `project-management/workflows/13-pr-and-merge/`, and not for milestone-level reflection, which belongs to
  `project-management/workflows/12-review-and-reflect/`.

## Key concepts

- **Two axes, reported separately.** _Spec_: does the code do what the `EX-MS###` spec asked, case by case?
  _Standards_: does it follow `code/docs/`? A pass on one does not cover a failure on the other.
- **Five Standards dimensions, most expensive first.**
  1. **Memory safety and undefined behaviour** — bounds, lifetimes, who frees, uninitialised reads,
     signed overflow, aliasing; in Rust, every `unsafe` justified (`code/docs/MEMORY-SAFETY.md`).
  2. **Error handling** — every call that can fail is checked; errors propagate rather than print and
     continue; cleanup runs on every path (C return codes, `errno` and the goto-cleanup ladder; Rust
     `Result` and `?`) (`code/docs/C-CODING-PRINCIPLES.md`, `code/docs/RUST-CODING-PRINCIPLES.md`).
  3. **Idiomatic style** — Linux kernel coding style for C; rustfmt layout and a clean clippy run for
     Rust.
  4. **Test quality** — independent expected values, error paths tested, assertions through the public
     interface (`code/docs/TESTING.md`).
  5. **Readability** — names, function length, nesting depth, one idea per function
     (`code/docs/CODING-PRINCIPLES.md`).
- **Pointers, not rewrites.** Each finding names the file and line, the dimension, the `code/docs/` section
  that decides it and a question that leads the learner to the fix. A reviewer's rewrite teaches the
  reviewer.
- **The record.** Findings land in `project-management/src/11-REVIEWS/REVIEW-MS###-<DESC>.md`, copied
  from `REVIEW-MS000-TEMPLATE.md`; the milestone's reflection later distils patterns from these records.
- **Tools first, eyes second.** The build already fails on warnings, sanitiser reports and analyzer
  findings, so review time goes on what tools cannot judge: design, naming, missing cases, error paths.
  Until a kernel tree is fetched at P4, the kernel's `checkpatch.pl` is not available here, so C style is
  checked by reading against the style guide.

## Cross-references

### Governing documents

- `code/docs/MEMORY-SAFETY.md` — dimension 1
- `code/docs/C-CODING-PRINCIPLES.md` and `code/docs/RUST-CODING-PRINCIPLES.md` — dimensions 2 and 3
- `code/docs/TESTING.md` — dimension 4
- `code/docs/CODING-PRINCIPLES.md` — dimension 5

### Related reading

- `project-management/src/11-REVIEWS/REVIEW-MS000-TEMPLATE.md` — the record's sections
- `project-management/src/11-REVIEWS/CONTEXT.md` — naming and where reviews sit in a milestone
- `project-management/workflows/12-review-and-reflect/` — reads the review records at milestone close
- `project-management/src/08-DECISIONS/ADR-MS001-C-CODING-STYLE-LINUX-KERNEL-27-09-2026.md` — why kernel
  style
- `code/workflows/07-debug/` and `code/workflows/08-refactor/` — where findings are fixed
- `code/REFERENCES.md` — the kernel coding-style document and the clippy lint list
