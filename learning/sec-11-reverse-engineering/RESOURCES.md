# Resources — sec-11-reverse-engineering

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 The ELF format up close | `man 5 elf` (<https://man7.org/linux/man-pages/man5/elf.5.html>); `man 1 readelf` (<https://man7.org/linux/man-pages/man1/readelf.1.html>); binutils `readelf` manual (<https://sourceware.org/binutils/docs/binutils/readelf.html>) | — | `code/src/c/msNNN-elf-tour/` (planned) |
| 02 Disassembly and the AMD64 calling convention | `man 1 objdump` (<https://man7.org/linux/man-pages/man1/objdump.1.html>); System V AMD64 ABI (pin the document at lesson open) | — | `code/src/c/msNNN-disasm/` (planned) |
| 03 Static analysis with Ghidra | Ghidra project (<https://github.com/NationalSecurityAgency/ghidra>) — confirm current release at lesson open | — | analysis of a binary under `code/src/` |
| 04 Reading compiled Rust versus C | `man 1 objdump`; `man 1 nm`; the rustc book, "Symbol Mangling" (<https://doc.rust-lang.org/1.92.0/rustc/symbol-mangling/index.html>) and its v0 chapter | — | `code/src/c/msNNN-rust-vs-c/` and `code/src/rust/crates/msNNN_rust_vs_c/` (planned) |
| 05 Dynamic analysis with gdb, strace and ltrace | `man 1 gdb` (<https://man7.org/linux/man-pages/man1/gdb.1.html>); gdb manual (<https://sourceware.org/gdb/current/onlinedocs/gdb/>); `man 1 strace`; `man 1 ltrace` (not installed on the host, 27/09/2026) | `code/docs/DEBUGGING.md` — gdb | `code/src/c/msNNN-dynamic-trace/` (planned) |
