@./CONTEXT.md

# CLAUDE.md — project-management/src/06-KERNEL/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (the plan and
record stages and what lives elsewhere — imported above) → this file →
`project-management/docs/SAFETY-GUIDE.md`.

## Purpose (one line)

The kernel plans and build records — `KERNEL-PLAN-MS###-*` before a build, `KERNEL-IMPL-MS###-*`
after it, for kernels and modules that run in QEMU only.

## How to work here

- **Routing:** plans come from `project-management/workflows/06-kernel-spec/` (`STEPS.md` +
  `CHECKLIST.md`); build records are written during study and build and checked at
  `project-management/workflows/11-verification/`. Choosing a kernel base, an init system or a
  bootloader is hard to reverse and goes through `project-management/workflows/08-decisions/`.
  The how-to kernel workflows `07-kernel-source-setup` and `08-build-and-boot-kernel` pair with
  this folder once they exist (planned — added at P4).
- **Concrete steps:** plan — explain-first on what the build should prove → copy
  `KERNEL-PLAN-MS000-TEMPLATE.md` → choose and justify the version against kernel.org's current
  releases → check host prerequisites (log missing ones in `GAPS.md`) → write the config approach,
  patches, modules and initramfs → write the exact QEMU command and the line that proves the boot.
  Record — copy `KERNEL-IMPL-MS000-TEMPLATE.md` with the same descriptor → give every plan row a
  verdict → paste the real evidence → record divergences and gaps.
- **Definition of done:** a plan names its version with a reason, a committed-or-planned fragment
  path, and a copy-pasteable QEMU command; a record pastes real command output (trimmed, never
  paraphrased), gives every plan row a verdict, and confirms nothing touched the host; British
  English; DD/MM/YYYY.

## Guardrails

- **Run kernels and modules in QEMU only.** Never install a custom kernel on the host, never
  `insmod` a module into the host kernel, never run `make install` or `make modules_install`
  without `INSTALL_MOD_PATH` pointing into an initramfs staging directory. The rule is owned by
  `.claude/CLAUDE.md`; this folder only applies it.
- **Build modules against the QEMU kernel's own tree.** `make -C <kernel-build-dir> M=$PWD`, never
  `make -C /lib/modules/$(uname -r)/build`, which targets the host kernel.
- **Never commit kernel sources, build output or images.** Fragments, patches and pasted text
  excerpts are the only kernel material that enters the repository.
- **Never use `sudo` for kernel work.** Nothing in a QEMU-only workflow needs root on the host; a
  step that seems to is a step aimed at the host.
- **Paste evidence; do not summarise it.** A boot is proved by the serial-console line, a module by
  its `dmesg` lines. A check that was not run is written as not run, never as passed.
- **Check versions against kernel.org, not memory.** Which branches are maintained changes; cite
  the releases page with the date it was read.
- **Verify what you download.** A tarball is checked against its kernel.org signature before it is
  built; the record states how.

## Output & naming

- **Hand-written:** every `KERNEL-PLAN-MS###-<DESCRIPTOR>.md` and `KERNEL-IMPL-MS###-<DESCRIPTOR>.md`.
- **Templates:** `KERNEL-PLAN-MS000-TEMPLATE.md` and `KERNEL-IMPL-MS000-TEMPLATE.md` — the copy
  sources; keep them, do not repurpose them.
- **Generated:** none. Build output never lands here.
- A plan and its record share the driving milestone and a `SCREAMING-KEBAB-CASE` descriptor:
  `KERNEL-PLAN-MS030-FIRST-QEMU-BOOT.md` pairs with `KERNEL-IMPL-MS030-FIRST-QEMU-BOOT.md`
  (numbers illustrative). A P5 tier build puts the tier in the descriptor
  (`...-TIER-BEGINNER-CONFIG`).
- Status words: a plan is `Draft` then `Ready`; a record is `Draft` then `Verified` once
  `11-verification` has checked its evidence. Dates DD/MM/YYYY.
