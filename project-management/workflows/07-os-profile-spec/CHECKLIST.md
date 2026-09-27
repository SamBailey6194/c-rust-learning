---
workflow: 07-os-profile-spec
phase: specify
skills: [research]
---

# OS Profile Spec — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `project-management/REFERENCES.md` (external OS and kernel sources) ·
> `project-management/src/07-OS-PROFILES/CLAUDE.md` (naming and status) ·
> `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` (the eleven axes) for supporting
> references.

## Execution Checklist

### Step 1 — Explain the profile first, then gather the inputs

- [ ] The learner described the profile's target user before any drafting, and the answer is recorded
- [ ] The P5 and P6 rows of `ROADMAP.md`, the matrix, the profile file and its cited notes and ADRs were read

### Step 2 — Research the axis values that rest on memory

- [ ] Every axis value cites a research note or primary source, or is marked as an assumption to test
- [ ] Each new note answers one question and sits at `research/<SCREAMING-KEBAB-TOPIC>.md`

### Step 3 — Open the profile file, or copy the template

- [ ] The profile file is one of the seven `PROFILE-<NAME>.md` files (beginner, intermediate, expert, server, nas, homelab, router)
- [ ] No `{PLACEHOLDER}` or `[EXAMPLE]` row survives in a copied file
- [ ] Header fields (date, driving milestone, status) are current

### Step 4 — Fill every axis against the matrix

- [ ] Every one of the eleven matrix axes has a value and a one-line reason in the profile file
- [ ] The profile's column in `PROFILE-MATRIX.md` matches the profile file cell for cell
- [ ] Values shared with another profile are marked as shared on purpose

### Step 5 — Write the hypotheses

- [ ] Every user-facing axis has at least one hypothesis
- [ ] Every hypothesis names its test in QEMU, its pass condition and the phase that tests it
- [ ] No hypothesis relies on an adjective ("easy", "minimal") instead of an observation

### Step 6 — Check the profiles against each other and against the ADRs

- [ ] No hypothesis in one profile is contradicted by another profile's axis value
- [ ] No axis value conflicts with an Accepted ADR
- [ ] Every hard-to-reverse choice (init, package manager and signing, bootloader, storage layer, hardware) cites an ADR
- [ ] Still seven profiles (an eighth would need an ADR and a `ROADMAP.md` change)

### Step 7 — Cross-link and set the status

- [ ] The profile file links its research notes, ADRs and driving milestone by full repo-relative path
- [ ] The driving milestone links back to the profile file
- [ ] Later-phase ideas moved to `DEFERRED.md` with a `DEFERRED (MS###)` marker

### Step 8 — Commit by explicit path

- [ ] Files staged by name (no `git add -A`, no `git add .`)
- [ ] Commit message follows Conventional Commits with scope `os` or `research`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `project-management/REFERENCES.md` lists any new artefact type or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] The profile file and `PROFILE-MATRIX.md` agree cell for cell
- [ ] Every hypothesis is testable in QEMU and names its test, pass condition and phase
- [ ] Every hard-to-reverse choice cites an ADR, Proposed or Accepted
- [ ] The work is committed, ready for `project-management/workflows/08-decisions/`
