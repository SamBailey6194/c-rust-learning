# Syllabus — llm-10-data-pipeline-and-licensing

**Track**: llm · **Phase**: L4 · **Path**: Core · **Detail**: full · **Prerequisites**: llm-05, tooling-05 (its lesson on the licences of datasets and model weights), sec-01
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Most of the work in training a model from scratch is the data. This topic builds the corpus for the ~100M-parameter code
model of llm-12: how much data the budget calls for, where code data can lawfully come from, and the pipeline that
turns it into something safe to train on — licence filtering, deduplication, decontamination, quality filtering,
secret and PII scrubbing, and a dataset card that records where every file came from. It serves the mission's "secure"
as much as its "efficient": a model inherits whatever its data carries. Concept exercises land under
`code/src/python/` (planned — added at L1) and use synthetic data only; the real pipeline lands in the model-training
repository (created when this build starts). Datasets are never committed to any repository; the corpus lives on local
disk, sized in lesson 01.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Getting data you are allowed to use, sized to the budget | 1 sitting | yes — data-budget calculator | Efficiency, Security |
| 02 | The Stack v2 and v3: access, terms and keeping your copy current | 1 sitting | no | Security |
| 03 | Licence filtering and attribution | 1 sitting | yes — licence filter over synthetic metadata | Security |
| 04 | Exact and near-duplicate removal | 2–3 sittings | yes — MinHash deduplication from scratch | Efficiency |
| 05 | Decontamination against evaluation sets | 1 sitting | yes — n-gram overlap checker | — |
| 06 | Quality filtering and language weighting | 1 sitting | yes — heuristic quality filter | Efficiency |
| 07 | Security scrubbing: secrets and PII | 2–3 sittings | yes — scrubber over planted fake secrets | Security |
| 08 | Dataset cards and provenance | 1 sitting | yes — the corpus's dataset card | Security |

---

## 01 — Getting data you are allowed to use, sized to the budget

- **Objective:** Sam can derive a compute-optimal token target for a ~100M-parameter model, turn it into a disk budget,
  and name the terms and credentials that stand between him and the data.
- **Builds on:** llm-05 (tokens, batches, a training loop); tooling-05 (dataset and weight licences); sec-01 (threat
  modelling — here, of the data supply).
- **Key ideas:**
  - Chinchilla's compute-optimal runs scale parameters and tokens together; its Table 3 gives the tokens it pairs with a
    400M and a 1B model, and Sam derives the ratio and applies it to ~100M — roughly billions, not trillions, of tokens.
  - Tokens become bytes twice: raw text on disk before tokenisation, and token ids after (llm.c's data files, for
    example, store GPT-2 token ids as 16-bit integers). Both need disk, plus working space for each pipeline stage.
  - Gated datasets come with terms: accepting them is a decision, recorded before any download.
  - Access tokens stay outside every repository: the Hugging Face CLI stores its token under `HF_HOME` in the user's
    cache, a read-only token limits the damage of a leak, and this repository's TruffleHog gate is the backstop.
- **Recall targets:** Chinchilla's tokens-per-parameter ratio and where it comes from; raw and tokenised disk
  estimates; where a Hugging Face token is kept and why read-only.
- **Build:** a data-budget calculator under `code/src/python/` (planned — added at L1): given parameters, a
  tokens-per-parameter ratio, bytes per token and pipeline stages, it reports a token target and disk budget; tests
  check it against Chinchilla's Table 3 rows.
- **Efficiency lens:** the disk budget, checked against free space (`df -h`) before any download.
- **Security lens:** credentials never in a repository, a note or a command line saved to history.
- **Sources:**
  - Hoffmann et al., "Training Compute-Optimal Large Language Models", arXiv:2203.15556v1, Section 3.4 and Table 3
  - Hugging Face Hub Python library, Quickstart → Authentication, "Login command":
    <https://huggingface.co/docs/huggingface_hub/quick-start>
  - llm.c at f1e2ace, `dev/data/data_common.py` (the token file header and `uint16` ids):
    <https://github.com/karpathy/llm.c/blob/f1e2ace651495b74ae22d45d1723443fd00ecd3a/dev/data/data_common.py>
- **Done when:** the calculator passes its tests, and Sam states his token target and disk budget with their
  derivation.

## 02 — The Stack v2 and v3: access, terms and keeping your copy current

