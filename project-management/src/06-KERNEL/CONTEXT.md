# project-management/src/06-KERNEL/ — Kernel Plans and Build Records

**Last Updated**: 27/09/2026

Kernel work in two stages, one pair of files per milestone whose Kernel flag runs. A
`KERNEL-PLAN-MS###-<DESCRIPTOR>.md` is written **before** a build: which kernel version and why,
how the configuration is derived, which patches and modules are involved, and the exact QEMU
command that will prove the boot. A `KERNEL-IMPL-MS###-<DESCRIPTOR>.md` is written **after**: what
was actually built, the config as built, and the evidence — the QEMU command, a serial-console
excerpt and a `dmesg` excerpt — that closes the plan. Every kernel and module here runs in QEMU and
nowhere else; kernel source trees, build output and disk images stay outside the repository. Kernel
work starts at P4, so no plan or record exists until then.

## Directory Tree

```text
project-management/src/06-KERNEL/
├── CONTEXT.md · CLAUDE.md               ← this pair: the two stages · how to work here
├── KERNEL-PLAN-MS000-TEMPLATE.md        ← plan template — copied before a kernel build
├── KERNEL-IMPL-MS000-TEMPLATE.md        ← build-record template — copied after the build
├── KERNEL-PLAN-MS###-<DESCRIPTOR>.md    ← one plan per kernel milestone (from P4)
└── KERNEL-IMPL-MS###-<DESCRIPTOR>.md    ← the matching record, same descriptor
```

## The two stages

| File | When it is written | Holds |
| --- | --- | --- |
| `KERNEL-PLAN-...` | Before the build, at `06-kernel-spec` | Target version and why, host prerequisites, config approach, patches, modules, initramfs, the QEMU boot plan, the evidence to collect |
| `KERNEL-IMPL-...` | After the build, at verification | Version and source as built, planned-versus-built verdicts, config delta, QEMU boot evidence, `dmesg` and module transcripts, divergences |

A plan and its record share the milestone number and descriptor, so each record sits directly
beside the plan it closes. A plan without a record is work in progress; a record without a plan is
a build nobody decided on.

## What lives elsewhere

- **Config fragments and patch series** — small, reviewable text. The lesson fragments and practice
  patches of `kernel-01` to `kernel-04` are committed under `code/src/kernel/` (planned — added at
  P4), and these records cite them by path. From `kernel-05-downstream-tree` lesson 02 the profile
  fragments and the real patch series live in the downstream kernel repository, and these records
  cite them by that repository's URL and commit.
- **Kernel sources, build directories, `bzImage`, initramfs archives, disk images** — outside the
  repository entirely; only text excerpts of their output are pasted into the records here.
- **How to set up and boot** — the how-to workflows `07-kernel-source-setup` and
  `08-build-and-boot-kernel` (planned — appended to `how-to/workflows/` at P4).

## Cross-references

- `project-management/workflows/06-kernel-spec/` — the procedure that writes the plans
- `project-management/workflows/11-verification/` — where a build record's evidence is checked
- `project-management/src/01-ROADMAP/ROADMAP.md` — P4 and P5: topics, candidate milestones, exit gates
- `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` — the per-profile kernel config hypotheses P5 builds
- `project-management/docs/SAFETY-GUIDE.md` — the kernel-in-QEMU-only rule and why it exists
- `.claude/CLAUDE.md` — the kernel safety rule (its owner)
