# Syllabus — llm-15-efficient-inference

**Track**: llm · **Phase**: L5 · **Path**: Core · **Detail**: full · **Prerequisites**: llm-14 (inference in Rust, including lesson 04, the KV cache); llm-06 lessons 01 (measuring honestly) and 05 (the roofline); kernel-03's page-cache lesson or P2's mmap lesson; llm-01 lessons 03–04 (the baseline and the context sweep)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic is where the mission's "uses CPU, RAM, GPU, VRAM and cache efficiently" becomes measured
practice. Generating one token at a time reads nearly every weight once per token, so decoding is
usually limited by memory bandwidth, not arithmetic. Every lesson here either moves fewer bytes
(quantisation, grouped-query attention, a quantised KV cache), moves them more cleverly (mmap and the
page cache, paging, prefix reuse, offload splits, batching) or gets more tokens out of each pass
(speculative decoding) — and every one is measured on this machine against llm-01's baseline: an
i9-9900K with AVX2 and FMA but no AVX-512, 32 GB of RAM, and an RTX 2080 Ti whose 11 GiB is shared
with the desktop (about 9 GiB free). The reference engine is llama.cpp, pinned at release build
b11221 (27/09/2026, commit 136887b); it is not installed yet (`GAPS.md`), and lesson 01 installs it
outside the repository. **Where the work lands:** measurements are milestone evidence and go in the
verification record under `project-management/src/10-PROGRESS/`; the small exercises below land at
planned paths under `code/src/`; changes to Sam's own Rust inference engine (llm-14) land in the inference
repository (created when this build starts). No model file, GGUF or KV-cache dump is ever committed.
The topic feeds llm-16 (the context and KV budget of skills), llm-18 (prefix-cache leakage and
unbounded consumption), llm-19 (latent attention against this topic's GQA arithmetic) and os-17 (the
model as a supervised service).

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Prefill and decode: why generation is memory-bound | 2–3 sittings | yes — bound against measured | Efficiency, Security |
| 02 | Block quantisation: scales, bits per weight and error | 2–3 sittings | yes — block-quant | Efficiency |
| 03 | GGUF k-quants: choosing by size, speed and divergence | 2–3 sittings | yes — quant sweep | Efficiency |
| 04 | mmap loading and the page cache | 2–3 sittings | yes — page-cache residency | Efficiency |
| 05 | KV-cache arithmetic: MHA, MQA and GQA | 2–3 sittings | yes — kv-budget | Efficiency |
| 06 | Paged KV-cache memory | 2–3 sittings | yes — paged KV allocator | Efficiency |
| 07 | Prefix and prompt caching | 1 sitting | yes — time to first token | Efficiency, Security |
| 08 | CPU/GPU offload splits and KV-cache types | 2–3 sittings | yes — split sweep | Efficiency |
| 09 | Speculative decoding | 2–3 sittings | yes — draft sweep | Efficiency |
| 10 | Reading ggml's AVX2 quantised dot product, then profiling it | multi-session build | yes — profile against the roofline | Efficiency, Safety |
| 11 | Batching: throughput against latency | 2–3 sittings | yes — batched sweep | Efficiency, Security |

---

## 01 — Prefill and decode: why generation is memory-bound

- **Objective:** Sam can predict an upper bound on decode tokens per second from the bytes read per
  token and the memory bandwidth, and explain from his own measurements why prompt processing runs
  far faster per token than generation.
- **Builds on:** llm-06 lesson 01 (warm-up, repeated runs, variance) and lesson 05 (the roofline);
  llm-01 lesson 03 (the baseline); llm-14 lesson 03 (the hand-written forward pass).
