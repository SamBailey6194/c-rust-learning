---
workflow: 02-daily-study-session
phase: run
skills: [teach, handoff]
---

# Daily Study Session — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section |
| --- | --- |
| 1, 4, 9 | **Internal → Cross-layer** → `project-management/docs/git/BRANCHES.md`, `project-management/docs/git/COMMITS.md` |
| 2 | **Internal → Cross-layer** → `handoffs/CONTEXT.md`, `learning/CONTEXT.md` |
| 3 | **Internal → Cross-layer** → `project-management/src/03-STUDY-SPRINTS/`, `project-management/src/09-MILESTONE-PLANS/` |
| 5 | **Internal → Steps & checklists** → `how-to/workflows/01-toolchain-setup/STEPS.md` |
| 6 | **Internal → Cross-layer** → `project-management/workflows/10-study-and-build/`, `code/workflows/CONTEXT.md` |
| 7 | **Internal → Steps & checklists** → `how-to/workflows/03-quality-gates/STEPS.md` |

---

## Steps

### Step 1 — Pull, and switch to the milestone in flight

```bash
git fetch --prune
git switch main
git pull --ff-only
git branch -r --list 'origin/ms*'
```

`git pull --ff-only` prints `Already up to date.` or a fast-forward summary. If it refuses because the
histories diverged, stop and resolve that first (`project-management/docs/git/BRANCHES.md`). The last
command lists the milestone branch in flight; there is at most one, because milestones run one at a time.
If it lists one, switch to it and bring it up to date, since handoffs and the day's work live there:

```bash
git switch ms###/<short-kebab>     # on a fresh clone this creates the local branch from origin
git pull --ff-only
```

_Done when `main` is current and you are on the up-to-date milestone branch, or on `main` if none is in
flight._

### Step 2 — Read the open handoff

```bash
git ls-files 'handoffs/HANDOFF-*.md'
```

Handoffs are deleted once their work resumes (`handoffs/CLAUDE.md`), so this lists only open ones; the
newest carries the latest `DD-MM-YYYY` in its name. Read it in full: the branch, the unit, what was tried,
and the next step. If the command prints nothing, there is no open handoff; read the newest dated entry in
the current topic's `learning/<track>-NN-<topic>/PROGRESS.md` instead.

_Done when you can say, in one sentence, where the last session stopped and what comes next._

### Step 3 — Pick today's unit

```bash
ls project-management/src/03-STUDY-SPRINTS/ project-management/src/09-MILESTONE-PLANS/
```

Open the live sprint record and the current milestone's plan (or, before the plan exists, the milestone
file itself, such as `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` and its Tasks) and
choose **one** unit: the next exercise in the plan's order, from `project-management/src/04-EXERCISES/`,
or the milestone's next task. One unit that finishes beats three that half-start.

_Done when today's unit is named and you can state what "finished" means for it._

### Step 4 — Be on the milestone's branch

Step 1 has usually done this. A milestone has one branch, named for the milestone rather than the day's
unit, and opened by `project-management/workflows/02-milestone-creation/`
(`project-management/docs/git/BRANCHES.md` → _Branch prefixes_). Only if the current milestone
has none yet, cut it from an up-to-date `main`:

```bash
git switch -c ms001/toolchain-ready
```

Replace it with the current milestone's number and short name. This is the hard gate: the name follows
`BRANCHES.md` **before** the first commit.

_Done when `git branch --show-current` prints the milestone's `ms###/<short-kebab>` branch._

### Step 5 — Check the toolchain

```bash
bash code/src/scripts/toolchain/check.sh
echo "exit=$?"
```

`exit=0` means every required tool is present. `exit=2` means one is missing; fix the environment first
through `how-to/workflows/05-debugging-environment/` rather than studying on a broken machine.

_Done when `check.sh` exits 0._

### Step 6 — Study and exercise

New concept? Start with the tutor. It keeps its notes in `learning/`, and Claude writes no exercise code;
the lesson's runnable example is yours, and it lands under `code/src/` through the code workflow:

