# Syllabus — llm-20-post-training-and-adapters

**Track**: llm · **Phase**: L6 · **Path**: Later · **Detail**: outline · **Prerequisites**: llm-13 (evaluation and the sandboxed test runner); llm-16 (skill-use traces, lesson 07); llm-17 (retrieval, for any domain variant); llm-12 (the ~100M model); sec-04 lesson 07 (the sandbox launcher)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Sam's plan is one base model with versions for coding first and then other domains, made as adapters
rather than separate models, and trained to use skills: recognise the right one, load it, follow it.
This topic is the post-training that does that — supervised fine-tuning on chat-formatted skill-use
traces, LoRA and QLoRA sized for this RTX 2080 Ti, a small experiment in rewarding code that passes
its tests in the sandbox, evaluation of every adapter against its base, and serving several adapters
from one model. It also carries the two measurements that
`project-management/src/08-DECISIONS/ADR-MS001-LLM-BASE-MODEL-PLUS-ADAPTERS-27-09-2026.md` (Proposed)
needs before it can be accepted: whether a coding adapter on the ~100M model beats its base on the
task suite, and what serving two adapters costs against one. It is an **outline**: L6 is a far phase,
so objectives, key ideas and sources are checked on 27/09/2026 and the builds are sketched; library
versions and GPU support are re-verified when L6 opens. **Where the work lands:** training code,
traces, adapters and results in the model-training repository (created when this build starts); measurements in
the verification record under `project-management/src/10-PROGRESS/`. Adapter weights and datasets are
never committed here.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Supervised fine-tuning data and chat templates | 1 sitting | yes — template check | Security |
| 02 | Skill-use traces as training data | 2–3 sittings | yes — SFT set | Security |
| 03 | LoRA: training a low-rank adapter | 2–3 sittings | yes — first adapter | Efficiency |
| 04 | QLoRA on Turing | 2–3 sittings | yes — QLoRA run | Efficiency |
| 05 | Rewarding code that passes its tests | multi-session build | yes — rejection-sampling round | Security, Safety |
| 06 | Evaluating skill-following and each adapter | 2–3 sittings | yes — adapter scorecard | Efficiency |
| 07 | Serving several adapters, and what it costs | 2–3 sittings | yes — adapter serving sweep | Efficiency, Security |
| 08 | Domain variants: coding first, the rest only with retrieval | 1 sitting | no | Security |

---

## 01 — Supervised fine-tuning data and chat templates

- **Objective:** Sam can explain how a conversation becomes the exact token sequence a model is
  trained on, and check that training and serving use the same template.
- **Builds on:** llm-11 (the tokeniser and its special tokens); llm-16 lesson 07 (the trace format).
- **Key ideas:**
  - A chat template turns a list of role-and-content messages into one string with the model's
    special tokens; Hugging Face stores it with the tokeniser and applies it with
    `apply_chat_template`, with `add_generation_prompt` marking where the reply starts.
  - llama-server applies the template stored in the GGUF (or a `--chat-template-file`), and exposes
    `POST /apply-template` to show the result — the check that serving matches training.
  - A mismatch between the training and serving templates silently degrades a fine-tuned model.
  - SFT usually trains only on the assistant's tokens; masking the rest is part of the data format.
- **Recall targets:** say what `add_generation_prompt` changes; explain why a template mismatch hurts.
- **Build:** outline — `template check`: render the same conversation through the training library's
  template and llama-server's `/apply-template`, and diff the token IDs.
- **Security lens:** special tokens in user-supplied text must not be parsed as control tokens; the
  check includes a message containing the template's own markers.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) Hugging Face "Chat templates",
  <https://huggingface.co/docs/transformers/main/en/chat_templating> (transformers 5.17.0); llama.cpp
  `tools/server/README.md` → `--chat-template-file`, `--jinja`, `POST /apply-template`,
  <https://github.com/ggml-org/llama.cpp> (MIT, release b11221, commit 136887b).
