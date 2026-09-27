# Syllabus — llm-19-efficient-architectures

**Track**: llm · **Phase**: L6 · **Path**: Later · **Detail**: outline · **Prerequisites**: llm-15 (especially lesson 05, KV-cache arithmetic, and lesson 08, offload splits); llm-12 (training the ~100M model); llm-07 (VRAM budgets)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Sam's plan for the ~1B base named efficiency by design: attention that shrinks the KV cache, Mixture
of Experts so only part of the model works per token, quantisation-aware training, and an
architecture chosen under a real VRAM and compute budget rather than copied. This topic studies those
choices and measures what can be measured on this machine's RTX 2080 Ti, then ends in the
architecture decision that llm-21 trains. It is an **outline**: L6 is a far phase, so the lessons
below carry objectives, key ideas and sources checked on 27/09/2026, and their builds are sketched;
details — especially GPU-kernel support, which moves fast — are re-verified and filled in when L6
opens. **Where the work lands:** small arithmetic tools extend llm-15's lesson crates under
`code/src/rust/crates/`; PyTorch measurements go under `code/src/python/` (planned — added at L1);
training experiments on Sam's own models land in the model-training repository (created when this build starts);
the decision is an ADR in `project-management/src/08-DECISIONS/`.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Multi-query attention revisited: the limit of GQA | 1 sitting | yes — MQA rows | Efficiency |
| 02 | Multi-head latent attention: compressing the KV cache | 2–3 sittings | yes — MLA rows | Efficiency |
| 03 | FlashAttention, and what Turing can run | 2–3 sittings | yes — SDPA backends | Efficiency |
| 04 | Mixture of Experts: routing, and active against total parameters | 2–3 sittings | yes — toy MoE layer | Efficiency |
| 05 | Quantisation-aware training | 2–3 sittings | yes — QAT run | Efficiency |
| 06 | Choosing an architecture under a VRAM and compute budget | 2–3 sittings | yes — architecture ADR | Efficiency, Security |

---

## 01 — Multi-query attention revisited: the limit of GQA

- **Objective:** Sam can place MQA at the end of the MHA-to-GQA line, compute its KV saving for a
  candidate ~1B design, and state what it costs in quality and how GQA recovers most of it.
- **Builds on:** llm-15 lesson 05 (the KV formula and GQA, measured).
- **Key ideas:**
  - MQA shares one key and value head across all query heads, cutting the KV cache and the memory
    bandwidth of incremental decoding (arXiv:1911.02150).
  - GQA's authors report MQA can degrade quality, and that uptraining an existing multi-head
    checkpoint to GQA with about 5% of the original pre-training compute gets close to multi-head
    quality at close to MQA speed (arXiv:2305.13245).
  - For a model trained from scratch, the KV-head count is a design parameter, set against the
    context length and batch the budget has to serve.
- **Recall targets:** compute the KV bytes per token of one design as MHA, GQA and MQA; say when MQA's
  saving is worth its risk.
- **Build:** outline — `MQA rows`: extend llm-15's kv-budget crate (planned path
  `code/src/rust/crates/msNNN_kv_budget/`) to print a design's KV cost under each head layout.
- **Efficiency lens:** KV bytes per token and the context that fits in ~9 GiB beside the weights.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) Shazeer, arXiv:1911.02150; Ainslie et
  al., arXiv:2305.13245 (abstract and Section 2).
- **Done when:** Sam's table shows the three layouts for his candidate design, with a reasoned choice.

## 02 — Multi-head latent attention: compressing the KV cache

- **Objective:** Sam can explain how MLA caches a compressed latent vector instead of full keys and
  values, why positional encoding needs special handling there, and compare its cache with GQA's for
  the same model size.
- **Builds on:** lesson 01; llm-04 (attention with shapes, rotary positions if taught there).
- **Key ideas:**
  - MLA jointly compresses keys and values into a low-rank latent that is cached, and reconstructs
    per-head keys and values from it (arXiv:2405.04434, Section 2.1.2).
  - Rotary position embedding does not commute with that compression, so DeepSeek-V2 carries a small
    separate, "decoupled" rotary part (Section 2.1.3).
  - DeepSeek-V2 reports a 93.3% smaller KV cache than its predecessor DeepSeek 67B; the lesson
    recomputes the saving for Sam's own dimensions rather than quoting it.
  - Less cache is not free: the up-projections add compute per token, which the roofline of
    llm-15 lesson 01 prices.
