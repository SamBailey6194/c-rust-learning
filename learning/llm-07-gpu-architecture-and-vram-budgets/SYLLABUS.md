# Syllabus — llm-07-gpu-architecture-and-vram-budgets

**Track**: llm · **Phase**: L2 · **Path**: Core · **Detail**: full · **Prerequisites**: llm-05 (a model to account for); llm-06 lessons 01 and 05 recommended (the measurement method and the roofline)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

What the RTX 2080 Ti is made of, what it can do at best, and where every byte of its memory goes.
The topic reads the GPU as the CUDA programming model describes it (SMs, warps, memory spaces),
fixes this card's Turing numbers, measures its roofline, and then turns VRAM from a surprise into a
budget: a formula for weights, gradients, optimiser state, activations and the KV cache, checked
against PyTorch's own memory statistics on the llm-05 model, and a profile of where the time goes.
Every later LLM milestone states a VRAM budget; this is where the budget comes from. It is the
prerequisite for writing CUDA (llm-08) and for sizing the ~100M model (llm-12) against **~9 GiB of
free VRAM**, since the card also drives the desktop.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | SMs, warps and the memory spaces | 1 sitting | yes — device-properties probe | — |
| 02 | Turing in numbers: this card's ceilings | 1 sitting | no | Efficiency |
| 03 | The GPU roofline, measured | 1 sitting | yes — throughput and bandwidth probes | Efficiency |
| 04 | The VRAM budget formula | 2–3 sittings | yes — budget calculator | Efficiency |
| 05 | Measuring VRAM: torch.cuda statistics against nvidia-smi | 2–3 sittings | yes — budget against measured for llm-05 | Efficiency, Security |
| 06 | Profiling a training step: torch.profiler, then Nsight | 2–3 sittings | yes — profile of llm-05 | Efficiency, Safety |

**Where the work lands.** Small exercises in this repository under `code/src/python/` (planned —
added at L1). The budget calculator is pure Python and tested on the CPU in CI; the GPU probes and
profiles run locally, and their numbers go in the milestone's verification record under
`project-management/src/10-PROGRESS/`. Traces and memory snapshots are kept out of git.

---

## 01 — SMs, warps and the memory spaces

- **Objective:** Sam can describe how a GPU runs a kernel — a grid of thread blocks scheduled onto
  SMs, executed in warps of 32 threads — and place each memory space (registers, shared memory, L1,
  L2, global DRAM) on the chip or off it.
- **Builds on:** llm-02 lessons 03–04 (devices, asynchronous execution); llm-06 lesson 02 (a
  memory hierarchy on the CPU).
- **Key ideas:**
  - A GPU is a set of streaming multiprocessors (SMs), each with a register file, a unified data
    cache and functional units.
  - Threads are grouped into blocks and blocks into a grid; each block runs on one SM, and its
    threads execute in warps of 32 in single-instruction, multiple-thread (SIMT) fashion.
  - Registers are per thread, shared memory is per block and on the SM, L2 is shared by all SMs,
    and global memory is the card's DRAM — the VRAM the budget is about.
  - GPUs hide memory latency by keeping many warps resident and switching between them, not by
    large caches.
- **Recall targets:** draw the grid → block → warp → thread hierarchy; order the memory spaces by
  size and speed; explain how a GPU hides latency differently from a CPU.
- **Build:** a device-properties probe that prints what `torch.cuda.get_device_properties(0)`
  reports and compares it with the whitepaper; the test skips without a GPU.
