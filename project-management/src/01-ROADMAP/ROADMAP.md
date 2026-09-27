# ROADMAP — c-rust-learning

**Last Updated**: 28/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

<!-- CHANGED 27/09/2026: previously read "A public learning space: learn C thoroughly from the base
     level, then deepen Rust knowledge and skills, and then build a custom Linux kernel for a custom
     set of Linux distributions at three tiers — beginner, intermediate and experienced." Widened by
     ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md. -->
> A public learning space: learn C thoroughly from the base level and deepen Rust; learn Linux kernel
> development and maintain a downstream kernel; build Syntek OS — an independent Linux distribution,
> built from scratch, with profiles for beginner, intermediate and expert desktops and laptops,
> servers, NAS, homelab and routers, and its own TUI and GUI tools; and, in parallel, build and train
> a language model in C, Rust and Python that uses CPU, RAM, GPU, VRAM and cache efficiently and
> securely, and works through Markdown skills, workflows and documentation.

This file **owns the phases**. Every other document that names a phase — a milestone's `**Phase:**`
line, a guide, a workflow — cites this file rather than describing the phase again. A phase is
defined by its **exit gate**, not by its topic list: the topics say what to study, the gate says
what has to be demonstrably true before the next phase starts. Where a gate can be checked by a
command, the command is written down.

**Eighteen phases in six tracks.** The spine is Foundation (P1 to P3) → Kernel (P4 to P5) → OS (P6);
three side tracks run beside it — UI (U1 to U3), LLM (L1 to L6) and Security (S1 to S3). A track's
phases keep their own letters, so nothing is renumbered as tracks are added. **Parallel means
interleaved, not concurrent:** a phase opens when its "Opens after" gates pass, several phases (at
most one per track) may be open at once, but milestones still run one at a time through verification
and merge (`project-management/docs/planning/CADENCE.md` → _Why not two at once_). The tracks and
this interleaving are set by
`project-management/src/08-DECISIONS/ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md`.

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

Each phase names its **track** and what it **opens after**. Foundation is the spine; Kernel and OS
follow it; UI, LLM and Security interleave. The old six-phase table (P1 to P6) widened to this on
27/09/2026 (`project-management/src/08-DECISIONS/ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md`).

| Phase | Name | Track | Opens after | Exit gate (summary) | State |
| --- | --- | --- | --- | --- | --- |
| P1 | C foundations | Foundation | now | can write, test, sanitise and memcheck a multi-file C program unaided | **Current** |
| P2 | C systems | Foundation | P1 | shell and malloc projects pass their tests, valgrind clean | Not started |
| P3 | Rust | Foundation | P2 | the Rust port passes the C project's tests; the FFI crate has both suites green | Not started |
| P4 | Kernel internals | Kernel | P3 + `tooling-03`, `tooling-04` (lessons 01–02) | a custom-configured kernel boots in QEMU to a busybox shell; a module loads and unloads in QEMU | Not started |
| P5 | Downstream kernel <!-- CHANGED 27/09/2026: was "Custom kernel" — ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md --> | Kernel | P4 | base plus first-edition (server and homelab) fragments build and boot in QEMU | Not started |
| P6 | Syntek OS <!-- CHANGED 27/09/2026: was "Distro tiers" — ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md --> | OS | P2 + `tooling-03` (+ P3 for the build system onward; `kernel-04` before `os-10`) | each profile image boots in QEMU and meets its PROFILE spec | Not started |
| U1 | TUI foundations | UI | P2 (P3 for ratatui) | a raw-mode terminal program in C, then the same in ratatui with tests | Not started |
| U2 | Syntek OS tools | UI | U1 + `tooling-05` lessons 01–07 (each later topic also names its `os-*` prerequisite) <!-- CHANGED 27/09/2026: previously read "U1 + `tooling-05` (each later topic also names its `os-*` prerequisite)" — tooling-05 gained lesson 08 (SBOMs), needed at a product's first release, not here --> | the file manager, package-manager TUI, installer and system tools build and pass their tests | Not started |
| U3 | GUI tools and web admin | UI | U2 | an accessible gtk4-rs app here, the beginner-profile Slint tool in the Syntek OS GUI-tools repository, and the NAS/router web dashboard | Not started |
| L1 | ML foundations and a local-model baseline | LLM | P1 | an open coding model runs through ollama with three skills and a gap log; a tiny GPT trains on the 2080 Ti within a measured VRAM budget | Not started |
| L2 | Hardware, memory and GPU programming | LLM | L1 (`llm-06` needs only P2) | the memory hierarchy and VRAM budget measured on this machine | Not started |
| L3 | An LLM in C (llm.c) | LLM | L2 (its C parts) | llm.c's GPT-2 read, and its CPU `test_gpt2` run clean under ASan with UBSan and under valgrind memcheck | Not started |
| L4 | Training a small code model (~100M, local GPU) | LLM | L1 + L2's GPU topic + `tooling-05` lessons 01–07, `sec-01`, `sec-04` <!-- CHANGED 27/09/2026: previously read "L1 + L2's GPU topic + `tooling-05`, `sec-01`, `sec-04`" — tooling-05 gained lesson 08 (SBOMs), needed at a product's first release, not here --> | a ~100M FIM code model trained within the VRAM budget, evaluated in the sandbox | Not started |
| L5 | Efficient, secure inference in Rust and the skills layer | LLM | L4 + P3 (with async) + `sec-01`, `sec-04` | a Rust inference path with a skill loader, its threat model and budget measured | Not started |
| L6 | Efficient architectures, scale, adapters | LLM | L5 | efficient-architecture and adapter experiments within budget | Not started |
| S1 | Security foundations | Security | P2 (sec-01 after P1) | a deliberately vulnerable C exercise shown corrupting memory with mitigations off, each mitigation toggled, then fixed; a threat model and the sandbox launcher | Not started |
| S2 | Authorised pentest lab | Security | S1 + P4 | an isolated QEMU lab with an attacker VM, a written scope, and a first recon exercise | Not started |
| S3 | Securing and testing Sam's own systems | Security | S2 (alongside P6 and L5) | the Syntek OS profiles and the model tested in the lab, hardened and re-tested | Not started |

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

