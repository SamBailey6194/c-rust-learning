# Mission — os-02-storage-and-boot-fundamentals

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam wants Syntek OS in versions for "laptop/PC" and for "server, NAS, homelab, router" — every one of which has to be
partitioned, formatted, made bootable and, for the laptop and NAS, encrypted. Linux From Scratch starts by asking for a
partition and ends by setting up a boot loader, and the installer Sam's friends and family will one day run has to do
the same safely. This topic teaches those layers on disk images and in QEMU first, so that nothing in the Syntek OS
work ever touches the host's own disks.

## Can do it when

- Sam can identify every block device on a machine from `lsblk` and sysfs without writing to any of them.
- Sam can create, overlay and snapshot disk images with `qemu-img`, and his disk-image script passes ShellCheck.
- Sam can write a GPT layout with an ESP and a root partition onto an image with `sfdisk`, unprivileged.
- Sam can build and populate an ext4 root inside that image and say which `root=` forms need an initramfs.
- Sam can boot the image in QEMU under SeaBIOS and under OVMF and explain what each firmware does.
- Sam can compare GRUB and systemd-boot and annotate a kernel command line.
- Sam can decide whether a root setup needs an initramfs and list what it must contain.
- Sam can create and inspect a LUKS2 container in an image and state what it protects.

## Parked for later

- Installing a boot loader and booting a real root — os-04-lfs-base-system (lesson 04).
- Building an initramfs for real roots and live ISOs — os-10-profiles-and-installer.
- RAID, LVM, Btrfs and ZFS — os-13-nas-edition.
- UEFI Secure Boot — `DEFERRED.md` (P6) and sec-13-hardening-and-secure-boot.
- The installer's destructive-action safeguards — ui-06-installer-tui.
