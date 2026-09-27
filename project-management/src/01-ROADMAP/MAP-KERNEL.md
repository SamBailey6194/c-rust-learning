# MAP-KERNEL — Kernel internals and the downstream kernel (P4–P5)

**Charted**: 27/09/2026 | **Charted by**: Sam Bailey | **Workflow**: `01-roadmap-map`
**Phase**: P4–P5 — `project-management/src/01-ROADMAP/ROADMAP.md`
**Status**: Charting
**Frontier open**: 3 | **Blocking open**: 1

> A `Charting` draft: the destination and the open decisions are drawn from Sam's planning
> conversation of 27/09/2026 and its ADRs; nodes are resolved in later sessions, one at a time, each
> graduating to the artefact it becomes. **The map is an index, not a vault.**

---

## Destination

P4 exit gate met (`ROADMAP.md` → P4): a custom-configured kernel boots in QEMU to a busybox shell and
a module loads and unloads in the guest. Then P5 (`ROADMAP.md` → P5): a downstream of upstream Linux —
kernel.org's stable and longterm lines tracked, a small patch series rebased per release, a Kconfig
fragment per Syntek OS profile — with the base plus first-edition (server and homelab) fragments
building and booting in QEMU, reproducibly from a pinned tag.

---

## Notes

| Field | Value |
| --- | --- |
| Phase exit gate | P4–P5 — `project-management/src/01-ROADMAP/ROADMAP.md` → P4, P5 |
| Already known | _Not yet asked — the first charting session with Sam fills this._ |
| Expected to be hard | _Not yet asked — the first charting session with Sam fills this._ |
| Skills to load | from `.claude/skills/`: teach, research, handoff, wait-what |
| Standing preferences | downstream of upstream, not a fork or from scratch; QEMU only; longterm for the server family, stable for desktops (per profile) |
| Umbrella ADRs | `project-management/src/08-DECISIONS/ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md` · `ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md` |
| Primary resources | the P4 and P5 lists in `ROADMAP.md`; docs.kernel.org; kernel.org releases |
| Register entries triaged | 0 closes, 4 blocks, 0 unrelated — from `GAPS.md` |

**Register triage is a claim, not a close.** The four `GAPS.md` blockers this track meets are
"Kernel build dependencies not installed" (flex, bison, libelf-dev, dwarves, and the GCC-plugin choice
for `CONFIG_KSTACK_ERASE` at `kernel-04` lesson 03), "pahole minimum for P4
is unclear", "Rust-for-Linux needs clang/LLVM and bindgen" and "git send-email and b4 not installed"
(`kernel-07-upstreaming` lesson 04 only). The first three become frontier nodes' blockers below; the
last is a lesson-level Blocked mark. Nothing in this map edits either register.

---

## Resolved decisions

Each row links to the artefact it became. **An answer that lives only here has not graduated.**

| Node | Decision | Type | Settled | Became |
| --- | --- | --- | --- | --- |
| N-001 | Kernel is a downstream of upstream Linux, not a fork or from scratch | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md` |

---

## Slices

The milestone cut list — **each slice becomes one milestone**. Slices are filled at CUT, after the
blocking nodes resolve; the candidates are in `ROADMAP.md` → P4 and P5.

| Slice | Milestone | Title | Nodes | Mastery (what must be true) | Flags |
| --- | --- | --- | --- | --- | --- |
| S-01 | — | cut after the blocking nodes resolve — candidates in `project-management/src/01-ROADMAP/ROADMAP.md` → P4/P5 | — | — | — |

**Node state** is `resolved`, `open` or `BLOCKING`. A slice is cuttable only when every node it names
is resolved.

---

## Frontier

Open decisions in dependency order. **Blocked by** names other nodes or a register entry.

| Node | Decision | Type | Blocked by | Blocking a milestone? |
| --- | --- | --- | --- | --- |
| N-002 | Which stable or longterm line each profile follows | research | `GAPS.md` → nothing (host-independent); feeds `research/LTS-VS-STABLE-PER-PROFILE.md` (planned) | no |
| N-003 | The pahole minimum for the P4 build, and BTF on or off | research | `GAPS.md` → "pahole minimum for P4 is unclear" | yes |
| N-004 | Whether Rust-for-Linux is in scope for this machine | spike | `GAPS.md` → "Rust-for-Linux needs clang/LLVM and bindgen" | no |

**Types:** `research` graduates to a note in `research/`; `explain-first` to an ADR; `spike` to a
throwaway experiment in `learning/`; `build` is a slice's own milestone work.

**Blocking a milestone?** `yes` means no milestone in this track is cut until the node is settled.
N-003 blocks the first P4 build, because the build's dependencies must resolve first.

---

## Fog of war

In scope, but not yet sharp enough to state as a decision.

- Which trivial first patch the downstream series carries (a comment or a version string), decided at
  the first-downstream-build milestone.
- Where CI runs the per-profile build-and-boot matrix (self-hosted or hosted), decided at the kernel
  CI milestone.
- Where the work lands: lesson fragments and practice patches sit under `code/src/kernel/` (planned —
  added at P4) through `kernel-04`; the downstream kernel repository, created in
  `kernel-05-downstream-tree` lesson 02, then holds the profile fragments, the patch series and the
  kernel CI (`project-management/src/08-DECISIONS/ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md`
  → the repository boundary).

---

## Out of scope

| Ruled out | Why |
| --- | --- |
| A kernel from scratch | years of work, drivers the barrier — `ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`, Option C |
| A fork of upstream | divergence grows and stable fixes stop applying — same ADR, Option B |
| Installing a built kernel on the host | the kernel safety rule (`.claude/CLAUDE.md`); QEMU only |

---

## Session log

| Date | Node settled | Outcome | Frontier redrawn |
| --- | --- | --- | --- |
| 27/09/2026 | N-001 | downstream of upstream → `ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md` | [x] |

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
