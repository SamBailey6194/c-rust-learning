# Syllabus — sec-11-reverse-engineering

**Track**: sec · **Phase**: S2 · **Path**: Later · **Detail**: outline · **Prerequisites**: sec-06 (isolated lab), sec-02 (ELF and mitigations), sec-10 (binary exploitation), P3 (Rust) for reading compiled Rust
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Reverse engineering is how Sam reads a binary he did not write the source for, or checks what his own build actually produced. In the mission it serves two ends: understanding compiled C and Rust deeply enough to patch ggml or debug the inference server, and inspecting Syntek OS artefacts and his own binaries the way an attacker or an auditor would. Every lesson here works on Sam's own binaries and legal training material only; live malware is out of scope and stays in sec-17/sec-18 under their defensive-only rules. It is an **outline** topic because S2 is a far phase: its builds are sketched and its sources, checked on 27/09/2026, are re-verified when the topic opens.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The ELF format up close | 2–3 sittings | yes — elf-tour | Security |
| 02 | Disassembly and the AMD64 calling convention | 2–3 sittings | yes — disasm | — |
| 03 | Static analysis with Ghidra | multi-session build | yes — ghidra-recover | Safety |
| 04 | Reading compiled Rust versus C | 2–3 sittings | yes — rust-vs-c | — |
| 05 | Dynamic analysis with gdb, strace and ltrace | 2–3 sittings | yes — dynamic-trace | Safety |

---

## 01 — The ELF format up close

- **Objective:** Sam can name the parts of an ELF file and read them out of one of his own binaries with `readelf` and `objdump`.
- **Builds on:** sec-02's first contact with ELF and `readelf`; the C and Rust binaries Sam has already built under `code/src/`.
- **Key ideas:**
  - The ELF header sits at offset zero and points to the program header table and the section header table.
  - Program headers describe segments the loader maps at run time; section headers describe the link-time view (`.text`, `.data`, `.bss`, `.rodata`, symbol and relocation sections).
  - Symbols (`nm`, `.symtab`/`.dynsym`) and relocations tie names to addresses; a stripped binary drops `.symtab`.
  - The dynamic section, `NEEDED` entries and the interpreter (`ldd`, `readelf -d`) drive shared-library loading.
