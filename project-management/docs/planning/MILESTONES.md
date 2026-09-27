---
type: guide
---

# Milestones

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Writing an `MS###` milestone (`project-management/src/02-MILESTONES/`): its format, its mastery
criteria, its flags, its size and its status. **This file owns the milestone status vocabulary**;
every other file points here. Index: [`project-management/docs/PLANNING-GUIDE.md`](../PLANNING-GUIDE.md).

---

## Cutting milestones from the map

Milestones are cut from a resolved map in `project-management/src/01-ROADMAP/`, not invented from a
conversation. A milestone whose shape is still an open node on the map is premature: settle the node
first, or the mastery criteria encode a guess.

**One milestone is one concept you can prove you have learned**, not one chapter and not one tool.
"Read the chapter on `malloc`" is a task inside a milestone; "I can build a growable array that
survives `make memcheck`" is a milestone.

---

## Milestone format

Every milestone is a copy of `project-management/src/02-MILESTONES/MS000-TEMPLATE.md`, and carries:

| Field | What it holds |
| --- | --- |
| **Track** | `C`, `Rust`, `Kernel` or `Distro`; a milestone that genuinely spans two (a toolchain or FFI milestone) names both, as `C + Rust` |
| **Phase** | Exactly one of `P1`–`P6`, as defined in `project-management/src/01-ROADMAP/ROADMAP.md` |
| **Status** | One value from _Statuses_ below; a new milestone starts `Open` |
| **Learning story** | `As a learner, I want to [skill or concept], so that [what it unlocks next].` |
| **Why this matters** | Two or three sentences: where this sits on the road to the phase exit gate |
| **FLAGS** | The learning-gate table below, every row filled or `N/A` |
| **Mastery Criteria** | Gherkin scenarios naming real commands (next section) |
| **MoSCoW · Points** | Priority and Fibonacci estimate (sections below) |
| **Dependencies** | Milestones that must be `Completed` first, each with its reason |
| **Decisions** | ADRs in `project-management/src/08-DECISIONS/` this milestone relies on or raised |

The "so that" clause is not decoration. If you cannot say what the concept unlocks, the milestone is
either out of order on the roadmap or not worth its points yet.

---

## Mastery criteria

**Mastery criteria are the contract.** They become the exercise tests (`04-exercise-design`), the
commands `11-verification` runs, and the evidence the `10-PROGRESS` record holds. Vague criteria pass
planning and then fail at verification, when "I understand it" meets a command that disagrees.

**Testable means an observer could agree it passed without asking the author.** So each scenario
names the exact command and the exact result, and at least one scenario covers explaining the
concept back:

```gherkin
Scenario: The exercise suite passes and memcheck is clean
  Given the exercise in code/src/c/ms007-dynamic-array
  When I run make -C code/src/c/ms007-dynamic-array test
  Then every test binary exits 0 and reports no failed checks
  And make -C code/src/c/ms007-dynamic-array memcheck reports 0 errors

Scenario: The sanitised build is clean
  Given the same exercise
  When I run make -C code/src/c/ms007-dynamic-array san
  Then no AddressSanitizer report and no "runtime error:" line is printed

Scenario: I can explain the growth strategy
  Given no notes or code are open
  When I explain why push onto the array is amortised O(1)
  Then the explanation names the growth factor, the cost of the copy and what happens when realloc fails
```

A Rust milestone names `(cd code/src/rust && cargo test)` (or `cargo test -p <crate>` for one crate), run from
inside the workspace because rustup applies `rust-toolchain.toml` from the current directory and a root-level
`--manifest-path` run would use the default toolchain. A kernel milestone names the `qemu-system-x86_64`
command and the line on the serial console that proves the boot. The targets and flags themselves are owned by
`code/docs/BUILD.md`, and what each tool's clean output looks like by
`project-management/docs/VERIFICATION-GUIDE.md`.

---

## The FLAGS table

One row per learning gate. **A flag reading `N/A` means that gate is skipped for this milestone; any
other value means it runs.** The value is a first-pass manifest (which exercise, which command), not
the design: the gate owns the design and may add to it, and the milestone is updated to match when
the gate closes.

| Flag | Gate it opens | Typical value when it runs |
| --- | --- | --- |
| **Exercises** | `04-exercise-design` → `project-management/src/04-EXERCISES/` | `C: 5 exercises, recall → extend` |
| **Project** | `05-project-spec` → `project-management/src/05-PROJECTS/` | `own malloc, part A: free list` |
| **Kernel** | `06-kernel-spec` → `project-management/src/06-KERNEL/` | `out-of-tree module, load and unload in QEMU` |
| **Distro** | `07-distro-tier-spec` → `project-management/src/07-DISTRO-TIERS/` | `beginner tier: init-system hypothesis` |
| **Tests** | `11-verification` | `make -C code/src/c/ms007-dynamic-array test` · `cargo test` |
| **Memory** | `11-verification` | `make -C <exercise> san` + `make -C <exercise> memcheck` (C); FFI crates run both |
| **Debugger** | `10-study-and-build`, evidenced at `11` | `gdb: watch the buffer move across realloc` |
| **Lint** | `11-verification` | `make -C <exercise> lint` (gcc `-fanalyzer`) · `cargo fmt --check` + `cargo clippy --all-targets -- -D warnings` |
| **QEMU** | `11-verification` | `qemu-system-x86_64` boot to a busybox shell |
| **Notes** | `10-study-and-build` (`.claude/skills/teach/SKILL.md`) | a `learning/<track>-NN-<topic>/` note |
| **Research** | any spec or decision step (`.claude/skills/research/SKILL.md`) | a `research/<SCREAMING-KEBAB-TOPIC>.md` note |

