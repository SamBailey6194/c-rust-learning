# Syllabus — llm-14-inference-in-rust

**Track**: llm · **Phase**: L5 · **Path**: Core · **Detail**: full · **Prerequisites**: P3 including async Rust, llm-07, tooling-05 lesson 02
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Inference is where the mission's efficiency and security meet the user: every token served reads the weights and the
KV cache, and every weights file is input from outside. This topic builds inference in Rust from the bytes up — reading
safetensors by hand over a memory map, refusing pickle, a hand-written CPU forward pass with a KV cache, sampling and
streaming — then the two routes to real speed: candle, admitted through a documented licence exception, and llama.cpp
through FFI. It is the base llm-15 optimises and llm-16's skill loader runs on. Lesson exercises land as crates under
`code/src/rust/crates/msNNN_<snake>/`; the serving program — streaming, and llama.cpp through FFI — lands in the
inference repository (created when this build starts). Weights are never committed.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The safetensors format, read by hand over a memory map | 2–3 sittings | yes — safetensors reader | Efficiency, Security |
| 02 | Why pickle checkpoints are never loaded | 1 sitting | no | Security |
| 03 | A hand-written CPU forward pass | 2–3 sittings | yes — forward pass matching PyTorch | Efficiency |
| 04 | The KV cache | 1 sitting | yes — cached decode | Efficiency |
| 05 | Sampling: temperature, top-k and top-p | 1 sitting | yes — sampler | — |
| 06 | Streaming tokens with async Rust | 2–3 sittings | yes — streaming server skeleton | Efficiency, Security |
| 07 | candle, behind a documented licence exception | 2–3 sittings | yes — candle port with deny.toml exceptions | Efficiency, Security |
| 08 | llama.cpp from Rust through FFI | 2–3 sittings | yes — llama-cpp-2 client | Efficiency, Security |

---

## 01 — The safetensors format, read by hand over a memory map

- **Objective:** Sam can parse a safetensors file in Rust without the safetensors crate — header length, JSON header,
  tensor slices over a memory map — and reject every malformed file he can think of.
- **Builds on:** P3 (slices, error handling, `unsafe` with a `// SAFETY:` comment); llm-05's safetensors checkpoints;
  P2's `mmap`.
- **Key ideas:**
  - The layout: 8 bytes holding the header size N as an unsigned little-endian 64-bit integer; N bytes of UTF-8 JSON
    that must begin with `{` and may be padded with spaces; then the byte buffer.
  - Each tensor entry gives a dtype, a shape and `data_offsets` [begin, end) relative to the start of the byte buffer,
    not the file; `__metadata__` is an optional map of strings to strings.
  - The format forbids holes in the buffer and duplicate keys, and data is little-endian and row-major — a reader
    checks all of it: offsets within the file, shape times dtype size equal to the byte range, no overlaps, a bounded
    header size.
  - memmap2's `Mmap::map` is `unsafe` because a file changed underneath the map is undefined behaviour; the
    `// SAFETY:` comment states what the reader relies on.
- **Recall targets:** the three parts of the file; why offsets are relative; each validation check and the attack it
  stops; the invariant behind the `unsafe` map.
- **Build:** a reader crate under `code/src/rust/crates/msNNN_<snake>/` using `memmap2` (MIT OR Apache-2.0) and
  `serde_json`; tests read files written by Python's safetensors package, and property tests (proptest) feed it
  malformed headers and truncated files that must be rejected without a panic.
- **Efficiency lens:** time and resident memory to open a large file by mapping against reading it into a buffer
  (`/usr/bin/time -v`); the page cache itself is llm-15's.
- **Security lens:** a weights file is hostile input; a reader that trusts its header is a memory-safety bug waiting
  for a file.
- **Sources:**
  - safetensors at e246a25, README "Format" and its notes:
    <https://github.com/safetensors/safetensors/tree/e246a2560645b7525f5775669ed816eb57c5bcc8>
  - Hugging Face safetensors documentation: <https://huggingface.co/docs/safetensors/index>
  - memmap2 0.9.11, `Mmap` → "Safety": <https://docs.rs/memmap2/0.9.11/memmap2/struct.Mmap.html>
  - `man 2 mmap`
- **Done when:** the tests and property tests pass, every `unsafe` block has its `// SAFETY:` comment, and clippy and
  fmt are clean.

## 02 — Why pickle checkpoints are never loaded

- **Objective:** Sam can explain why loading a pickle-based checkpoint can run arbitrary code, what `weights_only=True`
  does and does not fix, and state the repository's rule.
