# MS000 — [Milestone Title]

**Track:** [C | Rust | Kernel | Distro]
**Phase:** [P1 to P6] — `project-management/src/01-ROADMAP/ROADMAP.md`
**Status:** Open

<!-- Status words and their transitions are owned by
     project-management/docs/planning/MILESTONES.md -> Statuses. Not restated here.
     A milestone that genuinely spans two tracks (a toolchain or FFI milestone) names both,
     as MS001 does: `C + Rust`. -->

_Template — copy to `MS###-<SCREAMING-KEBAB-TITLE>.md` with the next free number, replace every
`[PLACEHOLDER]`, delete the `[EXAMPLE]` rows, and delete every section whose flag is `N/A`._

<!-- FLAGS — one row per learning gate; the flag is that gate's entry condition.
     A flag reading N/A means the gate is skipped for this milestone; any other value means it runs.
     N/A carries a reason. A blank row is an unanswered question, not N/A.
     The value is a MANIFEST, not the design: the gate owns the design and may add to it, and
     this milestone is updated to match when the gate closes.
     Row meanings and the gate each one opens: project-management/docs/planning/MILESTONES.md
     -> The FLAGS table. Not restated here. -->

| Flag | Value |
| --- | --- |
| Exercises | [EXAMPLE] C: 5 exercises, recall → extend |
| Project | [EXAMPLE] N/A — no capstone in this milestone |
| Kernel | [EXAMPLE] N/A — P1 runs no kernel work |
| Distro | [EXAMPLE] N/A — P1 runs no distro work |
| Tests | [EXAMPLE] `make -C code/src/c/ms###-<kebab> test` |
| Memory | [EXAMPLE] `make -C code/src/c/ms###-<kebab> san` + `make -C code/src/c/ms###-<kebab> memcheck` |
| Debugger | [EXAMPLE] gdb: watch the buffer pointer change across `realloc` |
| Lint | [EXAMPLE] `make -C code/src/c/ms###-<kebab> lint` |
| QEMU | [EXAMPLE] N/A — no kernel boots before P4 |
| Notes | [EXAMPLE] `learning/c-02-pointers-and-memory/` |
| Research | [EXAMPLE] N/A — the primary resources in `ROADMAP.md` cover it |

---

## Why this matters

<!-- Two or three sentences: where this milestone sits on the road to its phase exit gate, and
     which later milestone or phase would fail without it. -->

[PLACEHOLDER]

## Learning story

As a learner, I want to [skill or concept], so that [what it unlocks next].

## MoSCoW priority

**[Must]** <!-- Must | Should | Could | Won't — meanings: project-management/docs/planning/MILESTONES.md -->

## Points

[N] <!-- Fibonacci 1, 2, 3, 5, 8, 13, 21. 8 is the largest milestone; 13 or more is an epic, back to
         the map. Scale and anchors: project-management/docs/planning/MILESTONES.md -> Estimation. -->

## Dependencies

- [EXAMPLE] `MS001` (Toolchain ready — every gate below needs a working toolchain)
- [PLACEHOLDER — or "None — this milestone depends on no other milestone."]

## Decisions

<!-- The ADRs this milestone rests on or raised, one bullet each: full repo-relative path, then one
     line on what it settles. Write "None — no decision this milestone made was hard to reverse."
     where the set is genuinely empty; a blank section is an unanswered question. -->

- `project-management/src/08-DECISIONS/ADR-MS###-<DECISION>-DD-MM-YYYY.md` — [what it settles]

---

## Mastery Criteria

**Testable means an observer could agree it passed without asking the author.** Every scenario
names the exact command and the exact result; commands run from the repository root unless the
scenario says otherwise. At least one scenario is an explain-back with no notes open.

[One or two sentences: what having mastered this milestone looks like overall.]

```gherkin
Scenario: [The suite passes]
  Given [the exercise directory or crate]
  When I run [exact command]
  Then [exact observable result]
  And [the exit status]

Scenario: [A gate fails when it should]
  Given [a deliberate, throwaway fault]
  When I run [exact command]
  Then [the report that proves the gate caught it]
  And the fault is reverted before anything is committed

Scenario: [I can explain the concept back]
  Given no notes or code are open
  When I explain [the concept]
  Then the explanation covers [the two or three points that prove understanding]
```

### C mastery criteria

<!-- Remove this section when no C code is written in this milestone. -->

```gherkin
Scenario: The sanitised build is clean
  Given [the exercise directory]
  When I run make -C code/src/c/ms###-<kebab> san
  Then no AddressSanitizer report and no "runtime error:" line is printed
  And make exits 0

Scenario: valgrind reports no errors and no leaks
  When I run make -C code/src/c/ms###-<kebab> memcheck
  Then valgrind prints "ERROR SUMMARY: 0 errors from 0 contexts"
  And make exits 0
```

