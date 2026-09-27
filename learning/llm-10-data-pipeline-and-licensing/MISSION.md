# Mission — llm-10-data-pipeline-and-licensing

**Started**: not yet · **Family**: llm · **Phase**: L4 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

I asked "how about building from scratch?" — a small code model of my own, trained on the languages I actually use (C,
Rust, Python, Nix, PHP, shell). From-scratch training starts with data, and most of the work is there: data I am
allowed to use, sized to what my budget can train on, cleaned of duplicates, secrets and personal details, and
documented well enough that anyone could see where every file came from. The model is meant to be secure; that starts
with what it is trained on.

## Can do it when

- Derive a token target for a ~100M-parameter model from Chinchilla and turn it into a disk budget.
- Explain what The Stack v2 and v3 provide, what their terms require of a trained model, and how opt-outs reach a local
  copy.
- Filter code by licence, excluding unlicensed files, while keeping the provenance needed for attribution.
- Remove exact and near-duplicates with MinHash and locality-sensitive hashing, and explain the threshold.
- Decontaminate training data against the evaluation sets before training.
- Apply quality heuristics and choose a language mix with recorded reasons.
- Redact secrets and personal data, tested only on fabricated examples, and say what scrubbing misses.
- Write a dataset card and manifest that trace any file back to its source.

## Parked for later

- Instruction and skill-use data for post-training — llm-20.
- Retrieval corpora of documentation — llm-17.
- Poisoning attacks on training data as a threat — llm-18.
- Live malware analysis — never here (`DEFERRED.md`); the pipeline only reads how The Stack v2 removed malware.
