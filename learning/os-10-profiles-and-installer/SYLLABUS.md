# Syllabus — os-10-profiles-and-installer

**Track**: os · **Phase**: P6 · **Path**: Core · **Detail**: full · **Prerequisites**: `os-08-repositories-signing-and-updates`; `os-02-storage-and-boot-fundamentals` lessons 02–05, 07 and 08 (disk images and loop devices, GPT, filesystems and UUIDs, firmware boot, when an initramfs is required, LUKS2); `kernel-04-kconfig-and-profile-configs` lessons 02, 05 and 06 (the fragment method, firmware and initramfs needs, the base, server and homelab fragments — P5); `kernel-01-build-and-boot-in-qemu` lessons 05–06 (the busybox initramfs and the QEMU boot harness); `llm-06-cpu-performance-in-c` lesson 01 (measuring honestly)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic turns one Syntek OS base into the seven profiles (beginner, intermediate and expert
desktops; server, NAS, homelab and router) without forking anything: a profile selects packages,
defaults and a kernel fragment from the one base, a declarative configuration file describes a
machine, and an installer backend applies that description to a disk as a checked transaction.
It is the bridge between the signed repository of `os-08` and the first edition (server and
homelab, `os-11` and `os-12`), and its installer backend is what the installer TUI (`ui-06`)
consumes. Small lesson exercises land under `code/src/` here (`msNNN` paths are planned and take
their number when the milestone is allocated); the build system and the installer proper land in the
Syntek OS build-system and installer repositories, created when each build starts. Everything runs on image files and
in QEMU, never on a host disk.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | One base, many profiles | 1 sitting | yes — profile layering | Efficiency, Security |
| 02 | A declarative system configuration file | 2–3 sittings | yes — machine config validator | Security |
| 03 | Building disk images and live ISOs without root | 2–3 sittings | yes — image build script | Efficiency, Safety |
| 04 | An initramfs for real roots and live ISOs | 2–3 sittings | yes — root-by-UUID and live initramfs | Efficiency, Security, Safety |
| 05 | Installing to an EFI System Partition under UEFI | 2–3 sittings | yes — UEFI boot under OVMF | Security, Safety |
| 06 | The installer backend as a transaction | multi-session build | yes — plan, confirm, apply, verify | Security, Safety |
| 07 | Testing every profile image in QEMU | 2–3 sittings | yes — boot-test harness | Efficiency, Safety |

---

## 01 — One base, many profiles

- **Objective:** Sam can describe a Syntek OS profile as the base plus a package set, configuration
  defaults, a kernel fragment and boot modes, and work out the resolved package set of a profile
  that layers on another.
- **Builds on:** `os-07-package-manager` lesson 02 (the package format and its metadata),
  `os-08-repositories-signing-and-updates` (the signed repository every package comes from),
  `kernel-04-kconfig-and-profile-configs` lesson 06 (the base, server and homelab fragments); the
  profiles decision in
  `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`.
- **Key ideas:**
  - One base, one build system, one package set: a profile selects and configures, it never patches
    a package or forks the base, so a fix lands once and reaches every profile.
  - Two shapes of the same idea to study: archiso's profile (a package list, an `airootfs` overlay
    of files, and `profiledef.sh` naming boot modes and the image type) and Alpine's `mkimage`
    profiles (a `profile_<name>` function that calls `profile_standard` and then appends to
    `apks`).
  - Layering has an order and conflict rules (a later layer adds or removes; removal is explicit);
    a resolved profile is plain data that can be diffed between releases.
  - Kernel fragments merge in the same layered way (`kernel-04` lesson 02), so the profile and
    its kernel config are resolved side by side.
- **Recall targets:** name the parts of a profile; predict the resolved package set of a small
  server-on-base example; explain why a profile never patches a package.
- **Build:** a small Rust library with tests that loads layered profile manifests (base, then
  server, then homelab) and resolves the final package set and kernel-fragment list, rejecting an
  unknown package and a layering cycle — `code/src/rust/crates/msNNN_profile_layers/` (planned),
  checked by `cargo test` and `code/src/scripts/rust/lint.sh`. The production profile definitions
  land in the Syntek OS build-system repository (created when this build starts).
- **Efficiency lens:** record each profile's resolved package count and installed-size estimate —
  the first line of that profile's disk budget.
- **Security lens:** the package count is attack surface (`sec-01-principles-threat-modelling-and-law`);
  every package in a profile comes from `os-08`'s signed repository.
