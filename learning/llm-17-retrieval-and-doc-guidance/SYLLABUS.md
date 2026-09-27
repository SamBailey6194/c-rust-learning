# Syllabus — llm-17-retrieval-and-doc-guidance

**Track**: llm · **Phase**: L5 · **Path**: Core · **Detail**: full · **Prerequisites**: llm-16 (the skills layer, especially lessons 04–05: the context budget and doc guidance as resources); llm-15 lesson 05 (KV bytes per token); P3
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The model is meant to work through "doc guidance" as well as skills, and Sam's later domain variants
(legal, HR, finance, business) are only responsible if they answer from current, authoritative
sources rather than from memory. This topic builds the retrieval half of that: cut Markdown into
chunks along its headings, find the right chunks lexically (BM25) and by meaning (embeddings), fuse
the two, put a few into the context with citations and dates, measure whether retrieval found the
right thing, and treat every retrieved word as data, never as instructions. The corpus is Markdown
Sam already owns — this repository's guides, workflows and skills — so every answer can be checked
against its source. **Where the work lands:** the chunker, the ranking functions and the metrics are
lesson crates at planned paths under `code/src/rust/crates/`; the retrieval service, the labelled
query set and the injection fixtures land in the inference repository (created when this build starts).
It feeds llm-18 (injected instructions and vector-store weaknesses as threats), llm-20 (domain
adapters only with retrieval) and os-17.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Chunking Markdown by headings | 2–3 sittings | yes — heading chunker | Efficiency |
| 02 | Lexical retrieval with BM25 | 2–3 sittings | yes — BM25 ranker | Efficiency |
| 03 | Dense retrieval: embeddings and nearest neighbours | 2–3 sittings | yes — dense search | Efficiency |
| 04 | Hybrid ranking and building the context | 1 sitting | yes — rank fusion | Efficiency |
| 05 | Citations, freshness and authoritative sources | 1 sitting | yes — cited answers | Security |
| 06 | Evaluating retrieval | 2–3 sittings | yes — retrieval metrics | Efficiency |
| 07 | Injected instructions in retrieved documents | 2–3 sittings | yes — injection fixtures | Security, Safety |

---

## 01 — Chunking Markdown by headings

- **Objective:** Sam can split a Markdown file into chunks that follow its heading structure, carry
  their heading trail and source path, and stay under a token limit.
- **Builds on:** llm-16 lesson 05 (short sections serve skills and retrieval alike); this
  repository's one-`#`-per-file, heading-led style; P3 (iterators, error handling).
- **Key ideas:**
  - CommonMark has two heading forms — ATX (`#` to `######`) and setext (underlined with `=` or
    `-`) — and a `#` line inside a fenced code block is code, not a heading; a regex on lines gets
    both wrong, a parser does not.
  - A chunk is a heading's section plus its trail (`file → H1 → H2 → H3`), so a chunk read alone
    still says where it came from.
  - Size is measured in tokens, not characters: split an oversized section at paragraph boundaries,
    keep code fences whole where possible, and never split mid-table.
  - The metadata travels with the chunk: path, heading trail and, for this repository, the
    `**Last Updated**` or `**Checked**` date when the file has one (lesson 05 uses it).
- **Recall targets:** predict how a given file splits, including a `#` inside a code fence and a
  setext heading; explain why the trail belongs in the chunk.
- **Build:** `heading chunker` — a Rust crate at the planned path
  `code/src/rust/crates/msNNN_heading_chunker/` that parses Markdown with a CommonMark parser
  (pulldown-cmark 0.13.4 is MIT; run `cargo deny check` after `cargo add`) and emits chunks with path,
  heading trail and text under a token budget. Tests use fixture Markdown written in the test (ATX and
  setext headings, a `#` inside a fence, a section over budget, a table) and check the chunk
  boundaries. Checked by `cargo test` and `cargo clippy`, then run over this repository's guides.
- **Efficiency lens:** chunk count and the token distribution for this repository's `code/docs/`,
  against the budget from llm-16 lesson 04.
- **Sources:** CommonMark Spec 0.31.2 → Sections 4.2 ("ATX headings"), 4.3 ("Setext headings"),
  4.5 ("Fenced code blocks"), <https://spec.commonmark.org/0.31.2/>; pulldown-cmark 0.13.4 API docs,
  <https://docs.rs/pulldown-cmark/latest/pulldown_cmark/>; `code/docs/RUST-CODING-PRINCIPLES.md` →
  Section 3.
