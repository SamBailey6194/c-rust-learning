# Mission — sec-15-red-teaming-the-llm

**Started**: not yet · **Family**: sec · **Phase**: S3 · **Milestone**: not yet allocated

## Why

Sam's model is designed to work through skills, docs and repositories — the same channels an
attacker uses for prompt injection. Security is a first-class goal of the LLM, measured on every
milestone, so the model has to be tested the way it will be attacked: adversarial input through the
skill loader, jailbreaks, and attempts to extract its prompt or skills. This topic red-teams Sam's
own model and turns the results into a suite that keeps it honest as it changes. It is the offensive
mirror of llm-18's defences, run only against systems Sam owns.

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

## Can do it when

- Sam can map the OWASP Top 10 for LLM Applications onto his own skill loader, docs and repositories.
- Sam can build a corpus of prompt-injection tests that exercise the loader's trust boundaries.
- Sam can measure his model's susceptibility to jailbreaks and data extraction.
- Sam can turn the corpus into an automated adversarial suite that runs on every model or skill change.
- Sam can name the defences and explain why none is complete.

## Parked for later

- Implementing the sandbox and per-skill policy the defences rely on — sec-04 and llm-18 own those.
- Post-training the model to resist these attacks — llm-20 (post-training and adapters).
