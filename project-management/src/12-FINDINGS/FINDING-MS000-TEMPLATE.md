# FINDINGS: MS000 — {Milestone Title}

_Template — copy to `FINDING-MS###-<DESCRIPTOR>-DD-MM-YYYY.md`, replace every `{PLACEHOLDER}`, delete the
`[EXAMPLE]` rows and the guidance comments. What one milestone corrected in the learner's understanding:
each misconception with what was believed, what is true and the source that settles it; which of them
would be expensive to relearn; and what the next milestone carries forward. It records; it does not fix._

| Field | Value |
| --- | --- |
| **Milestone** | MS### — {title} · `project-management/src/02-MILESTONES/MS###-{TITLE}.md` |
| **Plan** | `project-management/src/09-MILESTONE-PLANS/{NN}-PLAN-MS###-{DESCRIPTOR}.md` |
| **Verification** | `project-management/src/10-PROGRESS/MS###-VERIFICATION.md` |
| **Review** | `project-management/src/11-REVIEWS/REVIEW-MS###-{DESCRIPTOR}.md` |
| **Recorded** | {DD/MM/YYYY} — the day this milestone's review and reflection closed |
| **Recorded by** | Sam Bailey, through `project-management/workflows/12-review-and-reflect/` |
| **Outcome** | {N findings · M expensive to relearn} / Nothing corrected |

---

## 1. Scope

{One or two lines: what the milestone covered, and where the findings were gathered from.}

- [ ] The misconception notes in each `learning/<track>-NN-<topic>/PROGRESS.md` the milestone touched
- [ ] The bug records it produced in `project-management/src/13-BUGS/`
- [ ] The review's findings, and the learner's concern set against them (review Section 7)
- [ ] The learner's prediction at `11-verification` against what actually failed

---

## 2. Findings — misconceptions corrected

<!-- One row per corrected belief, most consequential first, each with a stable F-0NN ID so the next
     plan can cite it. "What I believed" is in the learner's own words. "Settled by" is a primary
     source or reproducible evidence — never "Claude said so". Anything inferred rather than observed
     is marked TODO(verify). -->

| ID | Area | What I believed | What is true | Settled by | Surfaced by | Relearn cost | Disposition |
| --- | --- | --- | --- | --- | --- | --- | --- |
| [EXAMPLE] F-001 | C library | `snprintf` returns the number of characters it wrote | It returns the length the whole output would have had, excluding the NUL; the output was truncated when that value is at least the buffer size | `man 3 snprintf` → RETURN VALUE | review R-002 | Cheap | Next milestone |
| [EXAMPLE] F-002 | C language | `sizeof` on an array parameter gives the array's size | An array parameter is adjusted to a pointer, so `sizeof` gives the size of a pointer; gcc warns by default (`-Wsizeof-array-argument`) | `man gcc` → `-Wno-sizeof-array-argument`; a gdb `print sizeof(buf)` in the function | gdb walkthrough | Expensive | Re-drill + next milestone |
| [EXAMPLE] F-003 | Undefined behaviour | Signed integer overflow wraps round like unsigned arithmetic | It is undefined behaviour; UBSan reports `runtime error: signed integer overflow`, and the optimiser may assume it never happens | cppreference → Arithmetic operators, Overflows; `make san` output | `make san` | Expensive | Re-drill |

**Area** — C language · C library · Memory · Undefined behaviour · Rust ownership · Rust `unsafe` and FFI ·
Tooling (make, gdb, valgrind, cargo) · Kernel · Process.

**Relearn cost** — `Expensive` when later work would build on the wrong model (object lifetimes,
aliasing, ownership, what undefined behaviour permits the compiler to do); `Cheap` when it is an isolated
fact that is simply looked up next time.

**Disposition** — `Next milestone` (a risk or an Explain-first question in the next plan) · `Re-drill`
(a spaced-review entry with a date in the topic's `PROGRESS.md`) · `Deferred — MS###` (`DEFERRED.md`) ·
`Bug` (`project-management/src/13-BUGS/`) · `Guide` (a `code/docs/` guide is wrong or silent: a `GAPS.md`
entry) · `ADR` (reopens a decision: `project-management/workflows/08-decisions/`) · `Memory` (a durable
tutoring pattern for `.claude/MEMORY.md`) · `Accepted — {reason}`.

---

## 3. Expensive to relearn

<!-- Repeat only the Expensive rows, so they cannot be lost in a long table. Each one gets a re-drill
     date, because a wrong model that has been corrected once tends to come back under pressure. -->

| ID | The wrong model | What it would have broken later | Re-drill |
| --- | --- | --- | --- |
| [EXAMPLE] F-002 | Arrays and pointers are interchangeable everywhere | Every buffer-length calculation inside a function; the P2 allocator | `learning/c-NN-{topic}/PROGRESS.md` · {DD/MM/YYYY} |

"None — nothing expensive to relearn." is a valid entry.

---

## 4. Carried into the next milestone

<!-- The point of this record. State each row as work the next plan does, not as an observation. -->

| ID | Carried as | Target |
| --- | --- | --- |
| [EXAMPLE] F-001 | Explain-first question: "How do you know `snprintf` truncated?" | MS### plan → Starting point |
| [EXAMPLE] F-003 | Risk: arithmetic on sizes overflows — add a test at the limit | MS### plan → Risks |

"None — nothing carried forward." is a valid entry.

---

## 5. Notes

- **Prediction against outcome:** {what the learner expected to be hardest at `09-milestone-plans`, and
  what actually was}
- [EXAMPLE] {a model that was confirmed rather than corrected, with the evidence}

> **Nothing corrected?** Say so here, with the evidence that the milestone was tested hard enough to
> find something, and set **Outcome** to `Nothing corrected`. A record is still written: a missing file
> cannot be told apart from a skipped step.

---

## Cross-references

- `project-management/src/11-REVIEWS/REVIEW-MS###-{DESCRIPTOR}.md` — the review these findings draw on
- `project-management/src/13-BUGS/` — the bug records behind any finding surfaced by a defect
- `project-management/src/09-MILESTONE-PLANS/` — where the next plan picks up Section 4
- `project-management/docs/SAFETY-GUIDE.md` — the undefined-behaviour and memory-bug classes to name
- `learning/` — the topic notes and re-drill entries
- `GAPS.md` · `DEFERRED.md` · `.claude/MEMORY.md` — the three registers a disposition can route to
