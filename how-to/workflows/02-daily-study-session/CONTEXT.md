# Workflow: Daily Study Session

**Last Updated**: 27/09/2026

A session that starts without reading the last handoff re-learns yesterday before learning today. This
is the short routine around each study session: pick up where the last one stopped, study one unit,
prove it with the gates, and leave a trail the next session can start from.

## Directory Tree

```text
how-to/workflows/02-daily-study-session/
├── CONTEXT.md · CLAUDE.md   ← when to use, key concepts (this file) · operating rules
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← verification before the session counts as complete
```

## When to use this

- At the start of every study session, whatever the track (C, Rust, and later kernel or distro work).
- When returning after a break of any length: the handoff and the latest PROGRESS entry are the memory.

It wraps the study itself rather than replacing it. The unit of study follows
`project-management/workflows/10-study-and-build/` and the code workflows it names; this workflow is the
session routine around that unit.

## Key concepts

- **Handoff first.** `handoffs/` holds one committed note per unfinished session. The newest one names
  the branch, the unit, and the next step, which saves re-deriving them from `git log`.
- **One unit per session.** Today's unit comes from the current study sprint
  (`project-management/src/03-STUDY-SPRINTS/`) or the milestone plan
  (`project-management/src/09-MILESTONE-PLANS/`). The current milestone is MS001, Toolchain ready.
- **One milestone, one branch.** Every session of a milestone works on its one `ms###/<short-kebab>`
  branch, which also carries its handoffs; the name is settled before the first commit
  (`project-management/docs/git/BRANCHES.md`).
- **Learn in `learning/`, keep in `code/`.** `/teach` guides the study and records it under
  `learning/<track>-NN-<topic>/`; an exercise worth keeping lands in `code/src/` through the code
  workflows.
- **The gates prove the day's work.** Zero warnings, clean sanitisers, a clean valgrind run, and green
  Rust tests, format and lints — the list lives in `how-to/workflows/03-quality-gates/`.
- **PROGRESS is the log.** Each session appends a dated entry to the topic's `PROGRESS.md`; a session
  that ends mid-unit also writes a handoff.

## Cross-references

### Governing documents

- `project-management/docs/git/BRANCHES.md` — the branch name is correct before the first commit
- `how-to/workflows/03-quality-gates/` — the gate list the session is proved against

### Related reading

- `project-management/workflows/10-study-and-build/` — the study procedure this session wraps
- `.claude/skills/teach/SKILL.md` — `/teach`, the guided study that writes to `learning/`
- `.claude/skills/handoff/SKILL.md` — `/handoff`, for a session that ends before the unit does
- `learning/CONTEXT.md` — how topic folders and their `PROGRESS.md` are laid out
- `code/workflows/CONTEXT.md` — the build workflows (C exercise, TDD cycle, Rust exercise, FFI bridge)
- `project-management/docs/git/COMMITS.md` — commit format, scopes, staging by explicit path
