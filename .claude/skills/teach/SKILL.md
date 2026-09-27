---
name: teach
description: >-
  Run one lesson on a C, Rust, kernel or tooling concept as a tutor, not an author: clarify the
  mission, pitch the next lesson at the edge of Sam's current level, gather primary sources, drill
  recall, then have Sam build the concept as runnable code under code/src/ (where CI compiles it)
  and log the lesson with spaced review dates in learning/<track>-NN-<topic>/. Invoke by typing
  /teach <topic>, or when Sam asks to learn, practise, revise or be taught something, or when a
  topic's PROGRESS.md shows a review falling due.
---

# Skill: Teach (c-rust-learning)

Teach turns a session into a **lesson**. The goal is a durable skill in Sam's head, not code
Claude wrote. Each lesson is one concept pitched at Sam's **zone of proximal development** (the
next step Sam cannot yet take alone but can with support), drilled by **retrieval practice**
(effortful recall, not re-reading), proved by **building** it where CI compiles it, and
consolidated on a **spaced repetition** schedule. Notes and the journal live in `learning/`;
runnable code lives in `code/src/`.

Locale: en_GB · Europe/London · dates DD/MM/YYYY.

## The one rule: Sam writes the code

Tutor mode (`.claude/CLAUDE.md`) holds for the whole session. Claude asks how Sam plans to
approach a problem before helping, explains, asks guiding questions, runs commands with Sam and
reads their output together, and points a review at the relevant `code/docs/` section rather than
rewriting Sam's code. Claude does not write an exercise solution, source or tests, unless Sam
explicitly asks for one. Scaffolding an exercise folder follows the code workflow that owns it
(`code/workflows/01-c-exercise/`, `code/workflows/03-rust-exercise/`).

## Workspace layout

```text
learning/<track>-NN-<topic>/          ← one folder per topic; track is c | rust | kernel | tooling
├── MISSION.md                        ← why this topic, what "can do it" looks like, family, phase
├── RESOURCES.md                      ← pinned primary sources + house guides, one row per lesson
├── PROGRESS.md                       ← review queue + dated journal: recall result, next review date
└── NOTES/                            ← one concept note per lesson, e.g. NOTES/03-pointer-arithmetic.md
code/src/c/msNNN-<kebab>/             ← the lesson's runnable C, built by make and by CI
code/src/rust/crates/msNNN_<snake>/   ← the lesson's runnable Rust, built by cargo and by CI
```

- `NN` in a topic folder is a two-digit running number per track, appended and never renumbered:
  `c-01-foundations/`, then `c-02-pointers-and-memory/`.
- `NNN` in a code path is the milestone the work belongs to (`MS###` in
  `project-management/src/02-MILESTONES/`); a Rust port keeps its C exercise's number. The rule is
  owned by `code/src/CLAUDE.md` → Output & naming. `code/src/c/ms001-hello/` and
  `code/src/rust/crates/ms001_hello/` are the pattern to copy.
- Kernel code arrives at P4 (`code/src/kernel/`, planned — added at P4).

### MISSION.md

```markdown
# Mission — {track}-{NN}-{topic}

**Started**: {DD/MM/YYYY} · **Family**: {c | rust | kernel | tooling} · **Phase**: {P1-P6} · **Milestone**: {MS###}

## Why

{Sam's words: why this topic now, and what it unlocks on the roadmap.}

## Can do it when

- {An observable capability, e.g. explain what `p + 1` does for an `int *` and a `char *`.}
- {A passing check, e.g. the exercise's `make test`, `make san` and `make memcheck` all exit 0.}

## Parked for later

- {An adjacent concept deliberately left out, and the topic it belongs to.}
```

### RESOURCES.md

```markdown
# Resources — {track}-{NN}-{topic}

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| {NN} {concept} | {URL + section + version, or `man 3 {page}`} | `code/docs/{GUIDE}.md` — {section} | `code/src/{path}` |
```

### PROGRESS.md (the review queue and the dated journal)

```markdown
# Progress — {track}-{NN}-{topic}

**Consolidated**: {lesson numbers passed at their +7 review, or "none yet"} · **Next session opens on**: {lesson or due review}

## Review queue

| Lesson | Last recall | Result | Next review |
| --- | --- | --- | --- |
| {NN} {concept} | {DD/MM/YYYY} | {pass | partial | miss} | {DD/MM/YYYY} (+{1 | 3 | 7}) |

## Journal

### {DD/MM/YYYY} — {NN} {concept}

- **Recall:** {the question asked} → {pass | partial | miss}; {what was missing, if anything}
- **Built:** `code/src/{path}` — `{command}` → {result, including gate results}
- **Dead ends:** {what was tried and did not work, or "none"}
- **Misconception to re-drill:** {the misconception, or "none"}
- **Note:** `NOTES/{NN}-{concept}.md`
- **Next review:** {DD/MM/YYYY} (+{1 | 3 | 7})
```

### NOTES/NN-concept.md