- **Objective:** Sam can explain what The Stack v2 and its successor v3 each provide, what their terms require of a
  model trained on them, and how a local copy stays in step with opt-outs — and decide which, if either, to use.
- **Builds on:** lesson 01; tooling-05 (licences); the Software Heritage archive as the source of the files.
- **Key ideas:**
  - The Hugging Face dataset holds identifiers (SWHIDs) and metadata, not file contents; the contents sit in Software
    Heritage's S3 bucket, and bulk download needs an agreement with Software Heritage and INRIA.
  - Term 2 binds anyone training on it to Software Heritage's principles for language-model training (19/10/2023).
    The resulting models must be made available under a suitable open licence, with the documentation and tooling
    needed to use them. The training data must be fully and precisely identified, for example by publishing its
    SWHIDs. And mechanisms should be established, where possible, for authors to exclude their code before training
    begins. Term 3 requires every use to abide by each file's original licence, including attribution clauses. That
    constrains the licence of Sam's own model, so it is a decision to take now, not after training.
  - The Stack v3 (`HuggingFaceCode/stack-v3-train`, 2026; GitHub crawl to 07/08/2025) ships file contents inline under
    ODC-By 1.0 with no gate, no SWH/INRIA agreement and no Software Heritage training-principles clause. It keeps the
    per-file original-licence and attribution duty (provenance in `repo_path`, `commit_id`, `detected_licenses`), and
    opt-outs are applied before each patch release. Compare the two versions' terms before choosing.
  - Opt-outs: authors ask for removal through the bigcode-project opt-out repository (whose README now points at v3);
    v2's terms require keeping a local copy updated to the latest usable version, and every derived shard must follow.
    Accepting v2's gate shares contact details with the dataset maintainers.
- **Recall targets:** what each version's rows contain and what they do not; the three Software Heritage principles
  and which version binds Sam to them; what "keep your copy current" means for shards already built.
- **Build:** none — the output is Sam's decision (use it, or use another source) in `NOTES/`; if he uses it, a Proposed
  ADR through `project-management/workflows/08-decisions/`.
- **Security lens:** a data source is part of the supply chain: its terms, its removals and its provenance are
  tracked like a dependency's.
- **Sources:**
  - The Stack v2 dataset card, "Terms of Use" and "Dataset Structure": <https://huggingface.co/datasets/bigcode/the-stack-v2>
  - The Stack v3 dataset card (`HuggingFaceCode/stack-v3-train`, last modified 25/09/2026), the v2-against-v3 table,
    "Opt-out" and "Licensing": <https://huggingface.co/datasets/HuggingFaceCode/stack-v3-train>
  - Software Heritage, "Statement on Large Language Models for Code" (19/10/2023), "Principles":
    <https://www.softwareheritage.org/2023/10/19/swh-statement-on-llm-for-code/>
  - bigcode-project opt-out-v2, README: <https://github.com/bigcode-project/opt-out-v2>
  - Lozhkov et al., "StarCoder 2 and The Stack v2", arXiv:2402.19173v1, Section 3.5 Removing Opt-outs
- **Done when:** the decision is written with its reasons, including why v2 or v3 (or neither), and Sam states the
  principles and the opt-out duty unaided.

## 03 — Licence filtering and attribution

- **Objective:** Sam can filter code data by licence, explain why unlicensed files are excluded, and keep the provenance
  needed for attribution.
- **Builds on:** lesson 02; tooling-05 (permissive versus copyleft; attribution clauses).
- **Key ideas:**
  - The Stack v2 labels each file's `license_type` as `permissive` or `no_license`; code with no licence generally
    comes with no permission to use, modify or share it, so those files are excluded.
  - The label comes from repository-level licence metadata where it exists and otherwise from file-level detection
    with the ScanCode Toolkit, matched against a published list; a label is evidence, not a guarantee.
  - Permissive licences still carry attribution clauses; the provenance fields (repository, revision, path, SWHIDs) are
    what make attribution possible later.
  - Filter early: every later stage then runs on less data.
- **Recall targets:** the two `license_type` values and which is kept; why "no licence" means no permission; which
  fields are kept for attribution.
- **Build:** a licence filter under `code/src/python/` (planned) over synthetic metadata rows shaped like the dataset's
  schema; tests cover kept, dropped and malformed rows and check provenance survives filtering.
