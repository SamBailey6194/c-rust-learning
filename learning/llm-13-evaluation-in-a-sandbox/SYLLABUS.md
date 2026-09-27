# Syllabus — llm-13-evaluation-in-a-sandbox

**Track**: llm · **Phase**: L4 · **Path**: Core · **Detail**: full · **Prerequisites**: llm-12, sec-04
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

A model is only as good as the evidence for it, and evidence for a code model means running the code it writes — which
is running untrusted code. This topic evaluates llm-12's ~100M FIM model honestly: held-out perplexity, contamination
checks, infilling benchmarks scored by execution inside sec-04's sandbox (no network, resource limits, timeouts),
pass@k with an unbiased estimator, the choice of evaluations that actually move at this model's scale, and a personal
task suite built from Sam's own languages. Its sandbox discipline is reused by llm-18 and llm-20. Small scoring tools
land under `code/src/python/` (planned — added at L1); the evaluation harness and its results live in the
model-training repository (created when this build starts). Generated code never runs outside the sandbox.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Perplexity on held-out sets | 1 sitting | yes — held-out evaluation | Efficiency |
| 02 | Contamination checks from the evaluation side | 1 sitting | yes — contamination report | Security |
| 03 | Running generated code in the sandbox | 2–3 sittings | yes — sandboxed test runner | Security, Safety |
| 04 | Infilling evaluation: pass rate and exact match | 2–3 sittings | yes — HumanEval infilling harness | Efficiency, Security |
| 05 | pass@k and its unbiased estimator | 1 sitting | yes — pass@k estimator | — |
| 06 | Choosing evaluations that move at your scale | 1 sitting | no | — |
| 07 | A personal task suite | multi-session build | yes — Sam's own task suite | Security |

---

## 01 — Perplexity on held-out sets

- **Objective:** Sam can measure held-out perplexity per language on data the model never trained on, and compare
  models with different tokenisers fairly.
- **Builds on:** llm-03 (cross-entropy and perplexity); llm-10 (the corpus and its deduplication); llm-12's model.
- **Key ideas:**
  - A held-out set is split by repository, not by file, so near-duplicate files cannot sit on both sides of the split.
  - Perplexity per language shows where the model is weak; one average hides it.
  - Perplexity per token depends on the tokeniser; normalising the loss by bytes (bits per byte) allows a comparison
    across tokenisers.
  - Perplexity says how well the model predicts code, not whether the code it writes works — the later lessons measure
    that.
- **Recall targets:** why split by repository; how bits per byte is computed from token loss; what perplexity cannot
  tell you.
- **Build:** a held-out evaluation in the model-training repository (created when this build starts): perplexity and
  bits per byte per language, with the split recorded in the dataset card.
- **Efficiency lens:** evaluation time and peak VRAM for the held-out pass, so it can run during training without
  breaking the budget.
- **Sources:**
  - Gao et al., "The Pile: An 800GB Dataset of Diverse Text for Language Modeling", arXiv:2101.00027v1, Section 3
    (bits per UTF-8 encoded byte)
  - Lee et al., arXiv:2107.06499v2, Section 5.3 Train / Test Set Leakage
- **Done when:** the per-language table is in the journal, and Sam explains why bits per byte and not perplexity per
  token.

## 02 — Contamination checks from the evaluation side

- **Objective:** Sam can show that the benchmarks and held-out sets he reports on do not overlap his training data, and
  report any overlap honestly.
- **Builds on:** llm-10 lesson 05 (decontamination and its n-gram checker); lesson 01.
- **Key ideas:**
  - llm-10 removed evaluation material from the training data; this lesson checks the other direction, with the same
    tool, against the training manifest.
  - Contamination can arrive later: a refreshed corpus, a new benchmark, a task Sam wrote after training.
  - An overlap found is reported beside the score, with the overlapping items excluded or flagged, never silently
    dropped.
- **Recall targets:** the two directions of a contamination check; when a check must be re-run; how an overlap is
  reported.
- **Build:** a contamination report in the model-training repository, produced by llm-10's checker for every
  benchmark and held-out set used.
- **Security lens:** a contaminated score is a false claim about the model; the report is the evidence.
- **Sources:**
  - Brown et al., arXiv:2005.14165v4, Appendix C
  - Lozhkov et al., arXiv:2402.19173v1, Section 3.3