- **Builds on:** lesson 01; llm-12 lesson 05 (resuming with `weights_only=True`).
- **Key ideas:**
  - Python's pickle module is not secure: unpickling can execute arbitrary code, so it is never used on data from an
    untrusted source.
  - `torch.load` unpickles; its `weights_only=True` default (since PyTorch 2.6) restricts what can be built, but the
    documentation says it does not guard against denial of service and memory corruption may still be possible.
  - The rule (`.claude/CLAUDE.md` Section 5): weights load from safetensors, or from a torch checkpoint this machine
    produced loaded with `weights_only=True`; a third-party model arrives as safetensors or GGUF.
  - Converting once, in Python, and reading only safetensors from Rust keeps the unpickler out of the serving path.
- **Recall targets:** why unpickling is code execution; the limits of `weights_only=True`; the rule and where the
  conversion happens.
- **Build:** none — Sam writes the rule and its reasons in his own words in `NOTES/`.
- **Security lens:** LLM03:2025 Supply Chain (LLM04:2026) — weights are a dependency and are verified like one
  (llm-18).
- **Sources:**
  - Python 3.14 documentation, `pickle` (the warning at the top): <https://docs.python.org/3.14/library/pickle.html>
  - PyTorch 2.14, Serialization semantics → "weights_only security":
    <https://docs.pytorch.org/docs/2.14/notes/serialization.html>
  - safetensors README (URL as lesson 01): its comparison of formats
- **Done when:** Sam explains the risk and the rule unaided, and the note is written.

## 03 — A hand-written CPU forward pass

- **Objective:** Sam can run the forward pass of his small GPT in plain Rust from safetensors weights and match
  PyTorch's logits within a tolerance.
- **Builds on:** lesson 01; llm-04 and llm-05 (the model); llm-09 lesson 02 (the same pass in C); llm-06 (loop order
  and cache lines).
- **Key ideas:**
  - The pass is the same sequence as llm.c's: embeddings, then per block layer norm, causal attention, residual, layer
    norm, MLP, residual; final layer norm and logits.
  - Weights are borrowed slices of the mapped file, not copies; activations are preallocated buffers reused per token.
  - Matmul loop order decides cache behaviour; the naive order is correct first, then measured and improved.
  - Agreement with PyTorch is tested on fixed inputs within a tolerance, never by eye.
- **Recall targets:** the order of operations; why weights stay borrowed; the tolerance and why it is not zero.
- **Build:** a forward-pass crate under `code/src/rust/crates/msNNN_<snake>/` built on lesson 01's reader, loading the
  llm-05 model exported to safetensors; the test compares logits with values PyTorch produced for the same tokens.
- **Efficiency lens:** tokens per second and peak resident memory (`/usr/bin/time -v`) for a fixed prompt, measured as
  llm-06 lesson 01 teaches.
