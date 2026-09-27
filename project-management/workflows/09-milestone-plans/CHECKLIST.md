---
workflow: 09-milestone-plans
phase: decide-and-plan
skills: []
---

# Milestone Plans — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `project-management/src/09-MILESTONE-PLANS/CLAUDE.md` (naming, exec-order) ·
> `code/docs/BUILD.md` (targets and flags) · `project-management/REFERENCES.md` for supporting
> references.

## Execution Checklist

### Step 1 — Explain the milestone first, then gather the inputs

- [ ] The learner's prior knowledge and predicted hardest part are recorded
- [ ] Milestone, sprint record, flagged specs, Accepted ADRs, `DEFERRED.md` and `GAPS.md` entries were read

### Step 2 — Compute the exec-order and copy the template

- [ ] The plan was copied from `00-PLAN-MS000-TEMPLATE.md`, not written free-hand
- [ ] Filename is `<exec-order>-PLAN-MS###-<DESC>.md` with a two-digit prefix from `01`
- [ ] The prefix matches the milestone's position in the whole roadmap's build order
- [ ] Any plan whose position moved was renumbered, with every citation, in the same change

### Step 3 — List the resources and chapters

- [ ] Every concept has a primary source with chapter or section and a link
- [ ] No copyrighted text is pasted into the plan

### Step 4 — Order the exercises

- [ ] Exercises run smallest concept first
- [ ] Each exercise names its spec, its code folder, its code workflow and its prerequisite concept

### Step 5 — Write the verification commands

- [ ] Every mastery criterion maps to a raw command and the script that wraps it
- [ ] Rust commands run from inside `code/src/rust/` so the pinned toolchain applies
- [ ] The table ends with `bash code/src/scripts/gates/all.sh`
- [ ] Every command runs on the host as `how-to/docs/TOOLCHAIN.md` describes it

### Step 6 — Record the risks and deferred items

- [ ] Every risk has a trigger and a response
- [ ] Blocking risks also appear in `GAPS.md`
- [ ] Deferred topics appear in `DEFERRED.md` with a `DEFERRED (MS###)` marker

### Step 7 — Leave the As-Built summary as a stub

- [ ] The As-Built section exists and is marked as pending until `11-verification`

### Step 8 — Have the learner explain the plan back

- [ ] The learner explained the order, the proof and the top risk without reading from the plan
- [ ] Every hesitation was fixed in the plan

### Step 9 — Cross-link and commit

- [ ] The plan links its milestone, sprint, specs and ADRs; the milestone links back
- [ ] Files staged by name; Conventional Commits message with scope `pm`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `project-management/REFERENCES.md` lists any new artefact type or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] Every mastery criterion has a runnable verification command written before any code
- [ ] Every exercise is sequenced, specified and routed to a code workflow
- [ ] Risks and deferrals are recorded in the plan and in the right register
- [ ] The plan is committed, ready for `project-management/workflows/10-study-and-build/`