## How the tracks fit together

```text
                        ┌─────────────────────────── Foundation ───────────────────────────┐
                        P1 C foundations → P2 C systems → P3 Rust
                                │              │              │
        ┌───────────────────────┘              │              └────────────────────┐
        │ (P1)                    ┌─────────────┴───────────┐                       │ (P3)
        ↓                         ↓ (P2, +P3 build system)  ↓ (P3)                  ↓
   LLM  L1 → L2 → L3        OS  P6 Syntek OS           Kernel P4 → P5          UI  U1 → U2 → U3
         → L4 → L5 → L6           (uses P5 profile             │                    │
                                   fragments) ◄────────────────┘                    │
        Security  S1 (after P2; sec-01 after P1) → S2 (+P4) → S3 (with P6 and L5) ◄──┘
```

**How the tracks interleave.** Several phases can be open at once (at most one per track), but
milestones still run **one at a time** through verification and merge
(`project-management/docs/planning/CADENCE.md` → _Why not two at once_). At each
`project-management/workflows/03-sprint-planning/` the next milestone may be cut from any open phase,
alternating the spine (Foundation → Kernel → OS) with one side track (LLM, then UI, then Security) so
no open track goes more than two milestones untouched; `/teach` runs every review that is due first,
whatever its track, and that cross-track recall counts as interleaving. This does not change CADENCE,
`project-management/docs/git/BRANCHES.md` or `.claude/CLAUDE.md` Section 2.2.

**Running tracks in parallel** is a planning stance, not a licence to build two things at once: the
one-milestone slot is the safety rail, and only a `Blocked` or `Parked` milestone releases it.

---

## Cross-cutting lenses

Two lenses apply across the roadmap, both owned here and given a milestone-level home in
`project-management/docs/planning/MILESTONES.md` (the `Budget` flag and the `## Threat model`
section):

- **Efficiency.** Every LLM, kernel-config and OS milestone states a resource budget — CPU time,
  RAM, cache behaviour, GPU time, VRAM peak — and measures it. The machine is an i9-9900K (16 MiB
  L3), 31 GiB RAM and an RTX 2080 Ti with about 9 GiB free VRAM once the desktop is running, so a run
  that will not fit is caught at planning. The measurement method is taught once in
  `learning/llm-06-cpu-performance-in-c/` lesson 01 and reused
  (`project-management/src/08-DECISIONS/ADR-MS001-LLM-EFFICIENCY-AND-SECURITY-FIRST-27-09-2026.md`).
- **Security.** Every milestone names its threat model or the non-negotiable it runs under
  (`.claude/CLAUDE.md` Section 5). Offensive work is authorised and isolated-lab-only
  (`project-management/src/08-DECISIONS/ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md`).

---

## Critical path

**Core** leads to the first server/homelab Syntek OS edition and the first own model; **Later** can
wait. This orders the interleaving without fixing milestone numbers. Each phase section below lists
its **topic folders** (`learning/<id>-<topic>/`), Core first and then Later; every folder's
`SYLLABUS.md` header carries the same phase and **Path**. A topic whose appended lessons sit on the
other path names both ranges in its header and on both lists, as `sec-05` does.

| Path | Phases and topics | Leads to |
| --- | --- | --- |
| **Core** | P1 to P3; P4 to P5 (`kernel-01` to `kernel-06`: build, modules, downstream, per-profile configs, CI); P6 from `os-01` through `os-12-homelab-edition`, plus `os-16-release-and-security-process`; U1 and, in U2, the file manager and the package-manager TUI (`ui-04`, `ui-05`); L1 to L5 (`llm-01` to `llm-18`); in S1, `sec-01`, `sec-02`, `sec-04` and `sec-05` lessons 01–07 | the first server/homelab edition and the first own model with a skills layer |
| **Later** | `kernel-07-upstreaming`, `kernel-08-rust-for-linux`; the NAS, router and desktop editions (`os-13`, `os-14`, `os-15`), the local-model integration (`os-17`) and Sam's own network (`os-18`); the installer, system-tools and remote-help TUIs (`ui-06`, `ui-07`, `ui-11`) and all of U3 (`ui-08` to `ui-10`); L6 (`llm-19` to `llm-21`); `sec-03`, `sec-05` lessons 08–13 (the private CA), and all of S2 and S3 (`sec-06` to `sec-19`) <!-- CHANGED 27/09/2026: previously read "`kernel-07-upstreaming`, `kernel-08-rust-for-linux`; the NAS, router and desktop editions (`os-13`, `os-14`, `os-15`) and the local-model integration (`os-17`); the installer and system-tools TUIs (`ui-06`, `ui-07`) and all of U3 (`ui-08` to `ui-10`); L6 (`llm-19` to `llm-21`); `sec-02` and `sec-03` (S1's exit gate waits on `sec-02`), and all of S2 and S3 (`sec-06` to `sec-19`)" — networking and licensing round: sec-02 to Core (Sam, carry-over question 4); sec-05's private-CA lessons appended as Later (Q9); os-18 added (Q8); ui-11 added (Q10) --> | breadth once the first edition and model ship |

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

**Topic folders:** `tooling-03`, `tooling-04`, `tooling-05`; the `c` topics are suggested in `learning/CONTEXT.md`, not yet created.

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

**Topic folders:** none pre-seeded; `/teach` creates the `c` topics suggested in `learning/CONTEXT.md`.

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
- Async Rust: futures and async/await, the tokio runtime, tasks and channels, `select!`,
  cancellation, and `spawn_blocking` — the base the U1 render loop and L5 serving build on