A concept note is Sam's own explanation: one sentence, how it works (a memory diagram in a
`text` block where it helps), the worked example **linked by path** to the code that proves it,
the gotchas with their primary-source citation, and a short `## Sources` list. A snippet in a note
is a copy of lines that compile under `code/`, cited with its `path:line` range.

## How to teach

1. **Clarify the mission.** Read `learning/<topic>/MISSION.md` if it exists. If it is missing or
   thin, ask Sam one question at a time why this topic and what "can do it" looks like. Place the
   topic on the roadmap (`project-management/src/01-ROADMAP/ROADMAP.md`) and the current milestone,
   and pick the family: **c**, **rust**, **kernel** or **tooling**. On first run, create the
   folder with the three files above and an empty `NOTES/`.
   _Done when `MISSION.md` states the goal, family, phase and at least one "can do it when" line
   in Sam's words._
2. **Assess the level, set the next lesson.** Read `PROGRESS.md`: any review dated today or
   earlier is run first as warm-up recall. Then find the edge of Sam's level with one or two
   diagnostic questions, ideally "predict what this prints, and why". Look facts up in the repo
   (`code/src/`, `code/docs/`, earlier `NOTES/`) rather than asking Sam what the repo already
   answers. Pick **one** next lesson at the zone of proximal development.
   _Done when due reviews are queued first and the next lesson is named as one tightly scoped
   concept, which becomes its `NOTES/NN-<concept>.md` title._
3. **Gather resources.** Add the lesson's row to `RESOURCES.md` from primary sources and the house
   guide for the family (below). Cite what was opened, not what is remembered: `man` locally for
   the C library and syscalls, Context7 (`resolve-library-id` → `query-docs`) for the Rust books
   and crate docs, docs.kernel.org for the kernel.
   _Done when the lesson's row names a pinned primary source and the house-guide section._
