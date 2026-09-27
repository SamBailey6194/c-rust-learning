# Syllabus — llm-05-tiny-gpt

**Track**: llm · **Phase**: L1 · **Path**: Core · **Detail**: full · **Prerequisites**: llm-04 (the architecture), llm-02 lessons 04–05 (timing and seeds), llm-03 lessons 06–07 (AdamW, floating point)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The first model Sam trains himself: a small character-level GPT, the llm-04 architecture rewritten
as PyTorch modules, trained on this RTX 2080 Ti with a VRAM budget stated before the run and measured
during it. It covers the whole loop once, at a size where a run takes minutes: data and batches, the
model, the training loop on CPU and GPU, mixed precision the way Turing allows it (fp16 with a
gradient scaler, because there is no native bf16), sampling, and validation with safe checkpoints.
Its measured tokens/s and VRAM sit beside the llm-01 baseline; llm-07 uses it as the model whose
memory is accounted for, and llm-12 scales the same loop to a ~100M code model.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Character data, splits and batches | 1 sitting | yes — data loader | Security |
| 02 | The GPT as PyTorch modules | 2–3 sittings | yes — model that overfits one batch | — |
| 03 | The training loop on CPU and GPU, measured against a budget | 2–3 sittings | yes — training run | Efficiency |
| 04 | Mixed precision on Turing: fp16 autocast and GradScaler | 1 sitting | yes — fp32 against fp16 run | Efficiency |
| 05 | Sampling: temperature, top-k and top-p | 1 sitting | yes — sampler | — |
| 06 | Validation, overfitting and safe checkpoints | 1 sitting | yes — checkpoint and resume | Efficiency, Security |

**Where the work lands.** A small exercise in this repository under `code/src/python/` (planned —
added at L1). Checkpoints, datasets and weights are never committed (`.claude/CLAUDE.md` Section 5);
they live in a gitignored folder. Unit tests run on the CPU in CI; the GPU runs are local, with their
numbers recorded in the milestone's verification record under `project-management/src/10-PROGRESS/`.

---

## 01 — Character data, splits and batches

- **Objective:** Sam can turn a text he is allowed to use into integer sequences, split it into
  training and validation data, and sample batches of inputs with next-character targets.
