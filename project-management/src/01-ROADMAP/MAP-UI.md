# MAP-UI — TUI and GUI tools (U1–U3)

**Charted**: 27/09/2026 | **Charted by**: Sam Bailey | **Workflow**: `01-roadmap-map`
**Phase**: U1–U3 — `project-management/src/01-ROADMAP/ROADMAP.md`
**Status**: Charting
**Frontier open**: 5 | **Blocking open**: 0

> A `Charting` draft: destination and open decisions from Sam's planning conversation of 27/09/2026
> and its ADRs; nodes resolve in later sessions, one at a time. **The map is an index, not a vault.**

---

## Destination

U1–U3 exit gates met (`ROADMAP.md` → U1, U2, U3): a ratatui program tested through `TestBackend`; the
Syntek OS tools — file manager first, then the package-manager TUI, installer and system tools —
each a Rust library with a thin front-end, in its own repository from when its build starts; GUI
lessons in gtk4-rs here, with the product GUI tools in Slint in their own repositories; and the
NAS/router web dashboard. The tools Syntek OS ships beside the reused desktops are the destination.
Beside them, and holding no exit gate, a consent-first remote-help tool for Sam's family (`ui-11`,
Later), in its own repository.

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
| Register entries triaged | 0 closes, 7 blocks, 21 unrelated — from the 28 open `GAPS.md` entries; `DEFERRED.md`'s eight rows: 1 closes, 7 unrelated |

**Register triage is a claim, not a close.** Recounted on 28/09/2026, after the networking and
licensing round and the scripted-recorder round, over every open `GAPS.md` entry and every
`DEFERRED.md` row. Seven `GAPS.md` entries block this track:

- "GTK 4 development files not installed" (retired when U3 opens and CI's runner installs the package
  too) and "Per-crate licence exceptions arrive with the first crate that needs them" (gtk4's
  `target-lexicon` build-dependency exception, frontier node N-003) block U3's gtk4-rs builds.
- "Remote-help law and dual-use publishing not yet researched" blocks `ui-11` lessons 01, 06 and 09
  and the remote-help ADR's acceptance (retired by the four research notes of N-005). "Export rules
  for shipping cryptography" blocks the first public binary release in `ui-11` lesson 09.
- "No ACME issuer chosen for the private CA" blocks the renewed dashboard leaf of `ui-10` lesson 05,
  through `sec-05` lesson 13.
- "Scripted recorder build dependencies not installed" blocks every Build of `ui-12` and `ui-13`.
- "Licensor and copyright holder of the product repositories" blocks a UI product repository only if
  it picks a gated entry from the approved outbound list.

Of `DEFERRED.md`, this track takes up "Graphical desktop sharing for remote help" (`DEFERRED (U3)`);
the other seven are unrelated. Nothing here edits either register.

---

## Resolved decisions