- **Key ideas:**
  - A forward pass costs about `2 * N` matmul FLOPs per token for `N` parameters (one multiply and
    one add per parameter), and the weights plus the KV cache must stream from memory once per
    pass; at small batch sizes the weight-loading time dominates (arXiv:2211.05102, Section 2).
  - Prefill handles the whole prompt as matrix-matrix products; decode is one token at a time, a
    matrix-vector product that reads every weight for a handful of FLOPs — low arithmetic intensity,
    far left of the ridge point on llm-06's roofline.
  - The bound: decode tokens/s is at most bandwidth divided by bytes read per token. The 2080 Ti's
    reference bandwidth is 616 GB/s (Turing whitepaper, Table 1); the RAM figure is the one Sam
    measured in llm-06 lesson 05, not a datasheet guess.
  - `llama-bench` reports prompt processing (`pp`) and text generation (`tg`) separately and repeats
    each test (five repetitions by default); report the mean and the spread, never one run.
  - Installing the pinned engine is itself a lesson in reading a build: the CPU release build loads
    `libggml-cpu-haswell.so` (the AVX2 variant) on this CPU (checked 27/09/2026); the CUDA release
    builds carry Turing only as PTX (`75-virtual` in `ggml/src/ggml-cuda/CMakeLists.txt`), and PTX
    will not run on a driver older than the toolkit that produced it — so the CUDA 13.4 build cannot
    run on driver 580 (CUDA 13.0), while the CUDA 12.8 build should (the Build confirms it); a source
    build with `-DCMAKE_CUDA_ARCHITECTURES=75` waits for cmake and the CUDA toolkit (`GAPS.md`).
- **Recall targets:** explain why decode is memory-bound and prefill is not; predict how halving the
  bits per weight should move `tg` and `pp`; say which CUDA release build can run on this driver and
  why.
- **Build:** a measurement, not code. Install release b11221 outside the repository, run
  `llama-bench` on the GGUF of llm-01's chosen model on the CPU and fully offloaded to the GPU,
  write down the bandwidth bound before running, then record bound against measured (command,
  repetitions, mean and spread) in the milestone's verification record under
  `project-management/src/10-PROGRESS/`. The gap between the two is explained, not ignored. If the
  CUDA 12.8 build does not run on this driver, that is recorded and the GPU half waits for a source
  build.
- **Efficiency lens:** `pp` and `tg` tokens/s (`llama-bench -r`), VRAM in use
  (`nvidia-smi --query-gpu=memory.used --format=csv`), peak RSS (`/usr/bin/time -v`).
- **Security lens:** a release tarball and a GGUF are third-party inputs; record the build number and
  the `sha256sum` of each before running them (llama.cpp `SECURITY.md` → "Untrusted models" and
  "Untrusted environments or networks").
- **Sources:** Pope et al., "Efficiently Scaling Transformer Inference", arXiv:2211.05102, Section 2;
  NVIDIA Turing Architecture Whitepaper WP-09183-001_v01, Table 1,
  <https://images.nvidia.com/aem-dam/en-zz/Solutions/design-visualization/technologies/turing-architecture/NVIDIA-Turing-Architecture-Whitepaper.pdf>;
  llama.cpp `tools/llama-bench/README.md`, `ggml/src/ggml-cuda/CMakeLists.txt` and `SECURITY.md` at
  b11221, <https://github.com/ggml-org/llama.cpp> (MIT); NVIDIA CUDA minor-version compatibility →
  "Applications using PTX will see runtime issues",
  <https://docs.nvidia.com/deploy/cuda-compatibility/minor-version-compatibility.html>; `man time`.
- **Done when:** the verification record holds the predicted bound and the measured `pp` and `tg`
  for CPU and GPU with their spread, and Sam explains the gap unaided.

## 02 — Block quantisation: scales, bits per weight and error

- **Objective:** Sam can quantise a block of floats to 8-bit and 4-bit integers with a per-block
  scale, dequantise it, and predict both the storage cost in bits per weight and the error it adds.
- **Builds on:** lesson 01 (bytes per token drive speed); llm-03's floating-point lesson (range and
  precision); P1–P2 C (arrays, integer conversions, `check.h` tests).
- **Key ideas:**
  - Symmetric block quantisation stores one scale per block and one small integer per weight; the
    scale's bytes are part of the cost, which is why the bits per weight is never exactly 8 or 4.
  - ggml's `Q8_0` block is 32 weights plus one fp16 scale (34 bytes, 8.5 bits per weight) and
    `Q4_0` is 32 four-bit weights plus one fp16 scale (18 bytes); the layouts and their
    `static_assert` size checks are in `ggml/src/ggml-common.h`.
  - Error comes from rounding and from outliers stretching the scale; smaller blocks cost more
    scale bytes but track outliers better.
  - Integer conversions in C are where this goes wrong: rounding mode, clamping to the integer
    range, and signed overflow (undefined behaviour — caught by UBSan, not by testing on one input).
  - Weight-only methods that go further (GPTQ, arXiv:2210.17323; AWQ, arXiv:2306.00978) choose the
    rounding more cleverly; they are reading here, not builds.
