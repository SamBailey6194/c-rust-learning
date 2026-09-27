---
workflow: 12-review-and-reflect
phase: record
skills: []
---

# Review and Reflect — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `code/workflows/05-review/` (the content review) · `project-management/src/12-FINDINGS/CLAUDE.md`
> (finding records) · `project-management/docs/planning/SPRINTS.md` (the Retrospective) ·
> `project-management/REFERENCES.md` for supporting references.

## Execution Checklist

### Step 1 — Explain first: the learner reviews their own code

- [ ] The learner named three places they were least sure of, before any review ran

### Step 2 — Run the content review

- [ ] `code/workflows/05-review/` covered every file the milestone changed under `code/src/`
- [ ] The review record exists in `project-management/src/11-REVIEWS/`, copied from its template

### Step 3 — Confirm the review record

- [ ] Every dimension in the template is filled
- [ ] Every finding names the `code/docs/` section that applies
- [ ] The review's findings were compared with the learner's list

### Step 4 — Resolve or route the required actions

- [ ] Behaviour changes went through `code/workflows/07-debug/`, with a bug record where earned
- [ ] Behaviour-preserving changes went through `code/workflows/08-refactor/`
- [ ] Later-phase items are in `DEFERRED.md` with a `DEFERRED (MS###)` marker
- [ ] The learner made every code change; anything changed was re-verified and the record updated

### Step 5 — Gather the misconceptions

- [ ] `PROGRESS.md` journals, bug records, review findings and the verification prediction were all read
- [ ] Each misconception has what was believed, what is true, and a source

### Step 6 — Write the finding record

- [ ] The record is in `project-management/src/12-FINDINGS/`, named per that folder's `CLAUDE.md`
- [ ] Misconceptions corrected, Expensive to relearn and Carried into the next milestone are filled
- [ ] The record links its milestone, plan, review and verification record
- [ ] A milestone with little to report still has a record saying so, with its evidence

### Step 7 — Route to the registers and schedule re-drills

- [ ] Blockers are in `GAPS.md`, parked topics in `DEFERRED.md`, working patterns in `.claude/MEMORY.md`
- [ ] No item appears in more than one register
- [ ] Every expensive-to-relearn item has a review-queue row in its topic's `PROGRESS.md`

### Step 8 — Write the Retrospective when the sprint closes

- [ ] For a closing sprint: What stuck, What did not and One change are drafted
- [ ] For a closing sprint: Velocity and Carried over are filled after the merge, and the sprint is
      `Closed`

### Step 9 — Commit by explicit path

- [ ] Only the files this workflow changed are staged, by name, with scope `pm`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `project-management/REFERENCES.md` lists any new artefact type or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] The milestone has a complete review record and every required action is resolved or routed
- [ ] The milestone has a finding record, and its carried-forward rows are ready for the next plan
- [ ] Each register holds only its own kind of entry
- [ ] The milestone is committed and ready for `project-management/workflows/13-pr-and-merge/`