### Rust mastery criteria

<!-- Remove this section when no Rust code is written in this milestone. -->

```gherkin
Scenario: The crate's tests, formatting and lints are clean
  Given I am in code/src/rust
  When I run cargo test -p ms###_<snake>
  And I run cargo fmt --all --check
  And I run cargo clippy --all-targets -- -D warnings
  Then all three exit 0
```

### Kernel mastery criteria

<!-- Remove this section when the Kernel and QEMU flags are both N/A.
     Kernels and modules run in QEMU only — the kernel safety rule in .claude/CLAUDE.md. -->

```gherkin
Scenario: The kernel boots in QEMU
  Given the kernel built per project-management/src/06-KERNEL/KERNEL-PLAN-MS###-<DESCRIPTOR>.md
  When I run [the exact qemu-system-x86_64 command from the plan]
  Then the serial console shows [the line that proves the boot, e.g. a busybox shell prompt]
```

### Distro mastery criteria

<!-- Remove this section when the Distro flag is N/A. -->

```gherkin
Scenario: The tier image meets its spec item
  Given the [tier] image built for this milestone
  When I boot it in QEMU and [the action from the TIER spec]
  Then [the acceptance item from project-management/src/07-DISTRO-TIERS/TIER-<NAME>.md]
```

### Debugging mastery criteria

<!-- Remove this section when the Debugger flag is N/A. -->

```gherkin
Scenario: I can find the fault with the debugger, not by guessing
  Given [the program or test binary, built with -g3 -O0]
  When I run it under gdb and [break / watch / backtrace as the flag names]
  Then I can show [the variable, frame or address that explains the behaviour]
  And the walkthrough is recorded in the milestone's learning notes
```

---

## Tasks

### Study

- [ ] [EXAMPLE] Read [resource, chapters] — from the phase list in `ROADMAP.md`
- [ ] [EXAMPLE] Explain [concept] back before starting the exercises

### Build

<!-- Keep only the sub-lists whose flags run. -->

- [ ] [EXAMPLE] C: exercises in `code/src/c/ms###-<kebab>/`, test first (`code/workflows/02-tdd-cycle/`)
- [ ] [EXAMPLE] Rust: crate `code/src/rust/crates/ms###_<snake>/`
- [ ] [EXAMPLE] Kernel: build and boot per the KERNEL-PLAN
- [ ] [EXAMPLE] Debugging: gdb walkthrough recorded in the learning notes

---

## Verification Checks

Run before the milestone moves to `Verifying`. Each command is the raw command; the script that
wraps it is named in `how-to/workflows/03-quality-gates/`. A tool that is missing is a gate that
**could not run**, never a gate that passed.

- [ ] [EXAMPLE] `make -C code/src/c/ms###-<kebab> test`
- [ ] [EXAMPLE] `make -C code/src/c/ms###-<kebab> san`
- [ ] [EXAMPLE] `make -C code/src/c/ms###-<kebab> memcheck`
- [ ] [EXAMPLE] `make -C code/src/c/ms###-<kebab> lint`
- [ ] [EXAMPLE] from `code/src/rust/`: `cargo test`, `cargo fmt --all --check`,
      `cargo clippy --all-targets -- -D warnings`
- [ ] Every mastery scenario above run and its output kept for the verification record

---

## Links

| Artefact | Path |
| --- | --- |
| Map slice | `project-management/src/01-ROADMAP/MAP-<TRACK>.md` → S-## |
| Sprint | `project-management/src/03-STUDY-SPRINTS/SPRINT-##.md` |
| Specs (as flagged) | `project-management/src/04-EXERCISES/EX-MS###-<TOPIC>.md` [and others] |
| Plan | `project-management/src/09-MILESTONE-PLANS/` — this milestone's plan |
| Verification | `project-management/src/10-PROGRESS/` — written at `11-verification` |

---

## Definition of Done

- [ ] Every mastery scenario passes, and the explain-back was done without notes
- [ ] Every task ticked, or moved to `DEFERRED.md` with a `DEFERRED (MS###)` marker
- [ ] Every verification check run, with its output kept
- [ ] Verification record written in `project-management/src/10-PROGRESS/`
- [ ] Review and findings recorded where the flags and the review call for them
- [ ] Merged to `main` through a PR from `ms###/<short-kebab>`
- [ ] **Status** set to `Completed`, and `ROADMAP.md` → You are here updated
