# Syllabus — llm-12-pretraining-a-small-code-model

**Track**: llm · **Phase**: L4 · **Path**: Core · **Detail**: full · **Prerequisites**: llm-07, llm-10, llm-11; llm-09 recommended
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This is the first own model: a ~100M-parameter fill-in-the-middle code model, trained from scratch on this machine's
RTX 2080 Ti with the corpus of llm-10 and the tokeniser of llm-11. The topic is as much about budgets as about
training — the compute a run needs, the VRAM it may use (about 9 GiB, since the card also drives the desktop), how to
survive a crash and a divergence, and how fast the pipeline really runs — so every lesson measures something. It proves
the pipeline before any money is spent on rented hardware (llm-21), and the model it produces is llm-13's subject and
the future speculative-decoding draft. Small calculators land under `code/src/python/` (planned — added at L1); the
training code, runs and checkpoints live in the model-training repository (created when this build starts), and no
checkpoint or dataset is committed anywhere.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Compute estimation: about 6·N·D, and which N | 1 sitting | yes — compute calculator | Efficiency |
| 02 | Choosing N and D under a VRAM cap and a GPU-hour budget | 1 sitting | yes — the run's resource budget | Efficiency |
| 03 | The fill-in-the-middle objective and data format | 1 sitting | yes — FIM transform | Security |
| 04 | Fitting in VRAM: micro-batches, accumulation, checkpointing, fp16 | 2–3 sittings | yes — memory probe | Efficiency |
| 05 | The run: logging, checkpoints and resume | 2–3 sittings | yes — kill-and-resume test | Efficiency, Security |
| 06 | Divergence and loss spikes | 1 sitting | yes — a diverging run, diagnosed | Efficiency |
| 07 | Throughput tuning | multi-session build | yes — the pretraining run | Efficiency |

---

## 01 — Compute estimation: about 6·N·D, and which N

- **Objective:** Sam can estimate a training run's FLOPs from parameters and tokens, say which parameter count he used,
  and turn FLOPs into GPU-hours from a measured throughput.
- **Builds on:** llm-03's matmul FLOP count; llm-07's roofline and peak figures; llm-10 lesson 01's token target.
- **Key ideas:**
  - Kaplan et al. count a forward pass at about 2N FLOPs per token plus a context term, and training at about 6N per
    token, with N the **non-embedding** parameters.
  - Chinchilla counts all FLOPs and all parameters, embeddings included; for a ~100M model the embedding table is a
    large share, so the two conventions give visibly different answers — say which one a number uses.
  - GPU-hours come from achieved FLOP/s, not the card's peak: the peak is 13.4 TFLOPS FP32 or 53.8 TFLOPS fp16 tensor
    with fp32 accumulation (whitepaper Table 1), and a real run reaches a fraction of it.
  - The estimate is checked against a short measured run before it is trusted.
- **Recall targets:** the 6N rule and where the 6 comes from; which N Kaplan uses and which Chinchilla uses; why the
  peak is the wrong divisor.
- **Build:** a compute calculator under `code/src/python/` (planned — added at L1): FLOPs for a configuration and token
  count under both conventions, and GPU-hours at a given achieved throughput; tests check Kaplan's formulas on a
  GPT-2-sized configuration.
- **Efficiency lens:** the estimate against a measured short run's tokens per second.
- **Sources:**
  - Kaplan et al., arXiv:2001.08361v1, Section 2.1 and Table 1
  - Hoffmann et al., arXiv:2203.15556v1, Section 3.4 and Appendix F (FLOPs computation)
  - NVIDIA Turing Architecture Whitepaper, Table 1:
    <https://images.nvidia.com/aem-dam/en-zz/Solutions/design-visualization/technologies/turing-architecture/NVIDIA-Turing-Architecture-Whitepaper.pdf>
- **Done when:** the calculator passes its tests, and Sam gives the FLOPs for his planned run under both conventions.

## 02 — Choosing N and D under a VRAM cap and a GPU-hour budget

