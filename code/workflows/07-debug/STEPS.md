---
workflow: 07-debug
phase: diagnose-and-improve
skills: [handoff]
---

# Debug — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `code/REFERENCES.md` for the external sources (the GDB manual, the Valgrind user manual,
git-bisect(1)) as you work through these steps:

| Step | Section |
| --- | --- |
| 1, 4 | `code/docs/DEBUGGING.md` — gdb, valgrind, core dumps, `rust-gdb` |
| 2 | This step's own method; `code/REFERENCES.md` → git-bisect(1) for `git bisect run` |
| 3 | `code/workflows/02-tdd-cycle/` and `code/docs/TESTING.md` |
| 6 | `code/workflows/06-memory-check/` |
| 7 | `project-management/src/13-BUGS/BUG-MS000-TEMPLATE.md` |

---

## Steps

### Step 1 — Reproduce the bug with one command

Ask the learner to write down three things: the exact command and input, what they expected, and what
happened. Then make that a single command that shows the bug every time, in seconds:

```bash
./code/src/c/msNNN-<kebab>/build/<program-name> <input>        # C: the program itself
make -C code/src/c/msNNN-<kebab> test                          # C: an existing test that fails
(cd code/src/rust && RUST_BACKTRACE=1 cargo test -p msNNN_<snake> <test_name>)   # Rust
```

The plain build is already `-g3 -O0`, so every line in a backtrace maps to source. A bug that appears only
sometimes gets run in a loop until the failing condition is found (`for i in $(seq 50); do ...; done`).

_Done when one command shows the wrong behaviour on every run._

---

### Step 2 — Shrink to the smallest failing case

Halve the input and re-run; keep the half that still fails, and repeat until nothing more can be removed.
If the code used to work, let git find the breaking commit by binary search:

```bash
git bisect start
git bisect bad HEAD
git bisect good <last-good-commit>
git bisect run sh -c 'make -C code/src/c/msNNN-<kebab> all || exit 125; <reproduce command>'
git bisect reset
```

`git bisect run` executes the command from the top of the working tree; exit 0 marks a commit good, 1–127
marks it bad, and 125 skips a commit that cannot be built. The reproduce command is Step 1's, and it has to
exist in every commit tested — keep it in an untracked script if it relies on new files.
`git bisect reset` returns to the starting branch.

_Done when the failing case is as small as it will go, and, for a regression, the first bad commit is
known._

---

### Step 3 — Pin the bug with a failing test

Run `code/workflows/02-tdd-cycle/` Steps 1–3 for this one case: a test with the shrunk input and the
correct expected value, taken from the spec or worked out by hand. It fails now, for the reason the bug
describes. Its name says what it guards (`rejects_empty_name`, `test_greet_truncation_boundary`).

Do not proceed to Step 4 until the new test is red.

_Done when the new test fails on its assertion and every other test still passes._

---

### Step 4 — Find the cause by observing

Ask the learner for two or three hypotheses, written down and ranked. Test them one at a time with gdb:

```bash
gdb -q --args ./code/src/c/msNNN-<kebab>/build/test_<name>
```

```text
(gdb) break <function>       stop on entry to a function (or file.c:line)
(gdb) run                    start; a crash stops here with the signal named
(gdb) bt                     the call stack; `frame N` moves to a caller
(gdb) info locals            every local in the current frame
(gdb) print <expr>           any expression; `print *p@4` shows four elements behind p
(gdb) watch <variable>       stop whenever that value changes
(gdb) next / step / finish   over a line / into a call / out of the current function
```

For Rust, `rust-gdb` (installed with the toolchain) pretty-prints Rust types; point it at the test binary
path `cargo test` prints in its `Running ...` line. Temporary debug output carries one marker, for example
`DEBUG-7c1e`, so `grep -rn DEBUG-7c1e code/src/` finds every line to remove.

_Done when the learner can state the root cause in one sentence and point at the gdb, valgrind or
sanitiser evidence for it._

---

### Step 5 — Apply the minimal fix

The learner makes the smallest change that turns the new test green — nothing else. Anything else worth
improving goes on a list for `code/workflows/08-refactor/`. Remove every tagged debug line.

```bash
make -C code/src/c/msNNN-<kebab> test
(cd code/src/rust && cargo test -p msNNN_<snake>)
```

_Done when the new test passes, every other test still passes, and `grep` finds no debug marker._

---

### Step 6 — Re-run the memory tools and linters

A C fix can move a bug rather than remove it. Run `code/workflows/06-memory-check/` Step 6 (`test`, `san`,
`memcheck`, `lint` together); for Rust, `cargo fmt --check` and
`cargo clippy --all-targets -- -D warnings`. Claude confirms through `code/src/scripts/c/*.sh` or
`code/src/scripts/rust/lint.sh` and `test.sh`.

_Done when every gate exits 0._

---

### Step 7 — Write the BUG record and commit

Copy `project-management/src/13-BUGS/BUG-MS000-TEMPLATE.md` to a new record named as
`project-management/src/13-BUGS/CLAUDE.md` → Output & naming specifies, and fill every section: symptom,
reproduction command, environment (gcc or rustc version, flags, `-O` level), root cause with its evidence,
the fix, and the regression test's name. Commit the fix and its test together with type `fix` and scope
`c` or `rust`, staging each path by name; then set the record's **Fix state** to `Fixed` and commit it
with scope `pm`. It moves to `Verified` in the milestone's final commit
(`project-management/workflows/13-pr-and-merge/` Step 6).

_Done when the record is complete with its Fix state at `Fixed`, the fix and its test are committed
together, and any design problem is noted for `code/workflows/08-refactor/`._

---

## Update context files

1. Add any new test file to the exercise's or crate's `CONTEXT.md` tree.
2. Add any new external source to `code/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md` — debugging state (hypotheses tried,
   bisect position) is the easiest thing to lose between sessions.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
