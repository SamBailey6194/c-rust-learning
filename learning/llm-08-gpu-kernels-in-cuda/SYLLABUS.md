# Syllabus — llm-08-gpu-kernels-in-cuda

**Track**: llm · **Phase**: L2 · **Path**: Core · **Detail**: full · **Prerequisites**: llm-07, P2; every Build is Blocked until the CUDA toolkit is installed (`GAPS.md` → "CUDA toolkit (`nvcc`) not installed")
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

A GPU kernel is where training and inference time is actually spent. This topic takes llm-07's memory spaces and VRAM
arithmetic down to hand-written CUDA C++ on this machine's RTX 2080 Ti (Turing, compute capability 7.5): the thread
hierarchy, honest timing, coalesced access, shared-memory tiling, reductions and softmax, each checked against a CPU
reference and finally measured against cuBLAS. It serves the mission's "uses GPU, VRAM and cache efficiently" directly,
and it is the bridge to llm.c's CUDA path (llm-09) and to reading ggml's kernels (llm-15). The exercises are small and
land under `code/src/cuda/` (planned — added at L2). CI has no GPU, so whether CI compiles them is an open question in
`GAPS.md`; they run locally, and the journal records the evidence.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Choosing a CUDA toolkit for driver 580 | 1 sitting | no | Safety |
| 02 | The thread hierarchy: a first kernel | 1 sitting | yes — vector add | Security |
| 03 | Timing GPU work and effective bandwidth | 1 sitting | yes — copy-bandwidth bench | Efficiency |
| 04 | Coalesced global memory access | 1 sitting | yes — naive transpose | Efficiency |
| 05 | Shared memory, barriers and bank conflicts | 2–3 sittings | yes — tiled transpose | Efficiency, Security |
| 06 | A shared-memory tiled matrix multiply | 2–3 sittings | yes — tiled SGEMM | Efficiency |
| 07 | Reductions and a numerically stable softmax | 2–3 sittings | yes — row softmax | Efficiency |
| 08 | Correctness and speed against cuBLAS | 2–3 sittings | yes — cuBLAS comparison harness | Efficiency, Security, Safety |

---

## 01 — Choosing a CUDA toolkit for driver 580

- **Objective:** Sam can choose a CUDA toolkit version and package that this machine's driver 580 runs, explain the
  choice, and install it himself without touching the display driver.
- **Builds on:** llm-07 (compute capability 7.5, reading `nvidia-smi`); llm-02's PyTorch install on the same card.
- **Key ideas:**
  - Each toolkit minor release is paired with a driver branch: 13.0 with R580, 13.4 with R615.
  - Minor-version compatibility lets any 13.x toolkit run on a driver of 580 or later, with limits: a feature that needs
    a newer driver fails, and device code shipped only as PTX will not run on the older driver.
  - So device code is built as a real-architecture binary for this card: `nvcc -arch=sm_75`, which is also nvcc 13.4's
    default target. CUDA 13 dropped Maxwell, Pascal and Volta; Turing is still supported.
  - Packages: from 13.4 no toolkit meta package installs or depends on the driver; in 13.0 the `cuda` meta package also
    pulls driver packages. A toolkit-only package keeps the desktop's driver as it is.
  - The card also drives the desktop, so a driver change is a risk to the session Sam learns in.
- **Recall targets:** which driver branch a given 13.x toolkit pairs with; what minor-version compatibility does and
  does not cover; why `-arch=sm_75` matters on this machine; which kind of package would replace the driver.
- **Build:** none — the outcome is Sam's own install, the version recorded in `how-to/docs/TOOLCHAIN.md` and the
  `GAPS.md` CUDA toolkit entry closed.
- **Safety:** Sam runs every install command himself; Claude never runs `sudo`. Install a toolkit-only package, never
  the `cuda` or driver meta packages; read the versioned package name from the chosen release's installation guide on
  the day. The 13.4 guide warns that `apt autoremove` can remove a driver that was only an automatic dependency of an
  older `cuda` meta package, so check before any autoremove.
- **Sources:**
  - CUDA Toolkit 13.4 Update 1 release notes, Section 2.2 "CUDA Driver", Tables 2–3:
    <https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html>; the 13.0 release notes, Section 2.6.2
    Deprecated Architectures: <https://docs.nvidia.com/cuda/archive/13.0.0/cuda-toolkit-release-notes/index.html>
  - CUDA Compatibility → Minor Version Compatibility, "Application Considerations":
    <https://docs.nvidia.com/deploy/cuda-compatibility/minor-version-compatibility.html>
  - nvcc 13.4, Section 4.2.7.1 `--gpu-architecture` (default `sm_75`) and Section 5.2 GPU Feature List:
    <https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html>
  - CUDA Installation Guide for Linux 13.4, Section 4.11.2 Meta Packages and Section 5 Driver Installation:
    <https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html>; the 13.0 guide, Section 4.12.2:
    <https://docs.nvidia.com/cuda/archive/13.0.0/cuda-installation-guide-linux/index.html>
  - `man 1 nvidia-smi`
