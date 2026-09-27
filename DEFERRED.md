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

| Topic | Parked during | Target | Date | Why parked |
| --- | --- | --- | --- | --- |
| UEFI Secure Boot for Syntek OS images: shim, signing kernels and bootloaders, key enrolment | MS001 (planning conversation) | DEFERRED (P6) | 27/09/2026 | Kept out of `learning/os-02-storage-and-boot-fundamentals/` so that topic stays on one concept at a time; `learning/sec-13-hardening-and-secure-boot/` teaches it on VM images, and the profile images take it up when P6 plans them |
| The init system Syntek OS ships (systemd, runit, s6, OpenRC or its own) | MS001 (planning conversation) | DEFERRED (P6) | 27/09/2026 | The learning build follows the LFS 13.1 systemd book and a minimal init in C is a lesson (`learning/os-06-init-and-services/`); the shipped init is chosen later by an ADR fed by the `INIT-SYSTEM-CHOICE.md` research note (planned) |
| Domain adapters beyond coding: legal, HR, finance and business | MS001 (planning conversation) | DEFERRED (L6) | 27/09/2026 | The coding adapter comes first; the others only with retrieval from authoritative UK sources and as assistants to professionals (`learning/llm-20-post-training-and-adapters/`) |
| Analysis of live malware samples | MS001 (planning conversation) | DEFERRED (S3) | 27/09/2026 | The security track is defensive and tests detection with the EICAR file and synthetic files only; revisit only with a dedicated air-gapped analysis environment and a decision ADR |
