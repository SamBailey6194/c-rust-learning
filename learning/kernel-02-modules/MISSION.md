# Mission — kernel-02-modules

**Started**: not yet · **Family**: kernel · **Phase**: P4 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam asked whether editing the kernel needs C, and the answer was yes: real kernel work is C in the kernel's own
dialect, and a loadable module is the stepping stone from user-space C to the kernel proper. A downstream kernel for
Syntek OS will one day carry patches and perhaps a driver of its own, and reading an oops is part of maintaining it.
This topic is where Sam's C first runs inside the kernel — in QEMU, where a mistake costs a reboot of a guest rather
than the machine he learns on.

## Can do it when

- Build an out-of-tree module against the QEMU kernel's build directory and explain version magic.
- Load, list and unload it inside the QEMU guest, with its messages captured from `dmesg`.
- Write kernel C with negative error codes and `goto`-based cleanup that unwinds every failure path.
- Give a module parameters and read or change them through sysfs, with permissions chosen on purpose.
- Read an oops and its taint flags and map the fault to a line of source.
- Implement a misc character device whose `read` and `write` copy data safely across the user-kernel boundary, proved
  by a user-space test program in the guest.

## Parked for later

- Kernel memory allocation, lists, reference counting and locking → kernel-03-syscalls-memory-and-concurrency.
- Module signing and its effect on reproducible builds → kernel-05-downstream-tree.
- Writing a module in Rust → kernel-08-rust-for-linux.
- Real hardware drivers (PCI, USB, platform devices) → not planned yet; a candidate for `DEFERRED.md` if a Syntek OS
  profile needs one.
