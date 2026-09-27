# Resources — llm-09-llm-c

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 pinning and the map | llm.c README at f1e2ace, "quick start" and "test" (<https://github.com/karpathy/llm.c/tree/f1e2ace651495b74ae22d45d1723443fd00ecd3a>) | `code/docs/TESTING.md` — Section 3 | — (clone outside the repository) |
| 02 CPU forward pass | llm.c `train_gpt2.c` at f1e2ace (<https://github.com/karpathy/llm.c/blob/f1e2ace651495b74ae22d45d1723443fd00ecd3a/train_gpt2.c>); arXiv:1607.06450v1; arXiv:1606.08415v5 | `code/docs/C-CODING-PRINCIPLES.md`; `code/docs/TESTING.md` — Section 1 | `code/src/c/msNNN-<kebab>/` |
| 03 memory layout | llm.c `train_gpt2.c` at f1e2ace, `malloc_and_point_parameters` and the lazy allocations; `man 1 time` | `code/docs/MEMORY-SAFETY.md` — Section 3 | `code/src/c/msNNN-<kebab>/` |
| 04 backward pass | llm.c `train_gpt2.c` at f1e2ace, `gpt2_backward`; arXiv:1607.06450v1 | `code/docs/TESTING.md` — Section 1 | `code/src/c/msNNN-<kebab>/` |
| 05 AdamW | arXiv:1711.05101v3; arXiv:1412.6980v9; llm.c `train_gpt2.c` at f1e2ace, `gpt2_update` | `code/docs/C-CODING-PRINCIPLES.md` | `code/src/c/msNNN-<kebab>/` |
| 06 sanitiser and valgrind gates | llm.c `Makefile` at f1e2ace (<https://github.com/karpathy/llm.c/blob/f1e2ace651495b74ae22d45d1723443fd00ecd3a/Makefile>); `man gcc`; `man valgrind` | `code/docs/MEMORY-SAFETY.md` — Sections 4–5; `code/docs/BUILD.md` — Section 2 | — (runs in the clone) |
| 07 CUDA path on Turing | llm.c issue #747 (<https://github.com/karpathy/llm.c/issues/747>); `llmc/cudnn_att.cpp` at f1e2ace (<https://github.com/karpathy/llm.c/blob/f1e2ace651495b74ae22d45d1723443fd00ecd3a/llmc/cudnn_att.cpp>); CUDA Programming Guide 13.4.2, Section 5.1.3 Table 33 | `code/docs/CUDA-CODING-PRINCIPLES.md` (planned — added at L2) | — (runs in the clone) |
| 08 fp16 loss scaling (stretch) | arXiv:1710.03740v3, Sections 3.1–3.2; PyTorch 2.14 AMP examples (<https://docs.pytorch.org/docs/2.14/notes/amp_examples.html>) | `code/docs/CUDA-CODING-PRINCIPLES.md` (planned — added at L2) | Sam's llm.c fork (its own repository, created if he takes the stretch) |
