# ROADMAP — c-rust-learning

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

> A public learning space: learn C thoroughly from the base level, then deepen Rust knowledge and
> skills, and then build a custom Linux kernel for a custom set of Linux distributions at three
> tiers — beginner, intermediate and experienced.

This file **owns the phases**. Every other document that names a phase — a milestone's `**Phase:**`
line, a guide, a workflow — cites this file rather than describing the phase again. A phase is
defined by its **exit gate**, not by its topic list: the topics say what to study, the gate says
what has to be demonstrably true before the next phase starts. Where a gate can be checked by a
command, the command is written down.

---

## You are here

| Phase | Milestone | Status | Next step |
| --- | --- | --- | --- |
| **P1 — C foundations** | `MS001` — Toolchain ready | Open | Verify the toolchain per `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md`, then chart the P1 track map |

Milestone status words are owned by `project-management/docs/planning/MILESTONES.md`. This marker
moves only on evidence: a milestone closes with a verification record in
`project-management/src/10-PROGRESS/`, and a phase closes when its exit gate below passes.

---

## Phase overview

| Phase | Name | Covers | Exit gate (summary) | State |
| --- | --- | --- | --- | --- |
| P1 | C foundations | types, operators, control flow, functions, arrays, strings, pointers, structs and unions, the memory model, the preprocessor, multi-file programs, make | can write, test, sanitise and memcheck a multi-file C program unaided | **Current** |
| P2 | C systems | dynamic memory and a custom allocator, data structures, file I/O, POSIX syscalls, processes and signals, threads, sockets; projects: own malloc, a Unix shell, a small libc subset | shell and malloc projects pass their tests, valgrind clean | Not started |
| P3 | Rust | ownership and borrowing, traits and generics, error handling, collections and iterators, concurrency, `unsafe`, FFI with C; port a P2 C project to Rust | the Rust port passes the C project's tests; the FFI crate has both suites green | Not started |
| P4 | Kernel internals | build and boot a kernel in QEMU, Kconfig, out-of-tree modules in C, kernel data structures, syscalls, debugging with QEMU and gdb; Rust-for-Linux (needs clang/LLVM) | a custom-configured kernel boots in QEMU to a busybox shell; a module loads and unloads in QEMU | Not started |
| P5 | Custom kernel | per-tier Kconfig fragments, a patch series, minimal init and initramfs | three tier configs build and boot in QEMU | Not started |
| P6 | Distro tiers | beginner, intermediate and experienced: root filesystem, package management, installer, documentation | each tier image boots in QEMU and meets its TIER spec | Not started |

**How milestones get numbers.** Only `MS001` is allocated. Every other milestone below is a
**candidate** — a named slice of work with no number yet. When a phase's track map is charted in
this folder, its slices are cut into milestones by `project-management/workflows/02-milestone-creation/`,
which allocates the next free `MS###`. The final count and order may differ from these lists: the
lists are a starting hypothesis, and the maps settle them.

**Where evidence lands.** Every exit gate below is proved in a verification record in
`project-management/src/10-PROGRESS/`, using the commands named here. The build targets and flags
behind those commands are owned by `code/docs/BUILD.md`; the gate scripts that wrap them are
described in `how-to/workflows/03-quality-gates/`.

---

## P1 — C foundations

**Goal:** write, test, sanitise and memcheck a multi-file C17 program unaided, in Linux kernel
coding style, and be able to say what every line does to memory.

**Topics:**

- Types and their sizes: `sizeof`, `<stdint.h>`, `<limits.h>`, integer promotions and the usual
  arithmetic conversions
- Operators and precedence; undefined behaviour in expressions (signed overflow, oversized shifts,
  unsequenced modifications)
- Control flow; functions, prototypes and scope; storage duration and linkage (`static`, `extern`)
- Arrays, and how they decay to pointers
- Strings as `char` arrays: NUL termination, bounded writes with `snprintf`, why `strcpy` and
  `strcat` need care
- Pointers: arithmetic, `const` correctness, pointers to pointers, function pointers
- Structs, unions and enums; alignment and padding
- The memory model: automatic, static and allocated storage; `malloc` and `free`; object lifetime
- The preprocessor: `#include`, object-like and function-like macros and their traps, include
  guards, conditional compilation
