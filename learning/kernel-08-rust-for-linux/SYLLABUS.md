# Syllabus — kernel-08-rust-for-linux

**Track**: kernel · **Phase**: P4 · **Path**: Later · **Detail**: outline · **Prerequisites**: P3; kernel-02-modules — **Blocked** until clang/LLVM, libclang and bindgen are installed (`GAPS.md` → "Rust-for-Linux needs clang/LLVM and bindgen")
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The optional Rust branch of P4: where Rust stands in the kernel, what toolchain it needs, a kernel built with Rust
support in QEMU, and a minimal module written in Rust against the kernel's safe abstractions. It joins the two
languages of Sam's mission at the lowest level — his P3 Rust, including its `unsafe` and FFI lessons, meeting his P4
kernel C — and prepares him for any Rust driver a Syntek OS profile might one day carry. It is **Later** and **outline**
detail: Rust-for-Linux's requirements change release by release, so Build sketches stay short and every version below
is re-checked when the tools are installed and the topic opens. Modules built here are Kbuild modules, not Cargo
crates, so they live under `code/src/kernel/` (planned — added at P4), outside the Cargo workspace and its gates, and
they load in QEMU only.

Version facts to re-verify on the day (read 27/09/2026): the "Rust experiment" section is present in
Documentation/rust/index.rst at the 6.18 longterm tag and gone from v7.0 onwards; the v7.2 minimal requirements list
Rust 1.85.0, bindgen 0.71.1 and Clang/LLVM 17.0.1 (all marked optional, because Rust support is optional); x86 support
is x86_64 only.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Rust in the kernel: status and toolchain requirements | 1 sitting | no | — |
| 02 | Building a kernel with Rust support in QEMU | 2–3 sittings | yes — Rust-enabled config | Safety |
| 03 | A minimal Rust module and the safe abstractions | 2–3 sittings | yes — Rust minimal module | Safety |
| 04 | Where Rust drivers are accepted today | 1 sitting | no | — |

---

## 01 — Rust in the kernel: status and toolchain requirements

- **Objective:** Sam can say what the kernel's Rust support is for today, which kernel lines treat it as an
  experiment, and exactly which tools a Rust-enabled build needs.
- **Builds on:** P3 (the Rust book to `unsafe` and FFI); kernel-01-build-and-boot-in-qemu lesson 01 (release lines).
- **Key ideas:**
  - Rust support was merged in v6.1; the 6.18 documentation still frames it as an experiment for kernel developers,
    and from v7.0 that framing is gone — so the answer depends on the line a profile runs.
  - A Rust-enabled build uses a full LLVM toolchain (`LLVM=1`); building it with GCC is documented as very
    experimental.
  - Beyond `rustc`, the kernel needs the Rust standard library's source (`rust-src`), bindgen and libclang;
    `make LLVM=1 rustavailable` reports what is missing and why.
  - The repository's pinned workspace toolchain installs only rustfmt and clippy; the kernel build brings its own
    requirements (a `rustup override` in the kernel build directory, or Ubuntu 24.04's versioned packages as the
    quick-start guide describes).
- **Recall targets:** the three extra tools and what each does; how the status differs between the 6.18 line and v7.x;
  what `rustavailable` checks.