- **Done when:** `nvcc --version` reports a 13.x toolkit, `nvidia-smi` still reports driver 580 and the desktop is
  unaffected, and Sam explains the choice unaided.

## 02 — The thread hierarchy: a first kernel

- **Objective:** Sam can write, launch and check a kernel over a one-dimensional array: pick a block size, size the grid
  to cover N, guard the tail, move data both ways and check for errors.
- **Builds on:** lesson 01; P2 C (pointers, allocation, error returns); llm-07 (SMs and warps).
- **Key ideas:**
  - A launch is a grid of blocks of threads; `gridDim`, `blockDim`, `blockIdx` and `threadIdx` locate each thread, with
    `x` varying fastest.
  - A global index comes from the block and thread indices; the last block is usually partial, so a bounds check is
    part of every kernel.
  - A launch returns no error code and runs asynchronously: check the error state straight after it for launch errors,
    and expect an error during execution to be reported only when the error state is next examined.
  - Compute capability 7.5 limits: at most 1024 threads per block, a warp of 32, and 1024 resident threads per SM.
  - Device memory is separate from host memory here: allocate, copy in, launch, copy out, free.
- **Recall targets:** the grid size for a given N and block size; what the threads beyond N do without a guard; why a
  failed launch can be reported later than the line that caused it.
- **Build:** a vector add under `code/src/cuda/msNNN-<kebab>/` (planned — added at L2): a CPU reference, the kernel, a
  checked launch and a test that compares every element for several N, including ones that are not a multiple of the
  block size; built with `nvcc -arch=sm_75` and run under `compute-sanitizer --tool memcheck`. **Blocked** until nvcc
  is installed (`GAPS.md` → "CUDA toolkit (`nvcc`) not installed").
- **Security lens:** an out-of-range write on the GPU corrupts a neighbouring allocation without a crash; Compute
  Sanitizer's memcheck plays the role ASan plays for C (`code/docs/MEMORY-SAFETY.md` — Section 4).
- **Sources:**
  - CUDA Programming Guide 13.4.2, Section 2.3.2 Thread Hierarchy and Section 2.3.3.1 Global Memory:
    <https://docs.nvidia.com/cuda/cuda-programming-guide/02-basics/writing-cuda-kernels.html>
  - CUDA Programming Guide 13.4.2, Section 2.1.7 Error Checking in CUDA:
    <https://docs.nvidia.com/cuda/cuda-programming-guide/02-basics/intro-to-cuda-cpp.html>
  - CUDA Programming Guide 13.4.2, Section 5.1.3, Table 30 (per-compute-capability limits):
    <https://docs.nvidia.com/cuda/cuda-programming-guide/05-appendices/compute-capabilities.html>
  - Compute Sanitizer, the Memcheck tool: <https://docs.nvidia.com/compute-sanitizer/ComputeSanitizer/index.html>
  - NVIDIA cuda-samples v13.4, `cpp/0_Introduction/vectorAdd` (reading only):
    <https://github.com/NVIDIA/cuda-samples/tree/v13.4/cpp/0_Introduction/vectorAdd>
- **Done when:** the test passes for every N tried, memcheck reports no errors, and Sam predicts the grid size for a new
  N unaided.

## 03 — Timing GPU work and effective bandwidth

- **Objective:** Sam can time a kernel honestly with CUDA events and express the result as effective bandwidth against
  the card's theoretical figure.
- **Builds on:** llm-06 lesson 01 (measuring honestly: warm-up, repeated runs, variance); lesson 02.
- **Key ideas:**
  - A kernel launch returns before the work is done, so a CPU timer around a bare launch measures the launch, not the
    kernel; CUDA events take timestamps on the GPU's own stream.
  - Effective bandwidth is bytes read plus bytes written, divided by time; use the same divisor (10^9 or 1024^3) for
    the measured and the theoretical figure.
  - The theoretical figure for the RTX 2080 Ti is 616 GB/s (Turing whitepaper, Table 1).
  - The desktop shares the card, so runs vary: report a median and a spread over repeated runs, after warm-up.
- **Recall targets:** why a CPU timer around a launch misleads; the effective-bandwidth formula and its units; why the
  ratio to the theoretical figure is the number worth keeping.
