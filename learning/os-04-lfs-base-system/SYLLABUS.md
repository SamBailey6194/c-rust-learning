# Syllabus — os-04-lfs-base-system

**Track**: os · **Phase**: P6 · **Path**: Core · **Detail**: full · **Prerequisites**: os-03 (all lessons: the chroot and its backup); os-02 lessons 04–06 (filesystems, firmware, boot loaders); kernel-01 lessons 03–07 recommended for the kernel build and the QEMU boot, else LFS Section 10.3
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The second half of Linux From Scratch: from the temporary tools inside the chroot to a complete, bootable base system
that reaches a login prompt in QEMU. It follows the LFS 13.1-systemd book — the System V edition stays at LFS 12.4 and
is no longer maintained, so a Syntek OS that later chooses another init departs from the book at chapter 9
(os-06-init-and-services and the INIT-SYSTEM-CHOICE research note). The lessons that matter most for Syntek OS are the
ones about order, package management and what a bootable system needs; the hundreds of commands are the book's. All
work happens in the build VM from os-03; the booted system is a disk image that is never committed.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Building the base packages, and why the order matters | multi-session build | yes — LFS chapter 8 | Efficiency, Security, Safety |
| 02 | Package management the LFS way | 1 sitting | yes — per-package file lists | Security |
| 03 | System configuration with systemd | 2–3 sittings | yes — LFS chapter 9 | Security |
| 04 | Making it bootable: fstab, a kernel and GRUB | 2–3 sittings | yes — LFS chapter 10 | Security, Safety |
| 05 | First boot in QEMU | 1 sitting | yes — boot to login | Safety |
| 06 | Stripping, cleanup and snapshots | 1 sitting | yes — measured image | Efficiency |

---

## 01 — Building the base packages, and why the order matters

- **Objective:** Sam can build LFS chapter 8's base system in the book's order and explain, for any package, what it
  needs before it and what needs it after.
- **Builds on:** os-03 (the chroot and the temporary tools); os-01 lesson 04 (shared libraries and sonames).
- **Key ideas:**
  - Appendix C lists each package's build, run-time and test-suite dependencies, and the packages that must be built
    after it; some dependencies are circular, which is why the order is fixed.
  - The final glibc comes almost first (after only the man pages and the IANA data), then the libraries and tools
    later packages link against, with GCC after its own libraries (GMP, MPFR, MPC).
  - The book discourages static libraries: a security fix in one means relinking every program that embedded it, so
    most packages are configured with `--disable-static`.
  - Test suites matter most for the toolchain: the book calls glibc's test suite critical and never to be skipped,
    and points to its build logs to tell expected failures from real ones.
  - Custom optimisation flags are discouraged; the packages' own defaults already enable `-O2` or `-O3`.
- **Recall targets:** the four dependency kinds Appendix C lists; why GCC waits for GMP, MPFR and MPC; the security
  argument against static libraries.
- **Build:** LFS chapter 8 in the build VM, with a snapshot every few packages and after the toolchain. Checked by the
  sanity checks the book runs after installing GCC and by the test-suite summaries, recorded in the note with the build
  time of each package in SBUs.
- **Efficiency lens:** total chapter build time and peak disk use in the VM, measured, against the book's SBU and
  disk estimates.
- **Security lens:** a static library turns one security fix into many relinks — the reason Syntek OS packages will
  default to shared libraries too.
- **Safety:** inside the chroot in the build VM only.
- **Sources:** LFS 13.1-systemd Chapter 8
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/introduction.html>),
  Section 8.1 including 8.1.1 "About Libraries"; Appendix C "Dependencies"
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/appendices/dependencies.html>); Section 4.6 "About the
  Test Suites" (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter04/abouttestsuites.html>).
- **Done when:** the chapter completes with its toolchain checks passing, and Sam explains the position of three
  packages the tutor picks from Appendix C alone.

## 02 — Package management the LFS way

- **Objective:** Sam can explain the package-management techniques LFS surveys, pick one for his own build, and say
  what an upgrade breaks when a shared library's name changes.
- **Builds on:** lesson 01; os-01 lesson 04 (sonames); os-03 lesson 03 (`DESTDIR`).
- **Key ideas:**
  - LFS recommends no package manager and surveys techniques instead: everything in your head, separate directories,
    symlink style with `DESTDIR`, timestamps, tracing install scripts, package archives, user-based management.
  - Upgrade issues: a new soname means rebuilding every dependant before the old library goes; a lower-numbered
    library file can fool `ldconfig`; a security fix to a shared library means restarting every process still using
    the deleted old copy.
  - Installing a program by removing then replacing the file (as `install` does) avoids crashing processes that have
    the old one mapped.
  - These are the problems os-07's package manager exists to solve: a file database, conflict checks and upgrades
    that cannot leave half a package behind.
