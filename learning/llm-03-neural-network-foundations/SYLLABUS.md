# Syllabus — llm-03-neural-network-foundations

**Track**: llm · **Phase**: L1 · **Path**: Core · **Detail**: full · **Prerequisites**: llm-02 (the uv project and PyTorch install)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The maths and mechanics under every model in the track, built by hand before any library does it
for Sam: shapes and the cost of a matmul, derivatives and the chain rule, a scalar autograd engine
checked against PyTorch, an MLP that overfits on purpose, the cross-entropy loss and perplexity that
every later training run reports, the optimisers and schedules that llm.c re-implements in C, the
floating-point formats that decide what fits in VRAM, and finally backprop by hand through the three
operations a transformer is built from. It is the bridge from Python to llm.c (llm-09 builds on
lessons 06 and 08). **Any lesson Sam already knows may be tested out at `/teach` step 2** and marked
`Tested out DD/MM/YYYY`.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Shapes, broadcasting and the cost of a matmul | 1 sitting | yes — shape and FLOP drills | Efficiency |
| 02 | Derivatives, the chain rule and a computation graph | 1 sitting | yes — gradient checker | — |
| 03 | A scalar autograd engine, checked against PyTorch | 2–3 sittings | yes — autograd engine | — |
| 04 | Gradient descent, an MLP and a train/validation split | 2–3 sittings | yes — MLP that overfits | Efficiency |
| 05 | Softmax, log-likelihood, cross-entropy and perplexity | 1 sitting | yes — bigram character model | — |
| 06 | Optimisers and schedules: SGD, momentum, AdamW, warm-up, cosine decay, clipping | 2–3 sittings | yes — optimisers checked against torch.optim | Efficiency |
| 07 | Floating point for ML: fp32, fp16, bf16 and loss scaling | 1 sitting | yes — underflow probe | Efficiency |
| 08 | Backprop by hand through matmul, softmax and layer norm | 2–3 sittings | yes — manual backward passes | — |

**Where the work lands.** Small exercises in this repository under `code/src/python/` (planned —
added at L1), tested with pytest on the CPU so CI runs them.

---

## 01 — Shapes, broadcasting and the cost of a matmul

- **Objective:** Sam can predict the result shape of numpy operations under broadcasting and count
  the floating-point operations of a matrix multiply.
- **Builds on:** llm-02 lesson 03 (tensors, shapes, dtypes); school algebra.
- **Key ideas:**
  - Vectors and matrices as arrays with shapes; a matmul of `(m, k)` by `(k, n)` gives `(m, n)`.
  - Broadcasting compares shapes from the trailing dimension; sizes must match or be 1.
  - A matmul does `m * n * k` multiply-adds, counted as `2 * m * n * k` floating-point operations
    — the same convention behind the "2N per token" forward cost in the scaling-law paper.
  - FLOPs divided by measured seconds gives achieved FLOP/s, the number llm-06 and llm-07 compare
    against hardware peaks.
- **Recall targets:** predict a broadcast result shape or say why it fails; count the FLOPs of a
  given matmul unaided.
- **Build:** shape and FLOP drills — pytest cases where Sam writes the predicted shape or FLOP count
  first, plus a timed CPU matmul reported in GFLOP/s; checked by the tests passing.
- **Efficiency lens:** achieved GFLOP/s of numpy's matmul on this CPU at two sizes, recorded for
  llm-06.
