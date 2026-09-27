# Resources — os-17-local-model-integration

Outline topic: every source below is re-verified when this topic opens.

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 A build-system recipe for the Rust inference server | SOURCE_DATE_EPOCH, <https://reproducible-builds.org/docs/source-date-epoch/> | `project-management/src/08-DECISIONS/ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md` | the Syntek OS build-system repository (created when this build starts) |
| 02 The model file as a signed, large package | GGUF specification (ggml commit 353b63b), <https://github.com/ggml-org/ggml/blob/353b63b439f27ab2cc19dac97ab1681ba6d2d084/docs/gguf.md>; safetensors, <https://huggingface.co/docs/safetensors/>; minisign, <https://jedisct1.github.io/minisign/> | `.claude/CLAUDE.md` (Section 5, weights) | the Syntek OS build-system repository (created when this build starts) |
| 03 Running the model as a supervised service within a memory budget | docs.kernel.org "Control Group v2", <https://docs.kernel.org/admin-guide/cgroup-v2.html>; `man 5 systemd.resource-control` (`MemoryMax=`); `man 1 nvidia-smi` | — | — (sketched at topic open) |
| 04 Skills as a package with a per-skill Landlock policy | docs.kernel.org "Landlock: unprivileged access control", <https://docs.kernel.org/userspace-api/landlock.html>; `man 7 landlock` | — | — (sketched at topic open) |
| 05 A TUI front-end for the local model | ratatui documentation, <https://ratatui.rs/> | `code/docs/RUST-CODING-PRINCIPLES.md` | — (sketched at topic open) |
| 06 Measuring the resource budget on the server edition in QEMU | docs.kernel.org "VFIO", <https://docs.kernel.org/driver-api/vfio.html>; `man 1 qemu-system`; `man 1 nvidia-smi` | — | — (sketched at topic open) |
