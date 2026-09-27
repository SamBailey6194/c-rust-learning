# EX-MS000 — {EXERCISE SET TITLE}

_Template — copy to `EX-MS###-<TOPIC>.md`, replace every `{PLACEHOLDER}`, delete the `[EXAMPLE]`
rows. One exercise set for one milestone: the problems, their constraints, the interfaces the tests
call, worked examples, test cases and a hints ladder. **No solutions** — the learner's code in
`code/src/` is the only solution that exists._

| Field | Value |
| --- | --- |
| **Milestone** | `MS###` — {short title} |
| **Milestone doc** | `project-management/src/02-MILESTONES/MS###-<TITLE>.md` |
| **Track** | {C / Rust / C + Rust} |
| **Code location** | {`code/src/c/ms###-<kebab>/` and/or `code/src/rust/crates/ms###_<snake>/`} |
| **Build workflow** | {`code/workflows/01-c-exercise/` / `code/workflows/03-rust-exercise/`} |
| **Status** | {Draft / Ready / Done} |
| **Date** | {DD/MM/YYYY} |

---

## 1. What this set teaches

- **Concepts:** {the two or three ideas the set exercises}
- **Serves:** {which Mastery Criteria scenarios in the milestone these exercises prove}
- **Builds on:** {earlier milestones whose skills are assumed, by `MS###`}
- **Climb:** exercises run from recall, to applying the concept, to extending it; each one is
  finishable before the next is opened.

---

## 2. Constraints

These apply to every exercise below unless an exercise says otherwise.

| Constraint | Rule for this set |
| --- | --- |
| Standard and flags | C17 with the project flags (`code/docs/BUILD.md`), warnings are errors / Rust edition 2024 with the workspace lints |
| Allowed library calls | {e.g. `<string.h>` length and compare functions, `snprintf`} |
| Banned | {e.g. `strcpy`, `strcat`, `sprintf`, variable-length arrays / `unsafe` in Rust} |
| Memory | {e.g. no heap in exercises 1 and 2; every allocation freed on every path} |
| Style | Linux kernel coding style (C) / `rustfmt` defaults (Rust) |
| Tests | Test first; `check.h` for C, `cargo test` for Rust (`code/docs/TESTING.md`) |

---

## 3. Exercises

### Exercise 1 — {TITLE}

**Problem.** {Two to five sentences describing what the program or function does, from the caller's
side. No hints about how.}

**Interface.** The signature the tests call — a contract, not an implementation:

```c
/* [EXAMPLE] */
int count_words(const char *text, size_t *out);
```

**Contract.**

| Aspect | Rule |
| --- | --- |
| Inputs | [EXAMPLE] `text` is a NUL-terminated string; `out` receives the count |
| Returns | [EXAMPLE] `0` on success; `-1` if `text` or `out` is NULL |
| Ownership | [EXAMPLE] nothing is allocated; the caller owns both pointers |
| Definition | [EXAMPLE] a word is a maximal run of characters for which `isspace()` is false |

**Worked examples** — the oracle the tests are written from:

| Input | Expected result | Why |
| --- | --- | --- |
| [EXAMPLE] `"one two"` | returns `0`, `*out == 2` | two runs of non-space characters |
| [EXAMPLE] `"   "` | returns `0`, `*out == 0` | spaces only: no word |
| [EXAMPLE] `NULL` | returns `-1`, `*out` unchanged | the contract's error case |

**Test cases.**

| ID | Class | Input | Expected |
| --- | --- | --- | --- |
| T1 | normal | {...} | {...} |
| T2 | boundary | [EXAMPLE] empty string `""` | [EXAMPLE] `0`, count `0` |
| T3 | boundary | [EXAMPLE] leading and trailing whitespace | [EXAMPLE] words counted once |
| T4 | error | [EXAMPLE] `text == NULL` | [EXAMPLE] `-1` |

Each test case becomes at least one check in `test_*.c` or `tests/*.rs`, written and seen to fail
before the code that makes it pass.

**Hints ladder.** Open one rung at a time, only after a real attempt at the one before.

1. **Nudge:** {a question that points back at the problem, e.g. "What should happen at the very
   first character, before any word has started?"}
2. **Concept:** {the idea it needs and where to read about it, e.g. "a two-state machine; King
   chapter 13 on string handling"}
3. **Approach:** {an approach described in prose, in steps, with no code}

**Stretch** (optional, not required for mastery): {an extension that deepens the same concept}

### Exercise 2 — {TITLE}

{Same shape as Exercise 1: problem, interface, contract, worked examples, test cases, hints ladder,
stretch.}

---

## 4. Mastery map

| Mastery scenario (in the milestone) | Proved by |
| --- | --- |
| [EXAMPLE] "The exercise suite passes and memcheck is clean" | Exercises 1 to 3, all test cases |
| [EXAMPLE] "I can explain the state machine" | Exercise 1, reflection question 1 |

---

## 5. Reflection questions

Answered in the learning note (`learning/<track>-NN-<topic>/`) once the set is green — not before.

1. {What did the sanitiser or valgrind catch that the tests did not?}
2. {Which test case did you find hardest to predict, and why?}
3. {What would change if the input could be larger than memory?}

---

## Cross-references

- `project-management/src/02-MILESTONES/MS###-<TITLE>.md` — the milestone this set serves
- `code/workflows/01-c-exercise/` / `code/workflows/03-rust-exercise/` — how the set is built
- `code/docs/TESTING.md` — how test cases become checks
- `code/docs/BUILD.md` — the flags and targets the constraints refer to
