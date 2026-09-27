# how-to/ — Setup, Daily Study and Environment Debugging

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

This layer answers "how do I run it", which is a different question from "how should the code be
written" (`code/`) or "what am I learning next" (`project-management/`). It covers the machine and the
routine around the learning: installing and recording the toolchain, running a study session, running
the quality gates, keeping the toolchain current, and diagnosing a broken environment. Its reader is
usually mid-session with something that does not work, so everything here is written to be executed
rather than studied. It holds no code; the scripts it names live in `code/src/scripts/`.

## Directory Tree

```text
how-to/
├── CONTEXT.md · CLAUDE.md       ← this entry map · operating rules for the layer
├── REFERENCES.md                ← internal and external reference register (tables only)
├── docs/                        ← reference guides, read in fragments (≤ 300 cloc lines each)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── TOOLCHAIN.md             ← owner of toolchain versions; prerequisites; troubleshooting
│   ├── CLI-TOOLING.md           ← every command by intent, raw first, then the script
│   └── GUIDE-CRAFT.md           ← how a guide here is written: reader, homes, spine, discipline
├── src/                         ← long-form runbooks, executed top to bottom (length-exempt)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── MACHINE-SETUP.md         ← full Ubuntu 24.04 host setup: Part A now, Part B at P4
│   └── HOST-MAINTENANCE.md      ← pointer stub → the reboot-purge repository
└── workflows/                   ← step-by-step procedures, five families
    ├── CONTEXT.md · CLAUDE.md
    │   ── Set up (01) ──
    ├── 01-toolchain-setup/      ← fresh machine → green toolchain check and ms001 gates
    │   ── Run (02–03) ──
    ├── 02-daily-study-session/  ← handoff → one unit → gates → PROGRESS → commit → handoff
    ├── 03-quality-gates/        ← the gate list (owner) and the one-shot local run
    │   ── Maintain (04) ──
    ├── 04-toolchain-updates/    ← Rust pin by ADR, host upgrades via reboot-purge, re-record
    │   ── Diagnose (05) ──
    ├── 05-debugging-environment/ ← environment first: tools, versions, ptrace, cores, ASan vs valgrind
    │   ── Author (06) ──
    └── 06-write-a-guide/        ← add a reference or runbook, run it, index it
```

Each `how-to/workflows/NN-…/` folder carries `CONTEXT.md`, `CLAUDE.md`, `STEPS.md` and `CHECKLIST.md`. Two more
workflows, `07-kernel-source-setup` and `08-build-and-boot-kernel`, are planned and added at P4.

## When to read this

- Setting up a machine for the first time, or after a reinstall
- Starting a study session, or picking up after a break
- Running the gates before a commit or a pull request, or reproducing a red CI run
- Updating Rust or after an `apt upgrade`
- A tool is missing, the wrong version runs, or gdb, valgrind or a sanitiser will not cooperate
- Writing a new operational guide

## Do not use for

- Writing or reviewing code, build flags, test and memory-safety standards → `code/CONTEXT.md`
- Roadmap, milestones, sprints, exercise specs, decisions, pull requests → `project-management/CONTEXT.md`
- Study notes and guided lessons → `learning/CONTEXT.md`
- Primary-source research notes → `research/CONTEXT.md`
- Host cleanup and routine upgrades → `how-to/src/HOST-MAINTENANCE.md` (the reboot-purge repository)

## Key docs

| Guide | When to read |
| --- | --- |
| `how-to/docs/TOOLCHAIN.md` | Which versions this repository runs on, what to install, and toolchain troubleshooting |
| `how-to/docs/CLI-TOOLING.md` | Looking for the command that does a thing |
| `how-to/docs/GUIDE-CRAFT.md` | Before writing or restructuring any guide in this layer |
| `how-to/src/MACHINE-SETUP.md` | Setting up a machine from scratch, with failure modes and rollback |
| `how-to/src/HOST-MAINTENANCE.md` | Host upkeep: it points at the reboot-purge repository |
| `how-to/workflows/03-quality-gates/` | The gate list and how to run it |
| `how-to/workflows/02-daily-study-session/` | The routine around every study session |

## Cross-references

- `REFERENCES.md` — the root index of every layer, guide and workflow
- `how-to/REFERENCES.md` — this layer's own register, internal and external
- `.claude/CLAUDE.md` — the non-negotiables, including the kernel safety rule (QEMU only)
- `code/src/scripts/CONTEXT.md` — the scripts every workflow here runs
- `project-management/src/01-ROADMAP/ROADMAP.md` — the phases that decide when the P4 material arrives
