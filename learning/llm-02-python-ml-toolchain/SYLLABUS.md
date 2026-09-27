# Syllabus — llm-02-python-ml-toolchain

**Track**: llm · **Phase**: L1 · **Path**: Core · **Detail**: full · **Prerequisites**: P1 (Python itself is already known)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic builds the Python environment every L1–L4 exercise runs in, and the habits that make its
numbers trustworthy. It creates `code/src/python/` (planned — added at L1) as a uv project with a
pinned interpreter and a committed lockfile, installs PyTorch 2.14 with a CUDA build that includes
this RTX 2080 Ti's architecture (sm_75), and teaches the three things that most often make an ML
measurement wrong: not knowing where a tensor lives, timing asynchronous GPU work without
synchronising, and results that cannot be repeated. Everything later in the track — the autograd
engine (llm-03), the numpy transformer (llm-04), the tiny GPT (llm-05) and the VRAM budgets (llm-07)
— stands on it.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | A uv project with a pinned Python and a lockfile | 1 sitting | yes — project skeleton | Security |
| 02 | Installing PyTorch with a CUDA build for Turing | 1 sitting | yes — GPU smoke test | Efficiency, Security |
| 03 | Tensors: shape, dtype, device and bytes | 1 sitting | yes — prediction tests | Efficiency |
| 04 | Timing GPU work honestly | 1 sitting | yes — three timings of one matmul | Efficiency |
| 05 | Reproducibility: seeds, determinism and what to record | 1 sitting | yes — repeatability test | — |

**Where the work lands.** These are small exercises, so they stay in this repository under
`code/src/python/` (planned — added at L1); the package layout and naming are decided in lesson 01
and recorded through `project-management/workflows/08-decisions/`. GPU tests skip cleanly where no
GPU exists, because CI has none.

---

## 01 — A uv project with a pinned Python and a lockfile

- **Objective:** Sam can create a uv project, pin its interpreter, add runtime and development
  dependencies, and rebuild the exact environment on a clean checkout from the lockfile.
- **Builds on:** Sam's Python; his Nix habit of pinning inputs so a build is repeatable (a
  `flake.lock` and a `uv.lock` answer the same question).
- **Key ideas:**
  - `pyproject.toml` marks the project root and declares dependencies; uv keeps the environment
    in the project's `.venv`.
  - `.python-version`, written by `uv python pin`, fixes the interpreter; this host has Python
    3.14.4 and uv 0.12.5. PyTorch 2.14's release matrix lists Python 3.10 to 3.15 (3.15
    experimental), but its PyPI wheels cover 3.10 to 3.14 (plus 3.14t), so pin 3.14.
  - `uv.lock` records the exact resolution and is committed; `uv run --locked` refuses to run when
    the lockfile is out of date instead of silently updating it.
  - Development tools (pytest, ruff) are project dependencies, not host installs: the host has no
    pytest, and the project should not depend on one.
  - The layout and naming choice for `code/src/python/` (planned — added at L1) is a decision with
    consequences for every later exercise, so it is recorded as an ADR, not improvised.
- **Recall targets:** say which file pins the interpreter, which pins the dependency graph, and
  which of them is committed; explain what `--locked` protects against.
- **Build:** the `code/src/python/` project skeleton (planned — added at L1) with one trivial
  module and one pytest test; checked by `uv run --locked pytest` passing in a fresh clone and
  `uv run ruff check` reporting nothing.
- **Security lens:** a lockfile pins what was reviewed; an unpinned dependency is an unreviewed
  supply-chain input.