```text
/teach pointers and arrays
```

Replace the topic with today's. Then do the exercise through the matching code workflow —
`code/workflows/01-c-exercise/`, `02-tdd-cycle/`, `03-rust-exercise/` or `04-ffi-bridge/` — which
`project-management/workflows/10-study-and-build/` routes you to. Claude tutors here: it asks how you
plan to approach the problem before it helps, and it does not write the solution unless you ask.

The exercise comes from the current milestone's `EX-MS###-<TOPIC>.md` spec, and its folder takes that
milestone's number. A milestone with no spec — MS001, whose Exercises flag is `N/A` — has no exercise:
its sessions work through the milestone's Tasks, and a new topic such as pointers waits for the milestone
that specifies it (`.claude/skills/teach/SKILL.md` → the build step).

_Done when the unit's exercise builds and its tests are written, or the session has reached a clean
stopping point._

### Step 7 — Run the gates

Run the gates for what you touched (raw commands first, as in `how-to/workflows/03-quality-gates/`), then
the one-shot run, then the Markdown lint, which `gates/all.sh` does not include:

```bash
bash code/src/scripts/gates/all.sh
echo "exit=$?"
npx --yes markdownlint-cli2
```

`exit=0` is green. `exit=1` names the failing gate in the summary table; fix it now, while the change is
fresh. `exit=2` means a gate could not run, which is not green — go to
`how-to/workflows/05-debugging-environment/`. The Markdown lint needs Node.js
(`how-to/src/MACHINE-SETUP.md` Part A, step 8); without it, say so in the PROGRESS entry, because CI's
`Markdown — Lint` runs it on every push.

_Done when `gates/all.sh` and the Markdown lint exit 0, or every failing or skipped gate is written into
today's PROGRESS entry._

### Step 8 — Check the PROGRESS entry

The session writes one journal entry, and `project-management/workflows/10-study-and-build/` Step 7 has
already appended it to the topic's `learning/<track>-NN-<topic>/PROGRESS.md`, in the format
`learning/CLAUDE.md` sets. Confirm it exists, add today's gate results from Step 7 to its **Built**
line, and record any dead end; dead ends are what stop the next session repeating them. A session with
no lesson (a MS001 task, say) appends one entry in the same format.

_Done when today's single entry exists, carries the gate results, and names the next review or step._

### Step 9 — Commit and push

Stage each file by name (never `git add -A` or `git add .`) and use one Conventional Commit per scope,
per `project-management/docs/git/COMMITS.md`. For example:

```bash
git status
git add code/src/c/ms007-dynamic-array/vec.c
git commit -m "feat(c): grow the vector by doubling"
git add learning/c-02-pointers-and-memory/PROGRESS.md
git commit -m "docs(learning): realloc lesson and review schedule"
git push -u origin "$(git branch --show-current)"
```

A session that has to stop with a gate still failing may still commit, with the failing gate named in
the message body, as `project-management/docs/git/COMMITS.md` allows. A finished unit goes back to
`project-management/workflows/10-study-and-build/` for the next item; the pull request comes once, for
the whole milestone, after `11-verification` and `12-review-and-reflect`
(`project-management/workflows/13-pr-and-merge/`).

_Done when `git status` shows nothing from today left uncommitted and the branch is pushed._

### Step 10 — Hand off if the unit is unfinished

```text
/handoff
```

The skill writes `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md` with the branch, the unit,
what was tried and the next step. Commit it by explicit path, as in Step 9. A finished unit needs no
handoff; its PROGRESS entry is the record.

_Done when an unfinished unit has a committed handoff, or the unit is finished._

---

## Update context files

If this workflow created files or folders, or settled a new convention:

1. Add every new file or folder to the directory tree in the nearest `CONTEXT.md`; a new directory also
   gets its own `CONTEXT.md` and `CLAUDE.md`.
2. Add any new guide, workflow or external source to `how-to/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