- **Recall targets:** two techniques and the weakness of each; the three upgrade issues above and what each breaks.
- **Build:** for the rest of the build, record each package's installed files with the technique Sam chooses (for
  example a `DESTDIR` staging tree per package, archived), kept inside the VM. Checked by answering, from the records,
  which package owns three files the tutor names.
- **Security lens:** processes still mapping a deleted, vulnerable library stay vulnerable until restarted; the book
  gives a `/proc/*/maps` check for them.
- **Sources:** LFS 13.1-systemd Section 8.2 "Package Management", Sections 8.2.1 "Upgrade Issues" and 8.2.2 "Package
  Management Techniques" (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/pkgmgt.html>);
  `man 8 ldconfig`.
- **Done when:** Sam's records answer the three ownership questions, and Sam explains the soname-upgrade rule unaided.

## 03 — System configuration with systemd

- **Objective:** Sam can configure the base system's network, devices, clock, console and locale under systemd as LFS
  13.1 does, and say where a non-systemd Syntek OS would leave the book.
- **Builds on:** lesson 01; os-01 lesson 01 (PID 1 in the boot chain).
- **Key ideas:**
  - LFS 13.1 configures networking with `systemd-networkd` and name resolution with `systemd-resolved`, both through
    small configuration files.
  - Devices are handled by udev (from systemd), loading modules and creating device nodes as the kernel reports
    hardware (Section 9.3).
  - Clock, console and locale are set through systemd's files and tools; `systemctl` and `journalctl` are the everyday
    interface (Section 9.10).
  - The System V edition of LFS remains at 12.4 and is no longer maintained, so a different init for Syntek OS means
    writing this configuration layer itself — os-06 surveys the options and the research note weighs them.
- **Recall targets:** which component handles addresses, names and devices in this build; what `systemctl` and
  `journalctl` show; what would have to be replaced if PID 1 were not systemd.
- **Build:** LFS chapter 9 in the build VM, configured for a QEMU guest (DHCP on the virtual NIC). Checked by the
  configuration files in the note and their effect after first boot in lesson 05.
