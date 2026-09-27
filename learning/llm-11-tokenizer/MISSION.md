# Mission — llm-11-tokenizer

**Started**: not yet · **Family**: llm · **Phase**: L4 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

The planning conversation named "own tokenizer" as one of the stages of building my model from scratch, and it matters
more than it looks: it decides how many tokens my code costs, how big the KV cache gets for a skill, and whether a small
model can later speed up a bigger one. I want the model to work through Markdown skills, so the tokeniser also has to
reserve the control tokens for fill-in-the-middle and skills — and make sure no file can forge them.

## Can do it when

- Train byte-level BPE from scratch and explain why decoding always returns the input.
- Split code before BPE so merges respect its structure, and show the effect on token counts.
- Train a code tokeniser on my corpus with Hugging Face tokenizers and justify its vocabulary size.
- Reserve FIM and skill control tokens and prove that ordinary text never produces them.
- Report compression per language and relate vocabulary size to parameters and compute.
- Encode in Rust with a hand-written merge loop that matches the Python library token for token.
- Explain why the draft and target models must share this tokeniser, and record that decision.

## Parked for later

- Using the tokeniser in the inference server — llm-14.
- Speculative decoding itself — llm-15.
- Chat templates and instruction formats — llm-20.
