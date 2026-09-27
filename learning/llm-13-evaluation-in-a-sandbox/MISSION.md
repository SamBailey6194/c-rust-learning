# Mission — llm-13-evaluation-in-a-sandbox

**Started**: not yet · **Family**: llm · **Phase**: L4 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

"Evaluation (HumanEval-style + own tasks)" was one of the stages the conversation laid out for my own code model. I need
to know honestly whether the model I trained is any good at the code I write — and scoring a code model means running
the code it generates, which must never happen outside a sandbox. The model is meant to be secure; that includes how I
test it.

## Can do it when

- Report held-out perplexity and bits per byte per language on a split made by repository.
- Show, for every reported score, that the benchmark does not overlap the training data.
- Run generated code only inside the sandbox, with each limit proven against a misbehaving program.
- Report pass rate and exact match on single- and multi-line HumanEval infilling in PSM and SPM.
- Compute pass@k with the unbiased estimator and explain why the naive method misleads.
- Choose evaluations that move at ~100M parameters, with a reason for each.
- Maintain a private, versioned task suite in my own languages, kept out of training data.

## Parked for later

- Evaluating skill-following and adapters — llm-20.
- Evaluating retrieval — llm-17.
- Adversarial and red-team evaluation — llm-18 and sec-15.
