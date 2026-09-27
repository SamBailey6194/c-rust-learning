# ADR-MS001: C coding style — the Linux kernel coding style from day one

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-C-CODING-STYLE-LINUX-KERNEL |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources cited below) |
| **Enforced in** | `code/docs/C-CODING-PRINCIPLES.md` · `.editorconfig` (tabs, 8 columns, for `*.c`, `*.h`, `*.S`) |

---

## Context

This is one of five scaffold defaults accepted on 27/09/2026 together with the repository skeleton,
before the first exercise was written. It records the choice and the evidence available that day.
Like every Accepted ADR it is immutable: a different style later means a new ADR that supersedes
this one, and this record stays as written.

Every C file needs one layout. A learner's first few thousand lines set reflexes — where braces go,
how deep nesting feels, how long a line is allowed to run — and reflexes are expensive to retrain.
The repository's destination is the kernel: from P4 the learner reads kernel source, writes
out-of-tree modules and carries patches (`project-management/src/01-ROADMAP/ROADMAP.md`), and all of
that is judged against the kernel's own coding style.

What that style says, checked against docs.kernel.org on 27/09/2026 (paraphrased; the document
itself is the authority):

- **Indentation** is done with tabs, and a tab is 8 columns. The stated reason is that deep
  indentation becomes visibly painful, which warns the author when a function nests more than about
  three levels. `switch` and its `case` labels sit in the same column. Spaces are not used for
  indentation outside comments, documentation and Kconfig.
- **Line length:** 80 columns is the preferred limit; a statement runs past it only when that
  significantly improves readability without hiding information. User-visible strings such as
  `printk` messages are not broken, so they stay greppable.
- **Braces** follow K&R: the opening brace ends the line for `if`, `switch`, `for`, `while` and `do`;
  a function's opening brace starts the next line. A closing brace stands alone except before the
  continuation of the same statement (`} else {`, `} while (...);`). A single statement takes no braces,
  unless another branch of the same conditional needs them, in which case both get them.
- **Spaces** follow keywords (`if`, `switch`, `case`, `for`, `do`, `while`) but not `sizeof`,
  `typeof`, `alignof` or `__attribute__`. The `*` of a pointer declaration sits next to the name
  (`char *buf`).
- **Comments:** the style document shows `/* ... */` throughout; a multi-line comment has a column of
  asterisks and near-empty first and last lines. Current `checkpatch.pl` tolerates `//` comments by
  default — its `C99_COMMENTS` error fires only when that tolerance is switched off with
  `--ignore C99_COMMENT_TOLERANCE` (read in the script's source). The kernel's licensing rules put the
  SPDX line of a `.c` file in a `//` comment and that of a `.h` file in `/* */`.
- **checkpatch.pl and the 100-column figure:** commit `bdc48fa11e46` ("checkpatch/coding-style:
  deprecate 80-column warning", Linux 5.7, 2020) raised checkpatch's default maximum from 80 to 100.
  Its documentation is explicit that 100 is not a hard limit either and that staying within 80 is
  still preferred; for a whole file (`-f`) the long-line message is only a `CHECK`, shown with
  `--strict`.

Tooling on the host, 27/09/2026: no C formatter is installed (`clang-format`, GNU `indent` and
`astyle` are all absent) and `checkpatch.pl` is not available — it ships inside the kernel source
tree, which arrives at P4. Whatever style is chosen is therefore enforced by `.editorconfig`, by
self-review and by `code/workflows/05-review/` until then. Rust code is outside this decision: it
is formatted by rustfmt, as the kernel's own Rust code is.

## Options considered

### Option A — The Linux kernel coding style

- **Summary:** Adopt the kernel's style for every C file: tabs of 8 columns, K&R braces with function
  braces on their own line, `/* */` comments, 80 columns preferred. This repository adds two rules of
  its own, both stricter than checkpatch: 100 columns is a hard ceiling in review, and comments use
  `/* */` only (apart from an SPDX line, where the licensing rules say otherwise).
- **Pros:** Habits carry into P4 unchanged, so module and patch work starts with no style debt. Code
  here reads like the kernel source the learner will study. The 8-column indent puts steady pressure
  on nesting depth and function length, which is good discipline for a beginner. The rules are
  written down in one public document with its reasons.
- **Cons:** Nothing formats code automatically today, so mistakes are caught by eye. Eight-column
  tabs look wide beside rustfmt's four spaces. Some kernel conventions (kernel-doc comments,
  `pr_*` logging, GNU-extension idioms) only make sense inside the kernel and are learned there.

### Option B — The GNU coding standards

- **Summary:** The style of GCC, glibc and coreutils: the function name and the function's opening
  brace in column one, block braces on their own lines, two-column indentation steps, a space before
  the parenthesis of a call.
- **Pros:** The style of the toolchain the repository uses. Well documented.
- **Cons:** Nearly the opposite of the kernel's layout, so every habit would be retrained at P4. The
  kernel's style guide explicitly rejects it. (This description was written from knowledge of the
  GNU standards; gnu.org did not respond when it was re-checked on 27/09/2026.)