Three rules follow, and each closes a way the mechanism fails quietly:

- **A blank row is not `N/A`.** `N/A` is a decision with a reason; a blank is an unanswered question
  that skips a gate without anyone choosing to. All eleven rows are filled or the milestone is not
  written.
- **The flag is a manifest, never the design.** It says which gates run and gives them a starting
  point. Treating it as the design and skipping the gate is the failure this table invites.
- **Downstream checklists read the flag.** Any checklist box that demands a gate's artefact is
  written "for a milestone whose <flag> is not `N/A`", so a milestone that correctly skipped the gate
  can still tick it honestly.

---

## MoSCoW

Priority within the sprint the milestone is admitted to. A sprint carries at least one **Must**;
**Should** and **Could** are the first to move to the next sprint when study time runs short.

| Priority | Meaning here |
| --- | --- |
| **Must** | The phase exit gate or a later milestone depends on it |
| **Should** | Deepens a Must concept; worth the time if the sprint allows |
| **Could** | Interesting and adjacent; first to move |
| **Won't** | Consciously out of this sprint; recorded so it is not rediscovered |

**Avoid a plan where everything is Must.** If every milestone is Must, the sprint has no give, and
the first concept that takes longer than expected breaks it.

---

## Estimation

Fibonacci points: **1, 2, 3, 5, 8, 13, 21**. Relative effort, not hours. As a rough anchor: 1 is a
single sitting on something you nearly know; 3 is a concept plus one new tool; 5 is a concept with a
small exercise set; 8 is a small project across several sessions.

| Points | Verdict | The question it answers |
| --- | --- | --- |
| **1–8** | A milestone | Can this be proved inside one two-week sprint? |
| **13 or 21** | **It is an epic** | Is this one concept at all, or several wearing one title? |

- **8 is the largest milestone.** The scale has nothing between 8 and 13, so there is one rule, not two.
- **13 or 21 is an epic, and it goes back to the map** (`01-roadmap-map`) to be cut into milestones
  along a concept seam, rather than being estimated harder: "the free list" and "coalescing" are two
  milestones that each prove something; "the header file" and "the source file" are one milestone in
  two halves.
- **A milestone you cannot estimate is one you do not understand yet.** That is a signal to run
  Explain-first again or add a research node, not to guess.

The sprint capacity these points are measured against is owned by
`project-management/docs/planning/CADENCE.md` → _Sprint capacity — the trigger_.

---

## Statuses

**This is the canonical milestone status set.** Each milestone's `**Status:**` line holds exactly one
of these values, spelt as shown.

| Status | Meaning |
| --- | --- |
| `Open` | Written and sized, not yet started (the value every new milestone starts with) |
| `In Progress` | Study and build under way (`10-study-and-build`) |
| `Verifying` | Build finished; gates being run, evidence recorded, review and PR in progress |
| `Completed` | Merged to `main` **and** a verification record exists in `project-management/src/10-PROGRESS/` |
| `Blocked` | Waiting on something outside the milestone; a `GAPS.md` entry names it |
| `Parked` | Deliberately set aside for a later phase; `DEFERRED.md` carries its `DEFERRED (MS###)` marker |

- **`Completed` requires a `10-PROGRESS` record.** Passing tests on a laptop are not evidence until
  they are written down with the commands that produced them
  (`project-management/docs/VERIFICATION-GUIDE.md`). No record, no `Completed`.
- **`Verifying` can go back to `In Progress`.** A failed gate is information, not a demotion: record
  the defect (a `13-BUGS` record where it earns one) and return.
- **`Blocked` and `Parked` are the only states that release the one-at-a-time slot**
  (`project-management/docs/planning/CADENCE.md`).

**Record-local lifecycles are not milestone statuses.** Some artefacts carry a lifecycle of their own,
owned by their folder and never written on a milestone's `**Status:**` line: map status
(`project-management/src/01-ROADMAP/CLAUDE.md`), ADR status
(`project-management/src/08-DECISIONS/CLAUDE.md`), a bug's fix state
(`project-management/src/13-BUGS/CLAUDE.md`), a review's verdict
(`project-management/src/11-REVIEWS/CLAUDE.md`), exercise and project spec status
(`project-management/src/04-EXERCISES/CLAUDE.md`, `project-management/src/05-PROJECTS/CLAUDE.md`), kernel
plan and record status (`project-management/src/06-KERNEL/CLAUDE.md`) and tier status
(`project-management/src/07-DISTRO-TIERS/CLAUDE.md`). Each folder owns its own words; this section owns
only the milestone's.

---

## Numbering

`MS###`, three digits, zero-padded, allocated in creation order by `02-milestone-creation`. The
number is an identifier, not a sequence: the order milestones are studied in is the plan prefix in
`project-management/src/09-MILESTONE-PLANS/`, whose rule that folder's `CLAUDE.md` owns.

**Numeric gaps are deliberate.** A retired or merged milestone keeps its number and is never reused;
renumbering to close a gap breaks every branch name, commit message and cross-link that cites it.
`MS000` is the template.

---

## Related

- [`project-management/docs/planning/CADENCE.md`](CADENCE.md) — when in the loop a milestone is
  written, and the sprint capacity
- [`project-management/docs/planning/SPRINTS.md`](SPRINTS.md) — the sprint a milestone is admitted to
- `project-management/src/02-MILESTONES/MS000-TEMPLATE.md` — the scaffold
- `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` — the first real milestone
- `project-management/docs/VERIFICATION-GUIDE.md` — how the mastery criteria are proved