- **Security lens:** a malformed or missing licence field is dropped, never defaulted to permissive.
- **Sources:**
  - The Stack v2 dataset card, "Data Fields" (`license_type`) and "Licensing information"
    (<https://huggingface.co/datasets/bigcode/the-stack-v2>)
  - arXiv:2402.19173v1, Section 2.1 Source Code, "License detection" and Figure 1
  - Choose a License, "No License": <https://choosealicense.com/no-permission/>
- **Done when:** the filter's tests pass, and Sam explains the exclusion of unlicensed files unaided.

## 04 — Exact and near-duplicate removal

- **Objective:** Sam can remove exact duplicates by hashing and near-duplicates with MinHash and locality-sensitive
  hashing, and explain why duplicates harm a model.
- **Builds on:** lesson 03; P2 hash tables; llm-06's cost of passes over large data.
- **Key ideas:**
  - Duplicated training data makes a model memorise and inflates evaluation when test items also appear in training.
  - Exact duplicates fall to a content hash; near-duplicates need a similarity measure — Jaccard similarity of the
    documents' shingle sets.
  - MinHash estimates Jaccard similarity from short signatures; locality-sensitive hashing buckets similar signatures
    so candidates are found without comparing every pair.
  - The Stack v2 used 5-gram shingles and a Jaccard threshold of 0.7, keeping one file per duplicate group; roughly 40%
    of its permissively licensed files were near-duplicates (dataset card).
- **Recall targets:** why duplicates hurt; what MinHash estimates and why it is cheaper than pairwise comparison; how a
  threshold trades false merges against missed duplicates.
- **Build:** exact and MinHash-with-LSH deduplication written from scratch under `code/src/python/` (planned), run on a
  toy corpus with planted near-duplicates; tests check planted pairs are caught and distinct files survive.
- **Efficiency lens:** signature memory per file and time per thousand files, measured, then extrapolated to the
  corpus size from lesson 01.
- **Sources:**
  - Lee et al., "Deduplicating Training Data Makes Language Models Better", arXiv:2107.06499v2, Section 4.2
  - arXiv:2402.19173v1, Section 3.1 Removing Near-Duplicates
  - The Stack v2 dataset card, "Data Collection" (near-duplicate share)
- **Done when:** the tests pass, and Sam explains MinHash and the threshold choice unaided.

## 05 — Decontamination against evaluation sets

- **Objective:** Sam can remove evaluation material from training data with an n-gram overlap check, before training,
  so llm-13's results mean something.
- **Builds on:** lesson 04; the benchmarks llm-13 will use (HumanEval and its infilling variants).
- **Key ideas:**
  - A model that saw a benchmark's solutions in training scores well for the wrong reason.
  - StarCoder 2 removed training files containing HumanEval and MBPP docstrings or solutions, among others.
  - GPT-3 flagged test items sharing a 13-gram with the training data — deliberately conservative.
  - Decontamination is a data-pipeline step; llm-13 re-checks the other direction with the same tool.
- **Recall targets:** why contamination inflates scores; how an n-gram overlap test works and what n trades off.
- **Build:** an n-gram overlap checker under `code/src/python/` (planned) that flags training files overlapping a
  given evaluation set; tests use planted overlaps in synthetic data. llm-13 reuses it.
- **Sources:**
  - arXiv:2402.19173v1, Section 3.3 Decontamination
  - Li et al., "StarCoder: may the source be with you!", arXiv:2305.06161v2, Section 5.2
  - Brown et al., "Language Models are Few-Shot Learners", arXiv:2005.14165v4, Appendix C
- **Done when:** the checker's tests pass, and Sam explains why this runs before training, not after.

## 06 — Quality filtering and language weighting

- **Objective:** Sam can apply simple quality heuristics to code files and choose a language mix for his model with its
  reasons.
- **Builds on:** lessons 03–05; his own languages (C, Rust, Python, Nix, PHP, shell) as the target mix.
- **Key ideas:**
  - Cheap heuristics remove most junk: auto-generated files, very long average or maximum line length, a low share of
    alphanumeric characters, embedded data files such as large XML.
  - Each filter is checked by inspecting what it removes, per language — a filter that suits one language can gut
    another.
  - Weighting decides how much of the compute budget each language gets; StarCoder sampled in proportion to volume but
    capped data-like formats (JSON, YAML, CSS).
  - Small languages in Sam's mix (Nix, shell) may need up-sampling; the choice is recorded and measured later per
    language (llm-11, llm-13).
- **Recall targets:** three quality heuristics and what each removes; what weighting changes and what it costs.
- **Build:** a heuristic quality filter under `code/src/python/` (planned) with per-rule counts; tests on synthetic
  files that each rule should and should not remove.
- **Efficiency lens:** bytes and files removed per rule and per language, and the resulting mix against the lesson 01
  token target.
- **Sources:**
  - Chen et al., "Evaluating Large Language Models Trained on Code", arXiv:2107.03374v2, Section 3.1 Data Collection
  - arXiv:2305.06161v2, Section 3.1 Programming Languages (filters) and Section 3.6 Weighting of data sources
- **Done when:** the tests pass, and Sam's chosen mix and its reasons are recorded in `NOTES/`.

## 07 — Security scrubbing: secrets and PII

- **Objective:** Sam can find and redact secrets and personal data in a code corpus, and explain what automatic
  scrubbing misses.
- **Builds on:** lessons 03–06; sec-01; this repository's secrets gate (`.github/workflows/audit-secrets.yml`).
- **Key ideas:**
  - Public code contains live keys, passwords, email addresses and IP addresses; a model can memorise and repeat them.
  - Pattern and detector scanners (TruffleHog's filesystem source scans a directory) find many secrets; a trained
    detector (StarPII) was used for names, emails, keys, passwords, IP addresses and usernames in StarCoder and The
    Stack v2.
  - Redaction replaces a finding with a placeholder token, consistently, so the model learns the shape, not the value.
  - TruffleHog's validation step logs in with a found secret to see whether it is live; whether that is appropriate
    for third parties' secrets in a corpus is a decision — check the scanner's options on the day.
  - The Stack v2 also removed malware found by ClamAV — reading only here; live samples are never handled.
- **Recall targets:** the classes of data scrubbed; why a placeholder and not deletion; what automatic scanning misses.
- **Build:** a scrubber under `code/src/python/` (planned) that redacts planted **fake** secrets and personal data in
  synthetic files; tests assert every planted item is redacted and ordinary code is untouched. Real scans run in the
  model-training repository (created when this build starts).
- **Security lens:** only fabricated secrets in tests — never a real key, even a revoked one; findings in the real
  corpus are recorded as counts, never copied into notes.
- **Sources:**
  - arXiv:2402.19173v1, Section 3.2 PII Redaction and Section 3.4 Malware Removal
  - arXiv:2305.06161v2, Section 4 PII redaction
  - TruffleHog v3.97.9 README, "Validation" and "Scan individual files or directories":
    <https://github.com/trufflesecurity/trufflehog/blob/v3.97.9/README.md>
- **Done when:** the scrubber's tests pass, and Sam lists what his scrubbing would still miss.

## 08 — Dataset cards and provenance

- **Objective:** Sam can write a dataset card for his corpus that records its sources, licences, processing steps and
  known gaps, with the identifiers needed for attribution and opt-outs.
- **Builds on:** lessons 01–07; tooling-05 (licence metadata, SPDX).
- **Key ideas:**
  - A dataset card is the dataset's README: what it contains, how it was made, its licence and how it should be used;
    YAML metadata at the top carries licence, language and size.
  - "Datasheets for Datasets" gives the questions a card answers: motivation, composition, collection, preprocessing,
    uses, distribution, maintenance.
  - Provenance is data, not prose: a manifest of source identifiers (SWHIDs where The Stack v2 is used) and content
    hashes for every file kept, so an opt-out can be traced and applied.
  - The card is versioned with the pipeline; a change in any stage is a new corpus version.
- **Recall targets:** the sections of a datasheet; what the manifest must hold to honour an opt-out; why the card is
  versioned.
- **Build:** the corpus's dataset card and manifest format in the model-training repository (created when this build
  starts), reviewed against the datasheet questions.
- **Security lens:** the manifest makes removal requests actionable and the corpus auditable.
- **Sources:**
  - Hugging Face Hub, "Dataset Cards": <https://huggingface.co/docs/hub/datasets-cards>
  - Gebru et al., "Datasheets for Datasets", arXiv:1803.09010v8
  - Software Heritage statement, "Principles" (URL as lesson 02)
- **Done when:** the card answers every datasheet question that applies, and Sam can trace one file from the card back
  to its source identifier.
