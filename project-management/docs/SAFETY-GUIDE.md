---
type: guide
---

# Safety Guide — c-rust-learning

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Three kinds of hazard run through this curriculum. C's undefined behaviour and memory bugs corrupt a
program quietly. Rust's `unsafe` hands the same bugs back to you behind a keyword. Kernel code can take
the whole machine down with it. This guide says what a milestone has to **plan** for each of them, at
the PM stage, so the right gates are flagged before any code exists. The rules themselves are owned
elsewhere, and each section routes there.

---

## C — undefined behaviour and memory bugs

Undefined behaviour means the C standard places no requirement on what happens: the program may crash,
may appear to work, or may work until the optimisation level changes. The classes below are the ones
this curriculum meets most, and no single tool catches all of them, which is why the Memory flag runs
two.

| Bug class | Typical shape | Caught by |
| --- | --- | --- |
| Heap buffer overflow | writing `buf[len]` in a `malloc(len)` block | AddressSanitizer; valgrind memcheck; `-fanalyzer` on some paths |
| Stack or global buffer overflow | `char name[8];` then an unchecked `strcpy` | AddressSanitizer (valgrind does **not** see these) |
| Use after free | reading a list node after `free(node)` | AddressSanitizer; valgrind; `-fanalyzer` |
| Double free | two error paths that both `free(p)` | AddressSanitizer; valgrind; `-fanalyzer` |
| Memory leak | an early `return` that skips the `free` | LeakSanitizer (part of ASan); valgrind; `-fanalyzer` |
| Uninitialised read | branching on a local that was never assigned | valgrind (`--track-origins=yes` shows where it came from); `-fanalyzer`; **not** ASan |
| Signed integer overflow | `INT_MAX + 1`, often inside a size calculation | UndefinedBehaviorSanitizer |
| Invalid shift | `1 << 32` on a 32-bit `int` | UndefinedBehaviorSanitizer; gcc warns at compile time when the count is a constant |
| NULL dereference | using `malloc`'s result without checking it | `-fanalyzer`; UndefinedBehaviorSanitizer; a crash otherwise |
| Format mismatch | `printf("%d", some_long)` | `-Wformat=2` at compile time |
| Data race | two threads updating a counter without a lock | ThreadSanitizer (`-fsanitize=thread`, cannot be combined with ASan); valgrind's Helgrind or DRD |

**What a C milestone plans for:**

- **The Memory flag is set whenever the milestone allocates**, and then both `make san` and
  `make memcheck` run: each tool is blind where the other sees.
- **The Lint flag is set whenever the milestone has non-trivial control flow**: `make lint` runs GCC's
  `-fanalyzer`, which follows paths across functions. It is a bug-finder, neither sound nor complete, so
  a clean run is evidence, not proof.
- **The exercise spec names the classes it risks.** A linked-list exercise risks use-after-free; a
  string exercise risks overflow and a missing terminator. Naming them in
  `project-management/src/04-EXERCISES/` turns each into a test the learner writes on purpose.
- **Threads get their own plan.** ThreadSanitizer is not part of `make san`; a P2 threads milestone
  flags it in its plan and records how it ran.

The full treatment, with examples and what each tool's report means, is owned by
`code/docs/MEMORY-SAFETY.md`; the warning and sanitiser flags by `code/docs/BUILD.md`.

---

## Rust — the `unsafe` policy

The workspace denies `unsafe` code outright (`unsafe_code = "deny"` in `code/src/rust/Cargo.toml`), so
safe Rust is the default and every exception is visible. Because it is `deny` and not `forbid`, a
single item can opt out with `#[allow(unsafe_code)]`, which is exactly the point: the opt-out is
deliberate, local and reviewable.

**What a Rust milestone plans for:**

- **`unsafe` arrives only in milestones that are about it** (P3's `unsafe` and FFI milestones, and the
  FFI crate). Any other milestone that finds itself needing `unsafe` has found a design question, not a
  shortcut: record it and ask.
- **Every `unsafe` block carries a `// SAFETY:` comment** on the line before it, stating the invariant
  that makes it sound. Review enforces it: clippy's restriction lint `undocumented_unsafe_blocks`
  would check for exactly this, but it is not enabled in the workspace
  (`code/docs/RUST-CODING-PRINCIPLES.md` Section 4).
