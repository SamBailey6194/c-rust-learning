# Mission — llm-03-neural-network-foundations

**Started**: not yet · **Family**: llm · **Phase**: L1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam wants to build and train his own model "from scratch", not only call someone else's. Training
from scratch, and later following llm.c in C, means understanding what a framework does for him:
how a gradient is computed, what the loss is measuring, why AdamW needs extra memory for every
parameter, and why fp16 on this card needs loss scaling. This topic builds those pieces by hand and
checks each one against PyTorch, so that nothing in the later training and efficiency work is a black
box. Any lesson he already knows can be tested out.

## Can do it when

- Sam can predict broadcast shapes and count the FLOPs of a matmul.
- Sam can apply the chain rule over a computation graph and check any gradient numerically.
- Sam's scalar autograd engine matches PyTorch's gradients on random expressions.
- Sam can train an MLP with a validation split and diagnose overfitting from the curves.
- Sam can compute cross-entropy and perplexity by hand and match `cross_entropy`.
- Sam's SGD, momentum and AdamW steps match `torch.optim` step for step, and he can say what
  warm-up, cosine decay and clipping each prevent.
- Sam can compare fp32, fp16 and bf16 and demonstrate loss scaling rescuing an underflowing gradient.
- Sam's hand-written backward passes for matmul, softmax with cross-entropy and layer norm pass both
  numerical and PyTorch checks.

## Parked for later

- Attention, residual streams and the transformer block — llm-04.
- Mixed precision in a real training loop with `GradScaler` — llm-05.
- The same backward passes in C — llm-09.
