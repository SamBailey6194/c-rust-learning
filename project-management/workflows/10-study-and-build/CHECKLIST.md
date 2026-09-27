---
workflow: 10-study-and-build
phase: build
skills: [teach, handoff]
---

# Study and Build — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `.claude/skills/teach/SKILL.md` (the lesson loop and review curve) · `code/workflows/CONTEXT.md`
> (the build workflows) · `project-management/REFERENCES.md` for supporting references.

## Execution Checklist

### Step 1 — Open on the due reviews

- [ ] Every queue row due today or earlier was found
- [ ] Each due review was answered without notes, then confirmed or corrected
- [ ] Each row moved along the curve: pass to the next interval, partial or miss back to +1

### Step 2 — Pick the next item from the plan

- [ ] The item is the next unfinished one in the plan's exercise order
- [ ] The session names one exercise and one prerequisite concept
- [ ] On the milestone's first session (or its first after `11-verification` sent it back): its Status and
      the `ROADMAP.md` "You are here" row read `In Progress`

### Step 3 — Teach the concept with `/teach`

- [ ] The topic folder is `learning/<track>-NN-<topic>/` with `MISSION.md`, `RESOURCES.md`, `PROGRESS.md`
- [ ] `RESOURCES.md` cites a primary source for the concept
- [ ] The learner answered a recall question unaided, or the miss is noted

### Step 4 — Explain it back and state the approach

- [ ] The learner explained the concept in their own words
- [ ] The learner stated their approach before Claude offered any help

### Step 5 — Write the failing test first

- [ ] The test was written before the code it tests
- [ ] The test failed, for the reason the learner predicted
- [ ] Rust commands ran from inside `code/src/rust/`

### Step 6 — Build the exercise until it is clean

- [ ] The learner wrote the exercise code; Claude gave hints, questions and `code/docs/` pointers only
- [ ] The exercise's tests pass
- [ ] For a C exercise: `make -C code/src/c/ms###-<kebab> san` and `memcheck` both exit 0
- [ ] For a milestone whose Kernel flag is not `N/A`: the `KERNEL-IMPL` record is written through
      `project-management/workflows/06-kernel-spec/` → RECORD, with the build and boot evidence pasted

### Step 7 — Write the note and log the lesson

- [ ] `NOTES/NN-<concept>.md` is in the learner's own words and links the exercise by path
- [ ] `PROGRESS.md` holds today's journal entry and a matching review-queue row

### Step 8 — Log bugs and misconceptions as they happen

- [ ] Every bug that needed investigation has a record in `project-management/src/13-BUGS/`
- [ ] Every corrected misconception is in the topic's `PROGRESS.md` journal

### Step 9 — Commit by explicit path

- [ ] Work committed on the milestone branch, staged by explicit path after `git status --short`
- [ ] No build output (`build/`, `target/`) staged
- [ ] Conventional Commits messages with scope `c`, `rust`, `kernel` or `learning` (and `pm` for a status change)

### Step 10 — Close the session

- [ ] **Next session opens on** is set in `PROGRESS.md`
- [ ] The finished item is ticked in the plan

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `project-management/REFERENCES.md` lists any new artefact type or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] Per session: due reviews answered, one concept taught, one exercise advanced with passing tests
- [ ] Per milestone: every exercise in the plan is built, tested and clean under `san` and `memcheck`
- [ ] No exercise solution was written by Claude unless the learner explicitly asked for one
- [ ] The milestone is ready for `project-management/workflows/11-verification/`
