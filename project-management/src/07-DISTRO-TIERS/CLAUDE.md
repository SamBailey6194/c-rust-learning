@./CONTEXT.md

# CLAUDE.md — project-management/src/07-DISTRO-TIERS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (the matrix, the
tier files and what is still open — imported above) → this file → `TIER-MATRIX.md`.

## Purpose (one line)

The distro tier specs — `TIER-MATRIX.md` and one `TIER-<NAME>.md` per tier, stating each tier's
value on eight fixed axes and the QEMU-testable hypotheses behind them.

## How to work here

- **Routing:** start from `project-management/workflows/07-distro-tier-spec/` (`STEPS.md` +
  `CHECKLIST.md`). An axis value that rests on memory goes through the `research` skill into
  `research/`; a hard-to-reverse choice (distro base, init system, package manager, bootloader)
  goes to `project-management/workflows/08-decisions/` as an ADR.
- **Concrete steps:** explain-first on the tier's target user → read the matrix and the tier file →
  research uncited values → write each axis value, reason and test in the tier file → update the
  tier's matrix column to match → write or revise the hypotheses → check the three tiers against
  each other and the ADRs → cite notes, ADRs and the driving milestone by full path → set the
  status.
- **Definition of done:** the tier file and `TIER-MATRIX.md` agree cell for cell; every axis has a
  value and a reason; every user-facing axis has a hypothesis naming its QEMU test, pass condition
  and phase; every hard-to-reverse choice cites an ADR (Proposed or Accepted); British English;
  DD/MM/YYYY.

## Guardrails

- **Keep the matrix and the tier files identical.** A value changed in one place and not the other
  is a spec that says two things.
- **Label a hypothesis as a hypothesis.** Nothing here is decided until an ADR decides it or a P6
  test confirms it; a Draft value written as fact is an overclaim.
- **Test with observations, not adjectives.** "Easy", "minimal" and "friendly" are not pass
  conditions; a prompt appearing, a command's output or a count of steps is.
- **Keep the axes fixed.** The eight axes and their spelling come from `TIER-MATRIX.md`; a new axis
  changes every tier and goes through `08-decisions` first.
- **Keep three tiers.** A fourth tier changes the mission; it needs an ADR and a `ROADMAP.md` change
  before it appears here.
- **Test in QEMU only.** Every hypothesis names a QEMU test; no tier image is booted on the host
  (the kernel safety rule in `.claude/CLAUDE.md`).
- **Park later-phase ideas.** An idea that belongs after P6 goes to `DEFERRED.md` with a
  `DEFERRED (MS###)` marker instead of widening a tier.

## Output & naming

- **Hand-written:** `TIER-MATRIX.md`, `TIER-BEGINNER.md`, `TIER-INTERMEDIATE.md`,
  `TIER-EXPERIENCED.md`.
- **Template:** `TIER-000-TEMPLATE.md` — the copy source; keep it, do not repurpose it.
- **Generated:** none.
- Tier files are named `TIER-<NAME>.md` with the tier name in `SCREAMING-KEBAB-CASE`; the three names
  are fixed. Hypothesis IDs are `H1`, `H2`, ... within a tier file; cite one across files as
  `TIER-BEGINNER.md` → H2.
- **Status words for a tier file and the matrix** (this folder owns them):
  - `Draft` — sketched; values may rest on memory and are labelled as hypotheses
  - `Specified` — every value cited or marked as an assumption to test, every user-facing axis has a
    testable hypothesis, every hard-to-reverse choice cites an ADR
  - `Verified` — the tier image passed every hypothesis's test at P6 (or the hypothesis was revised
    with the evidence), recorded in a verification record in `project-management/src/10-PROGRESS/`
- Dates DD/MM/YYYY.
