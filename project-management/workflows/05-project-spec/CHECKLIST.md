---
workflow: 05-project-spec
phase: specify
skills: [research]
---

# Project Spec — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `project-management/REFERENCES.md` (valgrind, GCC and Rust sources) ·
> `project-management/src/05-PROJECTS/CLAUDE.md` (naming, status, no solutions) ·
> `project-management/docs/SAFETY-GUIDE.md` (memory and `unsafe`) for supporting references.

## Execution Checklist

### Step 1 — Explain-first on what the program needs

- [ ] The milestone's `Project` flag is not `N/A`
- [ ] For a later part, the existing spec was opened rather than a new one started
- [ ] The learner described the program, its reference behaviour and the part they expect to be hardest

### Step 2 — Copy the template and fix the scope

- [ ] The spec is named for the project's first milestone, `Status: Draft`
- [ ] In scope and out of scope are both written, each out-of-scope item with a reason

### Step 3 — Write the interface or behaviour, and the parts

- [ ] Every expected behaviour cites a reference program, a man page, the standard or a research note
- [ ] The parts table gives each part one responsibility and no implementation

### Step 4 — Cut the milestones

- [ ] Every part is a milestone-sized row of 8 points or fewer; later rows read `—` until they are cut
- [ ] Later parts exist as slices on the track's map

### Step 5 — Write acceptance and the test strategy

- [ ] Every acceptance scenario names an exact command and result
- [ ] Every C part names `san` and `memcheck`; an allocator states which memory-testing option it takes
      and what that option cannot detect

### Step 6 — Stretch goals, risks, resource budget, threat model, status and links

- [ ] Stretch goals are marked not required; risks have a likelihood and a fallback
- [ ] `## 8. Resource budget` filled (or `N/A` with a reason; never `N/A` for a kernel-config, OS or LLM project)
- [ ] `## 9. Threat model` filled — assets, threats and mitigations, or the non-negotiable it runs under
- [ ] Hard-to-reverse design choices went to `08-decisions`
- [ ] `Status: Ready`, linked from every milestone the project spans so far

### Step 7 — Commit by explicit path

- [ ] Committed on the milestone branch, files staged by name, scope `pm`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `project-management/REFERENCES.md` lists any new artefact type or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] "Finished" is defined by acceptance scenarios, fixed before the first part is built
- [ ] Every part closes on its own verification record
- [ ] The spec contains no solution
- [ ] British English throughout; dates DD/MM/YYYY
