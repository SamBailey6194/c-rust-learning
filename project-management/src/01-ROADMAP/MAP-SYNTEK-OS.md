# MAP-SYNTEK-OS — Syntek OS, the independent distribution (P6)

**Charted**: 27/09/2026 | **Charted by**: Sam Bailey | **Workflow**: `01-roadmap-map`
**Phase**: P6 — `project-management/src/01-ROADMAP/ROADMAP.md`
**Status**: Charting
**Frontier open**: 4 | **Blocking open**: 1

> A `Charting` draft: destination and open decisions from Sam's planning conversation of 27/09/2026
> and its ADRs; nodes resolve in later sessions, one at a time. **The map is an index, not a vault.**

---

## Destination

P6 exit gate met (`ROADMAP.md` → P6): Syntek OS is an independent distribution, built from scratch
(LFS 13.1 systemd → BLFS → an automated build system of its own), with seven profiles on one base,
build system and package set. Each profile image built for a milestone boots in QEMU and meets its
profile spec in `project-management/src/07-OS-PROFILES/`; the server and homelab edition ships first.

---

## Notes

| Field | Value |
| --- | --- |
| Phase exit gate | P6 — `project-management/src/01-ROADMAP/ROADMAP.md` → P6 |
| Already known | _Not yet asked — the first charting session with Sam fills this._ (Sam's Nix experience is a standing input for declarative config and reproducible builds.) |
| Expected to be hard | _Not yet asked — the first charting session with Sam fills this._ |
| Skills to load | from `.claude/skills/`: teach, research, handoff, wait-what |
| Standing preferences | independent, from scratch; seven profiles on one base; server and homelab first; QEMU and VM disk images only until hardware is chosen per profile; a lab-proven config reaches Sam's own devices only by the graduation path (no offensive tooling on the real LAN: `MAP-SECURITY.md` → Out of scope) |
| Umbrella ADRs | `ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md` · `ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md` · `ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md` · `ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md` (all in `project-management/src/08-DECISIONS/`) |
| Primary resources | the P6 list in `ROADMAP.md`; the LFS/BLFS 13.1 systemd books; reproducible-builds.org; pacman/apk/xbps manuals |
| Register entries triaged | 2 closes, 4 blocks, 0 unrelated — from `GAPS.md` |

**Register triage is a claim, not a close.** This track retires "Distro build approach undecided"
(closed by `ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md`) and "Syntek OS profile
definitions are hypotheses" (once the matrix is checked against real builds); it is blocked by "A VM
with spare disk for the LFS build", "No hardware chosen for the Syntek OS profiles", "diffoscope not
installed" (`os-05` lesson 05) and "ZFS licence and kernel range for the NAS profile" (`os-13`).
Nothing here edits either register.

---

## Resolved decisions

| Node | Decision | Type | Settled | Became |
| --- | --- | --- | --- | --- |
| N-001 | Syntek OS is independent, built from scratch (not derived, not a fork) | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md` |
| N-002 | Seven profiles on one base, compared on eleven axes | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md` |
| N-003 | Reuse existing desktops; write none | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md` |
| N-008 | Where network config may run: isolated lab first, then a graduation path to named devices (Sam's explicit answer, 27/09/2026) | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md` |

---

## Slices

Filled at CUT, after the blocking nodes resolve; candidates in `ROADMAP.md` → P6.

| Slice | Milestone | Title | Nodes | Mastery (what must be true) | Flags |
| --- | --- | --- | --- | --- | --- |
| S-01 | — | cut after the blocking nodes resolve — candidates in `project-management/src/01-ROADMAP/ROADMAP.md` → P6 | — | — | — |

---

## Frontier

| Node | Decision | Type | Blocked by | Blocking a milestone? |
| --- | --- | --- | --- | --- |
| N-004 | Syntek OS's own init system | explain-first | `research/INIT-SYSTEM-CHOICE.md` (planned); the learning build follows LFS systemd meanwhile | no |
| N-005 | The package format and signing scheme (minisign/signify vs OpenPGP; TUF's threat model) | research | `research/PACKAGE-SIGNING-SCHEME.md` (planned) | no |
| N-006 | The eleven-axis profile definitions, cited not assumed | research | `research/SYNTEK-OS-PROFILE-DEFINITIONS.md` (planned) | no |
| N-007 | A VM with spare disk for the LFS build | spike | `GAPS.md` → "A VM with spare disk for the LFS build" | yes |

**Blocking a milestone?** N-007 blocks the first LFS milestone: without a build VM there is nowhere
to build. The others may stay open while earlier milestones run.

---

## Fog of war

- The C library and compiler for the base (glibc against musl; GCC against Clang) — a base decision
  tested against all seven profiles, sharpened when the LFS toolchain milestone approaches.
- Whether the NAS and router profiles ship the web dashboard (decided in `ui-10-web-admin-dashboard`).
- Which repositories the built artefacts live in: the build system, package manager and installer
  move to the Syntek OS build-system, package-manager and installer repositories when each build
  starts, under names and licences Sam chooses then
  (`project-management/src/08-DECISIONS/ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md`).

---

## Out of scope

| Ruled out | Why |
| --- | --- |
| Deriving from Debian, Arch or NixOS | Sam wants a clean distribution — `ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md` |
| Buildroot or Yocto as the base | embedded-focused; no binary packages on the target (Buildroot) — same ADR |
| Writing a desktop environment | reuse existing desktops — `ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md` |
| Booting an image on the host | VM disk images and QEMU only (`.claude/CLAUDE.md`) |

---

## Session log

| Date | Node settled | Outcome | Frontier redrawn |
| --- | --- | --- | --- |
| 27/09/2026 | N-001, N-002, N-003 | three ADRs in `project-management/src/08-DECISIONS/` | [x] |
| 27/09/2026 | N-008 | settled by Sam's answer in the networking round, not while charting → ADR | [x] |

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
