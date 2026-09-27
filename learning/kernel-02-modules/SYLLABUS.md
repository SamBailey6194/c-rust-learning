# Syllabus — kernel-02-modules

**Track**: kernel · **Phase**: P4 · **Path**: Core · **Detail**: full · **Prerequisites**: kernel-01-build-and-boot-in-qemu (all lessons)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Sam's first C running inside the kernel: out-of-tree modules built against the kernel from kernel-01, loaded and
unloaded inside the QEMU guest, growing from a hello-world into a misc character device that user space talks to. The
topic teaches the kernel's dialect of C — no libc, negative error codes, `goto`-based cleanup — on top of the C17 Sam
wrote in P1 and P2, and it closes half of the P4 exit gate in `project-management/src/01-ROADMAP/ROADMAP.md` (a module
that loads with `insmod` and unloads with `rmmod` in QEMU). Kernel memory allocation is left to
kernel-03-syscalls-memory-and-concurrency. A module is never built against or loaded into the host kernel
(`.claude/CLAUDE.md` → non-negotiables).

Version pins for this syllabus: docs.kernel.org pages were read on 27/09/2026 (documentation build 7.3.0-rc4);
kernel-tree files are cited at tag v7.2; _The Linux Kernel Module Programming Guide_ (LKMPG) is the edition dated
07/09/2026.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Building an external module with Kbuild | 1 sitting | yes — hello module | Safety |
| 02 | A module's life: init, exit, `printk` and loading in QEMU | 1 sitting | yes — hello module | Safety |
| 03 | The kernel's C dialect: no libc, negative errno, `goto` cleanup | 2–3 sittings | yes — hello module error paths | — |
| 04 | Module parameters and sysfs | 1 sitting | yes — hello module parameters | Security |
| 05 | Taint and reading an oops | 2–3 sittings | yes — faulting module | Safety |
| 06 | A misc character device and the user-space boundary | multi-session build | yes — misc device | Security, Safety |

---

## 01 — Building an external module with Kbuild

- **Objective:** Sam can build a one-file module out of tree against the kernel he configured in kernel-01, and say
  why it must be that kernel and not the host's.
- **Builds on:** kernel-01-build-and-boot-in-qemu lessons 03–04 (the configured build directory); the P1 `make`
  lessons (`code/docs/BUILD.md`).
- **Key ideas:**
  - A Kbuild file of one line, `obj-m := <name>.o`, names the module; the kernel's own build system does the rest.
  - `make -C <kernel build dir> M=$PWD` runs the kernel's makefiles against Sam's directory; `M=` must be an
    absolute path, and the result is a `.ko`.
  - The kernel must have `CONFIG_MODULES` on, and the module is built against **the same** configured tree it will
    load into: its version magic records the kernel version and ABI-relevant options, and a mismatch is refused.
  - `modinfo` on the `.ko` shows its licence, description and vermagic without loading anything.
  - Building against the host's own headers would produce a module for the host kernel, which is exactly what the
    kernel safety rule forbids here.
- **Recall targets:** what `obj-m` and `M=` each tell the build; why a module built for one kernel is refused by
  another; which command reads a module's metadata without loading it.
- **Build:** the Kbuild file, a Makefile that calls the kernel build with `M=`, and a module source that only logs on
  load and unload, in `code/src/kernel/msNNN-hello-module/` (planned — added at P4). Checked by a clean build against
  the kernel-01 output directory and `modinfo` showing the expected licence and vermagic;
  `code/workflows/09-kernel-module/` (planned — added at P4) turns the steps into a workflow.
- **Safety:** build against the QEMU kernel's build directory only; never load the result on the host.
- **Sources:** "Building External Modules" (<https://docs.kernel.org/kbuild/modules.html>, "How to Build External
  Modules" and "Creating a Kbuild File for an External Module"); LKMPG (<https://sysprog21.github.io/lkmpg/>, 4 Hello
  World and 4.7 Building modules for a precompiled kernel, on version magic); `man 8 modinfo`.
- **Done when:** the module builds from a clean directory, `modinfo` output is explained line by line, and Sam
  predicts the error a host-kernel load would give.

## 02 — A module's life: init, exit, `printk` and loading in QEMU

- **Objective:** Sam can load, list and unload his module inside the QEMU guest and read its messages in `dmesg`.
- **Builds on:** lesson 01; kernel-01-build-and-boot-in-qemu lessons 05–06 (the initramfs and the boot harness).
- **Key ideas:**
  - `module_init()` and `module_exit()` name the entry and exit functions; `__init` and `__exit` let the kernel drop
    code it no longer needs. The old fixed names `init_module`/`cleanup_module` break on x86 with indirect-branch
    tracking since 6.15, so the named-macro form is the only one to learn.
  - An init function returns 0 or a negative error code; a non-zero return makes the load fail.
  - `printk` writes to the kernel ring buffer read by `dmesg`; the `pr_*` helpers carry the log level, and
    `console_loglevel` decides what also reaches the serial console.
  - `MODULE_LICENSE("GPL")` states GPL-2.0 to the loader, alongside the SPDX line in the source.
  - The `.ko` reaches the guest by being packed into the harness's initramfs (a read-only 9p share is the alternative
    LKMPG's QEMU tooling uses); `insmod`, `lsmod` and `rmmod` then run as root inside the guest.