- **Sources:** archiso `README.profile.rst` at tag v91,
  <https://gitlab.archlinux.org/archlinux/archiso/-/blob/v91/docs/README.profile.rst>; Alpine wiki
  "How to make a custom ISO image with mkimage" (revision 31999),
  <https://wiki.alpinelinux.org/w/index.php?title=How_to_make_a_custom_ISO_image_with_mkimage&oldid=31999>;
  `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` (the profile axes).
- **Done when:** the tests show server-on-base and homelab-on-server resolving to the expected sets
  and a cycle being rejected, and Sam explains why the answer changes with the layer order.

## 02 — A declarative system configuration file

- **Objective:** Sam can design a declarative configuration format for one Syntek OS machine
  (profile, hostname, users, services, disks) with a schema, validation and merge rules, and say
  which NixOS ideas it borrows and which it leaves out.
- **Builds on:** lesson 01; Sam's own NixOS configuration and modules; the independence decision in
  `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md`
  (borrow ideas, not a base or a language).
- **Key ideas:**
  - Declarative means describing the end state; the image builder or the installer works out the
    steps.
  - The three NixOS module mechanisms worth borrowing: options are declared with types, definitions
    from several modules are merged, and priorities (`mkDefault`, `mkForce`) settle conflicts.
  - A smaller, data-only format (TOML 1.0 is one candidate) with a schema: an unknown key is an
    error, because a typo must never silently change a system.
  - Validate before applying: users, services and disks are checked against the profile; disks are
    named by a stable identifier, not by probe order.
  - Secrets never live in the file: it references a password hash or a key, it does not inline one.
- **Recall targets:** explain declaration versus definition; predict a merge that involves a default
  and a forced value; say why unknown keys are rejected rather than ignored.
- **Build:** extend lesson 01's crate, or add `code/src/rust/crates/msNNN_system_config/` (planned),
  to parse and validate a machine configuration against its profile, with tests for an unknown key,
  a wrong type and a default-then-override merge. Any parsing crate passes
  `code/src/scripts/rust/audit.sh` or carries a documented per-crate exception under
  `project-management/src/08-DECISIONS/ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md`. The real
  format lands in the Syntek OS build-system repository (created when this build starts).
- **Security lens:** the file comes from a trusted admin but is still validated; no secrets inline;
  unknown keys fail closed.
- **Sources:** NixOS manual 26.05, "Writing NixOS Modules",
  <https://nixos.org/manual/nixos/stable/#sec-writing-modules>; TOML v1.0.0,
  <https://toml.io/en/v1.0.0>.
- **Done when:** the tests pass, including the unknown-key rejection and the merge case, and Sam's
  note states the format's merge rule in one paragraph.

## 03 — Building disk images and live ISOs without root

- **Objective:** Sam can turn a root-filesystem directory into a partitioned disk image and then a
  qcow2 file without root on the host, and explain how a live ISO differs.
- **Builds on:** `os-02-storage-and-boot-fundamentals` lessons 02–04 (disk images and loop devices,
  GPT with `sfdisk`, filesystems and UUIDs); `os-04-lfs-base-system` (a root filesystem that boots);
  `os-05-build-system-and-reproducibility` lessons 04–05 (SOURCE_DATE_EPOCH, diffoscope); `tooling-03-shell-scripting`.
- **Key ideas:**
  - An image is a regular file: `sfdisk` partitions it and filesystems are created inside it, so
    nothing touches a host disk.
  - Unprivileged population: `mke2fs -d` copies a directory tree into a new ext4 filesystem;
    `systemd-repart` builds a partitioned image from `repart.d` definitions and, with `--offline`,
    does it without loop devices.
  - Ownership: an unprivileged build owns every file as Sam; inside `unshare -r`, stat(2) reports
    those files as root (`man 7 user_namespaces`) — the build checks what the image records.
  - A live ISO is an ISO 9660 image with a boot catalogue and a compressed read-only root (archiso
    offers squashfs, ext4 inside squashfs, and EROFS as its `airootfs_image_type` choices);
    `grub-mkrescue`, which needs xorriso (LFS 13.1 Section 10.4.1), makes a first test ISO.
  - A reproducible image fixes timestamps, input order and UUIDs; diffoscope explains whatever still
    differs (`os-05`).
- **Recall targets:** list the steps from a directory tree to a bootable qcow2; say which steps need
  root and how each is avoided; explain what makes two builds of one image differ.
- **Build:** a build-and-verify script following the contract in `code/src/scripts/CLAUDE.md`
  (`tooling-03`) that builds a GPT raw image from a root-filesystem directory, then converts it to
  qcow2, with no sudo — in `code/src/os/` (planned — added at P6). Checked by `sfdisk --dump` on the
  image, `qemu-img info`, and a second build with the same SOURCE_DATE_EPOCH that is byte-identical
  or whose diffoscope report explains every difference. The image builder proper lands in the
  Syntek OS build-system repository (created when this build starts).
