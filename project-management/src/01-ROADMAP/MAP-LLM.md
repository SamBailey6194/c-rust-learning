# MAP-LLM — a local, efficient, secure language model (L1–L6)

**Charted**: 27/09/2026 | **Charted by**: Sam Bailey | **Workflow**: `01-roadmap-map`
**Phase**: L1–L6 — `project-management/src/01-ROADMAP/ROADMAP.md`
**Status**: Charting
**Frontier open**: 5 | **Blocking open**: 0

> A `Charting` draft: destination and open decisions from Sam's planning conversation of 27/09/2026
> and its ADRs; nodes resolve in later sessions, one at a time. **The map is an index, not a vault.**

---

## Destination

L1–L6 exit gates met (`ROADMAP.md` → L1 … L6): from a measured local-model-and-skills baseline, to a
~100M fill-in-the-middle code model trained on the 2080 Ti within a VRAM budget and evaluated in a
sandbox, to efficient secure inference in Rust with a skill loader, to a ~1B base with LoRA adapters
per domain — resource budgets and a threat model on every milestone. The chat's destination: a Syntek
OS that runs Sam's own efficient local model with skills built in.

---

## Notes

| Field | Value |
| --- | --- |
| Phase exit gate | L1–L6 — `project-management/src/01-ROADMAP/ROADMAP.md` → L1 … L6 |
| Already known | _Not yet asked — the first charting session with Sam fills this._ (Sam already knows Python, a standing input for the training work.) |
| Expected to be hard | _Not yet asked — the first charting session with Sam fills this._ |
| Skills to load | from `.claude/skills/`: teach, research, handoff, wait-what |
| Standing preferences | skills not agents; a budget and a threat model on every milestone; safetensors-only weights; licence-checked, scrubbed data; sandboxed generated code; ~100M locally before ~1B on rented GPUs |
| Umbrella ADRs | `ADR-MS001-LLM-SKILLS-NOT-AGENTS-27-09-2026.md` · `ADR-MS001-LLM-EFFICIENCY-AND-SECURITY-FIRST-27-09-2026.md` · `ADR-MS001-LLM-BASE-MODEL-PLUS-ADAPTERS-27-09-2026.md` (Proposed) · `ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md` (all in `project-management/src/08-DECISIONS/`) |
| Primary resources | the L1–L6 lists in `ROADMAP.md`; PyTorch and NVIDIA docs; papers by arXiv ID; llm.c and nanochat; the OWASP LLM Top 10 |
| Register entries triaged | 0 closes, 7 blocks, 0 unrelated — from `GAPS.md` |

**Register triage is a claim, not a close.** The `GAPS.md` entries this track meets: "CUDA toolkit
(`nvcc`) not installed"; "Nsight Systems and Nsight Compute not installed"; "perf and GPU performance
counters are locked for unprivileged users"; "LLM track tools not installed"; "Per-crate licence
exceptions arrive with the first crate that needs them" (the Apache-2.0-only crates, admitted by ADR);
"CI has no GPU"; and "L6 compute budget and provider not chosen". Each is a frontier node's blocker or
a lesson-level Blocked mark; a Blocked lesson does not hold its phase closed. Nothing here edits either
register.

---

## Resolved decisions

| Node | Decision | Type | Settled | Became |
| --- | --- | --- | --- | --- |
| N-001 | The model works through skills, not autonomous agent loops | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-LLM-SKILLS-NOT-AGENTS-27-09-2026.md` |
| N-002 | A budget and a threat model on every LLM milestone; safetensors only; scrubbed data; sandboxed code | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-LLM-EFFICIENCY-AND-SECURITY-FIRST-27-09-2026.md` |
| N-003 | Apache-2.0-only crates admitted by documented per-crate exception; repository stays GPL-2.0-only | explain-first | 27/09/2026 | `project-management/src/08-DECISIONS/ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md` |

---

## Slices

Filled at CUT; candidates in `ROADMAP.md` → L1 … L6.

