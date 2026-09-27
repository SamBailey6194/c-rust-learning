# Syllabus — llm-01-local-models-and-skills-baseline

**Track**: llm · **Phase**: L1 · **Path**: Core · **Detail**: full · **Prerequisites**: the L1 phase, which opens after P1 (`project-management/src/01-ROADMAP/ROADMAP.md`); no earlier topic is needed (ollama 0.34.0 is installed on this machine, and lessons 01 and 04 are reading plus measurement); sec-01 lessons 01–04 recommended before lesson 02
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The first LLM topic, and the first milestone suggested in the planning conversation (run an open
coding model with a handful of hand-written skills before any training) — to confirm with Sam. That
conversation proposed llama.cpp driven from Rust; ollama replaces it here because Rust arrives at P3,
and llm-14 and llm-16 take the Rust route later. Run an open coding model on this machine, give it
hand-written Markdown skills, measure what it costs in VRAM, RAM and time, and
write down where it falls short. No C, Rust or CUDA yet. The numbers become **the baseline every
later model is compared against** (the tiny GPT in llm-05, the ~100M code model in llm-12, the Rust
inference path in llm-14 and llm-15). The gap log becomes data: llm-16 replays it through the Rust
skill loader and llm-20 turns it into skill-use training traces. The decision behind the skills is
the skills-not-agents ADR in `project-management/src/08-DECISIONS/`.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | What fits: parameters, bits per weight and a ~9 GiB budget | 1 sitting | no | Efficiency |
| 02 | Models and registries as untrusted inputs | 1 sitting | yes — provenance record | Security |
| 03 | Measuring a local model honestly: tokens/s, load time, VRAM and RAM | 2–3 sittings | yes — baseline runs | Efficiency |
| 04 | Context length costs memory: the KV cache, measured | 1 sitting | yes — context sweep | Efficiency |
| 05 | Writing skills with progressive disclosure | 2–3 sittings | yes — three skills | Efficiency, Security |
| 06 | Running skills and logging the gaps | 2–3 sittings | yes — gap log | Security, Safety |

**Where the work lands.** The measurements are milestone evidence, so they go in the milestone's
verification record under `project-management/src/10-PROGRESS/`. The three skills and the gap log
are the LLM's first artefacts and are consumed at inference by llm-16's skill loader (and turned into
training data by llm-20), so they land in **the inference repository (created when this build starts —
lesson 05 is where it starts, before any Rust; Sam chooses its name and licence)**, not in this
repository.

---

## 01 — What fits: parameters, bits per weight and a ~9 GiB budget

- **Objective:** Sam can estimate the weight footprint of a quantised model from its parameter count
  and bits per weight, and choose a coding model and quantisation that fit this machine's free VRAM
  with room left for the KV cache.
- **Builds on:** Sam's own reason for the track (efficient use of CPU, RAM, GPU, VRAM and cache);
  no earlier LLM lesson.
- **Key ideas:**
  - Weight bytes are roughly `parameters * bits_per_weight / 8`; llama.cpp's quantisation table
    gives the bits per weight of each GGUF type (for its Llama 3.1 8B example: Q4_K_M about 4.89,
    Q8_0 about 8.50, F16 about 16.0).
  - The budget is **free** VRAM, not the card's 11 GiB (11264 MiB): this RTX 2080 Ti also drives the
    desktop, which held 1474 MiB at idle on 27/09/2026, and the driver reserves about 470 MiB more
    (`nvidia-smi --query-gpu=memory.used,memory.reserved,memory.free --format=csv`), leaving 9318 MiB,
    about 9.1 GiB, free. Idle use moves with what the desktop shows (1381–1581 MiB across readings
    that day), so budget against `memory.free` (or `torch.cuda.mem_get_info()`) read on the day, not
    11264 minus used.
  - Weights are not the whole bill: the KV cache (lesson 04), the runtime's buffers and the CUDA
    context all share the same memory.
  - Quantisation trades accuracy for size; llama.cpp measures the loss as perplexity or KL
    divergence, so a smaller quant is a measured choice, not a free one.
  - `ollama show` reports architecture, parameter count, context length, quantisation and licence;
    the licence is part of the choice.
- **Recall targets:** predict the weight size of a named parameter count at two quantisations;
  explain why the budget is ~9 GiB and not 11, including what `memory.reserved` is; name what else
  competes for VRAM besides weights.
