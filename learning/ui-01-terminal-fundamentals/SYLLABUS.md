# Syllabus — ui-01-terminal-fundamentals

**Track**: ui · **Phase**: U1 · **Path**: Core · **Detail**: full · **Prerequisites**: P2 (file descriptors, `read`/`write`, processes and signals)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Every Syntek OS tool starts as a terminal program: the package-manager front-end, the installer, the system tools and
the file manager are TUIs first, with GUIs later. This topic opens the UI track by teaching what a TUI library does
underneath, in C and against the kernel's own terminal layer: the device a program talks to, the escape sequences that
draw on it, raw mode, reading keys, reacting to a resize, and the alternate screen. It ends with a tiny full-screen C
program — the first half of the U1 candidate milestone ("a raw-mode terminal program in C, then the same in ratatui
with tests", `project-management/src/01-ROADMAP/ROADMAP.md`). ui-02 rebuilds that program in Rust with ratatui. Every
build here is a small C exercise in this repository, built and tested by CI; the interactive parts are checked by hand
because CI has no terminal. Neither has Claude's tool shell: its stdin is not a tty and its stdout is a pipe, so Sam
runs every interactive exploration in his own terminal emulator and pastes the output.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Terminals, ttys and pseudoterminals | 1 sitting | no | — |
| 02 | Escape sequences: writing to the screen | 1 sitting | yes — vt-sequences | Security |
| 03 | termios and raw mode | 1 sitting | yes — raw-echo | — |
| 04 | Restoring the terminal on every exit path | 1 sitting | yes — raw-echo, extended | — |
| 05 | Reading keys: from bytes to key events | 2–3 sittings | yes — key-decoder | Security |
| 06 | Window size and SIGWINCH | 1 sitting | yes — raw-echo, extended | — |
| 07 | The alternate screen and a tiny full-screen program | multi-session build | yes — tiny-tui | Efficiency |

---

## 01 — Terminals, ttys and pseudoterminals

- **Objective:** Sam can trace a keystroke from the terminal emulator, through a pseudoterminal and the kernel's line
  discipline, to a `read(2)` in his program, and name the device at each end.
- **Builds on:** P2 file descriptors, `read`/`write`, processes and signals.
- **Key ideas:**
  - A terminal emulator is an ordinary program holding the **master** end of a pseudoterminal; the shell and every
    program it starts hold the **slave** end, a `/dev/pts/N` device that behaves like a classic terminal.
  - `/dev/tty` is a synonym for the calling process's controlling terminal, whichever device that is.
  - Between the two ends sits the kernel's **line discipline** (`N_TTY` by default): it echoes, edits lines and turns
    Ctrl-C into SIGINT for the foreground process group — work a TUI will later switch off.
  - `isatty(3)` tells a program whether a file descriptor is a terminal; a pipe or a file is not.
  - `script -c` runs a command inside a fresh pseudoterminal, so a program can be given a terminal without a window —
    and that terminal can report a 0 x 0 size (seen with `stty -a` under `script` on this machine, 27/09/2026).
- **Recall targets:** who generates SIGINT when Ctrl-C is typed, and which processes receive it; why `tty` prints a
  different device in two windows; predict whether stdout is a terminal for the at-the-prompt stand-in
  `[ -t 1 ] && echo tty >&2 || echo not >&2` run plain, piped to `cat`, and under `script -qc … /dev/null`.
- **Build:** none — Sam explores in his own terminal emulator with `tty`, `ls -l /proc/self/fd`, `ps -o pid,tty,cmd`
  and `stty -a`, and pastes the output: Claude's tool shell is not a tty (`tty` prints "not a tty", and `stty -a`
  fails with "Inappropriate ioctl for device"), which is itself a worked example of a pipe.
- **Sources:**
  - `man 4 tty`, `man 7 pty`, `man 4 pts`, `man 3 isatty` (Linux man-pages 6.7).
  - `man 1 script` (util-linux 2.39.3), `man 1 stty` (GNU coreutils 9.4).
  - The Linux kernel documentation, "TTY Line Discipline" (<https://docs.kernel.org/driver-api/tty/tty_ldisc.html>,
    documentation build 7.3.0-rc4, read 27/09/2026).
