# Syllabus — llm-11-tokenizer

**Track**: llm · **Phase**: L4 · **Path**: Core · **Detail**: full · **Prerequisites**: llm-10
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

A tokeniser decides what the model sees, how many tokens a file costs, and therefore how much compute and KV cache every
request needs. This topic builds byte-level BPE from scratch, trains a code tokeniser on llm-10's corpus, reserves the
special tokens that fill-in-the-middle and the skills layer need, measures compression per language, and re-implements
encoding in Rust for inference. It ends with a decision that ties the track together: this tokeniser is reused for the
later ~1B base so the ~100M model can serve as its speculative-decoding draft. Concept exercises land under
`code/src/python/` (planned — added at L1) and `code/src/rust/crates/msNNN_<snake>/`; training on the real corpus
lands in the model-training repository (created when this build starts), and the Rust encoder moves into the inference
repository when that build starts.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Byte-level BPE from scratch | 2–3 sittings | yes — BPE trainer and encoder in Python | — |
| 02 | Pre-tokenisation for code | 1 sitting | yes — a pre-tokeniser for the lesson 01 BPE | Efficiency |
| 03 | Training a code tokeniser with Hugging Face tokenizers | 1 sitting | yes — the corpus tokeniser | Efficiency |
| 04 | Special tokens for fill-in-the-middle and skills | 1 sitting | yes — special-token tests | Security |
| 05 | Measuring compression per language | 1 sitting | yes — a compression report | Efficiency |
| 06 | A BPE encoder in Rust for inference | 2–3 sittings | yes — Rust encoder matching Python | Efficiency, Security |
| 07 | One tokeniser for the draft and the target | 1 sitting | no | Efficiency |

---

## 01 — Byte-level BPE from scratch

- **Objective:** Sam can train a byte-level BPE vocabulary on text, encode and decode with it, and explain why decoding
  an encoding always gives back the input.
- **Builds on:** llm-05's character-level model (a vocabulary of characters); llm-04 (tokens and embeddings).
- **Key ideas:**
  - BPE starts from single symbols and repeatedly merges the most frequent adjacent pair into a new symbol, recording
    each merge in order.
  - Starting from the 256 byte values means any input — any language, any Unicode — can be encoded, with no unknown
    token.
  - Training learns the merge list; encoding replays it on new text; decoding concatenates the bytes back.
  - Vocabulary size is a choice: each merge adds one token.
- **Recall targets:** the merge loop in words; why bytes rather than Unicode code points; what is stored after
  training.
- **Build:** a BPE trainer, encoder and decoder written from scratch under `code/src/python/` (planned — added at L1);
  tests check the round trip on ASCII, multi-byte UTF-8 and binary-looking input, and a hand-worked merge sequence on a
  tiny text.
