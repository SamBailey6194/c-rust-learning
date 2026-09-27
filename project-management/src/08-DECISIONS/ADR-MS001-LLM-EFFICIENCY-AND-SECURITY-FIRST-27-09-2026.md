# ADR-MS001: LLM — resource budgets and a threat model on every milestone, from the first

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-LLM-EFFICIENCY-AND-SECURITY-FIRST |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources cited below); the sandbox design follows in `research/LLM-SANDBOX-DESIGN.md` (planned) |
| **Enforced in** | `project-management/docs/planning/MILESTONES.md` (the `Budget` flag and `## Threat model`) · `project-management/src/01-ROADMAP/ROADMAP.md` → Cross-cutting lenses · `.claude/CLAUDE.md` Section 5 (weights, data and sandbox rules) · `project-management/docs/SAFETY-GUIDE.md` |

---

## Context

Sam's brief for the model is that it uses computing resources properly — CPU, RAM, GPU, VRAM and
caches — and is secure (planning conversation of 27/09/2026, Q8, and his brief for the LLM track the
same day). The question is whether those are goals the track reaches at the end, or constraints every
milestone carries from the start.

Facts checked on 27/09/2026:

- **The machine is small for this work.** `nvidia-smi` reports an RTX 2080 Ti with 11264 MiB, of
  which 9318 MiB was free with the desktop session running; the CPU is an i9-9900K (16 threads,
  16 MiB L3); RAM is 31 GiB usable. A run that does not fit fails at run time, not at planning.
- **Some measurements need privileges.** `sysctl kernel.perf_event_paranoid` returns 4, and the
  NVIDIA driver reports `RmProfilingAdminOnly: 1`, so `perf` counters and GPU performance counters are
  unavailable to Sam's user. Claude never runs `sudo`; Sam decided on 27/09/2026 that lessons needing
  counters show him how to relax each restriction for one session and restore it, and also teach the
  unprivileged fallback (`valgrind --tool=cachegrind`, `torch.profiler`).
- **Loading a checkpoint can run code.** PyTorch 2.14's `torch.load` unpickles; its documentation
  warns never to load data from an untrusted source. `weights_only=True` (the default in 2.14)
  restricts the unpickler to an allowlist, and falling back to `weights_only=False` can result in
  arbitrary code execution (Sources, items 1 and 2).
- **safetensors is a format without code.** Its specification is an 8-byte little-endian header
  length, a JSON header naming each tensor's dtype, shape and offsets, then raw tensor bytes; the
  project describes it as a safe alternative to pickle that still allows zero-copy loading (Sources,
  item 3).
- **The threats are catalogued.** The OWASP Top 10 for LLM Applications 2025 lists, among others,
  prompt injection (LLM01), sensitive information disclosure (LLM02), supply chain (LLM03), data and
  model poisoning (LLM04), excessive agency (LLM06) and unbounded consumption (LLM10) (Sources,
  item 4). Its 2026 edition of 03/08/2026 re-ranks them — supply chain is now LLM04, data and model
  poisoning LLM05, excessive agency LLM03 and unbounded consumption LLM06, while LLM01 and LLM02 keep
  their places (Sources, item 8); this repository cites the 2025 IDs, mapped in
  `learning/llm-18-secure-llm-systems/` lesson 01.
- **Training data carries licences.** The Stack v2, the code dataset the track studies, is built
  from the Software Heritage archive (Sources, item 5); what may be trained on is decided per file
  licence and per dataset terms, not per repository.

## Options considered

### Option A — Budgets and a threat model on every milestone, from the first

- **Summary:** Every LLM milestone (and every kernel-config and OS milestone) states a resource
  budget — the numbers it must stay within and the tool that measures each — and a threat model of
  one to three lines; `11-verification` measures the budget. Weights load only from safetensors, or
  from a torch checkpoint this machine produced loaded with `weights_only=True`. Training data is
  licence-checked and scrubbed of secrets and personal data. Code a model or a skill generates runs
  sandboxed.
- **Pros:** A run that will not fit is caught at planning. Measurement becomes a habit taught in
  `llm-06-cpu-performance-in-c` lesson 01 and reused everywhere. The riskiest input paths (weights,
  data, generated code) are closed before they exist.