- **Recall targets:** where the ELF header lives and what it points to; the difference between the segment view and the section view; what stripping removes and what it leaves.
- **Build:** compile one small C program at `-O0` and `-O2` and one Rust program in debug and release, then walk each with `readelf -h -l -S -d` and `objdump -h`; record which sections change and which symbols disappear when stripped. Planned code path: a new `msNNN-elf-tour` exercise under `code/src/c/` (planned) reusing a program pattern like `code/src/c/ms001-hello/`.
- **Security lens:** what a stripped, statically linked binary tells an analyst versus a dynamically linked debug build; why release artefacts are stripped.
- **Sources:** (checked 27/09/2026; re-verify when S2 opens) `man 5 elf` (<https://man7.org/linux/man-pages/man5/elf.5.html>); `man 1 readelf` (<https://man7.org/linux/man-pages/man1/readelf.1.html>); GNU binutils `readelf` manual (<https://sourceware.org/binutils/docs/binutils/readelf.html>).
- **Done when:** Sam can point at any section in his own binary and say what it holds and whether the loader or the linker uses it.

---

## 02 — Disassembly and the AMD64 calling convention

- **Objective:** Sam can disassemble a function he wrote and explain, register by register, how its arguments arrive and its result returns.
- **Builds on:** lesson 01's `.text` section; Sam's C knowledge of the stack and function calls.
- **Key ideas:**
  - `objdump -d` and `-M intel`/AT&T syntax; reading a function prologue and epilogue.
  - The System V AMD64 ABI: integer arguments in `rdi, rsi, rdx, rcx, r8, r9`, return in `rax`, callee-saved versus caller-saved registers, stack alignment.
  - How local variables, spills and the frame pointer appear; how `-O2` reorders and inlines so the disassembly no longer maps line-for-line to the source.
- **Recall targets:** the first few integer-argument registers and the return register; why an optimised build is harder to read than the source suggests.
- **Build:** disassemble a two-or-three-argument function from an earlier exercise, predict where each argument and the return value live, then confirm against `objdump -d`. Planned code path: a `msNNN-disasm` exercise under `code/src/c/` (planned).
- **Sources:** (checked 27/09/2026; re-verify when S2 opens) `man 1 objdump` (<https://man7.org/linux/man-pages/man1/objdump.1.html>); GNU binutils manual (<https://sourceware.org/binutils/docs/binutils/readelf.html>); the System V AMD64 ABI is the calling-convention reference — read it when the lesson opens and pin the exact document then.
- **Done when:** Sam predicts the register use of a small function before disassembling it and the disassembly matches.

---

## 03 — Static analysis with Ghidra

- **Objective:** Sam can load one of his own binaries into Ghidra, use the decompiler to recover its logic, and compare that to the source he wrote.
- **Builds on:** lessons 01 and 02 — sections, symbols and disassembly are what Ghidra presents at a higher level.
- **Key ideas:**
  - Ghidra is a free software reverse-engineering framework; the workflow is import, auto-analyse, then navigate functions.
  - The decompiler produces C-like pseudocode; renaming variables and adding comments turns a first read into an understood one.
  - Comparing the decompiler's output to known source is how Sam calibrates what the tool infers versus what it guesses.
- **Recall targets:** the import-then-analyse workflow; why decompiler output is a reconstruction, not the original source.
- **Build:** import a binary Sam compiled himself, recover a function's behaviour in the decompiler, annotate it, and check it against his source. Planned code path: analysis of a binary built under `code/src/` — no new source, notes only, unless a `msNNN-ghidra-recover` exercise is specified.
- **Safety:** analyse only Sam's own binaries and legal training samples; no live malware in Ghidra on the host — live-sample analysis is deferred (`DEFERRED.md`) and governed by sec-18's rules.
- **Sources:** (checked 27/09/2026; re-verify when S2 opens) Ghidra project (<https://github.com/NationalSecurityAgency/ghidra>); confirm the current release and its documentation when the lesson opens.
- **Done when:** Sam recovers a function's logic in Ghidra and can explain where the decompiler was exact and where it inferred.

---

## 04 — Reading compiled Rust versus C

- **Objective:** Sam can spot, in a disassembly, the features that make compiled Rust read differently from compiled C.
- **Builds on:** lesson 02's disassembly; Sam's P3 Rust (monomorphisation, panics, bounds checks).
- **Key ideas:**
  - Name mangling: C symbols are plain; Rust 1.92 uses its legacy scheme by default (`_ZN…E` with a hash suffix) and the `v0` scheme with `-C symbol-mangling-version=v0` — both carry the path, and v0 also carries generic arguments.
  - Monomorphisation duplicates generic code per concrete type, so one generic function becomes several in `.text`.
  - Panics and unwinding, bounds checks and `Option`/`Result` handling appear as extra branches and calls that idiomatic C does not emit.
  - Release versus debug and stripping change the picture as much as the language does.
- **Recall targets:** why a Rust binary has more and longer symbol names; where bounds checks and panic paths show up.
- **Build:** implement the same small algorithm in C and in Rust, compile both, and compare symbol tables and disassembly side by side. Planned code paths: a `msNNN-rust-vs-c` C exercise under `code/src/c/` and its Rust counterpart under `code/src/rust/crates/` (both planned).
- **Sources:** (checked 27/09/2026; re-verify when S2 opens) `man 1 objdump` and `man 1 nm`; the rustc book, "Symbol Mangling" (<https://doc.rust-lang.org/1.92.0/rustc/symbol-mangling/index.html>) and its v0 chapter (<https://doc.rust-lang.org/1.92.0/rustc/symbol-mangling/v0.html>), for the pinned toolchain 1.92.0.
- **Done when:** given an unlabelled disassembly, Sam can say whether it was built from C or Rust and point to the evidence.

---

## 05 — Dynamic analysis with gdb, strace and ltrace

- **Objective:** Sam can watch one of his own binaries run — stepping in gdb and tracing its syscalls and library calls — and reconcile that with the static picture.
- **Builds on:** `code/docs/DEBUGGING.md` (gdb); lessons 01–04; sec-10's use of gdb during exploitation.
- **Key ideas:**
  - gdb breakpoints, single-stepping, and examining registers and memory (`info registers`, `x/`); combining a static map with a live run.
  - `strace` shows the syscall boundary; `ltrace` shows library calls; each answers a different "what did it actually do" question.
  - Static plus dynamic together resolves what a decompiler could only guess.
- **Recall targets:** when a syscall trace answers a question a disassembly cannot; how to set a breakpoint and read a register in gdb.
- **Build:** step through one of Sam's binaries in gdb to a chosen function, read the arguments in registers, then run it under `strace` and match the syscalls to the source. Planned code path: a `msNNN-dynamic-trace` exercise under `code/src/c/` (planned).
- **Safety:** trace only Sam's own binaries and legal training material; nothing untrusted is executed on the host — untrusted binaries run in the sec-06 lab VM.
- **Sources:** (checked 27/09/2026; re-verify when S2 opens) `man 1 gdb` (<https://man7.org/linux/man-pages/man1/gdb.1.html>); the gdb manual (<https://sourceware.org/gdb/current/onlinedocs/gdb/>); `man 1 strace`; `man 1 ltrace` (ltrace is not installed on the host, 27/09/2026 — Sam installs it himself, or the lesson uses `strace` alone).
- **Done when:** Sam explains a binary's behaviour using both a static read and a live trace, and the two agree.
