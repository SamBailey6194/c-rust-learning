# References — c-rust-learning

A curated index of the repository's own documentation and of the external sources worth
consulting while working in it: every layer entry point, guide and workflow by path, the one
cross-layer pairing table, and the primary sources behind the C, Rust, kernel, Syntek OS, UI, LLM
and security work, grouped by track.

**In what order to consult them — internal docs first, then primary documentation (man pages,
the standards, the official books and manuals), then Context7, then web search — is
`.claude/CLAUDE.md` Section 3.** This index is what that rule navigates; it does not restate it.

---

## Internal — Layer entry points

| Document | Purpose |
| --- | --- |
| [`CONTEXT.md`](CONTEXT.md) | Project overview: mission, directory tree, layer map, starting points, current state |
| [`README.md`](README.md) | The public front door: what this is, the roadmap, how to build and test |
| [`code/CONTEXT.md`](code/CONTEXT.md) | Code layer: C and Rust source, the standards that govern it, the coding workflows |
| [`code/REFERENCES.md`](code/REFERENCES.md) | Code layer index: guides, source areas, workflows, language and tool references |
| [`how-to/CONTEXT.md`](how-to/CONTEXT.md) | How-to layer: toolchain, machine setup, daily study routine, quality gates |
| [`how-to/REFERENCES.md`](how-to/REFERENCES.md) | How-to layer index: guides, runbooks, workflows, tool manuals |
| [`project-management/CONTEXT.md`](project-management/CONTEXT.md) | PM layer: the curriculum — roadmap, milestones, specs, decisions, records |
| [`project-management/REFERENCES.md`](project-management/REFERENCES.md) | PM layer index: guides, artefact folders, workflows, planning references |
| [`learning/CONTEXT.md`](learning/CONTEXT.md) | The `/teach` sandbox: eight lesson families (c, tooling, rust, kernel, os, ui, llm, sec) across the roadmap's six tracks, one folder per topic (syllabus, mission, sources, recall log), spaced review |
| [`research/CONTEXT.md`](research/CONTEXT.md) | `/research` notes: one question each, cited to primary sources |
| [`handoffs/CONTEXT.md`](handoffs/CONTEXT.md) | `/handoff` documents: continuity between context windows |

## Internal — Manual & registers

| Document | Purpose |
| --- | --- |
| [`.claude/CLAUDE.md`](.claude/CLAUDE.md) | The manual: tutor posture, read order, lookup order, non-negotiables, registers, explain-first |
| [`.claude/MEMORY.md`](.claude/MEMORY.md) | Project memory: feedback, project patterns, project state — read second every session |
| [`.claude/CONTEXT.md`](.claude/CONTEXT.md) | Orientation for `.claude/` and why its settings look the way they do |
| [`.claude/settings.json`](.claude/settings.json) | Shared Claude Code settings: read-only allowlist, `.env` denies, hooks, auto-compaction off |
| [`.claude/hooks/CONTEXT.md`](.claude/hooks/CONTEXT.md) | The two session-continuity hooks: 50% / 75% context thresholds and the compaction block |
| [`.claude/skills/CONTEXT.md`](.claude/skills/CONTEXT.md) | The skill roster — `teach`, `handoff`, `research`, `wait-what` — and when each loads |
| [`.claude/skills/teach/FAMILIES.md`](.claude/skills/teach/FAMILIES.md) | What to teach per family — c, rust, tooling, kernel, os, ui, llm, sec — and from which sources |
| [`GAPS.md`](GAPS.md) | Register: active toolchain gaps, knowledge gaps, blocked milestones, open questions |
| [`DEFERRED.md`](DEFERRED.md) | Register: topics parked for a later milestone or phase |
| [`AGENTS.md`](AGENTS.md) | Entry shim for coding agents other than Claude Code |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) · [`SECURITY.md`](SECURITY.md) | How outside help is handled; how to report a security problem privately |

---

## Internal — Standards & guides

### Code guides (`code/docs/`)

