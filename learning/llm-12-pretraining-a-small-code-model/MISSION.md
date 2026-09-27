# Mission — llm-12-pretraining-a-small-code-model

**Started**: not yet · **Family**: llm · **Phase**: L4 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

The plan from the conversation was to "prove the pipeline at ~100M locally" before renting any hardware: a
fill-in-the-middle code-completion model of my own, trained from scratch on my 2080 Ti. I want it to use the GPU and
VRAM efficiently, so every run has a budget — compute, VRAM, hours — and is measured against it. This model is also the
one that can later draft for a bigger base model, so it is not a throwaway.

## Can do it when

- Estimate a run's FLOPs as about 6·N·D, stating which N, and convert them to GPU-hours from a measured throughput.
- Choose N and D that fit the free VRAM and a GPU-hour budget, and record them as the milestone's resource budget.
- Transform documents into PSM and SPM fill-in-the-middle examples, and explain "FIM for free".
- Fit a training step in the VRAM budget with micro-batches, accumulation, checkpointing and fp16, each measured.
- Checkpoint and resume a run exactly, loading only checkpoints this machine produced with `weights_only=True`.
- Diagnose a diverging run from its logs and recover it.
- Tune throughput from a profile, then complete the pretraining run within budget.

## Parked for later

- Evaluating the model — llm-13.
- Efficient architectures (GQA, MLA, MoE) for the next model — llm-19.
- Distributed training (DDP, FSDP) and rented hardware — llm-21.
- Instruction tuning and adapters — llm-20.
