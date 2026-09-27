# Syllabus — sec-02-memory-corruption-and-mitigations

**Track**: sec · **Phase**: S1 · **Path**: Core · **Detail**: full · **Prerequisites**: P2 (the bug classes need C, pointers and dynamic memory); sec-01
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic turns the memory-safety discipline of the C track into security understanding: the bug
classes that undermine C programs, how each mitigation raises the cost of exploiting them, and why
Rust removes whole classes at compile time. Every bug is studied in a **deliberately vulnerable
program Sam writes**, built as a clearly named target under `code/src/c/msNNN-<kebab>/` that CI
compiles but never installs, boots or ships (`.claude/CLAUDE.md` non-negotiables). The lessons stay
defensive: observe the bug under the sanitisers, then watch a mitigation stop it — no working
exploit or shellcode is written or committed. It supports the secure-C work behind the package
manager, the kernel patch series and the LLM's C kernels.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Stack buffer overflow: what it corrupts | 2–3 sittings | yes — vuln-stack | Security, Safety |
| 02 | Format-string bugs | 1 sitting | yes — vuln-format | Security, Safety |
| 03 | Use-after-free and double-free | 2–3 sittings | yes — vuln-uaf | Security, Safety |
| 04 | Integer overflow into an undersized allocation | 1 sitting | yes — vuln-int | Security, Safety |
| 05 | The mitigations, toggled and inspected | multi-session build | yes — hardening-matrix | Efficiency, Security, Safety |
| 06 | Why Rust removes whole classes | 2–3 sittings | yes — safe-port | Security |

---

## 01 — Stack buffer overflow: what it corrupts

- **Objective:** Sam can explain what an out-of-bounds write to a stack array overwrites, and show
  the bug under AddressSanitizer.
- **Builds on:** P1 arrays and strings, P2 dynamic memory; sec-01 lesson 02 (attack surface).
- **Key ideas:**
  - The stack frame: local buffers, saved registers, the return address, and why an unbounded write
    reaches them.
  - The bug is an unbounded copy (`strcpy`, `gets`, a hand loop with no limit), not a language
    feature; bounded writes (`snprintf`, explicit lengths) prevent it.
  - Undefined behaviour is undefined: what happens after the write is not "what gcc does today".
  - ASan reports the write; the exercise stops at demonstrating the corruption, not exploiting it.
- **Recall targets:** predict which stack contents an over-long write reaches, and name the bounded
  alternative to the unbounded call.
- **Build:** a deliberately vulnerable program `vuln-stack` under `code/src/c/msNNN-<kebab>/`, in its
  own clearly named target that CI does not install. Sam triggers the out-of-bounds write and reads
  the AddressSanitizer report; a fixed variant uses a bounded write and passes `make test`, `san`
  and `memcheck`. Checked by: ASan flags the vulnerable target; the fixed target is clean. No
  exploit payload is written.
- **Security lens:** the overflow is the archetypal memory-corruption bug; naming what it corrupts
  is the basis of every mitigation in lesson 05.
- **Safety:** the vulnerable target is never installed or shipped; it runs only under the exercise's
  own sanitiser harness, locally.
- **Sources:** CWE-121 Stack-based Buffer Overflow, <https://cwe.mitre.org/data/definitions/121.html>; AddressSanitizer, <https://github.com/google/sanitizers/wiki/AddressSanitizer>; `code/docs/MEMORY-SAFETY.md`.
- **Done when:** Sam explains what the write corrupts and shows ASan catching it, then a bounded fix
  passing every gate.

## 02 — Format-string bugs

- **Objective:** Sam can explain why passing untrusted data as a format string is a bug and how the
  compiler warns about it.
- **Builds on:** lesson 01; P1 the preprocessor and variadic-style calls; `printf` family.
- **Key ideas:**
  - `printf(user)` versus `printf("%s", user)`: the first treats attacker data as conversion
    specifiers, reading (and with `%n`, writing) memory.
  - `-Wformat=2` (already in the house warning set) rejects a non-literal format at compile time —
    the bug is a warning the repository treats as an error.
  - The bug reads the stack; the exercise demonstrates the warning and a leaked value, not a full
    exploit.
