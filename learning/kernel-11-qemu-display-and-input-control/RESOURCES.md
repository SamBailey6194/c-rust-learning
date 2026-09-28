# Resources — kernel-11-qemu-display-and-input-control

Outline topic — every source is re-verified when P4 is open and the recorder's Wayland stages are `Done`
(`project-management/src/08-DECISIONS/ADR-MS001-SCRIPTED-RECORDER-STAGED-LEARNING-PROJECT-27-09-2026.md`).

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 From the human monitor to QMP | `man 7 qemu-qmp-ref` (QEMU 8.2.2, read 27/09/2026: `qmp_capabilities`); <https://www.qemu.org/docs/master/interop/qmp-spec.html>; `man 1 qemu-system` (`-qmp`, `-mon`, `-chardev`); <https://docs.kernel.org/virt/kvm/api.html> (`KVM_EXIT_IO`, `KVM_EXIT_MMIO`); `man 7 unix` | `code/docs/DEBUGGING.md` — 6. The kernel under QEMU and gdb | the capture-library repository (created at the recorder's stage 2) |
| 02 `screendump`: polled frames | `man 7 qemu-qmp-ref` (`screendump`, `ImageFormat`); <https://netpbm.sourceforge.net/doc/ppm.html>; QEMU os-posix.c at v8.2.2 (`os_setup_post()`), <https://gitlab.com/qemu-project/qemu/-/blob/v8.2.2/os-posix.c> | — | the capture-library repository |
| 03 RFB over a Unix socket | <https://www.rfc-editor.org/rfc/rfc6143> (7.1, 7.5.3, 7.6.1); `man 1 qemu-system` (`-vnc unix:path`; `-display dbus`); <https://github.com/rfbproto/rfbproto> | — | the capture-library repository |
| 04 Input from outside the guest | `man 7 qemu-qmp-ref` (`send-key`, `input-send-event`, `InputMoveEvent`, `QKeyCode`); QEMU include/ui/input.h at v8.2.2; `man 1 qemu-system` (`-k`) | — | the scripted-recorder repository (created at the recorder's stage 2) |
| 05 libvirt as a wrapper | <https://libvirt.org/html/libvirt-libvirt-domain.html> (`virDomainScreenshot`, `virDomainSendKey`); <https://libvirt.org/acl.html>; `man 1 virsh` (libvirt 10.0.0: `screenshot`, `send-key`); src/qemu/qemu_driver.c at v10.0.0 | — | — |
| 06 The QEMU backend and input | the staging and capture-library ADRs (`project-management/src/08-DECISIONS/`); lessons 01–05's sources | `code/docs/RUST-CODING-PRINCIPLES.md`; `code/docs/FFI.md` — the C and Rust boundary | the capture-library and scripted-recorder repositories |