- **Recall targets:** the order of events from `insmod` to the init function's return; what a non-zero init return
  does; which log levels reach the console by default and how to change that.
- **Build:** the hello module from lesson 01, loaded and unloaded in the guest through the harness, in
  `code/src/kernel/msNNN-hello-module/` (planned — added at P4). Checked by a scripted guest run that loads, lists and
  unloads the module and captures the `dmesg` lines — the P4 exit gate's module evidence, recorded in the milestone's
  `KERNEL-IMPL` ("Module evidence").
- **Safety:** `insmod` and `rmmod` run inside QEMU only.
- **Sources:** "Unreliable Guide To Hacking The Linux Kernel" (<https://docs.kernel.org/kernel-hacking/hacking.html>,
  "User Context", "\_\_init/\_\_exit/\_\_initdata", "\_\_initcall()/module\_init()" and "module\_exit()"); "Message
  logging with printk" (<https://docs.kernel.org/core-api/printk-basics.html>); "Linux kernel licensing rules"
  (<https://docs.kernel.org/process/license-rules.html>, "MODULE_LICENSE"); LKMPG
  (<https://sysprog21.github.io/lkmpg/>, 4.3 The \_\_init and \_\_exit Macros); `qemu-system-x86_64 -help`
  (`-virtfs … readonly=on`).
- **Done when:** the scripted run shows load and unload messages in `dmesg`, and Sam explains, before running it, what
  a module whose init returns `-ENOMEM` would print and whether it stays loaded.

## 03 — The kernel's C dialect: no libc, negative errno, `goto` cleanup

- **Objective:** Sam can write a kernel function with several failure points that reports errors the kernel way and
  unwinds every step it completed, in the kernel coding style.
- **Builds on:** lesson 02; `code/docs/C-CODING-PRINCIPLES.md` Section 1 (the kernel coding style is already the house
  style) and Section 3 (the negative-error-code convention).
- **Key ideas:**
  - There is no C library in the kernel: `printk` not `printf`, kernel headers only, and floating point is avoided
    because the FPU state is not saved for kernel code.
  - Functions return 0 on success or a negated errno (`-EINVAL`, `-EFAULT`, …); functions returning pointers can
    encode the error with `ERR_PTR()`, tested with `IS_ERR()` and read with `PTR_ERR()`, and not every API does.
  - Centralised exit with `goto`: one label per undo step, named after what it undoes, taken in reverse order.
  - Code in user context (module load, a system call) may sleep; code in interrupt context may not — the distinction
    kernel-03-syscalls-memory-and-concurrency builds on.
- **Recall targets:** which convention a given kernel function uses for failure; the order of the cleanup labels for a
  given sequence of steps; why a floating-point operation is out of place in kernel code.
- **Build:** the hello module's init gains two or three setup steps (for example registering things it later
  unregisters), with a way to make any one of them fail on demand, in `code/src/kernel/msNNN-hello-module/` (planned —
  added at P4). Checked in the guest by forcing each failure in turn and showing that the load fails with the right
  error and leaves nothing behind.
- **Sources:** "Linux kernel coding style" (<https://docs.kernel.org/process/coding-style.html>, 7. Centralized
  exiting of functions); "Unreliable Guide To Hacking The Linux Kernel"
  (<https://docs.kernel.org/kernel-hacking/hacking.html>, "Some Basic Rules" and "Routines and Conventions"); LKMPG
  (<https://sysprog21.github.io/lkmpg/>, 5.1 How modules begin and end, on the ERR_PTR convention).
- **Done when:** every forced failure unwinds cleanly in the guest, and Sam explains each label's order unaided.

## 04 — Module parameters and sysfs

- **Objective:** Sam can give his module load-time parameters, document them, and read or change them at run time
  through sysfs.
- **Builds on:** lessons 02–03; P2 file I/O (sysfs files are read and written like any other).
- **Key ideas:**
  - `module_param(name, type, perm)` declares a parameter; `MODULE_PARM_DESC` documents it for `modinfo`; arrays and
    strings have their own macros.
  - `insmod <module>.ko name=value` sets it at load time.
  - A non-zero permission creates `/sys/module/<module>/parameters/<name>`; the permission decides who may read or
    write it while the module runs.
  - A value written at run time arrives without the module being told, so code has to cope with it changing.
- **Recall targets:** what the third argument of `module_param` controls; where a parameter appears in sysfs; what a
  world-writable parameter would let any user do.
- **Build:** one integer and one string parameter on the hello module, in `code/src/kernel/msNNN-hello-module/`
  (planned — added at P4). Checked in the guest by loading with values, reading them back from sysfs and changing the
  writable one.
- **Security lens:** least privilege on sysfs — parameters are read-only, or root-writable only, unless there is a
  written reason (sec-04-linux-security-model covers file permissions in depth).
- **Sources:** LKMPG (<https://sysprog21.github.io/lkmpg/>, 4.5 Passing Command Line Arguments to a Module and 8
  sysfs: Interacting with your module); the tree's include/linux/moduleparam.h at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/include/linux/moduleparam.h?h=v7.2>).
- **Done when:** the parameters behave as Sam predicted in the guest, and `modinfo` shows their descriptions.

## 05 — Taint and reading an oops

- **Objective:** Sam can read a kernel oops — its message, the registers, the call trace and the taint flags — and
  map the faulting address back to a line of his own source.
- **Builds on:** lessons 02–04; kernel-01-build-and-boot-in-qemu lesson 07 (gdb against `vmlinux`).
- **Key ideas:**
  - The kernel records a taint when something makes it less trustworthy: an out-of-tree module sets `O` (bit 12),
    an unsigned module on a signing kernel `E` (bit 13), a non-GPL module `P` (bit 0), an oops `D` (bit 7).
  - Taint stays until reboot, even after the cause is unloaded; `/proc/sys/kernel/tainted` holds it as a number.
  - An oops prints the fault, the `Tainted:` line, the instruction pointer, the registers and a call trace; after an
    oops the kernel keeps running but can no longer be trusted.
  - gdb on `vmlinux` (or on the module with its load address) and the tree's scripts/decode_stacktrace.sh and
    scripts/faddr2line turn an address into a file and line.
- **Recall targets:** what each taint letter above means and which ones Sam's own modules set; the parts of an oops in
  order; why the guest is rebooted after an oops rather than trusted.
- **Build:** a module that dereferences a NULL pointer when a parameter asks it to, in
  `code/src/kernel/msNNN-oops-module/` (planned — added at P4). Checked by triggering it in the guest, capturing the
  oops, and naming the faulting line from the trace.
- **Safety:** a deliberately faulting module runs in QEMU only and is never loaded anywhere else.
- **Sources:** "Tainted kernels" (<https://docs.kernel.org/admin-guide/tainted-kernels.html>, "Table for decoding
  tainted state"); "Bug hunting" (<https://docs.kernel.org/admin-guide/bug-hunting.html>, "Finding the bug's
  location" and "gdb"); "Debugging kernel and modules via gdb"
  (<https://docs.kernel.org/process/debugging/gdb-kernel-debugging.html>, `lx-symbols`).
- **Done when:** Sam decodes a fresh oops to the right source line without help and explains the `Tainted:` flags it
  shows.

## 06 — A misc character device and the user-space boundary

- **Objective:** Sam can register a misc device, implement `read` and `write` that copy data safely across the
  user-kernel boundary, and prove it from a user-space test program in the guest.
- **Builds on:** lessons 02–05; P2 file I/O and system calls (`open`, `read`, `write` on a device node).
- **Key ideas:**
  - `misc_register()` with `MISC_DYNAMIC_MINOR` registers a small character device without the driver choosing a
    device number; `struct miscdevice` names the device, its `file_operations` and its node's `mode`.
  - A user pointer is never dereferenced: `copy_to_user()` and `copy_from_user()` return the number of bytes **not**
    copied, and a non-zero result becomes `-EFAULT`.
  - These copies may sleep, so they are not called with a spinlock held or interrupts off.
  - `read` and `write` receive a length and an offset from user space and have to bound both.
- **Recall targets:** what the copy functions return and what that return means; why a raw user pointer is never
  dereferenced; what goes wrong if `read` trusts the length it was given.
- **Build:** the misc device and a small statically linked C test program that writes to it and reads back, in
  `code/src/kernel/msNNN-misc-device/` (planned — added at P4), both packed into the guest's initramfs. Checked by the
  test program exiting 0 in the guest, including its cases for a zero-length read, an oversized write and a bad
  pointer; kernel-03-syscalls-memory-and-concurrency extends this device.
- **Security lens:** the device is an attack surface — every length and offset from user space is bounded, the node's
  mode is as narrow as the test needs, and a bad pointer returns `-EFAULT` instead of faulting the kernel.
- **Safety:** device and test run in QEMU only.
- **Sources:** "Unreliable Guide To Hacking The Linux Kernel" (<https://docs.kernel.org/kernel-hacking/hacking.html>,
  "copy_to_user() / copy_from_user() / get_user() / put_user()"); include/linux/miscdevice.h at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/include/linux/miscdevice.h?h=v7.2>);
  LKMPG (<https://sysprog21.github.io/lkmpg/>, 6 Character Device drivers); `man 2 read`; `man 2 write`.
- **Done when:** the test program passes in the guest, and Sam explains each bound his `read` and `write` enforce and
  what would happen without it.
