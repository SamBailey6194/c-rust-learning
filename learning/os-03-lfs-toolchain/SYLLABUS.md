# Syllabus — os-03-lfs-toolchain

**Track**: os · **Phase**: P6 · **Path**: Core · **Detail**: full · **Prerequisites**: os-01 (lessons 03–04: the toolchain and ELF); os-02 (lessons 02–04: images, partitions, filesystems); tooling-03-shell-scripting
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The first build from scratch on the way to Syntek OS: Linux From Scratch's cross toolchain and temporary tools,
following the LFS 13.1-systemd book (published 01/09/2026) inside a dedicated VM. It teaches why LFS cross-compiles
even for the same machine — so nothing built can depend on the host — and how to read any upstream build, which every
Syntek OS recipe (os-05) will automate. It ends inside the chroot, ready for the base system in os-04. The build runs
in a VM on a QEMU disk image, never on the host's disks (`GAPS.md` → "A VM with spare disk for the LFS build"); nothing
it produces is committed — the repository keeps Sam's notes, versions and timings.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Host requirements and a safe build environment | 2–3 sittings | yes — the LFS build VM | Efficiency, Security, Safety |
| 02 | Build, host and target triplets, and the sysroot | 1 sitting | no | — |
| 03 | Reading an upstream build: configure, make, DESTDIR, meson and ninja | 2–3 sittings | yes — staged installs | Safety |
| 04 | The cross toolchain, pass 1 | multi-session build | yes — LFS chapter 5 | Efficiency, Safety |
| 05 | Temporary tools, and why cross-compiling isolates the host | multi-session build | yes — LFS chapter 6 | Safety |
| 06 | Entering the chroot | 2–3 sittings | yes — LFS chapter 7 | Security, Safety |

---

## 01 — Host requirements and a safe build environment

- **Objective:** Sam can prepare a build VM that meets LFS 13.1's host requirements, create the LFS partition inside
  its disk image, and set up the unprivileged `lfs` user and environment — and explain why each step protects the
  system doing the building.
- **Builds on:** os-02 lessons 02–04 (images, partitions, filesystems); tooling-03 (shell environments).
- **Key ideas:**
  - LFS 13.1 lists minimum host tool versions and warns that GCC newer than 16.2.0 or binutils newer than 2.47 are
    untested; its `version-check.sh` checks them and that `/bin/sh` is bash.
  - Chapters 5 and 6 run as the unprivileged `lfs` user; running them as root risks installing into the host and
    breaking it (Section 2.3.2).
  - The environment is deliberately clean: `set +h` turns off bash's command hashing, `umask 022`, `LC_ALL=POSIX`,
    `LFS_TGT`, and `$LFS/tools/bin` first on `PATH` (Section 4.4).
  - The whole build lives in a VM whose disk is a qcow2 image, so a mistake costs a snapshot restore, not the host.
  - The SBU (Standard Build Unit) is the time for the first package; later packages are quoted as multiples of it.
- **Recall targets:** why the build user is not root; what each line of the environment file prevents; what the host
  requirements check and why the kernel version matters to glibc.
- **Build:** the LFS build VM — a VM installed from a mainstream distribution on a qcow2 image, with a second image
  (or partition) for `$LFS`, a snapshot taken before chapter 5, and `version-check.sh` passing inside it. The VM and
  its images live outside the repository; the planned `how-to/workflows/10-lfs-build-vm/` (planned — added at P6)
  will write the procedure down. Checked by the recorded `version-check.sh` output and `qemu-img snapshot -l`.
- **Efficiency lens:** record the SBU in the VM (the time for binutils pass 1) and the VM's cores and memory, so later
  build times are comparable.
- **Security lens:** the source tarballs are checked against the book's MD5 sums (Chapter 3) — integrity against
  corruption, not authenticity; sec-05 lesson 01 explains the difference.
- **Safety:** the VM only — never the host's disks, never `$LFS` on the host; `sudo` inside the VM is Sam's; Claude
  never runs `sudo` on the host.
- **Sources:** LFS 13.1-systemd (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/>) Sections 2.2 "Host System
  Requirements", 2.3 "Building LFS in Stages", 2.4 "Creating a New Partition", 2.6 "Setting the $LFS Variable and the
  Umask", 3.1 (package checksums), 4.3 "Adding the LFS User", 4.4 "Setting Up the Environment", 4.5 "About SBUs";
  `man 1 qemu-img` (`snapshot`).
- **Done when:** the VM passes `version-check.sh`, the `lfs` user's environment matches Section 4.4, a pre-build
  snapshot exists, and Sam explains why chapters 5–6 must not run as root.

## 02 — Build, host and target triplets, and the sysroot

- **Objective:** Sam can name the build, host and target machine for each LFS toolchain stage, read a system triplet,
  and explain what `--with-sysroot` does for the cross linker and compiler.