- **Objective:** Sam can choose a model size and token count that fit both the free VRAM and the GPU-hours he is
  willing to spend, and write them down as the milestone's resource budget.
- **Builds on:** lesson 01; llm-07's VRAM budget formula; llm-10's token target and corpus size.
- **Key ideas:**
  - Two ceilings: VRAM caps N (weights, gradients, two AdamW moments, activations — llm-07), and time caps N·D.
  - The VRAM ceiling is what the desktop leaves free, read with `torch.cuda.memory.mem_get_info()`, not 11 GiB.
  - Chinchilla's ratio says how to split a compute budget between N and D; the corpus from llm-10 may cap D first.
  - The budget is a line in the milestone (`project-management/docs/planning/MILESTONES.md`, the Budget flag), checked
    at verification.
- **Recall targets:** which ceiling binds first on this machine and why; the terms of the VRAM formula; how the corpus
  size can override Chinchilla.
- **Build:** the run's resource budget — N, D, VRAM peak, GPU-hours — written into the milestone's project spec
  through `project-management/workflows/05-project-spec/`, with the lesson 01 calculator's output as evidence.
- **Efficiency lens:** VRAM peak ≤ the free VRAM measured that day, as `torch.cuda.memory.max_memory_allocated`.
- **Sources:**
  - arXiv:2203.15556v1, Section 3.4 and Table 3
  - PyTorch 2.14, `torch.cuda.memory.mem_get_info`:
    <https://docs.pytorch.org/docs/2.14/generated/torch.cuda.memory.mem_get_info.html>
  - PyTorch 2.14, CUDA semantics → Memory management: <https://docs.pytorch.org/docs/2.14/notes/cuda.html>
- **Done when:** the budget is in the project spec with its derivation, and Sam defends the choice of N unaided.

## 03 — The fill-in-the-middle objective and data format

- **Objective:** Sam can transform training documents into fill-in-the-middle examples and explain why this costs the
  model nothing in ordinary left-to-right ability.