- **Recall targets:** given a call, say whether it is a format-string bug and which flag catches it.
- **Build:** a `vuln-format` target under `code/src/c/msNNN-<kebab>/` demonstrating the warning and,
  with the warning suppressed only inside that target, a benign information leak; the fixed variant
  uses a literal format and passes the gates. Checked by: `-Wformat=2` flags the vulnerable form.
- **Security lens:** untrusted input crossing into a format string is a trust-boundary failure
  (sec-01 lesson 02).
- **Safety:** vulnerable target confined and never shipped.
- **Sources:** CWE-134 Use of Externally-Controlled Format String, <https://cwe.mitre.org/data/definitions/134.html>; GCC Warning Options (`-Wformat=2`), <https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/Warning-Options.html>.
- **Done when:** Sam explains the bug and shows the compiler rejecting the non-literal format.

## 03 — Use-after-free and double-free

- **Objective:** Sam can explain what a dangling pointer is and show a use-after-free under
  AddressSanitizer.
- **Builds on:** lesson 01; P2 `malloc`/`free` and object lifetime.
- **Key ideas:**
  - Object lifetime: a pointer read after `free` is undefined; the allocator may have reused the
    block.
  - Double-free corrupts allocator metadata; both are lifetime bugs, not pointer-value bugs.
  - Set-to-NULL-after-free and single-owner discipline as the C-side mitigations; ASan's quarantine
    catches the access.
- **Recall targets:** predict what a read-after-free returns and why it is undefined; name a
  discipline that prevents the double-free.
- **Build:** a `vuln-uaf` target under `code/src/c/msNNN-<kebab>/` triggering a use-after-free and a
  double-free, both caught by ASan; the fixed variant enforces single ownership and passes the
  gates.
- **Security lens:** use-after-free is a leading exploitation primitive; understanding lifetime is
  the bridge to why Rust's ownership model closes it (lesson 06).
- **Safety:** vulnerable target confined and never shipped.
- **Sources:** CWE-416 Use After Free, <https://cwe.mitre.org/data/definitions/416.html>; AddressSanitizer, <https://github.com/google/sanitizers/wiki/AddressSanitizer>; `code/docs/MEMORY-SAFETY.md`.
- **Done when:** Sam shows ASan catching the use-after-free and explains the lifetime rule that was
  broken.

## 04 — Integer overflow into an undersized allocation

- **Objective:** Sam can explain how an integer overflow in a size calculation leads to an
  undersized buffer and a later out-of-bounds write.