- **Sources:**
  - Vaswani et al., "Attention Is All You Need", arXiv:1706.03762v7, Section 3.2 (scaled dot-product attention and
    the decoder's mask)
  - llm.c `train_gpt2.c` at f1e2ace, `gpt2_forward` (reading):
    <https://github.com/karpathy/llm.c/blob/f1e2ace651495b74ae22d45d1723443fd00ecd3a/train_gpt2.c>
- **Done when:** the logits test passes, and the throughput table is in the journal.

## 04 — The KV cache

- **Objective:** Sam can add a KV cache to his forward pass, prove it changes nothing but speed, and compute its size
  from the model's configuration.
- **Builds on:** lesson 03.
- **Key ideas:**
  - Without a cache, each new token recomputes keys and values for the whole prefix; with one, each step computes them
    for the new token only and appends.
  - The cache holds keys and values for every layer and position: its size grows with layers, heads, head size,
    sequence length and bytes per value — Sam derives the formula from his configuration.
  - For large batches and long contexts the cache can outgrow the weights, and reading it every step dominates decode
    time — the reason llm-15 shrinks it.
  - Correctness test: decoding with and without the cache gives the same logits.
- **Recall targets:** what is cached and why only keys and values; the size formula; why the cache makes decode
  memory-bound.
- **Build:** cached decode in the lesson 03 crate; tests assert identical logits with and without the cache over a
  sequence, and a measured memory figure is compared with the formula.
- **Efficiency lens:** tokens per second with and without the cache as the sequence grows; cache bytes against the
  formula.
- **Sources:**
  - Pope et al., "Efficiently Scaling Transformer Inference", arXiv:2211.05102v1, Section 2.1
  - arXiv:1706.03762v7, Section 3.2.3 (masking to preserve the auto-regressive property)
- **Done when:** the equivalence test passes, and Sam's formula matches the measured cache size.

## 05 — Sampling: temperature, top-k and top-p

- **Objective:** Sam can turn logits into the next token with temperature, top-k and top-p, reproducibly under a seed.
- **Builds on:** lesson 04; llm-05 (sampling in Python).
- **Key ideas:**
  - Greedy decoding takes the most likely token and is deterministic — the reference for tests.
  - Temperature divides the logits before softmax: lower sharpens, higher flattens.
  - Top-k keeps the k most likely tokens; top-p (nucleus) keeps the smallest set whose probability reaches p, which
    adapts to how confident the model is.
  - A seeded random-number generator makes a sampled output reproducible for tests.
- **Recall targets:** what each knob does to the distribution; why top-p adapts where top-k does not; how a sampled
  test stays deterministic.
- **Build:** a sampler module in the lesson 03 crate, tested on fixed distributions where the kept set can be worked
  out by hand, and on seeded sequences.
- **Sources:**
  - Holtzman et al., "The Curious Case of Neural Text Degeneration", arXiv:1904.09751v2, Sections 3.1 and 3.3
- **Done when:** the tests pass, and Sam explains nucleus sampling unaided.

## 06 — Streaming tokens with async Rust

- **Objective:** Sam can stream tokens to a client as they are produced, keep the async runtime responsive while the
  CPU-bound decode loop runs, and stop generation when the client goes away.
- **Builds on:** P3's async Rust (futures, the tokio runtime, tasks and channels, `select!`, cancellation,
  `spawn_blocking`); lessons 03–05.
- **Key ideas:**
  - The decode loop is CPU-bound, so it runs off the async workers — on a dedicated thread or through `spawn_blocking`
    — and sends tokens over a channel.
  - A bounded channel gives backpressure: a slow client slows the producer instead of growing a queue.
  - A running `spawn_blocking` task cannot be aborted, so cancellation is cooperative: the loop checks a flag or a
    closed channel between tokens.
  - Limits belong here too: a maximum number of new tokens and a request timeout.
- **Recall targets:** why the decode loop stays off the async workers; what a bounded channel buys; how a blocking task
  is stopped.
- **Build:** a streaming CLI or local-socket server skeleton in the inference repository (created when this build
  starts), driving the lesson 03–05 engine; tests cover cancellation mid-stream and the token limit.
- **Efficiency lens:** time to first token and tokens per second with streaming, against lesson 03's batch run.
- **Security lens:** LLM10:2025 Unbounded Consumption (LLM06:2026) — token limits, timeouts and bounded queues are
  the first defence; llm-18 owns the full threat model.
- **Sources:**
  - tokio 1.53.1, `tokio::sync::mpsc` (bounded and unbounded channels):
    <https://docs.rs/tokio/1.53.1/tokio/sync/mpsc/index.html>
  - tokio 1.53.1, `tokio::task::spawn_blocking` (CPU-bound work, and why it cannot be aborted):
    <https://docs.rs/tokio/1.53.1/tokio/task/fn.spawn_blocking.html>
  - The Rust Programming Language, Chapter 17 "Fundamentals of Asynchronous Programming":
    <https://doc.rust-lang.org/book/ch17-00-async-await.html>
  - OWASP Top 10 for LLM Applications 2025, LLM10: <https://genai.owasp.org/llm-top-10/> (the 2026 IDs are mapped
    in `llm-18-secure-llm-systems` lesson 01)
- **Done when:** the cancellation and limit tests pass, and Sam explains the thread and channel design unaided.

## 07 — candle, behind a documented licence exception

- **Objective:** Sam can bring candle into the workspace through the exceptions the crate-licence ADR allows, read
  `cargo deny`'s licence report, and compare a candle port of his forward pass with his own.
- **Builds on:** tooling-05 lesson 02 (Apache-2.0 against GPL-2.0-only, reading `cargo deny` output, writing an
  exception); lesson 03.
