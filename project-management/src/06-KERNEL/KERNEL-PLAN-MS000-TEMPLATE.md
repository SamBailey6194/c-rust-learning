# Kernel Plan — MS000: {PLAN TITLE}

_Template — copy to `KERNEL-PLAN-MS###-<DESCRIPTOR>.md`, replace every `{PLACEHOLDER}`, delete the
`[EXAMPLE]` rows. This is the **pre-build** plan for one kernel milestone; its post-build record is
`KERNEL-IMPL-MS###-<DESCRIPTOR>.md` (same descriptor), copied from
`KERNEL-IMPL-MS000-TEMPLATE.md`. **Everything planned here runs in QEMU only** — the kernel safety
rule in `.claude/CLAUDE.md`._

| Field | Value |
| --- | --- |
| **Milestone** | `MS###` — {short title} |
| **Milestone doc** | `project-management/src/02-MILESTONES/MS###-<TITLE>.md` |
| **Phase** | {P4 / P5} — `project-management/src/01-ROADMAP/ROADMAP.md` |
| **Tier** | {— / beginner / intermediate / experienced (P5)} |
| **Build record** | `project-management/src/06-KERNEL/KERNEL-IMPL-MS###-<DESCRIPTOR>.md` (written after the build) |
| **Status** | {Draft / Ready} |
| **Date** | {DD/MM/YYYY} |

---

## 1. What this build proves

