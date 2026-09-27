# Workflow: Kernel Spec

**Last Updated**: 27/09/2026

A kernel build started without a plan picks its version from memory, its config by trial and error,
and ends with a boot nobody wrote down. It can also end on the host. Planning the version, the config
fragment, the initramfs and the exact QEMU command first, then recording what was actually built
against that plan, keeps every kernel milestone reproducible, evidenced and inside QEMU.

## Directory Tree

```text
project-management/workflows/06-kernel-spec/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

**Entry condition: the milestone's `Kernel` flag is not `N/A`.** A milestone whose flag reads `N/A`
skips this gate (`project-management/docs/planning/MILESTONES.md` → _The FLAGS table_). Kernel work
starts at P4 and continues through the P5 per-tier configurations
(`project-management/src/01-ROADMAP/ROADMAP.md`).

- **PLAN:** after `03-sprint-planning` admits the milestone and before `08-decisions` and
  `09-milestone-plans`: a first QEMU boot, a Kconfig fragment, an out-of-tree module, a patch series, a
  tier configuration.
- **RECORD:** during `10-study-and-build`, once the build has run, to write the build record against the
  plan; `11-verification` then checks its evidence.

## Key concepts

- **QEMU only.** Every kernel and module planned here is built and booted in `qemu-system-x86_64`;
  none is installed, booted or `insmod`-ed on the host, and sources, build output and images stay out
  of the repository. `.claude/CLAUDE.md` owns the rule, and
  `project-management/docs/SAFETY-GUIDE.md` → _Kernel — QEMU only_ explains it.
- **Two documents per build, one descriptor.** `KERNEL-PLAN-MS###-<DESCRIPTOR>.md` is written before the
  build; `KERNEL-IMPL-MS###-<DESCRIPTOR>.md` after it, giving every plan row a verdict and pasting the real
  evidence.
- **Versions come from kernel.org, not memory.** Which branches are maintained changes; the plan cites
  the releases page with the date it was read, and a choice that sets the base for later phases is an
  ADR.
- **The fragment is the config.** A committed Kconfig fragment, each option with its reason, merged onto
  a named base and checked with `diffconfig`, because `olddefconfig` can drop an option silently.
- **Modules build against the QEMU kernel's tree** (`make -C <kernel-build-dir> M=$PWD`), not the
  host's `/lib/modules/$(uname -r)/build`.
- **Missing prerequisites are blockers, not workarounds.** flex, bison, libelf-dev and dwarves are not
  yet installed on the host, and Rust-for-Linux also needs clang/LLVM and bindgen; a milestone waiting
  on them is `Blocked` with a `GAPS.md` entry.
- **Evidence is pasted, not summarised.** A boot is proved by its serial-console line, a module by its
  `dmesg` lines.

## Cross-references

### Governing documents

- `project-management/src/06-KERNEL/CLAUDE.md` — naming, status words and the QEMU-only guardrails
- `project-management/src/06-KERNEL/KERNEL-PLAN-MS000-TEMPLATE.md` — the plan scaffold
- `project-management/src/06-KERNEL/KERNEL-IMPL-MS000-TEMPLATE.md` — the build record scaffold
- `.claude/CLAUDE.md` — the kernel safety rule

### Related reading

- `project-management/docs/SAFETY-GUIDE.md` — why QEMU only, and what a kernel milestone plans for
- `project-management/workflows/08-decisions/` — kernel base, bootloader and init-system ADRs
- `project-management/workflows/07-distro-tier-spec/` — the tier specs a P5 configuration serves
- `research/CONTEXT.md` — primary-source notes behind version and config choices
- `how-to/workflows/CONTEXT.md` — where the kernel source-setup and build-and-boot workflows join
  (planned — added at P4)
