---
workflow: 01-c-exercise
phase: build
skills: [teach, handoff]
---

# C Exercise — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `code/REFERENCES.md` for the external sources (the N2310 draft of the C17 text, cppreference,
the GCC and GNU make manuals, the Valgrind manual) as you work through these steps:

| Step | Section |
| --- | --- |
| 1 | `project-management/src/04-EXERCISES/` — the `EX-MS###-<TOPIC>.md` spec |
| 2 | `code/src/c/ms001-hello/` — the folder, pair, header and Makefile to copy |
| 2, 5–8 | `code/docs/BUILD.md` — the targets and flags |
| 3–4 | `code/workflows/02-tdd-cycle/` and `code/docs/TESTING.md` |
| 4 | `code/docs/C-CODING-PRINCIPLES.md` — kernel style, error handling |
| 6–8 | `code/workflows/06-memory-check/` and `code/docs/MEMORY-SAFETY.md` |
| 9 | `.claude/skills/teach/SKILL.md` and `learning/CONTEXT.md` |

---

## Steps

### Step 1 — Read the spec and restate the objective

Open the exercise's `EX-MS###-<TOPIC>.md` in `project-management/src/04-EXERCISES/`. Ask the learner to
say, in their own words, what the program does, what its function signatures will be, what counts as an
error, and which concept the exercise exists to practise. Then ask how they plan to approach it. Point at
the relevant `code/docs/` section for anything unfamiliar rather than explaining the solution.

_Done when the learner has stated the objective, the interface and the error cases, and the spec's
examples are understood well enough to become tests._

---

### Step 2 — Create the exercise folder, its pair and its Makefile

```bash
mkdir code/src/c/msNNN-<kebab>
```

`NNN` is the milestone number from the spec's ID; `<kebab>` names the exercise. Inside the folder:

- `CONTEXT.md` — the learning objective, the concepts practised and the file tree (model:
  `code/src/c/ms001-hello/CONTEXT.md`); `CLAUDE.md` — tutor rules and the make commands.
- `<name>.h` — the interface: an include guard and each function's declaration with a kernel-doc style
  comment stating parameters, return value and error cases. This is the contract the tests pin.
- `Makefile` — three names and the shared rules, nothing more:

```make
PROG      := <program-name>
SRCS      := <name>.c main.c
TEST_SRCS := test_<name>.c

include ../mk/exercise.mk
```

Every `.c` and `.h` file opens with an SPDX licence line, as the `ms001-hello` files do.

_Done when the folder has its pair, header and Makefile, and `make -C code/src/c/msNNN-<kebab> clean`
runs without an error about unset variables._

---

### Step 3 — Write the tests first

Run `code/workflows/02-tdd-cycle/` Steps 1–3: the learner lists normal, boundary and error cases from the
spec, writes `test_<name>.c` against the header using `check.h`, and gives `<name>.c` a stub that returns a
wrong value so the tests compile and fail.

```bash
make -C code/src/c/msNNN-<kebab> test      # expect "failed: got ..., expected ..." lines
```

The failing test binary exits 1, so make stops with `Error 1` and itself exits 2 — GNU make's code for
any failed recipe, not this repository's "could not run". The script `c/test.sh` maps the same failure
to 1 (FAIL), which is why Claude checks exit codes through the scripts.

_Done when every case is an assertion and every new test is red on its assertion (any coincidental green
noted for the mutation check)._

---

### Step 4 — Implement until green

The learner writes `<name>.c` and `main.c` (`code/workflows/02-tdd-cycle/` Steps 4–6). Claude answers
questions, asks guiding ones and points at `code/docs/C-CODING-PRINCIPLES.md`; it writes no solution code
unless explicitly asked. Build as often as useful:

```bash
make -C code/src/c/msNNN-<kebab>                    # builds build/<program-name> and every test binary
./code/src/c/msNNN-<kebab>/build/<program-name>     # run the program by hand
```

The script `bash code/src/scripts/c/build.sh --path msNNN-<kebab>` wraps the build.

_Done when the build is warning-free and the program behaves as the spec's examples say._

---

### Step 5 — Run the tests

```bash
make -C code/src/c/msNNN-<kebab> test
```

Wrapped by `bash code/src/scripts/c/test.sh --path msNNN-<kebab>`. Each test binary prints
`check: N passed, 0 failed`; any `file:line: CHECK... failed: got ..., expected ...` line names the
assertion to look at.

Do not proceed to Step 6 until every test passes.

_Done when `make test` exits 0 for this exercise._

---

### Step 6 — Run the sanitisers

```bash
make -C code/src/c/msNNN-<kebab> san
```

Wrapped by `bash code/src/scripts/c/san.sh --path msNNN-<kebab>`. This rebuilds into `build/san/` with
AddressSanitizer and UBSan and runs the tests there; the first report stops the run with a non-zero
exit. Read any report with `code/workflows/06-memory-check/` Step 2 before changing code.

_Done when `make san` exits 0 with no `ERROR: AddressSanitizer`, `LeakSanitizer` or `runtime error:` line._

---

### Step 7 — Run valgrind

```bash
make -C code/src/c/msNNN-<kebab> memcheck
```

Wrapped by `bash code/src/scripts/c/memcheck.sh --path msNNN-<kebab>`. valgrind runs the plain test
binaries and counts every leak kind as an error, including blocks still reachable at exit. Interpretation:
`code/workflows/06-memory-check/` Step 3.

_Done when every run ends `ERROR SUMMARY: 0 errors` and `make memcheck` exits 0._

---

### Step 8 — Run the static analyzer

```bash
make -C code/src/c/msNNN-<kebab> lint
```

Wrapped by `bash code/src/scripts/c/lint.sh --path msNNN-<kebab>`. gcc's `-fanalyzer` follows paths the
tests may never take; under `-Werror` each `-Wanalyzer-*` warning fails the build. Interpretation:
`code/workflows/06-memory-check/` Step 4.

_Done when `make lint` prints that `-fanalyzer` found nothing and exits 0._

---

### Step 9 — Record the learning note and hand back

Run the `teach` skill's closing steps: the learner writes, in their own words, a note in the matching
`learning/c-NN-<topic>/NOTES/` folder — the concept practised, what the tools caught and why, and any
misconception corrected — and the skill logs it in that topic's `PROGRESS.md` with a review date. Then
commit on the milestone branch with scope `c` (`project-management/docs/git/COMMITS.md`), staging each path
by name, and return to `project-management/workflows/10-study-and-build/`, which updates the spec's status.

_Done when the note exists, the work is committed, and the PM step knows the exercise is finished._

---

## Update context files

1. Add the new exercise folder to the tree in `code/src/c/CONTEXT.md`.
2. Add any new external source the exercise leaned on to `code/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified, including the exercise's own.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
