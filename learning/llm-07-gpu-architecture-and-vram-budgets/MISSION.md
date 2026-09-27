# Mission — llm-07-gpu-architecture-and-vram-budgets

**Started**: not yet · **Family**: llm · **Phase**: L2 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

The 2080 Ti's 11 GiB (11264 MiB) of VRAM is the hard ceiling on everything Sam trains or runs locally, and his
brief is a model that uses "GPU, VRAM and cache" efficiently. That starts with knowing the card — how
it runs work, what it can reach at best, what its tensor cores can and cannot do — and with never
being surprised by an out-of-memory error: every byte of a training or inference run should be
predictable from the model's shape and then confirmed by measurement. This topic makes VRAM a budget
he states and checks, which every later LLM milestone requires.

## Can do it when

- Sam can explain grids, blocks, warps and SMs, and place each memory space on or off the chip.
- Sam can quote this card's key numbers, compute its ridge points, and say why it trains in fp16
  rather than bf16 or TF32.
- Sam can measure achieved matmul throughput and bandwidth and state each as a fraction of peak.
- Sam can predict peak VRAM for training (weights, gradients, optimiser state, activations) and for
  inference (weights and KV cache) from a model's configuration.
- Sam can measure the llm-05 model's VRAM by component with `torch.cuda` statistics, reconcile it
  with `nvidia-smi`, and explain the residual against his prediction.
- Sam can profile a training step with `torch.profiler`, and explain the GPU counter lock and how he
  would lift and restore it for one session.

## Parked for later

- Writing CUDA kernels, coalescing and shared-memory tiling — llm-08 (blocked until the CUDA
  toolkit is installed).
- Fitting a larger model with gradient accumulation and activation checkpointing — llm-12.
- KV-cache arithmetic for grouped-query attention and paged caches in serving — llm-15.