- **Build:** none — the output is the choice itself, with its arithmetic, in the lesson's note.
- **Efficiency lens:** predicted weight size against the size the registry lists for each tag
  (<https://ollama.com/library>, the model's "tags" page) or the GGUF file's size, read without
  pulling; the difference is explained, not ignored. The registry and `ollama list` print GB, and
  ollama's GB is decimal (10^9 bytes), while nvidia-smi reports MiB: convert before comparing. Only
  the chosen model is pulled, at the start of lesson 02, after the loopback and cloud checks.
- **Sources:** llama.cpp `tools/quantize/README.md` → "Quantization" tables and "Memory/Disk
  Requirements" (<https://github.com/ggml-org/llama.cpp>, MIT, read at commit a97cce8, 27/09/2026);
  ollama docs → "Context length" (<https://docs.ollama.com/context-length>, read 27/09/2026 against
  ollama 0.34.0); `ollama show --help` on this host; `man nvidia-smi` (driver 580.178.04).
- **Done when:** Sam's note names two candidate models at two quantisations each, with predicted and
  registry-listed sizes side by side (nothing pulled yet), and the chosen one leaves stated headroom
  under ~9.1 GiB.

## 02 — Models and registries as untrusted inputs

- **Objective:** Sam can record where a model came from (source, blob digest, quantisation,
  licence), keep the ollama server local-only, and explain why a pulled model, its Modelfile and the
  code it generates are all untrusted input.
- **Builds on:** lesson 01; sec-01 lessons 01–04 (assets, trust boundaries, a milestone threat
  model) if taken.
- **Key ideas:**
  - OWASP LLM03:2025 (Supply Chain; LLM04:2026 in the re-ranked list): third-party weights can be
    tampered with, mislabelled or carry licence terms that forbid the intended use.
  - ollama names each model blob by a sha256 digest; `ollama show --modelfile <model>` prints the
    `FROM` blob, and that digest is recorded beside every measurement. Where the blob file is
    readable, `sha256sum` shows whether the name matches the content.
  - A Modelfile's `TEMPLATE`, `SYSTEM` and `PARAMETER` lines change behaviour; read them before
    trusting a model's output.
  - The server binds `127.0.0.1:11434` by default; keeping it there, and turning cloud features
    off (`OLLAMA_NO_CLOUD=1`), keeps prompts and code on this machine. On this host the server is a
    root-owned systemd service (user `ollama`), so Sam applies the setting himself with
    `sudo systemctl edit ollama` (`Environment=OLLAMA_NO_CLOUD=1`) and restarts it — Claude never runs
    `sudo`; the check is the log line "Ollama cloud disabled: true". The chosen model is pulled only
    after both checks pass.
  - Generated code is untrusted output (OWASP LLM05:2025, Improper Output Handling; LLM10:2026).
- **Recall targets:** name three things that can be wrong with a pulled model; say where its digest
  comes from; explain what binding to `0.0.0.0` would expose.
- **Build:** a provenance record for the chosen model (source, digest, quantisation, licence,
  Modelfile template summary) plus a check that the port listens on loopback only, read with
  `ss -ltn`; recorded in the milestone's verification record under
  `project-management/src/10-PROGRESS/`. Checked by the digest re-read after the server restarts
  matching the record.
- **Security lens:** this lesson is the topic's threat model — assets (the host, Sam's code and
  prompts), threats (tampered weights, a listening port, unsafe generated code), mitigations (digest
  recorded, loopback only, cloud off, generated code not executed).
