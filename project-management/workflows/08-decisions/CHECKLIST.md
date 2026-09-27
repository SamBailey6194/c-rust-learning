---
workflow: 08-decisions
phase: decide-and-plan
skills: [research]
---

# Decisions (ADRs) — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `project-management/src/08-DECISIONS/CLAUDE.md` (authoring rules) ·
> `project-management/src/08-DECISIONS/ADR-MS000-TEMPLATE.md` (the five-section scaffold) ·
> `project-management/REFERENCES.md` for supporting references.

## Execution Checklist

### Step 1 — Explain the decision first, then list the ADR set

- [ ] The learner stated each open decision as a single question, with the cost of not deciding
- [ ] Every existing ADR for the milestone was listed by `MS###` prefix and read

### Step 2 — Check each record still holds

- [ ] Each ADR's Context was re-read against what later workflows decided
- [ ] Every falsified premise is queued for supersession, not for an edit

### Step 3 — Check no two clash

- [ ] The set was compared pairwise on what each Decision commits the repo to
- [ ] Each clash has a named loser, agreed with the learner

### Step 4 — Confirm each gap is ADR-worthy

- [ ] Every unrecorded choice was tested: hard to reverse, or would need explicit supersession
- [ ] Choices that failed the test were written into the milestone plan instead

### Step 5 — Ground the contested options in research

- [ ] Every factual claim in the options cites a research note or an upstream document

### Step 6 — Copy the template and write the record

- [ ] Filename is `ADR-MS###-<DECISION>-DD-MM-YYYY.md`, flat in `project-management/src/08-DECISIONS/`
- [ ] The header table (Status `Proposed`, date, milestone, deciders, research, enforced in) is filled
- [ ] Context, Options considered, Decision, Consequences and Sources are all filled
- [ ] Every option has a Summary, Pros and Cons; "do nothing" or "defer" appears where it is honest
- [ ] The Decision names the learner's deciding factor
- [ ] Consequences cover Positive, Negative and Follow-on, and Follow-on names the enforcing file

### Step 7 — Supersede with two-way links

- [ ] Each new record's "Supersedes" holds the old record's full filename
- [ ] Each old record's "Superseded by" holds the new record's full filename, and its Status is
      `Superseded`
- [ ] No other field of an Accepted record was edited

### Step 8 — Accept and cross-link

- [ ] Status flipped to `Accepted` only after the learner signed off
- [ ] The driving milestone references every ADR in the set

### Step 9 — Commit by explicit path

- [ ] Files staged by name, with both sides of any supersession in the same commit
- [ ] Commit message follows Conventional Commits with scope `pm`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `project-management/REFERENCES.md` lists any new artefact type or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] Every hard-to-reverse choice the milestone made is recorded as an ADR
- [ ] The milestone's whole ADR set is Accepted and internally consistent
- [ ] Every supersession is linked both ways by full filename
- [ ] The work is committed, ready for `project-management/workflows/09-milestone-plans/`