4. **Run the lesson — recall, then build.** Teach the concept briefly, grounded in the source,
   then close the loop:
   - **Retrieval practice** — pose a short recall question (predict the output, explain it back,
     spot the bug), wait for Sam's answer, then confirm or correct. Interleave one question from an
     earlier lesson.
   - **Build to learn** — ask how Sam plans to approach it, then Sam writes a small runnable
     example and its tests under `code/src/` through the code workflow (below), as an exercise from
     the current milestone's `EX-MS###-<TOPIC>.md` spec, in a folder numbered for that milestone.
     A milestone with no spec (its Exercises flag is `N/A`, as MS001's is) has no build step: the
     lesson stops at recall and the note, and the example waits for the milestone that specifies
     it (`project-management/workflows/04-exercise-design/`). Run the raw
     command first, because the command is the lesson, then the script that wraps it:
     `make -C code/src/c/<exercise> test`, `san` and `memcheck` (`code/src/scripts/c/test.sh`,
     `san.sh`, `memcheck.sh`); `cargo test` and `cargo clippy` in `code/src/rust/`
     (`code/src/scripts/rust/test.sh`, `lint.sh`); `gdb` when a result surprises.
   - **Write it down** — Sam writes `NOTES/NN-<concept>.md` in his own words; Claude checks it
     against the source and flags errors rather than rewriting it.

   _Done when Sam has recalled the concept unaided and, where the milestone specifies an exercise,
   its tests pass, a C example is clean under `san` and `memcheck`, and the note links to the code
   by path._
5. **Capture the lesson, schedule the review.** Append a `### DD/MM/YYYY — NN <concept>` entry to
   the journal and update the review queue. Spacing: a new lesson is reviewed at **+1 day**; each
   pass moves it to the next interval, **+3** then **+7 days**, counted from the review date; a
   partial or a miss sends it back to +1; a pass at the +7 review marks it **consolidated**, after
   which it returns only as interleaved recall. Example: lesson 27/09/2026 → review 28/09/2026 →
   pass → 01/10/2026 → pass → 08/10/2026 → pass → consolidated.
   _Done when `PROGRESS.md` holds today's dated entry with a next-review date, and the queue row
   matches it._
6. **Close the session cleanly.** Update `MISSION.md` or `RESOURCES.md` if the goal or sources
   shifted, and set **Next session opens on** in `PROGRESS.md`. Offer the commit (Sam decides;
   conventions in `project-management/docs/git/COMMITS.md`). If the work is mid-way, run
   `/handoff` instead of carrying on.
   _Done when a fresh session could resume from `MISSION.md` and `PROGRESS.md` alone, every code
   path a note cites builds under `code/`, and nothing outside the topic folder and its code path
   changed._

## What to teach (by family)

**c** — the language and its memory model (P1 and P2). House guides: `code/docs/C-CODING-PRINCIPLES.md`,
`code/docs/BUILD.md`, `code/docs/TESTING.md`, `code/docs/MEMORY-SAFETY.md`,
`code/docs/DEBUGGING.md`. Primary sources:

- The C standard. C17 is pinned
  (`project-management/src/08-DECISIONS/ADR-MS001-C-STANDARD-C17-27-09-2026.md`). Its ballot draft,
  WG14 N2176, is listed on open-std.org but served password-protected (checked 27/09/2026), so
  read [N2310](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2310.pdf) (the first C2x working
  draft, which marks its changes against the C17 text, ISO/IEC 9899:2018: the closest readable text
  to C17) or [N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf) (the C11
  committee draft; C17 fixed defects and added no features). For the C23 revisit,
  [N3096](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3096.pdf). Cite by draft and section:
  "N2310 Section 6.5.6"; an N1570 citation is fine where the section number is the same.
- Man pages: `man 3 <function>` (C library), `man 2 <syscall>`, `man 7 <overview>` such as
  `man 7 signal`. POSIX `3p` pages are not installed on the host (checked 27/09/2026).
- [cppreference's C pages](https://en.cppreference.com/w/c) as a readable index into the standard.

**rust** — ownership to `unsafe` and FFI (P3). House guides: `code/docs/RUST-CODING-PRINCIPLES.md`,
`code/docs/TESTING.md`, `code/docs/FFI.md`. Primary sources through Context7: The Rust Book
(`/rust-lang/book`), The Rust Reference (`/rust-lang/reference`), The Rustonomicon
(`/rust-lang/nomicon`); cite the doc.rust-lang.org page, not Context7.

**kernel** — build, boot, modules, Kconfig, initramfs and the distro tiers (P4 to P6). Primary
sources: [docs.kernel.org](https://docs.kernel.org/) and the kernel tree's `Documentation/`. Until
P4 a kernel lesson is reading and notes only. From P4, every build boots in QEMU and never on the
host (the kernel safety rule in `.claude/CLAUDE.md`); specs live in `project-management/src/06-KERNEL/`.

**tooling** — gcc, make, gdb, valgrind, the sanitisers, cargo (from P1). House guides:
`how-to/docs/TOOLCHAIN.md`, `how-to/docs/CLI-TOOLING.md`, `code/docs/BUILD.md`,
`code/docs/DEBUGGING.md`. Primary sources: `man gcc`, `man make`, `man gdb`, `man valgrind`, and
the GNU manuals online. Practise on `code/src/c/ms001-hello/` before a new exercise.

## Lesson design

- **One concept per lesson**, small enough to finish in a sitting; respect working memory.
- **Predict, then run.** Ask Sam to predict an output before compiling; the compiler, the tests,
  ASan/UBSan and valgrind are the answer key.
- **Undefined behaviour is taught as undefined**, not as what gcc happens to do today; show
  `-fsanitize=undefined` catching it.
- **Interleave** recall from earlier lessons into a new one so retrieval stays effortful.
- **Ground every lesson in the mission**; a lesson that does not move Sam towards it is the wrong
  lesson, so return to step 2.
- **Quiz cleanly**: phrase recall so the shape of the question does not give the answer away.
- **Cite the primary source** so Sam can go deeper than Claude's recall.

## Anti-patterns

- Writing the solution: a tutor-mode breach, even when Sam is stuck. Ask a smaller question.
- Runnable code in `learning/`: it escapes CI. Code goes to `code/src/`; the note links to it.
- Pasting book, standard or manual text into a note: re-author and cite
  (`research/CLAUDE.md` holds the licence rules).
- Asking what the repo already answers; look it up (step 2).
- Re-reading in place of recall; teaching ahead of the zone of proximal development.
- A wall of lessons at once: teach one, drill it, schedule its review, then the next.
- Running a custom kernel or module on the host: QEMU only.

## Governing procedures (route here — do not restate at length)

Route to the one that matches and follow its `STEPS.md` against its `CHECKLIST.md`:

- `project-management/workflows/10-study-and-build/`: the procedure a lesson runs inside.
- `code/workflows/01-c-exercise/` · `code/workflows/02-tdd-cycle/`: a C lesson's build step.
- `code/workflows/03-rust-exercise/` · `code/workflows/04-ffi-bridge/`: Rust and C-to-Rust lessons.
- `code/workflows/06-memory-check/`: the sanitiser and valgrind proof for a C lesson.
- `code/workflows/07-debug/`: when a lesson's build or test surprises.
- `how-to/workflows/02-daily-study-session/`: the session shell around a lesson.

## Cross-references

- `.claude/CLAUDE.md`: tutor mode, the non-negotiables, the kernel safety rule.
- `.claude/skills/wait-what/SKILL.md`: one origin of a topic, a re-pitch that exposed a knowledge
  gap and arrives with its opening lesson already named.
- `.claude/skills/handoff/SKILL.md`: the session boundary a lesson crosses when it runs long.
- `.claude/skills/research/SKILL.md`: when a lesson raises a question that needs a decision.
- `learning/CONTEXT.md` · `learning/CLAUDE.md`: the layer this skill writes.
- `project-management/src/01-ROADMAP/ROADMAP.md`: phases and exit gates a mission is placed on.
- `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md`: the current milestone.
- `code/src/c/ms001-hello/` · `code/src/rust/crates/ms001_hello/`: the exercise pattern to copy.
- `code/docs/BUILD.md`: the make targets and flags a C lesson runs.
- `project-management/docs/git/COMMITS.md`: the commit scopes (`learning`, `c`, `rust`).