- **Efficiency lens:** image size (raw, qcow2, compressed root) and build time, measured with the
  method of `llm-06-cpu-performance-in-c` lesson 01 (`/usr/bin/time -v`, repeated runs).
- **Safety:** image files only — never a host block device or a loop device (`os-02` lesson 02,
  disk images and loop devices); no sudo by Claude.
- **Sources:** `man 8 sfdisk` (util-linux); `man 8 mke2fs` (e2fsprogs 1.47.0, option `-d`);
  `man 8 systemd-repart` and `man 5 repart.d` (systemd 255, `--offline=`); `man 7 user_namespaces`;
  `man 1 grub-mkrescue` (GRUB 2.12); `man 1 xorriso` (1.5.6); `man 1 qemu-img` (QEMU 8.2.2);
  archiso `README.profile.rst` v91 (`airootfs_image_type`),
  <https://gitlab.archlinux.org/archlinux/archiso/-/blob/v91/docs/README.profile.rst>; LFS
  13.1-systemd Section 10.4.1, <https://www.linuxfromscratch.org/lfs/view/13.1-systemd/chapter10/grub.html>;
  SOURCE_DATE_EPOCH, <https://reproducible-builds.org/docs/source-date-epoch/>.
- **Done when:** the script exits 0 with its checks, and the rebuild is identical or every
  difference is explained.

## 04 — An initramfs for real roots and live ISOs

- **Objective:** Sam can build an initramfs whose `/init` finds the root filesystem by UUID — and,
  for the live ISO, mounts a read-only root under a writable overlay — then switches root, and can
  say when a Syntek OS profile needs an initramfs at all.
- **Builds on:** `kernel-01-build-and-boot-in-qemu` lessons 05–06 (the hand-made busybox initramfs
  and the QEMU boot harness); `os-02-storage-and-boot-fundamentals` lesson 07 (when an initramfs is
  required); `kernel-04-kconfig-and-profile-configs` lesson 05 (firmware and initramfs needs per
  profile); `os-06-init-and-services` lesson 01 (what PID 1 owes the system); lesson 03.
- **Key ideas:**
  - The kernel unpacks the cpio archive into rootfs and runs `/init` as PID 1; that program is not
    expected to return — it mounts the real root and hands over with `switch_root`.
  - BLFS 13.1 gives four reasons for an initramfs on a system whose hardware is known: root over
    the network, root on an LVM logical volume, an encrypted root that needs a password, and naming
    the root by LABEL or UUID; an installer's live image faces the unknown hardware the book says
    general distributions do.
  - Generators to study, not assume: dracut (event-driven, built from modules) and mkinitcpio
    (hooks and autodetection); extending the hand-made one is a valid choice, recorded as one.
  - A live system is a compressed read-only root plus an overlayfs whose upper layer is in memory,
    so it runs writable without touching a disk.
  - Everything copied in costs boot time and size and runs as root before any policy loads.
- **Recall targets:** what the kernel does with an initramfs and what happens when `/init` is
  missing; the four BLFS reasons; why `/init` hands over rather than returning.
- **Build:** extend `kernel-01`'s initramfs so `/init` mounts the root of lesson 03's image by UUID
  and switches to it, then a live variant with an overlay — scripts in `code/src/os/` (planned —
  added at P6), or a C `/init` in `code/src/c/msNNN-<kebab>/` (planned) if Sam grows `os-06` lesson
  02's minimal init. Checked by booting both in QEMU with a serial console and seeing the real
  root's init print a marker line, and by a negative test (a wrong UUID ends in a clear rescue
  message, not a panic loop).
- **Efficiency lens:** initramfs size, compressed and unpacked, and time to `switch_root`, over
  repeated boots.
- **Security lens:** the initramfs runs as root before any policy; it carries only what reaching
  the root needs.
- **Safety:** QEMU only; image files only.
- **Sources:** docs.kernel.org, "Ramfs, rootfs and initramfs" (v7.3-rc4 render, read 27/09/2026),
  <https://docs.kernel.org/filesystems/ramfs-rootfs-initramfs.html>; docs.kernel.org, "Overlay
  Filesystem", <https://docs.kernel.org/filesystems/overlayfs.html>; BLFS 13.1-systemd, "About
  initramfs", <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/initramfs.html>;
  dracut (dracut-ng, tag 112), <https://github.com/dracut-ng/dracut>; mkinitcpio(8) (v42.1),
  <https://man.archlinux.org/man/mkinitcpio.8>; `man 8 switch_root`; `man 7 initramfs-tools` (the
  host's own generator, as a third design).
