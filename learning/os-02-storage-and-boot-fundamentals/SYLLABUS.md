# Syllabus — os-02-storage-and-boot-fundamentals

**Track**: os · **Phase**: P6 · **Path**: Core · **Detail**: full · **Prerequisites**: P2 (C systems); tooling-03-shell-scripting; os-01 lesson 01 recommended (the boot chain)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Everything Syntek OS installs lands on a disk and starts from firmware, so this topic teaches the storage and boot
layers the LFS build (os-03, os-04), the installer (os-10) and the NAS profile (os-13) all stand on: block devices and
partition tables, filesystems and how the kernel finds its root, firmware (BIOS and UEFI), boot loaders and the kernel
command line, when an initramfs is required, and disk encryption. Its disk-images lesson is the one every later
"VM disk images only" Safety line cites. All practice happens on image files and in QEMU, never on the host's disks;
most of it runs unprivileged, and the few steps that need root (loop devices, mounting, opening an encrypted
container) Sam runs himself inside a VM.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Block devices, partitions and sysfs | 1 sitting | no | Safety |
| 02 | Disk images and loop devices | 2–3 sittings | yes — disk-image script | Efficiency, Safety |
| 03 | GPT and MBR on a disk image | 1 sitting | yes — partition the image | Safety |
| 04 | Filesystems, mounting, fstab, UUID and PARTUUID | 2–3 sittings | yes — populate the root | Safety |
| 05 | Firmware boot: BIOS, UEFI, the ESP and OVMF | 1 sitting | yes — firmware in QEMU | Safety |
| 06 | Boot loaders and the kernel command line | 1 sitting | no | Security |
| 07 | When an initramfs is required | 1 sitting | no | Efficiency, Security |
| 08 | Disk-encryption concepts: LUKS2 | 1 sitting | yes — LUKS2 container in an image | Security, Safety |

---

## 01 — Block devices, partitions and sysfs

- **Objective:** Sam can read a machine's block devices, partitions and their properties with `lsblk` and sysfs, and
  say which device is which without writing to any of them.
- **Builds on:** os-01 lesson 02 (`/dev` and `/sys`); P2 file I/O (a device is a file you can `open`).
- **Key ideas:**
  - A block device is addressed in fixed-size blocks; the kernel names disks and partitions (`sda`, `sda1`,
    `nvme0n1p1`) and exposes each as a device node and a sysfs directory.
  - `lsblk` builds its tree from sysfs and the udev database; `/sys/block/<disk>/queue/logical_block_size` and
    `queue/rotational` are two stable, documented attributes.
  - Major and minor numbers identify a device to the kernel; `lsblk -o NAME,MAJ:MIN,SIZE,TYPE,MOUNTPOINTS` shows them.
  - Reading is safe; writing to the wrong device destroys data. Every exercise from lesson 02 on targets an image file.
- **Recall targets:** what `lsblk` reads to build its output; how to tell a disk from a partition from a loop device;
  why exercises never name `/dev/sd*` or `/dev/nvme*`.
- **Build:** none — read-only inspection of the host (`lsblk`, `ls /sys/block`) recorded in the note.
- **Safety:** read-only on the host; no partitioning or formatting tool is ever pointed at a host device. Claude never
  runs `sudo`.
