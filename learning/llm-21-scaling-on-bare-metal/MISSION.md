# Mission — llm-21-scaling-on-bare-metal

**Started**: not yet · **Family**: llm · **Phase**: L6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam wants to "build a base LLM" and train it on "bare-metal GPU servers", and asked early on "how
about building from scratch?". The route agreed in the planning conversation was to prove the whole
pipeline on this machine with the ~100M model first, and rent multi-GPU machines only for the ~1B
base once it works. This topic makes that rental worth its cost: estimate before spending, rehearse
data parallelism and sharding locally with several processes before paying for a node, keep secrets
and data safe on hardware Sam does not own, survive failures with checkpoints, and finish with a base
model released the way a stranger could trust it — the base the coding adapter (llm-20) and the
Syntek OS model service (os-17) build on.

## Can do it when

- Sam can estimate a run's FLOPs, GPU-hours and cost from its size, tokens and measured utilisation,
  and record the decision in a budget ADR.
- Sam can run his training loop under DDP and under FSDP on local processes, and explain the memory
  and communication difference.
- Sam can say what an interconnect changes for a sharded run.
- Sam can rent and release a machine with a checklist that leaves no secret or data behind.
- Sam can resume a sharded run from a distributed checkpoint on a different topology.
- Sam can publish a base model as safetensors with a model card, a licence, evaluations, digests and
  a signature.

## Parked for later

- Tensor and pipeline parallelism beyond reading — only if a later model needs them.
- Choosing a provider — the budget ADR, decided when the first L6 milestone that rents hardware is
  planned (`GAPS.md`).
- Serving the base with adapters — llm-20.