- **Builds on:** lesson 01; os-01 lessons 03–04 (the toolchain; the dynamic loader).
- **Key ideas:**
  - In build-system terms the build is where compilation runs, the host is where the result runs, and the target
    (compilers only) is what the compiler emits code for.
  - A triplet is `cpu-vendor-kernel-os` (for example `x86_64-pc-linux-gnu`); LFS changes the vendor to `lfs` to make
    a cross toolchain even though the CPU is the same.
  - Passing `--host` and an explicit, different `--build` puts autoconf into cross-compilation mode, so the build never
    runs code meant for the new system.
  - `--with-sysroot` tells the cross linker and compiler where the new system's headers and libraries live, so
    nothing links against the host's.
  - `gcc -dumpmachine` prints a compiler's triplet; `readelf -l <binary> | grep interpreter` shows the loader it
    expects.
- **Recall targets:** build, host and target for each of LFS's three toolchain stages; what `LFS_TGT` expands to on
  x86-64; the risk `--with-sysroot` removes.
- **Build:** none — Sam predicts `LFS_TGT` and the interpreter of a chapter 6 binary, then checks both in lessons 04–05.
- **Sources:** LFS 13.1-systemd "Toolchain Technical Notes", "About Cross-Compilation" and "Implementation of
  Cross-Compilation for LFS"
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/partintro/toolchaintechnotes.html>);
  GCC "Installing GCC: Configuration" (<https://gcc.gnu.org/install/configure.html>, `--with-sysroot`, build, host and
  target).
- **Done when:** Sam fills in the build/host/target table for LFS's stages from memory and explains why a native
  build is still done as a cross build.

## 03 — Reading an upstream build: configure, make, DESTDIR, meson and ninja

- **Objective:** Sam can build an autotools package and a meson package from their release tarballs, install each
  into a staging directory with `DESTDIR`, and read what each step decided.
- **Builds on:** lesson 02; P1 make (`code/docs/BUILD.md` Sections 1 and 3).
- **Key ideas:**
  - `./configure` probes the system and writes Makefiles; `--prefix` says where the software will live, not where
    `make install` writes today.
  - `make DESTDIR=<staging> install` prefixes every installed path with the staging directory — the basis of package
    building (Automake's "Staged Installs"; LFS Section 8.2.2.3).
  - Meson configures a separate build directory (`meson setup`) and generates Ninja files; `ninja` builds and
    `DESTDIR=<staging> meson install` (or `--destdir`) stages the result.
  - LFS's general instructions: extract with `tar` as the build user (copying a tree with `cp -R` can wreck its
    timestamps), build inside it, delete it afterwards, and re-extract after any doubt (Section 2.3.2).
  - A package's own test suite (`make check`, `ninja test`) is part of reading the build; LFS points to its build
    logs to tell expected failures from real ones (Section 4.6).
- **Recall targets:** what `--prefix` and `DESTDIR` each change; where Meson's output goes and why; how to tell from
  the staged tree what a package installs.
- **Build:** inside the build VM, stage one autotools package (M4, the first package in LFS chapter 6) and one small
  meson package into staging directories as an unprivileged user, and list each staged tree. Meson and Ninja come from
  the VM's own distribution — neither is installed on this host (checked 27/09/2026). Checked by the listings in the
  note and by showing that nothing was written outside the staging directory.
