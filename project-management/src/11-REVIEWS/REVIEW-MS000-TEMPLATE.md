# REVIEW: MS000 — {Milestone Title}

_Template — copy to `REVIEW-MS###-<DESCRIPTOR>.md`, replace every `{PLACEHOLDER}`, delete the `[EXAMPLE]`
rows and the guidance comments. The review of one milestone's code on two axes — against its spec, and
against the written standards in `code/docs/`. Each finding points at the guide that decides it and asks
the question that leads to the fix; the review never rewrites the learner's code._

| Field | Value |
| --- | --- |
| **Milestone** | MS### — {title} · `project-management/src/02-MILESTONES/MS###-{TITLE}.md` |
| **Plan** | `project-management/src/09-MILESTONE-PLANS/{NN}-PLAN-MS###-{DESCRIPTOR}.md` |
| **Spec** | `project-management/src/04-EXERCISES/EX-MS###-{TOPIC}.md` {and any project spec} |
| **Branch · PR** | `ms###/{short-kebab}` · #{NN} (or "not raised yet") |
| **Reviewer** | {Sam Bailey / Claude, through `code/workflows/05-review/`} |
| **Date** | {DD/MM/YYYY} |
| **Verdict** | {Approve / Approve with follow-ups / Changes requested} — see Section 6 |

---

## 1. Scope and files reviewed

**Baseline.** {The gates were green before review began: `project-management/src/10-PROGRESS/MS###-VERIFICATION.md`,
or the commands run and their exit codes. A red gate goes back to the building workflow first.}

**The learner's concern.** {The part of the code the learner is least sure of, and why — asked before the
review started. Section 7 compares it with what the review found.}

| File | Change |
| --- | --- |
| [EXAMPLE] `code/src/c/ms###-{kebab}/{unit}.c` | Created — {function}, {what it does} |
| [EXAMPLE] `code/src/c/ms###-{kebab}/test_{unit}.c` | Created — {N} checks: normal, NULL, zero-length, truncation |
| [EXAMPLE] `code/src/rust/crates/ms###_{snake}/src/lib.rs` | Created — `pub fn {name}` |

---

## 2. Spec axis

Every case and error condition the spec lists, with the test that pins it and the code that satisfies it.
A case with no test is a finding even when the code handles it.

| Spec case or error condition | Test | Code | Result |
| --- | --- | --- | --- |
| [EXAMPLE] {output truncated to fit the buffer} | `test_{unit}.c:{line}` | `{unit}.c:{line}` | Covered |
| [EXAMPLE] {NULL name} | — | `{unit}.c:{line}` | Covered, untested |
| {case} | {test or —} | {code or —} | {Covered / Covered, untested / Missing} |

---

## 3. Findings

Most severe first. Each finding has a stable `R-0NN` ID, names the `code/docs/` section that decides it, and
asks a question rather than giving the answer.

| ID | Severity | File:line | Dimension | Decided by | Question that leads to the fix | Resolution |
| --- | --- | --- | --- | --- | --- | --- |
| [EXAMPLE] R-001 | Blocking | `{unit}.c:{line}` | Memory safety | `code/docs/MEMORY-SAFETY.md` → {section} | "What does `buf` hold if the second allocation fails?" | Open |
| [EXAMPLE] R-002 | Should fix | `{unit}.c:{line}` | Error handling | `code/docs/C-CODING-PRINCIPLES.md` → {section} | "Which caller learns that the file failed to open?" | Fixed — `{commit}` |
| [EXAMPLE] R-003 | Suggestion | `{unit}.c:{line}` | Readability | — (no written standard) | "Would a reader know what `n2` counts?" | Accepted — {reason} |

**Severity.**

- **Blocking** — changes behaviour or safety: undefined behaviour, a memory error, a wrong result, an
  unchecked failure, a missing spec case. Resolved and re-checked before merge.
- **Should fix** — breaks a written standard without changing behaviour: layout, a missing error-path
  test, a misleading name. Fixed now, or routed with a named destination.
- **Suggestion** — no written standard behind it; the learner decides. When the rule ought to exist, it
  becomes a `GAPS.md` entry, not a rule invented in this review.

**Resolution** — `Open` · `Fixed — {commit}` · `Routed — {destination}` · `Accepted — {reason}`.

---

## 4. Standards checklists

Work the five dimensions in order, reading the whole scope for each. Tick an item, or mark it `N/A` with a
one-line reason. A failed item becomes a finding in Section 3.

### 4.1 Memory safety and undefined behaviour — `code/docs/MEMORY-SAFETY.md`

- [ ] Every allocation has the right size and is freed exactly once on every path, error paths included
- [ ] Every index, copy and string operation is bounded; every string has room for its NUL and gets it
- [ ] No read of uninitialised memory, no use after free, no double free
- [ ] No signed overflow, no shift by a negative or oversized amount, no division by zero
- [ ] No type punning through pointer casts; alignment respected
- [ ] Conversions `-Wconversion` reported were fixed at the cause, not silenced with a cast
- [ ] Sanitiser and valgrind runs clean in the verification record
- [ ] Rust: no `unsafe` unless the milestone is about it; each `unsafe` has its own `#[allow(unsafe_code)]`
  and a `// SAFETY:` comment stating a real invariant
