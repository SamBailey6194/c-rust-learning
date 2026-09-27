# Resources — sec-02-memory-corruption-and-mitigations

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Stack buffer overflow | CWE-121, <https://cwe.mitre.org/data/definitions/121.html>; AddressSanitizer, <https://github.com/google/sanitizers/wiki/AddressSanitizer> | `code/docs/MEMORY-SAFETY.md` | `code/src/c/msNNN-<kebab>/` (planned) |
| 02 Format-string bugs | CWE-134, <https://cwe.mitre.org/data/definitions/134.html>; GCC Warning Options, <https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/Warning-Options.html> | `code/docs/BUILD.md` — warning set | `code/src/c/msNNN-<kebab>/` (planned) |
| 03 Use-after-free and double-free | CWE-416, <https://cwe.mitre.org/data/definitions/416.html>; AddressSanitizer, <https://github.com/google/sanitizers/wiki/AddressSanitizer> | `code/docs/MEMORY-SAFETY.md` | `code/src/c/msNNN-<kebab>/` (planned) |
| 04 Integer overflow into allocation | CWE-190, <https://cwe.mitre.org/data/definitions/190.html>; GCC Instrumentation Options, <https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/Instrumentation-Options.html> | `code/docs/MEMORY-SAFETY.md` | `code/src/c/msNNN-<kebab>/` (planned) |
| 05 Mitigations, toggled and inspected | GCC Instrumentation Options, <https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/Instrumentation-Options.html>; GNU ld Options, <https://sourceware.org/binutils/docs/ld/Options.html>; kernel x86 shadow stacks, <https://docs.kernel.org/arch/x86/shstk.html>; `man 1 readelf`; `man 7 feature_test_macros` | `code/docs/BUILD.md` | `code/src/c/msNNN-<kebab>/` (planned) |
| 06 Why Rust removes whole classes | The Rustonomicon, <https://doc.rust-lang.org/nomicon/> | `code/docs/RUST-CODING-PRINCIPLES.md` · `code/docs/FFI.md` | `code/src/rust/crates/msNNN_<snake>/` (planned) |