| Node | Decision | Type | Settled | Became |
| --- | --- | --- | --- | --- |
| N-001 | Custom tools in Rust, ratatui TUI first, GUI later | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-TOOLS-RUST-TUI-FIRST-27-09-2026.md` |
| N-002 | gtk4-rs for GUI lessons here; Slint for products in their own repositories | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md` |
| N-004 | Each substantial tool build (file manager, package-manager front-end, installer, system tools) gets its own repository when its build starts; this repository keeps lessons and small exercises (Sam, after the critique) | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md` → the repository boundary |
| N-009 | The scripted recorder's Wayland stages target headless Hyprland (`ui-12`), then GNOME and KDE through the portal and PipeWire (`ui-13`), each in a guest, Later and outside U2's exit gate | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-SCRIPTED-RECORDER-STAGED-LEARNING-PROJECT-27-09-2026.md` |

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
| N-005 | What the law asks of remote help and of publishing it | research | `research/REMOTE-HELP-CONSENT-AND-THE-COMPUTER-MISUSE-ACT.md`, `research/REMOTE-HELP-TOOL-AND-SECTION-3A.md`, `research/REMOTE-HELP-SESSION-RECORDS-AND-UK-GDPR.md` and `research/DUAL-USE-TOOLS-ON-GITHUB.md` (all planned); `GAPS.md` → "Remote-help law and dual-use publishing not yet researched" | no |
| N-006 | The tool's consent-first envelope | explain-first | N-005; drafted as `ADR-MS001-REMOTE-HELP-TOOL-CONSENT-FIRST-27-09-2026.md` (Proposed), Accepted once N-005 resolves and Sam signs off | no |
| N-007 | The mTLS stack under the licence gate | research | N-006; `sec-05-applied-cryptography` lessons 08–13; `ADR-MS001-PRODUCT-LICENCES-APPROVED-OUTBOUND-LIST-27-09-2026.md`; `research/RUST-MTLS-STACK-LICENCES.md` (planned) | no |
| N-008 | Headless Hyprland in a guest: how it gets a DRM device and seat, which capture protocol and virtual-input protocols it offers, and which release to pin | research | the recorder's stage 2 `Done`; `research/HYPRLAND-HEADLESS-CAPTURE-AND-INPUT.md` (planned, written when `ui-12` opens) | no |

**Blocking a milestone?** N-003 does not block: U1 needs no toolkit choice, and the file manager (the
first U2 build) has no OS-track or GUI dependency. N-005 to N-007 do not block either: `ui-11` is
Later and holds no exit gate, so they gate its lessons (01, 03, 06 and 09), not a milestone. N-008
does not block: `ui-12` is Later and outside U2's exit gate, so it gates `ui-12`'s lessons 01–04 only.

---

## Fog of war

- Which desktop each desktop profile ships (decided in `os-15-desktop-editions`), which sets what the
  GUI tools are themed for.
- How friends and family contribute (the contribution guide, CI and licence) — the rules are fixed by
  `project-management/src/08-DECISIONS/ADR-MS001-PRODUCT-LICENCES-INBOUND-RULES-27-09-2026.md`; the
  rest is settled per repository when the first tool crate moves (`tooling-05-licensing-and-collaboration`
  teaches it).
- Devices that do not run Linux, for the remote-help tool: `ui-11` is Linux terminal sessions only
  (`ADR-MS001-REMOTE-HELP-TOOL-CONSENT-FIRST-27-09-2026.md`).
- Whether the beginner profile ships the remote-help tool.
- Re-running the recorder's Wayland tapes on the Syntek OS expert image once P6 builds it
  (`os-15-desktop-editions` lesson 05), in place of a stock guest.

---

## Out of scope

| Ruled out | Why |
| --- | --- |
| iced as the GUI toolkit | fails the licence gate and has no screen-reader support — `ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md` |
| A Slint crate in this repository | Slint is for the product repositories under their own licence — same ADR |
| C with ncurses for the tools | tools parsing untrusted input stay memory-safe in Rust — `ADR-MS001-SYNTEK-OS-TOOLS-RUST-TUI-FIRST-27-09-2026.md` |
| Unattended remote access (an always-on agent) | a RAT's shape; the consent-first ADR's non-goals — `ADR-MS001-REMOTE-HELP-TOOL-CONSENT-FIRST-27-09-2026.md` |

---

## Session log

| Date | Node settled | Outcome | Frontier redrawn |
| --- | --- | --- | --- |
| 27/09/2026 | N-001, N-002 | two ADRs in `project-management/src/08-DECISIONS/` | [x] |
| 27/09/2026 | N-004 | the repository boundary → `ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md` | [x] |
| 27/09/2026 | — | N-005, N-006, N-007 charted; ui-11 added (Later) | [x] |
| 28/09/2026 | N-009 | the recorder's Wayland stages → `ADR-MS001-SCRIPTED-RECORDER-STAGED-LEARNING-PROJECT-27-09-2026.md`; N-008 charted; ui-12 and ui-13 added (Later) | [x] |

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