- **Build:** a copy-kernel benchmark under `code/src/cuda/msNNN-<kebab>/` (planned) that checks the copy is correct,
  then reports median effective bandwidth over repeated runs for several sizes. **Blocked** until nvcc is installed
  (`GAPS.md` → "CUDA toolkit (`nvcc`) not installed").
- **Efficiency lens:** effective GB/s against 616 GB/s, timed with CUDA events; the table (sizes, median, spread) goes
  in the journal.
- **Sources:**
  - CUDA C++ Best Practices Guide 13.4, Section 9.1.2 Using CUDA GPU Timers and Section 9.2 Bandwidth:
    <https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html>
  - NVIDIA Turing Architecture Whitepaper, Table 1:
    <https://images.nvidia.com/aem-dam/en-zz/Solutions/design-visualization/technologies/turing-architecture/NVIDIA-Turing-Architecture-Whitepaper.pdf>
- **Done when:** the journal holds the table, and Sam explains the gap between his best figure and 616 GB/s.

## 04 — Coalesced global memory access

- **Objective:** Sam can predict whether a warp's global loads and stores coalesce, and show the difference with a
  measured transpose.
- **Builds on:** lesson 03's harness; llm-06's cache lines and locality.
- **Key ideas:**
  - Global memory moves in 32-byte transactions; a warp's 32 requests are combined into as few transactions as the
    addresses allow.
  - Consecutive threads reading consecutive 4-byte words use every byte fetched; threads 32 bytes or more apart force
    one transaction each and waste most of each.
  - In a two-dimensional block `threadIdx.x` is the fast index, so in a row-major matrix it should walk along a row.
  - A naive transpose cannot make both its read and its write follow `threadIdx.x` — one of them is strided.
- **Recall targets:** transactions per warp for a unit-stride and a large-stride access of 4-byte values; which side of
  a naive transpose is strided, and why.
- **Build:** a naive transpose under `code/src/cuda/msNNN-<kebab>/` (planned), tested against a CPU transpose, with
  effective bandwidth measured beside lesson 03's copy. **Blocked** until nvcc is installed (`GAPS.md` → "CUDA toolkit
  (`nvcc`) not installed").
- **Efficiency lens:** transpose bandwidth as a fraction of copy bandwidth, same harness and sizes.
- **Sources:**
  - CUDA Programming Guide 13.4.2, Section 2.3.4.1 Coalesced Global Memory Access and 2.3.4.1.1 (transpose example):
    <https://docs.nvidia.com/cuda/cuda-programming-guide/02-basics/writing-cuda-kernels.html>
  - CUDA C++ Best Practices Guide 13.4, Section 10.2.1 Coalesced Access to Global Memory:
    <https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html>
  - NVIDIA cuda-samples v13.4, `cpp/6_Performance/transpose` (reading only):
    <https://github.com/NVIDIA/cuda-samples/tree/v13.4/cpp/6_Performance/transpose>
- **Done when:** the journal shows copy and naive-transpose bandwidth side by side, and Sam explains the difference in
  terms of transactions.

## 05 — Shared memory, barriers and bank conflicts

- **Objective:** Sam can stage a tile through shared memory so that both the global read and the global write
  coalesce, place the barrier correctly, and remove a bank conflict.
- **Builds on:** lesson 04; P2 threads (a data race and why a barrier orders it).
- **Key ideas:**
  - Shared memory belongs to one block, lives on the SM and shares the unified data cache with L1; on compute
    capability 7.5 that cache is 96 KB, of which 32 or 64 KB can be shared memory.
  - A kernel that wants more than 48 KB per block must allocate it dynamically and opt in.
  - `__syncthreads()` makes every write in the block visible before any thread reads past it; a missing barrier is a
    race that may pass a test by luck.
  - Shared memory is split into banks; different addresses in one bank from one warp serialise, and padding a tile's
    row changes which bank each element falls in.
- **Recall targets:** where the barrier goes in a tiled transpose and what breaks without it; why padding a row by one
  element can remove a conflict; the shared-memory limits for this card.
- **Build:** a tiled transpose, with and without padding, under `code/src/cuda/msNNN-<kebab>/` (planned): correctness
  test, `compute-sanitizer --tool racecheck`, and bandwidth beside lesson 04. **Blocked** until nvcc is installed
  (`GAPS.md` → "CUDA toolkit (`nvcc`) not installed").
