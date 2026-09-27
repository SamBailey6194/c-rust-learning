# Mission — llm-17-retrieval-and-doc-guidance

**Started**: not yet · **Family**: llm · **Phase**: L5 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam wants the model to work through "Markdown for skills, workflows, doc guidance", and he wants
later versions for coding and then legal, HR, finance and business work. The planning conversation
was clear that the second group is only responsible with current, UK-specific information retrieved
from authoritative sources, and with the model positioned as an assistant to professionals. A small
model cannot remember that material reliably, and should not try: it should find the right passage,
quote it with a citation and a date, and say so when nothing supports an answer. This topic builds
that retrieval layer over Markdown Sam already owns, measures it honestly, and treats every retrieved
word as untrusted data — the habit the secure-system topic (llm-18) and the domain adapters (llm-20)
depend on.

## Can do it when

- Sam can chunk Markdown by headings with a parser, carrying path, heading trail and date.
- Sam can compute BM25 by hand and explain `k1` and `b`.
- Sam can embed and search a corpus densely and say what it costs in memory.
- Sam can fuse rankings with RRF and justify a top-k from the context budget.
- Sam can make answers cite retrieved chunks, refuse when none supports them, and respect a source's
  licence.
- Sam can evaluate BM25, dense and hybrid retrieval on his own labelled query set.
- Sam can measure how often a planted instruction in a retrieved document is obeyed, with and without
  his controls.
- The chunker, BM25, dense-search, rank-fusion and metrics crates pass `cargo test` and
  `cargo clippy`.

## Parked for later

- Approximate nearest-neighbour indexes at scale — revisit if the corpus outgrows exact search.
- The full threat model of the skill and retrieval loop — llm-18.
- Domain adapters (legal, HR, finance, business) built on retrieval — llm-20, parked in
  `DEFERRED.md`.
- The adversarial test suite against the retrieval pipeline — sec-15.