- **Done when:** every reported score has a contamination line beside it.

## 03 — Running generated code in the sandbox

- **Objective:** Sam can run model-generated code against tests only inside sec-04's sandbox, with no network, bounded
  resources and a timeout, and explain what each limit prevents.
- **Builds on:** sec-04 (namespaces, cgroups, seccomp, Landlock and its sandbox launcher); P2 processes and signals.
- **Key ideas:**
  - Generated code is untrusted: it can be wrong in destructive ways even without malice. The Codex authors ran it in
    gVisor with network access blocked; human-eval's own README says to run it only in a robust sandbox, and its
    `reliability_guard` says it is not a security sandbox.
  - Limits and what they stop: a network namespace with no interfaces (exfiltration and downloads), resource limits on
    memory, CPU time, processes and file size (runaway code), a wall-clock timeout (hangs), a read-only or scratch-only
    filesystem view (damage to the host).
  - Each limit is tested with a deliberately misbehaving test program, not assumed.
  - A timeout or a limit hit is a failed sample, recorded as such.
- **Recall targets:** each limit and the failure it contains; why an evaluation harness's own guard is not a sandbox;
  how a timeout is recorded.
- **Build:** a sandboxed test runner in the model-training repository that calls sec-04's launcher for every sample,
  with a test suite of misbehaving programs (a network call, a fork loop, a memory hog, an infinite loop, a write
  outside the scratch directory) that must each be contained.
- **Security lens:** LLM06:2025 Excessive Agency and LLM10:2025 Unbounded Consumption (OWASP Top 10 for LLM
  Applications 2025; LLM03:2026 and LLM06:2026 in the 2026 edition), contained at the process level; the full
  threat model is llm-18's.
- **Safety:** generated code never runs on the host outside the sandbox, and never with network access; Claude never
  runs `sudo`.
- **Sources:**
  - Chen et al., arXiv:2107.03374v2, Section 2.3 Sandbox for Executing Generated Programs
  - openai/human-eval at 6d43fb9, README "Usage" and `human_eval/execution.py` (`reliability_guard`):
    <https://github.com/openai/human-eval/tree/6d43fb980f9fee3c892a914eda09951f772ad10d>
  - `man 7 network_namespaces`; `man 2 setrlimit`; `man 1 timeout`; `man 7 landlock`
  - OWASP Top 10 for LLM Applications 2025 (LLM06, LLM10): <https://genai.owasp.org/llm-top-10/>; the 2026
    edition's IDs are mapped in `llm-18-secure-llm-systems` lesson 01
- **Done when:** every misbehaving program is contained and recorded as a failure, and Sam explains each limit
  unaided.

## 04 — Infilling evaluation: pass rate and exact match

- **Objective:** Sam can run the HumanEval infilling benchmarks against his FIM model and report pass rate and exact
  match.
- **Builds on:** llm-12 lesson 03 (PSM and SPM prompts); lesson 03's sandbox.
- **Key ideas:**
  - The infilling benchmarks are built from HumanEval's canonical solutions: single-line masks one line, multi-line
    masks a span of lines; the FIM paper adds random-span variants.
  - Pass rate runs the completed function against its tests; exact match compares the generated lines with the
    masked ones — two views of the same completion.
  - Prompts use the model's FIM format and sampling stops at the end-of-text token.
  - Many tasks per problem (over a thousand single-line, several thousand multi-line) reduce variance.
- **Recall targets:** how single- and multi-line tasks are built; what pass rate and exact match each reward; why
  sampling stops at end-of-text.
- **Build:** an infilling harness in the model-training repository that reads the benchmark problems, prompts the
  model in PSM and SPM, runs every completion through lesson 03's runner, and reports both metrics.
- **Efficiency lens:** wall-clock time and peak VRAM for a full benchmark pass.
- **Security lens:** execution goes only through the sandboxed runner.
- **Sources:**
  - Fried et al., "InCoder: A Generative Model for Code Infilling and Synthesis", arXiv:2204.05999v3, Section 4.1
  - Bavarian et al., arXiv:2207.14255v1, Section 2.2 Infilling evaluation
  - openai/human-eval-infilling (MIT, archived) at 88062ff, README:
    <https://github.com/openai/human-eval-infilling/tree/88062ff9859c875d04db115b698ed4b0f0395170>