- Multi-file programs: headers versus translation units, what the linker resolves, and GNU make

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| `MS001` — Toolchain ready (allocated) | gcc, make, gdb, valgrind and the Rust toolchain verified; the `ms001-hello` pair green on every gate |
| Types, operators and expressions | sizes, conversions, and the undefined behaviour UBSan catches |
| Control flow and functions | prototypes, scope, `static`, recursion |
| Arrays and strings | bounds, NUL termination, bounded copies |
| Pointers | arithmetic, `const`, pointers to pointers, function pointers |
| Structs, unions and enums | layout, padding, tagged unions |
| Memory: storage and lifetime | stack versus heap, ownership rules written down, leaks and use-after-free under ASan and valgrind |
| Preprocessor and multi-file builds | headers, include guards, make dependency files |
| P1 capstone | a small multi-file tool (for example a `wc`-style counter or an INI-file parser) specified in `project-management/src/05-PROJECTS/` |

**Exit gate:** a multi-file C program — at least two `.c` translation units and a header —
written without copying a solution, for which all four targets exit 0:

```bash
make -C code/src/c/<exercise-dir> test
make -C code/src/c/<exercise-dir> san
make -C code/src/c/<exercise-dir> memcheck
make -C code/src/c/<exercise-dir> lint
```

In addition, the learner can explain each warning flag the build uses (`code/docs/BUILD.md`) and
has recorded one gdb walkthrough of their own bug in the milestone's learning notes.

**Primary resources:**

- **K. N. King, _C Programming: A Modern Approach_, 2nd edition** (W. W. Norton) — main text for
  the language, C99-based; C17 differences are small.
- **Jens Gustedt, _Modern C_** — <https://gustedt.gitlabpages.inria.fr/modern-c/> — a current
  treatment of standard C, read alongside King.
- **cppreference, C reference** — <https://en.cppreference.com/w/c> — per-feature lookup, with
  the standard version each feature arrived in.
- **WG14 (the C standards committee)** — <https://www.open-std.org/jtc1/sc22/wg14/> — the
  document index; its working drafts are the free stand-in for the ISO text.
- **GCC manual** — <https://gcc.gnu.org/onlinedocs/> — Warning Options and Instrumentation Options
  explain every flag the build uses.
- **GNU make manual** — <https://www.gnu.org/software/make/manual/>
- **Linux kernel coding style** — <https://docs.kernel.org/process/coding-style.html>
- **Beej's Guide to C Programming** — <https://beej.us/guide/bgc/> — a lighter second explanation.

---

## P2 — C systems

**Goal:** use C the way systems code does — managing memory by hand, talking to the kernel
through system calls, running and coordinating processes and threads — and finish three projects:
a memory allocator, a Unix shell and a small libc subset.

**Topics:**

- Dynamic memory in depth: the `malloc` / `realloc` / `free` contracts, alignment, fragmentation;
  where the heap comes from (`brk`, `sbrk`, `mmap`)
- A custom allocator: free lists, splitting and coalescing, alignment guarantees
- Data structures with written-down ownership: dynamic arrays, linked lists, hash tables, trees
- File I/O: `stdio` buffering versus `open` / `read` / `write` / `close`; file descriptors
- POSIX system calls and `errno`
- Processes: `fork`, `execve`, `waitpid`, exit status; pipes and `dup2`
- Signals: `sigaction`, async-signal-safety
- Threads: POSIX threads, mutexes, condition variables; finding data races with
  `-fsanitize=thread`, which runs in its own build because it cannot be combined with ASan
- Sockets: a TCP client and server with `socket`, `bind`, `listen`, `accept`, `connect`

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| Dynamic memory and data structures | ownership rules, growth strategies, valgrind-clean containers |
| File I/O and system calls | descriptors, buffering, error handling with `errno` |
| Processes, pipes and signals | `fork` / `exec` / `wait`, redirection, signal handling |
| Threads and synchronisation | mutexes, condition variables, a race found and fixed |
| Sockets | a small TCP echo server and client |
| Project: own `malloc` | specified in `project-management/src/05-PROJECTS/` |
| Project: a Unix shell | pipelines, redirection, built-ins, job control as stretch |
| Project: a small libc subset | string and memory functions, a minimal formatted printer |

**Exit gate:** the shell and allocator projects pass their specified test suites, and for each
project directory `make -C code/src/c/<project-dir> test` and
`make -C code/src/c/<project-dir> memcheck` exit 0, with valgrind reporting
`ERROR SUMMARY: 0 errors`.

