# Syllabus — os-01-anatomy-of-a-distro

**Track**: os · **Phase**: P6 · **Path**: Core · **Detail**: full · **Prerequisites**: P2 (C systems); tooling-03-shell-scripting (the host-side exercises are shell)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The first Syntek OS topic: before building a distribution from scratch, Sam takes one apart on paper. It maps the
boot chain, the directory layout every package relies on, the toolchain that produces every binary, and the parts that
make a distribution independent rather than derived — the package format, build system, repositories and release
process — by studying four independent distributions. It ends where Syntek OS's own design starts: borrowing ideas
(declarative configuration, reproducible builds, atomic rollback) without borrowing a base, as
`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md` records. Everything
here is reading and small host-side exercises; the first build from scratch is os-03-lfs-toolchain.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The boot chain, end to end | 1 sitting | no | — |
| 02 | The filesystem hierarchy | 1 sitting | no | — |
| 03 | The toolchain trio: C library, compiler, binutils | 1 sitting | no | Security |
| 04 | What a toolchain produces: ELF, static and shared libraries, sonames, the loader | 2–3 sittings | yes — shared-library | Security |
| 05 | What makes a distribution independent | 2–3 sittings | no | Security |
| 06 | Borrowing ideas without deriving | 1 sitting | no | — |

---

## 01 — The boot chain, end to end

- **Objective:** Sam can draw the chain from power-on to a login prompt — firmware, boot loader, kernel, initramfs,
  init, userland — and say what each stage hands to the next.
- **Builds on:** P2 processes (`fork`, `execve`, PIDs); Sam's everyday use of an Ubuntu host, observed read-only.
- **Key ideas:**
  - Firmware (BIOS or UEFI) finds a boot loader; the boot loader loads the kernel, passes it a command line and,
    optionally, an initramfs. The firmware and boot-loader details are os-02's.
  - The kernel unpacks the initramfs (a cpio archive) into rootfs and runs its `/init` as PID 1; without one it falls
    back to mounting the root device itself and running an init from there.
  - An initramfs exists to get the real root filesystem mounted, then hands over to the real init.
  - PID 1 brings userland up — systemd on this host and in the LFS 13.1-systemd book; os-06 teaches what PID 1 owes
    the system.
  - Observing without changing anything: `/proc/cmdline` shows what the boot loader passed; `systemd-analyze time`
    shows how long each stage took on the host.
- **Recall targets:** the stages in order and what each needs from the one before; what the kernel does when the
  initramfs has no `/init`; where the kernel command line comes from.
