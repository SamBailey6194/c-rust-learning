# Mission — llm-14-inference-in-rust

**Started**: not yet · **Family**: llm · **Phase**: L5 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

The plan from the conversation is Rust for inference and serving, and the first milestone it set out was to run an
open coding model "via llama.cpp from Rust" with a handful of my own skills. I want inference that uses CPU, RAM, GPU
and VRAM efficiently and securely, so I start from the bytes: read weights myself, never load a pickle, write the
forward pass and the KV cache by hand, then reach for candle and llama.cpp knowing what they do underneath.

## Can do it when

- Parse safetensors by hand over a memory map and reject malformed files without a panic.
- Explain why pickle checkpoints are never loaded and what `weights_only=True` does not fix.
- Run my model's forward pass in plain Rust and match PyTorch's logits within a tolerance.
- Add a KV cache that changes only speed, and compute its size from the model's configuration.
- Sample with temperature, top-k and top-p, reproducibly under a seed.
- Stream tokens from an async server with backpressure, limits and cooperative cancellation.
- Bring in candle through documented licence exceptions and compare it with my own forward pass.
- Run a GGUF model through llama.cpp from Rust and compare it with the ollama baseline from llm-01.

## Parked for later

- Quantisation, attention variants, paging and speculative decoding — llm-15.
- The skill loader on top of this engine — llm-16.
- Multi-tenant isolation and the full LLM threat model — llm-18.
- Packaging the server for Syntek OS — os-17.
