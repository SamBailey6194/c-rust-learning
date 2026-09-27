---
type: guide
---

# CLI Tooling — c-rust-learning

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

> **The command is the lesson.** Every section shows the raw `make`, `gcc`, `valgrind`, `gdb` or `cargo`
> command first, then names the `code/src/scripts/` script that wraps it. Learn the raw form; CI and
> Claude's own verification run the scripts. Which commands count as gates is owned by
> `how-to/workflows/03-quality-gates/`; the flags behind the C targets by `code/docs/BUILD.md`.

Run everything from the repository root unless a block says otherwise. Every command outside the P4
preview has been run on the machine recorded in `how-to/docs/TOOLCHAIN.md`.

---

## Overview

| Target | Where | Built with | Toolchain |
| --- | --- | --- | --- |
| C exercises | `code/src/c/ms###-*/` | GNU make, shared rules in `code/src/c/mk/` | gcc 13, `-std=c17` |
| Rust crates | `code/src/rust/crates/` | one cargo workspace | rustc 1.92.0, pinned |
| Docs | every `*.md` | — | cloc, markdownlint-cli2 |
| Kernel (P4 preview) | a kernel tree outside this repository | kbuild | gcc, QEMU |

---

## C build

```bash
# Build every exercise (the default target is `all`)
make -C code/src/c

# Build one exercise
make -C code/src/c/ms001-hello

# Run the program by hand once it is built
./code/src/c/ms001-hello/build/hello Sam

# Build and run the tests (`check: <n> passed, 0 failed`)
make -C code/src/c test

# Start one exercise from clean
make -C code/src/c/ms001-hello clean all

# Print every command make would run, without running any
make -C code/src/c/ms001-hello -B -n

# See what a flag does: fewer warnings, or the optimiser switched on
make -C code/src/c/ms001-hello clean all WARN=-Wall
make -C code/src/c/ms001-hello clean all DBG="-g3 -O2"

# The compiler line make uses, checking one file for warnings only
gcc -std=c17 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wstrict-prototypes -Wformat=2 -Werror \
    -g3 -O0 -I code/src/c/include -fsyntax-only code/src/c/ms001-hello/greet.c
```

| Script (under `code/src/scripts/`) | Wraps |
| --- | --- |
| `c/build.sh [--path <exercise>]` | `make -C code/src/c all` (or one exercise) |
| `c/test.sh` | `make -C code/src/c test` |

---

## Memory and sanitisers

```bash
# AddressSanitizer + UBSan build in build/san/, then run the tests there
make -C code/src/c san

# valgrind Memcheck on the plain test binaries (never on build/san/)
make -C code/src/c memcheck

# The same valgrind run by hand, with the flags make uses
valgrind --leak-check=full --show-leak-kinds=all --errors-for-leak-kinds=all --error-exitcode=1 \
    ./code/src/c/ms001-hello/build/test_greet

# Chasing an uninitialised value: where did it come from?
valgrind --track-origins=yes ./code/src/c/ms001-hello/build/test_greet

# gcc's static analyser (-fanalyzer) into build/lint/
make -C code/src/c lint

# One ASan run with leak detection off (needed inside gdb)
ASAN_OPTIONS=detect_leaks=0 ./code/src/c/ms001-hello/build/san/test_greet
```

A clean valgrind run ends with `All heap blocks were freed -- no leaks are possible` and
`ERROR SUMMARY: 0 errors from 0 contexts`. A leak looks like this (a 16-byte `malloc` never freed):

```text
==184716== 16 bytes in 1 blocks are definitely lost in loss record 1 of 1
==184716==    at 0x4846828: malloc (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==184716==    by 0x10915E: main (leak.c:6)
```

The `san` build adds `-fno-sanitize-recover=all`, so a UBSan `runtime error:` fails the run just as an ASan
report does. Reading those reports is `code/docs/MEMORY-SAFETY.md`.

| Script | Wraps |
| --- | --- |
| `c/san.sh` | `make -C code/src/c san` |
| `c/memcheck.sh` | `make -C code/src/c memcheck` |
| `c/lint.sh` | `make -C code/src/c lint` |

---

## Debugging

```bash
# Start a C program under gdb, with its arguments
gdb --args ./code/src/c/ms001-hello/build/hello Sam

# One-shot, non-interactive: stop in greet(), show the call stack and the arguments
gdb -q -batch -ex 'break greet' -ex run -ex bt -ex 'info args' --args ./code/src/c/ms001-hello/build/hello Sam

# Rust: rust-gdb adds pretty-printers for String, Vec and friends
rust-gdb --args code/src/rust/target/debug/ms001_hello Sam

# Rust: a full backtrace on panic
(cd code/src/rust && RUST_BACKTRACE=1 cargo run -p ms001_hello -- Sam)

# Core dumps: enable for this shell, crash, then open the core apport saved
ulimit -c unlimited
ls -t /var/lib/apport/coredump/ | head -1
```

| Inside gdb | Does |
| --- | --- |
| `break greet` / `b greet.c:12` | Stop at a function or a line |
| `run` / `r` | Start the program (with the `--args` given) |
| `next` / `n`, `step` / `s` | Next line, stepping over or into calls |
| `finish` | Run to the end of this function and print its return value |
| `print buf` / `p len`, `info args`, `info locals` | Inspect values |
| `bt` | Call stack |
| `watch n` | Stop whenever `n` changes |
| `continue` / `c`, `quit` / `q` | Carry on, or leave |

