# Resources — kernel-09-virtual-input-devices

Outline topic — every source is re-verified when P4 opens and the recorder reaches stage 5a
(`project-management/src/08-DECISIONS/ADR-MS001-SCRIPTED-RECORDER-STAGED-LEARNING-PROJECT-27-09-2026.md`).

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 The input subsystem and evdev | <https://docs.kernel.org/input/input.html> (the event interface); <https://docs.kernel.org/input/event-codes.html>; include/uapi/linux/input.h and input-event-codes.h at v7.2; <https://www.qemu.org/docs/master/system/monitor.html> (`sendkey`); `man 2 ioctl` | `code/docs/DEBUGGING.md` — 6. The kernel under QEMU and gdb | `code/src/kernel/msNNN-uinput-keyboard/` (planned — added at P4) |
| 02 A uinput keyboard | <https://docs.kernel.org/input/uinput.html> (keyboard events; mouse movements); include/uapi/linux/uinput.h at v7.2 (host copy: linux-libc-dev 6.8.0, `UINPUT_VERSION` 5, read 27/09/2026) | `code/docs/C-CODING-PRINCIPLES.md` — 3. Error handling | `code/src/kernel/msNNN-uinput-keyboard/` (planned — added at P4) |
| 03 An input guest: fragment and initramfs | drivers/input/Kconfig and drivers/input/misc/Kconfig at v7.2 (`INPUT_EVDEV`, `INPUT_UINPUT`); <https://docs.kernel.org/kbuild/headers_install.html> | `how-to/docs/CLI-TOOLING.md` — Kernel and QEMU — P4 preview | `code/src/kernel/msNNN-uinput-keyboard/` (planned — added at P4) |
| 04 The recorder's uinput input backend | <https://docs.kernel.org/input/uinput.html>; `man 7 vsock`; <https://doc.rust-lang.org/book/ch18-02-trait-objects.html>; <https://doc.rust-lang.org/nomicon/ffi.html> | `code/docs/FFI.md` — the C and Rust boundary | the scripted-recorder repository (created at the recorder's stage 2) |
