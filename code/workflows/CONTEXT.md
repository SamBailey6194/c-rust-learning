# code/workflows/ — Step-by-Step Coding Workflows

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

`code/docs/` decides each coding rule once; this folder sequences the work that applies those rules to
the C and Rust exercises under `code/src/`. Each workflow is a numbered folder of four files, and each one
exists because skipping one of its steps has a known cost: tests written after the code that only confirm
what it already does, a leak that valgrind would have caught three exercises earlier, a fix with no
regression test that quietly breaks again. Every workflow runs in tutor mode — the learner writes the
exercise code, and Claude asks, explains and points at `code/docs/` sections (`.claude/CLAUDE.md`).

## Directory Tree

```text
code/workflows/
├── CONTEXT.md · CLAUDE.md   ← this file (the family index) · operating rules
│
│   ── Build (01–04) ──
├── 01-c-exercise/           ← one C exercise, from its EX-MS### spec to a clean analyzer run
├── 02-tdd-cycle/            ← red → green → refactor with check.h and cargo test
├── 03-rust-exercise/        ← a new workspace crate, or a Rust port of a finished C exercise
├── 04-ffi-bridge/           ← P3 — C and Rust across a thin extern "C" boundary, both suites green
│
│   ── Verify (05–06) ──
├── 05-review/               ← content review: memory safety/UB, errors, style, tests, readability
├── 06-memory-check/         ← ASan + UBSan, valgrind memcheck, -fanalyzer, and reading their reports
│
│   ── Diagnose & improve (07–08) ──
├── 07-debug/                ← FIX it: reproduce, shrink, failing test first, minimal fix, BUG record
└── 08-refactor/             ← IMPROVE it: one behaviour-preserving move at a time
```

Every workflow folder holds the same four files: `CONTEXT.md` (when to use it and its key concepts),
`CLAUDE.md` (operating rules), `STEPS.md` (ordered steps, each closing on a "Done when" line) and
`CHECKLIST.md` (the gate ticked before the workflow counts as complete).

## The three families

### Build (01–04) — making something new

| Workflow | Purpose | From |
| --- | --- | --- |
| `01-c-exercise/` | One C exercise end to end: spec → folder and Makefile → tests → code → `make test`, `san`, `memcheck`, `lint` → learning note | P1 |
| `02-tdd-cycle/` | The red → green → refactor loop inside every build workflow — `check.h` in C, `cargo test` in Rust | P1 |
| `03-rust-exercise/` | A new crate `msNNN_<snake>/` in the Cargo workspace, or a port that keeps the C exercise's test cases as its oracle | P3 |
| `04-ffi-bridge/` | A boundary between C and Rust: gate question, plain code first, thin `extern "C"` layer, no panic across it, both suites | P3 |

### Verify (05–06) — checking what already exists

| Workflow | Purpose | From |
| --- | --- | --- |
| `05-review/` | Reads finished code against `code/docs/` on five dimensions and writes a `REVIEW-MS###-<DESC>.md` record | P1 |
| `06-memory-check/` | Runs the three memory tools, explains what each report means, and loops until all three are clean | P1 |

### Diagnose & improve (07–08) — in handoff order

| Workflow | Purpose | From |
| --- | --- | --- |
| `07-debug/` | **Fix** a wrong result or a crash: reproduce, shrink to the smallest failing case, pin it with a test, change as little as possible, write the BUG record | P1 |
| `08-refactor/` | **Improve** working code: one behaviour-preserving move at a time, tests green before and after each | P1 |

`07` hands to `08` when a fix exposes a design problem: the minimal fix lands first, on its own, and the
restructuring follows as separate work.

### Planned — appended when their phase starts