- **Recall targets:** say what MLA caches per token and per layer; explain the decoupled rotary part
  in one sentence.
- **Build:** outline — `MLA rows`: add the latent-cache formula to the same crate and compare with the
  GQA rows for one design.
- **Efficiency lens:** KV bytes per token against extra FLOPs per token.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) DeepSeek-AI, "DeepSeek-V2",
  arXiv:2405.04434, abstract and Sections 2.1.2–2.1.3.
- **Done when:** Sam's comparison for one design states the cache saving and the compute it costs.

## 03 — FlashAttention, and what Turing can run

- **Objective:** Sam can explain FlashAttention's IO-aware tiling, say which attention kernels this
  RTX 2080 Ti can actually use from PyTorch, and measure memory and time for the ones it can.
- **Builds on:** llm-07 (memory spaces, SMs, the VRAM budget); llm-15 lesson 01 (memory-bound work).
- **Key ideas:**
  - Standard attention writes the full score matrix to GPU memory; FlashAttention tiles the
    computation so the scores live in on-chip SRAM and never reach HBM, cutting memory traffic and
    memory use while staying exact (arXiv:2205.14135; FlashAttention-2, arXiv:2307.08691).
  - The official FlashAttention package targets Ampere, Ada and Hopper; its README points Turing users
    to a separate flash-attention-turing repository, which on 27/09/2026 carried no licence file — so
    it stays reading-only unless that changes.
  - In PyTorch 2.14, `scaled_dot_product_attention` picks a backend per call: the flash backend checks
    for sm80–sm121 and the cuDNN backend for sm80 or newer, while the memory-efficient backend
    accepts sm50–sm121 — so on this sm75 card the memory-efficient or the math backend runs.
  - `torch.nn.attention.sdpa_kernel` forces a backend, which makes the comparison measurable.
- **Recall targets:** explain why tiling cuts memory traffic; name the backends this card can use and
  the check that rules the others out.
- **Build:** outline — `SDPA backends`: a PyTorch script under `code/src/python/` (planned — added at
  L1) that times the math and memory-efficient backends over growing sequence lengths and records peak
  memory with `torch.cuda.max_memory_allocated`.
- **Efficiency lens:** time and peak VRAM per backend and sequence length, measured with
  `torch.profiler` (no GPU counters needed).
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) Dao et al., arXiv:2205.14135; Dao,
  arXiv:2307.08691; PyTorch 2.14 `scaled_dot_product_attention`,
  <https://docs.pytorch.org/docs/2.14/generated/torch.nn.functional.scaled_dot_product_attention.html>,
  and `sdpa_kernel`, <https://docs.pytorch.org/docs/2.14/generated/torch.nn.attention.sdpa_kernel.html>;
  PyTorch v2.14.0 source `aten/src/ATen/native/transformers/cuda/sdp_utils.cpp` (the SM-range
  checks), <https://github.com/pytorch/pytorch/blob/v2.14.0/aten/src/ATen/native/transformers/cuda/sdp_utils.cpp>;
  FlashAttention README, <https://github.com/Dao-AILab/flash-attention> (BSD-3-Clause);
  <https://github.com/ssiu/flash-attention-turing> (no licence file, 27/09/2026).
- **Done when:** the record shows both usable backends' time and memory curves, and Sam explains why
  the flash backend is absent.

## 04 — Mixture of Experts: routing, and active against total parameters

- **Objective:** Sam can explain how a router sends each token to a few experts, why memory scales with
  total parameters but compute with active ones, and where experts should live on this machine.
- **Builds on:** llm-15 lesson 08 (experts in RAM with `--n-cpu-moe`); llm-04 (the MLP block).
- **Key ideas:**
  - A sparsely-gated MoE layer replaces one feed-forward block with many experts and a gate that picks
    a few per token (arXiv:1701.06538); Switch Transformers route each token to one expert
    (arXiv:2101.03961).
  - Mixtral 8x7B routes each token to two of eight experts per layer: 47B parameters present, 13B
    active per token (arXiv:2401.04088); DeepSeek-V2 reports 236B total and 21B active
    (arXiv:2405.04434).
  - Routers need balancing — without it a few experts take all the tokens — and that is a training
    concern, not an inference one.
  - All experts must be stored somewhere: VRAM for the busy ones, RAM for the rest, which llm-15's
    offload lesson measured.
