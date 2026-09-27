# Mission — ui-04-file-manager-tui

**Started**: not yet · **Family**: ui · **Phase**: U2 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam said he is happy to use existing GUIs but wants Syntek OS's own tools, and that friends and family could build
"the TUI, file manager etc." The file manager comes first: it needs nothing from the OS track, it is useful on every
profile, and it is a project others can join. Studying Yazi shows how a fast Rust file manager is built; building one
teaches the parts that matter anywhere — never blocking on I/O, treating every file as untrusted input, a trash that
interoperates, and operations that can be cancelled and undone. It is also the first tool to move to its own
repository, where contributors can extend it.

## Can do it when

- Sam can explain how Yazi stays responsive: chunked loading, discardable tasks and prioritised scheduling.
- Sam can list a 100,000-entry directory in chunks with the UI responsive, with the timings measured.
- Sam can preview hostile files — control characters in names, FIFOs, devices, symlinks — safely, and state the
  preview pane's threat model.
- Sam can trash, list and restore files as the FreeDesktop Trash specification requires, `EXDEV` included.
- Sam can run a long copy with honest progress, cancel it without leaving a partial file, and undo it.
- The file manager builds from its own repository's README, with licence, CONTRIBUTING and green CI.

## Parked for later

- Sandboxing external previewers — sec-04-linux-security-model, then a later ui-04 lesson if needed.
- Image previews through terminal graphics protocols (sixel, kitty) — not scheduled.
- Remote file systems and plugins (Yazi has both) — not scheduled.
- A GUI file manager — the desktop profiles reuse existing ones (os-15-desktop-editions).