- **Done when:** both variants boot in QEMU to the marker, the negative test shows the rescue
  message, and the sizes and times are recorded.

## 05 — Installing to an EFI System Partition under UEFI

- **Objective:** Sam can lay out a GPT image with an EFI System Partition, install a UEFI boot path
  into it and boot it under OVMF in QEMU, and explain the removable fallback path versus a firmware
  boot entry.
- **Builds on:** `os-02-storage-and-boot-fundamentals` lessons 05–06 (BIOS versus UEFI, the ESP,
  OVMF; boot loaders and the kernel command line);
  `os-04-lfs-base-system` (GRUB from LFS chapter 10); lessons 03–04.
- **Key ideas:**
  - The ESP is a FAT filesystem in a partition with a registered GPT type
    (C12A7328-F81F-11D2-BA4B-00A0C93EC93B, alias `U` in `sfdisk`) that the firmware can read.
  - Two ways to be found: the removable path `EFI/BOOT/BOOTX64.EFI`, which LFS 13.1 Section 10.4.4.2
    uses with `grub-install --target=x86_64-efi --removable`, or a firmware boot entry written with
    efibootmgr — an installer usually wants both.
  - Alternatives to GRUB: systemd-boot reading Boot Loader Specification Type #1 entries from
    `/loader/entries/`, or a Type #2 unified kernel image; with `CONFIG_EFI_STUB` the kernel itself
    can be the EFI executable.
  - OVMF in QEMU is a read-only firmware CODE image plus a writable VARS store that each guest gets
    its own copy of; firmware boot entries live in that VARS copy.
  - Secure Boot is out of scope: LFS 13.1 Section 10.4.2 turns it off, `DEFERRED.md` parks it for
    P6, and `sec-13-hardening-and-secure-boot` lesson 03 teaches the Secure Boot chain.
- **Recall targets:** why `BOOTX64.EFI` at that path boots with no boot entry; where a QEMU guest's
  boot entries are stored; Type #1 entries versus a Type #2 image.
- **Build:** extend lesson 03's script to add an ESP and a UEFI boot loader to the image, then boot
  it under OVMF with a per-image copy of the VARS template — `code/src/os/` (planned — added at P6).
  Checked by a headless boot reaching lesson 04's marker; inside the guest, `efibootmgr` listing the
  entry the install wrote; and a second boot from a fresh VARS copy proving the removable path still
  boots.
- **Security lens:** the ESP is unencrypted and readable by firmware and every OS on the disk, so
  nothing secret lives there.
- **Safety:** QEMU with OVMF only; `efibootmgr` runs only inside the guest, never against the host's
  firmware.
- **Sources:** LFS 13.1-systemd Sections 10.4.2 and 10.4.4,
  <https://www.linuxfromscratch.org/lfs/view/13.1-systemd/chapter10/grub.html>; BLFS 13.1
  efibootmgr-18, <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/efibootmgr.html>;
  UAPI.1 Boot Loader Specification, <https://uapi-group.org/specifications/specs/boot_loader_specification/>;
  UAPI.2 Discoverable Partitions Specification (the ESP type UUID),
  <https://uapi-group.org/specifications/specs/discoverable_partitions_specification/>;
  systemd-boot manual page (systemd 262), <https://www.freedesktop.org/software/systemd/man/latest/systemd-boot.html>;
  docs.kernel.org, "The EFI Boot Stub", <https://docs.kernel.org/admin-guide/efi-stub.html>;
  `man 8 sfdisk` (partition type aliases); README.Debian of the host's `ovmf` package (2024.02:
  `OVMF_CODE_4M.fd` with a per-guest copy of `OVMF_VARS_4M.fd`). Whether the LFS 13.1 systemd build
  ships systemd-boot is to verify when the lesson runs.
- **Done when:** the image boots under OVMF to the marker, `efibootmgr` shows the entry, and the
  fallback boot works after the VARS reset.

## 06 — The installer backend as a transaction

- **Objective:** Sam can design and build an installer backend that plans, confirms, applies and
  verifies an installation onto a disk image, and refuses any other target.
- **Builds on:** lessons 02–05; `os-02-storage-and-boot-fundamentals` lessons 03, 04 and 08
  (partitioning, filesystems, UUID versus PARTUUID, LUKS2 concepts); `os-07-package-manager`
  lessons 05–07 (crash-safe file updates, transactions, the library crate and thin CLI).
