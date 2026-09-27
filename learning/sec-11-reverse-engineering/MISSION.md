# Mission — sec-11-reverse-engineering

**Started**: not yet · **Family**: sec · **Phase**: S2 · **Milestone**: not yet allocated

## Why

Reading compiled code is the skill under two of Sam's stated goals: patching and debugging ggml
and llama.cpp ("C: patch llama.cpp/ggml" from the LLM plan) means reading what the compiler
produced, and auditing Syntek OS and his own binaries means seeing them as an analyst would. This
topic turns the ELF file, the disassembly and the decompiler from opaque output into something Sam
can read. It works on his own binaries and legal training material only.

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

## Can do it when

- Sam can name the parts of an ELF file and read them out of his own binary with `readelf` and `objdump`.
- Sam can disassemble a function he wrote and explain how its arguments arrive and its result returns.
- Sam can recover a function's logic in Ghidra and tell where the decompiler was exact and where it inferred.
- Sam can tell compiled Rust from compiled C in a disassembly and point to the evidence.
- Sam can reconcile a static read of a binary with a live gdb and `strace` run.

## Parked for later

- Exploiting what the analysis finds — sec-10 (binary exploitation) owns that.
- Analysing live malware samples — deferred to a dedicated air-gapped environment (`DEFERRED.md`); sec-17/sec-18 hold the defensive framing.
