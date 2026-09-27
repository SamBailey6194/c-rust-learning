@./CONTEXT.md

# CLAUDE.md — project-management/workflows/06-kernel-spec/

Read order: `.claude/CLAUDE.md` (the kernel safety rule) → `.claude/MEMORY.md` → this folder's
`CONTEXT.md` (entry condition, key concepts, governing documents — imported above) → this file →
`STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Plan a kernel build, configuration or module for QEMU before it happens, and afterwards record what was
built against that plan with pasted evidence, for a milestone whose `Kernel` flag is set.

## How to work here

- **Routing:** run `STEPS.md` against `CHECKLIST.md`: PLAN before `08-decisions`, RECORD during
  `10-study-and-build` once the build has run. Read `project-management/src/06-KERNEL/CLAUDE.md` and both
  templates before Step 2. Version and config questions go through `.claude/skills/research/SKILL.md`; a
  kernel base, bootloader or init-system choice goes to `project-management/workflows/08-decisions/`.
- **Concrete steps:** PLAN (Explain-first on what the build proves → copy the plan template → version
  from kernel.org with the date read → host prerequisites, gaps to `GAPS.md` → base config and fragment →
  patches, modules, initramfs → build commands → the exact QEMU command and the line that proves it →
  evidence list and risks → `Ready`, link, commit) → RECORD (copy the record template, same descriptor →
  a verdict for every plan row → paste evidence → divergences and gaps → host safety confirmation).
- **Definition of done:** the plan names its version with a reason and a date, a fragment path, a
  copy-pasteable QEMU command and the console line that proves success; the record pastes real output,
  gives every plan row a verdict, and confirms nothing touched the host.

## Guardrails

- **Keep every kernel and module in QEMU.** Never install a custom kernel on the host, never `insmod`
  into the host kernel, never run `make install`, and never run `make modules_install` without
  `INSTALL_MOD_PATH` pointing into an initramfs staging directory.
- **Never use `sudo` for kernel work.** Nothing in a QEMU-only build needs root on the host; a step that
  seems to is a step aimed at the host.
- **Never commit kernel sources, build output or disk images.** Fragments, patches and trimmed text
  excerpts are the only kernel material that enters the repository.
- **Check versions against kernel.org, not memory**, and cite the page with the date it was read.
- **Record a missing prerequisite as a blocker.** A missing tool is a `GAPS.md` entry and a `Blocked`
  milestone, not a workaround; installing packages is a how-to task, done by the learner.
- **Paste evidence; never summarise it.** A check that was not run is written as not run, never as
  passed.

## Output & naming

- **Writes:** `project-management/src/06-KERNEL/KERNEL-PLAN-MS###-<DESCRIPTOR>.md` (PLAN) and
  `project-management/src/06-KERNEL/KERNEL-IMPL-MS###-<DESCRIPTOR>.md` (RECORD), sharing one descriptor;
  `GAPS.md` entries for missing prerequisites.
- The folder's `CLAUDE.md` → Output & naming owns both patterns and the plan and record status words.
- Commit on the milestone branch with scope `kernel` (`docs(kernel)` for the plan and record, per
  `project-management/docs/git/COMMITS.md`); dates DD/MM/YYYY.