> **An allocator under valgrind needs care.** valgrind intercepts any globally exported `malloc`
> and `free` — including your own — so a test run of an allocator named `malloc` measures
> valgrind's allocator, not yours. The allocator project therefore tests its functions under their
> own names, and can mark its blocks with the client requests in `<valgrind/valgrind.h>`
> (`VALGRIND_MALLOCLIKE_BLOCK`, `VALGRIND_FREELIKE_BLOCK`). See `man valgrind`, option
> `--soname-synonyms`. The project spec decides which approach it takes.

**Primary resources:**

- **Michael Kerrisk, _The Linux Programming Interface_** (No Starch Press) — the reference for
  every syscall topic above.
- **Linux man-pages** — <https://man7.org/linux/man-pages/> — also installed locally (`man 2 fork`).
- **R. and A. Arpaci-Dusseau, _Operating Systems: Three Easy Pieces_** —
  <https://pages.cs.wisc.edu/~remzi/OSTEP/> — free-space management, processes and concurrency.
- **Bryant and O'Hallaron, _Computer Systems: A Programmer's Perspective_, 3rd edition** — its
  allocator and shell labs are the classic shape of the two main projects.
- **POSIX.1-2024 (The Open Group Base Specifications, Issue 8)** —
  <https://pubs.opengroup.org/onlinepubs/9799919799/> — what the standard guarantees, as opposed to
  what Linux does.

---

## P3 — Rust

**Goal:** rebuild what P2 taught in safe, idiomatic Rust, and learn exactly where `unsafe` is
needed and how to contain it — by porting a P2 C project and by bridging Rust and C through FFI.

**Topics:**

- Ownership, borrowing and lifetimes — contrasted with the C memory model from P1 and P2
- Structs, enums and pattern matching; traits and generics
- Error handling: `Result`, the `?` operator, custom error types; the workspace warns on
  `unwrap` and `expect`
- Collections, iterators and closures
- Modules, crates and the Cargo workspace; unit, integration and doc tests
- Concurrency: threads, `Send` and `Sync`, `Arc` and `Mutex`, channels
- Smart pointers: `Box`, `Rc`, `RefCell`
- `unsafe`: raw pointers, the invariants an `unsafe` block promises, `// SAFETY:` comments
- FFI with C: `#[repr(C)]`, `unsafe extern "C"` blocks and `#[unsafe(no_mangle)]` (both spelled
  this way in edition 2024), linking a C library from Cargo with a build script

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| Ownership and borrowing | the same bugs P1 caught at runtime, now caught at compile time |
| Traits, generics and error handling | designing an API with `Result` |
| Collections, iterators and closures | idiomatic data processing |
| Concurrency | the P2 threading exercise, rewritten |
| `unsafe` and raw pointers | what the compiler stops checking, and what you then owe |
| FFI: Rust and C in both directions | a C library called from Rust, a Rust function called from C |
| Project: port a P2 C project to Rust | candidates: the shell or the libc subset |

**Exit gate:** from `code/src/rust/`, where `rust-toolchain.toml` selects the pinned toolchain,
all three commands exit 0, and the port's tests are built from the same cases as the C project's
suite:

```bash
cargo test
cargo fmt --all --check
cargo clippy --all-targets -- -D warnings
```

The FFI crate's C side passes `make ... test` and its Rust side passes `cargo test`: both suites
green. The workspace denies `unsafe_code`, so the FFI milestone decides — by ADR in
`project-management/src/08-DECISIONS/` — how `unsafe` is allowed in that one crate, and every
`unsafe` block carries a `// SAFETY:` comment.

**Primary resources:**

- **_The Rust Programming Language_** — <https://doc.rust-lang.org/book/>
- **_Rust by Example_** — <https://doc.rust-lang.org/rust-by-example/>
- **_The Rust Reference_** — <https://doc.rust-lang.org/reference/>
- **_The Rustonomicon_** — <https://doc.rust-lang.org/nomicon/> — `unsafe`, FFI and the invariants.
- **_The Rust Edition Guide_** — <https://doc.rust-lang.org/edition-guide/> — what edition 2024
  changed, including `unsafe extern` and unsafe attributes.
- **Clippy lint list** — <https://rust-lang.github.io/rust-clippy/>
- **Rustlings** — <https://github.com/rust-lang/rustlings> — small drills alongside the book.

---

## P4 — Kernel internals

**Goal:** fetch, configure, build, boot and debug a Linux kernel entirely inside QEMU, and write
loadable modules in C against that kernel.

**Topics:**

- Kernel releases (mainline, stable, longterm) and choosing a target; verifying a source tarball
- Host build dependencies (`docs.kernel.org` "Minimal requirements"): flex, bison, libelf
  headers and pahole are not yet installed on the host, so this is the first P4 step
  (`GAPS.md` → "Kernel build dependencies not installed")
