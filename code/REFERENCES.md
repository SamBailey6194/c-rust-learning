# References — code layer

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Internal and external references for all coding work in this repository. Workflow `STEPS.md` files cite
the section names below; the root `REFERENCES.md` indexes this file alongside the other layers. Every
external link was checked on 27/09/2026 except where an entry says otherwise.

---

## Internal

### Layer CONTEXT files

- `code/CONTEXT.md` — this layer: the three sub-layers, the tree, and the key docs
- `code/docs/CONTEXT.md` — the guide catalogue, and which rule each guide owns
- `code/workflows/CONTEXT.md` — the workflow catalogue, by family
- `code/src/CONTEXT.md` — the source root: the tracks, and the phase each arrives in
- `code/src/c/CONTEXT.md` — the C track: the recursive Makefile, `mk/`, `include/`, the exercise list
- `code/src/c/ms001-hello/CONTEXT.md` — the reference C exercise: `greet()` into a caller's buffer
- `code/src/rust/CONTEXT.md` — the Cargo workspace, its lint policy and its configuration files
- `code/src/rust/crates/ms001_hello/CONTEXT.md` — the reference Rust crate, the twin of `ms001-hello`
- `code/src/scripts/CONTEXT.md` — every gate script, what it wraps, and its exit codes

### Workflow CONTEXT files

- `code/workflows/01-c-exercise/CONTEXT.md` — **Build** — one C exercise, from its spec to a clean
  analyser run
- `code/workflows/02-tdd-cycle/CONTEXT.md` — **Build** — red → green → refactor with `check.h` and
  `cargo test`
- `code/workflows/03-rust-exercise/CONTEXT.md` — **Build** — a new crate, or a Rust port of a finished C
  exercise
- `code/workflows/04-ffi-bridge/CONTEXT.md` — **Build, P3** — C and Rust across a thin `extern "C"`
  boundary, both suites green
- `code/workflows/05-review/CONTEXT.md` — **Verify** — reading finished code against `code/docs/`
- `code/workflows/06-memory-check/CONTEXT.md` — **Verify** — ASan + UBSan, valgrind memcheck and
  `-fanalyzer`, until all three are clean
- `code/workflows/07-debug/CONTEXT.md` — **Diagnose & improve** — reproduce, shrink, failing test first,
  minimal fix, BUG record
- `code/workflows/08-refactor/CONTEXT.md` — **Diagnose & improve** — behaviour-preserving steps, tests
  green throughout
- `code/workflows/09-kernel-module/` — **planned — added at P4** — an out-of-tree kernel module in C,
  built against the configured tree and loaded only inside QEMU
- `code/workflows/10-python-exercise/` — **planned — added at L1** — one Python exercise under
  `code/src/python/` (planned), tests first with pytest, ruff clean
- `code/workflows/11-profile-and-optimise/` — **planned — added at L2** — budget, honest measurement,
  one change, measure again
- `code/workflows/12-cuda-kernel/` — **planned — added at L2** — one CUDA kernel, correct against a
  reference first, then timed
- `code/workflows/13-tui-app/` — **planned — added at U1** — a terminal UI crate, restored on exit and
  panic, tested against the rendered buffer

### Guides in code/docs/

- `code/docs/CODING-PRINCIPLES.md` — Pike's five rules, Torvalds on data structures, good taste and short
  functions, Beck's four rules of simple design, and how they apply to C and Rust
- `code/docs/C-CODING-PRINCIPLES.md` — **owner of C style**: the Linux kernel coding style summarised,
  headers and linkage, error-handling conventions and the `goto` cleanup ladder, the C17 dialect
- `code/docs/RUST-CODING-PRINCIPLES.md` — **owner of the Rust lint policy and `unsafe` rules**: rustfmt,
  each workspace lint and why, errors as values, `SAFETY:` comments, crate layout
- `code/docs/BUILD.md` — **owner of build flags and make targets**: the gcc pipeline by hand, every flag
  in `mk/flags.mk`, the six targets, the exercise Makefile, the cargo commands and the scripts
- `code/docs/TESTING.md` — the `check.h` API, the three kinds of `cargo test`, the test discipline, and
  coverage with gcov as information only
- `code/docs/MEMORY-SAFETY.md` — undefined behaviour, the bug classes and what catches each, allocation
  ownership, the three memory tools, and why ASan and valgrind never mix
