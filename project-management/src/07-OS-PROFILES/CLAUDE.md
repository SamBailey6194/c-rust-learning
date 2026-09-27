@./CONTEXT.md

# CLAUDE.md — project-management/src/07-OS-PROFILES/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (the matrix, the
profile files and what is still open — imported above) → this file → `PROFILE-MATRIX.md`.

## Purpose (one line)

The Syntek OS profile specs — `PROFILE-MATRIX.md` and one `PROFILE-<NAME>.md` per profile, stating
each profile's value on eleven fixed axes and the QEMU-testable hypotheses behind them.

## How to work here

- **Routing:** start from `project-management/workflows/07-os-profile-spec/` (`STEPS.md` +
  `CHECKLIST.md`). An axis value that rests on memory goes through the `research` skill into
  `research/`; a hard-to-reverse choice (init system, package manager and signing, bootloader, a
  storage layer, a profile's hardware) goes to `project-management/workflows/08-decisions/` as an ADR.
- **Concrete steps:** explain-first on the profile's target user → read the matrix and the profile
  file → research uncited values → write each axis value, reason and test in the profile file → update
  the profile's matrix column to match → write or revise the hypotheses → check the profiles against
  each other and the ADRs → cite notes, ADRs and the driving milestone by full path → set the status.
- **Definition of done:** the profile file and `PROFILE-MATRIX.md` agree cell for cell; every one of
  the eleven axes has a value and a reason; every user-facing axis has a hypothesis naming its QEMU
  test, pass condition and phase; every hard-to-reverse choice cites an ADR (Proposed or Accepted);
  British English; DD/MM/YYYY.

## Guardrails

- **Keep the matrix and the profile files identical.** A value changed in one place and not the other
  is a spec that says two things.
- **Label a hypothesis as a hypothesis.** Nothing here is decided until an ADR decides it or a P6
  test confirms it; a Draft value written as fact is an overclaim.
- **Test with observations, not adjectives.** "Easy", "minimal" and "friendly" are not pass
  conditions; a prompt appearing, a command's output or a count of steps is.
- **Keep the eleven axes fixed.** The axes and their spelling come from `PROFILE-MATRIX.md`; a new
  axis changes every profile and goes through `08-decisions` first.
- **Keep seven profiles.** An eighth profile changes the mission; it needs an ADR and a `ROADMAP.md`
  change before it appears here (`ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`).
- **Test in QEMU only.** Every hypothesis names a QEMU test; no profile image is booted on the host,
  and router labs run on isolated virtual networks only (`.claude/CLAUDE.md` owns the rules). Real
  hardware is not chosen yet, and is chosen per profile by ADR when its topic opens.
- **Park later-phase ideas.** An idea that belongs after P6 goes to `DEFERRED.md` with a
  `DEFERRED (MS###)` marker instead of widening a profile.

## Output & naming

- **Hand-written:** `PROFILE-MATRIX.md`, `PROFILE-BEGINNER.md`, `PROFILE-INTERMEDIATE.md`,
  `PROFILE-EXPERT.md`, `PROFILE-SERVER.md`, `PROFILE-NAS.md`, `PROFILE-HOMELAB.md`,
  `PROFILE-ROUTER.md`.
- **Template:** `PROFILE-000-TEMPLATE.md` — the copy source; keep it, do not repurpose it.
- **Generated:** none.
- Profile files are named `PROFILE-<NAME>.md` with the profile name in `SCREAMING-KEBAB-CASE`; the
  seven names are fixed (`BEGINNER`, `INTERMEDIATE`, `EXPERT`, `SERVER`, `NAS`, `HOMELAB`, `ROUTER`).
  Hypothesis IDs are `H1`, `H2`, ... within a profile file; cite one across files as
  `PROFILE-BEGINNER.md` → H2.
- **Status words for a profile file and the matrix** (this folder owns them):
  - `Draft` — sketched; values may rest on memory and are labelled as hypotheses
  - `Specified` — every value cited or marked as an assumption to test, every user-facing axis has a
    testable hypothesis, every hard-to-reverse choice cites an ADR
  - `Verified` — the profile image passed every hypothesis's test at P6 (or the hypothesis was revised
    with the evidence), recorded in a verification record in `project-management/src/10-PROGRESS/`
- Dates DD/MM/YYYY.