- **Cons:** More planning per milestone; some budgets are guesses the first time and need revising.

### Option B — Make it work, then make it fast and safe

- **Summary:** Build the pipeline first; optimise and harden at the end of the track.
- **Pros:** Faster first results.
- **Cons:** The end of the track is years away. Habits (loading any checkpoint, running generated
  code directly) form early and are expensive to unlearn; on an 11 GB card, "works" and "fits" are the
  same question.

### Option C — Rely on the serving stacks' defaults

- **Summary:** Trust ollama, llama.cpp and PyTorch defaults; measure nothing of our own.
- **Pros:** No work.
- **Cons:** Nothing to compare against, so no efficiency claim can be made; defaults are not a
  threat model.

### Option D — Budgets for training only

- **Summary:** Measure training runs; leave inference, skills and data work unmeasured.
- **Pros:** Covers the most expensive runs.
- **Cons:** Inference and the skills layer are where the memory-efficiency goal lives (KV caches,
  quantisation, offload), and the skill loop is where excessive agency and prompt injection live.

## Decision

**We will take Option A: resource budgets and a threat model are part of every LLM milestone from
the first, with safetensors-only weights, licence-checked and scrubbed data, and sandboxed generated
code.** The deciding factor is the machine: with about 9 GiB of free VRAM, fitting is the first thing
any plan has to prove, and a model that loads files and runs code from outside needs its threat
model before its first run. Option D was the runner-up and lost because the efficiency goal lives
mostly in inference.

This answer changes only if the budgets prove to be noise — measured values routinely nowhere near
their budgets and never informing a decision — which would be argued in a new ADR.

## Consequences

- **Positive:** Every LLM milestone has a `Budget` row that is never `N/A`, a `## Threat model`
  section, and a Resource measurements table in its verification record. The same lenses apply to
  kernel-config and OS milestones (`ROADMAP.md` → Cross-cutting lenses).
- **Negative:** Planning takes longer; lessons that need counters depend on Sam relaxing a host
  setting for a session.
- **Follow-on:**
  - `project-management/docs/planning/MILESTONES.md` gains the `Budget` flag and the
    `## Threat model` section; `project-management/src/10-PROGRESS/MS000-VERIFICATION-TEMPLATE.md`
    gains Resource measurements; `project-management/src/05-PROJECTS/PROJ-MS000-TEMPLATE.md` gains
    Resource budget and Threat model sections.
  - The sandbox is designed once (`sec-04-linux-security-model` owns the launcher) and reused by the
    evaluation, secure-systems and post-training lessons; `research/LLM-SANDBOX-DESIGN.md` (planned)
    grounds it.
  - `GAPS.md` records the locked-down counters; Sam decides whether to relax them, per session.

## Sources

1. **PyTorch 2.14, `torch.load`** — <https://docs.pytorch.org/docs/2.14/generated/torch.load.html>
   — `weights_only=True` default and the untrusted-data warning, checked 27/09/2026
2. **PyTorch 2.14, Serialization semantics** —
   <https://docs.pytorch.org/docs/2.14/notes/serialization.html> — the `weights_only` unpickler and
   the arbitrary-code-execution warning, checked 27/09/2026
3. **safetensors** — <https://github.com/safetensors/safetensors> — the format and its safety goal,
   checked 27/09/2026; documentation at <https://huggingface.co/docs/safetensors/index>
4. **OWASP Top 10 for LLM Applications 2025** — <https://genai.owasp.org/llm-top-10/> — LLM01 to
   LLM10:2025, checked 27/09/2026
5. **Lozhkov et al., "StarCoder 2 and The Stack v2: The Next Generation"** — arXiv:2402.19173,
   <https://arxiv.org/abs/2402.19173>, checked 27/09/2026
6. **Host commands, 27/09/2026** — `nvidia-smi --query-gpu=memory.total,memory.free --format=csv`,
   `lscpu`, `free -g`, `sysctl kernel.perf_event_paranoid`, and the `RmProfilingAdminOnly` line of the
   NVIDIA driver's parameters
7. **Sam's planning conversation, 27/09/2026** — Q8, and his brief for the LLM track
8. **OWASP Top 10 for LLM Applications 2026** —
   <https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/> — published 03/08/2026, LLM01 to
   LLM10:2026, checked 27/09/2026
