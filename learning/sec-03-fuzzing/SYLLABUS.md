# Syllabus — sec-03-fuzzing

**Track**: sec · **Phase**: S1 · **Path**: Later · **Detail**: full · **Prerequisites**: sec-02; P2 (C parsers) and P3 (Rust) for the respective lessons
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Fuzzing finds the bug classes of `sec-02` automatically by feeding a program mutated input and
watching a sanitiser for the crash. This topic teaches the method, the oracle (sanitisers), corpus
and crash handling, and applies it to Sam's own parsers — the package-manager metadata reader and
the installer inputs are the parsers that most need it. Several lessons are **Blocked** on tooling
the host does not yet have (clang/libFuzzer, AFL++, and cargo-fuzz's nightly requirement) and are
recorded in `GAPS.md`; a Blocked lesson does not hold the phase closed, and the stable-toolchain
complement (`proptest` property testing) is taught first so there is a working fuzzing-adjacent
practice from day one.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | What coverage-guided fuzzing is | 1 sitting | no | Security |
| 02 | The sanitiser as the fuzzer's oracle | 1 sitting | no | Security |
| 03 | Property testing a parser with proptest | 2–3 sittings | yes — proptest-parser | Security |
| 04 | A libFuzzer target and a seed corpus (Blocked) | 2–3 sittings | yes — libFuzzer target | Efficiency, Security |
| 05 | Crash triage and test-case minimisation (Blocked) | 1 sitting | yes — crash triage | Security |
| 06 | Fuzzing a Rust parser with cargo-fuzz (Blocked) | 2–3 sittings | yes — cargo-fuzz target | Security |

---

## 01 — What coverage-guided fuzzing is

- **Objective:** Sam can explain the coverage-guided fuzzing loop and why it finds the `sec-02` bug
  classes without hand-written cases.
- **Builds on:** sec-02 (the bug classes); sec-01 lesson 02 (untrusted input).
- **Key ideas:**
  - The loop: instrument for coverage, run an input, keep inputs that reach new code, mutate them.
  - Why coverage feedback beats random input: it walks into deep branches a parser hides bugs in.
  - The fuzzer needs an oracle — a way to know a crash happened — which is the sanitiser (lesson 02).
  - Fuzzing complements, does not replace, the tests and sanitiser gates already in place.
- **Recall targets:** describe the fuzzing loop and why coverage guidance matters for a parser.
- **Build:** none — concept only.
- **Security lens:** fuzzing is how untrusted-input parsers are hardened before they ship.
- **Sources:** LLVM libFuzzer, <https://llvm.org/docs/LibFuzzer.html>; AFL++, <https://github.com/AFLplusplus/AFLplusplus>.
- **Done when:** Sam explains the loop and why it suits a parser, unaided.

## 02 — The sanitiser as the fuzzer's oracle

- **Objective:** Sam can explain why fuzzing is run with AddressSanitizer and UndefinedBehaviorSanitizer,
  and what each turns from silent corruption into a detected crash.
- **Builds on:** lesson 01; sec-02 lesson 05; `code/docs/MEMORY-SAFETY.md`.
- **Key ideas:**
  - Without a sanitiser many corruptions are silent; ASan/UBSan make them observable crashes the
    fuzzer can record.
  - The sanitiser is the oracle; the fuzzer is the input generator — separate roles.
  - The repository already runs these sanitisers as gates, so the mental model carries over.
- **Recall targets:** name what ASan and UBSan each detect and why a fuzzer needs one.
- **Build:** none — concept only.
- **Security lens:** the oracle is what makes a found input a finding rather than a shrug.
- **Sources:** AddressSanitizer, <https://github.com/google/sanitizers/wiki/AddressSanitizer>; GCC Instrumentation Options, <https://gcc.gnu.org/onlinedocs/gcc-13.3.0/gcc/Instrumentation-Options.html>; `code/docs/MEMORY-SAFETY.md`.
- **Done when:** Sam explains the oracle's role and which sanitiser catches which class.

## 03 — Property testing a parser with proptest

- **Objective:** Sam can write property tests for a small parser using `proptest`, the fuzzing-adjacent
  practice that runs on the pinned stable toolchain and in CI.
- **Builds on:** lessons 01–02; P3 Rust; `code/docs/TESTING.md`.
- **Key ideas:**
  - A property test asserts an invariant over generated inputs ("parse never panics", "parse then
    print round-trips"), shrinking a failure to a minimal case.
  - `proptest` is MIT/Apache dual-licensed and works on stable — it passes the audit gate where
    coverage-guided fuzzers do not yet fit the host (lessons 04–06 are Blocked, `GAPS.md`).
  - Properties encode the parser's contract; a violated property is a bug found without a corpus.
- **Recall targets:** state a useful invariant for a parser and how shrinking helps.
- **Build:** a `proptest-parser` crate under `code/src/rust/crates/msNNN_<snake>/` that property-tests
  a small parser Sam writes (a candidate: the metadata reader that later feeds os-07). Passes
  `cargo test` and `cargo clippy`.
- **Security lens:** invariants on untrusted input are the property the package manager's parser must
  hold.
- **Sources:** `code/docs/TESTING.md`; proptest crate docs (via Context7 `resolve-library-id` →
  `query-docs` at the version in use, cited to docs.rs at `/teach` step 3).
- **Done when:** Sam's property tests pass and one deliberately broken invariant is shrunk to a
  minimal failing case.

## 04 — A libFuzzer target and a seed corpus (Blocked)

- **Objective:** Sam can write a libFuzzer entry point for a C parser, build a seed corpus, and run
  it — once clang/libFuzzer is installed.
- **Builds on:** lessons 01–03; P2 C parsers.
- **Key ideas:**
  - The `LLVMFuzzerTestOneInput` entry point and building with `-fsanitize=fuzzer,address`.
  - A seed corpus of valid inputs bootstraps coverage; a dictionary helps structured formats.
  - Fuzzing is a long-running job, not a unit test — run time and executions/second matter.
- **Recall targets:** describe the fuzz entry point and what a seed corpus is for.
- **Build:** **Blocked** — clang/libFuzzer is not installed on the host (`GAPS.md` → "Security lab
  tools and the attacker VM"). When unblocked, a fuzz target under `code/src/c/msNNN-<kebab>/` for a
  parser Sam wrote, run locally only. Until then the lesson is reading and design; the parser is
  exercised by lesson 03's property tests.
- **Efficiency lens:** measure executions per second and coverage growth (measurement method: llm-06
  lesson 01) when the tool is available.
- **Security lens:** libFuzzer is the C-side equivalent of lesson 03 once the toolchain allows it.
- **Sources:** LLVM libFuzzer, <https://llvm.org/docs/LibFuzzer.html>.
- **Done when:** the toolchain gap closes and Sam runs a fuzz target that reaches new coverage from a
  seed corpus — or, while Blocked, Sam designs the target and corpus on paper.

## 05 — Crash triage and test-case minimisation (Blocked)

- **Objective:** Sam can take a fuzzer crash, minimise the input and turn it into a regression test.
- **Builds on:** lesson 04.
- **Key ideas:**
  - A crashing input is minimised to the smallest reproducer; the minimal case becomes a fixed
    regression test.
  - Deduplicating crashes by stack signature so one bug is not counted many times.
  - The finding flows into `sec-01`'s coordinated-disclosure process if it affects third-party code.
- **Recall targets:** outline the path from a raw crash to a committed regression test.
- **Build:** **Blocked** on the same toolchain gap (`GAPS.md` → "Security lab tools and the attacker
  VM"); while Blocked, practise minimisation by hand on a lesson-03 shrink result.
- **Security lens:** triage turns noise into a fixable, disclosable bug.
- **Sources:** LLVM libFuzzer (minimisation), <https://llvm.org/docs/LibFuzzer.html>; AFL++, <https://github.com/AFLplusplus/AFLplusplus>.
- **Done when:** Sam minimises a crash to a regression test — with a fuzzer once unblocked, or by
  hand from a proptest shrink meanwhile.

## 06 — Fuzzing a Rust parser with cargo-fuzz (Blocked)

- **Objective:** Sam can set up `cargo-fuzz` for a Rust parser once a nightly toolchain is available.
- **Builds on:** lessons 03–05; P3 Rust.
- **Key ideas:**
  - `cargo-fuzz` drives libFuzzer against a Rust target; it needs a nightly toolchain, while this
    workspace pins stable (`GAPS.md`) — so it runs outside the pinned workspace or waits.
  - Fuzzing safe Rust finds panics and logic bugs, not memory corruption (which the type system
    already closes); `unsafe` and FFI targets are where memory bugs return.
  - The relationship to lesson 03: proptest for the CI gate, cargo-fuzz for deeper local search.
- **Recall targets:** say what cargo-fuzz adds over proptest and why memory-corruption findings are
  rare in safe Rust.
- **Build:** **Blocked** — cargo-fuzz needs nightly; the workspace pins stable 1.92.0 (`GAPS.md` →
  "Fuzzing Rust needs a nightly toolchain"). When unblocked, a fuzz target for a Rust parser, run
  locally.
- **Security lens:** the same parser hardened two ways — the argument for Rust on the untrusted-input
  path.
- **Sources:** cargo-fuzz book, <https://rust-fuzz.github.io/book/cargo-fuzz.html>.
- **Done when:** the nightly gap closes and cargo-fuzz runs against a Rust parser — or, while Blocked,
  Sam records the setup plan and why it waits.