- **Builds on:** llm-03 lesson 05 (the bigram vocabulary); llm-04 lesson 01.
- **Key ideas:**
  - The vocabulary is the set of characters in the text; encode and decode are two lookups.
  - A training example is a window of `block_size` characters and the same window shifted by one;
    every position predicts its next character.
  - The validation split is held back from the end of the text and never trained on.
  - Batches are random windows, so one pass over the text is not an "epoch" in the usual sense.
  - The text must be one Sam may use: his own writing (this repository's Markdown and C) has a
    known licence; a Project Gutenberg text is public domain in the United States, and its policy
    tells readers elsewhere to check their own country's law.
- **Recall targets:** state the shapes of a batch's inputs and targets; explain why the targets are
  shifted by one; say why the validation data comes from a separate span.
- **Build:** a data module (encode, decode, split, `get_batch`) with pytest checks that decode undoes
  encode, that targets are inputs shifted by one, and that no validation span leaks into training.
- **Security lens:** the dataset's source and licence are recorded with the run; a text of unknown
  licence is not used.
- **Sources:** Zero to Hero Lecture 7, "Let's build GPT" (<https://github.com/karpathy/nn-zero-to-hero>,
  MIT, commit 73c3fcc); Project Gutenberg licence policy (<https://www.gutenberg.org/policy/license.html>,
  read 27/09/2026).
- **Done when:** the data tests pass and the run record names the text and its licence.

## 02 — The GPT as PyTorch modules

- **Objective:** Sam can write the llm-04 architecture as PyTorch modules and prove it can learn by
  overfitting a single batch.
- **Builds on:** llm-04 lessons 03–06; lesson 01.
- **Key ideas:**
  - `nn.Module`, `nn.Linear`, `nn.Embedding` and `nn.LayerNorm` hold the parameters the numpy
    version kept by hand; `scaled_dot_product_attention` with `is_causal=True` replaces the manual
    mask.
  - Overfitting one fixed batch to near-zero loss is the cheapest test that the model, loss and
    optimiser are wired correctly; failing it means a bug, not a hyperparameter.
  - The initial loss should be close to `ln(vocab)` — the uniform guess from llm-03 lesson 05; a
    very different start points to an initialisation or wiring error.
  - nanochat (MIT) is the maintained reference to read; nanoGPT is deprecated and kept for reading
    only.
- **Recall targets:** predict the initial loss for the vocabulary size; explain what overfitting one
  batch proves and what it does not.
- **Build:** the model module, a test comparing its logits with the llm-04 numpy forward pass on
  copied weights, and a test that a fixed batch is overfitted within a set number of CPU steps.
- **Sources:** PyTorch 2.14 `scaled_dot_product_attention`
  (<https://docs.pytorch.org/docs/2.14/generated/torch.nn.functional.scaled_dot_product_attention.html>)
  and `torch.nn.LayerNorm` (<https://docs.pytorch.org/docs/2.14/generated/torch.nn.LayerNorm.html>);
  nanochat (<https://github.com/karpathy/nanochat>, MIT, commit 92d63d4); nanoGPT `model.py` as
  reading (<https://github.com/karpathy/nanoGPT>, MIT, commit 3adf61e, deprecated).
- **Done when:** the initial loss matches the prediction, both tests pass, and the single batch is
  overfitted.

## 03 — The training loop on CPU and GPU, measured against a budget

- **Objective:** Sam can train the model with AdamW and a learning-rate schedule on the CPU and on
  the GPU, and report tokens/s and peak VRAM against a budget he stated before the run.
- **Builds on:** lesson 02; llm-02 lessons 04–05; llm-03 lesson 06.
- **Key ideas:**
  - The loop: batch, forward, loss, backward, clip, step, schedule, zero the gradients; evaluate
    on validation data under `torch.no_grad()` at intervals.
  - Tokens/s is `batch_size * block_size` per step divided by synchronised step time (llm-02
    lesson 04); CPU throughput also depends on the thread count, which is recorded.
  - Peak VRAM comes from `torch.cuda.memory.max_memory_allocated()` after
    `reset_peak_memory_stats()`; the budget is set against `mem_get_info()`'s free memory, not the
    card's total.
  - The milestone's Budget line is stated first (for example "VRAM peak at most 9 GiB, measured by
    `max_memory_allocated`") and checked after.
- **Recall targets:** list the steps of one training iteration in order; explain why the budget
  uses free memory; predict whether the GPU run's tokens/s gap over the CPU grows or shrinks with a
  larger model.
- **Build:** the training script with a seeded, recorded configuration; one CPU run and one GPU run
  of equal length, each logging tokens/s, loss curves and (GPU) peak VRAM; checked by validation
  loss falling below the lesson 02 initial loss and by the budget line being met or the miss
  explained.
- **Efficiency lens:** tokens/s on CPU and GPU, peak VRAM against the stated budget, and time to a
  target validation loss — recorded beside the llm-01 baseline.
- **Sources:** PyTorch 2.14 `torch.optim` (<https://docs.pytorch.org/docs/2.14/optim.html>), "CUDA
  semantics → Memory management" (<https://docs.pytorch.org/docs/2.14/notes/cuda.html>),
  `torch.cuda.memory.max_memory_allocated`
  (<https://docs.pytorch.org/docs/2.14/generated/torch.cuda.memory.max_memory_allocated.html>) and
  `torch.cuda.memory.mem_get_info`
  (<https://docs.pytorch.org/docs/2.14/generated/torch.cuda.memory.mem_get_info.html>).
- **Done when:** both runs are recorded with their configuration, seed and versions, and the budget
  line has a measured value beside it.

## 04 — Mixed precision on Turing: fp16 autocast and GradScaler

- **Objective:** Sam can train in mixed precision the way this card supports it — fp16 autocast
  with a gradient scaler — and measure what it changes in VRAM and throughput against fp32.
- **Builds on:** lesson 03; llm-03 lesson 07.
- **Key ideas:**
  - `torch.amp.autocast("cuda", dtype=torch.float16)` runs eligible operations in fp16 while
    keeping the weights in fp32.
  - `torch.amp.GradScaler("cuda")` scales the loss so small fp16 gradients survive, skips steps
    whose gradients overflowed, and adjusts the scale; `torch.cuda.amp.GradScaler` is deprecated.
  - Clipping must see true gradients, so `scaler.unscale_(optimizer)` comes before
    `clip_grad_norm_`.
  - Why not bf16: Turing (compute capability 7.5) has no native bf16 path, and
    `torch.cuda.is_bf16_supported()` counts emulation unless called with
    `including_emulation=False`. nanochat makes the same call: fp32 by default below SM 80, fp16
    with a gradient scaler on request.
- **Recall targets:** place `unscale_` correctly in the loop; explain what the scaler does when a
  step overflows; say why this card trains in fp16 rather than bf16.
- **Build:** an fp16 option in the training script; equal-length fp32 and fp16 GPU runs recording
  peak VRAM, tokens/s, skipped steps and final validation loss; checked by the fp16 run reaching a
  comparable validation loss.
- **Efficiency lens:** VRAM and throughput difference between fp32 and fp16, measured, not assumed.
- **Sources:** PyTorch 2.14 "Automatic Mixed Precision package" (<https://docs.pytorch.org/docs/2.14/amp.html>)
  and "Automatic Mixed Precision examples → Gradient clipping"
  (<https://docs.pytorch.org/docs/2.14/notes/amp_examples.html>); `torch.cuda.is_bf16_supported`
  (<https://docs.pytorch.org/docs/2.14/generated/torch.cuda.is_bf16_supported.html>); nanochat README
  → precision table (<https://github.com/karpathy/nanochat>, commit 92d63d4); Micikevicius et al.,
  arXiv:1710.03740, Section 3.2.
- **Done when:** both runs are recorded side by side and Sam explains every difference in the table.

## 05 — Sampling: temperature, top-k and top-p

- **Objective:** Sam can generate text from the trained model and control it with temperature, top-k
  and top-p (nucleus) sampling, predicting each knob's effect.
- **Builds on:** lessons 02–04.
- **Key ideas:**
  - Generation is a loop: run the model on the context, take the last position's logits, pick a
    token, append it, crop the context to `block_size`.
  - Temperature divides the logits before the softmax: below 1 sharpens the distribution, above 1
    flattens it; near 0 approaches greedy decoding.
  - Top-k keeps the k most likely tokens; top-p keeps the smallest set whose probability reaches p,
    so its size adapts to how confident the model is.
  - Sampling is random, so a fixed generator seed makes a sample repeatable.
- **Recall targets:** predict the effect of each knob on a given distribution; explain why top-p
  adapts where top-k does not.
- **Build:** a sampler with pytest checks on hand-made distributions (top-k keeps exactly k, top-p
  keeps the smallest qualifying set, a seeded sample repeats), then samples from the trained model
  at three settings saved with the run.
- **Sources:** Holtzman et al., "The Curious Case of Neural Text Degeneration", arXiv:1904.09751,
  Sections 3.1–3.3; Fan et al., arXiv:1805.04833 (top-k sampling); PyTorch 2.14 `torch.multinomial`
  (<https://docs.pytorch.org/docs/2.14/generated/torch.multinomial.html>).
- **Done when:** the sampler tests pass and Sam predicts, then confirms, how a sample changes as each
  knob moves.

## 06 — Validation, overfitting and safe checkpoints

- **Objective:** Sam can decide when to stop training from the validation curve, save the weights as
  safetensors, and resume a run from a checkpoint this machine produced, loaded safely.
- **Builds on:** lessons 03–05; llm-03 lesson 04.
- **Key ideas:**
  - When validation loss turns upward while training loss keeps falling, the model is memorising;
    the best checkpoint is the one with the lowest validation loss, not the last.
  - Weights are saved as safetensors: a small JSON header and raw tensor bytes, with no code to
    execute on load.
  - Resuming also needs the optimiser and scaler state; a torch checkpoint is a pickle, so it is
    loaded only if this machine wrote it, and then with `weights_only=True` — which narrows the
    attack surface but does not remove it.
  - Checkpoints and data stay out of git; their hashes and paths go in the run record.
- **Recall targets:** read a pair of curves and name the checkpoint to keep; explain why safetensors
  is safe to load and a pickle is not.
- **Build:** save the best weights as safetensors, save and resume the full training state, and a
  test that a resumed run continues with the same loss as an uninterrupted one on the CPU.
- **Efficiency lens:** checkpoint size on disk against the parameter count times bytes per value.
- **Security lens:** never load a pickle from anywhere else; safetensors only for weights shared or
  downloaded (`.claude/CLAUDE.md` Section 5).
- **Sources:** safetensors documentation (<https://huggingface.co/docs/safetensors/>) and repository
  README → "Format" (<https://github.com/safetensors/safetensors>, Apache-2.0, read at commit e246a25);
  PyTorch 2.14 "Serialization semantics → weights_only security"
  (<https://docs.pytorch.org/docs/2.14/notes/serialization.html>).
- **Done when:** the resume test passes, the best checkpoint is chosen from the validation curve,
  and nothing it produced is tracked by git.