- **Done when:** both metrics are reported for single- and multi-line infilling in PSM and SPM, with the contamination
  line from lesson 02.

## 05 — pass@k and its unbiased estimator

- **Objective:** Sam can compute pass@k from n samples per task with the unbiased estimator, and explain why the naive
  method misleads.
- **Builds on:** lesson 04; llm-05's sampling (temperature, top-p).
- **Key ideas:**
  - pass@k asks whether at least one of k samples passes; sampling exactly k and checking has high variance.
  - The unbiased estimator draws n ≥ k samples, counts the c that pass, and computes the chance that a random k-subset
    contains none of them — in a numerically stable form.
  - Temperature changes pass@k: diverse samples help large k, greedy helps pass@1.
- **Recall targets:** what pass@k means; the estimator's inputs; why a stable form is needed; how temperature interacts
  with k.
- **Build:** a pass@k estimator under `code/src/python/` (planned — added at L1), tested against cases Sam works out by
  hand and against extreme values of n and c.
- **Sources:**
  - Chen et al., arXiv:2107.03374v2, Section 2.1 Functional Correctness (the estimator and its stable form)
- **Done when:** the tests pass, and Sam derives the estimator's idea unaided.

## 06 — Choosing evaluations that move at your scale

- **Objective:** Sam can choose evaluations that will register progress for a ~100M model, and explain why some
  benchmarks sit at the floor at this size.
- **Builds on:** lessons 01–05.
- **Key ideas:**
  - At small scale, whole-program synthesis is hard: the Codex paper reports its 300M model solving about 13% of
    HumanEval with one sample, and GPT models without code training near zero.
  - All-or-nothing metrics can hide steady improvement; per-token or continuous measures show it (Schaeffer et al.).
  - Infilling tasks with surrounding context, perplexity per language and a small, fast benchmark (the FIM paper's
    random-span-light, used to track training) move earlier than plain HumanEval.
  - A table of what moves and what does not is itself a result.
- **Recall targets:** why plain HumanEval barely moves at this scale; what a continuous metric reveals; which three
  measures to track during training.
- **Build:** none — the choice of evaluations, with reasons, recorded in `NOTES/` and in the milestone's exit
  criteria.
- **Sources:**
  - Chen et al., arXiv:2107.03374v2, Section 1 (results by model size)
  - Schaeffer, Miranda and Koyejo, "Are Emergent Abilities of Large Language Models a Mirage?", arXiv:2304.15004v2,
    Section 2
  - Bavarian et al., arXiv:2207.14255v1, Section 2.2 (random-span-light)
- **Done when:** the evaluation plan is recorded with a reason for each measure.

## 07 — A personal task suite

- **Objective:** Sam can build and maintain a private task suite from his own work in C, Rust, Python, Nix, PHP and
  shell, scored by tests in the sandbox, that tracks what he actually wants the model for.
- **Builds on:** lessons 03–06; his own code in this repository and elsewhere.
- **Key ideas:**
  - Public benchmarks measure public tasks; a personal suite measures the completions Sam needs.
  - Each task is a prefix, a suffix, a hidden middle and tests; tasks in languages without an easy runner (Nix, shell)
    need their own check commands inside the sandbox.
  - The suite never enters training data: it is kept outside the corpus and checked with lesson 02's report.
  - The suite is versioned; a score is always quoted with the suite version.
- **Recall targets:** the parts of a task; how the suite is kept out of training data; why scores carry a version.
- **Build:** the task suite in the model-training repository (created when this build starts), starting small, with a
  runner that reuses lesson 03's sandbox and lesson 04's metrics; tasks drawn from Sam's own code, never from licensed
  third-party code without its terms.
- **Security lens:** tasks run only in the sandbox, and task files contain no secrets or personal data.
- **Sources:**
  - Bavarian et al., arXiv:2207.14255v1, Section 2.2 (task construction by masking spans)
  - Chen et al., arXiv:2107.03374v2, Section 2.2 HumanEval: Hand-Written Evaluation Set
- **Done when:** the suite has tasks in every language of the mix, the model's scores are in the journal with the suite
  version, and the contamination check is clean.