- **Sources:** NVIDIA, CUDA Programming Guide v13.4.2, Sections 1.2.2 "GPU Hardware Model", 1.2.2.2
  "Warps and SIMT" and 1.2.3 "GPU Memory" (<https://docs.nvidia.com/cuda/cuda-programming-guide/01-introduction/programming-model.html>);
  Turing Tuning Guide 13.4, Section 1.4.1.1 "Instruction Scheduling"
  (<https://docs.nvidia.com/cuda/turing-tuning-guide/index.html>); PyTorch 2.14
  `torch.cuda.get_device_properties` (<https://docs.pytorch.org/docs/2.14/generated/torch.cuda.get_device_properties.html>).
- **Done when:** the probe's output is saved beside the whitepaper figures and Sam draws the
  execution and memory hierarchy from memory.

## 02 — Turing in numbers: this card's ceilings

- **Objective:** Sam can quote this RTX 2080 Ti's architectural numbers, compute its ridge points,
  and explain what having fp16 tensor cores but no bf16 or TF32 means for training.
- **Builds on:** lesson 01; llm-06 lesson 05 (the roofline).
- **Key ideas:**
  - The card: 68 SMs, each with 64 FP32 cores and 8 tensor cores; up to 32 resident warps and 64K
    32-bit registers per SM; 96 KB of unified L1 and shared memory per SM (64 KB or 32 KB of it as
    shared memory); 5632 KB (5.5 MiB) of L2; 11264 MB of GDDR6 on a 352-bit bus at 616 GB/s.
  - Peak rates at reference clocks: 13.4 TFLOPS FP32; 53.8 TFLOPS on fp16 tensor cores with fp32
    accumulation, and 107.6 with fp16 accumulation. PyTorch's fp16 matmuls accumulate in fp32
    unless `allow_fp16_accumulation` is switched on, so 53.8 is the ceiling that applies.
  - Compute capability 7.5 tensor cores take FP16, INT8 and INT4 — not TF32 and not BF16 — which is
    why llm-05 trains in fp16 with a gradient scaler.
  - Ridge point = peak FLOP/s divided by bandwidth; with those numbers a kernel needs tens of FLOPs
    per byte before compute limits it, and decode-style matrix-vector work sits far below that.
  - Whitepaper peaks assume reference clocks; the card's actual clocks (`nvidia-smi -q -d CLOCK`)
    and the desktop's share of the card lower what is reachable.
- **Recall targets:** quote SM count, bandwidth, L2 size and the two tensor-core peaks; compute the
  FP32 and FP16-tensor ridge points; say which tensor-core input types Turing lacks.
- **Build:** none — the ridge-point arithmetic goes in the lesson's note and feeds lesson 03.
- **Efficiency lens:** the ceilings table (peak FLOP/s per precision, bandwidth, ridge points) that
  every later GPU measurement is compared against.
- **Sources:** NVIDIA Turing GPU Architecture whitepaper WP-09183-001_v01, Table 1
  (<https://images.nvidia.com/aem-dam/en-zz/Solutions/design-visualization/technologies/turing-architecture/NVIDIA-Turing-Architecture-Whitepaper.pdf>);
  Turing Tuning Guide 13.4, Sections 1.4.1.3 "Occupancy" and 1.4.3.1 on the unified shared memory,
  L1 and texture cache (<https://docs.nvidia.com/cuda/turing-tuning-guide/index.html>); CUDA
  Programming Guide v13.4.2, "Compute Capabilities" appendix, Tables 30–33
  (<https://docs.nvidia.com/cuda/cuda-programming-guide/05-appendices/compute-capabilities.html>);
  PyTorch 2.14 "CUDA semantics → Full FP16 Accumulation in FP16 GEMMs"
  (<https://docs.pytorch.org/docs/2.14/notes/cuda.html>); `man nvidia-smi`.
- **Done when:** Sam fills the ceilings table from memory and derives both ridge points.

## 03 — The GPU roofline, measured

- **Objective:** Sam can measure this card's achieved matmul throughput in fp32 and fp16 and its
  achieved memory bandwidth, and state each as a fraction of the lesson 02 ceiling.
- **Builds on:** lesson 02; llm-02 lesson 04 (timing GPU work).
- **Key ideas:**
  - Achieved TFLOPS is `2 * m * n * k` divided by the synchronised time of one matmul, after
    warm-up; only large matmuls approach the peak.
  - Achieved bandwidth is bytes read plus bytes written divided by time for a large device-to-device
    copy; host-to-device copies run over PCIe and are much slower.
  - The gap between achieved and peak is information: clocks, the desktop's use of the card, and
    kernel efficiency all show up in it.
  - Results depend on the build of PyTorch, the driver and the card's state, so the record names
    all three.
- **Recall targets:** predict the fraction of peak a small matmul reaches and why; say which roof a
  large copy measures.
- **Build:** probes for fp32 and fp16 matmul throughput across sizes and for device-to-device and
  host-to-device bandwidth, with results tabled against the ceilings; the probe skips without a GPU
  in CI.
- **Efficiency lens:** achieved fraction of each roof, recorded in the ceilings table.
- **Sources:** PyTorch 2.14 "CUDA semantics → Asynchronous execution"
  (<https://docs.pytorch.org/docs/2.14/notes/cuda.html>) and "Benchmark Utils"
  (<https://docs.pytorch.org/docs/2.14/benchmark_utils.html>); CUDA C++ Best Practices Guide →
  Section 9 "Performance Metrics", 9.2.2 "Effective Bandwidth Calculation"
  (<https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html>);
  Turing whitepaper, Table 1.
- **Done when:** the table holds achieved and peak values for every row and Sam explains each gap.

## 04 — The VRAM budget formula

- **Objective:** Sam can predict a training run's peak VRAM from the model configuration, the
  precision and the optimiser, and an inference run's from the weights and the KV cache.
- **Builds on:** lessons 01–03; llm-03 lessons 06–07 (optimiser state, bytes per format); llm-04
  (shapes and parameter counts).
- **Key ideas:**
  - Training memory = weights + gradients + optimiser state + activations + fixed overheads (the
    CUDA context, library workspaces, allocator slack), which are measured rather than derived.
  - Bytes per parameter depend on the precisions: ZeRO's accounting for mixed-precision Adam comes
    to 16 bytes per parameter (fp16 weights and gradients, plus fp32 weights, momentum and
    variance); Sam derives the figure for his own llm-05 set-up.
  - Activations grow with batch size, sequence length, width and depth; Korthikanti et al. give
    `s * b * h * (34 + 5 * a * s / h)` bytes per layer for their fp16 set-up with dropout — a model
    with stated assumptions, not a law.
  - Inference replaces gradients and optimiser state with the KV cache:
    `2 * layers * kv_heads * head_dim * bytes_per_value` per token (PagedAttention's example: about
    800 KB per token for OPT-13B in fp16).
  - The budget is set against free memory from `mem_get_info()`, not the card's 11 GiB.
- **Recall targets:** list the terms of the training and inference budgets; derive bytes per
  parameter for a stated precision and optimiser; compute a KV cache size for a stated model and
  context.
- **Build:** a budget calculator (pure functions) for training and inference, with pytest cases that
  reproduce ZeRO's 16 bytes per parameter and PagedAttention's per-token figure, then a prediction for
  the llm-05 model written down before lesson 05 measures it.
- **Efficiency lens:** the predicted peak for llm-05, and the largest model that fits ~9 GiB under
  each precision and optimiser.
- **Sources:** Rajbhandari et al., "ZeRO", arXiv:1910.02054, Section 3.1 "Model States: Optimizer
  States, Gradients and Parameters"; Korthikanti et al., "Reducing Activation Recomputation in Large
  Transformer Models", arXiv:2205.05198, Section 4.1 and equation 1; Kwon et al., "PagedAttention",
  arXiv:2309.06180, Section 3; Chen et al., "Training Deep Nets with Sublinear Memory Cost",
  arXiv:1604.06174 (activation checkpointing, for the trade-off llm-12 uses).
- **Done when:** the calculator's tests pass and the llm-05 prediction is recorded before
  measurement.

## 05 — Measuring VRAM: torch.cuda statistics against nvidia-smi

- **Objective:** Sam can measure where VRAM goes during a training step, reconcile PyTorch's
  numbers with `nvidia-smi`'s, and compare the result with the lesson 04 prediction.
- **Builds on:** lesson 04; llm-05 lesson 03.
- **Key ideas:**
  - PyTorch's caching allocator keeps freed blocks for reuse: `memory_allocated` counts memory held
    by tensors, `memory_reserved` counts what the allocator holds, and `nvidia-smi` shows the
    reserved memory plus the CUDA context and every other process, including the desktop.
  - `reset_peak_memory_stats` then `max_memory_allocated` gives the peak of a step; reading the
    counters after model creation, the first backward and the first optimiser step separates
    weights, gradients and optimiser state.
  - `mem_get_info` reports free and total memory as the driver sees it.
  - A memory snapshot (`torch.cuda.memory._record_memory_history`, then `_dump_snapshot`) shows
    every allocation over time in PyTorch's memory visualiser.
- **Recall targets:** explain why `nvidia-smi` reports more than `memory_allocated`; name the
  counter for a step's peak; say what each checkpoint in the step isolates.
- **Build:** instrument the llm-05 training step to record each component and the peak, compare
  them with the lesson 04 prediction, and explain the residual; recorded as budget against measured
  in the milestone's verification record.
- **Efficiency lens:** predicted against measured for each component, and the size of the
  unexplained overhead.
- **Security lens:** a memory snapshot is written as a pickle; only snapshots this machine produced
  are opened, and none is shared or committed.
- **Sources:** PyTorch 2.14 "CUDA semantics → Memory management"
  (<https://docs.pytorch.org/docs/2.14/notes/cuda.html>), "Understanding CUDA Memory Usage"
  (<https://docs.pytorch.org/docs/2.14/torch_cuda_memory.html>), `max_memory_allocated`
  (<https://docs.pytorch.org/docs/2.14/generated/torch.cuda.memory.max_memory_allocated.html>),
  `reset_peak_memory_stats` (<https://docs.pytorch.org/docs/2.14/generated/torch.cuda.memory.reset_peak_memory_stats.html>)
  and `mem_get_info` (<https://docs.pytorch.org/docs/2.14/generated/torch.cuda.memory.mem_get_info.html>);
  PyTorch memory visualiser (<https://pytorch.org/memory_viz>); `man nvidia-smi`.
- **Done when:** every component has a predicted and a measured value, and the residual is explained
  or bounded.

## 06 — Profiling a training step: torch.profiler, then Nsight

- **Objective:** Sam can profile a training step to see which kernels take the time and memory,
  explain why GPU hardware counters are locked on this machine, and relax that lock for one session
  himself when a lesson truly needs counters.
- **Builds on:** lesson 05; llm-05 lesson 04 (the fp16 run).
- **Key ideas:**
  - `torch.profiler` records CPU operators and CUDA kernels (`ProfilerActivity.CPU` and `.CUDA`),
    with shapes and memory on request; `key_averages()` ranks them and a Chrome trace shows the
    timeline. A schedule with wait, warm-up and active steps keeps start-up out of the profile.
  - Comparing the fp32 and fp16 profiles shows which kernels moved onto tensor cores.
  - Hardware counters (achieved occupancy, memory throughput per kernel) come from Nsight Compute,
    and Nsight Systems samples GPU metrics; neither is installed yet, and both need counter access.
  - This driver restricts counters to administrators (`RmProfilingAdminOnly: 1` in
    `/proc/driver/nvidia/params`), NVIDIA's response to a GPU side-channel paper; the error is
    `ERR_NVGPUCTRPERM`.
  - NVIDIA documents two one-session routes on driver 580. First, per process: Sam launches the
    profiler himself with `sudo` (or with `CAP_SYS_ADMIN`, or `CAP_PERFMON` from R565), which changes
    nothing persistent, though the profiled program runs as root too. Second, the module option: stop
    the display manager, unload the NVIDIA modules, load `nvidia` with
    `NVreg_RestrictProfilingToAdminUsers=0`, then later reload it with `=1` — because this card drives
    the desktop, that means leaving the graphical session. The capability-file method needs R610+.
- **Recall targets:** say what `torch.profiler` can and cannot show; explain why counters are
  locked and what relaxing the lock exposes; compare the two one-session routes and what each costs.
- **Build:** profiles of the llm-05 training step in fp32 and fp16 with `torch.profiler`, the top
  kernels by CUDA time tabled for each; traces kept out of git, their summaries recorded.
- **Efficiency lens:** share of step time in the top kernels, and the fp32 against fp16 kernel mix.
- **Safety:** Claude never runs `sudo`. If a later lesson needs counters, Sam takes one of the two
  routes himself: the per-process `sudo` launch of the profiler, only on his own code; or, after saving
  his work, the module reload, then reloading with the restriction on (or rebooting, since nothing is
  written to `/etc/modprobe.d`). The torch.profiler path is taught either way.
- **Sources:** PyTorch 2.14 "torch.profiler" (<https://docs.pytorch.org/docs/2.14/profiler.html>) and
  the "PyTorch Profiler" recipe (<https://docs.pytorch.org/tutorials/recipes/recipes/profiler_recipe.html>);
  NVIDIA, "ERR_NVGPUCTRPERM" → "Run with Elevated Privileges" and "Enable Access Temporarily"
  (<https://developer.nvidia.com/nvidia-development-tools-solutions-err_nvgpuctrperm-permission-issue-performance-counters>,
  read 27/09/2026); Nsight Systems User Guide → GPU metrics permissions
  (<https://docs.nvidia.com/nsight-systems/UserGuide/index.html>); Nsight Compute Profiling Guide
  (<https://docs.nvidia.com/nsight-compute/ProfilingGuide/index.html>).
- **Done when:** both profiles are summarised in the record, and Sam explains the counter lock and
  the steps to lift and restore it without doing so.
