# Resources — llm-04-transformer-maths

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Tokens, vocabulary and embeddings | Vaswani et al., arXiv:1706.03762, Sections 3.4–3.5; GPT-2 paper, Sections 2.2–2.3, <https://cdn.openai.com/better-language-models/language_models_are_unsupervised_multitask_learners.pdf>; PyTorch 2.14 `torch.nn.Embedding`, <https://docs.pytorch.org/docs/2.14/generated/torch.nn.Embedding.html> | `code/docs/TESTING.md` | `code/src/python/` (planned — added at L1) |
| 02 Counting FLOPs and a numerically stable softmax | Kaplan et al., arXiv:2001.08361, Section 2.1; _Deep Learning_ Section 4.1, <https://www.deeplearningbook.org/contents/numerical.html> | — | `code/src/python/` (planned — added at L1) |
| 03 Self-attention with a causal mask | Vaswani et al., arXiv:1706.03762, Sections 3.2.1 and 3.2.3; PyTorch 2.14 `scaled_dot_product_attention`, <https://docs.pytorch.org/docs/2.14/generated/torch.nn.functional.scaled_dot_product_attention.html> | — | `code/src/python/` (planned — added at L1) |
| 04 Multi-head attention, step by step with shapes | Vaswani et al., arXiv:1706.03762, Section 3.2.2 | — | `code/src/python/` (planned — added at L1) |
| 05 The block: MLP, residual connections and layer norm | Vaswani et al., arXiv:1706.03762, Section 3.3; He et al., arXiv:1512.03385; Ba et al., arXiv:1607.06450; GPT-2 paper, Section 2.3; Kaplan et al., arXiv:2001.08361, equation 2.1 | — | `code/src/python/` (planned — added at L1) |
| 06 A numpy forward pass checked against PyTorch | nanoGPT `model.py`, <https://github.com/karpathy/nanoGPT> (MIT, commit 3adf61e, deprecated — reading only); nanochat, <https://github.com/karpathy/nanochat> (MIT, commit 92d63d4); PyTorch 2.14 `torch.testing`, <https://docs.pytorch.org/docs/2.14/testing.html> | `code/docs/TESTING.md` | `code/src/python/` (planned — added at L1) |
