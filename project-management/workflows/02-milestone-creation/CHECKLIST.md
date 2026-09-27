---
workflow: 02-milestone-creation
phase: plan
skills: []
---

# Milestone Creation — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `project-management/REFERENCES.md` (Connextra, Gherkin, MoSCoW, Fibonacci) ·
> `project-management/docs/planning/MILESTONES.md` (format, flags, estimation, statuses) ·
> `project-management/src/02-MILESTONES/CLAUDE.md` (naming) for supporting references.

## Execution Checklist

### Step 1 — Explain-first, then load the slice

- [ ] The learner said what they know, predicted the pitfalls and explained the concept back, before
      any drafting
- [ ] The slice row is from a resolved map, and every node it carries is resolved
- [ ] `DEFERRED.md` was checked for topics parked until this phase

### Step 2 — Open the branch and copy the template

- [ ] The milestone branch `ms###/<short-kebab>` was opened from an up-to-date `main`
- [ ] The file takes the next free `MS###` and follows the folder's naming pattern

### Step 3 — Write the header and the learning story

- [ ] Track, Phase (cited from `ROADMAP.md`) and `Status: Open` are set
- [ ] The learning story's "so that" names what the milestone unlocks

### Step 4 — Fill all eleven flags

- [ ] Every row holds a value or `N/A` with a reason; none is blank
- [ ] The values agree with the slice's manifest, or the difference was settled with the learner

### Step 5 — Write the mastery criteria

- [ ] Every flag that runs a command has a scenario naming the exact command and result
- [ ] Every command exists as written (`code/docs/BUILD.md`) and runs from the repository root
- [ ] At least one scenario is an explain-back built from the Step 1 gaps

### Step 6 — Set MoSCoW and points

- [ ] The learner estimated first; the estimate is a Fibonacci number
- [ ] The points are 8 or fewer; an estimate of 13 or more went back to `01-roadmap-map` to be split
- [ ] MoSCoW reflects what depends on the milestone

### Step 7 — Record dependencies and decisions

- [ ] Every dependency names a milestone and a reason
- [ ] Every ADR is cited by full path; any new hard-to-reverse choice went to `08-decisions`
- [ ] Sections whose flag is `N/A` are deleted; no `[PLACEHOLDER]` or `[EXAMPLE]` remains

### Step 8 — Back-fill the map and commit by explicit path

- [ ] The map's slice names the new `MS###`, and the folder's milestone table has its row
- [ ] Files staged by name on the milestone branch; a `docs(pm):` message in Conventional Commits form

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `project-management/REFERENCES.md` lists any new artefact type or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] An observer could run every mastery criterion and agree it passed without asking the learner
- [ ] The milestone is sized for one sprint and prioritised
- [ ] It is ready for `project-management/workflows/03-sprint-planning/`
- [ ] British English throughout; dates DD/MM/YYYY
