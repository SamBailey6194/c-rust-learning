# Mission — ui-03-tui-architecture-and-testing

**Started**: not yet · **Family**: ui · **Phase**: U1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam plans a family of Syntek OS tools — a file manager first, then the package-manager front-end, the installer and
settings/system tools — and hopes friends and family will contribute to them. Tools that several people extend need
one shared shape and tests that catch a broken screen before a person does. This topic gives them that: The Elm
Architecture, background work that never freezes the interface (on a thread, then on tokio), rendered-screen tests,
clean error handling and cheap redraws for huge lists. It finishes U1, and every U2 tool reuses it.

## Can do it when

- Sam can structure a TUI as model, messages, update and view, with update tested without a terminal.
- Sam can run slow work on a worker thread or a tokio task and keep the UI responsive, with cancellation.
- Sam can test widgets against a `Buffer` and whole screens against a `TestBackend` at several sizes, with no snapshot
  dependency.
- Sam can separate fatal from recoverable errors so the terminal is always restored before a fatal one is printed.
- A 100,000-item list scrolls smoothly, with frame time and memory measured for the full and windowed versions.
- The U1 candidate milestone — the tiny program in C, then in ratatui with tests — passes CI.

## Parked for later

- Directory listing, previews and file operations at scale — ui-04-file-manager-tui.
- Consuming a library's API from a TUI (the package manager) — ui-05-package-manager-tui.
- Privilege separation between a UI and a helper — ui-07-system-tools-tui.
- Snapshot testing with insta — only if a milestone takes the per-crate licence exception.
