---
workflow: 09-milestone-plans
phase: decide-and-plan
skills: []
---

# Milestone Plans — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `project-management/REFERENCES.md` → **Internal — Live Artefacts** and the root `REFERENCES.md`
(external C, Rust, kernel and tool sources) as you work through these steps:

| Step | Section |
| --- | --- |
| 1 | `project-management/src/02-MILESTONES/` — the milestone and its mastery criteria |
| 1 | `project-management/src/08-DECISIONS/` — the Accepted ADRs the milestone rests on |
| 2 | `project-management/src/09-MILESTONE-PLANS/CLAUDE.md` — naming and the exec-order rule |
| 2 | `project-management/src/09-MILESTONE-PLANS/00-PLAN-MS000-TEMPLATE.md` — the scaffold |
| 3 | `REFERENCES.md` — the root index of external sources |
| 4 | `code/workflows/CONTEXT.md` — which code workflow builds which kind of exercise |
| 5 | `code/docs/BUILD.md` — make targets and flags; `how-to/workflows/03-quality-gates/` — the scripts |
| 6 | `GAPS.md` · `DEFERRED.md` — the two registers risks and deferrals route to |

---

## Steps

### Step 1 — Explain the milestone first, then gather the inputs

Explain-first (`project-management/workflows/CONTEXT.md` → _Explain-first_): ask the learner what they
already know about the milestone's topic and which part they expect to find hardest, and write both down;
the prediction becomes the first risk at Step 6. Then gather:

- the milestone file `project-management/src/02-MILESTONES/MS###-<TITLE>.md`, above all its mastery
  criteria
- the sprint record in `project-management/src/03-STUDY-SPRINTS/` that holds the milestone
- every spec the milestone flagged: exercises (`04-EXERCISES/`), project (`05-PROJECTS/`), kernel
  (`06-KERNEL/`), distro tier (`07-DISTRO-TIERS/`)
- the Accepted ADRs from `08-decisions`
- entries marked `DEFERRED (MS###)` for this milestone in `DEFERRED.md`, and open items in `GAPS.md`

_Done when the learner's prediction is recorded and every input above has been read._

### Step 2 — Compute the exec-order and copy the template

`<exec-order>` is the milestone's two-digit position in the build order of the whole roadmap: the
phases in `ROADMAP.md` order, and within a phase the milestones in the order the sprint records schedule
them, counted from `01`. `00-` is the template's prefix and never a real plan's.

Copy `00-PLAN-MS000-TEMPLATE.md` to `<exec-order>-PLAN-MS###-<DESC>.md` in the same folder, with the
milestone's own descriptor. If the new plan changes the position of plans already written, renumber them
and every citation of them now, in the same commit.

_Done when the plan file exists at a prefix that matches the build order and every existing plan still
does._

### Step 3 — List the resources and chapters

For each concept the milestone teaches, name the primary source and the exact chapter or section, with a
link: the C standard's working drafts and cppreference for C, The Rust Programming Language and the Rust
Reference for Rust, docs.kernel.org for the kernel, the GNU make, gdb and valgrind manuals for the tools.
Cite and link; never paste the text.

_Done when every concept in the milestone has at least one cited primary source._

### Step 4 — Order the exercises

List the exercises smallest concept first, each one building on the last. For each, give:

1. its spec, `project-management/src/04-EXERCISES/EX-MS###-<TOPIC>.md` (or the project spec)
2. the folder it will live in: `code/src/c/ms###-<kebab>/` or `code/src/rust/crates/ms###_<snake>/`
3. the code workflow that builds it: `code/workflows/01-c-exercise/`, `03-rust-exercise/` or
   `04-ffi-bridge/`, with `02-tdd-cycle/` inside any of them
4. the concept it depends on, so a `/teach` session can come first

_Done when every exercise has a spec, a folder, a code workflow and a prerequisite concept._

### Step 5 — Write the verification commands

Turn each mastery criterion into the raw command that proves it, then the script that wraps it. The raw
command is the lesson; the script is what CI and `11-verification` call. A C milestone's table reads
like this:

| Criterion | Raw command | Script |
| --- | --- | --- |
| Tests pass | `make -C code/src/c/ms###-<kebab> test` | `bash code/src/scripts/c/test.sh` |
| Sanitisers find no UB or memory error | `make -C code/src/c/ms###-<kebab> san` | `bash code/src/scripts/c/san.sh` |
| valgrind clean | `make -C code/src/c/ms###-<kebab> memcheck` | `bash code/src/scripts/c/memcheck.sh` |
| Static analysis clean | `make -C code/src/c/ms###-<kebab> lint` | `bash code/src/scripts/c/lint.sh` |

The raw commands target one exercise; the scripts run the same make target across every exercise, so a
green script also proves nothing earlier regressed.

A Rust milestone uses `(cd code/src/rust && cargo test -p ms###_<snake>)` and
`(cd code/src/rust && cargo clippy --all-targets -- -D warnings)`, wrapped by
`bash code/src/scripts/rust/test.sh` and `bash code/src/scripts/rust/lint.sh`. Running cargo from inside
`code/src/rust/` is what makes rustup honour the pinned `rust-toolchain.toml`. Every milestone ends with
`bash code/src/scripts/gates/all.sh`.

_Done when every mastery criterion has a raw command and a script, and nothing in the table is unrunnable
on the host listed in `how-to/docs/TOOLCHAIN.md`._

### Step 6 — Record the risks and deferred items

Write each risk with its trigger and its response. Typical ones: the learner's prediction from Step 1; a
missing tool (the kernel build dependencies flex, bison, libelf-dev and dwarves are not yet installed;
Rust-for-Linux needs clang/LLVM); a concept with no exercise yet. A risk that already blocks progress
also gets a `GAPS.md` entry. A topic the milestone deliberately leaves out gets a `DEFERRED.md` entry
marked `DEFERRED (MS###)` with the milestone that picks it up.

_Done when every risk has a response and every deferral is in `DEFERRED.md`._

### Step 7 — Leave the As-Built summary as a stub

Keep the As-Built heading and mark it as pending, to be filled at `11-verification` with what was built
against what was planned. Filling it now would record intent as if it were evidence.

_Done when the As-Built section exists and is visibly marked as not yet written._

### Step 8 — Have the learner explain the plan back

Ask the learner to walk through the plan: why this exercise order, which command proves which criterion,
what happens if the top risk fires. Every hesitation points at a section to fix.

_Done when the learner can explain the plan end to end without reading from it._

### Step 9 — Cross-link and commit

Link the plan to its milestone, sprint, specs and ADRs by full repo-relative path, and link the milestone
back to the plan. Then stage by explicit path:

```bash
git add project-management/src/09-MILESTONE-PLANS/<exec-order>-PLAN-MS###-<DESC>.md \
        project-management/src/02-MILESTONES/MS###-<TITLE>.md
git commit -m "docs(pm): plan MS### <short description>"
```

_Done when every link resolves and `git status` shows nothing from this workflow left uncommitted._

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