### Option C — A formatter-defined style (clang-format with an LLVM- or Google-style preset)

- **Summary:** Let a formatter own layout; commit its configuration and run it before every commit.
- **Pros:** Zero layout debate; formatting is automatic and consistent.
- **Cons:** `clang-format` is not installed, and it comes with the clang/LLVM toolchain, which is
  not installed either (Rust-for-Linux will need it at P4). The common presets are far from kernel
  style. The
  kernel does ship a `.clang-format`, but its own documentation describes clang-format as helpful
  rather than perfect, so it assists the kernel style instead of replacing it.

### Option D — No house style

- **Summary:** Write whatever the editor produces.
- **Pros:** No rules to learn up front.
- **Cons:** Inconsistent files, reviews spent on layout instead of correctness, and no kernel habit
  built before the phase that needs it.

## Decision

**We will take Option A: the Linux kernel coding style, 80 columns preferred and 100 as this
repository's hard ceiling.** The deciding factor is the destination: every C line written in P1–P3
is practice for P4–P6, and the kernel is the one C codebase whose style this learner will be
reviewed against. Option B would be unlearned at P4. Option C is attractive but unavailable on the
host, and even the kernel treats a formatter as an aid to its style, not the style itself. Option D
wastes the cheapest moment to form the habit.

The 100-column ceiling and the `/* */`-only comment rule are repository choices, both stricter than
checkpatch, which warns at 100 columns and tolerates `//`. They exist so a review has an unambiguous
line to hold, while 80 columns remains the target.

This answer changes only if the repository's destination changes away from kernel work, which would
itself be a change to `project-management/src/01-ROADMAP/ROADMAP.md`.

## Consequences

- **Positive:** One style for all C — the kernel's, with two stricter choices. `.editorconfig`
  already sets tabs of width 8 for `*.c`, `*.h` and `*.S`. Code in `code/src/c/` can be read side by
  side with kernel source without a mental switch.
- **Negative:** Layout is enforced by eye until a checker is on the host; a review checklist item in
  `code/workflows/05-review/` carries the load. The repository holds two indentation styles — tabs for
  C and make, four spaces for Rust — which mirrors the kernel tree itself, whose `.rustfmt.toml` keeps
  rustfmt's default indentation.
- **Follow-on:** `code/docs/C-CODING-PRINCIPLES.md` owns the day-to-day rules and links the kernel
  document rather than copying it. At P4, once a kernel tree is present, its checkpatch can be run
  over exercise files (`scripts/checkpatch.pl --no-tree -f <file>`); once clang is installed,
  the kernel's `.clang-format` can assist. Either tool arriving is a small change to
  `code/docs/C-CODING-PRINCIPLES.md`, not a new decision.

## Sources

- **Linux kernel coding style** — <https://docs.kernel.org/process/coding-style.html> —
  indentation, line length, braces, spaces and comments as summarised above, checked 27/09/2026
- **checkpatch documentation** — <https://docs.kernel.org/dev-tools/checkpatch.html> —
  `--max-line-length` default 100, `LONG_LINE` as a `CHECK` in file mode, `--no-tree`, `-f`,
  checked 27/09/2026
- **checkpatch.pl source (mainline)** —
  <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/checkpatch.pl> —
  `$allow_c99_comments = 1` by default; `C99_COMMENTS` only with `--ignore C99_COMMENT_TOLERANCE`,
  checked 27/09/2026
- **Kernel commit bdc48fa11e46, "checkpatch/coding-style: deprecate 80-column warning"** —
  <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bdc48fa11e46> —
  the 80 → 100 change; `scripts/checkpatch.pl` reads 80 at tag `v5.6` and 100 at `v5.7`, checked
  27/09/2026
- **Linux kernel licensing rules** — <https://docs.kernel.org/process/license-rules.html> — SPDX
  comment style per file type (`//` in `.c`, `/* */` in `.h`), checked 27/09/2026
- **Kernel clang-format documentation** — <https://docs.kernel.org/dev-tools/clang-format.html> —
  clang-format as a helpful but imperfect aid, checked 27/09/2026
- **Rust in the kernel, coding guidelines** — <https://docs.kernel.org/rust/coding-guidelines.html> —
  kernel Rust is formatted with rustfmt, checked 27/09/2026
- **GNU coding standards, Formatting** — <https://www.gnu.org/prep/standards/html_node/Formatting.html>
  — the alternative in Option B; not re-read on 27/09/2026 (site unreachable)
- **EditorConfig** — <https://editorconfig.org/> — the editor-side half of the enforcement