- Kbuild: out-of-tree build directories (`make O=...`), `make x86_64_defconfig`,
  `make kvm_guest.config`, `make menuconfig`, `make olddefconfig`
- Booting in QEMU without a disk: `-kernel`, `-initrd`, `-append "console=ttyS0"`, `-nographic`,
  and a busybox initramfs
- Out-of-tree modules in C: `module_init` / `module_exit`, `pr_info`, and
  `make -C <kernel-build-dir> M=$PWD` against the QEMU kernel's own tree, not the host's
- Kernel data structures: `struct list_head`, `kmalloc` and GFP flags, reference counting
- System calls: how user space enters the kernel, and tracing one call end to end
- Debugging: QEMU's gdb stub (`-s -S`, then `target remote :1234`), `nokaslr`,
  `CONFIG_GDB_SCRIPTS` helpers, `dmesg`
- Rust-for-Linux: blocked until clang/LLVM and bindgen are installed; `make LLVM=1 rustavailable`
  reports what is missing

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| Kernel source and host build dependencies | the missing packages installed, a source tree outside the repo |
| First build and QEMU boot | `defconfig` plus `kvm_guest.config` to a busybox shell over the serial console |
| Kconfig: from defconfig to a trimmed config | a saved config fragment, understood line by line |
| Hello-world module | load and unload inside the QEMU guest, messages in `dmesg` |
| Kernel data structures and a character device | a module exposing a device node |
| System calls and tracing | following one syscall from user space into the kernel |
| Debugging the kernel with QEMU and gdb | a breakpoint in kernel code, a backtrace read |
| Rust-for-Linux (blocked) | needs clang/LLVM and bindgen; `GAPS.md` → "Rust-for-Linux needs clang/LLVM and bindgen" |

**Exit gate:** a custom-configured kernel — a committed config fragment applied on a recorded
base, not an untouched defconfig — boots in QEMU to a busybox shell; an out-of-tree module built
against that same tree loads with `insmod` and unloads with `rmmod` inside the QEMU guest, with the
`dmesg` lines captured. The QEMU command, a serial-console excerpt and the `dmesg` excerpt are
recorded in a `KERNEL-IMPL-MS###-...` record in `project-management/src/06-KERNEL/`. Nothing is
installed on or loaded into the host kernel: the kernel safety rule in `.claude/CLAUDE.md`.

**Primary resources:**

- **The Linux kernel documentation** — <https://docs.kernel.org/>
- **Minimal requirements to compile the kernel** — <https://docs.kernel.org/process/changes.html>
- **Configuration targets and editors (Kconfig)** — <https://docs.kernel.org/kbuild/kconfig.html>
- **Building external modules** — <https://docs.kernel.org/kbuild/modules.html>
- **Debugging kernel and modules via gdb** —
  <https://docs.kernel.org/process/debugging/gdb-kernel-debugging.html>
- **Rust quick start** — <https://docs.kernel.org/rust/quick-start.html>
- **_The Linux Kernel Module Programming Guide_** — <https://sysprog21.github.io/lkmpg/> — kept
  current with recent kernels.
- **QEMU system emulation** — <https://www.qemu.org/docs/master/system/index.html>
- **kernel.org releases** — <https://www.kernel.org/category/releases.html> — which branches are
  maintained, and for how long.
- **Robert Love, _Linux Kernel Development_, 3rd edition** — concepts; written for 2.6-era
  kernels, so check every API against the current documentation.

---

## P5 — Custom kernel

**Goal:** turn one generic kernel build into three deliberate ones — a Kconfig fragment per distro
tier, a maintained patch series, and a minimal init and initramfs — each reproducible from what is
committed in this repository.

**Topics:**

- Config fragments: merging with the kernel's `scripts/kconfig/merge_config.sh` then
  `make olddefconfig`; checking what a fragment changed with `scripts/diffconfig`
- Size against hardware coverage, per tier
- Patch series: `git format-patch`, `git am`, carrying a series onto a new release;
  `scripts/checkpatch.pl`
- Minimal init: what PID 1 is responsible for; busybox `init` against a hand-written C init
- Building an initramfs: `find . | cpio -o -H newc | gzip`, or `CONFIG_INITRAMFS_SOURCE`
- Reproducibility: a pinned kernel version, a recorded base config, `KBUILD_BUILD_TIMESTAMP`

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| Tier config fragments | beginner, intermediate and experienced fragments, each justified line by line |
| A patch series across an update | a small series rebased onto the next release |
| Minimal init and initramfs | a C init that mounts `/proc` and `/sys` and starts a shell |
| Reproducible kernel builds | two clean builds from the same inputs, compared |

