# Resources — kernel-08-rust-for-linux

Outline topic — every source is re-verified when the Rust toolchain is installed and the topic opens (`GAPS.md` →
"Rust-for-Linux needs clang/LLVM and bindgen").

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Status and toolchain requirements | Documentation/rust/index.rst at v6.18 and v7.2; <https://docs.kernel.org/rust/quick-start.html> (Requirements: Building; Ubuntu; docs build 7.3.0-rc4); Documentation/process/changes.rst at v7.2; <https://docs.kernel.org/rust/arch-support.html> | `how-to/docs/TOOLCHAIN.md` — Rust-for-Linux (blocked until LLVM is installed) | — |
| 02 Building a kernel with Rust support | <https://docs.kernel.org/rust/quick-start.html> (Configuration; Building); kernel/configs/rust.config and samples/rust/Kconfig at v7.2; <https://rust.docs.kernel.org/kernel/> | `how-to/docs/CLI-TOOLING.md` — Kernel and QEMU — P4 preview | `code/src/kernel/msNNN-rust-config/` (planned — added at P4) |
| 03 A minimal Rust module | samples/rust/rust_minimal.rs at v7.2; <https://docs.kernel.org/rust/general-information.html> (Abstractions vs. bindings); <https://docs.kernel.org/rust/coding-guidelines.html> | `code/docs/FFI.md` — the C and Rust boundary | `code/src/kernel/msNNN-rust-minimal/` (planned — added at P4) |
| 04 Where Rust drivers are accepted | <https://docs.kernel.org/process/maintainers.html> (entries tagged `[RUST]`, read 27/09/2026); <https://rust-for-linux.com/> | — | — |