- **Recall targets:** compute the bits per weight of a block format from its layout; predict which
  of two blocks (with and without an outlier) quantises with more error, and why.
- **Build:** `block-quant` — a C exercise at the planned path `code/src/c/msNNN-block-quant/` that
  quantises and dequantises a block of 32 floats to 8-bit and 4-bit codes with a per-block scale
  (a `float` scale is fine; C17 has no half type). Tests in `check.h` check the bits-per-weight
  arithmetic, the round-trip error bound on known inputs, clamping at the integer range, and an
  all-zero block. Checked by `make test`, `make san` and `make memcheck`.
- **Efficiency lens:** bytes per block and bits per weight computed in the test, set against the
  rounding error (maximum absolute and root-mean-square) on the same input.
- **Sources:** llama.cpp `ggml/src/ggml-common.h` at b11221 (`block_q8_0`, `block_q4_0` and their
  `static_assert` lines); Jacob et al., arXiv:1712.05877, Section 2.1 (the quantisation scheme);
  Frantar et al. (GPTQ), arXiv:2210.17323; Lin et al. (AWQ), arXiv:2306.00978;
  `code/docs/C-CODING-PRINCIPLES.md` → Section 5.
- **Done when:** the exercise's tests pass clean under `san` and `memcheck`, and Sam predicts the bits
  per weight of an unseen block layout before computing it.

## 03 — GGUF k-quants: choosing by size, speed and divergence

- **Objective:** Sam can explain how a k-quant super-block is laid out, produce two or three
  quantisations of one model, and choose between them from measured size, speed and divergence from
  the higher-precision model.
- **Builds on:** lesson 02; llm-01 lesson 01 (the quantisation table and the ~9 GiB budget).
- **Key ideas:**
  - k-quants group 256 weights (`QK_K`) into a super-block of sub-blocks, each with a quantised scale
    (and, for some types, a minimum); `block_q4_K` stores two fp16 super-block values, 12 bytes of
    6-bit scales and mins, and 128 bytes of 4-bit codes — 4.5 bits per weight for the block alone.
  - A named mix such as `Q4_K_M` quantises different tensors differently, which is why its measured
    bits per weight is above 4.5; `--pure` turns the mixture off.
  - An importance matrix (`--imatrix`) spends precision where activations say it matters.
  - Quality is measured, not assumed: `llama-perplexity` reports perplexity, and with
    `--kl-divergence-base` and `--kl-divergence` it compares a quant's token distributions against a
    higher-precision model's.
  - Requantising an already-quantised model loses more than quantising from 16- or 32-bit.
- **Recall targets:** compute a k-quant block's bits per weight from its struct; explain why
  perplexity alone can hide a quant's damage that KL divergence shows.
- **Build:** `quant sweep` — a measurement. Convert one small open model to a 16-bit GGUF and
  quantise it to two or three types outside the repository, then record size, `pp`/`tg` tokens/s and
  KL divergence against the 16-bit model in the verification record. No code, no model files in the
  repository.
- **Efficiency lens:** file size, VRAM in use and `tg` tokens/s for each quant, beside its KL
  divergence — the trade-off is a table, not a feeling.
- **Sources:** llama.cpp `tools/quantize/README.md` ("Quantize the GGUF", "Quantization", "Background
  information", including the k-quants pull request #1684), `tools/perplexity/README.md` (the KL
  divergence options) and `ggml/src/ggml-common.h` (`QK_K`, `block_q4_K`) at b11221; GGUF
  specification, <https://github.com/ggml-org/ggml/blob/master/docs/gguf.md> (last changed at commit
  6af560d, 09/07/2026).
- **Done when:** the record compares at least two quants of one model on size, speed and KL
  divergence, and Sam defends his pick against the ~9 GiB budget.

## 04 — mmap loading and the page cache

- **Objective:** Sam can explain what happens between `mmap` and the first token — page faults, the
  page cache, readahead — and measure cold and warm load times and page-cache residency for a model
  file.