| Guide | Purpose |
| --- | --- |
| [`code/docs/CODING-PRINCIPLES.md`](code/docs/CODING-PRINCIPLES.md) | Principles for all code here — C exercises, Rust crates and, from P4, kernel modules |
| [`code/docs/C-CODING-PRINCIPLES.md`](code/docs/C-CODING-PRINCIPLES.md) | C in the Linux kernel coding style: layout, headers and linkage, error handling |
| [`code/docs/RUST-CODING-PRINCIPLES.md`](code/docs/RUST-CODING-PRINCIPLES.md) | Rust on edition 2024: rustfmt, clippy, error handling, the workspace lint set |
| [`code/docs/BUILD.md`](code/docs/BUILD.md) | **Owner** of the C flag set and make targets, and the Cargo workspace commands |
| [`code/docs/TESTING.md`](code/docs/TESTING.md) | The `check.h` harness, `cargo test`, test-first discipline |
| [`code/docs/MEMORY-SAFETY.md`](code/docs/MEMORY-SAFETY.md) | ASan + UBSan and valgrind: what each catches, why they never share a binary, reading reports |
| [`code/docs/DEBUGGING.md`](code/docs/DEBUGGING.md) | gdb on exercises, core dumps, and later kernels under QEMU |
| [`code/docs/FFI.md`](code/docs/FFI.md) | C and Rust across an `extern "C"` boundary; `unsafe` and `// SAFETY:` comments |
| [`code/docs/DOCUMENTATION-PAIRING.md`](code/docs/DOCUMENTATION-PAIRING.md) | **Owner** of the `CONTEXT.md` / `CLAUDE.md` split, shapes, banned headings and exemptions |
| [`code/docs/DOCUMENTATION-LENGTH.md`](code/docs/DOCUMENTATION-LENGTH.md) | **Owner** of the 300-line cap on instructional Markdown and the thin-index split |

### How-to guides (`how-to/docs/`) and runbooks (`how-to/src/`)

