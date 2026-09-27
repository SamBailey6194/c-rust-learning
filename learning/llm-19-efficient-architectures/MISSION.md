# Mission — llm-19-efficient-architectures

**Started**: not yet · **Family**: llm · **Phase**: L6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam wants to "build a base LLM" and to use "CPU, RAM, GPU, VRAM, caching" efficiently while doing it.
The planning conversation named the tools for that at design time rather than after the fact: Mixture
of Experts so only part of the model works per token, grouped-query or latent attention to shrink the
KV cache, quantisation-aware training, and experts kept in system RAM with the active ones on the GPU.
This topic studies each of those, measures what this RTX 2080 Ti can actually run (it predates the
GPUs FlashAttention's kernels need), and ends in the architecture decision for the ~1B base that
llm-21 trains on rented machines — so the money spent there buys a design that was argued, not
copied.

## Can do it when

- Sam can compute the KV cost of one design as MHA, GQA, MQA and MLA, and explain what each trades.
- Sam can explain FlashAttention's tiling and measure the attention backends this card can use.
- Sam can compute active and total parameters for an MoE layout and say where its experts should live.
- Sam can compare quantisation-aware training with post-training quantisation on one checkpoint.
- Sam can write the base-architecture ADR with training FLOPs, token budget, inference VRAM and KV
  per token for each option.

## Parked for later

- Training the chosen base at scale — llm-21.
- Adapters on the base — llm-20.
- Writing attention kernels in CUDA — llm-08 covers the basics; a Turing FlashAttention of Sam's own
  would be a new topic.
