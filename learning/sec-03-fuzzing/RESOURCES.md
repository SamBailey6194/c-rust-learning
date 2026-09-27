# Resources — sec-03-fuzzing

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 What coverage-guided fuzzing is | LLVM libFuzzer, <https://llvm.org/docs/LibFuzzer.html>; AFL++, <https://github.com/AFLplusplus/AFLplusplus> | — | — |
| 02 The sanitiser as oracle | AddressSanitizer, <https://github.com/google/sanitizers/wiki/AddressSanitizer>; GCC Instrumentation Options, <https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/Instrumentation-Options.html> | `code/docs/MEMORY-SAFETY.md` | — |
| 03 Property testing with proptest | proptest docs (Context7, cited to docs.rs at the version in use) | `code/docs/TESTING.md` | `code/src/rust/crates/msNNN_<snake>/` (planned) |
| 04 libFuzzer target and corpus (Blocked) | LLVM libFuzzer, <https://llvm.org/docs/LibFuzzer.html> | `code/docs/MEMORY-SAFETY.md` | `code/src/c/msNNN-<kebab>/` (planned; Blocked — `GAPS.md`) |
| 05 Crash triage and minimisation (Blocked) | LLVM libFuzzer, <https://llvm.org/docs/LibFuzzer.html>; AFL++, <https://github.com/AFLplusplus/AFLplusplus> | — | Blocked — `GAPS.md` |
| 06 cargo-fuzz for Rust (Blocked) | cargo-fuzz book, <https://rust-fuzz.github.io/book/cargo-fuzz.html> | `code/docs/RUST-CODING-PRINCIPLES.md` | `code/src/rust/crates/msNNN_<snake>/` (planned; Blocked — `GAPS.md`) |