- **Done when:** the two renderings match token for token, or the difference is explained and fixed.

## 02 — Skill-use traces as training data

- **Objective:** Sam can turn llm-16's skill-use traces into a supervised fine-tuning set that teaches
  recognise → load → follow, with a task-level held-out split and a data card.
- **Builds on:** lesson 01; llm-16 lessons 06–07; llm-10 (licences and scrubbing).
- **Key ideas:**
  - Each example shows the catalogue, the request, the model choosing the right skill, the activation,
    and a reply that follows the skill — corrected failures from the gap log are the richest examples.
  - Negative cases matter too: requests that need no skill, and ones that need a skill not installed.
  - The held-out split is by task, so evaluation measures unseen work (llm-13's contamination rule).
  - The set stays small and clean; volume does not rescue bad traces.
- **Recall targets:** name the parts of one example; explain why negative cases belong in the set.
- **Build:** outline — `SFT set`: in the model-training repository, the SFT-format dataset built from the traces,
  its split and its card.
- **Security lens:** the scrub from llm-16 lesson 07 runs again before training; a planted fake secret
  that survives fails the build.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) Ouyang et al. (InstructGPT),
  arXiv:2203.02155, Section 3 (supervised fine-tuning as the first stage); Agent Skills specification,
  <https://agentskills.io/specification>; Mitchell et al., arXiv:1810.03993.
- **Done when:** the set, split and card exist and llm-13's contamination check passes on it.

## 03 — LoRA: training a low-rank adapter

- **Objective:** Sam can explain why a low-rank update to frozen weights is enough to adapt a model,
  train one on his own ~100M model or a small open model, and measure its memory and size.
- **Builds on:** lesson 02; llm-12 (the training loop and VRAM budget); llm-03 (matrices and ranks).
- **Key ideas:**
  - LoRA freezes the pre-trained weights and trains a pair of small matrices whose product is added
    to chosen weight matrices; the rank sets the adapter's size (arXiv:2106.09685).
  - Only the adapter's parameters get gradients and optimiser state, which is where the memory saving
    comes from.
  - Which matrices get adapters (attention projections, MLP) and the rank are the design choices; the
    PEFT library exposes them.
  - An adapter is a separate small file; it can be merged into the base or kept apart for serving
    (lesson 07).
- **Recall targets:** compute an adapter's parameter count for a given matrix shape and rank; explain
  where the memory saving comes from.
- **Build:** outline — `first adapter`: in the model-training repository, an SFT run with LoRA on the lesson 02
  set, with VRAM and adapter size recorded.
- **Efficiency lens:** peak VRAM (`torch.cuda.max_memory_allocated`) and adapter size against a full
  fine-tune estimate.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) Hu et al. (LoRA), arXiv:2106.09685; PEFT
  "LoRA" developer guide, <https://huggingface.co/docs/peft/main/en/developer_guides/lora> (peft 0.21.0,
  Apache-2.0 — a Python import, under the crate-licence ADR's rule for Python).
- **Done when:** the adapter trains within the stated VRAM budget and its size matches Sam's estimate.

## 04 — QLoRA on Turing

- **Objective:** Sam can fine-tune a larger open model than fits in 16-bit by training LoRA adapters
  over a 4-bit frozen base, set up correctly for a card without bf16.
- **Builds on:** lesson 03; llm-15 lesson 02 (block quantisation); llm-05 (fp16 and loss scaling on
  Turing).
- **Key ideas:**
  - QLoRA backpropagates through a frozen 4-bit base into LoRA adapters, using the 4-bit NormalFloat
    type, double quantisation of the quantisation constants and paged optimisers
    (arXiv:2305.14314).
  - The paper dequantises to a BFloat16 compute type; this card has no native bf16, so the compute
    type is set to float16 (`bnb_4bit_compute_dtype` in transformers' `BitsAndBytesConfig`, whose
    default is float32).
  - bitsandbytes supports NF4 from compute capability 6.0 and LLM.int8() from 7.5, and its Linux
    wheels list sm75 among their targets — so Turing is supported.
  - The budget is still ~9 GiB free: base at 4 bits, adapters, their optimiser state, activations
    and the KV of the training sequence.
