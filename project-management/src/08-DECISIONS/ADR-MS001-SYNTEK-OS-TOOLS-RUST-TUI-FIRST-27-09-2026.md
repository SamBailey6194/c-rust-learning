# ADR-MS001: Syntek OS tools — custom tools in Rust, terminal UI first, GUI later

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-SYNTEK-OS-TOOLS-RUST-TUI-FIRST |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources cited below) |
| **Enforced in** | `project-management/src/01-ROADMAP/ROADMAP.md` → U1 to U3 · `code/src/rust/deny.toml` (what a TUI crate may depend on) · the Syntek OS file-manager, package-manager, installer and system-tools repositories (created when each build starts) |

---

## Context

Syntek OS reuses existing desktops (`ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md`), but some
tools have to be its own because they sit on its own parts: a front-end for its package manager, an
installer that knows its profiles, settings and system tools for its services, and a file manager. In
his planning conversation of 27/09/2026 (Q11) Sam said these custom tools — a TUI and a file manager
among them — are where friends and family could contribute. The answer recommended Rust with ratatui,
a TUI file manager first (studying Yazi), and GUI versions later.

Facts checked on 27/09/2026:

- **ratatui** is a Rust library for building terminal user interfaces (Sources, item 1), rendered
  immediately each frame through intermediate buffers (Sources, item 2). Version 0.30.2 is
  MIT-licensed and declares a minimum Rust of 1.88.0 (crates.io), inside the workspace pin of 1.92.0
  (`ADR-MS001-RUST-EDITION-2024-TOOLCHAIN-PIN-27-09-2026.md`). Its terminal backend crossterm 0.29.0
  is MIT.
- **The licence gate.** A cargo-deny 0.19.0 run with this repository's `code/src/rust/deny.toml`
  against a scratch crate depending on ratatui 0.30.2 rejects exactly one crate: `ryu` 1.0.23,
  licensed `Apache-2.0 OR BSL-1.0`, reached through `compact_str` and `ratatui-core`. The Free Software
  Foundation lists the Boost Software License as compatible with the GNU GPL (Sources, item 3), so
  adding `BSL-1.0` to the allow list admits ratatui with no exception.
- **Yazi**, the file manager to study, describes itself as a fast terminal file manager written in
  Rust and based on async I/O (Sources, item 4).
- **Servers have no display.** The server family ships no graphical session, so every tool it needs
  must work in a terminal or over SSH.

## Options considered

### Option A — Rust with ratatui; TUI first, GUI versions later

- **Summary:** Each tool is a Rust library crate plus a thin terminal front-end in ratatui; GUI
  front-ends follow in U3 over the same libraries.
- **Pros:** Memory-safe code for tools that run with privilege or parse untrusted input (packages,
  partition tables, file previews). One language across the package manager and its front-ends.
  Works on every profile, including over SSH. Rust's test tooling and ratatui's `TestBackend`, which
  renders to an in-memory buffer for integration tests (Sources, item 8), make the UI testable in
  CI.
- **Cons:** Sam's Rust is the least mature of his languages until P3 completes, so U1's Rust topics
  wait for P3. Contributors need Rust.

### Option B — C with ncurses

- **Summary:** Terminal tools in C.
- **Pros:** Uses the C Sam learns in P1 and P2; ncurses is ubiquitous.
- **Cons:** Tools that parse untrusted input in C carry the memory-safety classes the rest of the
  curriculum spends time defending against; no shared library with a Rust package manager without
  FFI.

### Option C — GUI first

- **Summary:** Build graphical tools first, terminal versions later or never.
- **Pros:** Friendlier to the beginner profile.
- **Cons:** Useless on the server family, which is the recommended first edition; the GUI toolkit
  question (`ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md`) would gate every tool.

### Option D — Shell scripts with dialog-style widgets

- **Summary:** Menus built from shell and a dialog utility.
- **Pros:** Fastest to a first screen.
- **Cons:** Hard to test and to make safe with untrusted input; no library for a GUI to share later.

## Decision

**We will take Option A: Syntek OS's custom tools are written in Rust, terminal UI first, each as a
library crate with a thin front-end, with GUI versions later.** The deciding factor is that the
first edition is a server family edition with no display, so a TUI is the tool every profile can
use, and Rust keeps the parsing of untrusted input memory-safe. ratatui is recorded as the current
choice of TUI library.

This answer changes if ratatui stops being maintained or cannot pass the licence gate, or if a
profile's users cannot use a terminal tool at all — each argued in a new ADR.

## Consequences

- **Positive:** The file manager (`ui-04-file-manager-tui`) can start as soon as U1 closes, with no
  OS-track dependency — the natural first project for contributors. The package-manager library
  (`os-07-package-manager`) is the contract its TUI and GUI front-ends consume.
- **Negative:** U1's ratatui topics wait for P3, including its async topic. Contributors need Rust
  and the repository's licence gate.
- **Follow-on:**
  - To confirm — ratatui as the TUI library, and Yazi as the file manager to study, were the
    conversation's recommendations.
  - `code/src/rust/deny.toml` gains `BSL-1.0` in `[licenses] allow`, citing the FSF licence list.
  - A substantial tool (and any tool taking outside contributions) gets its own repository when its
    build starts, with a contribution guide, CI and a licence chosen up front
    (`ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md` → the repository boundary;
    `ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md` → licences are per repository;
    `tooling-05-licensing-and-collaboration` teaches the choice). This repository keeps Sam's lesson
    exercises and prototypes.

## Sources

1. **Ratatui** — <https://ratatui.rs/> — what ratatui is, checked 27/09/2026
2. **ratatui crate documentation** — <https://docs.rs/ratatui/latest/ratatui/> — immediate rendering
   with intermediate buffers, checked 27/09/2026
3. **FSF, Various licenses and comments about them** —
   <https://www.gnu.org/licenses/license-list.html> — the Boost Software License is GPL-compatible;
   gnu.org timed out on 27/09/2026, so checked via the Wayback Machine copy of 26/09/2026,
   <https://web.archive.org/web/20260926203802/https://www.gnu.org/licenses/license-list.html>
4. **Yazi** — <https://github.com/sxyazi/yazi> — repository description, checked 27/09/2026
5. **crates.io API** — `https://crates.io/api/v1/crates/<name>` for ratatui, crossterm and ryu —
   version, licence and minimum Rust, checked 27/09/2026
6. **Host command, 27/09/2026** — `cargo deny check licenses` (cargo-deny 0.19.0) with
   `code/src/rust/deny.toml`, on a scratch crate outside the repository depending on ratatui 0.30.2
7. **Sam's planning conversation, 27/09/2026** — Q11 (the decision and the recommendations)
8. **ratatui `TestBackend`** — <https://docs.rs/ratatui/latest/ratatui/backend/struct.TestBackend.html>
   — a backend for integration tests that renders to a memory buffer, checked 27/09/2026