- **Sources:**
  - Sennrich, Haddow and Birch, "Neural Machine Translation of Rare Words with Subword Units", arXiv:1508.07909v5,
    Section 3.2
  - Radford et al., GPT-2, Section 2.2 Input Representation:
    <https://cdn.openai.com/better-language-models/language_models_are_unsupervised_multitask_learners.pdf>
  - karpathy/minbpe (MIT) at 1acefe8, README (reading only; Sam's code is his own):
    <https://github.com/karpathy/minbpe/tree/1acefe89412b20245db5a22d2a02001e547dc602>
- **Done when:** the tests pass, and Sam explains the round-trip guarantee unaided.

## 02 — Pre-tokenisation for code

- **Objective:** Sam can split text into chunks before BPE so that merges never cross category boundaries, and adapt
  the split for source code.
- **Builds on:** lesson 01.
- **Key ideas:**
  - GPT-2 splits text with a regular expression into letters, numbers, punctuation and whitespace runs before BPE, so no
    merge crosses those boundaries.
  - Code is dominated by whitespace: Codex added tokens for runs of whitespace of different lengths and reports about
    30% fewer tokens for code.
  - The split is part of the tokeniser: training and inference must use the same one, byte for byte.
- **Recall targets:** what the pre-tokeniser prevents; why indentation matters for code; what breaks if training and
  inference split differently.
- **Build:** a pre-tokeniser for the lesson 01 BPE under `code/src/python/` (planned), with tests on code samples in
  C, Rust, Python, Nix, PHP and shell; token counts before and after in the journal.
- **Efficiency lens:** tokens per file before and after pre-tokenisation on the same samples.
- **Sources:**
  - openai/gpt-2 at 9b63575, `src/encoder.py` (the split pattern):
    <https://github.com/openai/gpt-2/blob/9b63575ef42771a015060c964af2c3da4cf7c8ab/src/encoder.py>
  - Chen et al., arXiv:2107.03374v2, Section 3.2 Methods (whitespace tokens)
  - minbpe README, `RegexTokenizer` (URL as lesson 01)
- **Done when:** the tests pass, and Sam explains the effect of whitespace tokens on code unaided.

## 03 — Training a code tokeniser with Hugging Face tokenizers

- **Objective:** Sam can train a byte-level BPE tokeniser on his filtered corpus with the Hugging Face tokenizers
  library, choose its vocabulary size, and save it in a form both Python and Rust can read.
- **Builds on:** lessons 01–02; llm-10's corpus; llm-10's language mix.
- **Key ideas:**
  - The library does at scale what lesson 01 did by hand: a model (BPE), a pre-tokeniser (ByteLevel starts from 256
    byte symbols), a trainer (`BpeTrainer` with `vocab_size` and `special_tokens`) and a decoder.
  - The trained tokeniser saves to a single JSON file holding the vocabulary, merges and configuration.
  - The tokenizers package is Apache-2.0; training runs in Python, which imports it — the rule for Python imports is
    set by the crate-licence ADR (`ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md`).
  - Train on a sample that follows the language mix, so small languages are not starved of merges.
- **Recall targets:** the four components and what each does; what is in the saved file; why the training sample
  follows the mix.
- **Build:** the corpus tokeniser, trained in the model-training repository (created when this build starts), its
  vocabulary size and training sample recorded in the dataset card from llm-10.
- **Efficiency lens:** training time and peak memory (`/usr/bin/time -v`) for the chosen sample size.
- **Sources:**
  - Hugging Face tokenizers, Quicktour ("Training the tokenizer"): <https://huggingface.co/docs/tokenizers/quicktour>
  - Hugging Face tokenizers, Components ("Pre-tokenizers" → ByteLevel):
    <https://huggingface.co/docs/tokenizers/components>
  - tokenizers 0.23.2 on PyPI (<https://pypi.org/project/tokenizers/>); licence Apache-2.0
    (<https://github.com/huggingface/tokenizers>)
- **Done when:** the tokeniser file exists in the model-training repository, its round trip passes on held-out files, and
  Sam justifies the vocabulary size.

## 04 — Special tokens for fill-in-the-middle and skills

- **Objective:** Sam can reserve the control tokens that fill-in-the-middle training and the skills layer need, and
  prove that ordinary text can never produce them.
- **Builds on:** lesson 03; llm-12's FIM objective (the tokens are reserved now, used there); llm-16's skills.
- **Key ideas:**
  - FIM training marks the prefix, suffix and middle with sentinel tokens and ends each document with an end-of-text
    token; each must be one reserved id, not a string BPE could also produce.
  - Skills (llm-16) may need markers too — reserve a few ids now, because adding them after pre-training changes the
    embedding table.
  - A special token must never be produced from data: if a source file happened to contain the sentinel's text and the
    encoder mapped it to the control token, the file could steer the model — minbpe's README calls this a footgun and
    makes special tokens opt-in at encode time.
  - Decoding a control token is a decision too: printed, hidden or refused.
- **Recall targets:** the FIM sentinels and their order in PSM; why each must be a single reserved id; how untrusted
  text could smuggle in a control token, and how the encoder prevents it.
- **Build:** tests, in the model-training repository and against lesson 01's tokeniser under `code/src/python/` (planned),
  that a file containing the literal sentinel strings encodes to ordinary tokens, and that the sentinels round-trip
  only when explicitly requested.
- **Security lens:** special-token injection is prompt injection at the tokeniser level; it feeds llm-18's threat
  model.
- **Sources:**
  - Bavarian et al., "Efficient Training of Language Models to Fill in the Middle", arXiv:2207.14255v1, Section 3
    (sentinel tokens, PSM, EOT)
  - minbpe README, the `allowed_special` discussion (URL as lesson 01)
- **Done when:** the injection tests pass, and Sam explains the risk and the defence unaided.

## 05 — Measuring compression per language

- **Objective:** Sam can measure how many bytes each token carries for each language in his mix, and relate vocabulary
  size to embedding parameters and output cost.
- **Builds on:** lessons 02–04; llm-10's language mix.
- **Key ideas:**
  - Compression is bytes per token on held-out files, per language; a language that compresses badly costs more
    compute and more KV cache for the same code.
  - The embedding table has one row per token; the output projection costs FLOPs per token in proportion to the
    vocabulary size (Kaplan et al., Table 1).
  - For a ~100M model the embedding share of the parameters is large, which matters for llm-12's choice of N.
- **Recall targets:** how compression is measured; which languages compress worst and why; how vocabulary size moves
  the parameter count.
- **Build:** a compression report under `code/src/python/` (planned) that takes a tokeniser file and held-out samples
  and prints bytes per token per language; tests on a tiny tokeniser with known results.
- **Efficiency lens:** bytes per token per language, and the embedding parameters at the chosen vocabulary size.
- **Sources:**
  - Kaplan et al., "Scaling Laws for Neural Language Models", arXiv:2001.08361v1, Section 2.1 and Table 1
  - Hugging Face tokenizers, Quicktour (encoding and offsets; URL as lesson 03)
- **Done when:** the report is in the journal for every language in the mix, and Sam explains the worst one.

## 06 — A BPE encoder in Rust for inference

- **Objective:** Sam can load the trained tokeniser file in Rust and encode and decode with a hand-written merge loop
  that matches the Python library token for token.
- **Builds on:** lessons 01–05; P3 (ownership, error handling, testing); `code/docs/RUST-CODING-PRINCIPLES.md`.
- **Key ideas:**
  - Inference needs only encode and decode: parse the JSON file, apply the same pre-tokeniser split, replay the merges
    in rank order, map to ids.
  - The Rust `tokenizers` crate is Apache-2.0-only and would need documented per-crate exceptions in
    `code/src/rust/deny.toml` (tooling-05 lesson 02), for tokenizers and for its Apache-2.0-only dependencies esaxx-rs
    and spm_precompiled; the hand-written encoder is the lesson, and needs only
    `serde_json` (MIT OR Apache-2.0).
  - Agreement is tested, not assumed: the same held-out files through both encoders, compared id by id.
  - The encoder takes untrusted input: huge inputs, invalid UTF-8, pathological repeats.
- **Recall targets:** what inference needs from the tokeniser file; how merge ranks drive encoding; which inputs are
  hostile and what the encoder does with each.
- **Build:** a crate under `code/src/rust/crates/msNNN_<snake>/` with unit tests, an agreement test against ids the
  Python library produced for fixed files, and property tests (proptest) for the round trip on arbitrary bytes; it moves
  to the inference repository when that build starts.
- **Efficiency lens:** encode throughput (bytes per second) against the Python library on the same files, measured as
  llm-06 lesson 01 teaches.
- **Security lens:** bounded work per input and no panics on malformed input; the round trip holds for arbitrary bytes.
- **Sources:**
  - docs.rs, `tokenizers` 0.23.2 (licence Apache-2.0) and `serde_json` 1.0.151 (MIT OR Apache-2.0):
    <https://docs.rs/crate/tokenizers/0.23.2>, <https://docs.rs/crate/serde_json/1.0.151>
  - Hugging Face tokenizers, Quicktour (saving and loading; URL as lesson 03)
  - arXiv:1508.07909v5, Section 3.2 (applying merges)
- **Done when:** `cargo test` passes including the agreement and property tests, clippy and fmt are clean, and
  `code/src/scripts/rust/audit.sh` passes with no new exception.

## 07 — One tokeniser for the draft and the target

- **Objective:** Sam can explain why speculative decoding needs the draft and target models to share one vocabulary,
  and record the decision to reuse this tokeniser for the ~1B base.
- **Builds on:** lessons 03–06; the planned ~1B base on rented hardware (llm-21) and speculative decoding (llm-15).
- **Key ideas:**
  - Speculative sampling lets a small draft model propose several tokens that the large target model checks in one
    pass.
  - Its acceptance test divides the target's probability of a drafted token by the draft's probability of the same
    token, and on rejection resamples from the difference of the two distributions — so both must index one
    vocabulary.
  - Choosing now costs little; retraining a tokeniser after the ~1B base exists would orphan the ~100M model as a
    draft.
- **Recall targets:** the acceptance test in words; why a shared vocabulary is required; what the decision rules out.
- **Build:** none — the decision is recorded as a node in the LLM map (`MAP-LLM.md` in
  `project-management/src/01-ROADMAP/`) and, if Sam wants it binding, an ADR through
  `project-management/workflows/08-decisions/`.
- **Efficiency lens:** the decision exists to make llm-15's own-draft speculative decoding possible; its payoff is
  measured there.
- **Sources:**
  - Chen et al., "Accelerating Large Language Model Decoding with Speculative Sampling", arXiv:2302.01318v1, Algorithm 2
  - Leviathan, Kalman and Matias, "Fast Inference from Transformers via Speculative Decoding", arXiv:2211.17192v2,
    Section 2
- **Done when:** the decision is recorded with its reason, and Sam explains the shared-vocabulary requirement unaided.
