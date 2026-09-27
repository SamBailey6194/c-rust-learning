# learning/ — Concept Notes and Recall Journal

**Last Updated**: 28/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Sam's own record of what he is learning: one folder per topic holding the planned lessons, the
mission, the pinned sources, a concept note per lesson written in his own words, and a dated
journal of recall results and spaced review dates. It is a notes-and-memory layer, not a code
sandbox. Runnable code lives under `code/src/`, where CI builds and tests it, and each note links to
that code by path. The `teach` skill creates and updates every topic folder; this layer is committed
so lessons sync across devices and the learning stays visible in public.

## Directory Tree

```text
learning/
├── CONTEXT.md · CLAUDE.md      ← this orientation · how to work here (tutor mode, notes not code)
└── <track>-NN-<topic>/         ← one folder per topic: pre-seeded (tracks below) or created by /teach
    ├── SYLLABUS.md             ← the planned lessons in order, each with objective, build sketch and sources
    ├── MISSION.md              ← why this topic, what "can do it" looks like, family, phase, milestone
    ├── RESOURCES.md            ← pinned primary sources and house guides, one row per lesson
    ├── PROGRESS.md             ← review queue, then the dated journal: recall result and next review date
    └── NOTES/                  ← one concept note per lesson, created by the first lesson taught
        └── NN-<concept>.md     ← Sam's explanation, linked by path to the code that proves it
```

The formats of all five live in `.claude/skills/teach/SKILL.md`. A topic folder is `<track>`, a
two-digit running number within that track, and a kebab-case topic: `c-01-foundations/`.

**Pre-seeded topics are drafts.** The kernel, os, ui, llm and sec folders, and `tooling-03` to
`tooling-05`, were drafted from Sam's planning conversation of 27/09/2026 and the networking and
licensing round that followed it the same day, before any lesson ran: each `SYLLABUS.md` is a plan
the tutor re-pitches lesson by lesson, and each `MISSION.md` is marked as a draft for Sam to confirm
or rewrite in his own words at the topic's first lesson.

## Tracks and topic folders

| Track | Covers | Topic folders | Phases |
| --- | --- | --- | --- |
| `c` | the language, its memory model, then systems programming | suggested, not created: `c-01-foundations/` · `c-02-pointers-and-memory/` · `c-03-structs-unions-memory-model/` · `c-04-preprocessor-and-multi-file/` | P1–P2 |
| `tooling` | gcc, make, gdb, valgrind, the sanitisers, cargo; shell, git for patch series, licensing | suggested, not created: `tooling-01-gcc-and-make/` · `tooling-02-gdb-valgrind-sanitisers/`; pre-seeded: `tooling-03-shell-scripting/` · `tooling-04-git-for-patch-series/` · `tooling-05-licensing-and-collaboration/` | from P1 |
| `rust` | ownership to `unsafe`, FFI with C, async | suggested, not created: `rust-01-ownership-borrowing/` · `rust-02-traits-generics/` · `rust-03-unsafe-and-ffi-with-c/` | P3 |
| `kernel` | build and boot in QEMU, modules, syscalls and memory, Kconfig and profile fragments, the downstream tree, kernel CI, upstreaming, Rust-for-Linux | `kernel-01-build-and-boot-in-qemu/` · `kernel-02-modules/` · `kernel-03-syscalls-memory-and-concurrency/` · `kernel-04-kconfig-and-profile-configs/` · `kernel-05-downstream-tree/` · `kernel-06-kernel-ci-and-security/` · `kernel-07-upstreaming/` · `kernel-08-rust-for-linux/` | P4–P5 |
| `os` | Syntek OS: LFS, a build system, init, packages and signing, networking, profiles and editions, and running Sam's own network | `os-01-anatomy-of-a-distro/` · `os-02-storage-and-boot-fundamentals/` · `os-03-lfs-toolchain/` · `os-04-lfs-base-system/` · `os-05-build-system-and-reproducibility/` · `os-06-init-and-services/` · `os-07-package-manager/` · `os-08-repositories-signing-and-updates/` · `os-09-networking-fundamentals/` · `os-10-profiles-and-installer/` · `os-11-server-edition/` · `os-12-homelab-edition/` · `os-13-nas-edition/` · `os-14-router-edition/` · `os-15-desktop-editions/` · `os-16-release-and-security-process/` · `os-17-local-model-integration/` · `os-18-own-network-operations/` | P6 |
| `ui` | terminal programs, ratatui, the Syntek OS TUI tools, then GUI tools and a web admin dashboard | `ui-01-terminal-fundamentals/` · `ui-02-ratatui-foundations/` · `ui-03-tui-architecture-and-testing/` · `ui-04-file-manager-tui/` · `ui-05-package-manager-tui/` · `ui-06-installer-tui/` · `ui-07-system-tools-tui/` · `ui-08-gui-foundations/` · `ui-09-gui-tools/` · `ui-10-web-admin-dashboard/` | U1–U3 |
| `llm` | a local-model baseline, ML foundations, CPU and GPU performance, llm.c, training a small code model, inference in Rust, skills, security, scale | `llm-01-local-models-and-skills-baseline/` · `llm-02-python-ml-toolchain/` · `llm-03-neural-network-foundations/` · `llm-04-transformer-maths/` · `llm-05-tiny-gpt/` · `llm-06-cpu-performance-in-c/` · `llm-07-gpu-architecture-and-vram-budgets/` · `llm-08-gpu-kernels-in-cuda/` · `llm-09-llm-c/` · `llm-10-data-pipeline-and-licensing/` · `llm-11-tokenizer/` · `llm-12-pretraining-a-small-code-model/` · `llm-13-evaluation-in-a-sandbox/` · `llm-14-inference-in-rust/` · `llm-15-efficient-inference/` · `llm-16-skills-layer/` · `llm-17-retrieval-and-doc-guidance/` · `llm-18-secure-llm-systems/` · `llm-19-efficient-architectures/` · `llm-20-post-training-and-adapters/` · `llm-21-scaling-on-bare-metal/` | L1–L6 |
| `sec` | foundations, an authorised pentest lab, then securing Sam's own systems; malware defence | `sec-01-principles-threat-modelling-and-law/` · `sec-02-memory-corruption-and-mitigations/` · `sec-03-fuzzing/` · `sec-04-linux-security-model/` · `sec-05-applied-cryptography/` · `sec-06-pentest-lab-setup/` · `sec-07-recon-and-network-security/` · `sec-08-web-application-security/` · `sec-09-linux-privilege-escalation/` · `sec-10-binary-exploitation/` · `sec-11-reverse-engineering/` · `sec-12-methodology-and-reporting/` · `sec-13-hardening-and-secure-boot/` · `sec-14-testing-syntek-os/` · `sec-15-red-teaming-the-llm/` · `sec-16-detection-response-and-disclosure/` · `sec-17-malware-concepts-and-defence/` · `sec-18-antivirus-and-detection-engineering/` · `sec-19-runtime-and-kernel-integrity/` | S1–S3 |

