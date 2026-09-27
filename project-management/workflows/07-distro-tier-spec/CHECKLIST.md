---
workflow: 07-distro-tier-spec
phase: specify
skills: [research]
---

# Distro Tier Spec — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `project-management/REFERENCES.md` (external distro and kernel sources) ·
> `project-management/src/07-DISTRO-TIERS/CLAUDE.md` (naming and status) ·
> `project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md` (the axes) for supporting references.

## Execution Checklist

### Step 1 — Explain the tier first, then gather the inputs

- [ ] The learner described the tier's target user before any drafting, and the answer is recorded
- [ ] The P5 and P6 rows of `ROADMAP.md`, the matrix, the tier file and its cited notes and ADRs were read

### Step 2 — Research the axis values that rest on memory

- [ ] Every axis value cites a research note or primary source, or is marked as an assumption to test
- [ ] Each new note answers one question and sits at `research/<SCREAMING-KEBAB-TOPIC>.md`

### Step 3 — Open the tier file, or copy the template

- [ ] The tier file is one of `TIER-BEGINNER.md`, `TIER-INTERMEDIATE.md`, `TIER-EXPERIENCED.md`
- [ ] No `{PLACEHOLDER}` or `[EXAMPLE]` row survives in a copied file
- [ ] Header fields (date, driving milestone, status) are current

### Step 4 — Fill every axis against the matrix

- [ ] Every matrix axis has a value and a one-line reason in the tier file
- [ ] The tier's column in `TIER-MATRIX.md` matches the tier file cell for cell
- [ ] Values shared with another tier are marked as shared on purpose

### Step 5 — Write the hypotheses

- [ ] Every user-facing axis has at least one hypothesis
- [ ] Every hypothesis names its test in QEMU, its pass condition and the phase that tests it
- [ ] No hypothesis relies on an adjective ("easy", "minimal") instead of an observation

### Step 6 — Check the tiers against each other and against the ADRs

- [ ] No hypothesis in one tier is contradicted by another tier's axis value
- [ ] No axis value conflicts with an Accepted ADR
- [ ] Every hard-to-reverse choice (init, package manager, bootloader, distro base) cites an ADR

### Step 7 — Cross-link and set the status

- [ ] The tier file links its research notes, ADRs and driving milestone by full repo-relative path
- [ ] The driving milestone links back to the tier file
- [ ] Later-phase ideas moved to `DEFERRED.md` with a `DEFERRED (MS###)` marker

### Step 8 — Commit by explicit path

- [ ] Files staged by name (no `git add -A`, no `git add .`)
- [ ] Commit message follows Conventional Commits with scope `distro` or `research`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `project-management/REFERENCES.md` lists any new artefact type or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] The tier file and `TIER-MATRIX.md` agree cell for cell
- [ ] Every hypothesis is testable in QEMU and names its test, pass condition and phase
- [ ] Every hard-to-reverse choice cites an ADR, Proposed or Accepted
- [ ] The work is committed, ready for `project-management/workflows/08-decisions/`
