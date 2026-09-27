# Mission — os-05-build-system-and-reproducibility

**Started**: not yet · **Family**: os · **Phase**: P6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam's Syntek OS is to be "a clean distro" with profiles for everything from beginner desktops to routers, all on one
base — which only works if the base is built by a machine, the same way every time, not by hand from a book. When a
NixOS fork came up, Sam wanted the ideas without the base: declarative configuration, reproducible builds and atomic
rollback designed in from scratch. This topic is where the reproducible-builds idea becomes real, and where the build
system that every Syntek OS package and profile passes through is first written.

## Can do it when

- Sam can write an LFS package as a recipe in his own format, and his parser rejects malformed recipes (`cargo test`
  and `cargo clippy` clean).
- Sam can compute a build order from recipes, report a cycle, and explain how LFS breaks its cycles.
- Sam's builder runs a recipe with no network and no view of the host, and its isolation tests pass.
- Sam can make two independent builds of a package hash identically and explain every difference he removed.
- Sam can prove reproducibility with a second, independent rebuild and explain a mismatch with diffoscope.
- Sam's pipeline rebuilds a changed package and its dependants in isolation, checks reproducibility, and publishes to
  staging with no signing key on any builder.

## Parked for later

- Signing and publishing packages and repositories — os-08-repositories-signing-and-updates.
- The package format and the package manager that installs what the farm builds — os-07-package-manager.
- Reproducible kernel builds (`KBUILD_BUILD_TIMESTAMP` and friends) — kernel-05-downstream-tree.
- Kernel CI on the same farm — kernel-06-kernel-ci-and-security.
- Fuzzing the recipe parser — sec-03-fuzzing (`GAPS.md` → "Fuzzing Rust needs a nightly toolchain").