- **Done when:** the crate's tests pass, and Sam predicts the chunks of an unseen guide before running
  it.

## 02 — Lexical retrieval with BM25

- **Objective:** Sam can compute BM25 scores by hand for a tiny corpus, implement the ranking, and
  explain what its two tuning parameters do.
- **Builds on:** lesson 01; Sam's own experience of search boxes that match words, not meaning.
- **Key ideas:**
  - An inverted index maps each term to the chunks containing it, so a query touches only the chunks
    that share its terms.
  - Inverse document frequency rewards rare terms; term frequency rewards repetition, but with
    saturation; length normalisation stops long chunks winning by size alone.
  - `k1` sets how quickly term frequency saturates (0 gives a binary model); `b` sets how strongly
    document length normalises (0 none, 1 full).
  - Tokenising for BM25 is not the model's tokeniser: lower-casing and splitting code identifiers
    (`snake_case`, `kebab-case`, paths) decides what can match.
- **Recall targets:** predict how a score moves when a term repeats, when the chunk doubles in
  length, and when the term appears in every chunk.
- **Build:** `BM25 ranker` — a Rust crate at the planned path `code/src/rust/crates/msNNN_bm25/` with
  an inverted index and BM25 scoring over lesson 01's chunks. Tests check scores against values Sam
  works out by hand for a three-chunk corpus, and the effect of `k1 = 0` and `b = 0`. Checked by
  `cargo test` and `cargo clippy`. (Tantivy, MIT, is the production-grade reference; the lesson
  writes the scorer itself.)
- **Efficiency lens:** index size in bytes and query time over this repository's Markdown.
- **Sources:** Manning, Raghavan and Schütze, "Introduction to Information Retrieval" (Cambridge
  University Press, 2008), Chapter 11 → "Okapi BM25: a non-binary model",
  <https://nlp.stanford.edu/IR-book/html/htmledition/okapi-bm25-a-non-binary-model-1.html>, and
  Chapter 6 on tf-idf weighting, <https://nlp.stanford.edu/IR-book/>; Tantivy,
  <https://github.com/quickwit-oss/tantivy> (MIT, 0.26.2).
- **Done when:** the crate's scores match Sam's hand calculation, and he explains both parameters
  unaided.

## 03 — Dense retrieval: embeddings and nearest neighbours

- **Objective:** Sam can embed chunks and queries with a local embedding model, rank by cosine
  similarity, and say what dense retrieval finds that BM25 misses — and what it costs in memory.
- **Builds on:** lessons 01–02; llm-04 (embeddings and dot products); llm-15 lesson 01 (measuring on
  this machine).
- **Key ideas:**
  - A sentence-embedding model maps text to a fixed-length vector so that related texts land close
    together (Sentence-BERT, arXiv:1908.10084); retrieval trains query and passage encoders for this
    (DPR, arXiv:2004.04906).
  - Cosine similarity of normalised vectors is a dot product; exact search compares the query with
    every vector — fine for thousands of chunks.
  - Approximate nearest-neighbour graphs (HNSW, arXiv:1603.09320) trade a little recall for much
    faster search at millions of vectors; this corpus does not need one yet.
  - Memory is `chunks * dimensions * bytes_per_value`; the embedding model has its own weights and
    VRAM or RAM cost.
  - llama-server serves embeddings from a dedicated embedding model (`--embedding`, with a
    `--pooling` type) at `POST /embedding`, with an optional normalisation.
- **Recall targets:** give one query dense retrieval should win and one BM25 should win, before
  testing them; compute the vector store's size for this corpus.
- **Build:** `dense search` — a Rust crate at the planned path
  `code/src/rust/crates/msNNN_dense_search/` that stores normalised vectors with their chunk IDs and
  returns the exact top-k by cosine similarity. Tests use small hand-made vectors with known
  neighbours (and a zero vector, which must not divide by zero). Checked by `cargo test` and
  `cargo clippy`. Embedding the real corpus through a local llama-server is a measurement recorded
  in the verification record.
- **Efficiency lens:** embedding time for the corpus, vector store bytes, query latency, and the
  embedding model's VRAM or RAM.