- **Safety:** unprivileged user in the VM; never `make install` without `DESTDIR` at this stage.
- **Sources:** GNU Automake manual, Section 12.4 "Staged Installs" (automake 1.16, `info automake` on the host; the
  gnu.org copy timed out on 27/09/2026); LFS 13.1-systemd "General Compilation Instructions"
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/partintro/generalinstructions.html>), Section 4.6 "About
  the Test Suites" and Section 8.2.2.3 "Symlink Style Package Management"; Meson "Quickstart Guide"
  (<https://mesonbuild.com/Quick-guide.html>) and "Installing", "DESTDIR support"
  (<https://mesonbuild.com/Installing.html>); The Ninja build system manual (<https://ninja-build.org/manual.html>).
- **Done when:** both staged trees are listed in the note, and Sam predicts where a given file will land for a given
  `--prefix` and `DESTDIR`.

## 04 — The cross toolchain, pass 1

- **Objective:** Sam can build LFS 13.1's cross toolchain in the book's order — binutils 2.47 pass 1, GCC 16.2.0 pass
  1, the Linux 7.1.8 API headers, glibc 2.44 and libstdc++ — and explain why the order is forced.
- **Builds on:** lessons 01–03.
- **Key ideas:**
  - Binutils comes first, because both GCC and glibc test the available linker and assembler to decide which of
    their own features to enable.
  - GCC pass 1 is a deliberately reduced compiler: its libgcc lacks threads and exception handling because glibc,
    which they need, does not exist yet.
  - The Linux API headers (`make headers`) describe the kernel's user-space interface for glibc to build against;
    they are not the kernel.
  - glibc is then built with the cross compiler, and a sanity check links a test program and confirms its interpreter
    is `/lib64/ld-linux-x86-64.so.2` — proof the toolchain targets the new system.
  - libstdc++ comes last, once glibc exists to link it against.
- **Recall targets:** the chapter 5 order and the dependency that forces each step; what GCC pass 1 leaves out and
  why; what the glibc sanity check proves.
- **Build:** LFS chapter 5 in the build VM, following the book exactly, with a snapshot after each package. Checked by
  the book's sanity check output recorded in the note and by the per-package build times.
- **Efficiency lens:** record each package's build time in SBUs and the disk used by `$LFS` after the chapter
  (`du -sh`), against the book's estimates.
- **Safety:** as lesson 01 — the `lfs` user in the VM only.
- **Sources:** LFS 13.1-systemd Chapter 5
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/introduction.html>),
  Sections 5.2 "Binutils-2.47 - Pass 1", 5.3 "GCC-16.2.0 - Pass 1", 5.4 "Linux-7.1.8 API Headers", 5.5 "Glibc-2.44"
  (the sanity check) and 5.6 "Libstdc++ from GCC-16.2.0"; "Toolchain Technical Notes" (the libgcc and glibc
  chicken-and-egg).
- **Done when:** the sanity check passes, and Sam explains the chapter 5 order without the book.

## 05 — Temporary tools, and why cross-compiling isolates the host

- **Objective:** Sam can cross-compile LFS chapter 6's temporary tools and show, from the binaries themselves, that
  they depend on the new system and not on the host.
- **Builds on:** lesson 04; os-01 lesson 04 (`readelf -d`, `NEEDED`, the interpreter).
- **Key ideas:**
  - Chapter 6 builds the basic utilities (M4, Ncurses, Bash, Coreutils and the rest, then binutils and GCC pass 2)
    with the cross toolchain, installing into `$LFS`.
  - Everything cross-compiled can only link against what is in the sysroot, so a missing dependency fails at build
    time instead of silently using the host's library.
  - LFS removes libtool archives (`.la` files) because libtool can otherwise lead the linker to the host's libraries.
  - GCC pass 2 is the last cross-compiled package; the book warns that installing it breaks the cross toolchain,
    which is expected.
- **Recall targets:** what stops a chapter 6 binary picking up a host library; why the `.la` files go; what GCC pass 2
  is for.
- **Build:** LFS chapter 6 in the build VM, with a snapshot at the end. Checked by `readelf -l` and `readelf -d` on two
  chapter 6 binaries (interpreter and `NEEDED` entries point into the new system), recorded in the note.
- **Safety:** as lesson 01.
- **Sources:** LFS 13.1-systemd Chapter 6
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/introduction.html>)
  and Section 6.18 "GCC-16.2.0 - Pass 2"; "Toolchain Technical Notes" (libtool and the sysroot); `man 1 readelf`.
- **Done when:** the chapter completes, and the recorded `readelf` output supports Sam's explanation of host
  isolation.

## 06 — Entering the chroot

- **Objective:** Sam can prepare the virtual kernel filesystems, enter the LFS chroot with a clean environment, build
  the remaining temporary tools, and save a backup of the temporary system.
- **Builds on:** lesson 05; os-01 lesson 02 (the hierarchy the chroot creates).
- **Key ideas:**
  - From chapter 7 the work runs as root inside the chroot, so `$LFS` is first handed to root (Section 7.2).
  - The chroot needs `/dev`, `/dev/pts`, `/proc`, `/sys` and `/run` from the kernel: LFS bind-mounts the host's
    `/dev` and mounts `devpts`, `proc`, `sysfs` and a `tmpfs` (Section 7.3).
  - `chroot "$LFS" /usr/bin/env -i ...` starts with an empty environment, so nothing leaks in from the host shell.
  - The chroot builds the essential directories and files, then the last temporary tools (Gettext, Bison, Perl, Zlib,
    mpdecimal, Python, Texinfo, Util-linux), and cleans up before chapter 8.
  - Section 7.15 backs up the temporary system from outside the chroot — the natural moment for a VM snapshot too.
- **Recall targets:** what each virtual filesystem is for inside the chroot; why the environment is emptied; what the
  chroot does not isolate.
- **Build:** LFS chapter 7 in the build VM, ending with the Section 7.15 backup and a VM snapshot. Checked by a working
  chroot shell, the backup archive's listing and the snapshot list.
- **Security lens:** a chroot changes only the root directory for path lookups; `chroot(2)` says it is not meant for
  any security purpose and a privileged process can escape it. Real isolation is namespaces and sandboxes (os-05,
  sec-04).
- **Safety:** every mount and the chroot happen inside the VM; the Section 7.15 warning (root commands that can modify
  the host) applies to the VM's own system, which is why the VM exists.
- **Sources:** LFS 13.1-systemd Chapter 7
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter07/introduction.html>),
  Sections 7.2 "Changing Ownership", 7.3 "Preparing Virtual Kernel File Systems", 7.4 "Entering the Chroot Environment"
  and 7.15 "Cleaning up and Saving the Temporary System"; `man 2 chroot` (NOTES).
- **Done when:** the backup and snapshot exist, and Sam explains, before running them, what each Section 7.3 mount
  provides.