- **Sources:** uv docs → "Projects: structure and files" (<https://docs.astral.sh/uv/concepts/projects/layout/>),
  "Locking and syncing" (<https://docs.astral.sh/uv/concepts/projects/sync/>) and "Python versions →
  Python version files" (<https://docs.astral.sh/uv/concepts/python-versions/>), read 27/09/2026
  against uv 0.12.5; PyTorch `RELEASE.md` → "Release Compatibility Matrix"
  (<https://github.com/pytorch/pytorch/blob/main/RELEASE.md>, read 27/09/2026); torch 2.14.0 wheel files on PyPI
  (<https://pypi.org/pypi/torch/2.14.0/json>, `urls`: cp310 to cp314 and cp314t); `uv python pin --help`.
- **Done when:** a fresh clone runs `uv run --locked pytest` green, and the layout decision exists as
  an ADR (Proposed or Accepted).

## 02 — Installing PyTorch with a CUDA build for Turing

- **Objective:** Sam can install PyTorch 2.14 into the project with a CUDA build that supports
  sm_75, and prove from Python that the GPU is usable.
- **Builds on:** lesson 01.
- **Key ideas:**
  - PyTorch 2.14.0 was released on 02/09/2026. On Linux, its PyPI wheel depends on the CUDA 13.0.3
    runtime packages, so no system CUDA toolkit is needed to run it.
  - The driver decides what runs: driver 580.178.04 reports CUDA 13.0 in `nvidia-smi`, which
    matches the default wheel.
  - PyTorch's 2.14 support matrix lists Turing (7.5) in its CUDA 12.6, 13.0 and 13.2 builds for
    Linux x86; the non-default builds come from `download.pytorch.org` indexes, which uv's guide
    marks `explicit = true` so only PyTorch packages come from them.
  - The proof is on the machine: `torch.cuda.get_device_capability()` returns `(7, 5)` and
    `torch.cuda.get_arch_list()` contains `sm_75`.
- **Recall targets:** explain why the host needs a driver but not a CUDA toolkit to run PyTorch;
  name the two calls that prove the build supports this card.
- **Build:** add `torch` to the project and a smoke test that skips when CUDA is absent (as in CI)
  and otherwise asserts the capability and the arch list; checked by `uv run --locked pytest`
  locally (passes, not skipped) and in CI (skipped).
- **Efficiency lens:** the disk cost of the CUDA wheels — measure the `.venv` with `du -sh` before
  and after, and record it.
- **Security lens:** an extra index is a second supply chain; `explicit = true` stops it serving
  anything but the packages named for it.
- **Sources:** PyTorch `RELEASE.md` → "Release Compatibility Matrix" and "PyTorch CUDA Support Matrix
  For Release 2.14" (<https://github.com/pytorch/pytorch/blob/main/RELEASE.md>); torch 2.14.0 package
  metadata (<https://pypi.org/pypi/torch/2.14.0/json>, read 27/09/2026); uv "Using uv with PyTorch"
  (<https://docs.astral.sh/uv/guides/integration/pytorch/>); PyTorch 2.14 `torch.cuda.get_arch_list`
  (<https://docs.pytorch.org/docs/2.14/generated/torch.cuda.get_arch_list.html>); `man nvidia-smi`.
- **Done when:** the smoke test passes on this machine with `sm_75` asserted, skips in CI, and the
  installed torch version, CUDA version and `.venv` size are recorded.

## 03 — Tensors: shape, dtype, device and bytes

- **Objective:** Sam can predict a tensor's shape, dtype, device and size in bytes, and say when an
  operation copies data (between devices, or into a new tensor) and when it returns a view.
- **Builds on:** lesson 02; Sam's Python lists and numpy if known.
- **Key ideas:**
  - A tensor is storage plus shape, strides, dtype and device; its size in bytes is
    `numel() * element_size()`.
  - The dtype sets memory and precision together: `float32` is 4 bytes, `float16` and `bfloat16`
    are 2 (llm-03 lesson 07 explains the difference in range).
  - `.to("cuda")` copies across the PCIe bus, and copying is always explicit: an operation on
    tensors spread across different devices raises an error instead.
  - A view shares its base tensor's data (slicing, `view`, `transpose`) and may be
    non-contiguous; `torch.from_numpy` shares memory with the numpy array, so a write to one shows
    in the other.
- **Recall targets:** predict the byte size of a given tensor in two dtypes; say whether a named
  operation copies or views; explain what a device mismatch error means.
- **Build:** prediction tests — a pytest module where each test states Sam's prediction (shape,
  dtype, bytes, shares-storage or not) before the assertion runs; checked by the tests passing on
  CPU, with the device tests skipping in CI.
- **Efficiency lens:** host-to-device copy bandwidth for a large tensor, timed with lesson 04's
  method, recorded in GB/s.
- **Sources:** PyTorch 2.14 → "Tensor Attributes" (<https://docs.pytorch.org/docs/2.14/tensor_attributes.html>),
  "torch.Tensor" (<https://docs.pytorch.org/docs/2.14/tensors.html>), "Tensor Views"
  (<https://docs.pytorch.org/docs/2.14/tensor_view.html>), "CUDA semantics" on cross-device operations
  (<https://docs.pytorch.org/docs/2.14/notes/cuda.html>) and `torch.from_numpy`
  (<https://docs.pytorch.org/docs/2.14/generated/torch.from_numpy.html>).
- **Done when:** every prediction test passes and Sam explains, unaided, one case where his first
  prediction was wrong.

## 04 — Timing GPU work honestly

- **Objective:** Sam can time a GPU operation correctly and explain why wall-clock timing without
  synchronisation measures the launch, not the work.
- **Builds on:** lessons 02–03.
- **Key ideas:**
  - CUDA work is asynchronous: a call enqueues a kernel and returns, so a timer stopped straight
    after it measures almost nothing.
  - Two correct methods: `torch.cuda.synchronize()` before reading the clock, or
    `torch.cuda.Event(enable_timing=True)` pairs recorded on the stream.
  - The first calls pay one-off start-up costs (the benchmark recipe shows the same call before
    and after warm-up), so warm up and discard them.
  - `torch.utils.benchmark.Timer` does warm-up and synchronisation for you; report a median and a
    spread from repeated runs.
  - `CUDA_LAUNCH_BLOCKING=1` makes errors appear at the call that caused them; it is for debugging,
    not for timing.
- **Recall targets:** predict what an unsynchronised timer reports for a large matmul and why;
  name the two correct timing methods.
- **Build:** time one large matmul three ways (naive, synchronised, `benchmark.Timer`) and convert
  the correct time to achieved TFLOPS with `2 * m * n * k` floating-point operations; checked by the
  naive figure being implausibly fast and the other two agreeing within their spread.
- **Efficiency lens:** achieved TFLOPS for fp32 on this card, recorded for llm-07's roofline.
- **Sources:** PyTorch 2.14 → "CUDA semantics → Asynchronous execution"
  (<https://docs.pytorch.org/docs/2.14/notes/cuda.html>), `torch.cuda.Event`
  (<https://docs.pytorch.org/docs/2.14/generated/torch.cuda.Event.html>) and "Benchmark Utils"
  (<https://docs.pytorch.org/docs/2.14/benchmark_utils.html>); PyTorch recipe "PyTorch Benchmark"
  (<https://docs.pytorch.org/tutorials/recipes/recipes/benchmark.html>).
- **Done when:** the three timings are recorded with an explanation of the gap, and the TFLOPS figure
  is in the lesson note.

## 05 — Reproducibility: seeds, determinism and what to record

- **Objective:** Sam can make a small training run repeat to the degree PyTorch allows, and state
  what still varies and why.
- **Builds on:** lessons 01–04.
- **Key ideas:**
  - `torch.manual_seed` seeds every device; Python's `random` and numpy keep their own generators
    and need their own seeds.
  - `torch.use_deterministic_algorithms(True)` makes an operation without a deterministic
    implementation raise instead of varying silently; `torch.backends.cudnn.benchmark = False`
    stops cuDNN choosing algorithms by timing.
  - Determinism can cost speed, and PyTorch does not promise identical results across releases,
    platforms, or CPU against GPU.
  - A result is only repeatable with its context recorded: seed, torch and CUDA versions, driver,
    GPU, and the lockfile.
- **Recall targets:** list what must be seeded; say what `use_deterministic_algorithms` changes;
  name what else must be recorded for a run to be repeatable.
- **Build:** a repeatability test — a tiny model trained for a few steps twice with the same seed
  must give identical losses on CPU, and a run record written beside the result (seed, versions,
  device); checked by pytest.
- **Sources:** PyTorch 2.14 → "Reproducibility" (<https://docs.pytorch.org/docs/2.14/notes/randomness.html>).
- **Done when:** the repeatability test passes, and Sam explains one source of variation it does not
  remove.