- **Efficiency lens:** bandwidth of naive, tiled and padded-tiled transposes.
- **Security lens:** a race is undefined behaviour on the GPU as on the CPU; racecheck is the gate, not the test's luck.
- **Sources:**
  - CUDA Programming Guide 13.4.2, Sections 2.3.3.2 Shared Memory, 2.3.4.2 Shared Memory Access Patterns and 2.3.4.2.2
    Shared Memory Bank Conflicts: <https://docs.nvidia.com/cuda/cuda-programming-guide/02-basics/writing-cuda-kernels.html>
  - CUDA Programming Guide 13.4.2, Section 5.1.3, Table 32 (shared-memory capacity per compute capability):
    <https://docs.nvidia.com/cuda/cuda-programming-guide/05-appendices/compute-capabilities.html>
  - CUDA C++ Best Practices Guide 13.4, Section 10.2.3.1 Shared Memory and Memory Banks:
    <https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html>
  - Compute Sanitizer, the Racecheck tool: <https://docs.nvidia.com/compute-sanitizer/ComputeSanitizer/index.html>
- **Done when:** racecheck is clean, the three-way bandwidth table is in the journal, and Sam explains the padding.

## 06 — A shared-memory tiled matrix multiply

- **Objective:** Sam can write a shared-memory tiled single-precision matrix multiply, count its FLOPs and bytes, and
  place its measured throughput on the roofline for this card.
- **Builds on:** llm-03's FLOP count of a matmul; llm-06's roofline and arithmetic intensity; lesson 05.
- **Key ideas:**
  - A naive kernel re-reads rows and columns from global memory for every output element, so its arithmetic intensity
    is low.
  - Tiling loads a tile of each input into shared memory once per block and reuses it, raising intensity as the tile
    grows.
  - This card's ceilings: 13.4 TFLOPS FP32 without tensor cores and 616 GB/s (whitepaper Table 1); Sam works out where
    the ridge point falls and which side of it each kernel sits.
  - Registers and shared memory per block limit how many blocks an SM holds (64K registers per SM, at most 255 per
    thread on 7.5).
  - The GPU sums in a different order from the CPU reference, so results are compared within a tolerance.
- **Recall targets:** FLOPs and bytes for an N x N multiply, naive and tiled; why tiling helps; what limits occupancy.
- **Build:** naive and tiled SGEMM under `code/src/cuda/msNNN-<kebab>/` (planned) for square and non-multiple sizes,
  tests against a CPU reference within a stated tolerance, and a GFLOP/s table. **Blocked** until nvcc is installed
  (`GAPS.md` → "CUDA toolkit (`nvcc`) not installed").
- **Efficiency lens:** achieved GFLOP/s against the FP32 peak, and each kernel's position against the bandwidth roof.
- **Sources:**
  - CUDA C++ Best Practices Guide 13.4, Section 10.2.3.2 Shared Memory in Matrix Multiplication (C=AB):
    <https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html>
  - CUDA Programming Guide 13.4.2, Section 2.3.7 Kernel Launch and Occupancy and Section 5.1.3, Tables 30–31:
    <https://docs.nvidia.com/cuda/cuda-programming-guide/02-basics/writing-cuda-kernels.html>
  - NVIDIA Turing Architecture Whitepaper, Table 1 (URL as lesson 03)
  - NVIDIA cuda-samples v13.4, `cpp/0_Introduction/matrixMul` (reading only):
    <https://github.com/NVIDIA/cuda-samples/tree/v13.4/cpp/0_Introduction/matrixMul>
- **Done when:** both kernels pass at every size, the table is in the journal, and Sam places each kernel on the
  roofline and explains why.

## 07 — Reductions and a numerically stable softmax

- **Objective:** Sam can write a block-level reduction and a row-wise softmax that does not overflow, and explain the
  one-pass online normaliser.
- **Builds on:** llm-04's numerically stable softmax; lesson 05.
- **Key ideas:**
  - A tree reduction in shared memory halves the active threads at each step, with a barrier between steps.
  - Warp shuffle functions such as `__shfl_down_sync` exchange registers inside a warp without shared memory.
  - Softmax needs the row's maximum and the sum of exponentials; subtracting the maximum first keeps `exp` in range.
  - The online normaliser keeps a running maximum and rescales the running sum when the maximum grows, so one pass
    over the row replaces two — the idea FlashAttention builds on (llm-19).
  - Floating-point sums depend on order: test with tolerances, and include rows with large values.
- **Recall targets:** why a barrier sits between reduction steps; what overflows in a naive softmax and why subtracting
  the maximum is exact; how the online normaliser updates its sum.