gdb 15 asks `Enable debuginfod for this session? (y or [n])` on first run; `n` is fine for local work.
Attaching to a running process (`gdb -p`) is blocked by Ubuntu's `ptrace_scope`; see
`how-to/workflows/05-debugging-environment/`. Technique, rather than commands, is `code/docs/DEBUGGING.md`.

---

## Rust

Run cargo from inside the workspace so the pinned toolchain applies:

```bash
cd code/src/rust

# Build, test, and run the crate's binary
cargo build
cargo test
cargo run -p ms001_hello -- Sam

# Only the tests whose names contain "greet", in one crate
cargo test -p ms001_hello greet

# Formatting: check (the gate), then apply
cargo fmt --check
cargo fmt

# Lints, every warning (pedantic included) an error
cargo clippy --all-targets -- -D warnings

# Dependency licences, advisories, bans and sources (needs network for advisories)
cargo deny check

cd ../../..
```

`cargo --manifest-path code/src/rust/Cargo.toml test` also works from the root, but rustup chooses the
toolchain from the directory cargo starts in, so it runs your host default rather than the 1.92.0 pin.

| Script | Wraps |
| --- | --- |
| `rust/build.sh` | `cargo build --all-targets` (with `--workspace`) |
| `rust/test.sh` | `cargo test` |
| `rust/lint.sh` | `cargo fmt --check` and `cargo clippy --all-targets -- -D warnings` |
| `rust/audit.sh` | `cargo deny check` (exit 2 if cargo-deny is not installed) |

---

## Docs audits

```bash
# Code lines of one Markdown file: the fifth CSV field of the Markdown row
cloc --include-lang=Markdown --quiet --csv how-to/docs/CLI-TOOLING.md

# Every instructional Markdown file within 300 cloc code lines
bash code/src/scripts/audits/docs-length.sh

# Every directory has CONTEXT.md + CLAUDE.md, in the house shape
bash code/src/scripts/audits/docs-pairing.sh

# Markdown lint, as CI runs it (the root config supplies the globs)
npx --yes markdownlint-cli2
```

---

## Toolchain and gates

```bash
# Print the | Tool | Version | table; exit 2 if a required tool is missing
bash code/src/scripts/toolchain/check.sh

# Every gate in order, then one summary table; exits with the worst code
bash code/src/scripts/gates/all.sh

# Any script prints its own header with --help
bash code/src/scripts/c/build.sh --help
```

Exit codes everywhere: 0 = pass, 1 = failures, 2 = could not run.

---

## Kernel and QEMU — P4 preview

Not yet runnable here: the kernel-build packages (flex, bison, libelf-dev, dwarves) are not installed
(`how-to/docs/TOOLCHAIN.md` → P4 prerequisites), and the kernel tree will live **outside** this repository.
These commands follow docs.kernel.org and `qemu-system-x86_64 -help`; the planned workflows
`07-kernel-source-setup` and `08-build-and-boot-kernel` (added at P4) will turn them into tested steps.
Custom kernels and modules run in QEMU only, never on the host (`.claude/CLAUDE.md`).

```bash
# Inside the kernel source tree: configure into a separate build directory (O= on every call)
make O=../kbuild defconfig
make O=../kbuild kvm_guest.config
make O=../kbuild -j"$(nproc)" bzImage

# An out-of-tree module, built against that build directory
make -C ../kbuild M="$PWD" modules

# Pack a busybox initramfs from a directory holding bin/busybox and an executable init script
(cd initramfs && find . -print0 | cpio --null -o --format=newc) | gzip -9 > initramfs.cpio.gz

# Boot on the serial console; leave QEMU with Ctrl-A then X
qemu-system-x86_64 -kernel ../kbuild/arch/x86/boot/bzImage -initrd initramfs.cpio.gz \
    -append "console=ttyS0 nokaslr" -nographic -m 512M -enable-kvm

# Add -s -S to freeze at start with a gdb stub on tcp::1234, then attach from another terminal
gdb ../kbuild/vmlinux -ex 'target remote :1234'
```

---

## Troubleshooting

### `make: *** No targets specified and no makefile found. Stop.`

You ran `make` outside an exercise folder. Use `make -C code/src/c/<exercise> <target>`, or
`make -C code/src/c <target>` for every exercise.

### `cargo fmt --check` prints `Diff in …` and exits 1

The code is not formatted. Run `cargo fmt` inside `code/src/rust/`, read the diff it applied, and commit it.

### valgrind prints `ASan runtime does not come first in initial library list`

valgrind was pointed at a `build/san/` binary. Use `make -C code/src/c memcheck`, which runs the plain build.

### gdb prints `LeakSanitizer does not work under ptrace (strace, gdb, etc)`

Leak detection cannot run under a debugger. Start gdb with `ASAN_OPTIONS=detect_leaks=0` set, and check
leaks with `make … san` outside gdb.

### A cargo command uses the wrong Rust version

You started cargo outside `code/src/rust/`. Run `rustup show active-toolchain` there; the full diagnosis is
`how-to/workflows/05-debugging-environment/`.

_Part of the `how-to/docs/` documentation family._
