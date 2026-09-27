# ADR-MS001: GUI toolkit — gtk4-rs for lessons here; Slint for Syntek OS products in their own repositories

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-GUI-TOOLKIT-GTK4 |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources and a cargo-deny run cited below); `research/GUI-TOOLKIT-LICENCE.md` (planned) may extend the survey |
| **Enforced in** | `code/src/rust/deny.toml` (the build-time exception for `target-lexicon`) · `project-management/src/01-ROADMAP/ROADMAP.md` → U3 · the Syntek OS GUI-tools repository (created when its build starts) |

---

## Context

The Syntek OS tools start as terminal UIs (`ADR-MS001-SYNTEK-OS-TOOLS-RUST-TUI-FIRST-27-09-2026.md`);
U3 adds GUI versions for the desktop profiles. A Rust GUI toolkit has to pass this repository's
licence gate (GPL-2.0-only; `code/src/rust/deny.toml`), support screen readers (the beginner
profile's users include people who rely on one), and run on the Wayland desktops Syntek OS reuses. The
planning conversation (Q11) named iced (which COSMIC uses) or Slint as candidates.

Facts checked on 27/09/2026 with crates.io, the projects' own pages and a cargo-deny 0.19.0 run
using this repository's `deny.toml` against scratch crates outside the repository (the policy sets no
target filter, so every platform's dependencies are checked):

- **iced 0.14.0** is MIT-licensed, but cargo-deny rejects 17 to 19 crates in its graph (the count
  moves with the lockfile; a fresh resolve on 27/09/2026 gave 17), including `winit` 0.30.13
  (Apache-2.0), `ab_glyph`, `owned_ttf_parser`, `unicode-linebreak` and `spirv` (all Apache-2.0),
  `dpi` (`Apache-2.0 AND MIT`) and `hexf-parse` (CC0-1.0). `self_cell` (`Apache-2.0 OR
  GPL-2.0-only`) is rejected only because the allow list does not name GPL-2.0-only for third-party
  crates. Its accessibility issue,
  "Implement accessibility support" (iced#552), is open (Sources, item 1).
- **Slint 1.18.1** is offered under GPL-3.0-only, a royalty-free licence or a commercial licence
  (`GPL-3.0-only OR LicenseRef-Slint-Royalty-free-2.0 OR LicenseRef-Slint-Software-3.0`). The
  royalty-free licence covers proprietary desktop, mobile and web applications that disclose their
  use of Slint, and excludes embedded systems (Sources, item 2). The FSF notes that GPLv3 is not
  compatible with GPLv2 by itself (Sources, item 3), and the two Slint licences are not on this
  repository's allow list. Slint's winit backend has an optional accessibility feature built on
  AccessKit, including its Unix adapter (Sources, item 4).
- **gtk4-rs (gtk4 0.11.5)** is MIT-licensed bindings; it declares a minimum Rust of 1.92, which the
  workspace pin meets. cargo-deny rejects exactly one crate in its graph: `target-lexicon` 0.13.5
  (`Apache-2.0 WITH LLVM-exception`), reached only as a build dependency (`system-deps` → `cfg-expr`,
  used by the `-sys` crates' build scripts), so it runs at build time and is not linked into the
  binary; the LLVM exception itself expressly addresses combining the software with GPLv2 code
  (Sources, item 10). GTK itself is LGPL-2.1-or-later and includes a small
  number of Apache-licensed source files (a roaring-bitmap fork and a timsort adaptation) (Sources,
  item 5); it is a system library the bindings link to, not a crate. GTK's AT-SPI accessibility
  backend serves Linux screen readers (Sources, item 6).

## Options considered

### Option A — gtk4-rs

- **Summary:** Rust bindings over GTK 4, the toolkit GNOME is built on.
- **Pros:** Passes the licence gate with one build-time exception. Mature accessibility through
  AT-SPI. GTK is packaged in BLFS 13.1, so Syntek OS can build it from the book.
- **Cons:** An object-oriented C toolkit seen through Rust bindings — a different model from
  ratatui's immediate mode, and more ceremony for small tools.

### Option B — iced

- **Summary:** A pure-Rust, Elm-inspired toolkit, used by COSMIC.
- **Pros:** Idiomatic Rust and The Elm Architecture that U1 teaches for TUIs.
- **Cons:** Nineteen rejected crates, most of them Apache-2.0 only, including the windowing layer
  every platform uses. No screen-reader support while iced#552 is open.

### Option C — Slint

- **Summary:** A declarative UI language with Rust, C++ and JavaScript APIs.
- **Pros:** A clean declarative model; accessibility through AccessKit; suited to products.
- **Cons:** None of its three licences can combine with this repository's GPL-2.0-only code; its
  royalty-free and commercial licences are Slint's own terms.

### Option D — No GUI in this repository

- **Summary:** Stay terminal-only; learn GUIs only in product repositories.
- **Pros:** No licence exceptions.
- **Cons:** The desktop profiles' tools would have no lessons behind them.

## Decision

**We will take Option A for this repository and Option C for Syntek OS products (Sam's decision
after the critique, 27/09/2026).** Lessons here use gtk4-rs, with a documented build-dependency
exception for `target-lexicon` in `code/src/rust/deny.toml`. Syntek OS's GUI products are written in
Slint, in their own repositories under their own licence; Slint's licence options are checked there,
not here, and no Slint crate enters this repository. The deciding factor for gtk4-rs is that it is
the only candidate that passes the licence gate with a single build-time exception and has working
screen-reader support today. iced was the runner-up on design fit, and lost on both counts.

This answer changes if iced gains screen-reader support and a licence-clean graph, or if a product
repository's licence choice makes Slint unusable there — each argued in a new ADR.

## Consequences

- **Positive:** `ui-08-gui-foundations` has a buildable toolkit, and its accessibility lesson has real
  AT-SPI support to test. Product repositories are free to choose Slint's licence that suits them.
- **Negative:** Two toolkits to learn: GTK in lessons, Slint for products. The Slint build happens only
  in the Syntek OS GUI-tools repository, so its lessons (`ui-09-gui-tools`) teach its model here and
  name that repository as where the build lands.
- **Follow-on:**
  - `code/src/rust/deny.toml` gains a build-time exception for `target-lexicon` citing this record
    (under `ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md`'s per-crate rule).
  - To confirm — iced and Slint as the candidates came from the conversation's recommendation (Q11);
    gtk4-rs was added after the licence check.
  - `GAPS.md` → "Per-crate licence exceptions arrive with the first crate that needs them" tracks
    the `target-lexicon` exception until the milestone that first adds gtk4 writes it.

## Sources

1. **iced** — <https://github.com/iced-rs/iced>; **issue #552, "Implement accessibility support"** —
   <https://github.com/iced-rs/iced/issues/552> (open), checked 27/09/2026
2. **Slint licence** — <https://raw.githubusercontent.com/slint-ui/slint/master/LICENSE.md> — the three
   licences and the royalty-free terms, checked 27/09/2026
3. **FSF, Various licenses and comments about them** —
   <https://www.gnu.org/licenses/license-list.html> — GPLv3 not compatible with GPLv2 by itself;
   gnu.org timed out on 27/09/2026, so checked via
   <https://web.archive.org/web/20260926203802/https://www.gnu.org/licenses/license-list.html>
4. **Slint winit backend manifest** —
   <https://raw.githubusercontent.com/slint-ui/slint/master/internal/backends/winit/Cargo.toml> — the
   optional `accessibility` feature on `accesskit` and `accesskit_winit` with `accesskit_unix`,
   checked 27/09/2026
5. **GTK README, Licensing terms** — <https://raw.githubusercontent.com/GNOME/gtk/main/README.md> —
   LGPL-2.1-or-later and the Apache-licensed files, checked 27/09/2026
6. **GTK 4 documentation, Accessibility** — <https://docs.gtk.org/gtk4/section-accessibility.html> —
   the AT-SPI backend on Linux, checked 27/09/2026
7. **crates.io API** — `https://crates.io/api/v1/crates/<name>` for iced, slint, gtk4, winit and
   target-lexicon — versions, licences and minimum Rust, checked 27/09/2026
8. **Host commands, 27/09/2026** — `cargo deny check licenses` (cargo-deny 0.19.0) with
   `code/src/rust/deny.toml`, and `cargo tree -i target-lexicon -e normal,build`, on scratch crates
   outside the repository depending on iced and gtk4
9. **Beyond Linux From Scratch 13.1 (systemd)** —
   <https://www.linuxfromscratch.org/blfs/view/stable-systemd/> — GTK packaged in the book, checked
   27/09/2026
10. **SPDX, LLVM-exception** — <https://spdx.org/licenses/LLVM-exception.html> — the clause on
    combining or linking with GPLv2-licensed software, checked 27/09/2026
