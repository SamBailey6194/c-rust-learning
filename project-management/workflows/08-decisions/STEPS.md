---
workflow: 08-decisions
phase: decide-and-plan
skills: [research]
---

# Decisions (ADRs) — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `project-management/REFERENCES.md` → **External — Decisions** (the original ADR form) as you work
through these steps:

| Step | Section |
| --- | --- |
| All | `project-management/src/08-DECISIONS/CLAUDE.md` — immutability, naming, the driving-milestone rule |
| 1 to 3 | `project-management/src/08-DECISIONS/` — the existing ADR set, listed by `MS###` prefix |
| 5 | `.claude/skills/research/SKILL.md` — primary-source notes that ground a contested option |
| 6 | `project-management/src/08-DECISIONS/ADR-MS000-TEMPLATE.md` — the five-section scaffold |
| 8 | `project-management/docs/planning/MILESTONES.md` — where a milestone records its decisions |
| 9 | `project-management/docs/git/COMMITS.md` — commit scopes and staging by explicit path |

---

## Steps

### Step 1 — Explain the decision first, then list the ADR set

Explain-first (`project-management/workflows/CONTEXT.md` → _Explain-first_): ask the learner to state
each open decision as one question ("Which kernel base do the tiers build
on?") and to say what happens if nothing is decided. Then list the records the milestone already has,
plus any it might supersede:

```bash
ls project-management/src/08-DECISIONS/ADR-MS###-*
ls project-management/src/08-DECISIONS/
```

Read every record the milestone raised and note which workflow surfaced it.

_Done when every open decision is written as a question and every existing ADR for the milestone is read._

### Step 2 — Check each record still holds

A decision taken at `04-exercise-design` was taken before `06-kernel-spec` or `07-distro-tier-spec` ran.
Re-read each ADR's Context against what later work decided or discovered: is the problem still real, are
its constraints still true? A falsified premise (a tool that is now installed, a standard that is now
supported) means the record is superseded at Step 7, never edited.

_Done when every ADR is marked, in your notes, as "holds" or "superseded by a new record at Step 7"._

### Step 3 — Check no two clash

Compare the set pairwise on what each Decision section commits the repo to. A clash is two records that
cannot both be followed, or whose Consequences contradict each other. Decide with the learner which one
loses; the loser is superseded at Step 7.

_Done when every pair has been compared and each clash has a named loser._

### Step 4 — Confirm each gap is ADR-worthy

Some choices get made without anyone writing them down. For each one, apply the test: is it hard to
reverse, or would a later decision need to supersede it explicitly? If yes, it gets an ADR. If not,
record it as a line in the milestone plan (`09-milestone-plans`) and move on.

_Done when every unrecorded choice is either queued for an ADR or written into the plan._

### Step 5 — Ground the contested options in research

For any option whose case rests on a factual claim (what gcc 13 supports under `-std=c2x`, what the
kernel requires to build Rust code), run `/research <question>` and cite the resulting
`research/<SCREAMING-KEBAB-TOPIC>.md` from the Context. Check the upstream documentation itself; version
support moves faster than memory.

_Done when every factual claim in the options cites a note or a primary source._

### Step 6 — Copy the template and write the record

Copy `ADR-MS000-TEMPLATE.md` to `ADR-MS###-<DECISION>-DD-MM-YYYY.md` in the same folder, with the driving
milestone, the decision in SCREAMING-KEBAB-CASE and today's date, and follow the template's own copy
instruction. Then fill it:

1. **Status** — the header table: Status `Proposed`, the date, the driving milestone, the deciders, the
   research note, and where the rule will be enforced; Supersedes and Superseded by stay as a dash
   unless Step 7 fills them.
2. **Context** — the problem, constraints and facts on the day, neutral enough that someone who
   disagrees with the outcome still recognises the problem. Tool facts are checked with the tool itself
   (`gcc --version`, `man gcc`) and cited.
3. **Options considered** — Summary, Pros and Cons for each realistic option, including "do nothing" or
   "defer" where either is honest.
4. **Decision** — the chosen option and the specific deciding factor. Ask the learner for it and record
   their reason.
5. **Consequences** — Positive, Negative (what the repo accepts as the cost) and Follow-on (the file
   where the rule will be enforced, the milestone it unblocks, the `GAPS.md` entry it opens).

List every source the Context and Options lean on in the template's Sources section.

_Done when the header and every section are filled and no `{PLACEHOLDER}` or `[EXAMPLE]` line remains._

### Step 7 — Supersede with two-way links

For every record that Step 2 found falsified or Step 3 found losing a clash: set this new record's
"Supersedes" to the old record's full filename, then open the old record and set its "Superseded by" to
this record's full filename and its Status to `Superseded`. Those two fields are the only edits an
Accepted record ever takes.

_Done when every supersession is linked in both directions by full filename._

### Step 8 — Accept and cross-link

Once the learner signs off, flip Status from `Proposed` to `Accepted`; from here the record is immutable.
List each ADR under the **Decisions** field of the driving milestone in
`project-management/src/02-MILESTONES/`, and cite it from the spec that surfaced it where one exists. The
gate closes when the milestone's whole ADR set is Accepted and consistent, not when the last record is
written.

_Done when every ADR in the set is Accepted and referenced from its milestone._

### Step 9 — Commit by explicit path

```bash
git add project-management/src/08-DECISIONS/ADR-MS###-<DECISION>-DD-MM-YYYY.md \
        project-management/src/02-MILESTONES/MS###-<TITLE>.md
git commit -m "docs(pm): record ADR-MS###-<DECISION>"
```

Include the superseded record in the same commit when Step 7 edited one, so the two links land together.

_Done when `git status` shows nothing from this workflow left uncommitted._

---

## Update context files

If this workflow created files or folders, or settled a new convention:

1. Add every new file or folder to the directory tree in the nearest `CONTEXT.md`.
2. Add any new artefact type or external source to `project-management/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
