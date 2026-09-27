---
workflow: 06-kernel-spec
phase: specify
skills: [research]
---

# Kernel Spec — Checklist

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

> **See** `project-management/REFERENCES.md` (kernel.org and QEMU sources) ·
> `project-management/src/06-KERNEL/CLAUDE.md` (naming, status, QEMU-only guardrails) ·
> `project-management/docs/SAFETY-GUIDE.md` (why QEMU only) for supporting references. Tick PLAN before
> `08-decisions`, and RECORD once the build has run.

## Execution Checklist

### Step 1 — Explain-first on what the build proves

- [ ] The milestone's `Kernel` flag is not `N/A`
- [ ] The learner stated what the build proves, predicted where it fails, and said where it runs: QEMU

### Step 2 — Copy the plan template

- [ ] The plan is named `KERNEL-PLAN-MS###-<DESCRIPTOR>.md`, `Status: Draft`, header and section 1 filled

### Step 3 — Choose the version from kernel.org

- [ ] The version is chosen from the kernel.org releases page, with the date read and a deciding reason
- [ ] The signature verification method and a source location outside the repository are written
- [ ] A version that sets the base for later phases has an ADR

### Step 4 — Check host prerequisites

- [ ] Every prerequisite was checked by command, not assumed
- [ ] Every missing tool has a `GAPS.md` entry, and the milestone is `Blocked` while any is missing
- [ ] Nothing was installed from this workflow

### Step 5 — Plan the configuration, patches, modules and initramfs

- [ ] The base config is named and every fragment option has a reason on its own comment line
- [ ] The merge is followed by `olddefconfig` and a `diffconfig` check
- [ ] Modules build against this kernel's tree, never the host's
- [ ] The initramfs uses a statically linked busybox and states how it is packed

### Step 6 — Write the build and the QEMU boot plan

- [ ] Builds are out of tree (`O=<build-dir>`), outside the repository
- [ ] The QEMU command is copy-pasteable and the success line on the serial console is named

### Step 7 — List the evidence and the risks, then set the plan ready

- [ ] The evidence list and the risks with fallbacks are written
- [ ] `Status: Ready`, and the milestone links the plan by full path

### Step 8 — Commit the plan by explicit path

- [ ] Committed on the milestone branch, files staged by name, scope `kernel`

### Step 9 — Write the build record against the plan (RECORD)

- [ ] The record shares the plan's descriptor
- [ ] Every plan row has a verdict; evidence is pasted, not paraphrased; unrun checks say "not run"
- [ ] Divergences and new gaps are recorded; the host safety confirmation is filled

### Step 10 — Commit the record by explicit path (RECORD)

- [ ] No kernel source, build output or image is staged
- [ ] Record, fragment and module sources committed by name, scope `kernel`

---

## Context

- [ ] Directory trees in the relevant `CONTEXT.md` files show every file or folder this workflow created
- [ ] `project-management/REFERENCES.md` lists any new artefact type or external source
- [ ] `**Last Updated**` is refreshed in every `CONTEXT.md` modified
- [ ] If the session ended mid-work, a handoff exists in `handoffs/`

---

## Definition of Done

- [ ] Nothing planned or built touched the host: no install, no boot, no `insmod`, no `sudo`
- [ ] The plan could be followed from a copy-paste by someone who has never seen the milestone
- [ ] The record proves, with pasted evidence, what the plan said the build would prove
- [ ] British English throughout; dates DD/MM/YYYY