- **Builds on:** P1 integer promotions and undefined behaviour; lesson 01.
- **Key ideas:**
  - `n * size` wrapping (or a signed-overflow UB) yields a small allocation; the subsequent write
    overflows it.
  - UBSan catches the signed case; an unsigned `size_t` wrap is defined behaviour, which GCC's
    `-fsanitize=undefined` does not report, so only ASan's heap-buffer-overflow on the later write
    shows it. The checked multiply (`__builtin_mul_overflow`, or `calloc`'s built-in check) is the
    fix.
  - The bug is often in length handling of untrusted input — a parser's classic mistake.
- **Recall targets:** given a size computation, spot the overflow and name the checked alternative;
  say which sanitiser reports a signed overflow and which only sees an unsigned wrap's consequence.
- **Build:** a `vuln-int` target under `code/src/c/msNNN-<kebab>/` where an overflowing size feeds a
  short allocation; UBSan (signed variant) and ASan (the out-of-bounds write) show the effect; the
  fixed variant uses a checked multiply and passes the gates.
- **Security lens:** length handling of untrusted input is where os-07's "safe archive extraction"
  and parser lessons meet this bug.
- **Safety:** vulnerable target confined and never shipped.
- **Sources:** CWE-190 Integer Overflow or Wraparound, <https://cwe.mitre.org/data/definitions/190.html>; GCC Instrumentation Options (`-fsanitize=undefined`), <https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/Instrumentation-Options.html>.
- **Done when:** Sam shows the overflow producing an undersized buffer and the checked fix passing.

## 05 — The mitigations, toggled and inspected

- **Objective:** Sam can name each common binary mitigation, enable and disable it, and read whether
  a binary has it using `readelf`.
- **Builds on:** lessons 01–04.
- **Key ideas:**
  - Stack canaries (`-fstack-protector-strong`), non-executable stack (NX / `GNU_STACK`), position-
    independent executables and ASLR (`-fPIE -pie`), RELRO — partial with `-Wl,-z,relro`, full with
    `-Wl,-z,relro,-z,now` (`readelf -l` shows `GNU_RELRO`, `readelf -d` shows `BIND_NOW`) —
    `_FORTIFY_SOURCE`, and CET / shadow stacks (`-fcf-protection`): what each stops and what it costs.
    This machine's i9-9900K has no CET (`grep -w user_shstk /proc/cpuinfo` is empty), so
    `-fcf-protection` is checked only as the ELF property note (`readelf -n`), not enforced.
  - Reading the mitigations from an ELF file with `readelf` (program headers, dynamic section, notes)
    — a checksec-style inspection done by hand.
  - Mitigations raise exploitation cost; they do not fix the bug. Toggled on the lesson-01 program,
    only some change what you see: the stack protector aborts with "stack smashing detected" and
    `_FORTIFY_SOURCE` aborts with "buffer overflow detected" (at -O1 and above); NX, ASLR/PIE and
    RELRO change what an exploit would need, which `readelf` shows but a crash does not.
- **Recall targets:** for a given mitigation, say what it defends and how to see it in `readelf`
  output.
- **Build:** a `hardening-matrix` under `code/src/c/msNNN-<kebab>/` that builds the same small
  program with each mitigation on and off (via named make targets) and a note recording the
  `readelf` evidence and the observed behaviour. Checked by: `readelf` output matches the flags set.
- **Efficiency lens:** record the size and run-time cost of each mitigation (`ls -l`, repeated runs)
  — the measurement method is llm-06 lesson 01; a mitigation's cost is part of choosing it (feeds
  kernel-04's hardening-config work).
- **Security lens:** this is defence in depth (sec-01 lesson 01) made concrete on a binary.
- **Safety:** builds run locally; nothing is installed.
- **Sources:** GCC Instrumentation Options (`-fstack-protector*`, `-fcf-protection`), <https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/Instrumentation-Options.html>; GNU ld Options (`-z relro`, `-z now`), <https://sourceware.org/binutils/docs/ld/Options.html>; `_FORTIFY_SOURCE` in `man 7 feature_test_macros`; kernel x86 shadow stacks, <https://docs.kernel.org/arch/x86/shstk.html>; `man 1 readelf`.
- **Done when:** Sam builds the program with and without each mitigation and reads the difference out
  of `readelf`, recording each mitigation's cost.

## 06 — Why Rust removes whole classes

- **Objective:** Sam can explain which of the bug classes above Rust's type system removes at compile
  time, and where `unsafe` reintroduces the risk.
- **Builds on:** lessons 01–04; P3 ownership, borrowing and `unsafe`.
- **Key ideas:**
  - Bounds-checked indexing, ownership and the borrow checker close buffer overflows, use-after-free
    and double-free for safe Rust; integer overflow panics in debug and wraps (defined) in release.
  - `unsafe` is where the guarantees are hand-maintained; the `// SAFETY:` comment records the
    invariant (`code/docs/FFI.md`).
  - Safety is a property of the safe subset, not of every line — FFI to C is still a trust boundary.
- **Recall targets:** for each C bug from lessons 01–04, say whether safe Rust rejects it and how.
- **Build:** a `safe-port` crate under `code/src/rust/crates/msNNN_<snake>/` porting one vulnerable C
  snippet; Sam observes the compiler or a runtime bounds check rejecting the bug, and (with a
  `// SAFETY:`-documented `unsafe` block) where the guarantee returns to the programmer. Passes
  `cargo test` and `cargo clippy`.
- **Security lens:** this is the argument for Rust in the tool crates and the LLM inference path.
- **Sources:** The Rustonomicon, <https://doc.rust-lang.org/nomicon/>; `code/docs/RUST-CODING-PRINCIPLES.md`; `code/docs/FFI.md`.
- **Done when:** Sam explains, per bug class, whether safe Rust rejects it and where `unsafe`
  reopens the risk.