{One or two sentences tied to the milestone's mastery criteria, e.g. "a kernel configured from a
committed fragment boots to a busybox shell over the serial console".}

---

## 2. Target version and why

Read the maintained branches from <https://www.kernel.org/category/releases.html> on the day of
planning, and record the date read. Branches and end-of-life dates change; memory is not a source.

| Candidate | Branch | Why for / against | Read on |
| --- | --- | --- | --- |
| [EXAMPLE] {x.y.z} | longterm | [EXAMPLE] years of fixes; matches a real distro kernel | DD/MM/YYYY |
| [EXAMPLE] {x.y.z} | stable | [EXAMPLE] newest features and docs; short support window | DD/MM/YYYY |

**Chosen:** {version} — {the deciding reason}. {If this sets the kernel base for later phases, it
is hard to reverse: cite the ADR in `project-management/src/08-DECISIONS/`.}

**Source and verification:**

- [EXAMPLE] Tarball `linux-{x.y.z}.tar.xz` and its `linux-{x.y.z}.tar.sign` from kernel.org,
  verified per <https://www.kernel.org/signature.html>
  (`xz -cd linux-{x.y.z}.tar.xz | gpg2 --verify linux-{x.y.z}.tar.sign -`)
- [EXAMPLE] or a shallow clone of the stable tree at tag `v{x.y.z}`
- **Location:** outside this repository (for example a sibling directory of the clone), never
  inside it.

---

## 3. Host prerequisites

Checked against "Minimal requirements to compile the kernel"
(<https://docs.kernel.org/process/changes.html>). A missing tool is a `GAPS.md` entry and a
`Blocked` milestone, not a workaround.

| Tool | Check command | Present? |
| --- | --- | --- |
| gcc | `gcc --version` | {yes / no — version} |
| GNU make | `make --version` | {...} |
| flex | `flex --version` | {...} |
| bison | `bison --version` | {...} |
| libelf headers | `pkg-config --modversion libelf` | {...} |
| pahole | `pahole --version` | {needed for BTF; ...} |
| bc, cpio, openssl headers | {...} | {...} |
| qemu-system-x86_64 | `qemu-system-x86_64 --version` | {...} |

---

## 4. Configuration approach

**Base:** {e.g. `make O=<build-dir> x86_64_defconfig` then `make O=<build-dir> kvm_guest.config`,
or `tinyconfig`, or the previous tier's config}

**Fragment:** committed at `code/src/kernel/{fragment-name}.config` (planned — the folder is added
at P4). Every option carries its reason on the comment line above it: the `.config` syntax has no
trailing comments, because Kconfig takes everything after `=` as the value.

```text
# [EXAMPLE] fragment — one reason per option, on its own line
# serial console, so -nographic shows boot messages and the shell
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
# boot from an initramfs, no disk
CONFIG_BLK_DEV_INITRD=y
# /dev without udev; with an initramfs, /init mounts devtmpfs itself
CONFIG_DEVTMPFS=y
# loadable modules, for the module milestones
CONFIG_MODULES=y
```

**Merge and settle:**

```bash
# [EXAMPLE] run inside the kernel source tree, outside this repository
scripts/kconfig/merge_config.sh -m -O <build-dir> <build-dir>/.config \
        <path-to-repo>/code/src/kernel/{fragment-name}.config
make O=<build-dir> olddefconfig
scripts/diffconfig <base-config-copy> <build-dir>/.config
```

`olddefconfig` can silently drop an option whose dependencies are unmet; the `diffconfig` output is
read line by line to confirm every fragment option survived.

---

## 5. Patches

{`None` if the milestone applies no patch.}

| ID | Subject | Why | Applies to |
| --- | --- | --- | --- |
| [EXAMPLE] 0001 | {subject line} | {what it changes and why} | {version} |

Applied with `git am` (or `patch -p1`), checked with `scripts/checkpatch.pl`. The series is
committed under `code/src/kernel/` (planned).

---

## 6. Modules

{`None` if the milestone builds no module.}

| Module | Purpose | Source | Build | In-guest test |
| --- | --- | --- | --- | --- |
| [EXAMPLE] `hello` | `pr_info` on load and unload | `code/src/kernel/` (planned) | `make -C <build-dir> M=$PWD` | `insmod hello.ko`, `rmmod hello`, then `dmesg` |

Modules are built against **this plan's kernel tree** (`<build-dir>`), never against
`/lib/modules/$(uname -r)/build`, which is the host's kernel.

---

## 7. Initramfs

{e.g. a static busybox, an `/init` script that mounts `/proc` and `/sys` then execs a shell, and
any modules copied in.}

```bash
# [EXAMPLE] from inside the staging directory, outside this repository
find . | cpio -o -H newc | gzip > ../initramfs.cpio.gz
```

---

## 8. Build

```bash
# [EXAMPLE]
make O=<build-dir> -j"$(nproc)"
```

Expected artefact: `<build-dir>/arch/x86/boot/bzImage`.

---

## 9. QEMU boot plan

```bash
# [EXAMPLE] no disk, serial console on the terminal, nothing persistent
qemu-system-x86_64 -m 512M -nographic \
        -kernel <build-dir>/arch/x86/boot/bzImage \
        -initrd initramfs.cpio.gz \
        -append "console=ttyS0"
```

- **Proof of boot:** {the exact serial-console line, e.g. the busybox shell prompt}
- **Exit:** `Ctrl-A` then `X` quits QEMU from `-nographic`.
- **Debug variant** (Debugger flag): a config with debug information on and
  `CONFIG_GDB_SCRIPTS=y`; add `-s -S` to the QEMU command and `nokaslr` to `-append`, then
  `gdb <build-dir>/vmlinux` and `target remote :1234`
  (<https://docs.kernel.org/process/debugging/gdb-kernel-debugging.html>).

---

## 10. Evidence to collect

The build record pastes each of these, trimmed to the relevant lines:

- [ ] Version and source verification output
- [ ] `scripts/diffconfig` output against the base
- [ ] The QEMU command exactly as run
- [ ] Serial-console excerpt from the `Linux version` line to the proof-of-boot line
- [ ] `dmesg` excerpt for every module loaded and unloaded
- [ ] {gdb transcript, if the Debugger flag runs}

---

## 11. Risks

| Risk | Fallback |
| --- | --- |
| [EXAMPLE] a fragment option silently dropped by `olddefconfig` | read `diffconfig`; add the missing dependency |
| [EXAMPLE] kernel panics with "unable to mount root fs" | check `CONFIG_BLK_DEV_INITRD` and the initramfs `/init` |
| {PLACEHOLDER} | {PLACEHOLDER} |

---

## Cross-references

- `project-management/src/02-MILESTONES/MS###-<TITLE>.md` — the driving milestone
- `project-management/src/06-KERNEL/KERNEL-IMPL-MS000-TEMPLATE.md` — the record that closes this plan
- `project-management/docs/SAFETY-GUIDE.md` — why kernels run in QEMU only
- <https://docs.kernel.org/kbuild/kconfig.html> — configuration targets
- <https://docs.kernel.org/kbuild/modules.html> — building external modules
