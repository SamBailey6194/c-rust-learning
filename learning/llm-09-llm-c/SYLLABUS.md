# Syllabus — llm-09-llm-c

**Track**: llm · **Phase**: L3 · **Path**: Core · **Detail**: full · **Prerequisites**: llm-03, llm-04, llm-06; lessons 07–08 also llm-08 (and are Blocked until the CUDA toolkit is installed, `GAPS.md`)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

llm.c trains GPT-2 in plain C and CUDA with no framework in between, so every byte of memory and every FLOP is visible.
This topic reads it: the CPU forward pass, the memory layout, the backward pass and AdamW, then the CUDA path on this
machine's Turing card, where only the fp32 builds work as the code stands. It is where the mission's "an LLM in C" stops
being a framework call, and it feeds llm-12's training run and llm-14's hand-written inference. llm.c is MIT-licensed
and dormant since 10/05/2025, so it is pinned at commit f1e2ace and cloned **outside this repository**, with its
downloaded model and data files never committed. Sam's own C exercises land under `code/src/c/msNNN-<kebab>/`, where
this repository's `make test`, `san` and `memcheck` gates apply; the optional fp16 stretch lands in Sam's own fork of
llm.c (its own repository, created if he takes the stretch).

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Pinning llm.c and reading its map | 1 sitting | no | Security |
| 02 | The GPT-2 forward pass on the CPU | 2–3 sittings | yes — a layer norm forward in C | Efficiency |
| 03 | Memory layout: one allocation per kind | 1 sitting | yes — a parameter and memory budget in C | Efficiency |
| 04 | The backward pass in C | 2–3 sittings | yes — layer norm backward with a gradient check | — |
| 05 | AdamW in C | 1 sitting | yes — an AdamW step in C | — |
| 06 | llm.c under the sanitiser and valgrind gates | 1 sitting | no | Security |
| 07 | The CUDA path on Turing | 2–3 sittings | no | Efficiency |
| 08 | Stretch: fp16 loss scaling for llm.c | multi-session build | yes — a patch in Sam's llm.c fork | Efficiency |

---

## 01 — Pinning llm.c and reading its map

- **Objective:** Sam can fetch llm.c at a pinned commit outside the repository, name what each top-level file is for,
  and run its CPU unit test against the PyTorch reference.
- **Builds on:** llm-04 (the transformer forward pass in numpy); tooling-04 (git objects and refs); his Python, for the
  reference script.
- **Key ideas:**
  - Pin by commit, not branch: f1e2ace (10/05/2025) is the repository's last commit.
  - The map: `train_gpt2.c` (the CPU reference), `train_gpt2.cu` (the mainline mixed-precision trainer),
    `train_gpt2_fp32.cu` (a legacy fp32 trainer, frozen early for learning), `test_gpt2.c` and `dev/cuda/` (kernel
    scratch space, each file several versions of one kernel checked against a CPU reference).
  - `test_gpt2` loads a debug state written by the PyTorch script, runs a forward pass, compares logits and loss, then
    ten training steps — the same "check against a reference" discipline as this repository's tests.
  - The starter-pack script downloads weight, tokenizer and data `.bin` files that llm.c's C loader reads directly.
- **Recall targets:** why a pinned commit and not `master`; which file is the CPU reference; what `test_gpt2` compares.
- **Build:** none — Sam clones outside the repository, runs `make test_gpt2` and `./test_gpt2`, and records the result
  and the commit in the journal.
- **Security lens:** the `.bin` files are input to a C loader that trusts their header, so they come only from the
  pinned source, with a checksum recorded — the models-as-untrusted-input rule from llm-01.
- **Sources:**
  - llm.c README at f1e2ace ("quick start", "test"): <https://github.com/karpathy/llm.c/tree/f1e2ace651495b74ae22d45d1723443fd00ecd3a>
  - llm.c `dev/cuda/README.md` at f1e2ace: <https://github.com/karpathy/llm.c/tree/f1e2ace651495b74ae22d45d1723443fd00ecd3a/dev/cuda>
- **Done when:** `test_gpt2` passes on this machine, and the journal records the commit and the files' checksums.

## 02 — The GPT-2 forward pass on the CPU

- **Objective:** Sam can trace a batch through `gpt2_forward` in `train_gpt2.c` and map each C function to its numpy
  counterpart from llm-04.
- **Builds on:** llm-04 (embeddings, causal attention, MLP, residuals, layer norm); P2 C (pointer arithmetic over flat
  arrays).