- **Security lens:** every service enabled by default is attack surface — list what the base system starts and why.
- **Sources:** LFS 13.1-systemd Chapter 9
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter09/introduction.html>),
  Sections 9.2 "General Network Configuration", 9.3 "Overview of Device and Module Handling" and 9.10 "Systemd Usage
  and Configuration"; LFS "Read" page, "The prior System V version of LFS is no longer maintained"
  (<https://www.linuxfromscratch.org/lfs/read.html>) and the LFS 12.4 book
  (<https://www.linuxfromscratch.org/lfs/view/12.4/>,
  historical reference only); `man 5 systemd.network`.
- **Done when:** the configuration is complete and Sam lists what a non-systemd Syntek OS would have to provide in its
  place.

## 04 — Making it bootable: fstab, a kernel and GRUB

- **Objective:** Sam can write the new system's `/etc/fstab`, install a kernel into its root filesystem, and install
  GRUB for BIOS and for UEFI so the image boots in QEMU under both firmware types.
- **Builds on:** lesson 03; os-02 lessons 03–06 (partitions, fstab, firmware, boot loaders); kernel-01 lessons 03–04
  (configuring and building) when the kernel track has reached them.
- **Key ideas:**
  - `/etc/fstab` lists what mounts where and in which order it is checked (Section 10.2); os-02 lesson 04 explains the
    fields and the choice of identifiers.
  - LFS 13.1 builds Linux 7.1.8 (Section 10.3); kernel.org marked the 7.1 series end-of-life on 02/09/2026, so a
    Syntek OS kernel comes from a supported stable or longterm line chosen in the kernel track.
  - GRUB for BIOS writes a stub to the disk's first sector and needs the BIOS Boot partition on GPT
    (`grub-install --target=i386-pc`); GRUB for UEFI installs `EFI/BOOT/BOOTX64.EFI` on the mounted ESP
    (`grub-install --target=x86_64-efi --removable`). Both can coexist (Section 10.4.4).
  - LFS has no Secure Boot support and asks for it to be off (Section 10.4.2); Secure Boot is parked in `DEFERRED.md`.
  - `grub.cfg` names the root partition for GRUB and passes `root=` to the kernel.
- **Recall targets:** what each firmware type needs installed where; why a supported kernel line matters more than
  the book's version; the path from `grub.cfg` to the kernel's `root=`.
- **Build:** LFS chapter 10 in the build VM: the fstab, a kernel (from kernel-01's method, else Section 10.3), and GRUB
  installed for BIOS and for UEFI on the image. Checked in lesson 05.
- **Security lens:** a kernel line past end-of-life receives no fixes; the kernel track owns choosing and tracking
  the line (kernel-04, kernel-06).
- **Safety:** `grub-install` is run only inside the build VM against the VM's image; never on the host, whose boot
  loader it would overwrite (the book's own warning).
- **Sources:** LFS 13.1-systemd Chapter 10
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter10/introduction.html>),
  Sections 10.2 "Creating the /etc/fstab File", 10.3 "Linux-7.1.8" and 10.4 "Using GRUB to Set Up the Boot Process"
  (10.4.2, 10.4.4.1, 10.4.4.2, 10.4.5); kernel.org front page, "stable: 7.1.13 [EOL] 2026-09-02"
  (<https://www.kernel.org/>, read 27/09/2026); GNU GRUB Manual (2.12 on the host via `info grub`; LFS 13.1 builds
  GRUB 2.14 — re-check any option against the 2.14 manual inside the build VM).
- **Done when:** the image carries a kernel, an fstab and GRUB for both firmware types, and Sam explains the chain from
  firmware to kernel for each.

## 05 — First boot in QEMU

- **Objective:** Sam can boot the finished LFS image in QEMU to a login prompt on a serial console, and diagnose a
  failed boot from its messages.
- **Builds on:** lesson 04; os-02 lesson 05 (firmware in QEMU); kernel-01 lessons 06–07 (serial console, reading a
  panic) when reached.
- **Key ideas:**
  - The image boots as a normal disk, through firmware and GRUB — unlike kernel-01's direct kernel boot.
  - A serial console (`console=ttyS0` on the command line, QEMU's `-nographic`) makes every boot message readable and
    recordable.
  - Typical first-boot faults map to the boot chain: GRUB cannot find its files; the kernel cannot mount root (wrong
    `root=`, a driver built as a module with no initramfs); init cannot run.
  - `systemctl --failed` and `journalctl -b` show what userland did not start.
- **Recall targets:** for three failure messages, the stage that failed and the first thing to check.
- **Build:** the booted LFS image under SeaBIOS and under OVMF, started from the disk-image launcher in
  `code/src/os/msNNN-disk-image/` (planned — added at P6) with `-nic none` or on os-09's isolated lab network. Checked
  by a recorded serial log reaching the login prompt and an empty `systemctl --failed`.
- **Safety:** QEMU only; the guest is given no network, or only the isolated lab network (os-09) — never QEMU's
  default (unrestricted) user-mode network, which reaches the host's LAN; user mode with `restrict=on` is acceptable.
- **Sources:** LFS 13.1-systemd Section 11.3 "Rebooting the System"
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter11/reboot.html>); "Explaining the 'No working init
  found.' boot hang message" (<https://docs.kernel.org/admin-guide/init.html>); QEMU "Network emulation", "Using the
  user mode network stack" (<https://www.qemu.org/docs/master/system/devices/net.html>) and the `-netdev user`
  `restrict=on` option (<https://www.qemu.org/docs/master/system/invocation.html>); `man 1 journalctl`.
- **Done when:** the image reaches a login prompt under both firmware types with no failed units, and Sam diagnoses one
  deliberately broken `root=` from its messages alone.

## 06 — Stripping, cleanup and snapshots

- **Objective:** Sam can shrink the finished system safely, measure what that saved, and keep a known-good snapshot to
  return to.
- **Builds on:** lessons 01–05; os-02 lesson 02 (images and snapshots).
- **Key ideas:**
  - Stripping debug symbols and unneeded symbol-table entries saves about 2 GB, at the cost of debugging the system
    software; the book says to back up first, because a wrong `strip` can make the system unusable.
  - The book keeps the debug symbols of a few chosen libraries in separate files before stripping (Section 8.84), so
    those can still be debugged.
  - Cleanup removes test-suite leftovers and the libtool `.la` archives before the image is final (Section 8.85).
  - A snapshot of the finished image is the starting point for os-05's recipes and every later experiment.
- **Recall targets:** what `--strip-unneeded` removes and what it keeps; what is lost for debugging; why the backup
  comes first.
- **Build:** measure the image before and after stripping and cleanup, and take the final snapshot. Checked by the
  recorded sizes (`du` inside the guest, `qemu-img info` on the host) and boot time (`systemd-analyze time`) before and
  after.
- **Efficiency lens:** image size and boot time, measured before and after, following llm-06 lesson 01's
  measurement method (repeated runs, variance) when that lesson has been taught.
- **Sources:** LFS 13.1-systemd Sections 8.83 "About Debugging Symbols", 8.84 "Stripping" and 8.85 "Cleaning Up"
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/stripping.html>); `man 1 strip`
  (`--strip-unneeded`); `man 1 systemd-analyze`; `man 1 qemu-img` (`snapshot`, `info`).
- **Done when:** the before-and-after measurements are recorded, the stripped system still boots, and the final
  snapshot is listed.