- **Sources:** `man 8 lsblk` (util-linux 2.39.3 on the host, "DESCRIPTION", "NOTES"); kernel ABI
  `Documentation/ABI/stable/sysfs-block` at v7.2.8
  (<https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/Documentation/ABI/stable/sysfs-block?h=v7.2.8>);
  "Linux allocated devices" (<https://docs.kernel.org/admin-guide/devices.html>).
- **Done when:** Sam identifies every block device on the host from `lsblk` and sysfs alone and explains each column.

## 02 — Disk images and loop devices

- **Objective:** Sam can create, inspect, convert and snapshot disk images with `qemu-img`, explain qcow2 backing files
  and overlays, and say what a loop device does and when one is needed.
- **Builds on:** lesson 01; tooling-03 (scripts with `set -euo pipefail` and `trap` clean-up).
- **Key ideas:**
  - A raw image is a plain file the size of the disk (sparse on most filesystems); qcow2 grows on demand and adds
    backing files and snapshots.
  - `qemu-img create -f qcow2 -b base.qcow2 -F qcow2 overlay.qcow2` writes changes to the overlay and leaves the base
    untouched — a cheap reset point for every VM experiment.
  - `qemu-img snapshot -c/-l/-a` makes, lists and applies internal snapshots; `qemu-img check` and `qemu-img info`
    inspect an image.
  - A loop device (`losetup --find --show --partscan`) presents a file as a block device so the kernel can mount its
    partitions; it needs root, which is why this repository's exercises avoid it where they can.
  - This is the lesson every later "VM disk images only" Safety line points to.
- **Recall targets:** raw against qcow2; what happens to the base image when a guest writes through an overlay;
  what `--partscan` adds; which of these steps needs root.
- **Build:** a disk-image script in `code/src/os/msNNN-disk-image/` (planned — added at P6) that creates a raw image,
  converts it to qcow2, adds an overlay on it and takes a snapshot, all under a scratch directory outside git, with
  `trap` clean-up. Checked by recorded `qemu-img info` and `qemu-img check` output, and by ShellCheck in CI
  (not installed locally — `GAPS.md` → "ShellCheck not installed locally"). Images are never committed.
- **Efficiency lens:** compare the apparent and on-disk size of a raw and a qcow2 image (`qemu-img info`, `du`), and
  the disk cost of an overlay after a guest writes to it.
- **Safety:** image files only, in a scratch directory; `losetup` and `mount` run as root only inside a VM, or by Sam
  himself if he chooses — Claude never runs `sudo`.
- **Sources:** `man 1 qemu-img` (QEMU 8.2.2 on the host: `create -b/-F`, `snapshot`, `check`, `info`, `convert`);
  QEMU "Disk Images" (<https://www.qemu.org/docs/master/system/images.html>, "Snapshot mode", "VM snapshots") and the
  qcow2 format (<https://www.qemu.org/docs/master/interop/qcow2.html>); `man 8 losetup` (`--find`, `--show`,
  `--partscan`).
- **Done when:** the script passes ShellCheck, its recorded output shows the overlay's backing chain, and Sam restores
  the base state from the snapshot without recreating the image.

## 03 — GPT and MBR on a disk image

- **Objective:** Sam can partition an image with a scripted `sfdisk` layout, explain GPT against MBR, and choose
  partition type GUIDs a boot loader and an installer will recognise.
- **Builds on:** lesson 02.
- **Key ideas:**
  - MBR (DOS-type) describes four primary partitions in sector 0, one of which may be an extended partition holding
    logical ones; its 32-bit sector counts reach about 2 TB with 512-byte sectors.
  - GPT uses 64-bit block addresses, checksums, UUIDs and names, keeps a backup header at the end of the disk, and
    reserves sector 0 for a protective MBR so MBR-only tools leave the disk alone.
  - Partition type GUIDs carry meaning: the EFI System Partition is `c12a7328-f81f-11d2-ba4b-00a0c93ec93b`, and the
    Discoverable Partitions Specification defines root, `/usr`, swap and others; `sfdisk` accepts short aliases such as
    `uefi` and `linux`.
  - `sfdisk` reads a script from standard input and works on an image file as well as a device; `sfdisk --dump` and
    `--json` print the layout back.
  - BIOS booting from a GPT disk with GRUB needs a small unformatted BIOS Boot partition (LFS Section 2.4.1.3).
- **Recall targets:** two limits of MBR and how GPT removes them; what the protective MBR is for; which partition types
  a UEFI system's installer must create.
- **Build:** extend the disk-image script so it writes a GPT with an ESP and a root partition from an `sfdisk` script,
  unprivileged, on the image file. Checked by comparing `sfdisk --dump` against the expected layout in the script's
  own check step.
- **Safety:** `sfdisk` is only ever given an image path produced by the script; a guard refuses any argument under
  `/dev`.
- **Sources:** `man 8 sfdisk` ("INPUT FORMATS", `--dump`, `--json`) and `man 8 fdisk` ("DISK LABELS") (util-linux
  2.39.3); UAPI "Discoverable Partitions Specification"
  (<https://uapi-group.org/specifications/specs/discoverable_partitions_specification/>, "Defined Partition Type
  UUIDs"); LFS 13.1-systemd Section 2.4.1, "Other Partition Issues"
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/creatingpartition.html>).
- **Done when:** the script's check step passes and Sam explains every field of the `sfdisk --dump` output.

## 04 — Filesystems, mounting, fstab, UUID and PARTUUID

- **Objective:** Sam can create and populate an ext4 filesystem inside a partition of an image, write the matching
  `/etc/fstab` line, and explain which root identifiers the kernel resolves by itself and which need an initramfs.
- **Builds on:** lesson 03; os-01 lesson 02 (what goes in the root filesystem).
- **Key ideas:**
  - `mkfs.ext4` can build a filesystem at an offset inside an image (`-E offset=`) and copy a staging directory into
    it (`-d`), with no loop device and no mount — so no root.
  - Mounting attaches a filesystem to the tree; `/etc/fstab` has six fields (device, mount point, type, options, dump,
    pass) read at boot and by `mount -a`.
  - A filesystem UUID belongs to the filesystem (`blkid`); a PARTUUID belongs to the GPT partition entry.
  - The kernel's own root lookup (`block/early-lookup.c`) understands `/dev/...`, `PARTUUID=`, `PARTLABEL=` and
    major:minor numbers — not a filesystem `UUID=`, which needs user space (an initramfs) to resolve.
  - Labels and UUIDs survive disks being renumbered; `/dev/sda2` does not.
- **Recall targets:** the six fstab fields; filesystem UUID against PARTUUID; which `root=` forms work without an
  initramfs, and why.
- **Build:** extend the disk-image script to create the root filesystem at the partition's offset, populated from a
  staging directory, and to emit a matching fstab line. Checked by `blkid -p -O <offset>` reporting ext4 and the UUID
  the fstab line names; a mount test, if Sam wants one, runs inside a VM.
- **Safety:** unprivileged image work only; any `mount` is inside a VM.
- **Sources:** `man 8 mkfs.ext4` (e2fsprogs 1.47.0: `-d`, `-E offset=`); `man 5 fstab`; `man 8 mount`; `man 8 blkid`;
  "The kernel's command-line parameters", `root=` (<https://docs.kernel.org/admin-guide/kernel-parameters.html>);
  `block/early-lookup.c` at v7.2.8, the comment above `early_lookup_bdev`
  (<https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/block/early-lookup.c?h=v7.2.8>).
- **Done when:** the image's root partition holds the staged files (checked with `blkid` and, in a VM, a read-only
  mount), and Sam predicts correctly whether a given `root=` line boots without an initramfs.

## 05 — Firmware boot: BIOS, UEFI, the ESP and OVMF

- **Objective:** Sam can explain how BIOS and UEFI firmware each find a boot loader, what the EFI System Partition
  holds, and boot a disk image in QEMU under both firmware types.
- **Builds on:** lessons 03 and 04; os-01 lesson 01.
- **Key ideas:**
  - BIOS runs code from the disk's first sector; GRUB puts a stub there that loads its main image from the BIOS Boot
    partition (LFS Section 10.4.4).
  - UEFI reads a FAT filesystem on the ESP and runs an EFI executable. The standard path `EFI/BOOT/BOOTX64.EFI` on
    x86-64 needs no boot entry; any other path has to be recorded in a firmware variable (with `efibootmgr`).
  - With no firmware option, the host's QEMU 8.2.2 loads SeaBIOS (`bios-256k.bin`, shown by `info roms` in the QEMU
    monitor); OVMF is the UEFI firmware. `OVMF_CODE` is read-only and shared; each VM gets its own writable copy of an
    `OVMF_VARS` template.
  - Secure Boot is off in LFS (Section 10.4.2) and parked for Syntek OS in `DEFERRED.md`.
- **Recall targets:** where each firmware type looks for a boot loader; what the ESP must contain and why it is FAT;
  why every VM needs its own variable store.
- **Build:** a small QEMU launcher beside the disk-image script, in `code/src/os/msNNN-disk-image/` (planned — added
  at P6), that boots the image under SeaBIOS and under OVMF with a per-VM copy of the variable store (OVMF 2024.02 is
  installed on the host). Checked by the firmware's own console messages: no bootable device found, then — once a boot
  loader is installed in os-04 — its menu.
- **Safety:** QEMU only; `-nic none` so the guest has no network (QEMU's default user-mode network would give it one;
  see os-09).
- **Sources:** LFS 13.1-systemd Sections 2.4.1.3–2.4.1.4 and 10.4.4
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter10/grub.html>); UAPI "Boot Loader Specification"
  (<https://uapi-group.org/specifications/specs/boot_loader_specification/>, "The Partitions"); the Ubuntu `ovmf`
  package's `README.Debian` (ovmf 2024.02 on the host: the CODE and VARS files); the Ubuntu `seabios` package
  (1.16.3 on the host, `bios-256k.bin`); QEMU "Invocation" (<https://www.qemu.org/docs/master/system/invocation.html>,
  `-boot`, `-drive if=pflash`). The UEFI specification itself is to verify in a browser: uefi.org refused scripted
  fetches on 27/09/2026.
- **Done when:** the launcher boots the image under both firmware types and Sam explains each firmware message.

## 06 — Boot loaders and the kernel command line

- **Objective:** Sam can say what a boot loader does beyond jumping to the kernel, compare GRUB and systemd-boot, and
  read and change the kernel command line.
- **Builds on:** lesson 05; lesson 04 (`root=`).
- **Key ideas:**
  - A boot loader loads the kernel and (optionally) an initramfs, passes the command line and offers a menu; GRUB
    keeps its modules in `/boot/grub` and embeds those it needs to reach them.
  - GRUB supports BIOS and UEFI; systemd-boot supports UEFI only and reads Boot Loader Specification entries from the
    ESP or an XBOOTLDR partition.
  - The command line carries `root=`, `ro`, `console=`, `init=`/`rdinit=` and more; `/proc/cmdline` shows what the
    running kernel received.
  - A `foo=bar` argument the kernel does not claim becomes an environment variable for init, and any other unclaimed
    argument is passed to PID 1 (`bootparam(7)`); systemd and the programs in the initrd read their own options from
    the command line (`kernel-command-line(7)`).
- **Recall targets:** what GRUB and systemd-boot each support; four command-line parameters and what they do; where a
  running system's command line can be read.
- **Build:** none — the boot loader is installed for real in os-04 lesson 04, inside the LFS VM.
- **Security lens:** anyone at the boot menu can edit the command line (`init=/bin/sh` gives a root shell), which is
  why physical access and boot-loader passwords matter; hardening is sec-13's.
- **Sources:** GNU GRUB Manual (2.12 on the host via `info grub` — gnu.org did not answer on 27/09/2026, so the local
  copy is the one checked; LFS 13.1 builds GRUB 2.14, so re-check any option against the 2.14 manual inside the build
  VM); LFS 13.1-systemd Section 10.4
  (<https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter10/grub.html>); `systemd-boot(7)` from systemd 262
  (<https://www.freedesktop.org/software/systemd/man/latest/systemd-boot.html>); `man 7 bootparam`,
  `man 7 kernel-command-line` and `man 5 proc` (`/proc/cmdline`); "The kernel's command-line parameters"
  (<https://docs.kernel.org/admin-guide/kernel-parameters.html>).
- **Done when:** Sam annotates the host's `/proc/cmdline` parameter by parameter and states which boot loader could
  boot a BIOS-only machine.

## 07 — When an initramfs is required

- **Objective:** Sam can decide, for a given root setup, whether a system needs an initramfs and list what it must
  contain.
- **Builds on:** lesson 04 (what the kernel resolves by itself); kernel-01 lesson 05 (a busybox initramfs by hand)
  when the kernel track has reached it.
- **Key ideas:**
  - An initramfs exists to mount the real root filesystem; a plain root on a partition the kernel can name
    (`PARTUUID=`) with its drivers built in needs none.
  - BLFS names four reasons on a system whose kernel is built for its hardware: root over the network, on LVM,
    encrypted behind a passphrase, or named by filesystem LABEL or UUID. For a general distribution, drivers built as
    modules are the biggest reason; LFS adds RAID roots.
  - CPU microcode is loaded early from an uncompressed cpio archive placed in front of the initramfs
    (`kernel/x86/microcode/GenuineIntel.bin` on Intel).
  - Distributions generate initramfs images with tools — BLFS gives its own `mkinitramfs` script and points to dracut
    for more; this host uses Ubuntu's initramfs-tools — and os-10 builds one for real roots and live ISOs.
- **Recall targets:** three root setups that force an initramfs and one that does not; how microcode reaches the CPU
  before the kernel's main initramfs is unpacked.
- **Build:** none — a read-only look at the host's initramfs (`lsinitramfs /boot/initrd.img`) to find the microcode
  and storage tools it carries, recorded in the note.
- **Efficiency lens:** BLFS notes that an initramfs can make the boot take significantly longer; the cost is measured
  on a real image in os-04 lesson 06 (`systemd-analyze time`).
- **Security lens:** the initramfs runs as root before the real system is up, and on a laptop or NAS it asks for the
  disk passphrase — it is part of the trusted boot path.
- **Sources:** "Ramfs, rootfs and initramfs" (<https://docs.kernel.org/filesystems/ramfs-rootfs-initramfs.html>);
  "The Linux Microcode Loader", "Early load microcode" (<https://docs.kernel.org/arch/x86/microcode.html>); BLFS 13.1
  systemd "About initramfs" (<https://www.linuxfromscratch.org/blfs/view/stable-systemd/postlfs/initramfs.html>);
  LFS 13.1-systemd Section 2.4 (RAID and LVM roots may need an initramfs); `man 8 lsinitramfs` (initramfs-tools,
  host).
- **Done when:** for five root setups named by the tutor, Sam says whether an initramfs is needed and what it must
  carry, and finds the microcode file in the host's initramfs listing.

## 08 — Disk-encryption concepts: LUKS2

- **Objective:** Sam can explain what LUKS2 adds to dm-crypt, what it protects and what it does not, and create and
  inspect a LUKS2 container inside an image file.
- **Builds on:** lessons 02 and 07; sec-05 lessons 01–03 when reached (hashes, key derivation, symmetric encryption).
- **Key ideas:**
  - dm-crypt is the kernel's device-mapper target for transparent block encryption; LUKS adds a standard header, key
    slots and a key-derivation function (PBKDF) in front of it.
  - LUKS manages several passphrases, each in its own key slot, which can be revoked or changed individually.
  - cryptsetup 2.7 formats LUKS2 by default; `luksFormat` on an image file and `luksDump` need no root, while opening
    the container needs device-mapper and so root.
  - Encryption at rest protects a powered-off laptop or a removed NAS disk; it does not protect a running, unlocked
    system.
  - The laptop and NAS profiles need it; an encrypted root is why lesson 07's initramfs asks for a passphrase.
- **Recall targets:** header, key slot, volume key and PBKDF, and how they relate; the threat LUKS addresses and one it
  does not.
- **Build:** a LUKS2 container in an image file made with a throwaway test passphrase, inspected with
  `cryptsetup luksDump`; opening and formatting it inside happens in a VM. Recorded as a script step in
  `code/src/os/msNNN-disk-image/` (planned — added at P6); no real secret is ever used or committed.
- **Security lens:** a damaged LUKS header loses all the data unless a header backup exists; passphrase strength and
  the PBKDF cost are the brute-force defence.
- **Safety:** image files and VMs only; `cryptsetup open` runs in the guest, never against a host device.
- **Sources:** `man 8 cryptsetup` ("LUKS EXTENSION", and the "LUKS header" warning) and `cryptsetup --help`
  (cryptsetup 2.7.0 on the host, default metadata format LUKS2); "dm-crypt"
  (<https://docs.kernel.org/admin-guide/device-mapper/dm-crypt.html>); LUKS2 on-disk format documentation
  (<https://gitlab.com/cryptsetup/LUKS2-docs>); BLFS 13.1 systemd "cryptsetup-2.8.7"
  (<https://www.linuxfromscratch.org/blfs/view/stable-systemd/postlfs/cryptsetup.html>).
- **Done when:** Sam reads a `luksDump` of his container field by field and states what an attacker holding the
  powered-off disk image can and cannot learn.