- [ ] FFI: pointer validity, lifetime and ownership across the boundary are documented on both sides

### 4.2 Error handling — `code/docs/C-CODING-PRINCIPLES.md` · `code/docs/RUST-CODING-PRINCIPLES.md`

- [ ] Every call that can fail is checked (`malloc`, `fopen`, `read`, `write`, `snprintf` truncation,
  `strtol` with `errno` and its end pointer)
- [ ] The error reaches the caller through the documented contract; nothing prints and carries on
- [ ] Cleanup runs once on every exit path (a `goto` cleanup ladder where more than one resource is held)
- [ ] Each function's failure contract is stated in the comment above its declaration
- [ ] Rust: fallible functions return `Result`; `?` propagates; no `unwrap` or `expect` outside tests

### 4.3 Idiomatic style — `code/docs/C-CODING-PRINCIPLES.md` · `code/docs/RUST-CODING-PRINCIPLES.md`

- [ ] C: tab indentation, 8 columns; nesting no deeper than about three levels
- [ ] C: K&R braces, with a function's opening brace on its own line
- [ ] C: `/* */` comments; lines within 80 columns and none over 100
- [ ] C: one declaration per line; the `*` next to the name
- [ ] C: ISO C17 only — no GNU extension outside kernel work
- [ ] Rust: `cargo fmt --check` and clippy clean; each pedantic warning fixed, or allowed with a reason
- [ ] Rust: borrowing rather than cloning; iterators where they read more clearly than index loops

### 4.4 Test quality — `code/docs/TESTING.md`

- [ ] Expected values come from an independent source (the spec, a man page, a hand calculation), never
  from running the code under test
- [ ] Error paths and edge cases are tested, not only the normal case (NULL, zero length, truncation,
  empty input)
- [ ] Tests go through the public interface: the header, or the crate's `pub` API
- [ ] Each test was seen to fail for the predicted reason before it passed
- [ ] Test names read as sentences; every C test function is called from `main`
- [ ] Every bug fixed in this milestone has its regression test (`project-management/src/13-BUGS/`)

### 4.5 Readability — `code/docs/CODING-PRINCIPLES.md`

- [ ] Names say what a thing is or does
- [ ] Each function does one thing and fits on a screen
- [ ] No magic numbers; constants are named
- [ ] Comments say why, not how
- [ ] Headers expose only what callers need; file-local helpers are `static`

---

## 5. Required actions before merge

Blocking findings, and any Should-fix the learner chooses to clear now. Each ties to an `R-0NN` and has a
route. "None — approved as is." is a valid entry.

| Action | Finding | Route | Status |
| --- | --- | --- | --- |
| [EXAMPLE] Free `buf` on the second allocation's failure path | R-001 | `code/workflows/07-debug/` · `project-management/src/13-BUGS/` | Open |
| [EXAMPLE] Extract the parsing loop into its own function | R-004 | `code/workflows/08-refactor/` | Done — `{commit}` |
| [EXAMPLE] Revisit once dynamic arrays are taught | R-005 | `DEFERRED.md` → `DEFERRED (MS###)` | Routed |

---

## 6. Verdict

- **Verdict:** {Approve / Approve with follow-ups / Changes requested}
- **Reasoning:** {one or two lines — what carries the verdict}
- **Re-review:** {date and commit, and which findings were re-checked — or "none needed"}

**Changes requested blocks the merge** at `project-management/workflows/13-pr-and-merge/` until every
Blocking action is done and re-reviewed. Any change to code sends the milestone back through
`project-management/workflows/11-verification/` from its first step.

---

## 7. Notes

- **The learner's concern against the findings:** {which predicted weak spots were real, and which
  findings the learner did not suspect — the second list is where misconceptions hide, and feeds
  `project-management/src/12-FINDINGS/`}
- [EXAMPLE] {a design choice confirmed as sound, with the guide section that supports it}

---

## Cross-references

- `project-management/src/02-MILESTONES/MS###-{TITLE}.md` — the milestone under review
- `project-management/src/10-PROGRESS/MS###-VERIFICATION.md` — the baseline evidence
- `code/workflows/05-review/` — the procedure the reviewer runs
- `code/docs/MEMORY-SAFETY.md` · `code/docs/C-CODING-PRINCIPLES.md` · `code/docs/RUST-CODING-PRINCIPLES.md`
  · `code/docs/TESTING.md` · `code/docs/CODING-PRINCIPLES.md` — the standards the five dimensions check
- `project-management/src/12-FINDINGS/` — where the misconceptions this review surfaces are recorded
- `project-management/src/13-BUGS/` — where a Blocking behaviour defect is recorded