- **Recall targets:** name QLoRA's three memory techniques; explain why the compute type is fp16 here.
- **Build:** outline — `QLoRA run`: in the model-training repository, a QLoRA fine-tune of a small open coding
  model on the lesson 02 set, with peak VRAM recorded against the budget.
- **Efficiency lens:** peak VRAM and step time against the lesson 03 LoRA run.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) Dettmers et al. (QLoRA),
  arXiv:2305.14314, Section 3; bitsandbytes installation guide → "NVIDIA CUDA",
  <https://huggingface.co/docs/bitsandbytes/main/en/installation> (bitsandbytes 0.50.2, MIT);
  transformers "bitsandbytes" → "Compute data type",
  <https://huggingface.co/docs/transformers/main/en/quantization/bitsandbytes>.
- **Done when:** the run completes under the budget with fp16 compute, and its peak is recorded.

## 05 — Rewarding code that passes its tests

- **Objective:** Sam can run one round of rejection sampling — generate several solutions, keep the
  ones whose tests pass in the sandbox, fine-tune on them — and explain how preference methods
  generalise the idea.
- **Builds on:** llm-13 lessons 03 and 05 (the sandboxed test runner, pass@k); sec-04 lesson 07 (the
  sandbox launcher);
  lessons 02–04.
- **Key ideas:**
  - Tests are a cheap, honest reward for code: sample `k` solutions, run each in the sandbox, keep the
    passes (pass@k, arXiv:2107.03374).
  - Fine-tuning on the model's own successful outputs and repeating is the STaR loop
    (arXiv:2203.14465).
  - RLHF trains a reward model and optimises against it with reinforcement learning after SFT
    (arXiv:2203.02155); DPO reaches a similar goal directly from preference pairs, without a separate
    reward model (arXiv:2305.18290) — a passing and a failing solution make a pair.
  - Reward hacking is real: a model can learn to game weak tests, so held-out tests judge the result.
- **Recall targets:** explain rejection sampling in three steps; say what DPO removes from RLHF.
- **Build:** outline — `rejection-sampling round`: in the model-training repository, one round on a small
  task set, with every generated solution run only through the sec-04 launcher.
- **Security lens:** generated code is untrusted; it never runs outside the sandbox, and the sandbox
  has no network.
- **Safety:** the runner has no network and no access outside its scratch directory; Claude never
  runs `sudo`.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) Chen et al. (Codex, HumanEval),
  arXiv:2107.03374; Zelikman et al. (STaR), arXiv:2203.14465; Ouyang et al., arXiv:2203.02155;
  Rafailov et al. (DPO), arXiv:2305.18290.
- **Done when:** one round runs end to end in the sandbox, and held-out pass rates before and after
  are recorded.

## 06 — Evaluating skill-following and each adapter

- **Objective:** Sam can show, with numbers, whether an adapter made the model better at its job than
  its base — the first measurement the base-plus-adapters ADR needs.
- **Builds on:** llm-13 lessons 04 and 07 (infilling evaluation, the personal task suite); llm-16
  lesson 06 (the gap-log replay); lessons 03–05.
- **Key ideas:**
  - Skill-following is scored on the held-out traces by the three outcomes: recognised, loaded,
    followed.
  - Every adapter is compared with its own base on the same suite, same settings, same seed.
  - An adapter can win its domain and lose elsewhere; the suite includes general tasks to catch it.
  - A small suite is noisy: report counts, and look at the cases that changed.
- **Recall targets:** state the comparison the ADR asks for; name one way an adapter can look better
  than it is.
- **Build:** outline — `adapter scorecard`: in the model-training repository, the base and each adapter scored on
  the task suite and the held-out skill traces, summarised in the verification record.
