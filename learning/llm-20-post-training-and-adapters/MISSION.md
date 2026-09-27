# Mission — llm-20-post-training-and-adapters

**Started**: not yet · **Family**: llm · **Phase**: L6 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam wants to "build a base LLM, then Coding/Legal/HR/Finance/Business versions", and wants the model
to be "a proper coding LLM, using skills not agents". Both land here. The versions are LoRA adapters
on one base rather than separate models, which is what makes them affordable; the skill use is taught
by fine-tuning on the traces llm-16 turned out of llm-01's gap log; and code gets better by rewarding
solutions that pass their tests in the sandbox. Coding comes first because tests can judge it. The
other domains wait, parked, until the coding adapter has proved the pipeline — and then only with
retrieval from authoritative UK sources and as an assistant to professionals. This topic also
produces the two measurements the base-plus-adapters ADR needs to move from Proposed to Accepted.

## Can do it when

- Sam can check that training and serving render a conversation to the same tokens.
- Sam can build a skill-use SFT set with a task-level split and a data card.
- Sam can train a LoRA adapter and predict its size and VRAM.
- Sam can run QLoRA on this card with an fp16 compute type inside the ~9 GiB budget.
- Sam can run one round of rejection sampling with every generated solution executed in the sandbox.
- Sam can show whether a coding adapter beats its base on the task suite and the held-out skill
  traces.
- Sam can measure the throughput cost of serving two adapters against one.
- Sam can state the conditions for a responsible domain variant.

## Parked for later

- Legal, HR, finance and business adapters — `DEFERRED.md` (L6).
- Full reinforcement learning from human feedback at scale — beyond this topic's small experiment.
- Training the ~1B base the adapters sit on — llm-21.
