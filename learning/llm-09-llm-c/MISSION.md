# Mission — llm-09-llm-c

**Started**: not yet · **Family**: llm · **Phase**: L3 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

I asked whether I could "build an LLM in C + Rust + Python + Markdown". llm.c is the proof that the C part is real: a
GPT-2 trainer with nothing between the code and the memory. Reading it — forward, backward, AdamW and its memory layout
— turns the framework calls I will use for training into code I understand, and running its CUDA path on my 2080 Ti
shows me exactly what an 11 GiB (11264 MiB) Turing card can and cannot do.

## Can do it when

- Fetch llm.c at a pinned commit outside the repository and pass its CPU test against the PyTorch reference.
- Trace the GPT-2 forward pass through the C source and map each function to its numpy counterpart.
- Predict llm.c's memory for parameters, gradients, optimiser state and activations, and check it against a
  measurement.
- Write a layer's backward pass in C and prove it with a finite-difference gradient check.
- Write an AdamW step in C that matches PyTorch within tolerance.
- Run llm.c's CPU code under ASan with UBSan and under valgrind, and explain every report.
- Run the fp32 GPU trainer on the 2080 Ti and explain why bf16 and fp16 do not work there as the code stands.

## Parked for later

- Multi-GPU and multi-node training in llm.c (MPI, NCCL) — llm-21.
- cuDNN FlashAttention — not supported on this card in fp32; attention efficiency is llm-19.
- Reproducing GPT-2 124M from scratch on llm.c — llm-12 trains Sam's own model instead.
