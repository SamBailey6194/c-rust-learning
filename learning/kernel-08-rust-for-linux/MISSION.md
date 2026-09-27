# Mission — kernel-08-rust-for-linux

**Started**: not yet · **Family**: kernel · **Phase**: P4 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Sam's mission is to learn C thoroughly and deepen Rust, and his first question about the kernel was whether editing it
needs C. The answer was yes for the core, with Rust now in mainline for some driver work. This optional topic is where
his two languages meet inside the kernel: what Rust-for-Linux supports on the kernel lines Syntek OS might run, how to
build a Rust-enabled kernel in QEMU, and how a Rust module uses safe abstractions instead of raw bindings — the same
`unsafe` discipline he learns in P3, applied where a mistake oopses a kernel.

## Can do it when

- State Rust-for-Linux's status on the 6.18 longterm line and on v7.x, and the tools a Rust-enabled build needs.
- Pass `make LLVM=1 rustavailable` and boot a Rust-enabled kernel in QEMU with the minimal sample loaded.
- Write, build and load his own minimal Rust module, and explain bindings against abstractions and every `unsafe`
  block's `// SAFETY:` argument.
- Find, from MAINTAINERS on the day, which subsystems accept Rust drivers.

## Parked for later

- Writing a real Rust driver for Syntek OS hardware → no hardware is chosen yet; `DEFERRED.md` when one is needed.
- Building the whole kernel with Clang/LLVM for other reasons (LTO, CFI) → not planned yet.
- Upstreaming Rust code → kernel-07-upstreaming, applied to a Rust patch.