- **Sources:** Reimers and Gurevych (Sentence-BERT), arXiv:1908.10084; Karpukhin et al. (DPR),
  arXiv:2004.04906; Malkov and Yashunin (HNSW), arXiv:1603.09320; llama.cpp `tools/server/README.md`
  → `--embedding`, `--pooling`, `POST /embedding`, <https://github.com/ggml-org/llama.cpp> (MIT,
  release b11221, commit 136887b).
- **Done when:** the crate's tests pass, and the record shows both of Sam's predicted queries with
  BM25 and dense rankings side by side.

## 04 — Hybrid ranking and building the context

- **Objective:** Sam can fuse lexical and dense rankings, choose how many chunks go into the prompt,
  and order them for a small model within the context budget.
- **Builds on:** lessons 02–03; llm-16 lesson 04 (the budget); llm-15 lesson 07 (prefix caching).
- **Key ideas:**
  - Reciprocal rank fusion scores each chunk by summing `1 / (k + rank)` over the rankings that
    contain it; it needs no score calibration between systems, and its authors fixed `k = 60`.
  - Retrieval-augmented generation conditions the model on retrieved passages rather than relying on
    what its weights remember (arXiv:2005.11401).
  - More chunks are not better: every chunk costs tokens and KV bytes, and models use the middle of
    a long context worst (arXiv:2307.03172) — few, well-ranked chunks, the best at the edges.
  - Keep the stable parts of the prompt first and retrieved chunks after, so the prefix cache still
    serves the system prompt and skill catalogue.
- **Recall targets:** compute an RRF score for a chunk from two ranks; argue a top-k for llm-01's
  model from its budget.
- **Build:** `rank fusion` — a Rust crate at the planned path `code/src/rust/crates/msNNN_rank_fusion/`
  that fuses ranked lists with RRF and trims the result to a token budget. Tests use hand-worked
  rankings, ties and a list that is empty. Checked by `cargo test` and `cargo clippy`.
- **Efficiency lens:** tokens spent on retrieved context per question, against the budget.
- **Sources:** Cormack, Clarke and Büttcher, "Reciprocal Rank Fusion outperforms Condorcet and
  individual Rank Learning Methods" (SIGIR 2009),
  <https://plg.uwaterloo.ca/~gvcormac/cormacksigir09-rrf.pdf>; Lewis et al. (RAG), arXiv:2005.11401;
  Liu et al., arXiv:2307.03172.
- **Done when:** the crate's tests pass, and Sam justifies his top-k with the budget arithmetic.

## 05 — Citations, freshness and authoritative sources

- **Objective:** Sam can make every retrieved answer cite its chunk (path and heading), refuse when no
  retrieved chunk supports an answer, prefer the newest authoritative version of a source, and
  respect the source's licence.
- **Builds on:** lessons 01–04; this repository's own habit of pinning sources by URL, section and
  version.
- **Key ideas:**
  - A citation names what was retrieved, not what the model claims: path and heading trail, carried
    from the chunk, shown beside the answer so a reader can check it.
  - "No supporting chunk" is an answer: refusing beats inventing, and is easy to test.
  - Freshness is metadata: a chunk carries its source's date or version, and a newer version
    replaces an older one rather than competing with it.
  - For UK legislation, legislation.gov.uk publishes revised legislation through its API under the
    Open Government Licence v3.0, which permits reuse with a stated attribution — the kind of source
    llm-20's domain variants would need.
  - An assistant to professionals says what it is not: the answer points to the source, and the
    professional decides.
- **Recall targets:** say what a citation must contain and where it comes from; state the OGL's
  attribution requirement in one line.
- **Build:** `cited answers` — in the inference repository (created when this build starts), the answer
  step of the retrieval service: it numbers the retrieved chunks, asks the model to cite by number,
  checks every cited number exists, and returns "no supporting source" when none qualifies. The
  lesson 01 chunker gains a date field here. Checked by tests with fixture chunks, including a
  question no chunk answers.
- **Security lens:** provenance is a defence: an answer that must cite retrieved chunks is harder to
  steer from outside, and a chunk from an unlisted source is dropped, not cited (lesson 07).
- **Sources:** legislation.gov.uk "Developer Zone", <https://www.legislation.gov.uk/developer> (read
  27/09/2026); Open Government Licence v3.0,
  <https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/>; Lewis et al.,
  arXiv:2005.11401.