- **Builds on:** llm-11 lesson 04's sentinel tokens; llm-05's training data batching.
- **Key ideas:**
  - With probability p (the FIM rate; 0.5 in the paper's main runs) a document is cut at two random character positions
    into prefix, middle and suffix, before tokenisation.
  - PSM order puts prefix, then suffix, then middle, each after its sentinel; SPM puts the suffix first, which keeps the
    suffix's cached keys and values valid as the prefix grows. The paper trains both, half each.
  - The loss covers all three parts and the end-of-text token; that is what keeps "FIM for free".
  - Document-level versus context-level FIM: whether the cut happens before or after documents are packed into
    contexts.
- **Recall targets:** the PSM and SPM layouts; why the split is by characters; why the loss covers every part.
- **Build:** a FIM transform under `code/src/python/` (planned) with tests: prefix, middle and suffix rejoin to the
  document, sentinels appear in the right order, the rate is respected over many samples, and a document containing a
  sentinel's literal text is handled as llm-11 lesson 04 decided.
- **Security lens:** the transform is where control tokens enter the data; it must add them only itself.
- **Sources:**
  - Bavarian et al., arXiv:2207.14255v1, Section 3 (document-level FIM), Section 3.1 (SPM) and Section 3.2
    (context-level FIM); Section 4.2 (FIM rate)
- **Done when:** the tests pass, and Sam explains PSM, SPM and "FIM for free" unaided.

## 04 — Fitting in VRAM: micro-batches, accumulation, checkpointing, fp16

- **Objective:** Sam can make a training step fit the VRAM budget with the four levers — micro-batch size, gradient
  accumulation, activation checkpointing and fp16 — and measure what each saves and costs.
- **Builds on:** llm-05 (fp16 autocast and `torch.amp.GradScaler` on Turing); llm-07 (the VRAM formula and memory
  stats); lesson 02.
- **Key ideas:**
  - A smaller micro-batch cuts activation memory; gradient accumulation keeps the effective batch by summing gradients
    over several micro-batches before one optimiser step.
  - Activation checkpointing stores fewer activations and recomputes them in backward — memory for compute
    (Chen et al.: sublinear memory for a chain of layers).
  - Turing has fp16 tensor cores and no native bf16, so mixed precision here is fp16 autocast with a gradient scaler;
    master weights and optimiser state stay fp32.
  - `nvidia-smi` shows memory the caching allocator reserved; `max_memory_allocated` shows what tensors used — measure
    with the latter, check against the former.
- **Recall targets:** what each lever saves and what it costs; why accumulation does not change the maths of the
  update; the two memory numbers and which one the budget uses.
- **Build:** a memory probe in the model-training repository (created when this build starts) that runs a few steps of
  the model at several micro-batch sizes, with and without checkpointing, and records peak allocated memory and step
  time.
- **Efficiency lens:** peak VRAM (`torch.cuda.memory.max_memory_allocated`) and step time for each configuration,
  against the lesson 02 budget.
- **Sources:**
  - PyTorch 2.14, Automatic Mixed Precision package: <https://docs.pytorch.org/docs/2.14/amp.html>
  - PyTorch 2.14, AMP examples, "Gradient accumulation": <https://docs.pytorch.org/docs/2.14/notes/amp_examples.html>
  - PyTorch 2.14, `torch.utils.checkpoint`: <https://docs.pytorch.org/docs/2.14/checkpoint.html>
  - Chen et al., "Training Deep Nets with Sublinear Memory Cost", arXiv:1604.06174v2
  - PyTorch 2.14, `torch.cuda.memory.max_memory_allocated`:
    <https://docs.pytorch.org/docs/2.14/generated/torch.cuda.memory.max_memory_allocated.html>
  - nanochat at 92d63d4, README "Precision / dtype" (fp16 with a GradScaler on cards below SM 80):
    <https://github.com/karpathy/nanochat/tree/92d63d4e8bb4df75c3b71618f31ddde2378b2bcd>
- **Done when:** the probe's table is in the journal, a configuration within budget is chosen, and Sam explains each
  lever's trade-off.

## 05 — The run: logging, checkpoints and resume

- **Objective:** Sam can checkpoint a training run so that killing it and resuming continues the same run, and load
  only checkpoints this machine produced, safely.
- **Builds on:** lesson 04; llm-05's safetensors checkpoints.
- **Key ideas:**
  - A resumable checkpoint holds more than weights: optimiser state, the gradient scaler's state, the learning-rate
    schedule's position, random-number state and the position in the data.
  - Log what explains a run later: loss, learning rate, gradient norm, the scaler's scale, tokens per second.
  - `torch.load` unpickles; since PyTorch 2.6 it defaults to `weights_only=True`, which narrows but does not remove the
    risk (the documentation says it does not guard against denial of service). The repository rule: resume only from a
    checkpoint this machine produced, loaded with `weights_only=True`.
  - Released weights go out as safetensors, never as a pickle.
- **Recall targets:** everything a resumable checkpoint needs; what `weights_only=True` protects against and what not;
  the format for released weights.
- **Build:** a kill-and-resume test in the model-training repository: stop a short run mid-way, resume from the
  checkpoint, and show the loss curve continues as an uninterrupted run's does.
- **Efficiency lens:** checkpoint size on disk and time to save, against the disk budget from llm-10.
- **Security lens:** the pickle rule (`.claude/CLAUDE.md` Section 5): no checkpoint from anywhere else is ever loaded
  with `torch.load`.
- **Sources:**
  - PyTorch 2.14, Serialization semantics → "torch.load with weights_only=True" and "weights_only security":
    <https://docs.pytorch.org/docs/2.14/notes/serialization.html>
  - PyTorch tutorial, "Saving & Loading a General Checkpoint for Inference and/or Resuming Training":
    <https://docs.pytorch.org/tutorials/beginner/saving_loading_models.html>
  - PyTorch v2.14.0 source, `torch/amp/grad_scaler.py` (`state_dict`, `load_state_dict`):
    <https://github.com/pytorch/pytorch/blob/v2.14.0/torch/amp/grad_scaler.py>
  - safetensors at e246a25, README "Format": <https://github.com/safetensors/safetensors/tree/e246a2560645b7525f5775669ed816eb57c5bcc8>
- **Done when:** the resumed run's loss matches the uninterrupted run's within noise, and Sam lists the checkpoint's
  contents unaided.

## 06 — Divergence and loss spikes

- **Objective:** Sam can recognise a diverging run from its logs, name the likely causes, and apply the standard
  defences.
- **Builds on:** lesson 05's logging; llm-03's optimisers lesson (warm-up, cosine decay, clipping); llm-03's
  floating-point lesson (fp16 range).
- **Key ideas:**
  - Symptoms: loss spikes, NaN loss, a gradient norm that climbs, a gradient scaler that keeps backing off.
  - The scaler skips an optimiser step when it finds inf or NaN gradients and lowers its scale; a run of skips is a
    signal, not a fix.
  - Gradients are unscaled before clipping, or the clipping threshold means nothing.
  - Defences: learning-rate warm-up and a lower peak rate, gradient clipping, and restarting from the last good
    checkpoint.
- **Recall targets:** the symptoms in the logs; what the scaler does on overflow; why unscale before clipping.
- **Build:** in the model-training repository, a short run with a deliberately too-high learning rate that diverges,
  and the same run recovered; the logs of both in the journal.
- **Efficiency lens:** steps lost to skips and restarts, counted from the logs.
- **Sources:**
  - PyTorch 2.14, AMP examples, "Typical Mixed Precision Training" and "Working with Unscaled Gradients"
    (URL as lesson 04)
  - PyTorch 2.14, `torch.nn.utils.clip_grad_norm_`:
    <https://docs.pytorch.org/docs/2.14/generated/torch.nn.utils.clip_grad_norm_.html>
  - Micikevicius et al., arXiv:1710.03740v3, Section 3.2
- **Done when:** both runs' logs are in the journal, and Sam diagnoses the divergence from them unaided.

## 07 — Throughput tuning

- **Objective:** Sam can find the bottleneck in his training step and raise tokens per second without breaking the
  VRAM budget — then run the pretraining.
- **Builds on:** lessons 01–06; llm-06 lesson 01 (measuring honestly); llm-07 (`torch.profiler`).
- **Key ideas:**
  - First find where time goes: data loading, host-to-device copies or GPU compute — `torch.profiler` needs no
    privilege; Nsight needs unlocked counters (`GAPS.md`).
  - Loader workers overlap data preparation with compute; copies from pinned (page-locked) host memory are much faster.
  - `torch.compile` fuses kernels: PyTorch 2.14's Inductor admits compute capability 7.0 and above, but Triton's own
    README lists 8.0 and above as supported — so on this card it is an experiment, measured and dropped if it fails.
  - Report achieved FLOP/s as a fraction of peak (llm.c reports this as MFU) alongside tokens per second.
- **Recall targets:** the three places time can go and how each is seen; what pinned memory buys; why `torch.compile`
  is an experiment here.
- **Build:** the pretraining run itself, in the model-training repository, after an A/B table of each tuning change;
  the final weights exported to safetensors outside every repository.
- **Efficiency lens:** tokens per second and achieved fraction of peak before and after each change; VRAM peak within
  budget throughout.
- **Sources:**
  - PyTorch 2.14, `torch.profiler`: <https://docs.pytorch.org/docs/2.14/profiler.html>
  - PyTorch 2.14, `torch.utils.data` → memory pinning: <https://docs.pytorch.org/docs/2.14/data.html>
  - PyTorch 2.14, `torch.compile`: <https://docs.pytorch.org/docs/2.14/generated/torch.compile.html>
  - PyTorch v2.14.0 source, `torch/_dynamo/device_interface.py` (`is_triton_capable`):
    <https://github.com/pytorch/pytorch/blob/v2.14.0/torch/_dynamo/device_interface.py>
  - Triton v3.8.0 README, "Compatibility": <https://github.com/triton-lang/triton/blob/v3.8.0/README.md>
- **Done when:** the A/B table and the final run's loss curve are in the journal, and the run stayed within its
  budget.
