# Mission — llm-01-local-models-and-skills-baseline

**Started**: not yet · **Family**: llm · **Phase**: L1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam wants "a proper coding LLM, using skills not agents", built in C, Rust, Python and Markdown,
that uses "CPU, RAM, GPU, VRAM and cache" properly while being secure and works through Markdown
skills, workflows and doc guidance. Before training anything, he needs to know what an existing open
coding model already does on this machine, what it costs, and where hand-written skills are not
enough. This topic is the first LLM milestone suggested in the planning conversation (run an open
coding model with a handful of hand-written skills before any training) — to confirm: an open model
running locally, three skills of his own, a measured baseline that every later model must beat, and
a gap log that later becomes the skill-use training data. The conversation proposed driving the
model through llama.cpp from Rust; ollama stands in here because Rust arrives at P3, and llm-14 and
llm-16 take that route later.

## Can do it when

- Sam can estimate a quantised model's weight footprint from its parameter count and bits per weight
  and pick a model and quantisation that fit the ~9 GiB of free VRAM with headroom.
- Sam can record a model's provenance (source, sha256 blob digest, quantisation, licence) and show
  the ollama server listening on loopback only.
- Sam can measure load time, prompt and generation tokens/s, VRAM and RAM over repeated runs, and the
  baseline table in the milestone record holds medians and spreads.
- Sam can predict and measure how VRAM grows with context length and with the KV cache type.
- Sam can write a skill with progressive disclosure (metadata, body, references) within its token
  budgets, and justify its description line.
- Sam can run his skills against a fixed task set and keep a gap log whose every entry carries the
  model digest, settings and a failure category.

## Parked for later

- The KV-cache arithmetic in full, grouped-query attention and llama.cpp's offload flags — llm-15.
- Loading skills from Rust and replaying the gap log automatically — llm-16.
- Turning the gap log into skill-use training traces — llm-20.
- Running generated code, which needs sec-04's sandbox — llm-13 and llm-18.