| Workflow | Purpose | Added at |
| --- | --- | --- |
| `09-kernel-module/` (planned — added at P4) | An out-of-tree kernel module in C: build it against the configured tree, then load and unload it inside QEMU only | P4 |
| `10-python-exercise/` (planned — added at L1) | One Python exercise under `code/src/python/`: a uv project, tests first with pytest, ruff clean | L1 |
| `11-profile-and-optimise/` (planned — added at L2) | State a resource budget, measure honestly (warm-up, repeats, variance), change one thing, measure again | L2 |
| `12-cuda-kernel/` (planned — added at L2) | One CUDA kernel under `code/src/cuda/`: checked for correctness against a CPU or library reference, then timed | L2 |
| `13-tui-app/` (planned — added at U1) | A terminal UI crate: terminal restored on exit and panic, state separate from rendering, tested against the rendered buffer | U1 |

Later kernel and Syntek OS workflows (patch series, profile images) are chosen when P5 and P6 are planned
in `project-management/src/01-ROADMAP/ROADMAP.md`, and take the next free numbers then.

## Numbers are identifiers, not a sequence — append, never renumber

Unlike `project-management/workflows/`, whose numbers are a running order through a milestone, these
folders are a catalogue entered by task type: nobody runs 01 through 08 in turn. A number is a stable
identifier and a shelf position, nothing more. Other files cite these paths, so a renumbered folder turns
every citation into a silent misroute, which costs far more than an untidy shelf. A new workflow takes the
next free number and joins a family through an edit to the tables above; within a family the order still
shows reading order.

A new workflow is registered in three places: this file, `code/REFERENCES.md` and the root
`REFERENCES.md` workflow index.

## Boundaries worth knowing

- **`01` or `02`.** `01` is the whole life of one C exercise; `02` is the loop inside its test-and-implement
  steps. `03`, `04`, `07` and `08` reuse `02` in the same way.
- **`03` port or `08` refactor.** A Rust port is a new crate beside the C original, so it belongs to `03`.
  `08` restructures code in place, in the same language, with the same behaviour.
- **`05` review or PM `12-review-and-reflect`.** `05` is the procedure that reads the code and writes the
  REVIEW record. `project-management/workflows/12-review-and-reflect/` is the milestone step that runs it,
  after verification and before the pull request, and distils FINDING records from what it found.
- **`06` memory check or the quality gates.** `06` is about reading one exercise's sanitiser, valgrind and
  analyzer output until it is clean. `how-to/workflows/03-quality-gates/` owns the full gate run across the
  repository, and `project-management/workflows/11-verification/` records a milestone's results.
- **`07` debug or the debugging environment.** `07` is for code that gives the wrong answer. When the tool
  itself misbehaves (gdb cannot attach, valgrind is missing, no core dump appears), the route is
  `how-to/workflows/05-debugging-environment/`.
- **`07` or `08`.** A fix changes behaviour and a refactor preserves it, so the two land in separate
  commits and each can be checked on its own terms.
- **Exercise specs come from the PM layer.** `project-management/workflows/04-exercise-design/` writes the
  `EX-MS###` spec that `01` and `03` consume; `project-management/workflows/10-study-and-build/` is the
  planning-side step that enters them (pairing table in the root `REFERENCES.md`).

## Cross-references

- `code/CONTEXT.md` — the layer map this sub-layer belongs to
- `code/REFERENCES.md` — internal index and external sources (GCC, GNU make, GDB, Valgrind, Rust) the
  `STEPS.md` files lean on
- `code/docs/CONTEXT.md` — the guide catalogue these workflows apply
- `code/src/CONTEXT.md` — where the exercises and crates land
- `code/src/scripts/CONTEXT.md` — the scripts that wrap each raw command
- `REFERENCES.md` — root workflow index and the cross-layer pairing table
- `project-management/workflows/CONTEXT.md` — the planning and recording half (specs, verification, reviews)
- `how-to/workflows/CONTEXT.md` — operational workflows (toolchain, gates, debugging environment)
- `learning/CONTEXT.md` — where learning notes from each exercise land