**Exit gate:** for each of the three tiers, base config plus tier fragment, then
`make olddefconfig`, then a build from a clean output directory succeeds; each resulting kernel
boots in QEMU to its init; the fragments and the patch series are committed (they live under
`code/src/kernel/`, planned — added at P4); and each tier has a `KERNEL-IMPL-MS###-...` record with
the build and boot evidence.

**Primary resources:**

- **Configuration targets and editors (Kconfig)** — <https://docs.kernel.org/kbuild/kconfig.html>
- **Ramfs, rootfs and initramfs** — <https://docs.kernel.org/filesystems/ramfs-rootfs-initramfs.html>
- **Reproducible builds** — <https://docs.kernel.org/kbuild/reproducible-builds.html>
- **Submitting patches** — <https://docs.kernel.org/process/submitting-patches.html> — the
  patch and commit-message discipline, even for a series that never leaves this repository.
- **checkpatch** — <https://docs.kernel.org/dev-tools/checkpatch.html>
- **BusyBox** — <https://busybox.net/>

---

## P6 — Distro tiers

**Goal:** build three bootable distribution images — beginner, intermediate and experienced — on
the P5 kernels, each meeting its tier spec.

**Topics:**

- Root filesystem layout (the Filesystem Hierarchy Standard); user space built from source against
  user space taken from an existing base
- Package management: formats, dependency resolution, repositories; using one against building one
- Init systems and service management
- Installers: from a documented manual install to a guided one
- Bootloaders and disk images for QEMU
- Documentation written for each audience; rescue and recovery paths
- Choosing a distro base — from scratch in the Linux From Scratch style, a build system such as
  Buildroot or the Yocto Project, or a Debian-family base — which is an ADR, not yet decided
  (`GAPS.md` → "Distro build approach undecided")

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| Distro base decision and a first root filesystem | the base ADR, then a rootfs that boots on a P5 kernel |
| Package management per tier | how much of the package manager each tier exposes |
| Init and services | the init hypothesis for each tier, tested |
| Installer per tier | from manual to guided |
| Documentation and rescue tooling per tier | written for the tier's target user |
| Tier images | beginner, intermediate and experienced, each passing its TIER spec |

**Exit gate:** each tier image boots in QEMU and meets every acceptance item in its tier spec in
`project-management/src/07-DISTRO-TIERS/` — which, by then, has moved from `Draft` to `Specified`
— with evidence per tier in a verification record, which moves the tier to `Verified`.

**Primary resources:**

- **Linux From Scratch** — <https://www.linuxfromscratch.org/lfs/>
- **Beyond Linux From Scratch** — <https://www.linuxfromscratch.org/blfs/>
- **Filesystem Hierarchy Standard** — <https://refspecs.linuxfoundation.org/fhs.shtml>
- **Buildroot manual** — <https://buildroot.org/downloads/manual/manual.html>
- **Debian debootstrap** — <https://wiki.debian.org/Debootstrap>
- **Arch Linux installation guide** — <https://wiki.archlinux.org/title/Installation_guide> — a
  well-known model of a documented manual install, relevant to the experienced tier.

---

## Changing the roadmap

- **A phase's scope or exit gate changes** through `project-management/workflows/01-roadmap-map/`;
  the previous wording stays in an HTML comment beside the change.
- **Reordering, adding or dropping a phase** is hard to reverse, so it is decided by an ADR in
  `project-management/src/08-DECISIONS/` before this file changes.
- **A topic parked for later** goes to `DEFERRED.md` with its target phase, rather than being
  deleted from here.
- **A blocker** (a missing package, a tool that will not install) goes to `GAPS.md`; the milestone
  it blocks is marked with the blocked status from `project-management/docs/planning/MILESTONES.md`.

---

## Cross-references

- `project-management/src/01-ROADMAP/CONTEXT.md` — the map index for each track charted here
- `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` — the one allocated milestone
- `project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md` — the tier hypotheses P5 and P6 test
- `project-management/docs/PLANNING-GUIDE.md` — cadence, milestone and sprint rules
- `code/docs/BUILD.md` — the make targets and flags the exit gates call
- `how-to/docs/TOOLCHAIN.md` — host tool versions
- `GAPS.md`, `DEFERRED.md` — blockers and parked topics
