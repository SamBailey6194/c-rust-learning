# Mission — llm-04-transformer-maths

**Started**: not yet · **Family**: llm · **Phase**: L1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam's route to his own model runs through "Let's build GPT", then llm.c, then a ~100M code model
trained here. Every step assumes he can read a transformer: what each weight matrix does, what shape
every tensor has, how many parameters and FLOPs a configuration costs, and why the KV cache and the
attention matrix grow the way they do. His brief is a model that uses VRAM and cache efficiently;
those costs are written in this architecture's shapes, so he learns them by building it once, in
numpy, where nothing is hidden.

## Can do it when

- Sam can explain tokens, vocabulary and embeddings and count a configuration's embedding
  parameters.
- Sam can estimate forward and training FLOPs per token (`2N` and `6N`) and implement a softmax that
  cannot overflow.
- Sam's numpy causal attention head is blind to future tokens and matches PyTorch's
  `scaled_dot_product_attention`.
- Sam can write every tensor shape through multi-head attention from memory.
- Sam can assemble a pre-norm block and derive its `12 * d_model^2` parameter count.
- Sam's full numpy forward pass matches a PyTorch model's logits and loss given the same weights.

## Parked for later

- Training the model, mixed precision and sampling — llm-05.
- Tokenisers trained on code (BPE) — llm-11.
- The KV cache in inference and grouped-query attention — llm-15.
- FlashAttention and other efficient attention — llm-19.
