# Mission — llm-08-gpu-kernels-in-cuda

**Started**: not yet · **Family**: llm · **Phase**: L2 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

I want to build and train a language model in C, Rust and Python that uses the GPU and VRAM properly, and on this
RTX 2080 Ti that means knowing what a GPU kernel actually does with memory. I asked whether C and Rust could "improve
memory reads for LLMs"; CUDA kernels are C++ with a few GPU extensions, so writing a few myself — and measuring them
against cuBLAS — is how I learn to read llm.c's CUDA path and ggml's kernels instead of treating them as black boxes.

## Can do it when

- Choose and install a CUDA toolkit that driver 580 runs, and explain why device code is built with `-arch=sm_75`.
- Write, launch and check a kernel, with the grid sized to the data and the tail guarded, clean under Compute Sanitizer.
- Time GPU work with CUDA events and express it as effective bandwidth against the card's 616 GB/s.
- Predict whether global accesses coalesce, and fix a strided access with a shared-memory tile and a correct barrier.
- Write a tiled matrix multiply and place its measured throughput on this card's roofline.
- Write a reduction and a numerically stable softmax, and explain the online normaliser.
- Report a kernel's speed as a percentage of cuBLAS with its correctness checked within a stated tolerance.

## Parked for later

- Tensor cores and warp matrix functions (fp16 in, fp32 accumulate) — revisit with llm-15's quantised kernels.
- FlashAttention-style fused attention — llm-19 (the official kernels need sm_80 or later).
- Multi-GPU communication (NCCL) — llm-21.
- Nsight Compute counter analysis beyond one unlocked session — when Nsight is installed (`GAPS.md`).