- **Builds on:** kernel-03's page-cache lesson (or P2's mmap lesson); llm-14 lesson 01 (the
  safetensors reader over memmap2); lesson 01.
- **Key ideas:**
  - Mapping a file costs almost nothing; pages are read on first touch (page faults) and then stay in
    the kernel's page cache, shared by every process that maps the same file.
  - A "warm" start is one whose pages are already in the page cache; most of the difference between
    a cold and a warm load is disk reads, not the program.
  - `posix_fadvise` with `POSIX_FADV_DONTNEED` asks the kernel to free one file's cached pages — an
    unprivileged way to stage a cold start for a single file (a request, not a guarantee).
  - `mincore` reports which pages of a mapping are resident, as a snapshot that may already be stale;
    `madvise` (`MADV_SEQUENTIAL`, `MADV_RANDOM`, `MADV_WILLNEED`) and `posix_fadvise` hint the
    kernel's readahead.
  - `mlock` pins pages against reclaim and swap, at the cost of memory nobody else can use; llama.cpp
    exposes the choice as `--load-mode` (`mmap`, `mlock`, `mmap+mlock`, `none`, `dio`).
  - A process's RSS counts shared file pages it has touched; `/proc/<pid>/smaps` separates
    `Shared_Clean` from `Private_Clean`, so "the model uses 5 GB of RAM" needs care.
- **Recall targets:** predict the second load of the same model after the first; explain why RSS
  over-states or under-states a mapped model's real cost.
- **Build:** `page-cache residency` — a C exercise at the planned path
  `code/src/c/msNNN-page-cache-residency/` that maps a file read-only, reports how many of its pages
  are resident (`mincore`), touches them, and reports again. Tests run it on a small file the test
  creates itself (never a model file) and check the counts before and after touching and the error
  paths. Checked by `make test`, `make san` and `make memcheck`. Then run it, and `llama-bench`,
  against the model file outside the repository to compare cold and warm starts.
- **Efficiency lens:** load time cold and warm, resident pages before and after, RSS and
  `Shared_Clean` from `smaps`; a cold start is staged per file with `POSIX_FADV_DONTNEED` and
  checked with the residency count, since dropping the whole page cache needs root — and Claude never
  runs `sudo`.
- **Sources:** `man 2 mmap`, `man 2 mincore`, `man 2 madvise`, `man 2 posix_fadvise`, `man 2 mlock`,
  `man 5 proc_pid_smaps` (Linux man-pages 6.7 on this host); kernel "Concepts overview" → "Page
  cache", <https://docs.kernel.org/admin-guide/mm/concepts.html> (docs.kernel.org, 7.3.0-rc4, read
  27/09/2026); llama.cpp `tools/server/README.md` → `--load-mode` at b11221.
- **Done when:** the exercise's tests pass clean under `san` and `memcheck`, and the record shows cold
  and warm load times with residency counts that Sam predicted first.

## 05 — KV-cache arithmetic: MHA, MQA and GQA

- **Objective:** Sam can compute the KV-cache bytes per token of a real model from its metadata,
  explain how multi-query and grouped-query attention shrink it, and check the prediction against
  measured VRAM at several context lengths.
- **Builds on:** llm-04's multi-head attention with shapes; llm-14 lesson 04 (the KV cache); llm-01
  lesson 04 (the context sweep, measured before the formula was known).
- **Key ideas:**
  - Each layer caches one key and one value vector per KV head per token, so bytes per token =
    `2 * n_layer * n_head_kv * head_dim * bytes_per_value`; the total grows linearly with context and
    with the number of sequences.
  - Multi-head attention has one KV head per query head; multi-query attention shares one KV head
    across all query heads (arXiv:1911.02150); grouped-query attention shares each KV head across a
    group — between the two (arXiv:2305.13245). The query-head count must divide evenly by the KV-head
    count.
  - The numbers come from the file, not the model card: GGUF stores `[llm].block_count`,
    `[llm].attention.head_count`, `[llm].attention.head_count_kv` and, optionally,
    `[llm].attention.key_length` (otherwise `n_embd / n_head`).
  - The value width is a choice: llama.cpp's `--cache-type-k` and `--cache-type-v` default to f16 and
    accept `q8_0`, `q4_0` and others; a quantised V cache requires Flash Attention in llama.cpp.
