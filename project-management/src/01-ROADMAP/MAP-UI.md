# MAP-UI — TUI and GUI tools (U1–U3)

**Charted**: 27/09/2026 | **Charted by**: Sam Bailey | **Workflow**: `01-roadmap-map`
**Phase**: U1–U3 — `project-management/src/01-ROADMAP/ROADMAP.md`
**Status**: Charting
**Frontier open**: 1 | **Blocking open**: 0

> A `Charting` draft: destination and open decisions from Sam's planning conversation of 27/09/2026
> and its ADRs; nodes resolve in later sessions, one at a time. **The map is an index, not a vault.**

---

## Destination

U1–U3 exit gates met (`ROADMAP.md` → U1, U2, U3): a ratatui program tested through `TestBackend`; the
Syntek OS tools — file manager first, then the package-manager TUI, installer and system tools —
each a Rust library with a thin front-end, in its own repository from when its build starts; GUI
lessons in gtk4-rs here, with the product GUI tools in Slint in their own repositories; and the
NAS/router web dashboard. The tools Syntek OS ships beside the reused desktops are the destination.

---

## Notes

| Field | Value |
| --- | --- |
| Phase exit gate | U1–U3 — `project-management/src/01-ROADMAP/ROADMAP.md` → U1, U2, U3 |
| Already known | _Not yet asked — the first charting session with Sam fills this._ (Sam's HTML, HTMX, CSS and PHP are a standing input for the web dashboard.) |
| Expected to be hard | _Not yet asked — the first charting session with Sam fills this._ |
| Skills to load | from `.claude/skills/`: teach, research, handoff, wait-what |
| Standing preferences | custom tools in Rust; ratatui TUIs first, GUIs later; a library crate plus a thin front-end; contributions welcome once a tool moves to its own repository |
| Umbrella ADRs | `ADR-MS001-SYNTEK-OS-TOOLS-RUST-TUI-FIRST-27-09-2026.md` · `ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md` · `ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md` (all in `project-management/src/08-DECISIONS/`) |
| Primary resources | the U1–U3 lists in `ROADMAP.md`; ratatui and crossterm docs; the Yazi repository; gtk4-rs docs |
| Register entries triaged | 0 closes, 2 blocks, 0 unrelated — from `GAPS.md` |

**Register triage is a claim, not a close.** Two `GAPS.md` entries block U3's gtk4-rs builds: "GTK 4
development files not installed" (retired when U3 opens and CI's runner installs the package too)
and "Per-crate licence exceptions arrive with the first crate that needs them" (gtk4's
`target-lexicon` build-dependency exception, frontier node N-003). Nothing here edits either
register.

---

## Resolved decisions

| Node | Decision | Type | Settled | Became |
| --- | --- | --- | --- | --- |
| N-001 | Custom tools in Rust, ratatui TUI first, GUI later | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-TOOLS-RUST-TUI-FIRST-27-09-2026.md` |
| N-002 | gtk4-rs for GUI lessons here; Slint for products in their own repositories | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md` |
| N-004 | Each substantial tool build (file manager, package-manager front-end, installer, system tools) gets its own repository when its build starts; this repository keeps lessons and small exercises (Sam, after the critique) | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md` → the repository boundary |

---

## Slices

Filled at CUT; candidates in `ROADMAP.md` → U1, U2, U3.

| Slice | Milestone | Title | Nodes | Mastery (what must be true) | Flags |
| --- | --- | --- | --- | --- | --- |
| S-01 | — | cut after the blocking nodes resolve — candidates in `project-management/src/01-ROADMAP/ROADMAP.md` → U1/U2/U3 | — | — | — |

---

## Frontier

| Node | Decision | Type | Blocked by | Blocking a milestone? |
| --- | --- | --- | --- | --- |
| N-003 | The `target-lexicon` build-dep exception in `deny.toml` for gtk4-rs | build | `GAPS.md` → "Per-crate licence exceptions arrive with the first crate that needs them" (the ADR decided the toolkit; the exception is mechanical) | no |

**Blocking a milestone?** N-003 does not block: U1 needs no toolkit choice, and the file manager (the
first U2 build) has no OS-track or GUI dependency.

---

## Fog of war

- Which desktop each desktop profile ships (decided in `os-15-desktop-editions`), which sets what the
  GUI tools are themed for.
- How friends and family contribute (the contribution guide, CI and licence) — settled when the first
  tool crate moves to its own repository (`tooling-05-licensing-and-collaboration` teaches it).

---

## Out of scope

| Ruled out | Why |
| --- | --- |
| iced as the GUI toolkit | fails the licence gate and has no screen-reader support — `ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md` |
| A Slint crate in this repository | Slint is for the product repositories under their own licence — same ADR |
| C with ncurses for the tools | tools parsing untrusted input stay memory-safe in Rust — `ADR-MS001-SYNTEK-OS-TOOLS-RUST-TUI-FIRST-27-09-2026.md` |

---

## Session log

| Date | Node settled | Outcome | Frontier redrawn |
| --- | --- | --- | --- |
| 27/09/2026 | N-001, N-002 | two ADRs in `project-management/src/08-DECISIONS/` | [x] |
| 27/09/2026 | N-004 | the repository boundary → `ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md` | [x] |

---

## Gate to milestones

- [ ] Destination and out-of-scope bounds agreed with the learner
- [ ] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes, blocks or unrelated
- [ ] Every claimed entry names what will retire it; **neither register edited here**
- [ ] Every knowable decision is a node or sits in fog of war
- [ ] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a milestone" is resolved**
- [ ] Every resolved node links to the artefact it became
- [ ] **Every slice has a mastery line and a flag manifest**
- [ ] Index row in `project-management/src/01-ROADMAP/CONTEXT.md` current

**Milestones may be cut in `project-management/workflows/02-milestone-creation/` once every box above
is ticked.** This map is `Charting`; those boxes are unticked by design.
