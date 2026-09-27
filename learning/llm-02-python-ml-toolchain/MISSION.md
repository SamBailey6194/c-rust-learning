# Mission — llm-02-python-ml-toolchain

**Started**: not yet · **Family**: llm · **Phase**: L1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam asked whether he could build an LLM "in C + Rust + Python + Markdown", and the plan gives Python
the training side. He already writes Python; what he needs now is a training environment he can
trust — pinned so it rebuilds exactly, with PyTorch using this machine's RTX 2080 Ti — and the
measuring habits his brief demands, since the model must use "CPU, RAM, GPU, VRAM and cache"
efficiently and every claim about efficiency is only as good as the measurement behind it.

## Can do it when

- Sam can create a uv project with a pinned Python and a committed lockfile, and a fresh clone runs
  its tests with `uv run --locked pytest`.
- Sam can install PyTorch 2.14 with a CUDA build that supports sm_75 and prove it from Python.
- Sam can predict a tensor's shape, dtype, device and size in bytes, and say whether an operation
  copies or returns a view.
- Sam can time GPU work correctly (synchronised or with CUDA events, after warm-up) and convert a
  matmul time to achieved TFLOPS.
- Sam can make a small training run repeat on the CPU and list what must be recorded for a result to
  be repeatable.

## Parked for later

- The maths the tensors carry — llm-03 and llm-04.
- Mixed precision and GradScaler — llm-05.
- GPU memory accounting and profiling — llm-07.
- CUDA C and the toolkit (`nvcc`) — llm-08.
