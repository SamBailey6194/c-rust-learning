# ADR-MS001: Roadmap — kernel, Syntek OS, UI and LLM tracks beside the C and Rust foundation

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — (the roadmap is an artefact, not an ADR; the five scaffold ADRs stand) |
| **Superseded by** | — |
| **Research** | — (primary sources cited below) |
| **Enforced in** | `project-management/src/01-ROADMAP/ROADMAP.md` (phases, tracks, lenses, critical path) · `project-management/src/07-OS-PROFILES/` (renamed from `07-DISTRO-TIERS/`) · `project-management/docs/planning/MILESTONES.md` (Track values, `Budget` flag, `## Threat model`) |

---

## Context

The scaffold roadmap had six phases, P1 to P6, and a mission that ended in "a custom set of Linux
distributions at three tiers — beginner, intermediate and experienced". P5 was "Custom kernel" and
P6 "Distro tiers". This record changes the shape of that roadmap, which `ROADMAP.md` → _Changing
the roadmap_ says is hard to reverse and needs an ADR first.

What Sam asked for, in his planning conversation of 27/09/2026:

- **Q9** — learn C and Rust, then kernel development, then a kernel based on Linux, then a
  distribution with beginner, intermediate and expert editions for laptops and PCs and server, NAS,
  homelab and router editions, and eventually a language model in C, Rust and Python that works
  through Markdown skills, workflows and documentation.
- **Q10** — a clean, independent distribution, not a fork of NixOS or anything else
  (`ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md`).
- **Q11** — existing desktop environments, with custom TUI and later GUI tools that friends and
  family could help build.
- **Q6 to Q8** — a coding model that uses skills rather than agents, trained from scratch at a small
  size first, and efficient with CPU, RAM, GPU, VRAM and caches.
- The same day, Sam asked for security and penetration-testing lessons as a track of their own
  (`ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md` sets the rules that track runs under).

Facts that shape the structure, checked on 27/09/2026:

- **The kernel track never finishes.** kernel.org releases a mainline kernel every 9 to 10 weeks,
  stable updates roughly weekly, and lists six longterm lines (6.18, 6.12, 6.6, 6.1, 5.15 and 5.10)
  with projected end-of-life dates from December 2026 to December 2028 (Sources, item 1). A
  downstream kernel is maintained for as long as it is shipped.
- **The OS track is book-length before it is Syntek OS.** Linux From Scratch 13.1 was released on
  01/09/2026, and only its systemd edition is still updated; the System V edition stays at 12.4
  (Sources, item 2).
- **The LLM track has different prerequisites.** It needs Python (which Sam already knows) and this
  machine's GPU, not the kernel: `nvidia-smi` reports an NVIDIA GeForce RTX 2080 Ti with 11264 MiB,
  of which 9318 MiB was free with the desktop session running (driver 580.178.04, compute
  capability 7.5); the CPU is an Intel Core i9-9900K with 16 threads and a 16 MiB L3 cache; RAM is
  31 GiB usable (`lscpu`, `free -g`).
- **One milestone runs at a time.** `project-management/docs/planning/CADENCE.md` → _Why not two at
  once_ keeps a single milestone moving through verification and merge before the next starts.
- **Identifiers are cited by full path.** Milestone numbers, branch names and `src/` folder numbers
  are frozen (`project-management/src/CONTEXT.md` → _The numbers here are frozen_), so a scheme that
  renumbers P1 to P6 breaks every citation of them.

## Options considered

### Option A — Keep P1 to P6, rename P5 and P6, add lettered tracks that open on gates

- **Summary:** P1 to P4 keep their names; P5 becomes "Downstream kernel" and P6 "Syntek OS". New
  tracks take their own letters so nothing renumbers — U1 to U3 (TUI and GUI), L1 to L6 (the
  language model) and S1 to S3 (security). Each phase opens when its "Opens after" gates pass; at
  most one phase per track is open at once; milestones still run one at a time.
- **Pros:** Every existing ID and citation survives. Each track states its real prerequisites (L1
  needs only P1; U1 needs P2; the build-system half of P6 needs P3), so a track starts when it can
  rather than when its predecessor in a list finishes. The one-milestone cadence is unchanged.
- **Cons:** More phases and maps to keep current. Interleaving needs a rule, or the spine (C →
  kernel → OS) starves while a side track runs, or the reverse.

### Option B — Renumber everything into one linear sequence

- **Summary:** P1 to P18 in a single order.
- **Pros:** One list; the next phase is always obvious.
- **Cons:** Breaks every existing citation of P4 to P6. Forces a false order: the LLM baseline would
  wait for the downstream kernel although it needs neither C nor the kernel.

### Option C — Fold UI and the LLM into P6 as sub-topics

- **Summary:** Six phases stay; P6 grows to cover tools and the model.
- **Pros:** No new phase IDs.
- **Cons:** P6 becomes unbounded, with an exit gate nobody could state. The LLM work's prerequisites
  (Python, GPU, PyTorch) and the UI work's (P2, P3 async) disappear inside an OS phase.

### Option D — Keep this repository to C, Rust and the kernel; learn OS and LLM elsewhere now

