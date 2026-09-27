---
workflow: 06-kernel-spec
phase: specify
skills: [research]
---

# Kernel Spec — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `project-management/REFERENCES.md` (kernel.org documentation and QEMU sources) as you work
through these steps:

| Step | Section |
| --- | --- |
| All | `.claude/CLAUDE.md` — the kernel safety rule; `project-management/docs/SAFETY-GUIDE.md` → _Kernel — QEMU only_ |
| 2–7 | `project-management/src/06-KERNEL/KERNEL-PLAN-MS000-TEMPLATE.md` — sections 1 to 11 |
| 3 | https://www.kernel.org/category/releases.html — maintained branches, read on the day |
| 3 | `project-management/workflows/08-decisions/` — when the version sets the base for later phases |
| 4 | https://docs.kernel.org/process/changes.html — minimal requirements to compile the kernel |
| 5 | https://docs.kernel.org/kbuild/modules.html — building external modules |
| 6 | https://docs.kernel.org/process/debugging/gdb-kernel-debugging.html — QEMU and gdb |
| 9 | `project-management/src/06-KERNEL/KERNEL-IMPL-MS000-TEMPLATE.md` — sections 1 to 10 |
| 8, 10 | `project-management/docs/git/COMMITS.md` — scope `kernel`, staging by explicit path |

---

## PLAN — before the build

### Step 1 — Explain-first on what the build proves

Check the entry condition: the milestone's `Kernel` flag is not `N/A`. Ask the learner what this build
should prove (in one sentence, tied to a mastery criterion), what they expect to happen at each stage
from `make` to the shell prompt, and where they expect it to fail. Then ask where the kernel will run,
and hear "in QEMU" said back; the safety rule is part of the lesson.

_Done when the learner's statement of what the build proves, and their predicted failure points, are
recorded._

### Step 2 — Copy the plan template

```bash
cp project-management/src/06-KERNEL/KERNEL-PLAN-MS000-TEMPLATE.md \
   project-management/src/06-KERNEL/KERNEL-PLAN-MS030-FIRST-QEMU-BOOT.md
```

