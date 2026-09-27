# PROJ-MS000 — {PROJECT NAME}

_Template — copy to `PROJ-MS###-<NAME>.md` (the first milestone the project spans), replace every
`{PLACEHOLDER}`, delete the `[EXAMPLE]` rows. One capstone project: what it does, what it
deliberately does not do, how it is cut into milestones, and how "finished" is proved. **No
solution** — design stays at the level of parts and responsibilities._

| Field | Value |
| --- | --- |
| **First milestone** | `MS###` — {short title} |
| **All milestones** | {`MS###`, `MS###`, ... in build order} |
| **Phase** | {P1 to P6} — `project-management/src/01-ROADMAP/ROADMAP.md` |
| **Track** | {C / Rust / C + Rust} |
| **Code location** | {`code/src/c/ms###-<kebab>/` and/or `code/src/rust/crates/ms###_<snake>/`} |
| **Status** | {Draft / Ready / Done} |
| **Date** | {DD/MM/YYYY} |

---

## 1. Summary

{Three to five sentences: what the program does from a user's point of view, and which of the
phase's skills it combines. Name the phase exit gate it contributes to.}

---

## 2. Scope

### 2.1 In scope

- [EXAMPLE] Run a program with arguments found on `PATH`
- [EXAMPLE] Pipelines of any length (`a | b | c`)
- [EXAMPLE] Redirection: `<`, `>`, `>>`
- [EXAMPLE] Built-ins: `cd`, `exit`

### 2.2 Out of scope

| Ruled out | Why |
| --- | --- |
| [EXAMPLE] Scripting (`if`, loops, functions) | a language interpreter is a different project |
| [EXAMPLE] Globbing | depends on a pattern matcher not yet studied; a stretch goal |

### 2.3 Interface or behaviour

{The command-line behaviour, or the library interface as signatures plus contracts. Include error
behaviour: exit statuses, messages, return values.}

```text
[EXAMPLE]
$ ./build/msh
msh> ls | wc -l
12
msh> exit 3
$ echo $?
3
```

### 2.4 Parts and responsibilities

{The parts the program divides into and what each one is responsible for — a map, not an
implementation. e.g. "tokeniser: text to tokens; parser: tokens to a pipeline; executor: pipeline
to processes".}

---

## 3. Milestones

Each project milestone closes on its own verification record. A part is 8 points at most; one estimated
at 13 or more is an epic and goes back to the map (`01-roadmap-map`) to be split
(`project-management/docs/planning/MILESTONES.md` → _Estimation_).

| Order | Milestone | Part | Proves |
| --- | --- | --- | --- |
| 1 | `MS###` | [EXAMPLE] tokeniser and parser | [EXAMPLE] parsing tests pass; no heap errors under `san` |
| 2 | `MS###` | [EXAMPLE] executor, single command | [EXAMPLE] runs a command and returns its exit status |
| 3 | `MS###` | [EXAMPLE] pipelines and redirection | [EXAMPLE] matches the reference shell on every A-scenario |

---

## 4. Acceptance

**The project is finished when every scenario below passes** — not before, and not with new scope
added. Commands run from the repository root.

```gherkin
Scenario: A1 — [EXAMPLE] A pipeline matches the reference shell
  Given the project is built with make -C code/src/c/ms###-<kebab>
  When I run the same pipeline in the project and in dash
  Then both print the same output and exit with the same status

Scenario: A2 — The project's test suite and memory gates are clean
  When I run make -C code/src/c/ms###-<kebab> test
  And I run make -C code/src/c/ms###-<kebab> memcheck
  Then both exit 0
  And valgrind prints "ERROR SUMMARY: 0 errors from 0 contexts"
```

---

## 5. Test strategy

| Level | What it covers | Where |
| --- | --- | --- |
| Unit | [EXAMPLE] each part in isolation | `test_*.c` / `#[cfg(test)]` modules |
| Behaviour | [EXAMPLE] whole-program runs compared with the reference | `test_*.c` driving the binary, or a script |
| Memory | `make ... san` and `make ... memcheck` on every C part | the exercise directory |

- **Reference behaviour:** {what the expected results are taken from — a reference program, a man
  page, the C standard, POSIX}
- **Memory-testing note:** {for an allocator, how the tests avoid valgrind replacing a global
  `malloc`; otherwise "standard gates"}

---

## 6. Stretch goals

Explicitly **not required** for Done; each one is a candidate for a later milestone or
`DEFERRED.md`.

- [EXAMPLE] Job control (`&`, `fg`, `bg`)
- {PLACEHOLDER}

---

## 7. Risks

| Risk | Likelihood | Fallback |
| --- | --- | --- |
| [EXAMPLE] Signal handling interacts badly with the pipeline code | medium | ship without Ctrl-C handling; add it as a stretch milestone |
| {PLACEHOLDER} | {low / medium / high} | {PLACEHOLDER} |

---

## Cross-references

- `project-management/src/02-MILESTONES/MS###-<TITLE>.md` — each milestone this project spans
- `project-management/src/01-ROADMAP/ROADMAP.md` — the phase and exit gate this project serves
- `code/docs/BUILD.md` — the targets named in the acceptance scenarios
- `project-management/src/08-DECISIONS/` — any ADR a design choice here raised