- **Key ideas:**
  - This repository is GPL-2.0-only; `code/src/rust/deny.toml` allows permissive licences and admits an Apache-2.0-only
    crate only through a per-crate exception with a written justification.
  - candle-core 0.11.0 is MIT OR Apache-2.0, but it requires safetensors 0.8 and tokenizers 0.22 (both
    Apache-2.0-only), and tokenizers in turn requires esaxx-rs and spm_precompiled (both Apache-2.0-only). It passes
    only with four per-crate exceptions, as the cargo-deny table in `ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md`
    records (learning use; this repository distributes no binaries); run `cargo deny check licenses` on the day to
    confirm the set.
  - Order matters: `cargo add` changes the manifest, and the next build runs the new crate's build scripts — so
    `cargo deny check` runs before any build (the comment at the top of `code/src/rust/deny.toml`).
  - The comparison is the lesson: same weights, same tokens, logits within tolerance, and speed side by side.
- **Recall targets:** why candle fails the gate without exceptions; what an exception must say; why the audit runs
  before the build.
- **Build:** a crate under `code/src/rust/crates/msNNN_<snake>/` porting lesson 03's forward pass to candle, with one
  `[[licenses.exceptions]]` entry per Apache-2.0-only crate that `cargo deny` reports (four at candle-core 0.11.0:
  safetensors, tokenizers, esaxx-rs, spm_precompiled) added to `code/src/rust/deny.toml`, each citing the ADR;
  `code/src/scripts/rust/audit.sh` passes, and a test compares logits with lesson 03's crate.
- **Efficiency lens:** tokens per second and peak resident memory, hand-written against candle, same prompt.
- **Security lens:** a new dependency tree is a supply-chain change; `cargo tree` and the advisory check are read
  before the first build.
- **Sources:**
  - docs.rs, `candle-core` 0.11.0 (licence and dependencies): <https://docs.rs/crate/candle-core/0.11.0>
  - docs.rs, `safetensors` 0.8.0 (licence Apache-2.0): <https://docs.rs/crate/safetensors/0.8.0>
  - candle repository: <https://github.com/huggingface/candle>
  - `code/src/rust/deny.toml` (the `[licenses]` section and its comments)
- **Done when:** the audit passes with exactly the documented exceptions, the logits test passes, and the speed table
  is in the journal.

## 08 — llama.cpp from Rust through FFI

- **Objective:** Sam can load a GGUF model through the llama-cpp-2 crate, generate text from Rust, and compare speed and
  VRAM with llm-01's ollama baseline.
- **Builds on:** P3's FFI lessons and `code/docs/FFI.md`; llm-01 (the baseline model and its measurements); lessons
  05–06.
- **Key ideas:**
  - llama-cpp-2 0.1.157 (MIT OR Apache-2.0) wraps llama-cpp-sys-2, whose build compiles llama.cpp with CMake and
    generates bindings with bindgen, which needs libclang (Clang 9 or later) — none of which is installed here yet.
  - GPU offload needs the crate's `cuda` feature, and so the CUDA toolkit (llm-08's blocker).
  - FFI rules from `code/docs/FFI.md`: a thin boundary, never panic across it, and one clear owner for every
    allocation.
  - GGUF is little-endian by default and is parsed by C and C++ code: the model file is untrusted input, pinned by
    digest as in llm-01.
- **Recall targets:** what the sys crate's build needs and why; the FFI rules; why the GGUF file is pinned.
- **Build:** a llama-cpp-2 client in the inference repository (created when this build starts) that loads the llm-01
  baseline model's GGUF, streams through lesson 06's design, and records tokens per second and VRAM. **Blocked** until
  CMake and libclang are installed (`GAPS.md` → "LLM track tools not installed"), and its GPU path until the CUDA
  toolkit is (`GAPS.md` → "CUDA toolkit (`nvcc`) not installed").
- **Efficiency lens:** tokens per second, time to first token and peak VRAM (`nvidia-smi`) against llm-01's ollama
  figures for the same model and quantisation.
- **Security lens:** C and C++ parse the model file; only digest-pinned files from known sources are loaded.
- **Sources:**
  - docs.rs, `llama-cpp-2` 0.1.157: <https://docs.rs/crate/llama-cpp-2/0.1.157>; `llama-cpp-sys-2` 0.1.157 (build
    dependencies): <https://docs.rs/crate/llama-cpp-sys-2/0.1.157>
  - utilityai/llama-cpp-rs README: <https://github.com/utilityai/llama-cpp-rs>
  - rust-bindgen, "Requirements": <https://rust-lang.github.io/rust-bindgen/requirements.html>
  - GGUF specification: <https://github.com/ggml-org/ggml/blob/master/docs/gguf.md>
  - The Rustonomicon, "Foreign Function Interface": <https://doc.rust-lang.org/nomicon/ffi.html>
- **Done when:** the client runs the baseline model, and the comparison with llm-01's figures is in the journal.
