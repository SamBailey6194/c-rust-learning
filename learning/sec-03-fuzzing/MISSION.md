# Mission — sec-03-fuzzing

**Started**: not yet · **Family**: sec · **Phase**: S1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam is going to write parsers that read untrusted input — package metadata, repository indexes,
installer answers — and asked for security lessons to go with the build. Hand-written test cases only
cover the inputs Sam thought of; fuzzing generates the ones he did not, and finds the `sec-02` bug
classes automatically. This topic teaches the method and points it at Sam's own parsers, so hardening
against hostile input becomes routine rather than an afterthought. Because the coverage-guided
tooling is not installed yet, it also teaches the property-testing practice that works today, so the
skill starts building before the toolchain gap closes.

## Can do it when

- Sam can explain the coverage-guided fuzzing loop and why the sanitiser is its oracle.
- Sam can write property tests for a parser with `proptest` on the pinned stable toolchain.
- Sam can design a libFuzzer target and seed corpus (and run it once clang/libFuzzer is installed).
- Sam can minimise a crash into a regression test and set up cargo-fuzz once a nightly toolchain is
  available.

## Parked for later

- The memory-corruption bug classes themselves — `sec-02` (a prerequisite).
- Fuzzing the package manager, repository metadata and installer as a system — a later S3 topic.
- Turning a crash into an exploit — `sec-10`, on Sam's own binaries only.
