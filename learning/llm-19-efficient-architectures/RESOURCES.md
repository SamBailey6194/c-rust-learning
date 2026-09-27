# Resources — llm-19-efficient-architectures

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Multi-query attention revisited: the limit of GQA | Shazeer, arXiv:1911.02150; Ainslie et al., arXiv:2305.13245 (checked 27/09/2026; re-verify at L6) | `code/docs/RUST-CODING-PRINCIPLES.md` — Section 3 | `code/src/rust/crates/msNNN_kv_budget/` (planned, from llm-15) |
| 02 Multi-head latent attention: compressing the KV cache | DeepSeek-V2, arXiv:2405.04434, Sections 2.1.2–2.1.3 | `code/docs/RUST-CODING-PRINCIPLES.md` — Section 3 | `code/src/rust/crates/msNNN_kv_budget/` (planned, from llm-15) |
| 03 FlashAttention, and what Turing can run | Dao et al., arXiv:2205.14135; Dao, arXiv:2307.08691; PyTorch 2.14 SDPA, <https://docs.pytorch.org/docs/2.14/generated/torch.nn.functional.scaled_dot_product_attention.html>; `sdpa_kernel`, <https://docs.pytorch.org/docs/2.14/generated/torch.nn.attention.sdpa_kernel.html>; PyTorch v2.14.0 `sdp_utils.cpp`, <https://github.com/pytorch/pytorch/blob/v2.14.0/aten/src/ATen/native/transformers/cuda/sdp_utils.cpp>; FlashAttention README, <https://github.com/Dao-AILab/flash-attention> | — | `code/src/python/` (planned — added at L1) |
| 04 Mixture of Experts: routing, and active against total parameters | Shazeer et al., arXiv:1701.06538; Switch Transformers, arXiv:2101.03961; Mixtral, arXiv:2401.04088; DeepSeek-V2, arXiv:2405.04434 | — | `code/src/python/` (planned — added at L1) |
| 05 Quantisation-aware training | Jacob et al., arXiv:1712.05877; LLM-QAT, arXiv:2305.17888; torchao 0.17 QAT, <https://docs.pytorch.org/ao/stable/workflows/qat.html> | — | the model-training repository (created when this build starts) |
| 06 Choosing an architecture under a VRAM and compute budget | Hoffmann et al., arXiv:2203.15556, Table 3; Kaplan et al., arXiv:2001.08361, Sections 1.3 and 2.1 | `project-management/workflows/08-decisions/` | `project-management/src/08-DECISIONS/` (the architecture ADR) |