What each track teaches from, and the rules that bind it, is `.claude/skills/teach/FAMILIES.md`.

The phases and their exit gates are owned by `project-management/src/01-ROADMAP/ROADMAP.md`; a
topic's `MISSION.md` names the phase it serves.

## How a lesson flows through the repo

One lesson touches three places. The concept note and the journal entry land here; the runnable
example and its tests land in `code/src/c/msNNN-<kebab>/` or `code/src/rust/crates/msNNN_<snake>/`
(`NNN` as `code/src/CLAUDE.md` → Output & naming numbers it: the milestone, except that a Rust port
keeps its C exercise's number); and the review dates in `PROGRESS.md` bring the concept back at
+1, +3 and +7 days until it is consolidated.

## When to read this

- Starting or resuming a lesson, after checking `handoffs/` for a newer handoff.
- Checking which reviews are due: each topic's `PROGRESS.md` review queue.
- Seeing what a topic plans to teach next: its `SYLLABUS.md`.
- Planning the next milestone: the "can do it when" lines in each `MISSION.md` show readiness
  against the roadmap's exit gates.

## Do not use for

- Runnable code, exercises and their tests → `code/CONTEXT.md`
- Evidence for a decision → `research/CONTEXT.md`
- Milestones, plans and progress records → `project-management/CONTEXT.md`
- Mid-task session continuity → `handoffs/CONTEXT.md`
- Durable repo facts and feedback for Claude → `.claude/MEMORY.md`

## Key docs

| Guide | When to read |
| --- | --- |
| `.claude/skills/teach/SKILL.md` | Before any lesson: the loop, the spacing rule and every file format |
| `project-management/workflows/10-study-and-build/` | The procedure a lesson runs inside |
| `code/docs/C-CODING-PRINCIPLES.md` · `code/docs/RUST-CODING-PRINCIPLES.md` | The house style a lesson's code follows |
| `code/docs/MEMORY-SAFETY.md` | Why a C lesson is not done until `san` and `memcheck` are clean |
| `project-management/src/01-ROADMAP/ROADMAP.md` | Which phase a topic belongs to |

## Cross-references

- `learning/CLAUDE.md`: how to work here.
- `.claude/skills/wait-what/SKILL.md`: the detour that can open a new topic mid-session.
- `code/workflows/CONTEXT.md`: the build workflows a lesson's code goes through.
- `code/src/c/ms001-hello/` · `code/src/rust/crates/ms001_hello/`: the exercise pattern.
- `REFERENCES.md`: the root index.
