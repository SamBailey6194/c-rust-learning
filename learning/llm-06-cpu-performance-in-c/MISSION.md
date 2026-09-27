# Mission — llm-06-cpu-performance-in-c

**Started**: not yet · **Family**: llm · **Phase**: L2 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam asked whether C and Rust "could improve memory reads for LLMs", and wants his model to use "CPU,
RAM, GPU, VRAM and cache" efficiently. The answer starts on the CPU: token-by-token generation reads
nearly every weight for each token, so speed comes from moving fewer bytes or moving them better —
cache-friendly layouts, SIMD, and knowing where the memory wall is. This topic teaches that in C on
this i9-9900K, with numbers he measures himself, and it also gives the whole repository its
measurement method, which the kernel, Syntek OS and security lessons cite.

## Can do it when

- Sam can measure a program with warm-up, repeats, median and spread, record it against a budget,
  and do so without `perf` counters when they are locked.
- Sam can state this machine's cache sizes and line size and show the latency steps in a pointer-chase
  sweep.
- Sam can find wasted cache lines with cachegrind and fix false sharing by layout, with the gain
  measured.
- Sam can confirm gcc vectorised a loop, write the AVX2/FMA version with intrinsics behind a runtime
  check, and explain why the results differ in the last bits.
- Sam can place kernels on this machine's measured roofline and explain why decoding is
  memory-bound.
- Sam can tile a matrix multiply for the cache and explain the gain from miss counts.

## Parked for later

- GPU memory spaces and the GPU roofline — llm-07; CUDA shared-memory tiling — llm-08.
- Reading ggml's quantised dot-product kernels and profiling llama.cpp — llm-15.
- The kernel's page cache and `mmap` from the inside — kernel-03.
