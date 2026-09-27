---
type: guide
---

# Debugging

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Finding out _why_: gdb on a running or crashed program, core files, the reports that the sanitisers,
valgrind and the analyser print, the Rust equivalents, and — from P4 — a kernel under QEMU. The method
around the tools (reproduce, shrink to the smallest failing case, pin it with a failing test, make the
smallest fix) is a procedure, `code/workflows/07-debug/`; setting up the debugging environment is
`how-to/workflows/05-debugging-environment/`.

---

## 1. Build for the debugger

The ordinary build already is one: `code/docs/BUILD.md` sets `-g3 -O0`, so every source line maps to the
code that runs, every local variable can be printed, and macros can be expanded. An optimised build shows
`<optimized out>` where variables used to be, and steps through lines out of order — debug the `-O0`
build first.

---

## 2. gdb essentials

```bash
cd code/src/c/ms001-hello && make
gdb -q --args ./build/hello Sam          # --args passes everything after the program to it
```

| Command | Short | What it does |
| --- | --- | --- |
| `break greet` / `break greet.c:20` | `b` | Stop at a function, or at a line |
| `start` | | Stop at the first line of `main` and wait (a one-off breakpoint, then `run`) |
| `run` | `r` | Start the program, with the arguments given to `--args` |
| `next` / `step` | `n` / `s` | Run one line, stepping over / into function calls |
| `continue` | `c` | Run on to the next breakpoint or watchpoint |
| `finish` | `fin` | Run until the current function returns, and print the value it returned |
| `backtrace` | `bt` | The call stack, innermost frame first (`#0`) |
| `frame 1` | `f 1` | Select a frame, so `info locals` and `print` look there |
| `info locals` / `info args` | | Every local variable / argument of the selected frame |
| `print expr` | `p` | Evaluate C: `p len`, `p *node`, `p/x flags`, `p *arr@4` (four elements from `arr`) |
| `x/8xb buf` | | Examine raw memory: a count, a format (`x` hex, `d` decimal, `c` char, `s` string) and a unit (`b` byte, `h` 2, `w` 4, `g` 8) |
| `watch total` | | Stop whenever `total` changes, showing the old and new value |
| `display total` | | Print `total` every time the program stops |
| `info breakpoints` / `delete 2` | `i b` / `d 2` | List breakpoints and watchpoints / remove one |
| `macro expand CHECK(n > 0)` | | Show what a macro becomes (needs `-g3`) |
| `quit` | `q` | Leave gdb |

A short session, stopping in a function that sums an array and watching the total grow:

```text
(gdb) break sum
(gdb) run
Breakpoint 1, sum (a=0x7fffffffcac0, n=4) at loop.c:4
(gdb) p *a@4
$1 = {1, 2, 3, 4}
(gdb) watch total
(gdb) continue
Hardware watchpoint 2: total
Old value = 0
New value = 1
(gdb) delete 2
(gdb) finish
Run till exit from #0  sum (a=0x7fffffffcac0, n=4) at loop.c:5
0x00005555555551da in main () at loop.c:13
Value returned is $2 = 10
```

`delete 2` comes first because `finish` stops at any breakpoint or watchpoint hit on the way out: with
the watchpoint still set, it stops at the next change of `total` (`Old value = 1`, `New value = 3`) and
never reaches the return.

For a one-shot look without the prompt — useful in a script — run gdb in batch mode:
`gdb -q -batch -ex run -ex bt --args ./build/test_greet`.

---

## 3. Core files — a crash, after the fact

A core file is a snapshot of the process's memory at the moment it died; gdb can load it and show the
stack as it was. They are off by default (`ulimit -c` prints `0`), so turn them on for the shell you are
working in:

```bash
ulimit -c unlimited          # this shell only
./build/hello                # ... Segmentation fault (core dumped)
cat /proc/sys/kernel/core_pattern
```

On Ubuntu 24.04 with apport running, `core_pattern` begins `|/usr/share/apport/apport`: the kernel hands
the core to apport, which writes it to `/var/lib/apport/coredump/` rather than the current folder, named
`core.<program path with / as _>.<uid>.<boot id>.<pid>.<time>` (observed on the owner's machine,
27/09/2026). Load it next to the binary that produced it:

```bash
gdb -q ./build/hello /var/lib/apport/coredump/core.<...>
(gdb) bt
(gdb) frame 0
(gdb) info locals
```

A core is a post-mortem: `bt`, `frame`, `print` and `x` work, but there is no process left to `step`.
Core files live outside the repository and are never committed. The full rules for where cores go are in
`man 5 core`.

---

## 4. Reading the reports

### AddressSanitizer

From a use-after-free, built with `make san` (addresses and library frames trimmed):

```text
==239649==ERROR: AddressSanitizer: heap-use-after-free on address 0x502000000014 ...
READ of size 4 at 0x502000000014 thread T0
    #0 0x62079ba41327 in main uaf.c:9
0x502000000014 is located 4 bytes inside of 16-byte region [0x502000000010,0x502000000020)
freed by thread T0 here:
    #0 0x723b99afc4d8 in free
    #1 0x62079ba412a0 in main uaf.c:8
previously allocated by thread T0 here:
    #0 0x723b99afd9c7 in malloc
    #1 0x62079ba4127f in main uaf.c:5
SUMMARY: AddressSanitizer: heap-use-after-free uaf.c:9 in main
```

Read it in this order:

1. **The bug class**, on the `ERROR:` line: `heap-use-after-free`, `heap-buffer-overflow`,
   `stack-buffer-overflow`, `double-free`, or `LeakSanitizer: detected memory leaks`.
2. **The access**: `READ` or `WRITE`, and how many bytes.
3. **Frame `#0` of the first stack is the line that did it** — `uaf.c:9`. Skip frames inside libc or the
   sanitiser runtime; the first frame in your own file is the one that matters.