- **Recall targets:** derive the bytes-per-token formula from what a layer stores; predict the KV
  cache for a given context and number of sequences; say what MQA and GQA trade away.
- **Build:** `kv-budget` — a Rust crate at the planned path `code/src/rust/crates/msNNN_kv_budget/`
  that reads the KV-relevant keys from a GGUF file's metadata (safe Rust, no `unsafe`) and prints the
  KV bytes per token and for a requested context, sequence count and cache type. Tests build a tiny
  synthetic GGUF header in the test itself (never a real model file) and check the parse and the
  arithmetic, including the `key_length` fallback. Checked by `cargo test` and `cargo clippy`. Then
  run it on the llm-01 model and compare with VRAM measured at three context lengths.
- **Efficiency lens:** predicted against measured VRAM (`nvidia-smi`) at three context lengths and
  two KV cache types; the residual (compute buffers, CUDA context) is named.
- **Sources:** Shazeer, arXiv:1911.02150; Ainslie et al., arXiv:2305.13245, Section 2.2; GGUF
  specification → "Standardized key-value pairs → LLM",
  <https://github.com/ggml-org/ggml/blob/master/docs/gguf.md> (commit 6af560d); llama.cpp
  `tools/server/README.md` (`-ctk`, `-ctv`) and `src/llama-context.cpp` (the quantised-V-cache check)
  at b11221; PyTorch 2.14 `scaled_dot_product_attention` → the GQA constraints,
  <https://docs.pytorch.org/docs/2.14/generated/torch.nn.functional.scaled_dot_product_attention.html>;
  `code/docs/RUST-CODING-PRINCIPLES.md` → Section 3.
- **Done when:** the crate's tests pass, and the record shows predicted and measured KV memory for the
  llm-01 model agreeing within the named residual.

## 06 — Paged KV-cache memory

- **Objective:** Sam can explain the three ways a contiguous per-request KV cache wastes memory and
  how fixed-size blocks with a block table remove most of it, borrowing the operating system's paging
  idea.
- **Builds on:** lesson 05; kernel-03's page tables (or P2's virtual memory); P2's custom allocator
  project.
- **Key ideas:**
  - Reserving a full context per request wastes memory three ways: slots reserved for future tokens,
    internal fragmentation, and external fragmentation between requests (arXiv:2309.06180,
    Section 3).
  - PagedAttention stores the KV cache in fixed-size blocks allocated on demand; a per-request block
    table maps logical blocks to physical ones, as a page table maps virtual pages to frames.
  - Blocks carry reference counts, so parallel samples and shared prompts share physical blocks and
    copy on write when they diverge.
  - llama.cpp's server shares one unified KV buffer across its slots when the slot count is left on
    auto (`--kv-unified`), sized by `--ctx-size` and `--parallel`; vLLM is the paged reference
    design.
- **Recall targets:** name the three wastes and which one fixed-size blocks cannot remove; trace a
  block table through a copy-on-write.
- **Build:** `paged KV allocator` — a Rust crate at the planned path
  `code/src/rust/crates/msNNN_paged_kv/` that simulates KV allocation for a stream of requests of
  varying length, once contiguously and once in fixed-size blocks with reference-counted sharing, and
  reports memory in use and waste. Tests check allocation, freeing, sharing and copy-on-write on
  small hand-worked cases. Checked by `cargo test` and `cargo clippy`. A simulation, not a GPU
  kernel.
- **Efficiency lens:** waste percentage for contiguous against paged allocation on the same request
  trace, across three block sizes.
- **Sources:** Kwon et al., "Efficient Memory Management for Large Language Model Serving with
  PagedAttention", arXiv:2309.06180, Sections 3–4; vLLM "Paged Attention" design notes,
  <https://docs.vllm.ai/en/latest/design/paged_attention.html> (vLLM 0.30.0, read 27/09/2026);
  llama.cpp `tools/server/README.md` (`--kv-unified`, `--parallel`) at b11221.
- **Done when:** the crate's tests pass, and Sam predicts which block size wastes least on a given
  trace before the simulation says so.

## 07 — Prefix and prompt caching

- **Objective:** Sam can explain when a cached prompt prefix can be reused, measure the time to first
  token with and without reuse, and say why a shared cache leaks timing between users.