- **Build:** none.
- **Sources:** (to verify when the topic opens) "Rust" index at v6.18 and v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/Documentation/rust/index.rst?h=v6.18>,
  <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/Documentation/rust/index.rst?h=v7.2>);
  "Quick Start" (<https://docs.kernel.org/rust/quick-start.html>, "Requirements: Building" and "Ubuntu");
  minimal requirements at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/Documentation/process/changes.rst?h=v7.2>);
  "Arch Support" (<https://docs.kernel.org/rust/arch-support.html>).
- **Done when:** `make LLVM=1 rustavailable` passes in Sam's kernel tree and he explains each requirement it checked.

## 02 — Building a kernel with Rust support in QEMU

- **Objective:** Sam can configure, build and boot a kernel with Rust support and load the kernel's own minimal Rust
  sample in QEMU.
- **Builds on:** lesson 01; kernel-01-build-and-boot-in-qemu lessons 03–06 (fragments, `O=`, the harness).
- **Key ideas:**
  - `CONFIG_RUST` sits in General setup and only appears when a suitable toolchain is found; the tree's
    kernel/configs/rust.config fragment turns it on, so `make rust.config` works like any other fragment.
  - The Rust samples under samples/rust/ sit behind a "Rust samples" menu that depends on `CONFIG_RUST`; the minimal
    sample is a tristate, so it can be built as a module and loaded in the guest.
  - Rust code documentation for the running configuration can be generated, and a pregenerated copy is published.
- **Recall targets:** why the Rust option can be invisible in `menuconfig`; how the fragment method from kernel-04
  applies here.
- **Build:** a Rust-enabling fragment on top of the kernel-01 QEMU fragment, in `code/src/kernel/msNNN-rust-config/`
  (planned — added at P4). Checked by a clean `LLVM=1` build and the minimal sample loading and unloading in the guest.
- **Safety:** QEMU only.
- **Sources:** (to verify when the topic opens) "Quick Start" (<https://docs.kernel.org/rust/quick-start.html>, "Configuration",
  "Building" and "Hacking"); samples/rust/Kconfig at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/samples/rust/Kconfig?h=v7.2>,
  SAMPLES_RUST and SAMPLE_RUST_MINIMAL); rust.config at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/kernel/configs/rust.config?h=v7.2>); Rust
  code documentation (<https://rust.docs.kernel.org/kernel/>).
- **Done when:** the Rust-enabled kernel boots and the sample's load and unload messages are captured.

## 03 — A minimal Rust module and the safe abstractions

- **Objective:** Sam can write, build and load his own minimal Rust module, and explain the difference between the
  kernel's bindings and its safe abstractions.
- **Builds on:** lesson 02; kernel-02-modules lessons 01–04 (the same module life cycle in C); P3 `unsafe` and FFI
  (`code/docs/FFI.md`).
- **Key ideas:**
  - A module declares itself with the `module!` macro (type, name, authors, description, licence, parameters) and
    uses the kernel crate's prelude instead of `std`.
  - Bindings are the generated Rust declarations of C functions and types; abstractions wrap them into safe,
    idiomatic APIs, and leaf code such as drivers uses the abstractions, not the bindings.
  - Every `unsafe` block carries a `// SAFETY:` comment saying why it is sound — the same rule Sam's P3 FFI crate
    follows.
- **Recall targets:** what the `module!` macro declares; bindings against abstractions; what a `// SAFETY:` comment
  must argue.
- **Build:** Sam's own minimal Rust module with one parameter, in `code/src/kernel/msNNN-rust-minimal/` (planned —
  added at P4). Checked by loading it with a parameter in the guest and reading the value back.
- **Safety:** QEMU only.
- **Sources:** (to verify when the topic opens) samples/rust/rust_minimal.rs at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/samples/rust/rust_minimal.rs?h=v7.2>);
  "General Information" (<https://docs.kernel.org/rust/general-information.html>, "Abstractions vs. bindings");
  "Coding Guidelines" (<https://docs.kernel.org/rust/coding-guidelines.html>, the `// SAFETY:` comments).
- **Done when:** the module loads, takes its parameter and unloads in the guest, and Sam justifies every `unsafe`
  block, if it has any.

## 04 — Where Rust drivers are accepted today

- **Objective:** Sam can find which subsystems accept Rust code today and what a subsystem expects before a Rust
  driver is proposed.
- **Builds on:** lessons 01–03; kernel-07-upstreaming lesson 02 (MAINTAINERS and get_maintainer.pl) if taken.
- **Key ideas:**
  - MAINTAINERS entries tagged `[RUST]` show where Rust is accepted: on 27/09/2026 (documentation build 7.3.0-rc4)
    they covered subsystem APIs such as PCI, I2C, block-device drivers, DRM, PWM and the Ethernet PHY library, and
    drivers such as the ASIX PHY driver and the NVIDIA GPU core and DRM drivers.
  - Acceptance is decided per subsystem by its maintainers; abstractions for a subsystem have to exist before drivers
    can use it.
  - The picture changes each release, so it is read on the day, never remembered.
- **Recall targets:** how to find the current Rust drivers; who decides whether a subsystem takes Rust.
- **Build:** none.
- **Sources:** (to verify when the topic opens) "List of maintainers" (<https://docs.kernel.org/process/maintainers.html>, entries tagged
  `[RUST]`); "General Information" (<https://docs.kernel.org/rust/general-information.html>); the Rust-for-Linux
  project (<https://rust-for-linux.com/>).
- **Done when:** Sam lists the subsystems with Rust drivers in the current release, from MAINTAINERS, with the date
  he read it.
