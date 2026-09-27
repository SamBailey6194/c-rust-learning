# Mission — ui-01-terminal-fundamentals

**Started**: not yet · **Family**: ui · **Phase**: U1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam wants "TUI and GUI things built" for Syntek OS: he is happy to reuse existing desktops, but the package-manager
front-end, the installer, the settings and system tools and a file manager are to be Syntek OS's own, written in Rust
with ratatui and built as TUIs first — and friends and family may help build them. Before leaning on a library, this
topic shows what every TUI actually does to a terminal, in the C he is learning in P2: raw mode, escape sequences,
keys, resizes and the alternate screen. It unlocks ui-02 (the same program in ratatui) and makes every later tool's
terminal handling something he understands rather than trusts.

## Can do it when

- Sam can trace a keystroke from the terminal emulator through a pseudoterminal and the line discipline to his
  program's `read`.
- Sam can write, and decode by hand, the escape sequences for cursor movement, clearing and colour.
- Sam can put a terminal into raw mode and restore it on every exit path, including signals and job control.
- Sam can decode raw key bytes into key events, a lone Esc and a split sequence included.
- Sam can redraw correctly on SIGWINCH.
- A tiny full-screen C program uses the alternate screen, leaves the shell as it found it, and its tests pass under
  `make test`, `make san` and `make memcheck`.

## Parked for later

- ratatui, crossterm and the immediate-mode render loop — ui-02-ratatui-foundations.
- Background work that never blocks the UI, and testing rendered screens — ui-03-tui-architecture-and-testing.
- Neutralising control sequences in untrusted file names and contents — ui-04-file-manager-tui.
- Mouse reporting and terminal graphics protocols (sixel, kitty) — not scheduled; a later ui topic if a tool needs them.