- **Efficiency lens:** tokens per task and latency with and without the adapter.
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) Bavarian et al. (FIM and infilling
  evaluation), arXiv:2207.14255; Chen et al., arXiv:2107.03374;
  `project-management/src/08-DECISIONS/ADR-MS001-LLM-BASE-MODEL-PLUS-ADAPTERS-27-09-2026.md`.
- **Done when:** the scorecard answers the ADR's first question for the ~100M model's coding adapter.

## 07 — Serving several adapters, and what it costs

- **Objective:** Sam can serve one base with several adapters, choose the adapter per request, and
  measure the throughput cost — the second measurement the ADR needs.
- **Builds on:** llm-15 lesson 11 (batching); lesson 06.
- **Key ideas:**
  - llama.cpp loads adapters with `--lora` (converted with `convert_lora_to_gguf.py`), sets global
    scales at `POST /lora-adapters`, and takes a per-request `lora` list — but requests with different
    adapter settings are not batched together, which costs throughput.
  - vLLM serves adapters with `--enable-lora`, bounded by `--max-loras`, `--max-lora-rank` and
    `--max-cpu-loras`; its GPU install guide asks for compute capability 7.5 or higher, which this card
    meets — whether its current wheels suit driver 580 is checked when L6 opens.
  - Mixed-adapter traffic is the realistic load; measure it, not one adapter at a time.
- **Recall targets:** explain why differing adapters break batching; name the vLLM limits and what
  each bounds.
- **Build:** outline — `adapter serving sweep`: serve the base with two adapters and measure total and
  per-request throughput for one adapter, two alternating, and the base alone, recorded in the
  verification record.
- **Efficiency lens:** throughput and VRAM for one against two adapters under mixed traffic.
- **Security lens:** adapters are supply chain (llm-18 lesson 05): each is verified by digest before
  loading, and a tenant's adapter choice is not a trust boundary on a shared server (llm-18 lesson 07).
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) llama.cpp `tools/server/README.md` →
  `--lora`, `lora` (per request), `/lora-adapters`, and `convert_lora_to_gguf.py` at b11221; vLLM "LoRA
  Adapters", <https://docs.vllm.ai/en/latest/features/lora.html>, and "Engine Arguments",
  <https://docs.vllm.ai/en/latest/configuration/engine_args.html> (vLLM 0.30.0); vLLM GPU installation,
  <https://docs.vllm.ai/en/latest/getting_started/installation/gpu.html>.
- **Done when:** the record answers the ADR's second question with the measured cost.

## 08 — Domain variants: coding first, the rest only with retrieval

- **Objective:** Sam can state the conditions under which a legal, HR, finance or business variant
  would be responsible, and why coding comes first.
- **Builds on:** llm-17 (retrieval, citations, authoritative UK sources); lessons 06–07.
- **Key ideas:**
  - Coding has an automatic judge — tests — and a domain Sam knows; the other domains have neither
    on this machine.
  - Those domains change and are jurisdiction-specific: a variant answers from retrieved,
    authoritative, current UK sources with citations (llm-17), not from its weights.
  - It is positioned as an assistant to professionals, who make the decision.
  - The work is parked in `DEFERRED.md` (L6) until the coding adapter has proved the pipeline.
- **Recall targets:** give the three conditions for a responsible domain variant.
- **Build:** none — the output is a short note of the conditions, linked from the `DEFERRED.md` entry
  when the entry is revisited.
- **Security lens:** a confident wrong answer in these domains is a harm (OWASP LLM09:2025
  Misinformation, LLM07:2026).
- **Sources:** (checked 27/09/2026; re-verify when L6 opens) legislation.gov.uk "Developer Zone",
  <https://www.legislation.gov.uk/developer>; OWASP Top 10 for LLM Applications 2025,
  <https://genai.owasp.org/llm-top-10/>; `DEFERRED.md`.
- **Done when:** Sam's note states the conditions, and the ADR's Consequences reflect them.