- `code/docs/DEBUGGING.md` — gdb essentials, core files under apport, reading ASan, UBSan, valgrind and
  analyser reports, rust-gdb and backtraces, and (P4) the kernel under QEMU with gdb
- `code/docs/FFI.md` — **P3, owner of the FFI crate layout** — the gate question, plain code first, the
  thin boundary, never panicking across it, ownership across it, the two test suites, and the crate
  layout with its `msNNN_` export prefix
- `code/docs/DOCUMENTATION-PAIRING.md` — **owner of the pairing rule**: the `CONTEXT.md` / `CLAUDE.md`
  split, banned headings, route-don't-restate, and the exemption classes
- `code/docs/DOCUMENTATION-LENGTH.md` — **owner of the length rule**: 300 cloc code lines, what is bound
  and exempt, and how a guide splits
- `code/docs/PYTHON-CODING-PRINCIPLES.md` — **planned — added at L1** — Python style and the ruff and
  pytest policy
- `code/docs/CUDA-CODING-PRINCIPLES.md` — **planned — added at L2** — CUDA C style and error checking

---

## External — Language & Standards

- **ISO C working draft N2310** — <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2310.pdf> — the
  first C2x working draft, which is the C17 text with change marks: the closest freely available text to
  C17, and the source of the clause numbers the guides cite (3.4.3, 6.9, 7.5)
- **WG14, the C committee** — <https://www.open-std.org/jtc1/sc22/wg14/> — the committee's documents,
  including the drafts that became C23 (revisited by a future ADR)
- **cppreference — C** — <https://en.cppreference.com/w/c> — the everyday reference for the language and
  its library, marked by standard version
- **cppreference — undefined behaviour** — <https://en.cppreference.com/w/c/language/behavior> —
  undefined, unspecified and implementation-defined behaviour, with examples
- **GCC 13.3 manual** — <https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/> — the version installed; `man gcc`
  is the same text, offline
- **GCC — Warning Options** — <https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html> — every `-W`
  flag in `code/src/c/mk/flags.mk`
- **GCC — C Dialect Options** — <https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html> —
  `-std=c17` against the default `gnu17`
- **GCC — Debugging Options** — <https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html> — `-g3` and
  the debug levels
- **GCC — Preprocessor Options** — <https://gcc.gnu.org/onlinedocs/gcc/Preprocessor-Options.html> —
  `-MMD` and `-MP`, the dependency files
- **GNU make manual** — <https://www.gnu.org/software/make/manual/make.html> — rules, variables,
  automatic variables and static pattern rules as used in `mk/exercise.mk`; `man make` summarises the
  options offline. Not reachable from the checking environment on 27/09/2026, so this link is unchecked
- **errno(3)** — <https://man7.org/linux/man-pages/man3/errno.3.html> — when `errno` is meaningful, and
  the error names
- **The Rust Programming Language** — <https://doc.rust-lang.org/book/> — the Book: ownership, error
  handling, testing
- **The Rust Book — Error Handling** — <https://doc.rust-lang.org/book/ch09-00-error-handling.html> —
  `Result`, `?` and when to panic
- **The Rust Reference** — <https://doc.rust-lang.org/reference/> — ABIs, unwinding, `unsafe extern`,
  `#[unsafe(no_mangle)]`
- **The Rust Reference — behaviour considered undefined** —
  <https://doc.rust-lang.org/reference/behavior-considered-undefined.html> — what `unsafe` code promises
  never to do
- **The Rustonomicon** — <https://doc.rust-lang.org/nomicon/> — writing `unsafe` Rust correctly
- **The Rustonomicon — FFI** — <https://doc.rust-lang.org/nomicon/ffi.html> — calling C, and being called
  from it
- **Rust standard library** — <https://doc.rust-lang.org/std/> — the API reference
- **`std::ffi`** — <https://doc.rust-lang.org/std/ffi/index.html> — `CStr`, `CString`, `c_int`,
  `c_char`