- **Done when:** Sam draws the path emulator → master → line discipline → slave → program from memory and predicts the
  three results of the `[ -t 1 ]` stand-in correctly, confirmed in his own terminal.

## 02 — Escape sequences: writing to the screen

- **Objective:** Sam can write the byte sequences that move the cursor, clear the screen and set colours and
  attributes, and look any of them up in the standards.
- **Builds on:** lesson 01; P1 strings and buffers.
- **Key ideas:**
  - Control characters (the C0 set: BEL, BS, CR, LF, ESC) versus escape sequences that start with ESC.
  - A CSI sequence is `ESC [`, optional numeric parameters separated by `;`, then a final byte that names the function;
    SGR (`… m`) sets attributes and colours, CUP (`… H`) moves the cursor with 1-based rows and columns.
  - The terminal interprets the bytes, so the available set depends on the emulator: ECMA-48 is the base, DEC private
    modes and xterm extensions sit on top, and the Linux console implements a subset; terminfo names each capability
    so a program need not hard-code one terminal.
  - Anything printed reaches the same interpreter — including text from files, filenames or the network.
- **Recall targets:** name the parts of a CSI sequence; decode a captured sequence from `infocmp -1` by hand; explain
  why the Linux console and xterm can disagree.
- **Build:** yes — a small C module that formats cursor-movement, clear-screen and SGR sequences into a caller-supplied
  buffer (it never writes to stdout itself), with `check.h` tests asserting the exact bytes and the truncation case;
  `code/src/c/msNNN-vt-sequences/` (planned). Checked by `make test`, `make san` and `make memcheck`, then by eye in a
  terminal.
- **Security lens:** untrusted text that reaches a terminal can carry control sequences — MITRE CWE-150. xterm's manual
  warns that its window-operation sequences can be misused by a script and turns them off by default
  (`allowWindowOps`). A TUI therefore neutralises control characters in anything it did not write itself; ui-04's safe
  previews apply this.