- **Build:** none — a labelled diagram of the chain in the concept note (a `text` block).
- **Sources:** `man 7 boot` and `man 7 bootup` (man-pages 6.7 and systemd 255 on the host); "Ramfs, rootfs and
  initramfs", section "What is initramfs?" (<https://docs.kernel.org/filesystems/ramfs-rootfs-initramfs.html>,
  docs.kernel.org 7.3.0-rc4, read 27/09/2026); "The Linux/x86 Boot Protocol"
  (<https://docs.kernel.org/arch/x86/boot.html>; reference, optional — a dense specification, not beginner reading);
  "Explaining the 'No working init found.' boot hang message" (<https://docs.kernel.org/admin-guide/init.html>);
  `man 1 systemd-analyze` (`time`).
- **Done when:** Sam draws the chain unaided and predicts where a boot stops for three faults: no boot-loader entry
  for the kernel; an initramfs with no `/init` and no usable `root=`; and the real root's init missing, which ends in
  "No working init found" (admin-guide/init.html).

## 02 — The filesystem hierarchy

- **Objective:** Sam can place any file a distribution installs in its directory and justify the choice by the
  Filesystem Hierarchy Standard's two distinctions.
- **Builds on:** lesson 01; daily Linux use.
- **Key ideas:**
  - FHS 3.0 sorts files on two independent axes — shareable or unshareable, static or variable — so that files used
    differently can live on different filesystems.
  - `/usr` is shareable, read-only data; `/etc` is host-specific configuration; `/var` holds variable state, logs and
    caches; `/run` holds run-time data; `/opt` holds add-on packages; `/srv` holds data a service provides.
  - LFS 13.1 makes `/bin`, `/lib` and `/sbin` symbolic links into `/usr` (a merged `/usr`, Section 4.2), so all
    installed programs and libraries live under one tree.
  - FHS 3.0 dates from 2015; `hier(7)` and systemd's `file-hierarchy(7)` describe the layout current systems use.
  - The layout is a contract: packages install into it, and upgrades and backups must treat `/etc` and `/var`
    (configuration and state) differently from `/usr` (replaceable).
  - `/dev` (device nodes, provided by the kernel's devtmpfs), `/proc` and `/sys` are kernel-provided virtual
    filesystems, not files a package installs (`hier(7)`, `proc(5)`, `sysfs(5)`).
- **Recall targets:** where configuration, logs, a package manager's database and a service's data belong; why `/usr`
  can be mounted read-only; what a merged `/usr` changes; why no package ships files under `/proc` or `/sys`.
- **Build:** none.
- **Sources:** FHS 3.0, Chapters 2–5 (<https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html>); `man 7 hier`
  and `man 7 file-hierarchy` (host); LFS 13.1-systemd Section 4.2, "Creating a Limited Directory Layout in the LFS
  Filesystem" (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter04/creatingminlayout.html>);
  `man 8 pacman` (`--dbpath`, default `/var/lib/pacman`, as one real example).
- **Done when:** Sam sorts a dozen paths from a real package's file list into their directories and names the axis
  that decided each one.

## 03 — The toolchain trio: C library, compiler, binutils

- **Objective:** Sam can say what the C library, the compiler and binutils each contribute to a running system, and
  name concrete glibc-versus-musl differences that would shape a Syntek OS choice.
- **Builds on:** P1–P2 (Sam compiles with gcc 13.3 every day); `code/docs/BUILD.md` Section 1.
- **Key ideas:**
  - The C library wraps the system calls and provides the standard library; it also ships the dynamic loader
    (`ld-linux-x86-64.so.2` for glibc on x86-64). LFS uses glibc and names musl as the alternative.
  - musl documents where it behaves differently from glibc: no lazy binding, `dlclose` does not unload, and a
    default thread stack of 128 KiB. Software written against glibc can trip on each.
  - The compiler (GCC, or Clang) turns C into assembly; binutils (`as`, `ld`, `ar`, `objdump`, `readelf`, `strip`)
    assemble, link and inspect the result.
  - Independent distributions choose differently: Alpine and Void's musl variant against Arch and LFS on glibc.
    glibc or musl is an open Syntek OS decision on the Syntek OS map (Frontier).
  - `gcc -dumpmachine` prints the system triplet; os-03 teaches triplets properly.
- **Recall targets:** which component provides `printf`, which one links, which one loads shared libraries at run
  time; two musl differences that break software written for glibc.
- **Build:** none — Clang is not installed on the host (checked 27/09/2026), so the comparison is reading plus `gcc -v`
  and `ld --version` run on the host.
- **Security lens:** hardening defaults come from how the toolchain and packages are built — Alpine states that all
  its userland binaries are position-independent executables with stack-smashing protection; sec-02 teaches what
  each mitigation stops.
- **Sources:** musl (<https://musl.libc.org/>) and "Functional differences from glibc", sections "Lazy bindings",
  "Unloading libraries" and "Thread stack size" (<https://wiki.musl-libc.org/functional-differences-from-glibc.html>);
  The GNU C Library manual (<https://sourceware.org/glibc/manual/latest/html_node/index.html>); GCC online docs
  (<https://gcc.gnu.org/onlinedocs/>); Clang User's Manual (<https://clang.llvm.org/docs/UsersManual.html>); GNU
  Binutils docs (<https://sourceware.org/binutils/docs/>); LFS 13.1-systemd "Toolchain Technical Notes"
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/partintro/toolchaintechnotes.html>); Alpine Linux
  "About" (<https://www.alpinelinux.org/about/>, "Secure").
- **Done when:** given a program that fails only on musl, Sam names the component responsible and the documented
  difference that explains it.

## 04 — What a toolchain produces: ELF, static and shared libraries, sonames, the loader

- **Objective:** Sam can build a C library as both a static archive and a shared object with a soname, inspect the
  results with `readelf`, `nm` and `objdump`, and predict how the dynamic loader finds the library at run time.
- **Builds on:** lesson 03; P1 multi-file programs and make; `code/docs/BUILD.md` Section 1 (from source to binary).
- **Key ideas:**
  - Executables, shared objects and object files are all ELF; the program headers tell the kernel how to load a file
    and name its interpreter (the dynamic loader).
  - A static archive (`.a`) is copied into the program at link time; a shared object (`.so`) is loaded at run time and
    shared between processes.
  - The linker records a `DT_SONAME` in a shared object (`-soname`); a program linked against it records that name
    in a `DT_NEEDED` entry, and `ldconfig` maintains the soname symlinks. A soname change is an ABI break — the reason
    LFS 8.2.1 says to rebuild every dependant when `libfoo.so.1` becomes `libfoo.so.2`.
  - The loader's search order: `DT_RPATH` (deprecated), `LD_LIBRARY_PATH`, `DT_RUNPATH`, `/etc/ld.so.cache`, then
    the default directories; `LD_LIBRARY_PATH` is ignored in secure-execution mode.
  - `readelf -d` and `objdump -p` read the dynamic section without running anything.
- **Recall targets:** what `DT_NEEDED`, `DT_SONAME` and `DT_RUNPATH` each record; where the loader looks, in order;
  what breaks, and when, if a library's soname changes without a rebuild.
- **Build:** a small C library with one function, built as a static archive and as a shared object with a soname, and
  a program linked against each, in `code/src/c/msNNN-shared-library/` (planned code path; the exercise pattern is
  `code/src/c/ms001-hello/`, and the Makefile changes for a `.so` are part of the exercise spec). Checked by the
  exercise's `make test`, `san` and `memcheck`, plus a recorded `readelf -d` excerpt showing the expected `SONAME`
  and `NEEDED` entries; the note predicts the loader's behaviour with the library moved, then confirms it.
- **Security lens:** `ldd` may execute the program it inspects in some circumstances (`man 1 ldd`, "Security"), so
  untrusted binaries are inspected with `readelf -d` or `objdump -p` only; secure-execution mode is why a setuid
  program ignores `LD_LIBRARY_PATH`.
- **Sources:** `man 5 elf`, `man 8 ld.so` ("When resolving shared object dependencies"), `man 8 ldconfig`, `man 1 ld`
  (`-soname`, `-rpath`), `man 1 readelf`, `man 1 nm`, `man 1 objdump`, `man 1 ldd` (binutils 2.42, glibc 2.39 and
  man-pages 6.7 on the host); GCC "Options for Linking" (<https://gcc.gnu.org/onlinedocs/gcc/Link-Options.html>,
  `-shared`); Ulrich Drepper, "How To Write Shared Libraries" (10/12/2011, the ABI-versioning section,
  <https://akkadia.org/drepper/dsohowto.pdf>); LFS 13.1-systemd Section 8.2.1, "Upgrade Issues"
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/pkgmgt.html>).
- **Done when:** the exercise passes its gates, and Sam predicts correctly — before running it — what the loader does
  when the shared object is missing, then when `LD_LIBRARY_PATH` points at it.

## 05 — What makes a distribution independent

- **Objective:** Sam can name the parts a distribution must own to be independent — package format and manager, build
  system, repositories and signing, release process — and compare how Arch, Alpine, Void and Gentoo own each.
- **Builds on:** lessons 01–04; Sam's own planning question about a "clean" distribution rather than a NixOS fork.
- **Key ideas:**
  - Independent means owning every layer above the kernel, not writing the kernel: Syntek OS runs a downstream of
    upstream Linux (the kernel track).
  - Arch: rolling release, pacman, PKGBUILDs built with makepkg, software shipped close to upstream with few
    downstream patches.
  - Alpine: musl and BusyBox, the apk package manager and OpenRC; apk packages are gzip-streamed tar segments whose
    signature covers the control segment.
  - Void: rolling, independent, XBPS, runit, and musl offered as a second libc beside glibc.
  - Gentoo: Portage builds from source (ebuilds and USE flags) or installs binary packages.
  - The cost is maintenance: every package, security fix and release is the distribution's own work.
- **Recall targets:** for each of the four, its package manager, init and C library; what "independent" demands that
  a derivative gets for free.
- **Build:** none — a comparison table in the concept note, one row per distribution and one column per part owned.
- **Security lens:** each package format carries its own trust model (who signs, what is signed); os-08 teaches
  repository signing, and this lesson only records how each distribution signs.
- **Sources:** ArchWiki "Arch Linux" (<https://wiki.archlinux.org/title/Arch_Linux>, "Principles", "History");
  `pacman(8)` 7.1.0 (<https://man.archlinux.org/man/pacman.8.en>); Alpine "About" (<https://www.alpinelinux.org/about/>)
  and "Apk spec" (<https://wiki.alpinelinux.org/wiki/Apk_spec>, Sections 1.1 "Tar Segments" and 2.1 "Binary Format");
  Void Linux Handbook "About" (<https://docs.voidlinux.org/about/index.html>); XBPS
  (<https://github.com/void-linux/xbps>); Gentoo wiki "Portage" (<https://wiki.gentoo.org/wiki/Portage>); LFS
  13.1-systemd Section 8.2, "Package Management"
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/pkgmgt.html>).
- **Done when:** Sam's table is complete and each cell cites the page it came from.

## 06 — Borrowing ideas without deriving

- **Objective:** Sam can explain three ideas Syntek OS takes from NixOS — declarative configuration, reproducible
  builds, atomic rollback — and say how each could be designed in from scratch without a Nix base.
- **Builds on:** lesson 05; Sam's own Nix experience (derivations and NixOS modules).
- **Key ideas:**
  - Declarative configuration: NixOS builds the system from its configuration file
    (`/etc/nixos/configuration.nix`), so the file, not a history of commands, describes the machine.
  - Reproducible builds: the same source, environment and instructions give bit-for-bit identical artefacts,
    verified by comparison — os-05 owns this.
  - Atomic rollback: NixOS keeps earlier system configurations, selectable from the boot menu or with
    `nixos-rebuild switch --rollback`.
  - The Nix thesis grounds these in a component store whose paths contain cryptographic hashes and whose components
    never change once built; Syntek OS can take the principle without the implementation (the independence ADR).
  - Each idea becomes a later lesson: rollback in os-07's transactions, the declarative file in os-10.
- **Recall targets:** each idea in one sentence, the Nix mechanism behind it, and the Syntek OS lesson that will build
  its equivalent.
- **Build:** none.
- **Sources:** Eelco Dolstra, "The Purely Functional Software Deployment Model" (PhD thesis, Utrecht University,
  18/01/2006, <https://edolstra.github.io/pubs/phd-thesis.pdf>); NixOS Manual 26.05, "Changing the Configuration" and
  "Rolling Back Configuration Changes" (<https://nixos.org/manual/nixos/stable/>); reproducible-builds.org
  "Definitions" (<https://reproducible-builds.org/docs/definition/>);
  `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md`.
- **Done when:** Sam writes, for each idea, the Nix mechanism and a from-scratch design sketch in two sentences each,
  and names the lesson that builds it.
