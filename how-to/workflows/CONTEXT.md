# how-to/workflows/ — Step-by-Step Operational Procedures

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Six workflows in five families: set up, run, maintain, diagnose and author. Like `code/workflows/`, this
is a **catalogue entered by task type**, not a sequence: the number is a stable identifier and a shelf
position, nothing more. Each workflow is the operational procedure for one recurring job on this
machine, from a bare Ubuntu install to a guide that documents it.

## Directory Tree

```text
how-to/workflows/
├── CONTEXT.md · CLAUDE.md       ← this catalogue · operating rules for this folder
│
│   ── Set up (01) ──
├── 01-toolchain-setup/          ← fresh Ubuntu 24.04 → clone that builds and tests ms001 in C and Rust
│
│   ── Run (02–03) ──
├── 02-daily-study-session/      ← pull → handoff → one unit → gates → PROGRESS → commit → handoff
├── 03-quality-gates/            ← the gate list (owner) and the one-shot local run
│
│   ── Maintain (04) ──
├── 04-toolchain-updates/        ← move the Rust pin by ADR, host upgrades via reboot-purge, re-record
│
│   ── Diagnose (05) ──
├── 05-debugging-environment/    ← missing tools, wrong versions, ptrace, core dumps, ASan vs valgrind
│
│   ── Author (06) ──
└── 06-write-a-guide/            ← add a reference to docs/ or a runbook to src/, and prove it
```

Every workflow folder carries `CONTEXT.md` (when to use), `CLAUDE.md` (operating rules), `STEPS.md`
(ordered execution) and `CHECKLIST.md` (verification).

## The five families

### Set up (01) — getting a working machine

| Workflow | Purpose |
| --- | --- |
| `01-toolchain-setup/` | Take a fresh Ubuntu 24.04 machine to a clone whose toolchain check and ms001 gates are green |

### Run (02–03) — day-to-day study

| Workflow | Purpose |
| --- | --- |
| `02-daily-study-session/` | The routine around one study session, from reading the last handoff to writing the next |
| `03-quality-gates/` | Every gate, raw and scripted, with the 0/1/2 exit-code contract; owns the gate list |

### Maintain (04) — keeping the toolchain honest

| Workflow | Purpose |
| --- | --- |
| `04-toolchain-updates/` | Move the Rust pin through an ADR, route host upgrades to reboot-purge, re-record versions |

### Diagnose (05) — when the machine is the problem

| Workflow | Purpose |
| --- | --- |
| `05-debugging-environment/` | Environment first: prove the toolchain and host settings before suspecting the code |

### Author (06) — documenting the above

| Workflow | Purpose |
| --- | --- |
| `06-write-a-guide/` | Write or restructure a guide in `how-to/docs/` or `how-to/src/`, run it, index it |

### Planned — kernel lab (07–08, added at P4)

These are not created yet; they are appended when P4 (kernel internals) opens, per
`project-management/src/01-ROADMAP/ROADMAP.md`.

| Workflow (planned) | Purpose |
| --- | --- |
| `07-kernel-source-setup/` | Fetch a pinned kernel tree outside the repository and set up an out-of-tree build directory |
| `08-build-and-boot-kernel/` | Configure, build, pack a busybox initramfs and boot the kernel in QEMU, gdb attached |

## Boundaries worth knowing

- **`02` wraps the study; it does not define it.** What a unit of study involves is
  `project-management/workflows/10-study-and-build/` and the code workflows it routes to.
- **`03` checks form, not judgement.** Content review is `code/workflows/05-review/`; the deeper memory
  investigation is `code/workflows/06-memory-check/`.
- **`05` stops at the environment.** Once the toolchain and host are proven healthy, a persisting fault is
  a logic bug for `code/workflows/07-debug/`.
- **`04` does not maintain the host.** Cleanup and routine upgrades belong to the reboot-purge repository
  (`how-to/src/HOST-MAINTENANCE.md`); `04` records what those upgrades change.

Read a workflow's `CONTEXT.md` first; enter its `STEPS.md` when the task calls for it.

## Numbers are identifiers, not a sequence

A new workflow is appended with the next free number and grouped by editing the family tables above;
existing numbers stay fixed. A stale number in a cross-reference is a silent routing failure, which is why
the planned kernel workflows already have theirs.

## Cross-references

- `how-to/CONTEXT.md` — the layer this catalogue belongs to
- `how-to/REFERENCES.md` → **Internal → Steps & checklists** — every `STEPS.md` in one table
- `code/workflows/CONTEXT.md` — the build, verify and debug workflows for code itself
- `project-management/workflows/CONTEXT.md` — planning, verification and pull-request workflows
- `project-management/src/01-ROADMAP/ROADMAP.md` — the phases that decide when 07 and 08 arrive
