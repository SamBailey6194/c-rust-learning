---
workflow: 08-refactor
phase: diagnose-and-improve
skills: []
---

# Refactor — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `code/REFERENCES.md` for the external sources (the kernel's coding-style document, the clippy lint
list) as you work through these steps:

| Step | Section |
| --- | --- |
| 1, 5 | `code/docs/BUILD.md` and `code/workflows/06-memory-check/` — the gates that define "green" |
| 2 | `code/docs/CODING-PRINCIPLES.md` — the smells and the moves that remove them |
| 2–3 | `code/docs/C-CODING-PRINCIPLES.md` or `code/docs/RUST-CODING-PRINCIPLES.md` |
| 6 | `code/docs/TESTING.md` — why the tests do not change |

---

## Steps

### Step 1 — Record a green baseline

Start from a clean working tree and prove everything passes before the first move:

```bash
git status --short                                   # nothing uncommitted
make -C code/src/c/msNNN-<kebab> test san memcheck lint
(cd code/src/rust && cargo fmt --check && cargo clippy --all-targets -- -D warnings && cargo test)
git rev-parse --short HEAD                           # note this: the baseline commit
```

Claude confirms the same through `code/src/scripts/c/*.sh` or `code/src/scripts/rust/lint.sh` and
`test.sh`. Anything red stops the workflow: fix it through `code/workflows/07-debug/` first.

Do not proceed to Step 2 until every gate exits 0 and the baseline commit is noted.

_Done when the baseline is green and its commit hash is written down._

---

### Step 2 — Name the target and list the moves

Ask the learner what makes the code hard to read or change, then name it together — a long function, deep
nesting, duplication, a magic number, a header exposing internals, a file past 750 lines — and find the
`code/docs/CODING-PRINCIPLES.md` section that covers it. List the moves in order, each small enough to
build and test on its own: rename, extract a function, introduce a struct, replace a literal with a named
constant or `enum`, flatten a condition with an early return, split a file along a header boundary.

_Done when the target and an ordered list of small, named moves are written down._

---

### Step 3 — Apply one move, then build and test

The learner makes exactly one move from the list, then:

```bash
make -C code/src/c/msNNN-<kebab> test
(cd code/src/rust && cargo test -p msNNN_<snake>)
```

If anything goes red, undo the move rather than debugging forward — `git restore -- <path>` discards the
uncommitted change to that file, which is safe because every green point is committed in Step 4 — then
try a smaller move.

_Done when the move is made and every test passes, unchanged._

---

### Step 4 — Commit at green, then repeat

```bash
git add <each changed path>
git commit -m "refactor(c): <the move, in the imperative>"
```

Stage by explicit path and use scope `c` or `rust` (`project-management/docs/git/COMMITS.md`). Return to
Step 3 for the next move until the list is done.

_Done when every move on the list is committed, each at a green point._

---

### Step 5 — Re-run every gate

```bash
make -C code/src/c/msNNN-<kebab> test san memcheck lint
(cd code/src/rust && cargo fmt --check && cargo clippy --all-targets -- -D warnings && cargo test)
```

A C refactor that moves code between files or changes lifetimes can surface a memory finding that `test`
alone never shows. Claude confirms through the scripts.

_Done when every gate exits 0, as it did at the baseline._

---

### Step 6 — Confirm behaviour and tests are unchanged

```bash
git diff --stat <baseline> HEAD -- 'code/src/c/msNNN-<kebab>/test_*.c'
git diff --stat <baseline> HEAD -- code/src/rust/crates/msNNN_<snake>/tests/
wc -l <each touched source file>
```

The first two print nothing when no test file changed; Rust unit tests inside `src/` are checked by
reading the `mod tests` hunks in `git diff <baseline> HEAD`. Every touched source file stays within 750
lines. Run the program on the spec's examples once more and compare with the baseline output.

_Done when no test assertion changed, every file is within the limit, and the outputs match the
baseline._

---

## Update context files

1. Update the exercise's or crate's `CONTEXT.md` tree if files were split, added or renamed.
2. Add any new external source to `code/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`, noting the baseline commit and the moves
   still to do.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
