# Resources — llm-13-evaluation-in-a-sandbox

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 held-out perplexity | arXiv:2101.00027v1, Section 3; arXiv:2107.06499v2, Section 5.3 | — | the model-training repository (created when this build starts) |
| 02 contamination checks | arXiv:2005.14165v4, Appendix C; arXiv:2402.19173v1, Section 3.3 | — | the model-training repository |
| 03 sandboxed execution | arXiv:2107.03374v2, Section 2.3; openai/human-eval at 6d43fb9 (<https://github.com/openai/human-eval/tree/6d43fb980f9fee3c892a914eda09951f772ad10d>); `man 7 network_namespaces`; `man 2 setrlimit`; `man 1 timeout`; `man 7 landlock`; OWASP Top 10 for LLM Applications 2025 (<https://genai.owasp.org/llm-top-10/>) | `.claude/CLAUDE.md` — Section 5 (sandboxed execution) | the model-training repository, calling sec-04's sandbox launcher |
| 04 infilling evaluation | arXiv:2204.05999v3, Section 4.1; arXiv:2207.14255v1, Section 2.2; openai/human-eval-infilling at 88062ff (<https://github.com/openai/human-eval-infilling/tree/88062ff9859c875d04db115b698ed4b0f0395170>) | — | the model-training repository |
| 05 pass@k | arXiv:2107.03374v2, Section 2.1 | `code/docs/PYTHON-CODING-PRINCIPLES.md` (planned — added at L1) | `code/src/python/` (planned — added at L1) |
| 06 evaluations at your scale | arXiv:2107.03374v2, Section 1; arXiv:2304.15004v2, Section 2; arXiv:2207.14255v1, Section 2.2 | — | — |
| 07 personal task suite | arXiv:2207.14255v1, Section 2.2; arXiv:2107.03374v2, Section 2.2 | `code/docs/TESTING.md` — Section 3 | the model-training repository |