| Guide | Purpose |
| --- | --- |
| [`how-to/docs/TOOLCHAIN.md`](how-to/docs/TOOLCHAIN.md) | **Owner** of the host toolchain versions — installed, missing, and why each tool is here |
| [`how-to/docs/CLI-TOOLING.md`](how-to/docs/CLI-TOOLING.md) | The commands used day to day and the scripts that wrap them |
| [`how-to/docs/GUIDE-CRAFT.md`](how-to/docs/GUIDE-CRAFT.md) | How a guide or runbook in this repository is written and proved |
| [`how-to/src/MACHINE-SETUP.md`](how-to/src/MACHINE-SETUP.md) | Setting up a machine to work in this repository |
| [`how-to/src/HOST-MAINTENANCE.md`](how-to/src/HOST-MAINTENANCE.md) | Keeping the Ubuntu host healthy, via the sibling repository [reboot-purge](https://github.com/SamBailey6194/reboot-purge) |

### Project-management guides (`project-management/docs/`)

| Guide | Purpose |
| --- | --- |
| [`project-management/docs/PLANNING-GUIDE.md`](project-management/docs/PLANNING-GUIDE.md) | Index over `planning/`: how milestones and study sprints are planned |
| [`project-management/docs/planning/CADENCE.md`](project-management/docs/planning/CADENCE.md) | The one-milestone-at-a-time learning cadence and sprint capacity |
| [`project-management/docs/planning/MILESTONES.md`](project-management/docs/planning/MILESTONES.md) | **Owner** of the milestone status vocabulary and mastery criteria |
| [`project-management/docs/planning/SPRINTS.md`](project-management/docs/planning/SPRINTS.md) | Study sprints: goal, capacity, retrospective |
| [`project-management/docs/GIT-GUIDE.md`](project-management/docs/GIT-GUIDE.md) | Index over `git/`: branches, commits, pull requests and checks |
| [`project-management/docs/git/BRANCHES.md`](project-management/docs/git/BRANCHES.md) | **Owner** of branch naming (`ms###/<short-kebab>`, `docs/`, `ci/`, `pm/`) |
| [`project-management/docs/git/COMMITS.md`](project-management/docs/git/COMMITS.md) | **Owner** of Conventional Commit scopes and staging by explicit path |
| [`project-management/docs/git/PR-AND-CHECKS.md`](project-management/docs/git/PR-AND-CHECKS.md) | Pull requests, the CI checks and merging to `main` |
| [`project-management/docs/VERIFICATION-GUIDE.md`](project-management/docs/VERIFICATION-GUIDE.md) | How mastery is proved and recorded |
| [`project-management/docs/SAFETY-GUIDE.md`](project-management/docs/SAFETY-GUIDE.md) | Undefined behaviour and memory-bug classes, Rust `unsafe`, kernels in QEMU only |

### Key artefacts

| Artefact | Purpose |
| --- | --- |
| [`project-management/src/01-ROADMAP/ROADMAP.md`](project-management/src/01-ROADMAP/ROADMAP.md) | **Owner** of the phases of every track (P1–P6, U1–U3, L1–L6, S1–S3), their exit gates, the critical path, and the efficiency and security lenses |
| [`project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md`](project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md) | The current milestone |
| [`project-management/src/08-DECISIONS/`](project-management/src/08-DECISIONS/) | ADRs — five seeded at MS001 (C17, kernel coding style, GNU make, `check.h`, Rust edition 2024 and toolchain pin) and the planning and networking-and-licensing decisions below |
| [`project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md`](project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md) | What separates the seven Syntek OS profiles, on one set of axes |

**Maps** (`project-management/src/01-ROADMAP/`, Charting drafts): `MAP-KERNEL.md` (P4–P5) ·
`MAP-SYNTEK-OS.md` (P6) · `MAP-UI.md` (U1–U3) · `MAP-LLM.md` (L1–L6) · `MAP-SECURITY.md` (S1–S3).

**Syntek OS profiles** (`project-management/src/07-OS-PROFILES/`): `PROFILE-000-TEMPLATE.md` ·
`PROFILE-BEGINNER.md` · `PROFILE-INTERMEDIATE.md` · `PROFILE-EXPERT.md` · `PROFILE-SERVER.md` ·
`PROFILE-NAS.md` · `PROFILE-HOMELAB.md` · `PROFILE-ROUTER.md`.

**Planning decisions of 27/09/2026** (`project-management/src/08-DECISIONS/`, one decision each):

| ADR | Subject |
| --- | --- |
| `ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md` | The widened mission and the kernel, Syntek OS, UI and LLM tracks |
| `ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md` | A downstream of upstream Linux, not a fork and not from scratch |
| `ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md` | Syntek OS built from scratch, derived from no other distribution |
| `ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md` | Seven profiles on one base, build system and package set |
| `ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md` | Existing desktop environments per profile |
| `ADR-MS001-SYNTEK-OS-TOOLS-RUST-TUI-FIRST-27-09-2026.md` | Custom tools in Rust, TUI first |
| `ADR-MS001-LLM-SKILLS-NOT-AGENTS-27-09-2026.md` | Markdown skills with progressive disclosure, not agent loops |
| `ADR-MS001-LLM-EFFICIENCY-AND-SECURITY-FIRST-27-09-2026.md` | Budgets and a threat model on every LLM milestone |
| `ADR-MS001-LLM-BASE-MODEL-PLUS-ADAPTERS-27-09-2026.md` | One base model with per-domain adapters |
| `ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md` | Apache-2.0-only crates by documented per-crate exception |
| `ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md` | gtk4-rs for the GUI lessons |
| `ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md` | The security track and its authorised, isolated-lab rules |

**Networking and licensing round of 27/09/2026** (`project-management/src/08-DECISIONS/`, one decision each):

| ADR | Subject |
| --- | --- |
| `ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md` | Network labs stay isolated; a lab-proven config graduates to named devices Sam owns |
| `ADR-MS001-PRIVATE-CA-OFFLINE-ROOT-AND-ACME-27-09-2026.md` | Proposed: a private CA — an offline root and constrained intermediate by hand, an ACME issuer for short-lived leaves |

**Lesson tracks** (`learning/`): `c`, `tooling`, `rust`, `kernel`, `os`, `ui`, `llm` and `sec` —
every topic folder is listed in `learning/CONTEXT.md` → _Tracks and topic folders_.

---

## Internal — Workflows

Each workflow is a numbered folder holding `CONTEXT.md`, `CLAUDE.md`, `STEPS.md` and
`CHECKLIST.md`; the links below go to its `CONTEXT.md`. In `code/` and `how-to/` the numbers are
stable identifiers — appended, never renumbered; in `project-management/` they are the running
order.

### Code workflows (`code/workflows/`)

| Family | Workflow |
| --- | --- |
| Index | [`code/workflows/CONTEXT.md`](code/workflows/CONTEXT.md) |
| Build (01–04) | [01 — C exercise](code/workflows/01-c-exercise/CONTEXT.md) · [02 — TDD cycle](code/workflows/02-tdd-cycle/CONTEXT.md) · [03 — Rust exercise](code/workflows/03-rust-exercise/CONTEXT.md) · [04 — FFI bridge](code/workflows/04-ffi-bridge/CONTEXT.md) |
| Verify (05–06) | [05 — Review](code/workflows/05-review/CONTEXT.md) · [06 — Memory check](code/workflows/06-memory-check/CONTEXT.md) |
| Diagnose & improve (07–08) | [07 — Debug](code/workflows/07-debug/CONTEXT.md) · [08 — Refactor](code/workflows/08-refactor/CONTEXT.md) |
| Planned — added at P4 | 09 — Kernel module |
| Planned — added at L1, L2 and U1 | 10 — Python exercise (L1) · 11 — Profile and optimise (L2) · 12 — CUDA kernel (L2) · 13 — TUI app (U1) |

### How-to workflows (`how-to/workflows/`)

| Family | Workflow |
| --- | --- |
| Index | [`how-to/workflows/CONTEXT.md`](how-to/workflows/CONTEXT.md) |
| Set up (01) | [01 — Toolchain setup](how-to/workflows/01-toolchain-setup/CONTEXT.md) |
| Run (02–03) | [02 — Daily study session](how-to/workflows/02-daily-study-session/CONTEXT.md) · [03 — Quality gates](how-to/workflows/03-quality-gates/CONTEXT.md) (**owner** of the gate list) |
| Maintain (04) | [04 — Toolchain updates](how-to/workflows/04-toolchain-updates/CONTEXT.md) |
| Diagnose (05) | [05 — Debugging environment](how-to/workflows/05-debugging-environment/CONTEXT.md) |
| Author (06) | [06 — Write a guide](how-to/workflows/06-write-a-guide/CONTEXT.md) |
| Planned — added at P4 | 07 — Kernel source setup · 08 — Build and boot kernel |
| Planned — added at L1–L2, P6 and L5 | 09 — GPU toolchain setup (L1–L2) · 10 — LFS build VM (P6) · 11 — Isolated network lab (P6) · 12 — Local model runtime (L5) |

### Project-management workflows (`project-management/workflows/`)

| Family | Workflow |
| --- | --- |
| Index | [`project-management/workflows/CONTEXT.md`](project-management/workflows/CONTEXT.md) |
| Plan (01–03) | [01 — Roadmap map](project-management/workflows/01-roadmap-map/CONTEXT.md) · [02 — Milestone creation](project-management/workflows/02-milestone-creation/CONTEXT.md) · [03 — Sprint planning](project-management/workflows/03-sprint-planning/CONTEXT.md) |
| Specify (04–07) | [04 — Exercise design](project-management/workflows/04-exercise-design/CONTEXT.md) · [05 — Project spec](project-management/workflows/05-project-spec/CONTEXT.md) · [06 — Kernel spec](project-management/workflows/06-kernel-spec/CONTEXT.md) · [07 — OS profile spec](project-management/workflows/07-os-profile-spec/CONTEXT.md) |
| Decide & plan (08–09) | [08 — Decisions](project-management/workflows/08-decisions/CONTEXT.md) · [09 — Milestone plans](project-management/workflows/09-milestone-plans/CONTEXT.md) |
| Build (10) | [10 — Study and build](project-management/workflows/10-study-and-build/CONTEXT.md) |
| Record (11–13) | [11 — Verification](project-management/workflows/11-verification/CONTEXT.md) · [12 — Review and reflect](project-management/workflows/12-review-and-reflect/CONTEXT.md) · [13 — PR and merge](project-management/workflows/13-pr-and-merge/CONTEXT.md) |

---

### Cross-layer pairing — the canonical map

**project-management/ plans the curriculum; learning/ drills it; code/ is where practice becomes
working, tested code.** This table is the single source of truth for how the layers' workflows
interlock — no layer's `CONTEXT.md` restates it; they cite it.

| PM workflow | Writes to | Pairs with |
| --- | --- | --- |
| `01-roadmap-map` | `project-management/src/01-ROADMAP/` | — |
| `02-milestone-creation` | `project-management/src/02-MILESTONES/` | — |
| `03-sprint-planning` | `project-management/src/03-STUDY-SPRINTS/` | — |
| `04-exercise-design` | `project-management/src/04-EXERCISES/` | `code/workflows/01-c-exercise/`, `code/workflows/03-rust-exercise/` |
| `05-project-spec` | `project-management/src/05-PROJECTS/` | — |
| `06-kernel-spec` | `project-management/src/06-KERNEL/` | The P4 how-to kernel workflows and `code/workflows/09-kernel-module/` (all planned — added at P4) |
| `07-os-profile-spec` | `project-management/src/07-OS-PROFILES/` | `research/` |
| `08-decisions` | `project-management/src/08-DECISIONS/` | `research/` |
| `09-milestone-plans` | `project-management/src/09-MILESTONE-PLANS/` | — |
| `10-study-and-build` | `learning/` + `code/src/` | `.claude/skills/teach/SKILL.md`, `code/workflows/` 01–04 |
| `11-verification` | `project-management/src/10-PROGRESS/` | `code/workflows/06-memory-check/`, `how-to/workflows/03-quality-gates/` |
| `12-review-and-reflect` | `project-management/src/11-REVIEWS/`, `project-management/src/12-FINDINGS/` | `code/workflows/05-review/` |
| `13-pr-and-merge` | git / GitHub | `project-management/docs/GIT-GUIDE.md` |
| _(no PM workflow)_ — `code/workflows/07-debug/` | `project-management/src/13-BUGS/` | — |

**The numbering diverges after 09.** PM workflows 01–09 write to the `src/` folder of the same
number; from 10 onwards they do not (workflow 11 writes `src/10-PROGRESS/`, and so on), and
`src/13-BUGS/` is written by `code/workflows/07-debug/` rather than a PM workflow. The reason is
recorded once, in `project-management/REFERENCES.md`.

---

## External — Language & standards

- **ISO/IEC JTC1/SC22/WG14 — the C committee** — <https://www.open-std.org/jtc1/sc22/wg14/> —
  where the standard's drafts, defect reports and proposals are published.
- **N2310, first C2x working draft** — <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2310.pdf> —
  the C17 text (ISO/IEC 9899:2018) with the first C2x changes marked, so the C17 wording can be read
  directly: the freely readable text closest to C17, and the one to cite clauses from when a lesson
  rests on the standard (as `code/REFERENCES.md` does). N2176, the C17 ballot draft, is served
  password-protected and is not a readable source.
- **N1570, C11 committee draft** — <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf> —
  C11, which C17 corrected without adding features. Its clause numbers match N2310's for the core
  language, so a citation from either is acceptable where the number is the same.
- **N3096, C23 working draft** — <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3096.pdf> —
  for the C23 revisit the C17 ADR anticipates.
- **cppreference — C reference** — <https://en.cppreference.com/w/c> — per-header, per-function
  reference that marks which standard revision introduced each feature.
- **GCC 13.3 manual** — <https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/> — the manual for the
  exact compiler on the host; the latest is at <https://gcc.gnu.org/onlinedocs/>.
- **GCC Warning Options** — <https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html> — what each
  flag in the `code/docs/BUILD.md` warning set enables.
- **GCC C Dialect Options** — <https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html> —
  `-std=c17` and related dialect switches.
- **GNU make** — `man make` (installed) — the build tool for every C exercise; the full manual is
  published by the GNU project.
- **Linux kernel coding style** — <https://docs.kernel.org/process/coding-style.html> — the C
  style this repository follows from the first exercise.
- **The Linux man-pages project** — <https://man7.org/linux/man-pages/> — online sections 2 and 3
  for the syscalls and library functions of P2; the installed `man` pages come first.
- **POSIX.1-2024 (The Open Group Base Specifications, Issue 8)** —
  <https://pubs.opengroup.org/onlinepubs/9799919799/> — the portable interfaces behind P2's
  processes, signals, threads and sockets.
- **The Rust Programming Language** — <https://doc.rust-lang.org/book/> — the P3 spine:
  ownership, traits, error handling, concurrency.
- **The Rust Reference** — <https://doc.rust-lang.org/reference/> — the precise rules when the
  book simplifies.
- **The Rustonomicon** — <https://doc.rust-lang.org/nomicon/> — `unsafe` Rust and FFI with C.
- **The Rust Edition Guide** — <https://doc.rust-lang.org/edition-guide/> — what edition 2024
  changes.
- **The Cargo Book** — <https://doc.rust-lang.org/cargo/> — workspaces, `rust-version`, lints
  tables, `Cargo.lock`.

## External — Testing & debugging

- **GDB manual** — <https://sourceware.org/gdb/current/onlinedocs/gdb/> — breakpoints, stepping,
  core files, and remote debugging of a kernel under QEMU.
- **Valgrind Memcheck manual** — <https://valgrind.org/docs/manual/mc-manual.html> — reading
  memcheck's leak and invalid-access reports.
- **GCC Instrumentation Options** —
  <https://gcc.gnu.org/onlinedocs/gcc/Instrumentation-Options.html> — `-fsanitize=address,undefined`
  and friends.
- **GCC Static Analyzer Options** —
  <https://gcc.gnu.org/onlinedocs/gcc/Static-Analyzer-Options.html> — what `-fanalyzer` checks.
- **AddressSanitizer** — <https://github.com/google/sanitizers/wiki/AddressSanitizer> — the
  sanitiser's own description of the bug classes it detects.
- **The Rust book — Writing automated tests** —
  <https://doc.rust-lang.org/book/ch11-00-testing.html> — unit and integration tests in Cargo.
- **Clippy lints** — <https://rust-lang.github.io/rust-clippy/> — the full lint list, searchable by
  name, behind `-D warnings`.
- **cargo-deny** — <https://embarkstudios.github.io/cargo-deny/> — the licence and source checks
  in `code/src/rust/deny.toml`.
- **ShellCheck** — <https://www.shellcheck.net/> — the explanation page for every SC code the
  shell gate reports.
- **markdownlint-cli2** — <https://github.com/DavidAnson/markdownlint-cli2> — the Markdown linter
  configured by `.markdownlint-cli2.jsonc`.

## External — Kernel

- **The Linux kernel documentation** — <https://docs.kernel.org/> — the primary source for all P4
  and P5 work, with the kernel tree's own `Documentation/`.
- **Minimal requirements to compile the kernel** — <https://docs.kernel.org/process/changes.html>
  — the tool versions a kernel build needs (see `GAPS.md`).
- **Kbuild** — <https://docs.kernel.org/kbuild/index.html> — Kconfig and the kernel build system.
- **Building external modules** — <https://docs.kernel.org/kbuild/modules.html> — out-of-tree
  modules, built here and loaded only inside QEMU.
- **Debugging kernel and modules via gdb** —
  <https://docs.kernel.org/process/debugging/gdb-kernel-debugging.html> — gdb against a kernel
  running in QEMU.
- **Rust for Linux — quick start** — <https://docs.kernel.org/rust/quick-start.html> — the
  toolchain the Rust-in-kernel track needs (see `GAPS.md`).
- **Submitting patches** — <https://docs.kernel.org/process/submitting-patches.html> — patch
  format and the Developer Certificate of Origin, for P5's patch series.
- **kernel.org releases** — <https://www.kernel.org/category/releases.html> — mainline, stable and
  longterm, for choosing a kernel base.
- **Kconfig language** — <https://docs.kernel.org/kbuild/kconfig-language.html> — the language the
  per-profile configuration fragments are written against.
- **Stable kernel rules** — <https://docs.kernel.org/process/stable-kernel-rules.html> — how
  patches reach the -stable releases the downstream tree tracks.
- **Reproducible kernel builds** — <https://docs.kernel.org/kbuild/reproducible-builds.html> — the
  timestamp, user and host variables a reproducible kernel build pins.
- **The kernel's CVE process** — <https://docs.kernel.org/process/cve.html> — how the kernel CNA
  assigns CVEs; its records are in `vulns.git`
  (`git ls-remote https://git.kernel.org/pub/scm/linux/security/vulns.git`, checked 27/09/2026).
- **KSPP Recommended Settings** — <https://kspp.github.io/Recommended_Settings> — the hardening
  baseline, measured with kernel-hardening-checker
  (<https://github.com/a13xp0p0v/kernel-hardening-checker>).
- **b4** — <https://b4.docs.kernel.org/> — preparing and sending patch series upstream.
- **Tracing and locking** — ftrace (<https://docs.kernel.org/trace/ftrace.html>) and lockdep
  (<https://docs.kernel.org/locking/lockdep-design.html>), for syscalls and locking bugs in QEMU.
- **Rust in the kernel** — <https://docs.kernel.org/rust/index.html> — the in-tree Rust
  documentation.
- **QEMU documentation** — <https://www.qemu.org/docs/master/> — `qemu-system-x86_64`
  invocation (<https://www.qemu.org/docs/master/system/invocation.html>) and its gdb stub
  (<https://www.qemu.org/docs/master/system/gdb.html>).
- **BusyBox** — <https://busybox.net/> — the minimal userland for the first initramfs.

## External — Syntek OS

- **Linux From Scratch 13.1-systemd** — <https://www.linuxfromscratch.org/lfs/view/stable-systemd/>
  (published 01/09/2026) — the book the learning build follows; Beyond LFS 13.1, systemd edition,
  at <https://www.linuxfromscratch.org/blfs/view/stable-systemd/> (03/09/2026). The System V book
  stays at LFS 12.4 (<https://www.linuxfromscratch.org/lfs/view/stable/>) and is no longer updated
  (<https://www.linuxfromscratch.org/news.html>): a historical reference only.
- **Filesystem Hierarchy Standard 3.0** — <https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html>.
- **Package managers studied** — pacman (<https://man.archlinux.org/man/pacman.8>), apk
  (<https://wiki.alpinelinux.org/wiki/Alpine_Package_Keeper>) and xbps
  (<https://docs.voidlinux.org/xbps/index.html>).
- **Reproducible builds** — <https://reproducible-builds.org/>, its `SOURCE_DATE_EPOCH`
  specification (<https://reproducible-builds.org/specs/source-date-epoch/>) and diffoscope
  (<https://diffoscope.org/>).
- **Signing and updates** — the TUF specification
  (<https://theupdateframework.github.io/specification/latest/>) and minisign
  (<https://jedisct1.github.io/minisign/>).
- **Init and boot** — systemd (<https://systemd.io/>, manual pages at
  <https://www.freedesktop.org/software/systemd/man/latest/>, including systemd-boot), runit
  (<https://smarden.org/runit/>) and s6 (<https://skarnet.org/software/s6/>).
- **Networking and storage** — nftables (<https://wiki.nftables.org/wiki-nftables/index.php/Main_Page>),
  WireGuard (<https://www.wireguard.com/>), Samba (<https://www.samba.org/samba/docs/>) and OpenZFS
  (<https://openzfs.github.io/openzfs-docs/>; see `GAPS.md` for its licence).
- **QEMU disk images** — <https://www.qemu.org/docs/master/system/images.html> — the images every
  OS lesson runs on.
- **Build systems as study references** — the Buildroot manual
  (<https://buildroot.org/downloads/manual/manual.html>) and the Yocto Project documentation
  (<https://docs.yoctoproject.org/>). Syntek OS is built from scratch, so these are read for ideas,
  not adopted.

## External — UI

- **ratatui** — <https://ratatui.rs/> (API: <https://docs.rs/ratatui/latest/ratatui/>) and
  **crossterm** — <https://docs.rs/crossterm/latest/crossterm/> — the TUI stack.
- **tokio** — <https://tokio.rs/tokio/tutorial> — async Rust, and background work beside a render
  loop.
- **Yazi** — <https://github.com/sxyazi/yazi> — the terminal file manager whose architecture U2
  studies.
- **gtk4-rs** — <https://gtk-rs.org/gtk4-rs/stable/latest/book/> — the GUI toolkit of the lessons.
- **zbus** — <https://docs.rs/zbus/latest/zbus/> and **polkit** —
  <https://www.freedesktop.org/software/polkit/docs/latest/> — privilege separation for system
  tools.
- **Wayland** — <https://wayland.freedesktop.org/docs/html/> and The Wayland Book
  (<https://wayland-book.com/>).
- **Slint** — <https://slint.dev/> — the toolkit of the Syntek OS GUI products; studied here only,
  and built in the Syntek OS GUI-tools repository.

## External — LLM

- **PyTorch 2.14** — <https://docs.pytorch.org/docs/2.14/> — including the serialization notes
  (<https://docs.pytorch.org/docs/2.14/notes/serialization.html>) and automatic mixed precision
  (<https://docs.pytorch.org/docs/2.14/amp.html>).
- **NVIDIA** — the CUDA programming guide (<https://docs.nvidia.com/cuda/cuda-programming-guide/>),
  the CUDA installation guide for Linux (<https://docs.nvidia.com/cuda/cuda-installation-guide-linux/>)
  and the Turing architecture whitepaper
  (<https://images.nvidia.com/aem-dam/en-zz/Solutions/design-visualization/technologies/turing-architecture/NVIDIA-Turing-Architecture-Whitepaper.pdf>).
- **Reference implementations** — llm.c, pinned at commit f1e2ace
  (<https://github.com/karpathy/llm.c/tree/f1e2ace651495b74ae22d45d1723443fd00ecd3a>); nanochat
  (<https://github.com/karpathy/nanochat>), its maintained successor; nanoGPT
  (<https://github.com/karpathy/nanoGPT>), deprecated, for reading only; micrograd
  (<https://github.com/karpathy/micrograd>). All MIT-licensed.
- **Formats and runtimes** — safetensors (<https://github.com/safetensors/safetensors>, format docs
  <https://huggingface.co/docs/safetensors/>); Hugging Face tokenizers
  (<https://huggingface.co/docs/tokenizers/>); candle (<https://github.com/huggingface/candle>);
  llama.cpp (<https://github.com/ggml-org/llama.cpp>) and the GGUF specification
  (<https://github.com/ggml-org/ggml/blob/master/docs/gguf.md>); vLLM (<https://docs.vllm.ai/>);
  ollama (<https://github.com/ollama/ollama>).
- **Data** — The Stack v2 dataset card and its terms
  (<https://huggingface.co/datasets/bigcode/the-stack-v2>), and The Stack v3 dataset card (ODC-By)
  (<https://huggingface.co/datasets/HuggingFaceCode/stack-v3-train>); `llm-10` compares the two.
- **LLM security** — the OWASP Top 10 for LLM Applications 2025 (<https://genai.owasp.org/llm-top-10/>),
  whose IDs are this repository's citation key; its 2026 edition
  (<https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/>, published 03/08/2026), which
  re-ranks them — mapped in `learning/llm-18-secure-llm-systems/` lesson 01; the OWASP Top 10 for
  Agentic Applications for 2026
  (<https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/>, published
  09/12/2025); the kernel's Landlock (<https://docs.kernel.org/userspace-api/landlock.html>) and
  seccomp (<https://docs.kernel.org/userspace-api/seccomp_filter.html>) documentation.
- **Papers, by arXiv ID** (abstract pages at `https://arxiv.org/abs/<id>`, each checked
  27/09/2026) — Attention, 1706.03762; Kaplan scaling laws, 2001.08361; Chinchilla, 2203.15556;
  FlashAttention, 2205.14135; multi-query attention, 1911.02150; grouped-query attention,
  2305.13245; DeepSeek-V2 (latent attention), 2405.04434; sparsely-gated mixture of experts,
  1701.06538; Switch Transformers, 2101.03961; LoRA, 2106.09685; QLoRA, 2305.14314;
  PagedAttention, 2309.06180; speculative decoding, 2211.17192 and 2302.01318; fill-in-the-middle,
  2207.14255; Codex and HumanEval, 2107.03374; retrieval-augmented generation, 2005.11401;
  InstructGPT, 2203.02155; DPO, 2305.18290; StarCoder 2 and The Stack v2, 2402.19173; Adam,
  1412.6980; AdamW, 1711.05101.

## External — Security

- **The law** — the UK Computer Misuse Act 1990
  (<https://www.legislation.gov.uk/ukpga/1990/18/contents>).
- **Method** — NIST SP 800-115, security testing (<https://csrc.nist.gov/pubs/sp/800/115/final>);
  NIST SP 800-61 Rev. 3, incident response (<https://csrc.nist.gov/pubs/sp/800/61/r3/final>);
  CVSS v4.0 (<https://www.first.org/cvss/v4-0/specification-document>); RFC 9116, security.txt
  (<https://www.rfc-editor.org/rfc/rfc9116>).
- **Weakness and attack catalogues** — MITRE CWE (<https://cwe.mitre.org/>) and ATT&CK
  (<https://attack.mitre.org/>, Linux matrix at <https://attack.mitre.org/matrices/enterprise/linux/>).
- **Web** — the OWASP Top 10 (<https://owasp.org/www-project-top-ten/>), the Web Security Testing
  Guide (<https://owasp.org/www-project-web-security-testing-guide/>) and Juice Shop
  (<https://owasp.org/www-project-juice-shop/>).
- **Kernel hardening and integrity** — self-protection
  (<https://docs.kernel.org/security/self-protection.html>) and dm-verity
  (<https://docs.kernel.org/admin-guide/device-mapper/verity.html>).
- **Detection** — the EICAR test file (<https://www.eicar.org/download-anti-malware-testfile/>),
  ClamAV (<https://github.com/Cisco-Talos/clamav>), YARA (<https://yara.readthedocs.io/>) and AIDE
  (<https://aide.github.io/>).
- **Training platforms**, used under their own rules — OverTheWire
  (<https://overthewire.org/wargames/>), pwn.college (<https://pwn.college/>) and picoCTF
  (<https://picoctf.org/>).

## External — Process

- **Conventional Commits 1.0.0** — <https://www.conventionalcommits.org/en/v1.0.0/> — the commit
  message format (`project-management/docs/git/COMMITS.md`).
- **Semantic Versioning 2.0.0** — <https://semver.org/> — the scheme behind the `0.1.0`
  documentation version.
- **Developer Certificate of Origin** — <https://developercertificate.org/> — what an optional
  `Signed-off-by:` trailer certifies.
- **Git reference** — <https://git-scm.com/docs> — every git command's manual.
- **GitHub Actions documentation** — <https://docs.github.com/en/actions> — the CI gates in
  `.github/workflows/`.
- **GitHub private vulnerability reporting** —
  <https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability>
  — the channel `SECURITY.md` points to.
- **SPDX License List** — <https://spdx.org/licenses/> — the licence identifiers used in
  `Cargo.toml` and `deny.toml`.
- **FSF — Various licenses and comments about them** —
  <https://www.gnu.org/licenses/license-list.html#apache2> — the FSF's statement that Apache-2.0 is
  not compatible with GPL version 2, which is why `code/src/rust/deny.toml` leaves it off the allow
  list; the same page lists the Boost Software License (`#boost`) as GPL-compatible and the CDDL
  (`#CDDL`) as incompatible (read through the Internet Archive's copy on 27/09/2026, as gnu.org did
  not answer).
- **REUSE** — <https://reuse.software/> — licence and copyright information per file, alongside the
  SPDX identifiers.
- **EditorConfig** — <https://editorconfig.org/> — the format of `.editorconfig`.
- **Claude Code — hooks reference** — <https://code.claude.com/docs/en/hooks> — the event
  semantics behind `.claude/hooks/`.
- **Claude Code — settings** — <https://code.claude.com/docs/en/settings> — the keys used in
  `.claude/settings.json`.
- **Claude Code — permissions** — <https://code.claude.com/docs/en/permissions> — how allow rules
  match a command, and the built-in read-only set the allowlist relies on.