**Topic folders:** none pre-seeded; `/teach` creates the `rust` topics suggested in `learning/CONTEXT.md`.

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| Ownership and borrowing | the same bugs P1 caught at runtime, now caught at compile time |
| Traits, generics and error handling | designing an API with `Result` |
| Collections, iterators and closures | idiomatic data processing |
| Concurrency | the P2 threading exercise, rewritten |
| `unsafe` and raw pointers | what the compiler stops checking, and what you then owe |
| FFI: Rust and C in both directions | a C library called from Rust, a Rust function called from C |
| Async I/O | the P2 sockets exercise rewritten as a concurrent tokio client and server |
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
- Debugging: QEMU's gdb stub on loopback (`-gdb tcp:127.0.0.1:1234 -S`, never bare `-s`, then
  `target remote 127.0.0.1:1234`), `nokaslr`,
  `CONFIG_GDB_SCRIPTS` helpers, `dmesg`
- Rust-for-Linux: blocked until clang/LLVM and bindgen are installed; `make LLVM=1 rustavailable`
  reports what is missing

**Topic folders:** `kernel-01`, `kernel-02`, `kernel-03`; Later `kernel-08`.

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

## P5 — Downstream kernel

<!-- CHANGED 27/09/2026: phase name was "Custom kernel"; goal previously read "turn one generic
     kernel build into three deliberate ones — a Kconfig fragment per distro tier, a maintained patch
     series, and a minimal init and initramfs — each reproducible from what is committed in this
     repository"; the old exit gate read "three tier configs build and boot in QEMU". Widened to a
     downstream of upstream Linux with per-profile fragments and a first-edition gate. See
     ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md and
     ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md. The old "Minimal init and initramfs"
     candidate moved to P6 (os-06). -->

**Goal:** maintain a downstream of upstream Linux — track kernel.org's stable and longterm lines,
carry a small patch series rebased per release, and keep a Kconfig fragment per Syntek OS profile —
each build reproducible from a pinned tag and a committed fragment
(`project-management/src/08-DECISIONS/ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`).

**Topics:**

- Upstream, downstream and fork: what distributions carry, and why a downstream is neither a fork nor
  from scratch
- Config fragments: merging with the kernel's `scripts/kconfig/merge_config.sh` then
  `make olddefconfig`; checking what a fragment changed with `scripts/diffconfig`; the in-tree
  `hardening.config` as a baseline, then the KSPP recommended settings and kernel-hardening-checker
- The base fragment, then the server and homelab fragments (the first edition); the NAS, router and
  desktop fragments are one lesson each inside their profile topics
- The stable and longterm remotes, tags and one branch per line; longterm for the server family,
  stable for desktops (per profile, following the LTS-VS-STABLE-PER-PROFILE research note)
- A patch series: `git format-patch`, `git am`, carrying it onto a new release, conflicts and
  `git range-diff`; `scripts/checkpatch.pl`; naming and `LOCALVERSION`
- Reproducibility applied to the kernel: a pinned version, a recorded base config,
  `KBUILD_BUILD_TIMESTAMP`, `KBUILD_BUILD_USER`, `KBUILD_BUILD_HOST`
- The CI pipeline (new stable → apply series → build each profile → boot-test in QEMU) and CVE triage
  through the kernel CNA's `vulns.git` and `linux-cve-announce`, per profile

**Topic folders:** `kernel-04`, `kernel-05`, `kernel-06`; Later `kernel-07`.

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| First downstream build | a pinned stable or longterm tag, one trivial patch and two profile configs (base plus server) boot in QEMU |
| Per-profile fragments | base, server and homelab fragments, each justified line by line, hardening measured |
| A patch series across an update | a small series rebased onto the next release, conflicts and range-diff |
| Reproducible kernel builds | two clean builds from the same inputs, compared |
| Kernel CI and CVE triage | the pipeline automated; CVEs triaged per profile from `vulns.git` |

**Exit gate:** base config plus the first-edition fragments (server and homelab), then
`make olddefconfig`, then a build from a clean output directory succeeds; each resulting kernel boots
in QEMU; the fragments and the patch series are committed in the downstream kernel repository
(created in `kernel-05-downstream-tree` lesson 02; the lesson fragments start under
`code/src/kernel/`, planned — added at P4, and move there); and each has a `KERNEL-IMPL-MS###-...`
record here with the build and boot evidence, citing the downstream kernel repository's commit.

**Primary resources:**

- **Active kernel releases** — <https://www.kernel.org/category/releases.html> — mainline, stable and
  longterm, and which lines are maintained.
- **Linux -stable release rules** — <https://docs.kernel.org/process/stable-kernel-rules.html>
- **Configuration targets and editors (Kconfig)** — <https://docs.kernel.org/kbuild/kconfig.html>
- **Reproducible builds** — <https://docs.kernel.org/kbuild/reproducible-builds.html>
- **Submitting patches** — <https://docs.kernel.org/process/submitting-patches.html>
- **CVEs (kernel process)** — <https://docs.kernel.org/process/cve.html>
- **KSPP recommended settings** — <https://kspp.github.io/Recommended_Settings>
- **checkpatch** — <https://docs.kernel.org/dev-tools/checkpatch.html>

---

## P6 — Syntek OS

<!-- CHANGED 27/09/2026: phase name was "Distro tiers"; goal previously read "build three bootable
     distribution images — beginner, intermediate and experienced — on the P5 kernels, each meeting
     its tier spec"; the old exit gate referred to a TIER spec in 07-DISTRO-TIERS. Widened to an
     independent, from-scratch distribution with seven profiles on one base. See
     ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md,
     ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md and
     ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md. Opens after P2 (with P3 for the build
     system onward), earlier than the old scheme's P5. -->