- **Key ideas:**
  - Plan, confirm, apply, verify: the plan is data (partitions, filesystems, packages, machine
    configuration) shown before anything is written, and apply does only what was confirmed.
  - Each step checks its precondition; a failed apply leaves a known, logged state; verify proves
    the result against the plan rather than trusting that each step succeeded.
  - Destructive-action safeguards: identify the target by a stable identifier, show its size and
    model, require explicit confirmation — and, in these lessons, accept only regular image files.
  - Prior art: `repart.d` describes a partition table declaratively, but `systemd-repart` only grows
    and adds partitions and never deletes one; note what an installer must do that it will not.
  - The backend is a library with a narrow API and a thin CLI; the installer TUI (`ui-06`) consumes
    it, the same "library plus thin client" pattern as `os-07`.
- **Recall targets:** the four phases and what each may write; why the plan is data; what the
  safeguard checks before apply.
- **Build:** a Rust library and thin CLI that produce a plan from a lesson 02 configuration and a
  target image path, print it, apply it only with an explicit confirmation flag, then verify it —
  `code/src/rust/crates/msNNN_install_plan/` (planned) as the lesson exercise. Checked by
  `cargo test` (the rendered plan asserted in tests, a refusal test for a target that is not a
  regular file, an interrupted apply that leaves a detectable state) and a QEMU boot of the installed
  image. The real installer backend lands in the Syntek OS installer repository (created when this
  build starts), where `ui-06`'s TUI consumes it.
- **Security lens:** the installer runs as root in the live system — every input is validated,
  every write is logged, and no secret reaches a log.
- **Safety:** VM disk images only; the lesson backend refuses block devices; no host disks; no sudo
  by Claude.
- **Sources:** `man 8 sfdisk`, `man 8 wipefs`, `man 8 mke2fs`; `man 8 systemd-repart` and
  `man 5 repart.d` (systemd 255: grows and adds, never deletes); `man 2 rename` and `man 2 fsync`
  (crash-safe writes, as in `os-07` lesson 05).
- **Done when:** the tests pass, including the refusal and the interrupted apply; the installed image
  boots in QEMU; the verify step reports a match with the plan.

## 07 — Testing every profile image in QEMU

- **Objective:** Sam can run an automated, headless boot test of each profile image in QEMU that
  passes or fails on evidence and records boot time and idle memory.
- **Builds on:** lessons 03–06; `kernel-01-build-and-boot-in-qemu` lesson 06 (the QEMU boot
  harness); `kernel-04-kconfig-and-profile-configs` lesson 07 (measuring a config);
  `os-05-build-system-and-reproducibility` lesson 06 (CI and build farms); `llm-06-cpu-performance-in-c`
  lesson 01 (measuring honestly).
- **Key ideas:**
  - A boot test is a program: start QEMU headless with a serial console, wait for a marker with a
    timeout, fail loudly on a panic or a timeout, and always tear the guest down.
  - Acceptance per profile comes from its profile spec: the server checks differ from the homelab's.
  - Every run starts from the same pristine image: a qcow2 overlay on a backing file, or QEMU's
    `-snapshot`.
  - KVM acceleration (`-accel kvm`) where available, TCG where it is not; say which one a number
    came from.
  - Measure time to the marker, idle guest memory and image size, against each profile's budget.
- **Recall targets:** what makes a boot test flaky and how the harness avoids it; why each run
  starts from a pristine overlay.
- **Build:** a boot-test script (`code/src/scripts/CLAUDE.md` contract) that boots the base, server
  and homelab images from lessons 03–06, checks each profile's markers and prints a table of
  pass or fail, boot time and idle memory — `code/src/os/` (planned — added at P6). Checked by its
  exit code on good images and by a deliberately broken image failing it. The CI version lands in
  the Syntek OS build-system repository (created when this build starts).
- **Efficiency lens:** boot time over repeated runs (median and spread) and idle memory per profile,
  against the profile's budget.
- **Safety:** QEMU only, on overlays of image files; guest networking is `-nic none`, QEMU user mode
  with `restrict=on` (plain user mode routes the guest out through the host), or
  `os-09-networking-fundamentals`' isolated lab.
- **Sources:** `man 1 qemu-system` (QEMU 8.2.2: `-accel`, `-serial`, `-nographic`, `-drive`,
  `-snapshot`, `-netdev user,restrict=on`); `man 1 qemu-img` (backing files);
  `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md`.
- **Done when:** the script passes the three profile images, fails the broken one, and its numbers
  are recorded in the milestone's verification record.
