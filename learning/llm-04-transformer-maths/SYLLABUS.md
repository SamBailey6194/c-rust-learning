# Syllabus — llm-04-transformer-maths

**Track**: llm · **Phase**: L1 · **Path**: Core · **Detail**: full · **Prerequisites**: llm-03 (all lessons, or tested out)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The decoder-only transformer, one piece at a time, in numpy, with every shape written down and every
piece checked against PyTorch. Tokens become vectors, attention mixes them under a causal mask,
several heads run side by side, and an MLP, residual connections and layer norm complete the block;
the topic ends with a full forward pass whose logits match a PyTorch reference model. Counting its
parameters and FLOPs along the way gives the numbers the efficiency lessons reuse: weight bytes
(llm-01, llm-07), `6N` training compute (llm-12) and the KV cache (llm-15). llm-05 trains the same
architecture in PyTorch; llm-09 reads it in C.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Tokens, vocabulary and embeddings | 1 sitting | yes — embedding lookup | Efficiency |
| 02 | Counting FLOPs and a numerically stable softmax | 1 sitting | yes — FLOP counter and stable softmax | Efficiency |
| 03 | Self-attention with a causal mask | 2–3 sittings | yes — one causal head | Efficiency |
| 04 | Multi-head attention, step by step with shapes | 1 sitting | yes — multi-head attention | — |
| 05 | The block: MLP, residual connections and layer norm | 1 sitting | yes — one block and its parameter count | Efficiency |
| 06 | A numpy forward pass checked against PyTorch | multi-session build | yes — full forward pass | Efficiency |

**Where the work lands.** Small exercises in this repository under `code/src/python/` (planned —
added at L1), each lesson extending the same numpy module and its pytest suite, on the CPU so CI
runs it.

---

## 01 — Tokens, vocabulary and embeddings

- **Objective:** Sam can explain how text becomes token ids, how an embedding table turns ids into
  vectors, and count the embedding parameters of a given configuration.
