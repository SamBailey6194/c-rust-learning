# Resources — llm-05-tiny-gpt

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Character data, splits and batches | Zero to Hero Lecture 7, <https://github.com/karpathy/nn-zero-to-hero> (MIT, commit 73c3fcc); Project Gutenberg licence policy, <https://www.gutenberg.org/policy/license.html> (read 27/09/2026) | `code/docs/TESTING.md` | `code/src/python/` (planned — added at L1) |
| 02 The GPT as PyTorch modules | PyTorch 2.14 `scaled_dot_product_attention`, <https://docs.pytorch.org/docs/2.14/generated/torch.nn.functional.scaled_dot_product_attention.html>; nanochat, <https://github.com/karpathy/nanochat> (MIT, commit 92d63d4) | `code/docs/TESTING.md` | `code/src/python/` (planned — added at L1) |
| 03 The training loop on CPU and GPU, measured against a budget | PyTorch 2.14 "CUDA semantics → Memory management", <https://docs.pytorch.org/docs/2.14/notes/cuda.html>; `max_memory_allocated`, <https://docs.pytorch.org/docs/2.14/generated/torch.cuda.memory.max_memory_allocated.html> | `project-management/docs/VERIFICATION-GUIDE.md` | `code/src/python/` (planned — added at L1) |
| 04 Mixed precision on Turing: fp16 autocast and GradScaler | PyTorch 2.14 AMP, <https://docs.pytorch.org/docs/2.14/amp.html>; AMP examples, <https://docs.pytorch.org/docs/2.14/notes/amp_examples.html>; Micikevicius et al., arXiv:1710.03740 | — | `code/src/python/` (planned — added at L1) |
| 05 Sampling: temperature, top-k and top-p | Holtzman et al., arXiv:1904.09751, Sections 3.1–3.3; Fan et al., arXiv:1805.04833 | — | `code/src/python/` (planned — added at L1) |
| 06 Validation, overfitting and safe checkpoints | safetensors README → "Format", <https://github.com/safetensors/safetensors> (commit e246a25); PyTorch 2.14 "Serialization semantics", <https://docs.pytorch.org/docs/2.14/notes/serialization.html> | `project-management/docs/SAFETY-GUIDE.md` | `code/src/python/` (planned — added at L1) |