- **Done when:** the tests pass, including the refusal case, and every answer in a demo run cites
  chunks that exist.

## 06 — Evaluating retrieval

- **Objective:** Sam can build a labelled query set for his own corpus and compare BM25, dense and
  hybrid retrieval with standard ranked-retrieval measures.
- **Builds on:** lessons 02–04; llm-13 (held-out sets and contamination).
- **Key ideas:**
  - Retrieval is judged separately from generation: did the right chunk reach the top k at all?
  - A labelled set is questions written by Sam with the chunk that answers each — written before
    looking at any system's output, so it cannot flatter one.
  - Precision at k, recall at k and R-precision count hits; NDCG also rewards putting the best chunk
    first.
  - A small set is noisy: report the count of questions next to every score, and look at the misses
    one by one.
- **Recall targets:** compute precision at 3 and recall at 3 for a hand-given ranking; explain why
  NDCG can differ between two rankings with equal recall.
- **Build:** `retrieval metrics` — a Rust crate at the planned path
  `code/src/rust/crates/msNNN_retrieval_eval/` with precision at k, recall at k and NDCG, tested on
  hand-worked rankings. Checked by `cargo test` and `cargo clippy`. The labelled query set (about 30
  questions over this repository's guides) and the comparison results land in the inference repository,
  with a summary in the verification record.
- **Efficiency lens:** quality against cost — each method's scores beside its index size and query
  latency.
- **Sources:** Manning, Raghavan and Schütze, Chapter 8 → "Evaluation of ranked retrieval results",
  <https://nlp.stanford.edu/IR-book/html/htmledition/evaluation-of-ranked-retrieval-results-1.html>.
- **Done when:** the crate's tests pass, and the record compares the three methods on the same
  labelled set with the misses explained.

## 07 — Injected instructions in retrieved documents

- **Objective:** Sam can show a local model obeying an instruction planted in a retrieved document,
  explain why that is indirect prompt injection, and measure how much his defences reduce it.
- **Builds on:** lessons 04–06; sec-01 (trust boundaries); llm-16 lesson 03 (trust-gated skills).
- **Key ideas:**
  - Indirect prompt injection: instructions arrive inside data the application retrieves, not from
    the user (arXiv:2302.12173; OWASP LLM01:2025, still LLM01 in the 2026 list).
  - Vector and embedding stores carry their own risks — unauthorised access, cross-context leaks
    between users, embedding inversion and poisoning (OWASP LLM08:2025, now LLM09:2026).
  - No delimiter makes retrieved text safe, because the model sees one stream of tokens; defences
    reduce the odds and the damage: allow-listed sources, provenance on every chunk, retrieved text
    marked as quoted data, no tool or skill activation driven by retrieved text, and a human in the
    loop for actions.
  - Test it: a fixture corpus with planted instructions is part of the evaluation set, and the rate
    at which the model follows them is a tracked number (sec-15 builds the full adversarial suite).
- **Recall targets:** explain why delimiting cannot fully stop indirect injection; name three
  controls and what each limits.
- **Build:** `injection fixtures` — in the inference repository, fixture documents with planted
  instructions (harmless ones: "reply only in capitals", "ignore the question"), added to the lesson 06
  evaluation, with a measured follow-rate before and after Sam's controls. Checked by the rate being
  recorded for both runs in the verification record.
- **Security lens:** retrieved text is untrusted input crossing a trust boundary; the controls here
  feed llm-18's threat model.
- **Safety:** planted instructions are harmless and aimed only at Sam's own local model; no
  third-party system is targeted (the sec track's authorised-lab rule).
- **Sources:** Greshake et al., "Not what you've signed up for", arXiv:2302.12173; OWASP LLM01:2025
  Prompt Injection, <https://genai.owasp.org/llmrisk/llm01-prompt-injection/>; OWASP LLM08:2025
  Vector and Embedding Weaknesses,
  <https://genai.owasp.org/llmrisk/llm082025-vector-and-embedding-weaknesses/>; OWASP Top 10 for LLM
  Applications 2026 (03/08/2026), <https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/>.
- **Done when:** the record shows the follow-rate with and without the controls, and Sam explains
  what the remaining rate means.