- **Summary:** Separate learning repositories per track from today.
- **Pros:** Smaller repositories.
- **Cons:** Spaced review, the milestone cadence and the registers would be split before the
  foundations exist, and cross-track recall — part of what makes interleaving work — has nowhere to
  happen.

### Option E — Do nothing

- **Summary:** Keep the six-phase roadmap and park the new goals in `DEFERRED.md`.
- **Pros:** No work now.
- **Cons:** The roadmap no longer describes what Sam is learning towards.

## Decision

**We will take Option A.** The deciding factor is that it adds the tracks Sam asked for without
renumbering anything, while letting each track open on its own prerequisites. Option B was the
runner-up for simplicity, and lost because it breaks citations and imposes an order the
prerequisites do not need.

Three rules come with it, all owned by `ROADMAP.md`:

1. **Parallel means interleaved, not concurrent.** Several phases may be open (at most one per
   track); milestones still run one at a time through verification and merge. At each
   `03-sprint-planning` the next milestone may come from any open phase, alternating the spine
   (Foundation → Kernel → OS) with one side track (LLM, then UI, then Security), so no open track goes
   more than two milestones untouched.
2. **Two cross-cutting lenses on every milestone.** Efficiency: every LLM, kernel-config and OS
   milestone states a resource budget and measures it. Security: every milestone names its threat
   model or the non-negotiable it runs under.
3. **The repository boundary** (Sam's decision after the critique, 27/09/2026). This repository holds
   the lessons, notes and small exercises. Anything substantial that is built — the downstream kernel
   tree, the Syntek OS build system, package manager, installer and tools, the LLM data, training and
   inference code — gets its own repository when its build starts. Those repositories' names and
   licences are Sam's to choose; until he names them, every document uses the placeholder names
   listed in `.claude/skills/teach/FAMILIES.md` (Where a lesson's build lands).

This answer changes if the interleaving rule repeatedly leaves an open track untouched for more than
two milestones, or if a track's stated prerequisites prove wrong in practice (for example, L4 turns
out to need P3). Either would be argued in a new ADR that supersedes this one.

## Consequences

- **Positive:** Every existing ID survives. The LLM baseline (L1) and the security foundations (S1)
  can start early, as Sam asked. The two lenses gain a milestone-level home: the `Budget` flag and
  the `## Threat model` section in `project-management/docs/planning/MILESTONES.md`.
- **Negative:** More maps to chart and keep current, and a single track moves more slowly than it
  would alone. The interleaving rule has to be applied at every sprint planning, or it decays into
  "whatever is most fun next".
- **Follow-on:**
  - `ROADMAP.md` gains the phase table, the dependency diagram, the lenses and the critical path;
    every changed P5 and P6 name, goal, topic list and exit gate keeps its old wording in an HTML
    comment that cites this record. The old P5 candidate "Minimal init and initramfs" moves to P6.
  - The specs folder is renamed `project-management/src/07-OS-PROFILES/` (from `07-DISTRO-TIERS/`)
    and its workflow `project-management/workflows/07-os-profile-spec/` (from
    `07-distro-tier-spec/`); the folder number is unchanged.
  - Five track maps are charted as `Charting` drafts in `project-management/src/01-ROADMAP/`:
    `MAP-KERNEL.md`, `MAP-SYNTEK-OS.md`, `MAP-UI.md`, `MAP-LLM.md` and `MAP-SECURITY.md`.
  - The decisions Sam settled in the conversation are recorded one per ADR, dated 27/09/2026:
    `ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`,
    `ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md`,
    `ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`,
    `ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md`,
    `ADR-MS001-SYNTEK-OS-TOOLS-RUST-TUI-FIRST-27-09-2026.md`,
    `ADR-MS001-LLM-SKILLS-NOT-AGENTS-27-09-2026.md`,
    `ADR-MS001-LLM-EFFICIENCY-AND-SECURITY-FIRST-27-09-2026.md`,
    `ADR-MS001-LLM-BASE-MODEL-PLUS-ADAPTERS-27-09-2026.md` (Proposed),
    `ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md`,
    `ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md` and
    `ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md`.
  - To confirm when each track opens: the candidate first milestones in `ROADMAP.md` are hypotheses
    from the conversation, not commitments; `02-milestone-creation` numbers them only when a map is
    cut.

## Sources

- **kernel.org, Active kernel releases** — <https://www.kernel.org/category/releases.html> — release
  cadence (mainline every 9 to 10 weeks, stable roughly weekly) and the six longterm lines with their
  projected end-of-life dates, checked 27/09/2026
- **Linux From Scratch news** — <https://www.linuxfromscratch.org/news.html> — LFS 13.1 released
  01/09/2026; the System V edition no longer updated and held at 12.4, checked 27/09/2026
- **Host commands, 27/09/2026** — `nvidia-smi --query-gpu=name,memory.total,memory.free,driver_version,compute_cap --format=csv`,
  `lscpu`, `free -g` — the GPU, CPU and RAM figures in Context
- **`project-management/docs/planning/CADENCE.md`** — _Why not two at once_: the one-milestone rule
  this decision keeps
- **Sam's planning conversation, 27/09/2026** — Q6 to Q11 as summarised in Context, and the same-day
  request for a security track