- **Sources:** OWASP Top 10 for LLM Applications 2025 → LLM03:2025 Supply Chain
  (<https://genai.owasp.org/llmrisk/llm032025-supply-chain/>) and LLM05:2025 Improper Output
  Handling (<https://genai.owasp.org/llmrisk/llm052025-improper-output-handling/>), mapped to the 2026
  edition in `llm-18-secure-llm-systems` lesson 01; ollama docs →
  FAQ "How can I expose Ollama on my network?" and "How do I disable Ollama Cloud features?"
  (<https://docs.ollama.com/faq>, read 27/09/2026) and "Modelfile Reference"
  (<https://docs.ollama.com/modelfile>); `ollama show --help`; `man 8 ss`.
- **Done when:** the provenance record exists with a sha256 digest and licence, and `ss -ltn` shows
  the ollama port on `127.0.0.1` only.

## 03 — Measuring a local model honestly: tokens/s, load time, VRAM and RAM

- **Objective:** Sam can measure a local model's load time, prompt-processing rate, generation
  rate, VRAM and RAM over repeated runs and report them with their spread.
- **Builds on:** lessons 01–02.
- **Key ideas:**
  - ollama's responses carry `load_duration`, `prompt_eval_count`, `prompt_eval_duration`,
    `eval_count` and `eval_duration`, all in nanoseconds; tokens/s is a count divided by a
    duration. `ollama run --verbose` shows timings for each response in the terminal.
  - Prompt processing (many tokens at once) and generation (one token at a time) are different
    workloads with different rates; report both.
  - The first request pays the load; later ones hit a warm model until `keep_alive` expires.
    Separate cold from warm runs.
  - One run is an anecdote: fixed prompts, several runs, the median and the spread. The full
    measurement method is llm-06 lesson 01.
  - `ollama ps` shows the size in memory and the CPU/GPU split; a split means layers spilled to
    system RAM, and generation slows.
- **Recall targets:** explain why generation is slower per token than prompt processing; predict
  what `ollama ps` shows when the model no longer fits; state why a warm and a cold run differ.
- **Build:** baseline runs — three fixed coding prompts, at least five warm runs each plus one cold
  run, recording both rates, load time, VRAM (`nvidia-smi --query-gpu=memory.used --format=csv`
  polled during the run), the runner's resident memory (`ps -o rss`) and the model digest from
  lesson 02. The table goes in the milestone's verification record under
  `project-management/src/10-PROGRESS/`. Checked by a repeat run on another day landing inside the
  recorded spread.
- **Efficiency lens:** this lesson produces the baseline: generation tokens/s, prompt tokens/s,
  load time, VRAM peak and RAM, each with its spread.
- **Sources:** ollama docs → API "Usage" (<https://docs.ollama.com/api/usage>) and FAQ "How can I
  tell if my model was loaded onto the GPU?" and "How do I keep a model loaded in memory…"
  (<https://docs.ollama.com/faq>), read 27/09/2026; `ollama run --help` (0.34.0); `man nvidia-smi`
  (`--query-gpu`, `--loop-ms`); `man 1 ps`.
- **Done when:** the baseline table has every field for three prompts with medians and spreads, the
  model digest and the ollama version, and a second-day repeat agrees.

## 04 — Context length costs memory: the KV cache, measured

- **Objective:** Sam can predict that VRAM grows linearly with context length, read the numbers the
  growth depends on from the model's metadata, and measure the growth.
- **Builds on:** lesson 03.
- **Key ideas:**
  - Every token in the context keeps a key and a value vector in every layer; that store is the KV
    cache, and it grows with the context. PagedAttention's worked example: one token of OPT-13B
    takes about 800 KB in fp16.
  - The GGUF metadata keys `block_count`, `attention.head_count`, `attention.head_count_kv` and
    `embedding_length` (shown by `ollama show --verbose`) are the inputs; the full arithmetic,
    including grouped-query attention, is llm-15's lesson.
  - ollama defaults to a 4k context below 24 GiB of VRAM; `OLLAMA_CONTEXT_LENGTH` or the
    `num_ctx` option changes it, and `ollama ps` shows the context actually allocated.
  - `OLLAMA_KV_CACHE_TYPE` (`f16` by default; `q8_0` about half the memory) shrinks the cache when
    flash attention is on — a second measured axis.
  - A short context is also a reason to prefer small, focused skills (lesson 05).
- **Recall targets:** state what one token of context stores; predict how VRAM changes when the
  context doubles; name two ways to fit a longer context.
- **Build:** a context sweep — the chosen model at several context lengths (for example 4k, 8k, 16k
  and the largest that stays 100% on the GPU), and at `f16` and `q8_0` cache types, recording VRAM,
  the `ollama ps` processor split and generation tokens/s. Added to the baseline record. Checked by
  VRAM rising roughly in proportion to the context, and the point where the split appears noted.
- **Efficiency lens:** VRAM per 1k tokens of context, and the context length at which the model
  first spills to the CPU.
- **Sources:** ollama docs → "Context length" (<https://docs.ollama.com/context-length>) and FAQ
  "How can I set the quantization type for the K/V cache?" (<https://docs.ollama.com/faq>), read
  27/09/2026; GGUF specification → "Standardized key-value pairs → LLM"
  (<https://github.com/ggml-org/ggml/blob/master/docs/gguf.md>, read at commit 353b63b); Kwon et
  al., PagedAttention, arXiv:2309.06180, Section 3.
- **Done when:** the sweep table is in the baseline record and Sam predicts the next point before
  measuring it.

## 05 — Writing skills with progressive disclosure

- **Objective:** Sam can write a skill in the Agent Skills shape — short metadata, a body loaded on
  activation, reference files loaded on demand — sized for a small model's context.
- **Builds on:** lesson 04 (why context is expensive); Sam's daily use of this repository's own
  skills under `.claude/skills/`, which are the working prototype of the format.
- **Key ideas:**
  - Three tiers: metadata (`name` and `description`, about 100 tokens) always loaded; the body
    (under about 5000 tokens) loaded when the skill activates; references and scripts only when a
    step needs them.
  - The description does the routing: the job first, then the triggers — a small model picks a
    skill from descriptions alone.
  - Focused instructions per task suit small models better than long agent loops, and a short
    context keeps the KV cache small (lesson 04).
  - At this stage Sam is the loader: he gives the model the list of descriptions, lets it choose,
    then pastes the chosen body. llm-16 automates exactly this step in Rust.
- **Recall targets:** name the three tiers and what triggers each; explain why the description, not
  the body, decides whether a skill is used.
- **Build:** three skills for coding tasks Sam really does (candidates: write a C function in this
  repository's kernel style with a `check.h` test; review a Rust function against the workspace
  lint rules; explain a gcc or rustc error). They land in **the inference repository (created when
  this build starts)**. Checked by each skill's metadata and body token counts, read from
  `prompt_eval_count` when the text is sent to the model on its own.
- **Efficiency lens:** tokens per skill tier, and the KV cost of loading one body (lesson 04's
  per-token figure times the body's tokens).
- **Security lens:** a skill is an instruction channel; it contains no secrets and names no private
  systems, because anything in it reaches the model's context.
- **Sources:** Agent Skills specification → "Progressive disclosure" and "SKILL.md format"
  (<https://agentskills.io/specification>, read 27/09/2026); `.claude/skills/CLAUDE.md` (this
  repository's authoring rules); the skills-not-agents ADR in `project-management/src/08-DECISIONS/`.
- **Done when:** three skills exist in the inference repository, each within the tier budgets, and Sam can
  justify each description line.

## 06 — Running skills and logging the gaps

- **Objective:** Sam can run each skill against a fixed task set, judge the output against the
  skill's own checklist, and record every failure in a gap log that can be replayed later.
- **Builds on:** lessons 03–05.
- **Key ideas:**
  - A fixed task set with a stated expected outcome per task is a small evaluation; without it,
    "the model did badly" is an impression.
  - Failure categories: did not pick the skill (recognise), picked it but skipped steps (follow),
    ran out of context, stated a wrong fact, suggested something unsafe.
  - A gap entry is data: task, skill, model digest and settings, prompt, output excerpt, category,
    note. Without the digest and settings it cannot be replayed (llm-16) or turned into training
    traces (llm-20).
  - One probe per skill carries an injected instruction in the task text (OWASP LLM01:2025, LLM01:2026) to see
    whether the model follows the task file over the skill.
- **Recall targets:** name the failure categories and give an example of each from Sam's own log;
  explain why the digest belongs in every entry.
- **Build:** the gap log for three skills across the task set, in the inference repository beside the
  skills; the summary (counts per category) also goes in the milestone's verification record.
  Checked by every entry having all fields and every task having a verdict.
- **Security lens:** prompt injection through task files (LLM01:2025, LLM01:2026); generated code is
  untrusted output (LLM05:2025, LLM10:2026).
- **Safety:** generated code is read and judged against the skill's checklist, never executed on
  the host; running it waits for sec-04's sandbox.
- **Sources:** OWASP Top 10 for LLM Applications 2025 → LLM01:2025 Prompt Injection
  (<https://genai.owasp.org/llmrisk/llm01-prompt-injection/>) and LLM05:2025
  (<https://genai.owasp.org/llmrisk/llm052025-improper-output-handling/>), mapped to the 2026 edition
  in `llm-18-secure-llm-systems` lesson 01; Agent Skills
  specification (<https://agentskills.io/specification>); ollama API "Usage"
  (<https://docs.ollama.com/api/usage>).
- **Done when:** the gap log covers every task with a category or a pass, the injection probes are
  recorded, and the milestone record holds the summary.
