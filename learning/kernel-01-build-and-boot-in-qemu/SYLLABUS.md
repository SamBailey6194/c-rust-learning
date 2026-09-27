# Syllabus — kernel-01-build-and-boot-in-qemu

**Track**: kernel · **Phase**: P4 · **Path**: Core · **Detail**: full · **Prerequisites**: P3; tooling-03-shell-scripting; tooling-04-git-for-patch-series lessons 01–02 (the object model and refs; crafting commits)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The first step from C and Rust into the kernel, and the opening topic of the kernel track: fetch a pinned Linux tree
outside this repository, configure it, build it, boot it in QEMU on a busybox initramfs Sam packs by hand, and debug a
boot with gdb. It leads to the downstream kernel that every Syntek OS profile runs on. This topic **owns "configure and
build" and the initramfs-plus-QEMU boot harness**: os-04-lfs-base-system (its bootable lesson) and
os-06-init-and-services (its minimal init in C) both reuse the harness built here rather than re-teaching it. Every
kernel built here runs in QEMU only (`.claude/CLAUDE.md` → non-negotiables). The kernel-build packages are not
installed yet (`GAPS.md` → "Kernel build dependencies not installed"); Sam installs them himself when P4 opens —
Claude never runs `sudo`. Lessons 01–02 are reading and may be taken before P4 (`.claude/skills/teach/FAMILIES.md`:
until P4 a kernel lesson is reading and notes only); lessons 03–07 need P4 and those dependencies.

Version pins for this syllabus: docs.kernel.org pages were read on 27/09/2026 (documentation build 7.3.0-rc4);
kernel-tree files are cited at tag v7.2 on git.kernel.org; kernel.org listed mainline 7.3-rc4, stable 7.2.8 and
longterm 6.18.54 that day; the host runs QEMU 8.2.2, and qemu.org's manual pages are the master build (11.1.50).

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Kernel trees and release lines | 1 sitting | no | — |
| 02 | A pinned, verified source tree outside the repository | 1 sitting | no | Security |
| 03 | Configuring: defconfig, tinyconfig and config fragments | 2–3 sittings | yes — QEMU config fragment | — |
| 04 | Building out of tree with `O=` | 1 sitting | no | Efficiency |
| 05 | A busybox initramfs by hand | 2–3 sittings | yes — initramfs builder | Security, Safety |
| 06 | Booting in QEMU on a serial console | 1 sitting | yes — QEMU boot harness | Safety |
| 07 | Debugging a boot: panics, QEMU's gdb stub and `vmlinux` | 2–3 sittings | yes — harness debug mode | Safety |

---

## 01 — Kernel trees and release lines

- **Objective:** Sam can name the kernel's release lines, say who maintains each and how often each moves, and read
  the current versions off kernel.org on the day.
- **Builds on:** tooling-04-git-for-patch-series lessons 01–02 (a tag names a commit; a branch moves); Sam's host,
  which runs an Ubuntu distribution kernel.
- **Key ideas:**
  - Mainline is Linus Torvalds' tree: a merge window of about two weeks, then weekly release candidates, with a new
    mainline release every 9–10 weeks.
  - Each mainline release then becomes a stable line; stable fixes are backported only once the fix (or an
    equivalent) is already in mainline, and stable updates come out as needed, usually weekly.
  - Longterm lines are chosen stable lines kept alive for years; each starts with a projected end of life of about two
    years that may be extended. On 27/09/2026 kernel.org listed 6.18, 6.12, 6.6, 6.1, 5.15 and 5.10.
  - A distribution kernel is recognisable by a suffix after the dash in `uname -r` and is supported by its distribution,
    not by kernel.org — the position Syntek OS takes on as a downstream.
  - Numbers go stale within a week: read them from `releases.json` on the day, never from a note.
- **Recall targets:** the route a fix takes from mainline into a stable or longterm line; why a longterm line suits a
  server; how to tell a distribution kernel from a kernel.org one.