- **Sources:** NumPy 2.5 → "Broadcasting" (<https://numpy.org/doc/2.5/user/basics.broadcasting.html>)
  and `numpy.matmul` (<https://numpy.org/doc/2.5/reference/generated/numpy.matmul.html>);
  Deisenroth, Faisal and Ong, _Mathematics for Machine Learning_, Chapter 2 "Linear Algebra"
  (<https://mml-book.github.io/>, free PDF); Kaplan et al., arXiv:2001.08361, Section 2.1.
- **Done when:** the drills pass and Sam counts a new matmul's FLOPs correctly without notes.

## 02 — Derivatives, the chain rule and a computation graph

- **Objective:** Sam can differentiate a composed expression with the chain rule, draw it as a
  computation graph, and check any gradient numerically.
- **Builds on:** lesson 01.
- **Key ideas:**
  - A derivative is the local rate of change; a partial derivative holds the other inputs fixed.
  - The chain rule multiplies local derivatives along a path; where paths merge, their
    contributions add.
  - A computation graph makes the order explicit: forward in topological order, gradients backward
    in reverse.
  - A central finite difference gives a numerical gradient to check an analytic one against; it
    is slow and approximate, so it is a test, never the method.
- **Recall targets:** apply the chain rule to a three-step expression; explain why gradients add
  where a value is used twice.
- **Build:** a numerical gradient checker (central differences with a relative-error test), used by
  lessons 03 and 08; checked by pytest on functions whose derivatives Sam derives by hand.
- **Sources:** _Mathematics for Machine Learning_, Chapter 5 "Vector Calculus"
  (<https://mml-book.github.io/>); Goodfellow, Bengio and Courville, _Deep Learning_, Section 6.5
  "Back-Propagation and Other Differentiation Algorithms" (<https://www.deeplearningbook.org/contents/mlp.html>);
  Karpathy, "Neural Networks: Zero to Hero", Lecture 1 (<https://github.com/karpathy/nn-zero-to-hero>,
  MIT, commit 73c3fcc).
- **Done when:** the checker passes its tests and Sam derives a gradient that the checker confirms.

## 03 — A scalar autograd engine, checked against PyTorch

- **Objective:** Sam can build a scalar reverse-mode autograd engine and show that its gradients
  match PyTorch's on the same expressions.
- **Builds on:** lesson 02.
- **Key ideas:**
  - Each value remembers its inputs and the local derivative of the operation that made it.
  - Backward runs once over a topological order from the output, accumulating gradients.
  - Gradients accumulate, so they must be zeroed between steps — the same reason PyTorch has
    `zero_grad`.
  - PyTorch's autograd records the same kind of graph, for tensors instead of scalars.
- **Recall targets:** explain why backward needs a topological order; predict what happens if
  gradients are not zeroed.
- **Build:** a micrograd-style engine (add, multiply, power, a non-linearity, backward) in Sam's own
  code; tests compare every gradient with `torch.autograd` and with the lesson 02 checker on random
  expressions. Micrograd (MIT) is the reading reference, not a source to copy.
- **Sources:** micrograd (<https://github.com/karpathy/micrograd>, MIT, commit 7bc720e); Zero to Hero
  Lecture 1; PyTorch 2.14 → "Autograd mechanics" (<https://docs.pytorch.org/docs/2.14/notes/autograd.html>)
  and "Automatic differentiation package" (<https://docs.pytorch.org/docs/2.14/autograd.html>).
- **Done when:** the engine's gradients match PyTorch's to within a stated tolerance on every test.

## 04 — Gradient descent, an MLP and a train/validation split

- **Objective:** Sam can train a small multilayer perceptron by gradient descent, hold out a
  validation set, and recognise overfitting in the two loss curves.
- **Builds on:** lesson 03.
- **Key ideas:**
  - Gradient descent: step each parameter against its gradient, scaled by a learning rate; too
    large diverges, too small crawls.
  - An MLP is layers of weighted sums and non-linearities; without the non-linearity, the layers
    collapse into one linear map.
  - Training loss measures fit; validation loss on held-out data measures generalisation.
  - Capacity against data: a large model on little data drives training loss down while
    validation loss rises — overfitting.
- **Recall targets:** explain what the validation set is for; read a pair of loss curves and say
  whether the model under- or overfits.
- **Build:** an MLP on the lesson 03 engine (or numpy) for a small toy dataset, with a fixed seed and
  a train/validation split; one run with enough data and one with too little, both loss curves
  recorded; checked by a test that training loss falls over a fixed number of steps.
- **Efficiency lens:** time per training step against parameter count, so the cost of the scalar
  engine is seen before tensors replace it.
- **Sources:** _Deep Learning_, Section 5.2 "Capacity, Overfitting and Underfitting" and Section
  5.3 "Hyperparameters and Validation Sets" (<https://www.deeplearningbook.org/contents/ml.html>)
  and Section 8.3.1 "Stochastic Gradient Descent"
  (<https://www.deeplearningbook.org/contents/optimization.html>); Zero to Hero Lecture 3 (MLP);
  makemore (<https://github.com/karpathy/makemore>, MIT, commit 988aa59).
- **Done when:** both runs are recorded and Sam explains the gap between their validation curves.

## 05 — Softmax, log-likelihood, cross-entropy and perplexity

- **Objective:** Sam can turn scores into a probability distribution, compute the negative
  log-likelihood of observed tokens, and report it as cross-entropy and perplexity.
- **Builds on:** lessons 01–04.
- **Key ideas:**
  - Softmax exponentiates and normalises; subtracting the maximum score first changes nothing
    mathematically and prevents overflow.
  - Maximum likelihood training minimises the average negative log-probability of the observed
    data — for a language model, of each next token.
  - PyTorch's `cross_entropy` takes unnormalised logits and a target index, combining the
    log-softmax and the negative log-likelihood.
  - Perplexity is the exponential of the average negative log-likelihood per token; a uniform guess
    over V tokens scores V.
- **Recall targets:** predict the loss of a uniform model over a given vocabulary; explain why the
  maximum is subtracted before `exp`.
- **Build:** a bigram character model from counts (as in makemore's first lecture), its loss
  computed by hand and checked against `torch.nn.functional.cross_entropy`, and its perplexity on a
  validation split; checked by pytest.
- **Sources:** _Deep Learning_, Section 4.1 "Overflow and Underflow"
  (<https://www.deeplearningbook.org/contents/numerical.html>), Section 5.5 "Maximum Likelihood
  Estimation" and Section 6.2.2.3 "Softmax Units for Multinoulli Output Distributions"; PyTorch 2.14
  `torch.nn.functional.cross_entropy` (<https://docs.pytorch.org/docs/2.14/generated/torch.nn.functional.cross_entropy.html>);
  Hugging Face Transformers, "Perplexity of fixed-length models"
  (<https://huggingface.co/docs/transformers/en/perplexity>); Zero to Hero Lecture 2.
- **Done when:** the hand-computed loss matches PyTorch's, and Sam predicts the uniform-model loss
  before computing it.

## 06 — Optimisers and schedules: SGD, momentum, AdamW, warm-up, cosine decay, clipping

- **Objective:** Sam can implement one update step of SGD, momentum and AdamW, match PyTorch's
  optimisers step for step, and explain what warm-up, cosine decay and gradient clipping each
  protect against.
- **Builds on:** lessons 03–05.
- **Key ideas:**
  - Momentum keeps a running average of gradients, smoothing noisy steps.
  - Adam keeps per-parameter first and second moment estimates with bias correction; AdamW applies
    weight decay directly to the weights instead of through the gradient.
  - Adam's two moments cost two extra values per parameter — the optimiser state in llm-07's VRAM
    budget.
  - Warm-up avoids large early steps; cosine decay lowers the learning rate smoothly towards the
    end; clipping the global gradient norm stops one bad batch exploding the weights.
- **Recall targets:** write the order of operations in one AdamW step; say how much memory Adam's
  state adds per parameter; name the failure each schedule element prevents.
- **Build:** numpy step functions for SGD, momentum and AdamW plus a warm-up-then-cosine schedule;
  tests feed identical gradients to Sam's code and to `torch.optim` and compare the parameters after
  several steps.
- **Efficiency lens:** bytes of optimiser state per parameter for each optimiser, in fp32.
- **Sources:** _Deep Learning_, Sections 8.3.2 "Momentum" and 8.5.3 "Adam"
  (<https://www.deeplearningbook.org/contents/optimization.html>); Kingma and Ba, arXiv:1412.6980,
  Algorithm 1; Loshchilov and Hutter, arXiv:1711.05101; Loshchilov and Hutter (cosine schedule),
  arXiv:1608.03983; Goyal et al. (warm-up), arXiv:1706.02677; Pascanu et al. (clipping),
  arXiv:1211.5063; PyTorch 2.14 `torch.optim.AdamW` (<https://docs.pytorch.org/docs/2.14/generated/torch.optim.AdamW.html>)
  and `clip_grad_norm_` (<https://docs.pytorch.org/docs/2.14/generated/torch.nn.utils.clip_grad_norm_.html>).
- **Done when:** Sam's AdamW matches `torch.optim.AdamW` to tolerance over several steps, and he
  writes the AdamW step from memory.

## 07 — Floating point for ML: fp32, fp16, bf16 and loss scaling

- **Objective:** Sam can compare fp32, fp16 and bf16 by range and precision, show a small gradient
  underflowing in fp16, and explain how loss scaling rescues it.
- **Builds on:** lesson 05; C's floating types from P1.
- **Key ideas:**
  - A float is sign, exponent and fraction: the exponent width sets the range, the fraction width
    the precision; rounding error is measured in ulps or as a relative error.
  - fp16 tops out at 65,504; its smallest normal value is 2^-14 (about 6.1e-5,
    `torch.finfo(torch.float16).tiny`), subnormals reach down to 2^-24, and anything at or below
    2^-25 rounds to zero (values just above it round up to 2^-24) — small gradients vanish.
  - bf16 keeps fp32's exponent range with fewer fraction bits; this RTX 2080 Ti (Turing) has fp16
    tensor cores but no native bf16 (llm-05 lesson 04 measures what that means).
  - Mixed-precision training keeps an fp32 master copy of the weights and multiplies the loss by a
    scale factor so gradients stay representable, then unscales before the update.
- **Recall targets:** give fp16's largest value and its underflow threshold; explain why bf16 needs
  no loss scaling where fp16 does.
- **Build:** a probe that prints `torch.finfo` for the three dtypes, and a test showing a gradient
  that underflows to zero in fp16 survives when the loss is scaled first; CPU only, checked by
  pytest.
- **Efficiency lens:** bytes per parameter in each format, and what halving them does to the llm-07
  budget.
- **Sources:** Goldberg, "What Every Computer Scientist Should Know About Floating-Point
  Arithmetic" (<https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html>); PyTorch 2.14
  "Type Info" (<https://docs.pytorch.org/docs/2.14/type_info.html>); Micikevicius et al., "Mixed
  Precision Training", arXiv:1710.03740, Sections 3.1 and 3.2; Google Cloud, "The bfloat16 numerical
  format" (<https://cloud.google.com/tpu/docs/bfloat16>).
- **Done when:** the probe and the underflow test pass, and Sam explains the scale-then-unscale step
  unaided.

## 08 — Backprop by hand through matmul, softmax and layer norm

- **Objective:** Sam can derive and implement the backward pass of a matmul, a softmax with
  cross-entropy, and a layer norm, and prove each against numerical and PyTorch gradients.
- **Builds on:** lessons 02, 03, 05 and 07.
- **Key ideas:**
  - For `Y = X W`, the gradient for `X` is the upstream gradient times `W` transposed, and for `W`
    it is `X` transposed times the upstream gradient; shapes check the algebra.
  - Softmax followed by cross-entropy has a simple combined gradient: the probabilities minus the
    one-hot target.
  - Layer norm normalises each row by its own mean and variance, then scales and shifts; its
    backward pass must account for every element feeding the mean and the variance.
  - These are the backward functions llm.c writes in C (`train_gpt2.c`), which llm-09 reads.
- **Recall targets:** state the two matmul gradients with their shapes; state the combined
  softmax-cross-entropy gradient.
- **Build:** numpy backward functions for the three operations, each tested against the lesson 02
  checker and against `torch.autograd`; checked by pytest.
- **Sources:** Zero to Hero Lecture 5, "Becoming a Backprop Ninja"; _Deep Learning_, Section 6.5;
  Ba, Kiros and Hinton, "Layer Normalization", arXiv:1607.06450; llm.c `train_gpt2.c` as reading
  (<https://github.com/karpathy/llm.c>, MIT, pinned at commit f1e2ace).
- **Done when:** all three backward functions pass both checks, and Sam derives the matmul gradients
  on paper from the shapes alone.