**Goal:** build Syntek OS — an independent distribution, built from scratch (Linux From Scratch →
Beyond LFS → an automated build system of its own), with seven profiles on one base, build system and
package set; ship the server and homelab edition first — recommended, still to confirm
(`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md`;
`ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md` → Consequences).

**Topics:**

- The anatomy of a distribution: the boot chain, the FHS, the toolchain trio, ELF and the dynamic
  loader; what makes a distribution independent (study Arch, Alpine, Void, Gentoo)
- Storage and boot fundamentals: block devices, partitions, filesystems, disk images and loop
  devices, firmware boot (BIOS and UEFI), bootloaders, when an initramfs is required
- The LFS 13.1 systemd toolchain and base system, made bootable in QEMU
- The build system and reproducibility: from book steps to recipes, the dependency graph, isolation,
  `SOURCE_DATE_EPOCH` and diffoscope; CI and build farms
- Init and services: PID 1's duties, a survey of init systems, a minimal init in C, what each profile
  needs (Syntek OS's own init chosen later by ADR from the INIT-SYSTEM-CHOICE note)
- A package manager (study pacman, apk, xbps): a package format, dependency resolution, safe archive
  extraction, crash-safe updates, a Rust library plus a thin CLI; repositories, signing and updates
- Networking fundamentals and an isolated QEMU lab; profiles and the installer as a transaction; the
  server, homelab, NAS, router and desktop editions; the release and security process; a local-model
  integration capstone; and, Later, running Sam's own network from the lab-proven pieces under the
  graduation path
  <!-- CHANGED 27/09/2026: previously read "Networking fundamentals and an isolated QEMU lab; profiles
       and the installer as a transaction; the server, homelab, NAS, router and desktop editions; the
       release and security process; a local-model integration capstone" — networking and licensing
       round: os-18 added as Later (Q8, Q11, Q12) -->

**Topic folders:** `os-01`, `os-02`, `os-03`, `os-04`, `os-05`, `os-06`, `os-07`, `os-08`, `os-09`, `os-10`, `os-11`, `os-12`, `os-16`; Later `os-13`, `os-14`, `os-15`, `os-17`, `os-18`.

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| LFS toolchain in a VM | the cross toolchain and temporary tools built, the chroot entered |
| LFS base system, bootable | the base packages built and booted in QEMU |
| The build system and a package manager | recipes and a Rust package-manager library plus CLI |
| Repositories, signing and updates | a signed repository and a secure update flow |
| Profiles and the installer | one base, the profiles, disk images and ISOs, a transactional installer |
| Server and homelab editions (first edition) | SSH, firewall, updates, containers and VMs, tested in QEMU |

**Exit gate:** each profile image built for a milestone boots in QEMU and meets every acceptance item
in its profile spec in `project-management/src/07-OS-PROFILES/` — which, by then, has moved from
`Draft` to `Specified` — with evidence per profile in a verification record, which moves the profile
to `Verified`. The first edition (server and homelab) clears this before the Later profiles.

**Primary resources:**

- **Linux From Scratch 13.1 (systemd)** — <https://www.linuxfromscratch.org/lfs/view/stable-systemd/>
- **Beyond Linux From Scratch 13.1 (systemd)** —
  <https://www.linuxfromscratch.org/blfs/view/stable-systemd/>
- **Filesystem Hierarchy Standard** — <https://refspecs.linuxfoundation.org/fhs.shtml>
- **Reproducible Builds** — <https://reproducible-builds.org/>
- **pacman** — <https://wiki.archlinux.org/title/Pacman> · **XBPS** —
  <https://docs.voidlinux.org/xbps/index.html> — package managers to study, not to derive from
- **Buildroot** — <https://buildroot.org/downloads/manual/manual.html> and **Yocto** —
  <https://docs.yoctoproject.org/> — build systems studied as references, not adopted

---

## U1 — TUI foundations

**Goal:** build a full-screen terminal program from raw mode up, first in C and then in Rust with
ratatui, and learn to test a TUI without a terminal
(`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-TOOLS-RUST-TUI-FIRST-27-09-2026.md`).

**Topics:**

- Terminals, ttys and ptys; ANSI and VT escape sequences; termios raw mode in C and restoring it on
  exit and on signals; reading keys and SIGWINCH; the alternate screen
- ratatui and crossterm: terminal init and restore, a panic hook, the immediate-mode render loop,
  layout and widgets, events and app state, styling and accessibility (contrast, not colour alone)
- The Elm Architecture in Rust; background work without blocking the render loop (a worker thread and
  `std::sync::mpsc`, then tokio tasks); testing against the rendered `Buffer` with ratatui's
  `TestBackend`

**Topic folders:** `ui-01`, `ui-02`, `ui-03`.

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| Raw-mode terminal in C | a tiny full-screen program that restores the terminal on exit and on signals |
| ratatui foundations | the same, in ratatui, with a render loop and events |
| TUI architecture and testing | The Elm Architecture, background work, `Buffer` assertions |

**Exit gate:** a ratatui program with the render loop, event handling and app state, whose tests
assert on the rendered `Buffer` through `TestBackend` and pass under `cargo test`; and the C
raw-mode program restores the terminal on every exit path.

**Primary resources:**

- **Ratatui** — <https://ratatui.rs/>
- **ratatui crate documentation** — <https://docs.rs/ratatui/latest/ratatui/>
- **termios** — `man 3 termios` (local)

---

## U2 — Syntek OS tools

**Goal:** build the tools Syntek OS needs of its own — a file manager, a package-manager front-end,
an installer and system tools — each a Rust library with a thin TUI, the file manager first and the
natural first project for friends and family.

**Topics:**

- A file-manager TUI (study Yazi): async directory listing, huge directories, safe previews of
  untrusted files, file operations with trash and undo
- A package-manager TUI consuming the P6 package-manager library: search, list and info views,
  transactions with preview and confirmation, progress and cancellation
- An installer TUI as a state machine, with destructive-action safeguards (VM images only)
- System tools: privilege separation (unprivileged UI, privileged helper), D-Bus with zbus and
  polkit, network, users, updates and storage screens
- Later, a consent-first remote-help tool for Sam's family: a Linux terminal session the helped person
  starts, sees, controls and ends, on mutual TLS from the private CA, proved in the lab first
  <!-- CHANGED 27/09/2026: bullet added — networking and licensing round: ui-11 added as Later (Q10),
       under ADR-MS001-REMOTE-HELP-TOOL-CONSENT-FIRST-27-09-2026.md (Proposed) -->

**Topic folders:** `ui-04`, `ui-05`; Later `ui-06`, `ui-07`, `ui-11`.

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| File-manager TUI | async listing, safe previews, trash and undo — the first U2 build |
| Package-manager TUI | consuming the P6 library; transactions with confirmation |
| Installer and system tools | guided flows, privilege separation, the system screens |
| Remote-help tool (Later) | consent-first by construction: the session state machine, mTLS, a PTY session, the abuse-case suite |

**Exit gate:** the file-manager TUI lists a directory asynchronously, previews an untrusted file
safely and supports trash and undo, with tests passing under `cargo test`; each later U2 tool builds
against its OS-track prerequisite, except `ui-11`, which waits on `os-18` and does not hold U2's exit
gate.
<!-- CHANGED 27/09/2026: previously read "the file-manager TUI lists a directory asynchronously, previews
     an untrusted file safely and supports trash and undo, with tests passing under `cargo test`; each
     later U2 tool builds against its OS-track prerequisite." — networking and licensing round: ui-11
     added as Later (Q10), outside the exit gate -->

**Primary resources:**

- **Yazi** — <https://github.com/sxyazi/yazi> — the file manager to study
- **ratatui crate documentation** — <https://docs.rs/ratatui/latest/ratatui/>

---

## U3 — GUI tools and web admin

**Goal:** add GUI versions of the tools for the desktop profiles — gtk4-rs for the lessons here, and
the product GUIs in Slint in the Syntek OS GUI-tools repository — and the NAS and router web dashboard, which
plays to Sam's HTML, HTMX and PHP
(`project-management/src/08-DECISIONS/ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md`).

**Topics:**

- Wayland basics — a client's view (surfaces, xdg-shell; what the toolkit hides), citing the OS
  track's graphics-stack lesson; the GUI toolkit (gtk4-rs here; Slint in the product repositories);
  theming, HiDPI and accessibility (AT-SPI) as its own lesson
- A GUI settings or package tool over the same library the TUI uses; packaging desktop apps
- A web admin dashboard (HTML, HTMX, PHP) with its own security topic: admin authentication, CSRF,
  never running as root

**Topic folders:** Later `ui-08`, `ui-09`, `ui-10`.

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| GUI foundations | a first gtk4-rs app; accessibility through AT-SPI |
| GUI tools | a settings or package tool for the beginner profile |
| Web admin dashboard | the NAS/router dashboard, authenticated and CSRF-safe |

**Exit gate:** a gtk4-rs application in this repository completes its main task with Orca and the
keyboard only, through AT-SPI (`ui-08`); the beginner-profile Slint tool over the package-manager
library runs in a VM guest (`ui-09`, in the Syntek OS GUI-tools repository); and the web dashboard authenticates an
admin and resists CSRF, tested in a VM (`ui-10`).

**Primary resources:**

- **gtk-rs** — <https://gtk-rs.org/>
- **GTK 4 accessibility** — <https://docs.gtk.org/gtk4/section-accessibility.html>

---

## L1 — ML foundations and a local-model baseline

**Goal:** run an open coding model locally through skills and measure it, then train a tiny GPT on
the 2080 Ti within a measured VRAM budget — the baseline every later model is compared against
(`project-management/src/08-DECISIONS/ADR-MS001-LLM-SKILLS-NOT-AGENTS-27-09-2026.md`,
`ADR-MS001-LLM-EFFICIENCY-AND-SECURITY-FIRST-27-09-2026.md`).

**Topics:**

- Choosing an open coding model and a quantisation that fits about 9 GiB free VRAM; running it with
  ollama and measuring tokens/s, VRAM, RAM and load time; three Markdown skills with progressive
  disclosure and a gap log; models as untrusted inputs (pin the digest)
- A uv project and Python pin; installing PyTorch; tensors, dtypes, devices, timing GPU work honestly
- Neural-network foundations: matrices and broadcasting, autograd, gradient descent, an MLP, softmax
  and cross-entropy, optimisers, floating point for ML (why fp16 training needs loss scaling)
- Transformer maths and a tiny character-level GPT trained on CPU and GPU, with mixed precision on
  Turing (fp16 autocast and `GradScaler`) and the VRAM and throughput difference measured

**Topic folders:** `llm-01`, `llm-02`, `llm-03`, `llm-04`, `llm-05`.

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| Local model and skills baseline | an open model under ollama, three skills, a gap log, measurements — no C/Rust/CUDA |
| Python ML toolchain and NN foundations | a uv project, autograd, an MLP, cross-entropy |
| Tiny GPT | a char-level GPT trained on the 2080 Ti with a measured VRAM budget |

**Exit gate:** the local model runs through three skills with its tokens/s and VRAM recorded and a
gap log written; and a tiny GPT trains to a falling validation loss within a stated VRAM budget,
measured with `torch.cuda.max_memory_allocated`.

**Primary resources:**

- **ollama** — <https://github.com/ollama/ollama>
- **PyTorch** — the version and CUDA build recorded in `how-to/docs/TOOLCHAIN.md`
- **Anthropic Agent Skills** — <https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview>

---

## L2 — Hardware, memory and GPU programming

**Goal:** understand and measure how this machine moves bytes — the memory hierarchy on the CPU and
the SMs, warps and memory spaces on the GPU — so later efficiency claims rest on measurement.

**Topics:**

- Measuring honestly: warm-up, repeated runs, variance, `/usr/bin/time -v`, `perf stat` (or
  `valgrind --tool=cachegrind` when perf is locked down); recording budget against measured — the
  method the kernel-config and OS milestones cite
- The memory hierarchy with this machine's numbers; cache lines, locality and false sharing; SIMD on
  AVX2 and FMA; roofline and arithmetic intensity (why token-by-token decode is memory-bound)
- SMs, warps and the memory spaces; Turing specifics; the VRAM budget formula (weights, gradients,
  optimiser state, activations, KV cache); `torch.cuda` memory stats and `torch.profiler`
- GPU kernels in CUDA (blocked until the CUDA toolkit is installed): threads, blocks, coalescing, a
  tiled matmul, correctness and speed against cuBLAS

**Topic folders:** `llm-06`, `llm-07`, `llm-08`.

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| Measuring honestly | the measurement harness, budget against measured |
| CPU performance in C | the memory hierarchy, cache behaviour and SIMD measured on this machine |
| GPU architecture and VRAM budgets | the budget formula checked against `nvidia-smi` and `torch.profiler` |

**Exit gate:** a measured comparison of a cache-friendly against a cache-hostile version of a C
routine on this machine, and a VRAM budget for a model computed from its config, checked against the
measured peak (`torch.cuda.max_memory_allocated`) and set under the free memory
`torch.cuda.mem_get_info` reports.

**Primary resources:**

- **`perf`** — `man perf-stat` (local); the profiling-permission facts in `how-to/docs/TOOLCHAIN.md`
- **valgrind cachegrind** — <https://valgrind.org/docs/manual/cg-manual.html>

---

## L3 — An LLM in C (llm.c)

**Goal:** read and run Karpathy's llm.c GPT-2 on the CPU path under this repository's sanitiser and
valgrind flags, and understand its memory layout and its backward pass.

**Topics:**

- Reading llm.c's GPT-2 forward pass on the CPU; the backward pass and AdamW in C; its memory layout
  and allocation strategy
- Running the CPU path under the sanitiser and valgrind gates; the CUDA path on Turing runs fp32 only
  (`train_gpt2_fp32.cu` or `PRECISION=FP32` without cuDNN), with fp16 loss scaling as a stretch

**Topic folders:** `llm-09`.

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| llm.c on the CPU | the forward and backward pass read and run under the gates |

**Exit gate:** llm.c's CPU `test_gpt2`, pinned at f1e2ace and cloned outside this repository, builds
with this repository's sanitiser flags (`code/docs/BUILD.md` Section 2) and runs clean under ASan with
UBSan and, separately, under valgrind memcheck, with the memory layout explained back. (llm.c's own
Makefile has no `san` or `memcheck` target.)

**Primary resources:**

- **llm.c** — <https://github.com/karpathy/llm.c> (pin commit f1e2ace; the repo is dormant)
- **nanochat** — <https://github.com/karpathy/nanochat> — the maintained successor, as reading

---

## L4 — Training a small code model (~100M, local GPU)

**Goal:** train a ~100M fill-in-the-middle code model on the 2080 Ti within the VRAM budget, on data
you are allowed to use, and evaluate it in a sandbox.

**Topics:**

- Getting data you are allowed to use, sized to the budget: a Chinchilla-sized token target for
  ~100M parameters, gated-access terms, credentials kept out of the repository; The Stack v2 or v3
  (terms compared; for v2, SWHIDs, the SWH/INRIA agreement, `license_type` filtering, attribution;
  v3 is ODC-By and not gated); dedup, quality filtering, secret and PII scrubbing
- A code tokeniser (trained in Python with Hugging Face tokenizers; a hand-written BPE merge loop in
  Rust at inference), reused for the ~1B base so the ~100M model can serve as its draft
- Compute estimation (≈6·N·D FLOPs, N excluding embeddings), fitting in VRAM (micro-batch, gradient
  accumulation, activation checkpointing, fp16), the run, throughput tuning
- Evaluation in the sandbox: perplexity, infilling evaluation from arXiv:2207.14255, then pass@k;
  running generated code with no network, rlimits and timeouts

**Topic folders:** `llm-10`, `llm-11`, `llm-12`, `llm-13`.

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| Data pipeline and licensing | a licence-checked, deduplicated, scrubbed dataset sized to the budget |
| Tokeniser | a code BPE tokeniser, compression measured per language |
| Pretraining the ~100M model | the FIM run within the VRAM budget, resumable |
| Evaluation in a sandbox | infilling and pass@k, generated code run sandboxed |

**Exit gate:** a ~100M FIM model trained within a stated VRAM budget, resumable from a checkpoint
this machine produced (`weights_only=True`), and evaluated on an infilling suite with the run in the
sandbox — no network, rlimits, timeouts.

**Primary resources:**

- **The Stack v2** — arXiv:2402.19173, <https://arxiv.org/abs/2402.19173>
- **The Stack v3** — dataset card, <https://huggingface.co/datasets/HuggingFaceCode/stack-v3-train>
- **FIM** — arXiv:2207.14255, <https://arxiv.org/abs/2207.14255>
- **Chinchilla** — arXiv:2203.15556, <https://arxiv.org/abs/2203.15556>

---

## L5 — Efficient, secure inference in Rust and the skills layer

**Goal:** serve the model efficiently and securely from Rust, with a skill loader, and turn the L1
gap log into skill-use training data
(`project-management/src/08-DECISIONS/ADR-MS001-LLM-EFFICIENCY-AND-SECURITY-FIRST-27-09-2026.md`).

**Topics:**

- Reading the safetensors format by hand in Rust over memmap2 (8-byte little-endian header length,
  JSON header, raw tensors) and why pickle checkpoints are never loaded; a CPU forward pass; candle
  behind the licence ADR; calling llama.cpp through FFI (llama-cpp-2)
- Efficient inference: quantisation, mmap and the page cache, attention variants and KV-cache
  arithmetic (MHA → MQA → GQA), KV-cache paging, prompt caching, CPU/GPU offload, speculative decoding
- The skills layer: skills against agents for small models, the skill file format, discovery and
  loading in Rust, the context and KV budget; retrieval and doc guidance
- Secure LLM systems: prompt injection, sensitive-information disclosure, supply chain, excessive
  agency, unbounded consumption (OWASP Top 10 for LLM Applications 2025 IDs, each mapped to the
  re-ranked 2026 edition of 03/08/2026); a per-skill Landlock/seccomp policy over the
  sandbox launcher; safetensors-only weights

**Topic folders:** `llm-14`, `llm-15`, `llm-16`, `llm-17`, `llm-18`.

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| Inference in Rust | a hand-parsed safetensors reader and a CPU forward pass |
| Efficient inference | quantisation, KV-cache arithmetic and offload, each measured |
| The skills layer | a Rust skill loader replaying the L1 gap log within a context budget |
| Secure LLM systems | the threat model and a per-skill sandbox policy |

**Exit gate:** a Rust inference path loads a safetensors model, runs a skill through the loader within
a stated context and KV budget, and each skill script runs under its sandbox policy — with the threat
model recorded.

**Primary resources:**

- **safetensors** — <https://github.com/safetensors/safetensors>
- **OWASP Top 10 for LLM Applications 2025** — <https://genai.owasp.org/llm-top-10/> — the IDs this
  repository cites
- **OWASP Top 10 for LLM Applications 2026** —
  <https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/> — published 03/08/2026; it re-ranks
  the 2025 IDs, mapped in `learning/llm-18-secure-llm-systems/` lesson 01
- **GQA** — arXiv:2305.13245, <https://arxiv.org/abs/2305.13245>

---

## L6 — Efficient architectures, scale, adapters

**Goal:** explore efficient architectures within budget, rehearse multi-GPU training locally before
renting, and specialise the base with adapters — the coding adapter first
(`project-management/src/08-DECISIONS/ADR-MS001-LLM-BASE-MODEL-PLUS-ADAPTERS-27-09-2026.md`).

**Topics:**

- Efficient architectures: MQA and latent attention against the L5 GQA arithmetic; FlashAttention (on
  Turing, the memory-efficient SDPA backend, measured); Mixture of Experts; quantisation-aware
  training; choosing under a VRAM and compute budget
- Post-training and adapters: SFT data and chat templates, skill-use traces from the gap log, LoRA
  and QLoRA (QLoRA on Turing uses fp16 compute), multi-adapter serving and its throughput cost;
  domain variants (coding first; legal, HR, finance, business only with retrieval and professional
  caution)
- Scaling on bare metal: cost estimation, DDP and FSDP rehearsed locally on the gloo backend before
  renting, renting safely, checkpointing at scale, from run to release

**Topic folders:** Later `llm-19`, `llm-20`, `llm-21`.

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| Efficient architectures | an architecture chosen and measured under a VRAM and compute budget |
| Post-training and adapters | a coding LoRA adapter and its skill-following measured; multi-adapter cost |
| Scaling on bare metal | DDP and FSDP rehearsed locally, a budget written before any rental |

**Exit gate:** a coding adapter on the base model measurably improves the task suite over the base,
and a local DDP or FSDP rehearsal runs before any GPU is rented, with a cost budget written first.
This is the Later end of the LLM track (`ADR-MS001-LLM-BASE-MODEL-PLUS-ADAPTERS-27-09-2026.md` moves
to `Accepted` on the adapter measurement).

**Primary resources:**

- **LoRA** — arXiv:2106.09685, <https://arxiv.org/abs/2106.09685>
- **QLoRA** — arXiv:2305.14314, <https://arxiv.org/abs/2305.14314>
- **vLLM LoRA** — <https://docs.vllm.ai/en/latest/features/lora.html>

---

## S1 — Security foundations

**Goal:** learn security as a discipline — threat modelling, memory-corruption bugs and their
mitigations, the Linux security model and applied cryptography — turned on Sam's own code
(`project-management/src/08-DECISIONS/ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md`).

**Topics:**

- Principles, threat modelling and law: CIA, least privilege, defence in depth, attack surface;
  STRIDE and data-flow diagrams (the method every milestone's Security lens uses); the UK Computer
  Misuse Act 1990, written authorisation and scope; coordinated disclosure — sec-01 may start after P1
- Memory corruption and mitigations: stack overflow, format-string, use-after-free and
  integer-overflow bugs Sam writes; stack protector, NX, ASLR, PIE, RELRO, `_FORTIFY_SOURCE`,
  CET/shadow stacks toggled one by one; why Rust removes whole classes
- Fuzzing (coverage-guided, sanitisers, corpora, crash triage); the Linux security model (users,
  capabilities, namespaces, cgroups, seccomp, LSMs including Landlock — the sandbox launcher the OS
  and LLM tracks reuse); applied cryptography (hashes, MACs, signatures, key management, "don't roll
  your own"); Later, a private CA built by hand and then run by an ACME issuer
  <!-- CHANGED 27/09/2026: previously read "Fuzzing (coverage-guided, sanitisers, corpora, crash triage);
       the Linux security model (users, capabilities, namespaces, cgroups, seccomp, LSMs including
       Landlock — the sandbox launcher the OS and LLM tracks reuse); applied cryptography (hashes,
       MACs, signatures, key management, "don't roll your own")" — networking and licensing round:
       sec-05's private-CA lessons appended as Later (Q9) -->

**Topic folders:** `sec-01`, `sec-02`, `sec-04`, `sec-05` (lessons 01–07); Later `sec-03`, `sec-05` lessons 08–13.

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| Principles, threat modelling and law | STRIDE on a real component; the CMA and disclosure |
| Memory corruption and mitigations | a deliberately vulnerable C exercise shown corrupting memory under ASan with mitigations off, each mitigation toggled and read out of `readelf`, then fixed |
| The Linux security model | the sandbox launcher (namespaces, seccomp, Landlock) the other tracks reuse |
| Applied cryptography | signatures (Ed25519) and key management, using a vetted library |
| Private CA (Later) | a lab root and a constrained intermediate by hand, short-lived leaves and revocation; then the ADR-chosen ACME issuer |

**Exit gate:** a deliberately vulnerable C exercise (built as a clearly named, never-shipped target)
is shown corrupting memory under AddressSanitizer with mitigations off; it is built with and without
each mitigation, and each one's presence is read out of `readelf`; and the fixed version passes
`make test`, `make san` and `make memcheck` — with the threat model written, the CMA authorisation
understood, and the `sec-04` sandbox launcher denying a test program network and out-of-scope file
access. Exploiting the same target is S2's work (`sec-10-binary-exploitation`), in the lab.

**Primary resources:**

- **Computer Misuse Act 1990** — <https://www.legislation.gov.uk/ukpga/1990/18/contents>
- **MITRE ATT&CK** — <https://attack.mitre.org/>

---

## S2 — Authorised pentest lab

**Goal:** build an isolated virtual lab and learn reconnaissance, network security and web-application
security against lab targets only, under a written scope.

**Topics:**

- The lab: an isolated virtual network (QEMU `restrict=on` or a libvirt isolated network, no bridge to
  the home LAN), an attacker VM, intentionally vulnerable targets with permissive licences, snapshots
  and reset; the written scope; nothing offensive runs on the host
- Recon and network security (nmap, tcpdump, Wireshark — lab targets only); web-application security
  (the OWASP web Top 10 on OWASP Juice Shop, an intercepting proxy, fixing each class in code Sam
  writes); Linux privilege escalation and its defensive fixes — on lab VMs only
- Binary exploitation on Sam's own binaries and legal training platforms under their rules; reverse
  engineering of Sam's own binaries; methodology and reporting (NIST SP 800-115, PTES, OWASP WSTG,
  CVSS)

**Topic folders:** Later `sec-06`, `sec-07`, `sec-08`, `sec-09`, `sec-10`, `sec-11`, `sec-12`.

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| Pentest lab setup | an isolated network, an attacker VM, a target, a written scope, isolation proved |
| Recon and network security | nmap and packet capture against a lab target |
| Web-application security | the OWASP web Top 10 on Juice Shop, fixed in code |
| Methodology and reporting | a report with CVSS severities |

**Exit gate:** the lab network is shown to have no route to the home LAN (evidence in the milestone's
verification record), and a first recon-and-capture exercise runs against a lab target under a written
scope.

**Primary resources:**

- **QEMU networking** — <https://www.qemu.org/docs/master/system/invocation.html> (`restrict=on`)
- **OWASP Juice Shop** — <https://owasp.org/www-project-juice-shop/>
- **NIST SP 800-115** — <https://csrc.nist.gov/pubs/sp/800/115/final>

---

## S3 — Securing and testing Sam's own systems

**Goal:** harden and test the Syntek OS profiles and the model in the lab, build defensive
malware detection into Syntek OS, and run a disclosure process — all defensive, all in the lab.

**Topics:**

- Hardening and secure boot (CIS-style baselines, lynis audits of each profile image, UEFI Secure
  Boot, measured boot/TPM basics — VM images only); testing Syntek OS (pentest the profiles in the
  lab, fuzz the package manager and installer, supply-chain attacks on the Syntek OS package archive as test cases)
- Red-teaming the LLM (prompt injection through skills, docs and repositories; jailbreak and
  data-extraction testing against Sam's own model; an adversarial test suite run in CI-like fashion)
- Detection, response and disclosure (logging and auditd, intrusion detection, incident response per
  NIST SP 800-61, a vulnerability-disclosure policy via `security.txt`)
- Malware concepts and defence, antivirus and detection engineering, and runtime and kernel integrity
  — defensive only: no malware written or distributed; detection tested with the EICAR test file and
  synthetic files; live-sample analysis parked in `DEFERRED.md`

**Topic folders:** Later `sec-13`, `sec-14`, `sec-15`, `sec-16`, `sec-17`, `sec-18`, `sec-19`.

**Candidate milestones:**

| Candidate | Focus |
| --- | --- |
| Hardening and testing Syntek OS | a hardened profile image, pentested in the lab, findings fixed |
| Red-teaming the LLM | an adversarial suite against the model and skill loader |
| Detection, response and disclosure | auditd and IDS in the lab; a `security.txt` disclosure policy |
| Antivirus and detection engineering | a scanner service tested against EICAR and synthetic files |

**Exit gate:** a Syntek OS profile image is hardened, pentested in the lab and its findings fixed and
re-tested; and an adversarial suite runs against the model, with results recorded — no live malware,
no third-party targets.

**Primary resources:**

- **NIST SP 800-61 Rev. 3** — <https://csrc.nist.gov/pubs/sp/800/61/r3/final>
- **RFC 9116 (security.txt)** — <https://www.rfc-editor.org/rfc/rfc9116>
- **EICAR test file** — <https://www.eicar.org/download-anti-malware-testfile/>

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
- `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` — the profile hypotheses P5 and P6 test
- `project-management/src/08-DECISIONS/` — the twelve MS001 ADRs that widened this roadmap
- `project-management/docs/PLANNING-GUIDE.md` — cadence, milestone and sprint rules
- `code/docs/BUILD.md` — the make targets and flags the exit gates call
- `how-to/docs/TOOLCHAIN.md` — host tool versions
- `GAPS.md`, `DEFERRED.md` — blockers and parked topics
