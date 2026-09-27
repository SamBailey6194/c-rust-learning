# Mission — llm-16-skills-layer

**Started**: not yet · **Family**: llm · **Phase**: L5 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam wants "a proper coding LLM, using skills not agents", and a model that works through "Markdown
for skills, workflows, doc guidance". He already works that way every day in this repository, where
`/teach`, `/research`, `/handoff` and `/wait-what` are skills, and in llm-01 he wrote three by hand
and logged where a local model fell short. This topic turns that practice into a loader he owns, in
Rust: find the skills, show the model a small catalogue, load one skill when it is needed, keep the
context and its KV cache inside a measured budget, and replay the gap log automatically. The gaps
then become the skill-use training data that post-training (llm-20) needs, and the loader is what a
Syntek OS package of skills (os-17) will ship with.

## Can do it when

- Sam can explain progressive disclosure and argue skills over an agent loop for a small model, with
  the token and KV cost in the argument.
- Sam can check a SKILL.md against the Agent Skills specification with his own linter.
- Sam can build a skill catalogue in Rust with scope precedence, lenient validation and a trust gate.
- Sam can activate skills inside a stated token and KV-byte budget, constrained to valid names.
- Sam can move a long procedure into a workflow-shaped reference file without losing a step.
- Sam can replay llm-01's gap log repeatably through the Rust loader and compare it with the manual
  results.
- Sam can produce skill-use traces with a task-level split, a tested scrub and a dataset card.
- The skill-lint, skill-catalogue and skill-budget crates pass `cargo test` and `cargo clippy`.

## Parked for later

- Retrieval over Markdown docs and citations — llm-17.
- Running skill scripts, and the threat model of the skill loop — llm-18.
- Training on the skill-use traces — llm-20.
- Shipping skills as a Syntek OS package with a per-skill policy — os-17.
- Red-teaming the loader with an adversarial suite — sec-15.