- **Builds on:** lessons 05–06; llm-01 lesson 05 (skills and system prompts are shared prefixes).
- **Key ideas:**
  - The KV cache of a prefix depends only on that prefix, so a request sharing it can skip its
    prefill; llama-server's `cache_prompt` (default on) re-evaluates only the unseen suffix, and
    `--cache-reuse` also reuses matching chunks by shifting the cache.
  - The server keeps prompt caches in RAM (`--cache-ram`) and can save and restore a slot's cache to
    a file; SGLang's RadixAttention (arXiv:2312.07104) and vLLM's automatic prefix caching generalise
    the idea across requests.
  - Reuse can change results slightly: llama.cpp warns that logits are not guaranteed bit-identical
    across batch sizes, so caching can make output nondeterministic.
  - Put what never changes first: a stable system prompt and skill catalogue ahead of the variable
    part is what makes the prefix reusable (the link to llm-16).
  - A cached prefix is answered faster, and that difference is observable: a cache shared across
    users is a timing side channel (arXiv:2502.07776) — llm-18 turns this into a design rule.
- **Recall targets:** predict which of two prompt orderings benefits from caching; explain the
  timing side channel in one sentence.
- **Build:** `time to first token` — a measurement. Send the same long skill-bearing prompt twice to a
  local llama-server, with and without prompt caching and with the variable part first and last,
  and record `prompt_n`, `cache_n` and `prompt_ms` (the prompt-processing time, which dominates the
  time to first token) from the response's `timings` object.
- **Efficiency lens:** `prompt_ms`, and `prompt_n` against `cache_n`, from `timings`, with and
  without reuse.
- **Security lens:** a prompt cache shared across users leaks which prefixes others sent; on this
  single-user machine it is a note, on any shared server it is a design constraint (llm-18).
- **Sources:** llama.cpp `tools/server/README.md` (`cache_prompt`, `--cache-reuse`, `--cache-ram`,
  `/slots/{id_slot}?action=save`, the `timings` object) at b11221; Zheng et al. (SGLang),
  arXiv:2312.07104; vLLM "Automatic Prefix Caching",
  <https://docs.vllm.ai/en/latest/design/prefix_caching.html> (vLLM 0.30.0); Gu et al., "Auditing
  Prompt Caching in Language Model APIs", arXiv:2502.07776.
- **Done when:** the record shows time to first token with and without reuse for both orderings, and
  Sam explains the side channel unaided.

## 08 — CPU/GPU offload splits and KV-cache types

- **Objective:** Sam can run a model that does not fit in ~9 GiB of VRAM by choosing which tensors
  live in VRAM and which in RAM, and measure what each split costs.
- **Builds on:** lessons 01, 03 and 05; llm-07 lesson 04 (the VRAM budget formula).
- **Key ideas:**
  - `-ngl` sets how many layers go to VRAM (`auto` by default, with `--fit` adjusting unset options
    to fit device memory); whatever stays on the CPU is read at RAM bandwidth, so the slowest part of
    the split sets the pace.
  - `--override-tensor` (`-ot`) places tensors by name pattern; `--n-cpu-moe` keeps the expert
    weights of the first N layers in RAM, and `--cpu-moe` keeps all of them — for a Mixture-of-Experts
    model only a few experts are read per token, so experts in RAM cost less than dense layers in RAM.
  - The KV cache competes with weights for VRAM; a smaller cache type (`-ctk`/`-ctv`) buys context
    or layers, at a measured quality cost.
  - Every split is a budget statement: weights in VRAM + KV cache + compute buffers must stay under
    the free VRAM measured today, not the card's size.
- **Recall targets:** predict how `tg` moves as layers move from VRAM to RAM; explain why expert
  weights are the cheapest thing to push to RAM.
- **Build:** `split sweep` — a measurement. Pick a model (dense or MoE) that does not fit in ~9 GiB,
  sweep `-ngl` (and `--n-cpu-moe` for an MoE model) with `llama-bench`, and record VRAM, RAM and
  `pp`/`tg` for each point in the verification record.
- **Efficiency lens:** `tg` tokens/s against layers in VRAM, beside VRAM and RSS for each point — the
  knee of the curve is the result.