- **Build:** none — Sam records the lines and the versions read on the day in the lesson note.
- **Sources:** kernel.org "Active kernel releases" (<https://www.kernel.org/category/releases.html>, the Longterm
  release kernels table and Releases FAQ, read 27/09/2026); <https://www.kernel.org/releases.json>; "Everything you
  ever wanted to know about Linux -stable releases" (<https://docs.kernel.org/process/stable-kernel-rules.html>, "Rules
  on what kind of patches are accepted"); "How the development process works"
  (<https://docs.kernel.org/process/2.Process.html>, 2.1 The big picture).
- **Done when:** Sam states the three lines and their cadence unaided, then reads today's versions from
  <https://www.kernel.org/releases.json> and says which line a server profile would follow and why
  (kernel-04-kconfig-and-profile-configs lesson 04 revisits the choice per profile).

## 02 — A pinned, verified source tree outside the repository

- **Objective:** Sam can fetch a named kernel release, prove it is the one its maintainers signed, and find his way
  around the top-level directories.
- **Builds on:** lesson 01; tooling-04-git-for-patch-series lessons 01–02 (clones, tags); sec-05-applied-cryptography
  if already taken (signatures), otherwise the signature is used as a black box here.
- **Key ideas:**
  - Two routes: a release tarball with its detached OpenPGP signature, or a git clone of the stable tree checked out at
    a signed tag. Either way the version is pinned, and the pin is written into the milestone's `KERNEL-PLAN`.
  - kernel.org signs every release; the signature is checked against the decompressed `.tar`, and kernel.org publishes
    its developers' keys through a Web Key Directory, with trust-on-first-use as the documented shortcut.
  - The tree lives **outside** this repository, and source trees, build output and images are never committed.
  - A first tour: arch/, init/, kernel/, mm/, fs/, drivers/, include/, scripts/, usr/,
    Documentation/ and kernel/configs/; `make help` lists every target.
  - Host prerequisites come from the tree's own Documentation/process/changes.rst: v7.2 asks for GNU C 8.1, GNU make
    4.0, flex 2.5.35, bison 2.0, Python 3.9 and pahole 1.26 (the pahole minimum is open for this host: `GAPS.md` →
    "pahole minimum for P4 is unclear").
- **Recall targets:** what a detached signature proves and what it does not; why a tree that fails verification is
  never built; where in the tree a given subsystem lives.
- **Build:** none — the fetch and verification steps become `how-to/workflows/07-kernel-source-setup/`
  (planned — added at P4), and the chosen version goes into the milestone's `KERNEL-PLAN` in
  `project-management/src/06-KERNEL/`.
- **Security lens:** supply chain — build only what verifies; record the tag, the commit and the key fingerprint used.
- **Sources:** kernel.org "Signatures" (<https://www.kernel.org/category/signatures.html>, "Using GnuPG to verify kernel
  signatures"); the admin-guide README (<https://docs.kernel.org/admin-guide/README.html>, "Installing the kernel
  source" and "Software requirements");
  "Minimal requirements to compile the kernel" at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/Documentation/process/changes.rst?h=v7.2>,
  "Current Minimal Requirements"); `man git-verify-tag`.
- **Done when:** a pinned tree sits outside the repository, its tag or tarball verified, and Sam can say where the
  scheduler, the memory manager and the kernel's config fragments live.

## 03 — Configuring: defconfig, tinyconfig and config fragments

- **Objective:** Sam can produce a `.config` three ways — from the architecture's defconfig, from `tinyconfig`, and by
  merging a fragment on top — and explain what each target did to the file.
- **Builds on:** lesson 02; tooling-03-shell-scripting (reading the `make` recipes that drive Kconfig).
- **Key ideas:**
  - The `.config` in the build directory is the product; every configuration target reads or rewrites it.
  - `make defconfig` starts from arch/x86/configs/x86_64_defconfig; `make tinyconfig` is `allnoconfig` seeded with
    kernel/configs/tiny-base.config, then the `tiny.config` fragment.
  - `make <name>.config` merges a fragment from kernel/configs/ or arch/x86/configs/ into the current `.config`
    with the tree's scripts/kconfig/merge_config.sh (its `-m` option), then runs `olddefconfig`;
    `kvm_guest.config` is the fragment for booting as a KVM guest (serial 8250 console, virtio, PCI).
  - `menuconfig` (and its `/` search) is for exploring and reading help text; `savedefconfig` writes the minimal
    difference from defaults; `olddefconfig` answers new symbols with their defaults.
  - A symbol asked for in a fragment can fail to stick when its dependencies are not met; the method for catching that
    belongs to kernel-04-kconfig-and-profile-configs lesson 02.
- **Recall targets:** which file each of the targets above starts from; what `make kvm_guest.config` changes in an
  existing `.config`; why a committed fragment plus a recorded base is reproducible and a hand-edited `.config` is not.
- **Build:** a small config fragment for booting under QEMU — serial console, initramfs support and the other options
  the harness needs, one comment per line saying why — in `code/src/kernel/msNNN-qemu-config/` (planned — added at
  P4). Checked by merging it onto a recorded base (defconfig or tinyconfig) and showing with scripts/diffconfig that
  every changed symbol is either in the fragment or a default or dependency it brought in, each explained; it is the
  "committed config fragment applied on a recorded base" the P4 exit gate in
  `project-management/src/01-ROADMAP/ROADMAP.md` names.
- **Sources:** the admin-guide README (<https://docs.kernel.org/admin-guide/README.html>, "Configuring the
  kernel"); "Configuration targets and editors" (<https://docs.kernel.org/kbuild/kconfig.html>, "General" and
  "Environment variables");
  scripts/kconfig/Makefile at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/kconfig/Makefile?h=v7.2>, the
  `%.config` and `tinyconfig` rules); kernel/configs/kvm_guest.config at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/kernel/configs/kvm_guest.config?h=v7.2>).
