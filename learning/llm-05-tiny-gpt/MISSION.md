# Mission — llm-05-tiny-gpt

**Started**: not yet · **Family**: llm · **Phase**: L1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam wants to know whether he could build an LLM himself, and the honest first answer is a small one
trained on his own GPU. His route is "Let's build GPT", then llm.c, then a ~100M code model; this is
the first rung: a character-level GPT he writes and trains on this RTX 2080 Ti, with a VRAM budget
stated before the run and measured during it, because using GPU and VRAM efficiently is half of his
brief. It is also where he learns why this card trains in fp16 with a gradient scaler rather than in
bf16, and how to keep weights safe to load.

## Can do it when

- Sam can build a character dataset from a text he may use, with a clean validation split and
  shifted targets.
- Sam's PyTorch GPT matches his numpy forward pass and overfits a single batch.
- Sam can train on CPU and GPU and report tokens/s and peak VRAM against a budget stated beforehand.
- Sam can train with fp16 autocast and `torch.amp.GradScaler("cuda")`, place `unscale_` before
  clipping, and explain why this card does not use bf16.
- Sam can sample with temperature, top-k and top-p and predict each one's effect.
- Sam can pick the best checkpoint from the validation curve, save weights as safetensors, and resume
  a run safely from a checkpoint this machine wrote.

## Parked for later

- Accounting for every byte of VRAM, and profiling — llm-07.
- A trained tokeniser and a code dataset — llm-10 and llm-11.
- Fitting a ~100M model (gradient accumulation, activation checkpointing) — llm-12.
- Loading the weights from Rust — llm-14.