4. **Where the address sits**: "4 bytes inside of 16-byte region", or "0 bytes after", tells you how far
   out of bounds the access was — often an off-by-one.
5. **The history**: _freed by_ and _previously allocated by_ name the two lines whose disagreement about
   ownership caused the bug (`code/docs/MEMORY-SAFETY.md` Section 3).

The block of shadow bytes after `SUMMARY` is ASan's own map of the memory around the address; it is
rarely needed.

### UndefinedBehaviorSanitizer

One line, in compiler-diagnostic shape — file, line, column, and what was undefined:

```text
ub.c:7:4: runtime error: signed integer overflow: 2147483647 + 1 cannot be represented in type 'int'
```

Set `UBSAN_OPTIONS=print_stacktrace=1` to get the call stack underneath it.

### valgrind

The same use-after-free, from the plain build under `make memcheck`:

```text
==179000== Invalid read of size 4
==179000==    at 0x1091C5: main (uaf.c:9)
==179000==  Address 0x4a87044 is 4 bytes inside a block of size 16 free'd
==179000==    at 0x484988F: free (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==179000==    by 0x1091BC: main (uaf.c:8)
==179000==  Block was alloc'd at
==179000==    at 0x4846828: malloc (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==179000==    by 0x10919E: main (uaf.c:5)
```

The same three questions — what kind of access, where, and the block's history — in a different layout.
`Conditional jump or move depends on uninitialised value(s)` is the uninitialised-read report; add
`--track-origins=yes` to learn where the value came from. The `LEAK SUMMARY` at the end counts the four
leak kinds.

### `-fanalyzer`

The analyser prints the path it found as numbered events, each pointing at a source line (the source
excerpts between events trimmed here):

```text
df.c:11:17: warning: double-'free' of 'p' [CWE-415] [-Wanalyzer-double-free]
    (1) allocated here
    (2) assuming 'p' is non-NULL
    (5) first 'free' here
    (6) following 'true' branch (when 'n > 0')...
    (8) second 'free' here; first 'free' was at (5)
```

Compiled by hand without `-Werror`, as here, it is a warning; under the build's `-Werror` (`make lint`)
the same line starts `error:` and ends `[-Werror=analyzer-double-free]`. Read the events in order and
ask whether that path can really happen. Usually it can; sometimes the
analyser has missed a constraint, and the finding is a false positive (`code/docs/MEMORY-SAFETY.md`
Section 4).

---

## 5. Rust

- **Backtraces.** A panic prints its message and the `file:line:col` where it started.
  `RUST_BACKTRACE=1 cargo run` adds a short backtrace; `RUST_BACKTRACE=full` shows every frame.
- **`rust-gdb`** is gdb with the Rust pretty-printers loaded — installed with rustup — so `print` shows
  a `String` as `"hi"` and a `Vec` as `Vec(size=2) = {1, 2}` instead of raw pointers. From
  `code/src/rust/`: `rust-gdb -q --args target/debug/ms001_hello Sam`.
- **Stopping where a panic starts**, before it unwinds: `break core::panicking::panic_fmt` (checked with
  Rust 1.92). The frame above it is your code.
- **Debugging a test.** `cargo test --no-run` builds the tests and prints the path of each test binary
  (`Executable unittests src/lib.rs (target/debug/deps/ms001_hello-<hash>)`). Run that binary under
  `rust-gdb`, with a test name as its argument to run only that test.
- **Debug information** is on in the default `dev` profile that `cargo build` and `cargo test` use, and
  off in `--release` unless the profile turns it on.

---

## 6. The kernel under QEMU and gdb — planned, added at P4

When the kernel phase starts, the kernel runs inside QEMU, and gdb attaches to QEMU's built-in gdb
server. Custom kernels and modules run in QEMU only, never on the host (`.claude/CLAUDE.md`). The how-to
workflows that fetch, build and boot the kernel — `how-to/workflows/07-kernel-source-setup/` and
`how-to/workflows/08-build-and-boot-kernel/` — are planned, added at P4.

```bash
qemu-system-x86_64 -kernel <bzImage> -initrd <initramfs> \
    -append "console=ttyS0 nokaslr" -nographic -s -S
```

- **`-s`** is shorthand for `-gdb tcp::1234`; **`-S`** freezes the CPU at start-up until gdb says `c`
  (both from `qemu-system-x86_64 --help`, QEMU 8.2).
- In a second terminal: `gdb vmlinux` (the uncompressed kernel with symbols, from the build tree), then
  `target remote :1234`, `break start_kernel`, `continue`.
- The kernel's own guide, [Debugging kernel and modules via gdb](https://docs.kernel.org/process/debugging/gdb-kernel-debugging.html),
  asks for a kernel built with debug information and `CONFIG_GDB_SCRIPTS`, with
  `CONFIG_DEBUG_INFO_REDUCED` off and `CONFIG_FRAME_POINTER` on where the architecture supports it, and
  booted with `nokaslr` so the symbols match the addresses. Its `lx-symbols` command loads the symbols
  of modules as they are inserted.

---

## Cross-references

- `code/workflows/07-debug/` — the procedure: reproduce, shrink, failing test, minimal fix, BUG record
- `code/docs/MEMORY-SAFETY.md` — the bug classes behind the reports, and the tools that produce them
- `code/docs/BUILD.md` — the `-g3 -O0` build and the `san`, `memcheck` and `lint` targets
- `how-to/workflows/05-debugging-environment/` — setting up gdb, core dumps and the tools
- `project-management/src/13-BUGS/` — where a debugged bug is recorded
- `code/REFERENCES.md` — the GDB and valgrind manuals, and the kernel and QEMU documentation

_Part of the `code/docs/` documentation family._