- **Builds on:** llm-03 lessons 01 and 05 (shapes; the bigram model's vocabulary).
- **Key ideas:**
  - A tokeniser maps text to ids from a fixed vocabulary: characters here, subword units from
    byte-pair encoding later (llm-11). GPT-2's byte-level vocabulary has 50,257 entries.
  - An embedding is a row lookup in a `(vocab, d_model)` matrix — the same result as a one-hot
    vector times that matrix, without the multiply.
  - Attention has no notion of order, so position is added: learned position embeddings (as in
    nanoGPT's `wpe`) or the fixed sinusoids of the original paper.
  - The input embedding and the output projection can share one matrix (weight tying), saving
    `vocab * d_model` parameters.
  - Embedding parameters are left out of N in the scaling-law paper's compute estimate — state which
    N a calculation uses.
- **Recall targets:** count the embedding parameters for a stated vocabulary and width; explain why
  a lookup equals a one-hot matmul; say why position must be added.
- **Build:** a numpy token and position embedding, tested against a one-hot matmul and against
  `torch.nn.Embedding` with the same weights.
- **Efficiency lens:** embedding bytes as a share of total weight bytes for a small and a large
  vocabulary.
- **Sources:** Vaswani et al., "Attention Is All You Need", arXiv:1706.03762, Sections 3.4
  "Embeddings and Softmax" and 3.5 "Positional Encoding"; Radford et al., "Language Models are
  Unsupervised Multitask Learners" (GPT-2), Sections 2.2–2.3
  (<https://cdn.openai.com/better-language-models/language_models_are_unsupervised_multitask_learners.pdf>);
  Sennrich et al., arXiv:1508.07909; PyTorch 2.14 `torch.nn.Embedding`
  (<https://docs.pytorch.org/docs/2.14/generated/torch.nn.Embedding.html>).
- **Done when:** the embedding tests pass and Sam counts a new configuration's embedding parameters
  unaided.

## 02 — Counting FLOPs and a numerically stable softmax

- **Objective:** Sam can estimate a transformer's forward and training FLOPs per token from its
  configuration, and implement a softmax that cannot overflow.
- **Builds on:** lesson 01; llm-03 lessons 01 and 05.
- **Key ideas:**
  - Each weight is used in one multiply-add per token, so the forward pass costs about `2N` FLOPs
    per token, plus an attention term that grows with the context length.
  - The backward pass costs about twice the forward, giving the `6N` FLOPs per training token
    llm-12 budgets with (N excluding embeddings, as in the scaling-law paper).
  - `exp` overflows for large scores; subtracting the row maximum first gives the same softmax and
    keeps every exponent at most zero.
  - For log-probabilities, the log-sum-exp form avoids taking the log of a rounded-to-zero value.
- **Recall targets:** estimate the training FLOPs for a stated N and token count; explain why the
  maximum is subtracted and why the result does not change.
- **Build:** a FLOP-counter function for a model configuration, tested against the paper's formulas
  on a worked example; a stable softmax tested with inputs that overflow the naive version, and
  against `torch.softmax`.
- **Efficiency lens:** predicted FLOPs per token for the llm-05 model, kept for comparison with
  measured throughput there.
- **Sources:** Kaplan et al., "Scaling Laws for Neural Language Models", arXiv:2001.08361, Section 2.1
  (equations 2.1 and 2.2); _Deep Learning_, Section 4.1 "Overflow and Underflow"
  (<https://www.deeplearningbook.org/contents/numerical.html>).
- **Done when:** both tests pass and Sam reproduces the `6N` estimate from the forward and backward
  costs without notes.

## 03 — Self-attention with a causal mask

- **Objective:** Sam can compute single-head self-attention with a causal mask by hand in numpy and
  show that no position can see the future.
- **Builds on:** lessons 01–02.
- **Key ideas:**
  - Queries, keys and values are three linear projections of the same input.
  - Scores are query-key dot products divided by the square root of the key width; without the
    scaling, large dot products push the softmax into regions with tiny gradients.
  - The causal mask sets every score for a later position to minus infinity before the softmax, so
    its weight is exactly zero.
  - The output is a weighted sum of values; the score matrix is `T * T` per head, so memory and
    compute grow with the square of the context.
- **Recall targets:** write the attention formula with shapes; predict the attention weights of the
  first position; explain what the mask does to a future token.
- **Build:** one causal head in numpy, with a test that changing tokens after position t leaves the
  output at t unchanged, and a comparison with `torch.nn.functional.scaled_dot_product_attention`
  using `is_causal=True`.
- **Efficiency lens:** bytes of the score matrix at 1k and 8k tokens — the quadratic cost that
  FlashAttention (llm-19) avoids storing.
- **Sources:** Vaswani et al., arXiv:1706.03762, Sections 3.2.1 "Scaled Dot-Product Attention" and
  3.2.3 "Applications of Attention in our Model"; PyTorch 2.14 `scaled_dot_product_attention`
  (<https://docs.pytorch.org/docs/2.14/generated/torch.nn.functional.scaled_dot_product_attention.html>);
  Zero to Hero Lecture 7, "Let's build GPT" (<https://github.com/karpathy/nn-zero-to-hero>, MIT,
  commit 73c3fcc).
- **Done when:** the future-blindness test and the PyTorch comparison both pass.

## 04 — Multi-head attention, step by step with shapes

- **Objective:** Sam can split attention into heads, write the shape of every intermediate tensor,
  and recombine the heads through the output projection.
- **Builds on:** lesson 03.
- **Key ideas:**
  - `d_model` is split into h heads of width `d_model / h`; each head attends independently.
  - The reshape path: `(B, T, d_model)` → `(B, T, h, d_head)` → `(B, h, T, d_head)`, attention per
    head, then back and concatenated.
  - An output projection mixes the heads back into the residual width.
  - The parameter count equals one wide head's, but several narrow heads can attend to different
    positions at once.
- **Recall targets:** write every shape on the path for stated B, T, d_model and h; explain why the
  parameter count does not change with h.
- **Build:** multi-head attention in numpy with a shape assertion at every step, compared with
  per-head `scaled_dot_product_attention` in PyTorch.
- **Sources:** Vaswani et al., arXiv:1706.03762, Section 3.2.2 "Multi-Head Attention"; PyTorch 2.14
  `scaled_dot_product_attention`.
- **Done when:** the comparison passes and Sam writes the shape path from memory.

## 05 — The block: MLP, residual connections and layer norm

- **Objective:** Sam can assemble a transformer block (pre-norm, as GPT-2 arranges it), explain what
  each part is for, and count its parameters.
- **Builds on:** lessons 03–04; llm-03 lesson 08 (layer norm).
- **Key ideas:**
  - The position-wise MLP is two linear maps with a non-linearity between, the inner width four
    times `d_model` in the original paper; nanoGPT's GPT-2 reproduction uses GELU instead of ReLU.
  - Residual connections add each sub-layer's output to its input, giving gradients a direct path
    through a deep stack.
  - Layer norm rescales each position's vector; GPT-2 moved it to the input of each sub-block and
    added one after the last block.
  - Attention and MLP weights together come to about `12 * n_layer * d_model^2` parameters when
    the MLP is four times wide.
- **Recall targets:** draw the pre-norm block from memory; derive the `12 * d_model^2` count per
  layer.
- **Build:** one block in numpy, a test that its parameter count matches the formula (plus biases
  and norm parameters, stated), and a comparison with the same block in PyTorch.
- **Efficiency lens:** parameters and fp32 bytes per block for the llm-05 configuration.
- **Sources:** Vaswani et al., arXiv:1706.03762, Section 3.3 "Position-wise Feed-Forward Networks";
  He et al., arXiv:1512.03385; Ba et al., arXiv:1607.06450; Hendrycks and Gimpel (GELU),
  arXiv:1606.08415; GPT-2 paper, Section 2.3 "Model"; Kaplan et al., arXiv:2001.08361, equation 2.1.
- **Done when:** the block matches PyTorch's and the parameter test passes.

## 06 — A numpy forward pass checked against PyTorch

- **Objective:** Sam can run a complete decoder-only forward pass in numpy — embeddings, a stack of
  blocks, the final norm and the logits — and match a PyTorch model given the same weights.
- **Builds on:** lessons 01–05.
- **Key ideas:**
  - The whole model is the lesson 05 block repeated, bracketed by embeddings and a final projection
    to vocabulary logits.
  - Matching two implementations means identical weights, identical ordering of operations that
    matter, and a stated tolerance — float results differ in the last bits.
  - The loss on a batch closes the loop to llm-03 lesson 05: logits → cross-entropy.
  - nanoGPT's `model.py` (MIT, deprecated by its author) is a readable reference for the same
    architecture; nanochat is the maintained successor.
- **Recall targets:** list the forward pass in order with shapes; explain why a tolerance is needed
  when comparing.
- **Build:** the full numpy forward pass and a small PyTorch reference model Sam writes himself; a
  test copies weights across and asserts matching logits and loss with
  `torch.testing.assert_close`; CPU only.
- **Efficiency lens:** time the numpy forward per token and compare with the lesson 02 FLOP
  estimate to get achieved GFLOP/s.
- **Sources:** GPT-2 paper, Section 2.3; nanoGPT `model.py` as reading
  (<https://github.com/karpathy/nanoGPT>, MIT, commit 3adf61e, deprecated); nanochat
  (<https://github.com/karpathy/nanochat>, MIT, commit 92d63d4); PyTorch 2.14 `torch.testing`
  (<https://docs.pytorch.org/docs/2.14/testing.html>).
- **Done when:** logits and loss match to the stated tolerance and the GFLOP/s figure is recorded.
