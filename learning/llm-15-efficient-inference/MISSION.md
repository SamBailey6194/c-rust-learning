# Mission — llm-15-efficient-inference

**Started**: not yet · **Family**: llm · **Phase**: L5 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam's first question about language models was whether C and Rust could "improve memory reads for
LLMs", and his brief for the model he builds is that it uses "CPU, RAM, GPU, VRAM, caching"
efficiently. This topic is where that brief is measured rather than hoped for. On this machine the
RTX 2080 Ti's 11 GiB is shared with the desktop, so every byte of weights and KV cache has to earn
its place; generation is limited by how fast bytes move, so the wins come from moving fewer of them
(quantisation, grouped-query attention, a smaller KV cache) or moving them better (the page cache,
paging, prefix reuse, offload splits, batching, speculative decoding). Each lesson ends in a number
recorded against llm-01's baseline, and together they make the budget that the skills layer (llm-16),
the secure server (llm-18) and the Syntek OS model service (os-17) live inside.

## Can do it when

- Sam can predict an upper bound on decode tokens/s from bytes per token and memory bandwidth, and
  explain the measured gap.
- Sam can quantise a block of weights, state its bits per weight and error, and choose a GGUF quant
  from measured size, speed and KL divergence.
- Sam can explain mmap loading and the page cache, and measure cold and warm loads and residency.
- Sam can compute a model's KV-cache bytes per token from its metadata, including GQA, and match it
  to measured VRAM.
- Sam can explain paged KV memory and prefix caching, and measure what prefix reuse saves.
- Sam can choose a CPU/GPU split and a KV-cache type for a model larger than the free VRAM, from a
  measured sweep.
- Sam can explain why speculative decoding keeps the target's distribution and measure when it pays.
- Sam can read ggml's AVX2 dot-product kernel and place a profile of it on this CPU's roofline.
- Sam can choose a batch size from a measured throughput-against-latency sweep.
- The block-quant and page-cache exercises pass `make test`, `make san` and `make memcheck`; the
  kv-budget and paged-KV crates pass `cargo test` and `cargo clippy`.

## Parked for later

- Latent attention (MLA), FlashAttention and Mixture-of-Experts design — llm-19.
- Quantisation-aware training — llm-19.
- Multi-adapter serving and its batching cost — llm-20.
- Rate limits, tenant isolation and the prefix-cache side channel as security controls — llm-18.
- Writing GPU kernels of its own — llm-08.
- Running the model as a supervised Syntek OS service — os-17.