- **Recall targets:** compute active and total parameters for a stated MoE layout; explain why an MoE
  model can be fast yet not fit.
- **Build:** outline — `toy MoE layer`: a small PyTorch MoE block under `code/src/python/` (planned)
  with router statistics per expert, trained briefly on the tiny-GPT data from llm-05 to show
  imbalance appearing and a balancing loss correcting it.
- **Efficiency lens:** parameters stored against parameters used per token; VRAM for all experts
  against a RAM split.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) Shazeer et al., arXiv:1701.06538; Fedus
  et al., arXiv:2101.03961; Jiang et al., arXiv:2401.04088; arXiv:2405.04434.
- **Done when:** Sam's note computes active and total parameters for his candidate layouts, and the
  toy run shows the router's balance before and after.

## 05 — Quantisation-aware training

- **Objective:** Sam can explain how fake quantisation during training lets a model learn around
  low-bit rounding, and when that beats quantising after training.
- **Builds on:** llm-15 lessons 02–03 (block quantisation, k-quants, KL divergence); llm-12 (the
  training loop).
- **Key ideas:**
  - Post-training quantisation rounds a finished model; quantisation-aware training simulates the
    rounding in the forward pass while training, so the weights adapt to it (arXiv:1712.05877).
  - For LLMs, post-training methods hold up to about 8 bits and break down lower, which is where QAT
    earns its cost; LLM-QAT uses data generated by the model itself and also quantises the KV cache
    (arXiv:2305.17888).
  - torchao's QAT flow is two steps: prepare (insert fake-quantise operations) and convert (replace
    them with real quantisation after training).
  - The comparison that matters is measured: the same model quantised after training, and with QAT,
    judged by KL divergence (llm-15 lesson 03) and size.
- **Recall targets:** explain what a fake-quantise operation does in the forward and backward pass;
  say when QAT is worth its training cost.
- **Build:** outline — `QAT run`: in the model-training repository, fine-tune the ~100M model from llm-12 with
  torchao's QAT flow to 4-bit weights and compare it with post-training quantisation of the same
  checkpoint.
- **Efficiency lens:** training-time and VRAM overhead of QAT against the accuracy it buys at the same
  size.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) Jacob et al., arXiv:1712.05877; Liu et
  al. (LLM-QAT), arXiv:2305.17888; torchao 0.17 "Quantization-Aware Training (QAT)",
  <https://docs.pytorch.org/ao/stable/workflows/qat.html>.
- **Done when:** the record compares QAT and post-training quantisation of one checkpoint at one size.

## 06 — Choosing an architecture under a VRAM and compute budget

- **Objective:** Sam can choose the ~1B base's shape — depth, width, attention layout, dense or MoE,
  quantisation plan, token budget — from arithmetic and measurements, and record it as an ADR that
  llm-21 trains.
- **Builds on:** lessons 01–05; llm-11 (the shared tokeniser decision); llm-12 (compute estimation).
- **Key ideas:**
  - Compute-optimal training sets tokens against parameters: Chinchilla's Table 3 estimates about
    20.2 billion tokens for a 1-billion-parameter model (arXiv:2203.15556).
  - Training compute is about `6 * N * D` FLOPs with `N` the non-embedding parameters
    (arXiv:2001.08361) — state which `N` is used.
  - Inference cost is a separate budget: weights at the chosen quant, KV per token at the target
    context, and whether it still fits beside the desktop on this card and on the server edition.
  - The tokeniser is fixed by llm-11, so the ~100M model can draft for the ~1B base (llm-15
    lesson 09).
  - Any design that loads third-party code or weights for evaluation inherits llm-18's supply-chain
    rules.
- **Recall targets:** derive the token budget and FLOPs for a stated size; name the three numbers the
  ADR must fix and the measurement behind each.
- **Build:** outline — `architecture ADR`: an ADR in `project-management/src/08-DECISIONS/` choosing
  the base architecture, with options argued and the arithmetic and measurements from lessons 01–05
  as evidence.
- **Efficiency lens:** training FLOPs, inference VRAM and KV per token for each option, in one table.
- **Security lens:** the ADR's threat model names where the weights and data come from and how they
  are verified (llm-18 lesson 05).
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) Hoffmann et al., arXiv:2203.15556,
  Table 3; Kaplan et al., arXiv:2001.08361, Sections 1.3 and 2.1; `project-management/workflows/08-decisions/`.
- **Done when:** the ADR is written with options, numbers and a decision Sam can defend.
