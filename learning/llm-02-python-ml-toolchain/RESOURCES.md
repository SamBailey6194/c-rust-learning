# Resources — llm-02-python-ml-toolchain

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 A uv project with a pinned Python and a lockfile | uv "Projects: structure and files", <https://docs.astral.sh/uv/concepts/projects/layout/>; "Locking and syncing", <https://docs.astral.sh/uv/concepts/projects/sync/>; "Python versions", <https://docs.astral.sh/uv/concepts/python-versions/> (read 27/09/2026, uv 0.12.5) | `how-to/docs/TOOLCHAIN.md` | `code/src/python/` (planned — added at L1) |
| 02 Installing PyTorch with a CUDA build for Turing | PyTorch `RELEASE.md` → "PyTorch CUDA Support Matrix For Release 2.14", <https://github.com/pytorch/pytorch/blob/main/RELEASE.md>; torch 2.14.0 metadata, <https://pypi.org/pypi/torch/2.14.0/json>; uv "Using uv with PyTorch", <https://docs.astral.sh/uv/guides/integration/pytorch/> | `how-to/docs/TOOLCHAIN.md` | `code/src/python/` (planned — added at L1) |
| 03 Tensors: shape, dtype, device and bytes | PyTorch 2.14 "Tensor Attributes", <https://docs.pytorch.org/docs/2.14/tensor_attributes.html>; "Tensor Views", <https://docs.pytorch.org/docs/2.14/tensor_view.html> | `code/docs/TESTING.md` — Section 3 Test discipline | `code/src/python/` (planned — added at L1) |
| 04 Timing GPU work honestly | PyTorch 2.14 "CUDA semantics → Asynchronous execution", <https://docs.pytorch.org/docs/2.14/notes/cuda.html>; "Benchmark Utils", <https://docs.pytorch.org/docs/2.14/benchmark_utils.html> | — | `code/src/python/` (planned — added at L1) |
| 05 Reproducibility: seeds, determinism and what to record | PyTorch 2.14 "Reproducibility", <https://docs.pytorch.org/docs/2.14/notes/randomness.html> | `code/docs/TESTING.md` | `code/src/python/` (planned — added at L1) |