- **Build:** a sum reduction and a one-block-per-row softmax under `code/src/cuda/msNNN-<kebab>/` (planned), tested
  against a CPU reference that includes large-magnitude rows, with a timing table. **Blocked** until nvcc is installed
  (`GAPS.md` → "CUDA toolkit (`nvcc`) not installed").
- **Efficiency lens:** memory passes per row, measured as effective bandwidth for the multi-pass and online versions.
- **Sources:**
  - CUDA Programming Guide 13.4.2, Section 5.4.6.5 Warp Shuffle Functions:
    <https://docs.nvidia.com/cuda/cuda-programming-guide/05-appendices/cpp-language-extensions.html>
  - Milakov and Gimelshein, "Online normalizer calculation for softmax", arXiv:1805.02867v2, Section 3
  - NVIDIA cuda-samples v13.4, `cpp/2_Concepts_and_Techniques/reduction` (reading only):
    <https://github.com/NVIDIA/cuda-samples/tree/v13.4/cpp/2_Concepts_and_Techniques/reduction>
  - llm.c at f1e2ace, `dev/cuda/softmax_forward.cu` (reading only — several kernel versions, each checked against a CPU
    reference): <https://github.com/karpathy/llm.c/tree/f1e2ace651495b74ae22d45d1723443fd00ecd3a/dev/cuda>
- **Done when:** both kernels pass, including the large-value rows, and Sam explains the online update unaided.

## 08 — Correctness and speed against cuBLAS

- **Objective:** Sam can call cuBLAS's SGEMM correctly from row-major code, show his kernel agrees within a tolerance,
  and report his kernel's speed as a percentage of cuBLAS.
- **Builds on:** lesson 06; llm.c's framing of cuBLAS as the expert upper bound for hand-written kernels (its README).
- **Key ideas:**
  - cuBLAS stores matrices column-major with a leading dimension; Sam works out how a row-major product maps onto a
    column-major call before writing it.
  - Correctness first: maximum absolute and relative error against cuBLAS, within a tolerance justified by fp32
    precision.
  - Compute Sanitizer has racecheck, initcheck and synccheck as well as memcheck; a kernel is checked with all four.
  - Nsight Compute reads GPU performance counters, which are admin-only on this machine (`RmProfilingAdminOnly: 1`). On
    driver 580 there are two one-session routes, both from llm-07 lesson 06: Sam launching the profiler himself with
    `sudo` (or with `CAP_SYS_ADMIN`, or `CAP_PERFMON` from R565), which changes nothing persistent and suits a single
    kernel run; or the module-option reload, which means leaving the desktop. The capability-file method needs R610 or
    later. The fallback needs no privilege: CUDA events plus effective bandwidth and GFLOP/s. Nsight is not installed
    yet (`GAPS.md` → "Nsight Systems and Nsight Compute not installed").
- **Recall targets:** the column-major convention and what the leading dimension is; how the tolerance was chosen;
  what each Compute Sanitizer tool detects; the unprivileged fallback.
- **Build:** a harness under `code/src/cuda/msNNN-<kebab>/` (planned) that runs Sam's tiled SGEMM and `cublasSgemm` on
  the same inputs, checks agreement within the tolerance and prints a percentage-of-cuBLAS table; linked with
  `-lcublas`. **Blocked** until nvcc is installed (`GAPS.md` → "CUDA toolkit (`nvcc`) not installed").
- **Efficiency lens:** percentage of cuBLAS GFLOP/s at each size, timed with CUDA events; counters only in a session Sam
  unlocks himself.
- **Security lens:** a profiler run under `sudo` runs the profiled program as root too — only Sam's own kernel, never a
  downloaded binary.
- **Safety:** Claude never runs `sudo`; Sam runs the privileged profiler command, for one session.
- **Sources:**
  - cuBLAS 13.4, Section 1.1 Data Layout and Section 2.7.1 `cublas<t>gemm()`: <https://docs.nvidia.com/cuda/cublas/index.html>
  - Compute Sanitizer (Memcheck, Racecheck, Initcheck, Synccheck):
    <https://docs.nvidia.com/compute-sanitizer/ComputeSanitizer/index.html>
  - NVIDIA, "ERR_NVGPUCTRPERM — permission issue with performance counters":
    <https://developer.nvidia.com/nvidia-development-tools-solutions-err_nvgpuctrperm-permission-issue-performance-counters>
  - llm.c at f1e2ace, README "repo" section:
    <https://github.com/karpathy/llm.c/tree/f1e2ace651495b74ae22d45d1723443fd00ecd3a>
- **Done when:** the kernel agrees within the tolerance at every size, all four sanitiser tools are clean, the
  percentage table is in the journal, and Sam explains what limits his kernel.
