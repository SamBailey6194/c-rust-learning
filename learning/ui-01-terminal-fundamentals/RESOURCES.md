# Resources — ui-01-terminal-fundamentals

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Terminals, ttys and pseudoterminals | `man 4 tty`, `man 7 pty`, `man 3 isatty` (Linux man-pages 6.7); "TTY Line Discipline", <https://docs.kernel.org/driver-api/tty/tty_ldisc.html> (build 7.3.0-rc4) | — | — |
| 02 Escape sequences: writing to the screen | `man 4 console_codes` (Linux man-pages 6.7); XTerm Control Sequences, patch #411, <https://invisible-island.net/xterm/ctlseqs/ctlseqs.html>; ECMA-48 5th edition, <https://ecma-international.org/publications-and-standards/standards/ecma-48/>; CWE-150 (4.20), <https://cwe.mitre.org/data/definitions/150.html> | `code/docs/C-CODING-PRINCIPLES.md` — Section 1 Style; `code/docs/TESTING.md` — Section 1 | `code/src/c/msNNN-vt-sequences/` (planned) |
| 03 termios and raw mode | `man 3 termios` — "Canonical and noncanonical mode", "Raw mode" (Linux man-pages 6.7); `man 1 stty` (GNU coreutils 9.4) | `code/docs/C-CODING-PRINCIPLES.md` — Section 3 Error handling | `code/src/c/msNNN-raw-echo/` (planned) |
| 04 Restoring the terminal on every exit path | `man 2 sigaction`, `man 7 signal`, `man 7 signal-safety`, `man 3 atexit` (Linux man-pages 6.7) | `code/docs/MEMORY-SAFETY.md` — Section 6 What "clean" means | `code/src/c/msNNN-raw-echo/` (planned) |
| 05 Reading keys: from bytes to key events | XTerm Control Sequences, patch #411 — DECSET `Ps = 1` (DECCKM), "Bracketed Paste Mode"; `man 5 terminfo`, `man 1 infocmp` (ncurses 6.4) | `code/docs/TESTING.md` — Section 3 Test discipline | `code/src/c/msNNN-key-decoder/` (planned) |
| 06 Window size and SIGWINCH | `man 2 ioctl_tty` (`TIOCGWINSZ`), `man 2 signalfd`, `man 2 poll` (Linux man-pages 6.7) | `code/docs/DEBUGGING.md` — Section 2 gdb essentials | `code/src/c/msNNN-raw-echo/` (planned) |
| 07 The alternate screen and a tiny full-screen program | XTerm Control Sequences, patch #411 — `Ps = 1 0 4 9`, "The Alternate Screen Buffer"; `man 5 terminfo` (`smcup`, `rmcup`, `civis`, `cnorm`, ncurses 6.4); `man 1 strace` (strace 6.8) | `code/docs/BUILD.md` — Section 3 The make targets | `code/src/c/msNNN-tiny-tui/` (planned) |