| Slice | Milestone | Title | Nodes | Mastery (what must be true) | Flags |
| --- | --- | --- | --- | --- | --- |
| S-01 | — | cut after the blocking nodes resolve — candidates in `project-management/src/01-ROADMAP/ROADMAP.md` → L1…L6 | — | — | — |

---

## Frontier

| Node | Decision | Type | Blocked by | Blocking a milestone? |
| --- | --- | --- | --- | --- |
| N-004 | One base with LoRA adapters per domain, coding first | explain-first | measured at `llm-20` (adapter quality and multi-adapter cost); `ADR-…-LLM-BASE-MODEL-PLUS-ADAPTERS` is Proposed | no |
| N-005 | The PyTorch build and CUDA support for sm_75 on driver 580 | research | `research/PYTORCH-SM75-SUPPORT.md` and `CUDA-TOOLKIT-FOR-DRIVER-580.md` (planned) | no |
| N-006 | The sandbox launcher's design (namespaces, seccomp, Landlock) | research | `research/LLM-SANDBOX-DESIGN.md` (planned); owned by `sec-04` | no |
| N-007 | The ~1B base's compute budget and GPU provider | research | `GAPS.md` → "L6 compute budget and provider not chosen"; prices checked on the day | no |
| N-008 | The training-data source and the models' licence: The Stack v2's terms bind a model trained on it to Software Heritage's principles (released under a suitable open licence with the documentation and tooling to use it, its training data identified by SWHID); The Stack v3 is ODC-By and carries no such clause | explain-first | decided at `llm-10` lesson 02 | no |

**Blocking a milestone?** None blocks: L1 needs no CUDA (it uses ollama and CPU/GPU PyTorch), and each
later blocker is scoped to the lesson that needs it, which is `Blocked` until its tool is installed
without holding the phase closed.

---

## Fog of war

- The exact open coding model and quantisation for the L1 baseline (chosen against ~9 GiB free VRAM
  on the day, since models and registries move).
- Whether the ~100M model's tokeniser is reused unchanged for the ~1B base (a map node at `llm-11`).
- The domain adapters beyond coding (legal, HR, finance, business) — parked in `DEFERRED.md` (L6),
  only with retrieval from authoritative UK sources and as assistants to professionals.
- Where the work lands: this repository keeps the lessons, notes and small exercises; the
  model-training and inference repositories are created when each build starts, with names and
  licences Sam chooses (`project-management/src/08-DECISIONS/ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md`
  → the repository boundary).

---

## Out of scope

| Ruled out | Why |
| --- | --- |
| Autonomous agent loops | small model, tight VRAM; skills keep the context short — `ADR-MS001-LLM-SKILLS-NOT-AGENTS-27-09-2026.md` |
| Loading untrusted pickle checkpoints | arbitrary code execution; safetensors or `weights_only=True` only — `ADR-MS001-LLM-EFFICIENCY-AND-SECURITY-FIRST-27-09-2026.md` |
| Renting GPUs before the pipeline is proven at ~100M locally | cost; prove locally first — `ADR-MS001-LLM-BASE-MODEL-PLUS-ADAPTERS-27-09-2026.md` |
| Running model- or skill-generated code outside the sandbox | excessive agency; sandbox with no network, rlimits, timeouts |

---

## Session log

| Date | Node settled | Outcome | Frontier redrawn |
| --- | --- | --- | --- |
| 27/09/2026 | N-001, N-002, N-003 | three ADRs in `project-management/src/08-DECISIONS/` | [x] |

---

## Gate to milestones

- [ ] Destination and out-of-scope bounds agreed with the learner
- [ ] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes, blocks or unrelated
- [ ] Every claimed entry names what will retire it; **neither register edited here**
- [ ] Every knowable decision is a node or sits in fog of war
- [ ] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a milestone" is resolved**
- [ ] Every resolved node links to the artefact it became
- [ ] **Every slice has a mastery line and a flag manifest**
- [ ] Index row in `project-management/src/01-ROADMAP/CONTEXT.md` current

**Milestones may be cut in `project-management/workflows/02-milestone-creation/` once every box above
is ticked.** This map is `Charting`; those boxes are unticked by design.