- **Key ideas:**
  - Tensors are flat `float` arrays indexed by hand; shapes such as (B, T, C) live in the index arithmetic.
  - The pass is a fixed sequence: encoder (token plus position embeddings), then per layer layer norm, attention,
    residual, layer norm, MLP with GELU, residual; then a final layer norm, the logits and softmax with cross-entropy.
  - The output projection reuses the token embedding matrix (`wte`), and the vocabulary is padded (`Vp`) to a round
    size.
  - Parallel loops use OpenMP pragmas; `OMP_NUM_THREADS` sets the thread count.
  - Layer norm and GELU follow their papers (arXiv:1607.06450v1, arXiv:1606.08415v5).
- **Recall targets:** the order of operations inside one block; the index of element (b, t, c) in a flat (B, T, C)
  array; why the vocabulary is padded.
- **Build:** a layer norm forward in C under `code/src/c/msNNN-<kebab>/` (Sam's own, not a copy), with `check.h` tests
  on small inputs whose mean and variance he can work out by hand; clean under `make test`, `make san` and
  `make memcheck`.
- **Efficiency lens:** time one forward step of llm.c's `train_gpt2` at 1, 4 and 8 OpenMP threads (applying llm-06
  lesson 01's method) and relate the scaling to this CPU's 8 cores and 16 threads.
- **Sources:**
  - llm.c `train_gpt2.c` at f1e2ace, `gpt2_forward` and the layer functions above it:
    <https://github.com/karpathy/llm.c/blob/f1e2ace651495b74ae22d45d1723443fd00ecd3a/train_gpt2.c>
  - Ba, Kiros and Hinton, "Layer Normalization", arXiv:1607.06450v1; Hendrycks and Gimpel, "Gaussian Error Linear
    Units (GELUs)", arXiv:1606.08415v5
  - Radford et al., "Language Models are Unsupervised Multitask Learners" (GPT-2), Section 2.3 Model:
    <https://cdn.openai.com/better-language-models/language_models_are_unsupervised_multitask_learners.pdf>
- **Done when:** Sam narrates one block of the forward pass from the C source unaided, and his layer norm passes all
  three gates.

## 03 — Memory layout: one allocation per kind

- **Objective:** Sam can explain llm.c's allocation strategy and predict the bytes it needs for parameters, gradients,
  optimiser state and activations at a given batch and sequence length.
- **Builds on:** lesson 02; llm-07's VRAM budget formula (weights + gradients + optimiser state + activations); P2's
  allocator project.
- **Key ideas:**
  - All 16 parameter tensors live in one `malloc`'d block, with pointers set into it; the 23 activation tensors do the
    same — one allocation per kind, not one per tensor.
  - Gradients are allocated lazily on the first backward pass, and AdamW's two moment buffers with `calloc` on the
    first update.
  - Parameter bytes depend only on the configuration; activation bytes grow with B and T.
  - One contiguous block is cache- and allocator-friendly and makes a checkpoint a single write.
- **Recall targets:** which buffers exist after forward only, after backward, after the first update; how the total
  scales with B and T.
- **Build:** a small C exercise under `code/src/c/msNNN-<kebab>/` that computes parameter and activation sizes for a
  GPT-2 configuration, tested against the parameter count `train_gpt2` prints for the 124M checkpoint; all three gates.
- **Efficiency lens:** predicted bytes against measured peak resident memory (`/usr/bin/time -v`, maximum resident set
  size) for a short `train_gpt2` run.
- **Sources:**
  - llm.c `train_gpt2.c` at f1e2ace: `fill_in_parameter_sizes`, `malloc_and_point_parameters`,
    `fill_in_activation_sizes`, the lazy allocations in `gpt2_backward` and `gpt2_update` (URL as lesson 02)
  - `man 1 time` (the `-v` report); `man 3 malloc` and `man 3 calloc`
- **Done when:** the exercise passes, and Sam's predicted and measured peak memory agree within a margin he can explain.

## 04 — The backward pass in C

- **Objective:** Sam can read `gpt2_backward` as the forward pass in reverse and verify a backward function he writes
  with a finite-difference gradient check.
- **Builds on:** llm-03's backprop-by-hand lesson (matmul, softmax, layer norm); lessons 02–03.
- **Key ideas:**
  - Backward walks the layers in reverse, consuming the activations the forward pass kept.
  - Gradients are accumulated (`+=`), because a tensor used twice — a residual branch, the shared `wte` — receives two
    contributions; so gradients are zeroed before each backward.
  - Softmax and cross-entropy are differentiated together into one simple expression.
  - A gradient check compares an analytic gradient with a centred finite difference, within a tolerance that respects
    fp32 precision.
- **Recall targets:** why `+=` and not `=`; what `gpt2_zero_grad` prevents; how a gradient check chooses its step size
  and tolerance.
- **Build:** the layer norm backward in the lesson 02 exercise, with a finite-difference gradient check as a `check.h`
  test; all three gates.
- **Sources:**
  - llm.c `train_gpt2.c` at f1e2ace: `gpt2_backward`, `layernorm_backward`, `crossentropy_softmax_backward`
    (URL as lesson 02)
  - Ba, Kiros and Hinton, arXiv:1607.06450v1
- **Done when:** the gradient check passes, and Sam explains the accumulation rule unaided.

## 05 — AdamW in C

- **Objective:** Sam can write one AdamW update in C and explain each term: moments, bias correction and decoupled
  weight decay.
- **Builds on:** llm-03's optimisers lesson (SGD, momentum, Adam, AdamW); lesson 03's lazy buffers.
- **Key ideas:**
  - AdamW keeps two running moments per parameter, corrects their start-up bias with the step count, and scales the
    step by their ratio.
  - Decoupled weight decay shrinks the weights directly instead of adding a penalty to the gradient (arXiv:1711.05101v3).
  - llm.c's `gpt2_update` cites PyTorch's AdamW documentation as its reference.
  - Optimiser state is two extra copies of the parameters — the same term llm-07's VRAM formula counts.
- **Recall targets:** the update in words; what bias correction fixes; why "decoupled" matters; the optimiser-state
  bytes for a given N.
- **Build:** an AdamW step over a small parameter array under `code/src/c/msNNN-<kebab>/`, tested against values Sam
  computes with `torch.optim.AdamW` for the same inputs and pastes as test constants; all three gates.
- **Sources:**
  - Loshchilov and Hutter, "Decoupled Weight Decay Regularization", arXiv:1711.05101v3; Kingma and Ba, "Adam",
    arXiv:1412.6980v9
  - llm.c `train_gpt2.c` at f1e2ace, `gpt2_update` (URL as lesson 02)
- **Done when:** the test matches PyTorch within tolerance for several steps, and Sam explains each term.

## 06 — llm.c under the sanitiser and valgrind gates

- **Objective:** Sam can build llm.c's CPU code with this repository's sanitiser flags, run it under ASan, UBSan and
  valgrind, and interpret what they report.
- **Builds on:** P1–P2's `make san` and `make memcheck` (`code/docs/MEMORY-SAFETY.md`); lessons 01–05.
- **Key ideas:**
  - llm.c's own Makefile builds the CPU code with `-Ofast -march=native` and OpenMP; a sanitiser build needs its own
    flags (the ones in `code/docs/BUILD.md` — Section 2) and runs far slower.
  - ASan and valgrind never run on the same binary (`code/docs/MEMORY-SAFETY.md` — Section 5).
  - `-Ofast` turns on `-ffast-math`, which permits floating-point reassociation, so results can differ slightly between
    an `-Ofast` build and a sanitiser build.
  - A finding in third-party code is reported upstream or noted, not silently patched.
- **Recall targets:** which flags the sanitiser build adds and why it is slower; why the two tools stay apart; what
  `-Ofast` changes.
- **Build:** none in this repository — the runs happen in the clone outside it; the commands and results go in the
  journal, and any finding in `NOTES/`.
- **Security lens:** a C program that parses model files is exactly where memory-safety bugs hide; the gates are the
  evidence, not an assumption.
- **Sources:**
  - llm.c `Makefile` at f1e2ace (`CFLAGS`, the OpenMP block):
    <https://github.com/karpathy/llm.c/blob/f1e2ace651495b74ae22d45d1723443fd00ecd3a/Makefile>
  - `man gcc` (`-fsanitize=`, `-Ofast`); `man valgrind`
- **Done when:** `test_gpt2` has run under ASan with UBSan and, separately, under valgrind memcheck, and the journal
  holds the commands and an explanation of every report.

## 07 — The CUDA path on Turing

- **Objective:** Sam can build and run llm.c's GPU trainer on the RTX 2080 Ti in the one mode that works there, and
  explain why the others do not.
- **Builds on:** llm-08 (toolkit, `-arch=sm_75`, timing); llm-05 (mixed precision on Turing); lessons 01–06.
- **Key ideas:**
  - Mainline `train_gpt2.cu` defaults to `PRECISION=BF16`; Turing has no native bf16.
  - Its FP16 mode refuses to build from a checkpoint (issue #747) and has no loss scaler, and its cuDNN attention path
    refuses FP32 — so on this card the working choices are the legacy `make train_gpt2fp32cu` or
    `make train_gpt2cu PRECISION=FP32` without cuDNN.
  - The Makefile tries to detect the compute capability with `nvidia-smi`, but at f1e2ace its Linux branch writes
    `$(which …)` and `$(nvidia-smi …)` without `$(shell …)`. Both expand to nothing, so no `--generate-code` flag is
    passed (check with `make -n train_gpt2fp32cu`), and nvcc falls back to its default target, which is `sm_75` in
    CUDA 13.x. Pass `GPU_COMPUTE_CAPABILITY=75` explicitly, e.g. `make train_gpt2fp32cu GPU_COMPUTE_CAPABILITY=75`,
    so the build states what it targets.
  - VRAM is budgeted against what the desktop leaves free, not the card's 11 GiB.
- **Recall targets:** why bf16 is out; the two reasons FP16 is out; the two build commands that work, each carrying
  `GPU_COMPUTE_CAPABILITY=75`, and why the Makefile's own detection does not set it; where the VRAM budget comes from.
- **Build:** none in this repository — Sam runs the fp32 GPU trainer in the clone and records tokens per second and peak
  VRAM against the CPU run of lesson 02. **Blocked** until nvcc is installed (`GAPS.md` → "CUDA toolkit (`nvcc`) not
  installed").
- **Efficiency lens:** tokens per second (CPU against GPU) and peak VRAM from `nvidia-smi` during the run, against the
  free VRAM measured before it.
- **Sources:**
  - llm.c `Makefile` at f1e2ace (`PRECISION ?= BF16`, `USE_CUDNN`, `file_exists_in_path` and
    `GPU_COMPUTE_CAPABILITY`, lines 38–63; URL as lesson 06)
  - NVIDIA CUDA Compiler Driver 13.4, Section 4.2.7.1 `--gpu-architecture` ("sm_75 is used as the default value"):
    <https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html>
  - llm.c README at f1e2ace, "quick start (1 GPU, fp32 only)" and "test" (URL as lesson 01)
  - llm.c issue #747, "Can't train in FP16 on Turing": <https://github.com/karpathy/llm.c/issues/747>
  - llm.c `llmc/cudnn_att.cpp` at f1e2ace (the FP32 assertion):
    <https://github.com/karpathy/llm.c/blob/f1e2ace651495b74ae22d45d1723443fd00ecd3a/llmc/cudnn_att.cpp>
  - CUDA Programming Guide 13.4.2, Section 5.1.3, Table 33 (tensor-core input types per compute capability):
    <https://docs.nvidia.com/cuda/cuda-programming-guide/05-appendices/compute-capabilities.html>
- **Done when:** the fp32 GPU trainer runs to at least one validation step, the journal holds the CPU/GPU table, and
  Sam explains the precision constraints unaided.

## 08 — Stretch: fp16 loss scaling for llm.c

- **Objective:** Sam can design and implement dynamic loss scaling for llm.c's FP16 mode and show it trains without
  its gradients underflowing.
- **Builds on:** lesson 07; llm-05's `torch.amp.GradScaler`; llm-03's floating-point lesson (fp16 range).
- **Key ideas:**
  - fp16's narrow range lets small gradients underflow to zero; scaling the loss up before backward and the gradients
    down before the update keeps them representable (arXiv:1710.03740v3, Section 3.2).
  - Dynamic scaling checks the gradients for inf or NaN: on overflow it skips the step and lowers the scale; after a
    run of good steps it raises it — the policy `torch.amp.GradScaler` implements.
  - Master weights stay fp32 (arXiv:1710.03740v3, Section 3.1).
  - FP16 in llm.c also needs weights that do not come from `build_from_checkpoint` (issue #747).
- **Recall targets:** where the scale is applied and where it is removed; what happens on overflow; why fp32 master
  weights.
- **Build:** a patch series in Sam's own fork of llm.c (its own repository, created if he takes the stretch), tested by
  a short FP16 run whose loss tracks the fp32 run of lesson 07. **Blocked** until nvcc is installed (`GAPS.md` →
  "CUDA toolkit (`nvcc`) not installed"). Optional: it does not hold L3 closed.
- **Efficiency lens:** FP16 against fp32 tokens per second and peak VRAM, same batch and sequence length.
- **Sources:**
  - Micikevicius et al., "Mixed Precision Training", arXiv:1710.03740v3, Sections 3.1–3.2
  - PyTorch 2.14, Automatic Mixed Precision examples, "Typical Mixed Precision Training":
    <https://docs.pytorch.org/docs/2.14/notes/amp_examples.html>
  - llm.c issue #747 (URL as lesson 07)
- **Done when:** the FP16 run's loss tracks the fp32 run over the same steps, and the patch explains its scaling policy.