- **Edition 2024 tightens the edges**, and the pinned 1.92.0 toolchain enforces it: `extern` blocks
  have to be written `unsafe extern "C" { ... }`, attributes such as `no_mangle` have to be written
  `#[unsafe(no_mangle)]`, and an unsafe operation inside an `unsafe fn` needs its own `unsafe { }`
  block (the `unsafe_op_in_unsafe_fn` lint).
- **An FFI milestone sets the Memory flag.** The C half of an FFI pair still runs under the
  sanitisers and valgrind, because Rust's guarantees stop at the boundary.
- **Relaxing the workspace lint is an ADR**, raised through `08-decisions`, never a line edit.

The rules and their reasons are owned by `code/docs/RUST-CODING-PRINCIPLES.md`, and the C and Rust
boundary by `code/docs/FFI.md`.

---

## Kernel — QEMU only

**Custom kernels and kernel modules run in QEMU only. They are never installed on the host, never
booted on it, and never `insmod`-ed into it.** Kernel source trees, build output and disk images are
never committed. The rule is non-negotiable and is owned by `.claude/CLAUDE.md`; this section explains
why it exists and what it costs a milestone to follow it.

**Why:**

- **A module is not a program.** It runs in ring 0 with the kernel's own privileges and no process
  boundary around it. A stray pointer in a module does not segfault; it corrupts the running kernel,
  and whatever it corrupts (a filesystem's cache, a device driver's state) can outlive the reboot.
- **A wedged module cannot always be removed.** A module stuck in use or crashed mid-init can leave the
  host needing a hard reset, with any unsaved work lost.
- **A kernel you built may not boot your hardware.** A config missing the right storage or filesystem
  driver leaves the host unbootable, and recovery needs a rescue medium.
- **The host is also the study machine.** Everything else in this repository runs on it; putting it at
  risk to learn a lesson QEMU teaches equally well is a bad trade.

**What QEMU gives instead:** a machine you can crash and restart in seconds; `-snapshot`, which writes
disk changes to temporary files so the image is never modified; `-nographic` with `console=ttyS0`, so
the whole boot log arrives as text you can paste into a record; and `-s -S`, which opens a gdb stub on
port 1234 and holds the CPU until gdb tells it to continue, so a kernel can be debugged from its
first instruction (https://docs.kernel.org/process/debugging/gdb-kernel-debugging.html).

**What a kernel milestone plans for** (in its `project-management/src/06-KERNEL/` plan):

- the exact `qemu-system-x86_64` command line, including the kernel image, the initramfs and the
  kernel command line
- where the kernel source and build output live: outside the repository, so they cannot be committed
- modules built against that kernel's build tree (`make -C <kernel-build-dir> M=$PWD`), never against
  the host's `/lib/modules/$(uname -r)/build`
- the missing build dependencies as blockers: flex, bison, libelf-dev and dwarves (for pahole) are not
  yet installed, and Rust-for-Linux also needs clang/LLVM and bindgen, so those milestones stay
  `Blocked` with a `GAPS.md` entry until they are

---

## Public-repository hygiene

This repository is public, so safety includes what it publishes. No secrets, no absolute paths from
your machine, no pasted copyrighted text (cite and link instead), no email addresses. The
`Audit — Secrets` check scans every push (`project-management/docs/git/PR-AND-CHECKS.md`), but it is
the last line, not the first: read `git diff --staged` before every commit
(`project-management/docs/git/COMMITS.md`). The hygiene rules are owned by `.claude/CLAUDE.md`.

---

## Related

- `code/docs/MEMORY-SAFETY.md` — memory-bug classes and tool reports in depth
- `code/docs/RUST-CODING-PRINCIPLES.md` — the `unsafe` rules and their reasons
- `code/docs/FFI.md` — the C and Rust boundary
- `.claude/CLAUDE.md` — the kernel QEMU-only rule and the public-repository rules
- `project-management/docs/VERIFICATION-GUIDE.md` — how the flagged gates are proved afterwards
- `project-management/workflows/06-kernel-spec/` — where a kernel milestone's safety plan is written