- **Done when:** Sam produces all three configurations, explains each target's effect from memory, and the fragment
  merges onto its recorded base with a `diffconfig` output he can justify line by line.

## 04 — Building out of tree with `O=`

- **Objective:** Sam can build a kernel into a separate output directory and say what `bzImage` and `vmlinux` are and
  which one each later step needs.
- **Builds on:** lesson 03; the P1 `make` lessons (`code/docs/BUILD.md`).
- **Key ideas:**
  - `O=<dir>` puts every output file, `.config` included, in another directory, and has to be given on **every** call.
  - `bzImage` (in the output's arch/x86/boot/) is the compressed, bootable image QEMU loads; `vmlinux` is the
    uncompressed ELF with symbols that gdb reads.
  - `-j` uses this machine's 16 hardware threads; `V=1` prints every command, `V=2` the reason each target rebuilt.
  - Build output is never committed; the build directory lives beside the source tree, outside the repository.
- **Recall targets:** what goes wrong when `O=` is dropped halfway; which artefact QEMU boots and which one gdb loads.
- **Build:** none — the commands and results go into the milestone's `KERNEL-IMPL` record ("Build").
- **Efficiency lens:** time a defconfig build and a tinyconfig-plus-fragment build with `/usr/bin/time -v`, and compare
  `ls -l` of each `bzImage` and `size` of each `vmlinux`; record budget against measured in the record.
- **Sources:** the admin-guide README (<https://docs.kernel.org/admin-guide/README.html>, "Build directory for
  the kernel" and "Compiling the kernel"); "Kbuild" (<https://docs.kernel.org/kbuild/kbuild.html>,
  KBUILD_OUTPUT); `man 1 time`; `man 1 size`.
- **Done when:** two builds from the same tree into two output directories succeed, and Sam explains from memory why
  both artefacts exist and what the measured size and time difference came from.

## 05 — A busybox initramfs by hand

- **Objective:** Sam can build a minimal initramfs — a statically linked busybox and an `/init` script packed as a
  `newc` cpio archive — and explain what the kernel does with it at boot.
- **Builds on:** lesson 04; tooling-03-shell-scripting; P2 processes (`execve`, PID 1 is just the first process).
- **Key ideas:**
  - The kernel unpacks a cpio archive into rootfs and, if `/init` exists, runs it as PID 1; the program is not
    expected to return, and the kernel panics if PID 1 exits.
  - The archive uses cpio's `newc` format; the kernel carries its own extractor, and `CONFIG_INITRAMFS_SOURCE` with
    usr/gen_init_cpio builds one without external cpio at all.
  - busybox has to be statically linked (the host's `busybox-static` package provides one) because the archive holds
    no shared libraries; its applets appear as links to the one binary.
  - `/init` mounts `proc`, `sysfs` and `devtmpfs` itself before anything else can rely on them.
  - `rdinit=/bin/sh` on the kernel command line replaces `/init` — the initramfs twin of `init=/bin/sh` for debugging.
- **Recall targets:** what happens when `/init` is missing, not executable, or exits; why busybox must be static; what
  `newc` is and why the kernel chose cpio over tar.
- **Build:** a script that stages busybox and an `/init` into a scratch directory outside git and packs the archive,
  in `code/src/kernel/msNNN-qemu-harness/` (planned — added at P4). Checked by listing the archive with `cpio -t` and by
  booting it in lesson 06; the staging directory and the archive itself are never committed.
- **Security lens:** `/init` runs as root in the guest — the script packs only what it staged, with root ownership
  set explicitly, and nothing from Sam's home directory.
- **Safety:** the archive boots in QEMU only; no host disk is touched.
- **Sources:** "Ramfs, rootfs and initramfs" (<https://docs.kernel.org/filesystems/ramfs-rootfs-initramfs.html>,
  "What is initramfs?", "Populating initramfs", "Contents of initramfs" and "Why cpio rather than tar?"); "Early
  userspace support" (<https://docs.kernel.org/driver-api/early-userspace/early_userspace_support.html>);
  init/main.c at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/init/main.c?h=v7.2>, the `/init` default
  and the "No working init found" panic) and kernel/exit.c at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/kernel/exit.c?h=v7.2>, the panic when
  PID 1 exits); `man 1 cpio`; BusyBox (<https://busybox.net/>).
- **Done when:** the archive lists the expected files, and Sam predicts correctly, before booting, what the kernel will
  print for a missing `/init`.

## 06 — Booting in QEMU on a serial console

- **Objective:** Sam can boot his kernel and initramfs in QEMU with no disk and no network, reach the busybox shell on
  the serial console, and end the run cleanly — by hand, then from a script.
- **Builds on:** lessons 04 and 05; P2 processes and exit status.
- **Key ideas:**
  - QEMU's direct Linux boot: `-kernel` for the image, `-initrd` for the archive, `-append` for the command line.
  - `console=ttyS0` sends kernel messages to the first serial port; `-nographic` connects that port and QEMU's monitor
    to the terminal through QEMU's multiplexer (`Ctrl+a x` exits, `Ctrl+a c` switches between console and monitor).
  - `-nic none` gives the guest no network device, and with no `-drive` option no disk image is attached.
  - For scripted runs, `panic=-1` reboots at once on a panic and `-no-reboot` turns that reboot into QEMU exiting, so
    a script sees the failure; `-enable-kvm` uses hardware virtualisation (Sam's user is in the `kvm` group).
  - This harness is what os-04-lfs-base-system and os-06-init-and-services reuse.
- **Recall targets:** what each QEMU option above contributes; what the guest can and cannot reach; how the script
  tells a successful boot from a panic or a hang.
- **Build:** a boot script beside the initramfs builder in `code/src/kernel/msNNN-qemu-harness/` (planned — added at
  P4) that takes a `bzImage` and an archive, boots them with a serial console and exits non-zero on a panic or a
  timeout. Checked by an interactive boot to the busybox shell and by a scripted boot whose `/init` powers the guest
  off, returning 0; `how-to/workflows/08-build-and-boot-kernel/` (planned — added at P4) cites it.
- **Safety:** QEMU only, never the host kernel; no host disks and no network in the guest; nothing installed on the
  host (`.claude/CLAUDE.md` → non-negotiables).
- **Sources:** QEMU "Direct Linux Boot" (<https://www.qemu.org/docs/master/system/linuxboot.html>), "Keys in the
  character backend multiplexer" (<https://www.qemu.org/docs/master/system/mux-chardev.html>) and
  `qemu-system-x86_64 -help` (QEMU 8.2.2 on the host: `-kernel`, `-initrd`, `-append`, `-nographic`, `-nic none`,
  `-no-reboot`, `-enable-kvm`); "The kernel's command-line parameters"
  (<https://docs.kernel.org/admin-guide/kernel-parameters.html>, `console=`, `panic=`, `rdinit=`); "Linux Serial
  Console" (<https://docs.kernel.org/admin-guide/serial-console.html>).
- **Done when:** the interactive boot reaches a shell, the scripted boot returns 0 on success and non-zero on a
  deliberately broken archive, and the QEMU command and a serial-console excerpt are in the milestone's `KERNEL-IMPL`.

## 07 — Debugging a boot: panics, QEMU's gdb stub and `vmlinux`

- **Objective:** Sam can read a boot failure from its console messages, and attach gdb to a kernel frozen at start-up
  to break in and backtrace kernel code.
- **Builds on:** lesson 06; the P1 gdb lessons (`code/docs/DEBUGGING.md` Sections 1–2).
- **Key ideas:**
  - A panic names its cause: for example "No working init found" when neither `/init` nor a fallback init could run.
  - `initcall_debug` traces every initcall as it runs, which shows where a boot stops; `printk.time=1` timestamps
    each line.
  - `-s` is shorthand for `-gdb tcp::1234`, and with no host given QEMU listens on all interfaces, so the stub (full
    control of the guest's CPU and memory) is reachable from the home network; this harness uses
    `-gdb tcp:127.0.0.1:1234` (or `-gdb unix:<path>,server=on,wait=off`) with `-S`, which freezes the CPU until gdb
    continues. gdb then loads `vmlinux` and connects with `target remote 127.0.0.1:1234`.
  - The kernel's gdb guide asks for debug information with `CONFIG_DEBUG_INFO_REDUCED` off, `CONFIG_GDB_SCRIPTS` on,
    frame pointers where supported, and `nokaslr` (or `CONFIG_RANDOMIZE_BASE` off) so symbols match addresses.
  - The `lx-` helpers from `vmlinux-gdb.py` (`lx-dmesg`, `lx-symbols`) read kernel state from gdb; gdb may need
    `add-auto-load-safe-path` before it loads them.
- **Recall targets:** what a given panic line says went wrong; why KASLR breaks symbol lookup; what `-s` and `-S` each
  do, and why bare `-s` is unsafe on a networked host.
- **Build:** a debug mode for the harness (start frozen with the gdb server) in `code/src/kernel/msNNN-qemu-harness/`
  (planned — added at P4), exercised on two failures Sam introduces on purpose — a broken `/init` and a breakpoint
  in a named kernel function. Checked by the diagnosis and a gdb backtrace recorded in the milestone's `KERNEL-IMPL`
  ("Debugging evidence").
- **Safety:** the gdb stub is bound explicitly to 127.0.0.1 (or a Unix socket), never bare `-s`, which listens on
  every interface; nothing runs on the host kernel.
- **Sources:** "Debugging kernel and modules via gdb"
  (<https://docs.kernel.org/process/debugging/gdb-kernel-debugging.html>, "Requirements", "Setup" and "Examples of
  using the Linux-provided gdb helpers"); QEMU "GDB usage" (<https://www.qemu.org/docs/master/system/gdb.html>);
  "Bug hunting" (<https://docs.kernel.org/admin-guide/bug-hunting.html>); kernel parameters
  (<https://docs.kernel.org/admin-guide/kernel-parameters.html>, `initcall_debug`, `printk.time=`, `nokaslr`); house
  guide `code/docs/DEBUGGING.md` Section 6.
- **Done when:** Sam diagnoses both planted failures from evidence, not guesses, and the backtrace and the exact QEMU
  and gdb commands are in the record.
