# Resources — llm-11-tokenizer

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 byte-level BPE | arXiv:1508.07909v5, Section 3.2; GPT-2 paper, Section 2.2 (<https://cdn.openai.com/better-language-models/language_models_are_unsupervised_multitask_learners.pdf>); minbpe at 1acefe8 (<https://github.com/karpathy/minbpe/tree/1acefe89412b20245db5a22d2a02001e547dc602>) | `code/docs/PYTHON-CODING-PRINCIPLES.md` (planned — added at L1) | `code/src/python/` (planned — added at L1) |
| 02 pre-tokenisation for code | openai/gpt-2 `src/encoder.py` at 9b63575 (<https://github.com/openai/gpt-2/blob/9b63575ef42771a015060c964af2c3da4cf7c8ab/src/encoder.py>); arXiv:2107.03374v2, Section 3.2 | `code/docs/PYTHON-CODING-PRINCIPLES.md` (planned — added at L1) | `code/src/python/` (planned) |
| 03 training with tokenizers | Hugging Face tokenizers Quicktour (<https://huggingface.co/docs/tokenizers/quicktour>) and Components (<https://huggingface.co/docs/tokenizers/components>) | — | the model-training repository (created when this build starts) |
| 04 special tokens | arXiv:2207.14255v1, Section 3; minbpe README (`allowed_special`) | `code/docs/TESTING.md` — Section 3 | `code/src/python/` (planned); the model-training repository |
| 05 compression per language | arXiv:2001.08361v1, Section 2.1 and Table 1 | `code/docs/PYTHON-CODING-PRINCIPLES.md` (planned — added at L1) | `code/src/python/` (planned) |
| 06 Rust encoder | docs.rs `tokenizers` 0.23.2 (<https://docs.rs/crate/tokenizers/0.23.2>) and `serde_json` 1.0.151 (<https://docs.rs/crate/serde_json/1.0.151>); arXiv:1508.07909v5, Section 3.2 | `code/docs/RUST-CODING-PRINCIPLES.md`; `code/docs/TESTING.md` — Section 2 | `code/src/rust/crates/msNNN_<snake>/` |
| 07 shared tokeniser | arXiv:2302.01318v1, Algorithm 2; arXiv:2211.17192v2, Section 2 | `project-management/workflows/08-decisions/` | — |