- **Sources:**
  - `man 4 console_codes` (Linux man-pages 6.7) — "ECMA-48 CSI sequences" and "ECMA-48 Select Graphic Rendition".
  - ECMA-48, 5th edition, June 1991 (<https://ecma-international.org/publications-and-standards/standards/ecma-48/>).
  - XTerm Control Sequences, updated for XTerm patch #411, 23/08/2026
    (<https://invisible-island.net/xterm/ctlseqs/ctlseqs.html>) — "Functions using CSI".
  - xterm(1), resource `allowWindowOps` (<https://invisible-island.net/xterm/manpage/xterm.html>).
  - CWE-150, "Improper Neutralization of Escape, Meta, or Control Sequences", CWE 4.20
    (<https://cwe.mitre.org/data/definitions/150.html>).
  - `man 5 terminfo`, `man 1 infocmp` (ncurses 6.4).
- **Done when:** the tests pass clean under `san` and `memcheck`, and Sam decodes three captured sequences unaided.

## 03 — termios and raw mode

- **Objective:** Sam can switch a terminal into raw mode with termios and explain what each cleared flag stops the
  kernel doing.
- **Builds on:** lessons 01–02; P2 system calls and error handling (`code/docs/C-CODING-PRINCIPLES.md` Section 3).
- **Key ideas:**
  - Canonical mode delivers input a line at a time with line editing; non-canonical mode delivers bytes as they arrive.
  - The flags `cfmakeraw` clears, by group: `ECHO`, `ICANON`, `ISIG`, `IEXTEN` (local), `IXON`, `ICRNL` and friends
    (input), `OPOST` (output) — and what each means for the program.
  - The pattern: `tcgetattr` → keep the original → change a copy → `tcsetattr` with `TCSAFLUSH`.
  - `VMIN` and `VTIME` pick one of four read behaviours: blocking, polling, timed, or inter-byte timed.
  - Restoring the original settings is the program's job; the kernel does not undo them at exit.
- **Recall targets:** why `\n` stops returning the cursor to column 0 in raw mode; what Ctrl-C does once `ISIG` is
  clear; the four `VMIN`/`VTIME` cases.
- **Build:** yes — a C program that enters raw mode and prints the byte value of each key pressed until `q`, then
  restores the saved settings; `code/src/c/msNNN-raw-echo/` (planned). The "make raw" step is a function over a
  `struct termios` value, so `check.h` tests the flags without a terminal. Checked by `make test`, `make san`,
  `make memcheck`, then by hand: `stty -a` before and after a run is identical.
- **Sources:** `man 3 termios` (Linux man-pages 6.7) — "Canonical and noncanonical mode" and "Raw mode"; `man 1 stty`
  (GNU coreutils 9.4).
- **Done when:** the gates exit 0, the `stty -a` output matches before and after, and Sam explains every cleared flag
  unaided.

## 04 — Restoring the terminal on every exit path

- **Objective:** Sam can guarantee the terminal is restored on a normal exit, an error exit, SIGINT or SIGTERM, and a
  Ctrl-Z followed by `fg`.
- **Builds on:** lesson 03; P2 signals.
- **Key ideas:**
  - List every way the program can end: return from `main`, `exit(3)` with an `atexit(3)` handler, a fatal signal —
    and the one it cannot handle (SIGKILL), which is why `stty sane` or `reset` belongs in the user docs.
  - A signal handler may call only async-signal-safe functions: `tcsetattr` and `write` are on the list, `printf` and
    `malloc` are not.
  - Job control: on SIGTSTP restore the terminal, then stop with the default action; on SIGCONT re-enter raw mode and
    redraw.
  - With `sigaction`, `SA_RESTART` decides whether a blocked `read` is restarted or fails with `EINTR`.
- **Recall targets:** which of `printf`, `write`, `tcsetattr` and `malloc` may run in a handler; what the user sees
  after a SIGKILL; what `SA_RESTART` changes about a blocked `read`.
- **Build:** yes — extend `code/src/c/msNNN-raw-echo/` (planned) so every listed exit path restores the terminal.
  Checked by hand for each path (`kill -TERM`, Ctrl-Z then `fg`, a forced error) by comparing `stty -a`, and by
  `make san` and `make memcheck` on the tests.
- **Sources:** `man 2 sigaction`, `man 7 signal` ("Interruption of system calls and library functions by signal
  handlers"), `man 7 signal-safety`, `man 3 atexit` (Linux man-pages 6.7).
- **Done when:** every exit path leaves `stty -a` unchanged and Sam names the async-signal-safe calls he relied on.

## 05 — Reading keys: from bytes to key events

- **Objective:** Sam can decode the byte stream from a raw terminal into key events — printable characters,
  Ctrl-letters, arrows and function keys, and a lone Esc.
- **Builds on:** lessons 02–04; P1 arrays, `unsigned char` and `switch`.
- **Key ideas:**
  - Printable input arrives as UTF-8, so one key can be several bytes; a Ctrl-letter is a single control byte.
  - Arrow and function keys arrive as escape sequences whose form depends on the cursor-key mode (DECCKM): the normal
    and application forms differ, and terminfo's `kcuu1` and `smkx` say which a terminal uses.
  - A lone Esc and the first byte of a sequence look the same; a short timeout (`VTIME` or `poll(2)`) settles it.
  - One `read` can return several keys or half of one, so the decoder keeps state between calls.
  - Bracketed paste wraps pasted text in `ESC [ 200 ~` … `ESC [ 201 ~`, so a program can tell it from typing.
- **Recall targets:** predict the bytes for Ctrl-A and for Up in both cursor-key modes; explain why the decoder needs
  state; explain why pasted text must not be taken as keystrokes.
- **Build:** yes — a C key decoder that consumes bytes and yields key events, with a `check.h` table of byte sequences
  (including ones split across two calls) and the keys they should produce; `code/src/c/msNNN-key-decoder/` (planned).
  Checked by `make test`, `make san`, `make memcheck`; then wired into raw-echo and compared by hand with what
  `infocmp -1` says this terminal sends.
- **Security lens:** pasted or piped text is data, not commands — without bracketed paste, a pasted line containing
  a key the TUI binds (say `d` for delete) would act on it.
- **Sources:**
  - XTerm Control Sequences, patch #411 (<https://invisible-island.net/xterm/ctlseqs/ctlseqs.html>) — "DEC Private
    Mode Set (DECSET)", `Ps = 1` (DECCKM), and "Bracketed Paste Mode".
  - `man 5 terminfo` (`kcuu1`, `smkx`, `rmkx`) and `man 1 infocmp` (ncurses 6.4).
  - `man 3 termios` (`VMIN`, `VTIME`), `man 2 poll`, `man 7 utf-8` (Linux man-pages 6.7).
- **Done when:** the decoder's tests pass, split sequences included, and Sam predicts the bytes for three keys before
  pressing them.

## 06 — Window size and SIGWINCH

- **Objective:** Sam can read the terminal's size and redraw correctly whenever it changes.
- **Builds on:** lessons 03–05.
- **Key ideas:**
  - `ioctl(fd, TIOCGWINSZ, &ws)` returns rows and columns.
  - When the size changes, the kernel sends SIGWINCH to the terminal's foreground process group.
  - The handler only records that a resize happened (a `volatile sig_atomic_t` flag); the main loop reads the new size
    and redraws.
  - A blocked `read` interrupted by the signal can return `EINTR`; `poll(2)`, or `signalfd(2)`, waits for keys and
    signals in one place.
  - A size of 0 x 0 is possible (lesson 01), so every layout calculation has to cope with it.
- **Recall targets:** who sends SIGWINCH and to whom; why the handler must not redraw; what the program shows at 0
  columns.
- **Build:** yes — extend `code/src/c/msNNN-raw-echo/` (planned) to show the current size and update it on every
  resize. The "fit this text to N columns" function is tested in `check.h`, including N = 0; resizing is checked by
  hand.
- **Sources:** `man 2 ioctl_tty` (`TIOCGWINSZ`, and the SIGWINCH note), `man 7 signal`, `man 2 signalfd`, `man 2 poll`
  (Linux man-pages 6.7).
- **Done when:** repeated resizes always leave a correct display with no stray output, and Sam explains the
  flag-then-redraw split.

## 07 — The alternate screen and a tiny full-screen program

- **Objective:** Sam can write a small full-screen C program that uses the alternate screen, hides the cursor, redraws
  only what changed and leaves the shell exactly as it found it.
- **Builds on:** lessons 02–06, composed.
- **Key ideas:**
  - The alternate screen (`CSI ? 1049 h` to enter, `l` to leave) saves the cursor, switches buffers and clears; the
    user's scrollback is untouched when the program leaves. terminfo calls the pair `smcup` and `rmcup`.
  - Hide the cursor while drawing and show it again on exit (`civis` / `cnorm`).
  - Build each frame in memory and write it once, rather than one `write` per cell.
  - Compare the new frame with the previous one and send only the cells that changed — the idea ratatui's buffer diff
    automates in ui-02.
- **Recall targets:** what the shell looks like after exit with and without `1049`; why one write per frame; what the
  diff saves and what it costs.
- **Build:** yes — a tiny full-screen C program: a bordered box, a cursor the arrow keys move, and a status line showing
  the size and the last key; `code/src/c/msNNN-tiny-tui/` (planned), assembled from lessons 02–06. The frame-diff
  function is tested in `check.h`; by hand, the scrollback is intact and `stty -a` unchanged after exit. This is the C
  half of the U1 candidate milestone.
- **Efficiency lens:** bytes written per frame (a counter around the single write) and the number of `write` calls
  (`strace -c -e trace=write`), full redraw against diff, recorded as budget against measured with the measuring method
  in llm-06 lesson 01.
- **Sources:**
  - XTerm Control Sequences, patch #411 (<https://invisible-island.net/xterm/ctlseqs/ctlseqs.html>) — `Ps = 1 0 4 9`
    and "The Alternate Screen Buffer".
  - `man 5 terminfo` (`smcup`, `rmcup`, `civis`, `cnorm`) and `man 1 tput` (ncurses 6.4).
  - `man 1 strace` (strace 6.8).
- **Done when:** the gates are clean, the shell is unchanged after exit, and bytes per frame are recorded for full
  redraw and for diff.
