# References — c-rust-learning

A curated index of the repository's own documentation and of the external sources worth
consulting while working in it: every layer entry point, guide and workflow by path, the one
cross-layer pairing table, and the primary sources behind the C, Rust, kernel and distro work.

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
| [`learning/CONTEXT.md`](learning/CONTEXT.md) | The `/teach` sandbox: one folder per topic, retrieval practice, spaced review |
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
| [`how-to/src/HOST-MAINTENANCE.md`](how-to/src/HOST-MAINTENANCE.md) | Keeping the Ubuntu host healthy, via the sibling maintenance-scripts repository |

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
| [`project-management/src/01-ROADMAP/ROADMAP.md`](project-management/src/01-ROADMAP/ROADMAP.md) | **Owner** of the phases P1–P6 and their exit gates |
| [`project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md`](project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md) | The current milestone |
| [`project-management/src/08-DECISIONS/`](project-management/src/08-DECISIONS/) | ADRs — five seeded at MS001: C17, kernel coding style, GNU make, `check.h`, Rust edition 2024 and toolchain pin |
| [`project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md`](project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md) | What separates the beginner, intermediate and experienced tiers |

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

### Project-management workflows (`project-management/workflows/`)

| Family | Workflow |
| --- | --- |
| Index | [`project-management/workflows/CONTEXT.md`](project-management/workflows/CONTEXT.md) |
| Plan (01–03) | [01 — Roadmap map](project-management/workflows/01-roadmap-map/CONTEXT.md) · [02 — Milestone creation](project-management/workflows/02-milestone-creation/CONTEXT.md) · [03 — Sprint planning](project-management/workflows/03-sprint-planning/CONTEXT.md) |
| Specify (04–07) | [04 — Exercise design](project-management/workflows/04-exercise-design/CONTEXT.md) · [05 — Project spec](project-management/workflows/05-project-spec/CONTEXT.md) · [06 — Kernel spec](project-management/workflows/06-kernel-spec/CONTEXT.md) · [07 — Distro tier spec](project-management/workflows/07-distro-tier-spec/CONTEXT.md) |
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
| `07-distro-tier-spec` | `project-management/src/07-DISTRO-TIERS/` | `research/` |
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

## External — Kernel & distro

- **The Linux kernel documentation** — <https://docs.kernel.org/> — the primary source for all P4
  and P5 work.
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
- **QEMU documentation** — <https://www.qemu.org/docs/master/> — `qemu-system-x86_64`
  invocation (<https://www.qemu.org/docs/master/system/invocation.html>) and its gdb stub
  (<https://www.qemu.org/docs/master/system/gdb.html>).
- **BusyBox** — <https://busybox.net/> — the minimal userland for the first initramfs.
- **Linux From Scratch** — <https://www.linuxfromscratch.org/lfs/> — building a system from
  source, one package at a time; Beyond LFS at <https://www.linuxfromscratch.org/blfs/>.
- **Buildroot manual** — <https://buildroot.org/downloads/manual/manual.html> — a build system for
  small, reproducible images.
- **Yocto Project documentation** — <https://docs.yoctoproject.org/> — a layered build system for
  custom distributions.
- **Debootstrap** — <https://wiki.debian.org/Debootstrap> — bootstrapping a Debian-based root
  filesystem. These last four are the candidates in `GAPS.md` → _Distro build approach undecided_.

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
  list.
- **EditorConfig** — <https://editorconfig.org/> — the format of `.editorconfig`.
- **Claude Code — hooks reference** — <https://code.claude.com/docs/en/hooks> — the event
  semantics behind `.claude/hooks/`.
- **Claude Code — settings** — <https://code.claude.com/docs/en/settings> — the keys used in
  `.claude/settings.json`.
- **Claude Code — permissions** — <https://code.claude.com/docs/en/permissions> — how allow rules
  match a command, and the built-in read-only set the allowlist relies on.
