# Mission — sec-02-memory-corruption-and-mitigations

**Started**: not yet · **Family**: sec · **Phase**: S1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam is writing real C — a package manager, kernel patches, the LLM's fast kernels — and asked for
cybersecurity lessons alongside the build. C gives no safety net, and the discipline (pointers,
manual memory, undefined behaviour) is exactly where security bugs live. This topic makes the C
track's memory-safety work explicit as security: seeing the classic bug classes in code Sam writes,
watching each mitigation raise the cost of exploiting them, and understanding precisely which
classes Rust removes — the argument for writing the tools and the inference path in Rust. It is
studied defensively: observe the bug and the defence, never build a weapon.

## Can do it when

- Sam can explain what a stack buffer overflow, a format-string bug, a use-after-free and an
  integer-overflow-into-allocation each corrupt, and show the sanitiser catching each.
- Sam can name each common binary mitigation, toggle it, read it out of `readelf`, and state its
  cost.
- Sam can say, for each bug class, whether safe Rust rejects it and where `unsafe` reopens the risk.

## Parked for later

- Coverage-guided fuzzing to find these bugs automatically — `sec-03`.
- Turning a bug into a working exploit (ret2libc, ROP) on Sam's own binaries and legal platforms —
  `sec-10`.
- Kernel-side hardening configuration — kernel-04.
