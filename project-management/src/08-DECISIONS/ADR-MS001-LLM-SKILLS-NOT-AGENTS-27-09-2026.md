# ADR-MS001: LLM — skills with progressive disclosure, not autonomous agent loops

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-LLM-SKILLS-NOT-AGENTS |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources cited below) |
| **Enforced in** | `project-management/src/01-ROADMAP/ROADMAP.md` → L1 and L5 · the skill loader in the inference repository (created when its build starts) |

---

## Context

The language model Sam wants is a coding assistant that runs locally and works through Markdown
skills, workflows and documentation. In his planning conversation of 27/09/2026 (Q6) he chose the
shape: a proper coding model **using skills, not agents**. The answer set out the reasoning — small
models follow a focused instruction better than a long agent loop, and a skill loaded only when it is
needed keeps the context short — and suggested a first step: run an open coding model with a handful
of hand-written skills, and let the places it falls short become the training data.

Facts checked on 27/09/2026:

- **Progressive disclosure is a documented pattern.** Anthropic's Agent Skills documentation
  describes three levels: a skill's name and description are loaded at start-up; its instructions are
  loaded only when the skill is triggered; its further files and scripts are read only when
  referenced — so many skills can be installed at little context cost (Sources, item 1). This
  repository already works that way: `.claude/skills/teach/SKILL.md`, `.claude/skills/research/SKILL.md`,
  `.claude/skills/handoff/SKILL.md` and `.claude/skills/wait-what/SKILL.md` each open with a
  frontmatter description that decides when they load.
- **Long contexts are used unevenly.** Language models answer best when the relevant information is
  at the beginning or end of the input, and noticeably worse when it sits in the middle of a long
  context, even for models built for long contexts (Sources, item 2).
- **Context costs memory.** The key-value cache for each request is large and grows with the
  sequence (Sources, item 3); grouped-query attention exists to shrink it by sharing key and value
  heads (Sources, item 4). On this machine the budget is tight: `nvidia-smi` reported 11264 MiB on
  the RTX 2080 Ti, 9318 MiB of it free with the desktop running.
- **A local runner is installed.** `ollama --version` reports 0.34.0, so a skills baseline with an
  open model needs no new software.

## Options considered

### Option A — Skills: Markdown instructions with progressive disclosure

- **Summary:** Each skill is a folder with a `SKILL.md` (name, description, instructions) and
  optional scripts or references. The model sees only names and descriptions until one matches; a
  Rust loader then puts that skill's instructions into context. Skill scripts run in a sandbox.
- **Pros:** Short, focused contexts — smaller KV caches and less for a small model to lose track of.
  Skills are plain files, versioned in git and reviewed like code. The same format serves Claude
  in this repository and the local model.
- **Cons:** The model has to learn to recognise, load and follow a skill; a small model may not do
  that reliably without post-training. Skill scripts are code from a file, so they need a sandbox and a
  permission model.

### Option B — Autonomous agent loops

- **Summary:** The model plans, calls tools and iterates for many steps with a growing transcript.
- **Pros:** Handles open-ended, multi-step tasks without a human choosing the procedure.
- **Cons:** The transcript grows every step, which costs KV memory and puts earlier instructions in
  the middle of a long context. Excessive agency is a named risk in the OWASP LLM Top 10
  (LLM06:2025, re-ranked as LLM03:2026 in the edition of 03/08/2026) and grows with the number of
  unsupervised steps.

### Option C — Everything in the weights

- **Summary:** Fine-tune all procedures into the model; no runtime instructions.
- **Pros:** No loader; shortest prompts.
- **Cons:** Changing a procedure means retraining; procedures cannot be read or reviewed; errors are
  invisible until they surface.

### Option D — Retrieval only

- **Summary:** Index the documentation and retrieve passages for each request.
- **Pros:** Fresh, citable facts without retraining.
- **Cons:** Retrieved passages are facts, not procedures; the model still has to know what to do with
  them. Useful as a complement rather than a replacement.

## Decision

**We will take Option A: the model works through skills with progressive disclosure, not
autonomous agent loops.** The deciding factor is the size of the model and the machine: a small model
on a GPU with about 9 GiB free does best with a short, focused context, and skills are the way to give
it one. Retrieval (Option D) was the runner-up and is kept as a complement for documentation
(`llm-17-retrieval-and-doc-guidance`).

This answer changes if measured skill-following of the own model stays poor after post-training while
a bounded agent loop does measurably better on the same task suite — a result `llm-20` can produce —
which would be argued in a new ADR.

## Consequences

- **Positive:** The first LLM milestone needs no C, Rust or CUDA: an open model under ollama with
  three hand-written skills, and a gap log of where it fails (`llm-01-local-models-and-skills-baseline`).
  The skill loader is a bounded Rust project (`llm-16-skills-layer`).
- **Negative:** Skill-following has to be trained and evaluated; skill scripts need the sandbox and
  per-skill policy that `ADR-MS001-LLM-EFFICIENCY-AND-SECURITY-FIRST-27-09-2026.md` requires.
- **Follow-on:**
  - To confirm — "small models follow focused skills better than long agent loops" was the
    conversation's reasoning; the llm-01 gap log and the skill-following evaluation in
    `llm-20-post-training-and-adapters` test it on this machine.
  - The gap log becomes skill-use training data (recognise, load, follow) at post-training.
  - The skill loader lives in the inference repository when that build starts; lesson-sized
    loaders stay here (`ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md`).

## Sources

1. **Anthropic, Agent Skills overview** —
   <https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview> — the three loading
   levels of progressive disclosure, checked 27/09/2026
2. **Liu et al., "Lost in the Middle: How Language Models Use Long Contexts"** — arXiv:2307.03172,
   <https://arxiv.org/abs/2307.03172>, checked 27/09/2026
3. **Kwon et al., "Efficient Memory Management for Large Language Model Serving with
   PagedAttention"** — arXiv:2309.06180, <https://arxiv.org/abs/2309.06180> — KV-cache memory per
   request, checked 27/09/2026
4. **Ainslie et al., "GQA: Training Generalized Multi-Query Transformer Models from Multi-Head
   Checkpoints"** — arXiv:2305.13245, <https://arxiv.org/abs/2305.13245>, checked 27/09/2026
5. **OWASP Top 10 for LLM Applications 2025** — <https://genai.owasp.org/llm-top-10/> — LLM06:2025
   Excessive Agency, checked 27/09/2026; the 2026 edition
   (<https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/>, 03/08/2026) lists it as
   LLM03:2026
6. **Host commands, 27/09/2026** — `nvidia-smi --query-gpu=memory.total,memory.free --format=csv`;
   `ollama --version`
7. **Sam's planning conversation, 27/09/2026** — Q6 (the decision and its reasoning)