- **Rust 2024 edition guide** — <https://doc.rust-lang.org/edition-guide/rust-2024/index.html> — the
  edition this workspace uses; see its pages on
  [unsafe extern blocks](https://doc.rust-lang.org/edition-guide/rust-2024/unsafe-extern.html) and
  [unsafe attributes](https://doc.rust-lang.org/edition-guide/rust-2024/unsafe-attributes.html)
- **The Cargo Book** — <https://doc.rust-lang.org/cargo/> — workspaces, manifests, profiles
- **Cargo — workspaces** — <https://doc.rust-lang.org/cargo/reference/workspaces.html> — members,
  inherited package fields, `[workspace.dependencies]`
- **Cargo — the `[lints]` section** —
  <https://doc.rust-lang.org/cargo/reference/manifest.html#the-lints-section> — lint levels and
  `priority`
- **Cargo — build scripts** — <https://doc.rust-lang.org/cargo/reference/build-scripts.html> — `build.rs`
  and `cargo::rerun-if-changed`, for the FFI crates
- **The `cc` crate** — <https://docs.rs/cc/latest/cc/> — compiles an FFI crate's C half from `build.rs`
  (P3)

---

## External — Testing & Debugging

- **GDB manual** — <https://sourceware.org/gdb/current/onlinedocs/gdb.html/> — breakpoints,
  watchpoints, examining memory, core files
- **GDB — generating a core file** —
  <https://sourceware.org/gdb/current/onlinedocs/gdb.html/Core-File-Generation.html> — `gcore`, a core
  from a live process
- **core(5)** — <https://man7.org/linux/man-pages/man5/core.5.html> — `ulimit -c`, `core_pattern`, and
  where the kernel sends a core
- **Valgrind user manual** — <https://valgrind.org/docs/manual/manual.html> — the tool suite
- **Valgrind — Memcheck** — <https://valgrind.org/docs/manual/mc-manual.html> — every error message, and
  the four leak kinds
- **GCC — Instrumentation Options** — <https://gcc.gnu.org/onlinedocs/gcc/Instrumentation-Options.html> —
  `-fsanitize=`, `-fno-sanitize-recover` and `--coverage`
- **AddressSanitizer** — <https://github.com/google/sanitizers/wiki/AddressSanitizer> — what ASan finds,
  its cost, and its run-time flags
- **UndefinedBehaviorSanitizer** — <https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html> — each
  check in detail; the gcc manual links here for UBSan
- **GCC — Static Analyzer Options** — <https://gcc.gnu.org/onlinedocs/gcc/Static-Analyzer-Options.html>
  — `-fanalyzer` and every `-Wanalyzer-*` warning
- **gcov** — <https://gcc.gnu.org/onlinedocs/gcc/Gcov.html> — reading coverage output
- **The Rust Book — test organisation** —
  <https://doc.rust-lang.org/book/ch11-03-test-organization.html> — unit against integration tests
- **cargo test** — <https://doc.rust-lang.org/cargo/commands/cargo-test.html> — filters, `--no-run`, and
  passing options to the test harness
- **`std::backtrace`** — <https://doc.rust-lang.org/std/backtrace/index.html> — `RUST_BACKTRACE` and
  what it controls
- **git-bisect(1)** — <https://git-scm.com/docs/git-bisect> — binary search through history for the
  commit that broke something; `git bisect run` and its exit-code contract (0 good, 125 skip, 1–127 bad),
  used by `code/workflows/07-debug/` Step 2

---

## External — Code Quality

- **Linux kernel coding style** — <https://docs.kernel.org/process/coding-style.html> — the C style this
  repository adopts; `code/docs/C-CODING-PRINCIPLES.md` summarises and cites it by section
- **Linux kernel licence rules** — <https://docs.kernel.org/process/license-rules.html> — the SPDX
  identifier line at the top of every C file
- **Rob Pike — Notes on Programming in C** — <https://doc.cat-v.org/bell_labs/pikestyle> — the five rules
- **Linus Torvalds on data structures** — <https://lwn.net/Articles/193245/> — "good programmers worry
  about data structures and their relationships"
- **Linus Torvalds — The mind behind Linux** —
  <https://www.ted.com/talks/linus_torvalds_the_mind_behind_linux> — the good-taste linked-list example
- **Kent Beck's design rules** — <https://martinfowler.com/bliki/BeckDesignRules.html> — the four rules
  of simple design, as summarised by Martin Fowler
- **SEI CERT C Coding Standard** — <https://wiki.sei.cmu.edu/confluence/display/c/SEI+CERT+C+Coding+Standard>
  — secure-coding rules for C, useful further reading from P2
- **Clippy lint list** — <https://rust-lang.github.io/rust-clippy/stable/index.html> — every lint, its
  group and its configuration
- **The Clippy book** — <https://doc.rust-lang.org/clippy/> — lint groups, and configuring lints in
  `Cargo.toml` and `clippy.toml`
- **rustfmt** — <https://rust-lang.github.io/rustfmt/> — the formatter's options, and their defaults
- **cargo-deny** — <https://embarkstudios.github.io/cargo-deny/> — the licence, advisory and source gate
  behind `code/src/scripts/rust/audit.sh`
- **RustSec advisory database** — <https://rustsec.org/> — what the advisory check compares against
- **FSF licence list — Apache 2.0** — <https://www.gnu.org/licenses/license-list.html#apache2> — why
  `code/src/rust/deny.toml` does not allow Apache-2.0 on its own in a GPL-2.0-only repository (read
  through a web archive on 27/09/2026; gnu.org was unreachable from the checking environment)
- **FSF licence list — Boost Software License** — <https://www.gnu.org/licenses/license-list.html#boost>
  — lax, permissive and compatible with the GNU GPL, which is why `BSL-1.0` is on the `deny.toml` allow
  list (read through the Internet Archive's copy on 27/09/2026, for the same reason)
- **cargo-fuzz setup** — <https://rust-fuzz.github.io/book/cargo-fuzz/setup.html> — cargo-fuzz needs
  the nightly compiler, which the pinned workspace does not use (`GAPS.md`)
- **cloc** — <https://github.com/AlDanial/cloc> — counts the code lines the length rule measures
- **markdownlint-cli2** — <https://github.com/DavidAnson/markdownlint-cli2> — the Markdown gate
- **ShellCheck** — <https://www.shellcheck.net/> — the shell-script gate in `Syntax — Shell`

---

## External — Python, CUDA and UI crates (L1, L2, U1)

- **uv** — <https://docs.astral.sh/uv/> — per-project Python environments, for the projects under
  `code/src/python/` (planned — added at L1)
- **Ruff** — <https://docs.astral.sh/ruff/> — the Python linter and formatter
- **pytest** — <https://docs.pytest.org/> — Python tests
- **PyTorch 2.14** — <https://docs.pytorch.org/docs/2.14/> — tensors, autograd, `torch.cuda`, and the
  [serialization notes](https://docs.pytorch.org/docs/2.14/notes/serialization.html) behind the
  weights-loading rule in `.claude/CLAUDE.md`
- **CUDA programming guide** — <https://docs.nvidia.com/cuda/cuda-programming-guide/> — the CUDA C
  model `code/src/cuda/` (planned — added at L2) will follow
- **ratatui** — <https://ratatui.rs/> and <https://docs.rs/ratatui/latest/ratatui/> — the TUI crate
  (U1); its `ryu` dependency is why `BSL-1.0` is allowed
- **crossterm** — <https://docs.rs/crossterm/latest/crossterm/> — the terminal backend ratatui drives
- **gtk4-rs book** — <https://gtk-rs.org/gtk4-rs/stable/latest/book/> — the GUI toolkit the lessons use
  (U3)
- **tokio tutorial** — <https://tokio.rs/tokio/tutorial> — async Rust (P3), and background work in a
  TUI

---

## External — Kernel (P4)

- **The Linux kernel documentation** — <https://docs.kernel.org/> — the root of everything below
- **Building external modules** — <https://docs.kernel.org/kbuild/modules.html> — out-of-tree modules
  and `make -C <kernel> M=$PWD`
- **checkpatch** — <https://docs.kernel.org/dev-tools/checkpatch.html> — the style checker, its options
  and every message type
- **Submitting patches** — <https://docs.kernel.org/process/submitting-patches.html> — patch series
  format, for the P5 patch sets
- **Debugging kernel and modules via gdb** —
  <https://docs.kernel.org/process/debugging/gdb-kernel-debugging.html> — the kernel config, `nokaslr`
  and the `lx-` helper commands
- **Rust in the kernel** — <https://docs.kernel.org/rust/index.html> — the in-tree documentation for
  Rust-for-Linux (needs clang/LLVM, not yet installed)
- **Rust for Linux** — <https://rust-for-linux.com/> — the project's own site
- **QEMU system emulation** — <https://www.qemu.org/docs/master/system/index.html> — booting a kernel
  and an initramfs
- **QEMU — GDB usage** — <https://www.qemu.org/docs/master/system/gdb.html> — `-s`, `-S` and the gdb
  stub