- **Sources:** llama.cpp `tools/server/README.md` (`-ngl`, `--fit`, `-ot`, `--cpu-moe`,
  `--n-cpu-moe`, `-ctk`, `-ctv`) and `tools/llama-bench/README.md` at b11221; Jiang et al.
  (Mixtral), arXiv:2401.04088 (two of eight experts per token per layer).
- **Done when:** the record shows the sweep for one model with its knee named, and the chosen split
  stays under the measured free VRAM.

## 09 — Speculative decoding

- **Objective:** Sam can explain how a small draft model and a verifying target model produce the
  target's own output distribution faster, and measure when drafting pays off.
- **Builds on:** lesson 01 (a batch of tokens costs little more than one token in the memory-bound
  regime); llm-05's sampling; llm-11's tokeniser decision (the ~100M model is meant to draft for the
  ~1B base).
- **Key ideas:**
  - The draft proposes several tokens; the target scores them all in one pass and accepts a prefix;
    a modified rejection-sampling rule keeps the output distribution exactly the target's
    (arXiv:2211.17192; arXiv:2302.01318).
  - The speed-up depends on the acceptance rate and on how cheap the draft is; a draft that is often
    wrong makes generation slower, not faster.
  - Draft and target must share a vocabulary: llama.cpp refuses a pair whose vocabularies do not
    match (`common/speculative.cpp`). This is why llm-11 keeps one tokeniser for the ~100M and ~1B
    models.
  - In llama-server the draft is `--spec-draft-model` (`-md`) with `--spec-type draft-simple`;
    `--spec-draft-n-max` and `--spec-draft-n-min` bound the draft length; n-gram methods
    (`ngram-*`) draft from the context itself with no second model.
- **Recall targets:** explain why speculative decoding does not change the output distribution;
  predict the effect of a larger draft length on a low-acceptance pair.
- **Build:** `draft sweep` — a measurement. Take a same-family open model pair that fits together in
  ~9 GiB, sweep the draft length, and record acceptance and `tg` tokens/s against the target alone;
  repeat once with an n-gram method. The own-draft to own-target run waits until llm-21 produces the
  ~1B base with llm-11's tokeniser, and is appended then.
- **Efficiency lens:** accepted tokens per draft and `tg` tokens/s against the target alone, and the
  VRAM the draft costs.
- **Sources:** Leviathan et al., arXiv:2211.17192, Section 2 ("Speculative Decoding"); Chen et al.,
  arXiv:2302.01318, "Modified Rejection Sampling"; llama.cpp `docs/speculative.md`, `tools/server/README.md`
  (`--spec-*`) and `common/speculative.cpp` (the vocabulary check) at b11221.
- **Done when:** the record shows the sweep with its best draft length, and Sam explains the result
  from the acceptance rate.

## 10 — Reading ggml's AVX2 quantised dot product, then profiling it

- **Objective:** Sam can read the AVX2 path of one ggml quantised dot-product kernel, say what each
  intrinsic does to the data, and show with a profile where llama.cpp spends its time on this CPU,
  placed on llm-06's roofline.
- **Builds on:** lesson 02 (the block layouts); llm-06 lessons 04–05 (SIMD on AVX2, the roofline);
  llm-09's reading of llm.c.
- **Key ideas:**
  - ggml multiplies a quantised weight row by an activation row quantised on the fly (for example
    `ggml_vec_dot_q4_K_q8_K`), accumulating in integers per block and scaling to float once per
    block.
  - The x86 code selects an AVX2 path at compile time (`#if defined(__AVX2__)` in
    `ggml/src/ggml-cpu/arch/x86/quants.c`); `_mm256_maddubs_epi16` multiplies unsigned bytes by
    signed bytes and adds adjacent pairs into saturated 16-bit sums — the heart of the integer dot
    product, and why one operand is kept unsigned.
  - The release build ships one CPU library per instruction-set level and keeps its symbols
    (`libggml-cpu-haswell.so` on this machine, not stripped), so a profile shows function names.
  - `perf record`/`perf report` needs `kernel.perf_event_paranoid` lower than this host's 4. Sam, not
    Claude, may relax it for one session with `sudo sysctl -w kernel.perf_event_paranoid=2` (upstream
    level 2 still refuses kernel profiling to unprivileged users), profile, then restore 4 and check it
    reads back; a `sysctl -w` change also ends at reboot, because no `sysctl.d` file sets it here.
  - The unprivileged fallback is `valgrind --tool=cachegrind` on a tiny model and a few tokens: slow,
    but it counts instructions and simulated cache misses without any privilege.
