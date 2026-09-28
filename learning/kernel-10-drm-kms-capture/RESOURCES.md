# Resources — kernel-10-drm-kms-capture

Outline topic, **learning-only** — never a capture-library backend
(`project-management/src/08-DECISIONS/ADR-MS001-SCRIPTED-RECORDER-STAGED-LEARNING-PROJECT-27-09-2026.md`). Every source
is re-verified when P5 opens and the MAP-KERNEL capture-target spike is settled.

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 DRM and KMS objects from user space | <https://docs.kernel.org/gpu/drm-uapi.html> (primary and render nodes; DRM master); <https://docs.kernel.org/gpu/drm-kms.html> (KMS overview); include/uapi/drm/drm.h and drm_mode.h at v7.2; <https://www.qemu.org/docs/master/system/devices/virtio-gpu.html> | `code/docs/C-CODING-PRINCIPLES.md` — 3. Error handling | `code/src/kernel/msNNN-drm-capture/` (planned — added at P4) |
| 02 Dumb buffers | <https://docs.kernel.org/gpu/drm-kms.html> (Dumb Buffer Objects); include/uapi/drm/drm.h at v7.2 (`DRM_IOCTL_MODE_CREATE_DUMB`; host copy linux-libc-dev 6.8.0, read 27/09/2026); <https://www.qemu.org/docs/master/system/monitor.html> (`screendump`); `man 2 mmap` | `code/docs/MEMORY-SAFETY.md` — 3. Who owns an allocation | `code/src/kernel/msNNN-drm-capture/` (planned — added at P4) |
| 03 Reading back the scanout | include/uapi/drm/drm.h at v7.2 (`DRM_IOCTL_MODE_GETFB2`, `DRM_IOCTL_GEM_CLOSE`, `DRM_IOCTL_PRIME_HANDLE_TO_FD`); <https://docs.kernel.org/driver-api/dma-buf.html> (CPU access); <https://docs.kernel.org/gpu/drm-usage-stats.html> | `code/docs/MEMORY-SAFETY.md` — 3. Who owns an allocation | `code/src/kernel/msNNN-drm-capture/` (planned — added at P4) |
| 04 Checking against kmsgrab | `man 1 ffmpeg-devices` (kmsgrab; ffmpeg 6.1.1, read 27/09/2026); `man 7 vsock`; <https://docs.kernel.org/gpu/vkms.html> | — | `code/src/kernel/msNNN-drm-capture/` (planned — added at P4) |
| 05 Why the library reads from QEMU instead | <https://docs.kernel.org/virt/kvm/api.html> (`KVM_EXIT_IO`, `KVM_EXIT_MMIO`); `man 7 qemu-qmp-ref` (`screendump`, QEMU 8.2.2); `project-management/src/08-DECISIONS/ADR-MS001-CAPTURE-LIBRARY-STANDALONE-27-09-2026.md` | — | — |
