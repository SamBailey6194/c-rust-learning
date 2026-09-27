# Resources — sec-14-testing-syntek-os

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Pentesting the profile images in the lab | NIST SP 800-115 (<https://csrc.nist.gov/pubs/sp/800/115/final>); os-08 and os-11 for intended surface (repo topics); tool `--help` at lesson open | — | note in this topic folder; fixes in the Syntek OS build-system repository (created when that build starts) |
| 02 Fuzzing the package manager and installer inputs | sec-03 fuzzing method (repo topic); `man 2 rename`; `man 2 fsync`; `proptest` (Context7 `/proptest-rs/proptest`) | — | Syntek OS package-manager repository fuzz target (created when that build starts), or `code/src/rust/crates/msNNN_pm_fuzz/` (planned) |
| 03 Repository metadata as hostile input | TUF specification (pin version at lesson open); os-08 signing (repo topic); sec-05 signatures (repo topic) | — | the Syntek OS package-manager repository (created when that build starts) |
| 04 Supply-chain attack simulations | os-08 (repo topic); sec-05 signatures (repo topic); TUF specification (pinned at lesson open) | — | lab exercise (artefacts stay in the lab, not committed) |
| 05 Turning tests into a regression suite | os-05 CI-and-build-farms (repo topic); the repo's `.github/workflows/` as the working CI pattern | — | test manifests in the Syntek OS package-manager and build-system repositories (created when those builds start) |
