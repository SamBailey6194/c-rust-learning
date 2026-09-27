# ADR-MS001: LLM — one base model with LoRA adapters per domain

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-LLM-BASE-MODEL-PLUS-ADAPTERS |
| **Status** | Proposed |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources cited below) |
| **Enforced in** | `project-management/src/01-ROADMAP/ROADMAP.md` → L6 (once Accepted) |

---

## Context

In his planning conversation of 27/09/2026 (Q8), Sam described the model family he wants: a base
model first, then coding, legal, HR, finance and business versions, trained on rented bare-metal GPU
servers and run efficiently. The answer recommended one base with LoRA adapters per domain, swapped
per request; proving the pipeline at about 100M parameters locally before a base of about 1B on
rented GPUs; the coding adapter first; and, for legal, HR and finance, retrieval from current,
authoritative UK sources, with the model positioned as an assistant to professionals.

This record is **Proposed**: the shape is plausible on paper, but the numbers that would decide it
(adapter quality at this model size, the throughput cost of serving several adapters) do not exist
yet. It is recorded now so the L4 to L6 lessons build towards it deliberately.

Facts checked on 27/09/2026:

- **LoRA** freezes the pre-trained weights and trains small rank-decomposition matrices injected into
  each layer; on GPT-3 175B it cut trainable parameters by 10,000 times and GPU memory by 3 times,
  with quality on par with full fine-tuning in the paper's evaluations (Sources, item 1).
- **QLoRA** back-propagates through a frozen 4-bit quantised model into LoRA adapters, fine-tuning a
  65B model on a single 48 GB GPU (Sources, item 2).
- **Serving several adapters is supported.** vLLM serves LoRA adapters beside the base model with
  `--enable-lora`, and a request selects an adapter by name; how many run in parallel is bounded by
  settings such as `max_loras` (Sources, item 3).
- **Compute-optimal training** scales parameters and tokens together — for each doubling of model
  size, double the training tokens (Sources, item 4) — so a larger base costs more data as well as
  more compute.
- **Domain facts go stale.** Retrieval-augmented generation keeps facts in an external index that can
  be updated and cited (Sources, item 5); legal, HR and finance answers depend on current rules.
- **This machine's ceiling.** The RTX 2080 Ti has 11264 MiB, about 9.1 GiB free with the desktop
  running (`nvidia-smi`), which bounds the local base model and any local adapter training.

## Options considered

### Option A — One base, LoRA adapters per domain

- **Summary:** Pre-train one base; train a small adapter per domain; serve the base once and select
  the adapter per request.
- **Pros:** One expensive pre-training run. Adapters are small, so several fit beside one base, and
  each domain can be retrained alone. The same tokeniser serves every variant, which keeps the small
  model usable as a draft for speculative decoding.
- **Cons:** A domain far from the base's data may need more than an adapter. Requests with different
  adapters may not batch together, which costs throughput (to be measured).

### Option B — A fully fine-tuned model per domain

- **Summary:** Copy the base and fine-tune every weight per domain.
- **Pros:** The most capacity per domain.
- **Cons:** A full model's memory per domain, both to train and to serve — out of reach on this
  machine beyond the smallest sizes.

### Option C — One general model plus retrieval, no adapters

- **Summary:** A single model; domain knowledge only through retrieval.
- **Pros:** Nothing to train per domain; always current.
- **Cons:** Retrieval supplies facts, not domain style or procedure; the model may still answer
  poorly in the domain's form.

### Option D — Separate from-scratch models per domain

- **Summary:** Pre-train each domain model independently.
- **Pros:** Full control of each model's data.
- **Cons:** Multiplies the most expensive step by the number of domains.

## Decision

**Proposed: Option A — one base model with LoRA adapters per domain, the coding adapter first.**
The expected deciding factor is cost: one pre-training run and small per-domain adapters fit the
budget of a solo learner renting GPUs only for pre-training. Option C is the strongest alternative
for the domains where facts change fastest, and is likely to be combined with A there.

To move to `Accepted`: `llm-20-post-training-and-adapters` measures, on this machine, (1) whether a
coding adapter on the ~100M model improves the task suite over the base, and (2) the throughput cost
of serving two adapters against one. If either result is poor, Option C or a revised A is argued
instead.

## Consequences

- **Positive:** The L4 to L6 lessons build towards one pipeline; the tokeniser chosen in L4 is
  reused for the base, so the small model can serve as its draft.
- **Negative:** Nothing is committed yet; the plan may change when the numbers arrive.
- **Follow-on:**
  - To confirm — every element of this record came from the conversation's recommendation (Q8
    answer), not from a decision Sam made in the conversation.
  - `DEFERRED.md` parks the legal, HR, finance and business adapters (target L6), each only with
    retrieval from authoritative UK sources and as an assistant to professionals.
  - The ~1B base is budgeted by its own ADR before any GPU is rented; prices are checked on the day,
    never recorded here.

## Sources

1. **Hu et al., "LoRA: Low-Rank Adaptation of Large Language Models"** — arXiv:2106.09685,
   <https://arxiv.org/abs/2106.09685>, checked 27/09/2026
2. **Dettmers et al., "QLoRA: Efficient Finetuning of Quantized LLMs"** — arXiv:2305.14314,
   <https://arxiv.org/abs/2305.14314>, checked 27/09/2026
3. **vLLM documentation, LoRA adapters** — <https://docs.vllm.ai/en/latest/features/lora.html> —
   `--enable-lora`, per-request adapter selection and `max_loras`, checked 27/09/2026
4. **Hoffmann et al., "Training Compute-Optimal Large Language Models"** — arXiv:2203.15556,
   <https://arxiv.org/abs/2203.15556>, checked 27/09/2026
5. **Lewis et al., "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks"** —
   arXiv:2005.11401, <https://arxiv.org/abs/2005.11401>, checked 27/09/2026
6. **Host command, 27/09/2026** — `nvidia-smi --query-gpu=memory.total,memory.free --format=csv`
7. **Sam's planning conversation, 27/09/2026** — Q8 (the goal and the recommended shape)