Fill the header (milestone, phase, tier for a P5 build, the record's future path, `Status: Draft`, date)
and section 1, _What this build proves_, from Step 1.

_Done when the plan exists under the folder's naming pattern with its header and section 1 filled._

### Step 3 — Choose the version from kernel.org

Read the maintained branches on the kernel.org releases page on the day, record the date read, and
compare at least a longterm and a stable candidate. Record the chosen version with its deciding reason,
how the source will be verified against its kernel.org signature, and where it will live: outside this
repository. If the choice sets the kernel base for later phases, raise it through `08-decisions`.

_Done when the version, its reason, the date read and the verification method are written._

### Step 4 — Check host prerequisites

Run each check command in the template's prerequisites table and record the result. At the time of
writing, flex, bison, libelf-dev and dwarves (for pahole) are **not** installed, and a Rust-for-Linux
milestone also needs clang/LLVM and bindgen (checked with `make LLVM=1 rustavailable` in the source
tree). Each missing tool becomes a `GAPS.md` entry and the milestone goes `Blocked` until the learner
installs it through `how-to/workflows/01-toolchain-setup/`. Never install anything from this workflow.

_Done when every prerequisite is recorded as present, or as a `GAPS.md` entry with the milestone
`Blocked`._

### Step 5 — Plan the configuration, patches, modules and initramfs

- **Configuration:** name the base (`x86_64_defconfig` plus `kvm_guest.config`, or `tinyconfig`, or the
  previous tier's config) and write the fragment with one reason per option on the comment line above it.
  Plan the merge with `scripts/kconfig/merge_config.sh`, then `make olddefconfig`, then a `diffconfig`
  check, because `olddefconfig` drops an option whose dependencies are unmet without saying so.
- **Patches:** `None`, or each patch with what it changes and why.
- **Modules:** each out-of-tree module, built with `make -C <kernel-build-dir> M=$PWD` against this
  kernel's tree, never the host's, and how it reaches the guest (copied into the initramfs).
- **Initramfs:** the statically linked busybox, the `/init` script, and how the archive is packed.

_Done when every template section from 4 to 7 is filled or marked `None` with a reason._

### Step 6 — Write the build and the QEMU boot plan

Write the build commands (out-of-tree with `O=<build-dir>`, `-j$(nproc)`) and the exact QEMU command,
copy-pasteable, for example:

```bash
qemu-system-x86_64 -m 512M -nographic -no-reboot \
    -kernel <build-dir>/arch/x86/boot/bzImage \
    -initrd <staging-dir>/initramfs.cpio.gz \
    -append "console=ttyS0 panic=-1"
```

`-nographic` with `console=ttyS0` puts the whole boot on the terminal as text; `panic=-1` with
`-no-reboot` makes a panic exit QEMU instead of looping. Name **the line on the serial console that
proves success** (the busybox prompt, a module's `pr_info` message). For a debugging milestone, add the
`-s -S` variant and the `nokaslr` argument, and the gdb session that attaches to `vmlinux`.

_Done when the QEMU command runs from a copy-paste and the success line is named._

### Step 7 — List the evidence and the risks, then set the plan ready

List the evidence the record will paste: the build's last lines, the boot log up to the success line, a
trimmed `dmesg` excerpt, module load and unload lines, a `uname -r` from inside the guest. Fill the
risks with a fallback each. Check the folder's definition of done, set `Status: Ready`, and link the plan
from the milestone by full path.

_Done when the plan is `Ready` and linked from its milestone._

### Step 8 — Commit the plan by explicit path

On the milestone branch:

```bash
git add project-management/src/06-KERNEL/KERNEL-PLAN-MS030-FIRST-QEMU-BOOT.md \
        project-management/src/02-MILESTONES/MS030-FIRST-QEMU-BOOT.md
git commit -m "docs(kernel): plan the first QEMU boot for MS030"
```

_Done when `git status` shows nothing from the plan left uncommitted._

---

## RECORD — during study and build, once the build has run

### Step 9 — Write the build record against the plan

Copy `KERNEL-IMPL-MS000-TEMPLATE.md` to `KERNEL-IMPL-MS###-<DESCRIPTOR>.md` with the plan's descriptor.
Give every plan row a verdict (as planned, changed, or not done, with the reason), confirm the source
was verified, record the config as built with its `diffconfig` output, and **paste** the evidence the
plan listed: trimmed, never paraphrased. A check that was not run is written as not run. Record every
divergence and every new gap (`GAPS.md` for a blocker, `DEFERRED.md` for a parked idea), and fill the
host safety confirmation: nothing was installed, booted or loaded on the host, and nothing built was
committed. The record stays `Draft` until `11-verification` has checked its evidence.

_Done when every plan row has a verdict, the evidence is pasted, and the host safety confirmation is
filled._

### Step 10 — Commit the record by explicit path

```bash
git add project-management/src/06-KERNEL/KERNEL-IMPL-MS030-FIRST-QEMU-BOOT.md
git commit -m "docs(kernel): record the MS030 build and boot evidence"
```

Commit the fragment and any module source under `code/` separately, each with scope `kernel`. Check
`git status` for anything from the kernel tree before committing: sources, build output and images never
enter the repository.

_Done when `git status` shows nothing from this workflow left uncommitted, and nothing built was staged._

---

## Update context files

If this workflow created files or folders, or settled a new convention:

1. Add every new file or folder to the directory tree in the nearest `CONTEXT.md`.
2. Add any new artefact type or external source to `project-management/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete. After PLAN, next as flagged:
`project-management/workflows/07-distro-tier-spec/`, then `08-decisions/`. After RECORD, the
milestone continues in `10-study-and-build` and then `11-verification/`.