- **Recall targets:** explain what `maddubs` computes and why the block scale is applied after the
  integer sum; read a `perf report` and name the hottest function and why it is hot.
- **Build:** `profile against the roofline` — a measurement and a reading note. Profile a CPU-only
  `llama-bench` run with `perf` (or cachegrind), name the top functions, compute the arithmetic
  intensity of the hottest kernel from its block layout, and place the measured throughput on
  llm-06 lesson 05's roofline for this CPU. The note annotates the kernel in Sam's own words with
  `path:line` citations to the pinned source; no ggml code is copied into the repository.
- **Efficiency lens:** share of cycles (or instructions) in the dot-product kernels; achieved
  bytes/s against measured RAM bandwidth.
- **Safety:** Claude never runs `sudo`; relaxing `perf_event_paranoid` is Sam's decision, for one
  session, restored and checked afterwards, with cachegrind as the no-privilege path.
- **Sources:** llama.cpp `ggml/src/ggml-cpu/arch/x86/quants.c` (`ggml_vec_dot_q4_K_q8_K`,
  `ggml_vec_dot_q8_0_q8_0`) and `ggml/src/ggml-common.h` at b11221; Intel Intrinsics Guide →
  `_mm256_maddubs_epi16` (guide data 3.6.9),
  <https://www.intel.com/content/www/us/en/docs/intrinsics-guide/index.html>; `man perf-record`,
  `man perf-report` (perf 7.0.14 on this host); kernel sysctl documentation →
  "perf_event_paranoid", <https://docs.kernel.org/admin-guide/sysctl/kernel.html>, and "Perf events
  and tool security", <https://docs.kernel.org/admin-guide/perf-security.html> (docs.kernel.org,
  7.3.0-rc4); `man 8 sysctl`; Cachegrind manual, <https://valgrind.org/docs/manual/cg-manual.html>
  (valgrind 3.22.0 on this host).
- **Done when:** Sam's note explains the kernel's AVX2 loop line by line in his own words, the profile
  names the hot functions, and the record places them on the roofline; if perf was used,
  `sysctl kernel.perf_event_paranoid` reads 4 again.

## 11 — Batching: throughput against latency

- **Objective:** Sam can explain why serving several sequences at once raises total throughput while
  each user's tokens arrive more slowly, and find the batch size that meets a latency target on this
  machine.
- **Builds on:** lessons 01, 05 and 06.
- **Key ideas:**
  - Batching turns decode's matrix-vector products back into matrix-matrix products, so the same
    weight reads serve several sequences; total tokens/s rises until compute or KV memory runs out.
  - Every sequence adds its own KV cache; at large batch and context the time to load the KV cache,
    not the weights, dominates (arXiv:2211.05102, Section 2).
  - llama-server's slots (`--parallel`) and continuous batching (on by default) let requests join and
    leave between steps.
  - `llama-batched-bench` separates prompt and generation speeds per batch size, with and without a
    shared prompt, and reports the KV cells each run needs.
  - Throughput is a server's number; latency is a user's. A budget states both.
- **Recall targets:** predict how per-sequence and total tokens/s move as the batch grows; explain
  why a shared prompt changes the KV requirement.
- **Build:** `batched sweep` — a measurement. Run `llama-batched-bench` over batch sizes 1 to 16
  with and without a shared prompt, and record total and per-sequence speed, KV cells and VRAM in
  the verification record; mark the batch size that keeps per-sequence `tg` above a stated target.
- **Efficiency lens:** total against per-sequence tokens/s and VRAM per batch size.
- **Security lens:** a server that accepts unbounded batch, context or output length can be driven
  out of memory by one client; the limits found here become llm-18's unbounded-consumption controls.
- **Sources:** Pope et al., arXiv:2211.05102, Section 2; Kwon et al., arXiv:2309.06180, Section 1;
  llama.cpp `tools/batched-bench/README.md` and `tools/server/README.md` (`--parallel`,
  `--cont-batching`) at b11221.
- **Done when:** the record shows the sweep and the chosen batch size with its latency, and Sam
  predicts the shape of the curve before it is drawn.
