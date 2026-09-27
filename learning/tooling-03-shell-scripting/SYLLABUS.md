# Syllabus — tooling-03-shell-scripting

**Track**: tooling · **Phase**: P1 · **Path**: Core · **Detail**: full · **Prerequisites**: P1 under way (lessons 01–07 need nothing more; the lesson 08 Build verifies a C exercise, so `code/src/c/ms001-hello/` or a later one)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Shell is the glue under everything this repository builds towards. Its own gates are bash scripts
(`code/src/scripts/`); a kernel is configured, built and booted in QEMU from the command line
(`kernel-01`); Linux From Scratch is a book of shell commands, and the Syntek OS build recipes that
automate it are scripts (`os-03` to `os-05`). This topic teaches bash the way this repository writes
it — `#!/usr/bin/env bash` with `set -euo pipefail` — then POSIX sh for the places bash is absent,
such as a BusyBox initramfs. It is a prerequisite for `tooling-04`, `kernel-01`, `kernel-06`,
`os-01`, `os-02`, `os-03` and `os-09`, and with P2 it opens P6's first topics. Lessons 01–07 are one
concept each and are checked at the prompt; lesson 08 puts them together in one small script that
lands here, under `code/src/`. Facts about behaviour were checked on this host on 27/09/2026 with
bash 5.2.21, dash 0.5.12 (the host's `/bin/sh`) and BusyBox 1.36.1 ash.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Quoting, expansion order and word splitting | 1 sitting | no | Security |
| 02 | Exit status, `set -euo pipefail`, and where `-e` does not fire | 1 sitting | no | Safety |
| 03 | Functions, local variables and arrays | 1 sitting | no | — |
| 04 | Redirection and here-documents | 1 sitting | no | Security |
| 05 | `trap` and cleanup | 1 sitting | no | Security, Safety |
| 06 | POSIX sh against bash: which shell a script needs | 1 sitting | no | — |
| 07 | Reading ShellCheck findings | 1 sitting | no | Security |
| 08 | A build-and-verify script to the repository's exit-code contract | 2–3 sittings | yes — `verify.sh` | Safety |

---

## 01 — Quoting, expansion order and word splitting

- **Objective:** Sam can predict how many arguments a command receives from a quoted and an unquoted
  expansion, and say why `"$@"` differs from `"$*"` and from a bare `$@`.
- **Builds on:** no earlier shell lesson; Sam's Python and PHP, where a string value is never
  re-parsed after it is built — the contrast is the lesson.
- **Key ideas:**
  - The shell expands in a fixed order: brace expansion; then tilde, parameter and arithmetic
    expansion and command substitution, left to right; then word splitting; then pathname expansion
    (globbing); then quote removal.
  - Word splitting applies only to the unquoted results of parameter expansion, command substitution
    and arithmetic expansion, using the characters in `IFS`; a literal word typed in the script is
    never split.
  - An unquoted expansion that is empty vanishes as an argument, while a quoted one stays as an empty
    argument, so the positions of later arguments shift.
  - `"$@"` gives each positional parameter as its own word; `"$*"` joins them into one word with the
    first character of `IFS`; unquoted, both are split and globbed.
  - Quote the expansion, not every literal around it; single quotes keep everything literal, double
    quotes still expand `$`, backquotes and `\`.
  - A filename that starts with `-` is read as an option unless `--` ends option parsing first.
- **Recall targets:** for a variable holding a filename with a space and a `*` in it, predict the
  arguments a command receives with and without quotes; explain why an empty unquoted variable can
  make a command act on the wrong argument.
- **Build:** none — each prediction is checked at the prompt by printing the arguments one per line.
- **Security lens:** an unquoted expansion of a filename or other outside input lets that input choose
  how many arguments a command gets and which files a glob matches; quoting and `--` keep untrusted
  names as data.
- **Sources:** `man bash` (bash 5.2.21) → EXPANSION (order), Word Splitting, Pathname Expansion,
  QUOTING, PARAMETERS → Special Parameters; POSIX.1-2024 XCU 2.2 Quoting and 2.6.5 Field Splitting,
  <https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html>; POSIX.1-2024 XBD 12.2
  Utility Syntax Guidelines, Guideline 10 (`--`),
  <https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap12.html>; ShellCheck SC2086,
  <https://www.shellcheck.net/wiki/SC2086>.
- **Done when:** Sam predicts the argument list for an unquoted variable, a quoted one, `"$@"` and
  `"$*"` unaided, and the prompt confirms all four.

## 02 — Exit status, `set -euo pipefail`, and where `-e` does not fire

- **Objective:** Sam can say, for a failing command in a given position, whether a script running
  under `set -euo pipefail` stops, and justify each answer from the manual.
- **Builds on:** lesson 01; the repository's exit-code contract (0 pass, 1 failures, 2 could not
  run) in `code/src/scripts/CONTEXT.md`.
- **Key ideas:**
  - 0 is success and anything else is failure; 127 means command not found, 126 found but not
    executable, 128+N killed by signal N, and a builtin returns 2 for incorrect usage.
  - A pipeline's status is its last command's, unless `pipefail` is set, when it is the rightmost
    non-zero status.
  - `set -e` does not exit for a failure in the condition of `if`, `while` or `until`, in any part of
    an `&&` or `||` list except the last, in any pipeline command but the last _unless `pipefail` is
    set_ (then the pipeline's own status is non-zero and `-e` fires), or after `!` — and a function
    called from such a place runs with `-e` ignored for its whole body.
  - Command substitution does not inherit `-e` unless `shopt -s inherit_errexit` is set (it is in
    posix mode).
  - `local v=$(cmd)` and `export v=$(cmd)` return the status of `local` or `export`, not of `cmd`:
    declare first, assign second.
  - `set -u` makes an unset variable an error (except `$@` and `$*`), and `${var:?message}` stops
    on an empty or unset value; `-e` is a safety net, so a failure the script must react to is
    still tested explicitly.
- **Recall targets:** predict whether the script stops for a failure in an `if` condition, on the
  left of `&&`, in `false | true` with and without `pipefail`, in `local v=$(false)`, and inside a
  function called as the condition of an `if`.
- **Build:** none — each prediction is checked with `bash -c` at the prompt.
- **Safety:** with `dir` unset and no `-u`, a cleanup line that deletes `"$dir"/*` deletes from the
  root of the filesystem; `-u` or `${dir:?}` stops the script before anything is removed. Practise
  deletion only inside a directory made for the purpose.
- **Sources:** `man bash` (bash 5.2.21) → EXIT STATUS; SHELL GRAMMAR → Pipelines; SHELL BUILTIN
  COMMANDS → `set` (`-e`, `-u`, `-o pipefail`), `local`, `shopt` (`inherit_errexit`); Parameter
  Expansion (`${parameter:?word}`); ShellCheck SC2155,
  <https://github.com/koalaman/shellcheck/wiki/SC2155>.
- **Done when:** Sam gets all five predictions right and, for each, names the rule in `man bash`
  that decides it.

## 03 — Functions, local variables and arrays

- **Objective:** Sam can write a function that takes arguments, returns a status, keeps its
  variables local, and passes a list of paths through an array without any being split.
- **Builds on:** lessons 01–02.
- **Key ideas:**
  - A function runs in the current shell: `$1`, `$2`… are its own arguments, `return N` sets its
    status, and anything it prints is output a caller captures with `$(…)`.
  - `local` limits a variable to the function and the functions it calls — dynamic scope, so a
    callee sees its caller's locals.
  - `"${arr[@]}"` expands each array element to exactly one word, whatever it contains;
    `${#arr[@]}` counts them.
  - A command line built as a string has to be split again (and breaks on a path with a space); built
    as an array, every argument survives intact, which is why `eval` is rarely the answer.
  - `mapfile -t` reads lines into an array; `declare -A` makes an associative array.
  - Arrays exist in neither POSIX sh nor dash — the most common reason a script needs bash
    (lesson 06).
- **Recall targets:** explain why a command stored in a string fails on a path with a space and how
  an array fixes it; predict what a called function sees of its caller's `local` variable.
- **Build:** none — read `code/src/scripts/_lib/common.sh` (`need_tool`, `run_gate`) as the worked
  example, then check predictions at the prompt.
- **Sources:** `man bash` (bash 5.2.21) → FUNCTIONS; Arrays; SHELL BUILTIN COMMANDS → `local`,
  `declare`, `mapfile`.
- **Done when:** Sam explains, line by line, how `run_gate` in `code/src/scripts/_lib/common.sh`
  passes its command through unchanged, and predicts the callee-sees-local case correctly.

## 04 — Redirection and here-documents

- **Objective:** Sam can send standard output and standard error where they belong, predict the
  effect of redirection order, and choose a here-document form that does or does not expand.
- **Builds on:** lessons 01–03.
- **Key ideas:**
  - Descriptors 0, 1 and 2 are standard input, output and error; a pipe carries standard output only
    (`|&` adds standard error).
  - Redirections apply left to right: `cmd >file 2>&1` sends both streams to the file, while
    `cmd 2>&1 >file` sends only standard output there.
  - Diagnostics go to standard error so standard output stays data a caller can capture; `die` and
    `need_tool` in `code/src/scripts/_lib/common.sh` do this.
  - A here-document with an unquoted delimiter expands `$var` and `$(cmd)` in its body; with a
    quoted delimiter the body is literal; `<<-` strips leading tabs so the body can be indented.
  - `>` truncates an existing file; `set -o noclobber` refuses, and `>|` overrides it on purpose.
  - A here-string (`<<<`) is a bash feature, not POSIX.
- **Recall targets:** predict where standard error ends up for each order of `>file` and `2>&1`;
  say which here-document form writes `$HOME` literally and why.
- **Build:** none — predictions checked at the prompt.
- **Security lens:** a here-document with an unquoted delimiter runs every `$(…)` it contains, so a
  file generated from text that holds shell syntax executes it; quote the delimiter whenever the
  body is data.
- **Sources:** `man bash` (bash 5.2.21) → REDIRECTION (the order note), Here Documents, Here
  Strings; SHELL BUILTIN COMMANDS → `set` (`noclobber`); POSIX.1-2024 XCU 2.7 Redirection,
  <https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html>.
- **Done when:** Sam predicts both redirection orders and both here-document forms correctly, and
  explains why the repository's helpers print errors with `>&2`.

## 05 — `trap` and cleanup

- **Objective:** Sam can make a script remove its temporary files whether it succeeds, fails under
  `set -e`, or is interrupted with Ctrl-C.
- **Builds on:** lessons 02 and 04.
- **Key ideas:**
  - `mktemp -d` creates a new directory with an unpredictable name, readable only by its owner;
    register the cleanup straight after creating it.
  - `trap '…' EXIT` runs when the shell exits; an ERR trap fires under the same conditions as
    `set -e`, so it misses the same cases.
  - Ctrl-C sends SIGINT and `kill` sends SIGTERM by default; SIGKILL and SIGSTOP cannot be caught at
    all.
  - Shells differ: on this host bash 5.2.21 ran its EXIT trap when killed by SIGINT or SIGTERM, while
    dash 0.5.12 and BusyBox 1.36.1 ash did not — a script that must clean up everywhere traps the
    signals as well.
  - A cleanup handler has to be safe when the resource was never created and when it runs twice.
- **Recall targets:** name the ways a script can end and say which of them run an EXIT trap in bash
  and in dash; explain why a trap string is usually single-quoted.
- **Build:** none — each ending is triggered at the prompt, and the handler is part of lesson 08's
  script.
- **Security lens:** a predictable name in the shared temporary directory can be created first by
  another user, who then controls what the script writes to or reads from; `mktemp` removes that
  race.
- **Safety:** the handler deletes only the directory `mktemp` returned, never a path assembled from
  an unchecked variable (lesson 02).
- **Sources:** `man bash` (bash 5.2.21) → SHELL BUILTIN COMMANDS → `trap`; `man 1 mktemp` (GNU
  coreutils 9.4); `man 7 signal`; `man 1 dash` (dash 0.5.12).
- **Done when:** Sam's handler removes the directory on a normal exit, a `set -e` failure and
  Ctrl-C, and he predicted each outcome before running it.

## 06 — POSIX sh against bash: which shell a script needs

- **Objective:** Sam can say whether a script needs bash or runs under POSIX sh, name the bash-only
  constructs in it, and choose its shebang on purpose.
- **Builds on:** lessons 01–05.
- **Key ideas:**
  - `#!/bin/sh` on this host runs dash 0.5.12, not bash; `bash --posix` changes some bash behaviour
    but is still bash.
  - Not POSIX: `[[ … ]]` and the `function` keyword (both listed as possible reserved words with
    unspecified results), arrays, here-strings, and `local` — although dash and BusyBox ash accept
    `local`.
  - POSIX.1-2024 standardised `set -o pipefail` and `$'…'` quoting, yet dash 0.5.12 fails on
    `set -o pipefail` and silently treats `$'…'` as a literal `$` followed by a single-quoted string
    (no error, exit 0), while BusyBox 1.36.1 ash accepts both: the standard is not the shell a
    machine has.
  - BusyBox ash — the shell in `kernel-01`'s hand-made initramfs — accepted `[[ … ]]` but not arrays
    on this host, a third dialect to test against.
  - This repository writes bash because every place its scripts run has bash; an initramfs `/init`
    or an early-boot script cannot assume it.
  - ShellCheck's `-s sh` checks against POSIX sh, not against whatever `/bin/sh` happens to be.
- **Recall targets:** sort a list of constructs into not-POSIX, POSIX, and POSIX-but-missing-from-
  dash; which of dash's failures is loud and which is silent (`set -o pipefail` against `$'…'`);
  explain what `#!/bin/sh` promises and to whom.
- **Build:** none — each construct is tried under `bash -c`, `dash -c` and `busybox sh -c`.
- **Sources:** POSIX.1-2024 XCU 2.2.4 Dollar-Single-Quotes, 2.4 Reserved Words and 2.9.2 Pipelines,
  <https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html>; `man 1 dash` (dash
  0.5.12); `man bash` (bash 5.2.21) → SHELL BUILTIN COMMANDS → `set -o posix`; ShellCheck 0.9.0
  manual, `-s`, <https://github.com/koalaman/shellcheck/blob/v0.9.0/shellcheck.1.md>.
- **Done when:** Sam classifies every construct in the list and each classification is confirmed
  under all three shells.

## 07 — Reading ShellCheck findings

- **Objective:** Sam can read a ShellCheck finding — code, severity, line — look up its page, and
  decide between fixing the cause and a narrowly scoped, justified directive.
- **Builds on:** lessons 01–06.
- **Key ideas:**
  - ShellCheck statically analyses sh, bash, dash and ksh scripts; every finding has a code
    (`SCnnnn`), a severity (error, warning, info or style) and a wiki page explaining it.
  - CI's `Syntax — Shell` runs `bash -n` and `shellcheck -x` over `code/src/scripts/` and
    `.claude/hooks/`; the ubuntu-24.04 runner image (20260920.314.1) ships ShellCheck 0.9.0.
  - ShellCheck is not installed on this host (`GAPS.md`), so the local loop is `bash -n` and the
    CI run on a pushed branch.
  - `-x` follows `source`; a `# shellcheck source=` directive names the file a computed path means,
    as `code/src/scripts/c/test.sh` does.
  - A `# shellcheck disable=SCnnnn` directive covers only the next command (or the whole script when
    it sits straight after the shebang), and carries a comment saying why.
  - The common findings map to earlier lessons — SC2086 and SC2046 (lesson 01), SC2155 (lesson 02),
    SC2164 (a `cd` that can fail) — and are fixed at the cause, as a C warning is.
- **Recall targets:** given a finding's code, say which earlier lesson's bug it describes; explain
  what `-x` changes and why the repository's scripts need it.
- **Build:** none — read the ShellCheck output of a `Syntax — Shell` run on a branch.
- **Security lens:** most findings are quoting and error-handling bugs, the same bugs that let
  outside input steer a script; a directive that silences one without a reason hides that risk.
- **Sources:** ShellCheck 0.9.0 manual, <https://github.com/koalaman/shellcheck/blob/v0.9.0/shellcheck.1.md>
  (`-S`, `-s`, `-x`); ShellCheck directives, <https://github.com/koalaman/shellcheck/wiki/Directive>;
  SC2086, SC2046, SC2155 and SC2164 at <https://www.shellcheck.net/wiki/SC2086> (same path per code);
  Ubuntu 24.04 runner image, <https://github.com/actions/runner-images/blob/main/images/ubuntu/Ubuntu2404-Readme.md>;
  `.github/workflows/syntax-shell.yml`.
- **Done when:** Sam explains each finding in one real CI run, fixes those at the cause, and
  justifies any directive he keeps.

## 08 — A build-and-verify script to the repository's exit-code contract

- **Objective:** Sam can write, from an empty file, a bash script that builds and verifies one C
  exercise and honours the repository's contract: exit 0, 1 or 2, `--help` from its header, and a
  missing tool reported as "could not run".
- **Builds on:** lessons 01–07; `code/src/scripts/CONTEXT.md` → _The shape every script shares_,
  with `code/src/scripts/c/test.sh` as the worked example.
- **Key ideas:**
  - A script's interface is a contract: its exit codes, its `--help`, its arguments, and what it
    prints on which stream.
  - 0 means the check ran and passed, 1 that it ran and found a problem, 2 that it could not run —
    a missing tool is 2, never 0 and never 1.
  - `--help` prints the header comment, so the documentation and the behaviour cannot drift apart.
  - Keep it thin: make holds the build logic, the script adds only the contract.
  - Every path comes from the repository root, never an absolute home path, and nothing runs `sudo`.
  - Each exit path is proved by making it happen, not by reading the code.
- **Recall targets:** explain why a missing `valgrind` must give 2 rather than 1, and what a reader
  of CI would wrongly conclude otherwise.
- **Build:** `verify.sh` — planned path `code/src/c/msNNN-<kebab>/verify.sh` (planned: `NNN` comes
  from the milestone whose `EX-MS###` spec, written through `project-management/workflows/04-exercise-design/`,
  specifies it), beside the C exercise it verifies. It runs that exercise's make targets in order —
  build, `test`, `san`, `memcheck` — stops at the first failure and exits 0, 1 or 2 per the contract,
  with `--help` printing its header. Checked by: `bash -n`; the `--help` output; exit 1 with a
  planted failing test; exit 2 when a tool it needs is unavailable on `PATH`; and `Syntax — Shell` in
  CI, which today scans only `code/src/scripts/` and `.claude/hooks/`, so the spec also adds the
  exercise folder to `.github/workflows/syntax-shell.yml`. A small exercise, so it lives in this
  repository.
- **Safety:** the script never uses `sudo`, deletes nothing outside the exercise's own `build/`, and
  runs under `set -u`.
- **Sources:** `code/src/scripts/CONTEXT.md`; `code/src/scripts/_lib/common.sh` (`need_tool`,
  `print_help`, `run_gate`); `code/docs/BUILD.md` (the make targets); `man bash` (bash 5.2.21) →
  SHELL BUILTIN COMMANDS → `set`, `trap`.
- **Done when:** all four local checks behave as stated, CI's `Syntax — Shell` is green on the
  branch, and Sam explains each exit path without reading the script.
