# DEFERRED.md — Topics Parked for a Later Phase

**Last Updated**: 27/09/2026 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB)

Topics that came up during a milestone and were **deliberately parked** for a named later
milestone or phase, rather than chased on the spot — "revisit this once Rust's ownership model
is familiar", "come back to this allocator trick when the kernel's slab allocator is studied".
Parking is a teaching decision: one concept at a time (`.claude/CLAUDE.md` Section 1).

**Not** a gap register — something that blocks progress goes in `GAPS.md`. **Not** memory —
patterns and feedback go in `.claude/MEMORY.md`.

**Add a row when** a lesson, review, finding or milestone record marks something
`DEFERRED (MS###)` (or `DEFERRED (P#)` when only the phase is known). **Remove the row** when the
target milestone covers it, noting where it landed in that milestone's record.

**Read when planning the next milestone.** Every row whose target is the milestone being planned
becomes an input to its scope (`project-management/workflows/02-milestone-creation/`,
`09-milestone-plans/`); a row whose target has already passed is re-targeted or dropped, never
left stale.

## Format

One row per parked topic, oldest first:

```text
| Topic | Parked during | Target | Date | Why parked |
| --- | --- | --- | --- | --- |
| <what to come back to> | MS### (or learning/<topic>/) | DEFERRED (MS###) | DD/MM/YYYY | <one line> |
```

---

## Parked topics

_No entries yet._
