---
workflow: 02-daily-study-session
phase: run
skills: [teach, handoff]
---

# Daily Study Session — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `how-to/REFERENCES.md` → **Internal → Steps & checklists** (`01-toolchain-setup`,
> `03-quality-gates`) · **Internal → Cross-layer** (`project-management/docs/git/BRANCHES.md`,
> `project-management/workflows/10-study-and-build/`) for supporting references.

## Execution Checklist

### Step 1 — Pull, and switch to the milestone in flight

- [ ] `git fetch --prune` ran and `git pull --ff-only` succeeded on `main`
- [ ] On the milestone branch in flight, pulled up to date, if `git branch -r --list 'origin/ms*'` listed one

### Step 2 — Read the open handoff

- [ ] The newest open handoff from `git ls-files 'handoffs/HANDOFF-*.md'` (or, with none open, the newest
      PROGRESS entry) was read in full

### Step 3 — Pick today's unit

- [ ] Exactly one unit chosen from the current sprint, milestone plan or milestone file

### Step 4 — Be on the milestone's branch

- [ ] `git branch --show-current` shows the milestone's one `ms###/<short-kebab>` branch, per `BRANCHES.md`
- [ ] A branch cut today was named for the milestone, not the day's unit, before the first commit

### Step 5 — Check the toolchain

- [ ] `toolchain/check.sh` exited 0

### Step 6 — Study and exercise

- [ ] New concepts went through `/teach` in `learning/`, not straight into `code/`
- [ ] Claude asked for the learner's approach before helping, and wrote no unrequested solution

### Step 7 — Run the gates

- [ ] `gates/all.sh` and `npx --yes markdownlint-cli2` exited 0, or every failing or skipped gate is
      recorded in today's PROGRESS entry
- [ ] No gate that exited 2 was treated as green

### Step 8 — Check the PROGRESS entry

- [ ] Today's single journal entry exists in the topic's `PROGRESS.md`, with the gate results on its
      **Built** line

### Step 9 — Commit and push

- [ ] Every file staged by explicit path; no `git add -A` or `git add .`
- [ ] One commit per scope, each following Conventional Commits; a commit made with a gate failing names
      that gate in its body
- [ ] Branch pushed

### Step 10 — Hand off if the unit is unfinished

- [ ] An unfinished unit has a committed `handoffs/HANDOFF-…-DD-MM-YYYY.md`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `how-to/REFERENCES.md` lists any new guide, workflow or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] The day's unit advanced, and its code builds with zero warnings
- [ ] Sanitiser and valgrind runs are clean for any C touched (`All heap blocks were freed -- no leaks are possible`)
- [ ] Rust tests, `cargo fmt --check` and clippy are green for any Rust touched
- [ ] PROGRESS entry written; work committed and pushed on the milestone's branch
- [ ] An unfinished unit has a handoff; a finished one returns to `project-management/workflows/10-study-and-build/`
      for the next item (the milestone's pull request comes after `11-verification` and `12-review-and-reflect`)
