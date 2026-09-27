---
name: research
description: >-
  Answer one question against primary sources (the WG14 C standard drafts, the GCC and GNU
  manuals, man pages, docs.kernel.org and the kernel source, the Rust Reference and Rustonomicon,
  the LFS books and each Syntek OS building block's own manual, PyTorch and NVIDIA CUDA docs,
  papers by arXiv ID) and capture a per-claim-cited note in research/ that feeds a decision: an
  ADR, an OS PROFILE spec, a kernel spec or a learning topic. Invoke by typing /research, or when a
  choice (C standard, warning flags, kernel config baseline, init system, bootloader, package
  signing, a crate or toolkit licence, a GPU toolchain) needs synthesis across sources beyond one
  library's or tool's own docs (those go to Context7).
---

# Skill: Research (c-rust-learning)

Research answers a question the repo cannot answer itself, such as which C standard to pin,
which warning flags earn their place, or which kernel config the profile fragments start from, by
reading **primary sources** and leaving a per-claim-cited **note** that a decision builds on. The
note is the deliverable; the ADR, OS profile spec or lesson that consumes it links back.

**Boundary with Context7.** For one library's or tool's own API (a `std` function, a crate, a
cargo or clippy flag), Context7 (`resolve-library-id` → `query-docs`) answers directly, once the
repo's own `code/docs/` and `how-to/docs/` have come up short. Reach for research when the question
needs **synthesis across primary sources** that no single page answers: comparing C11, C17 and
C23; weighing init systems for Syntek OS's profiles; establishing what the kernel's Rust support
covers today.

Locale: en_GB · Europe/London · dates DD/MM/YYYY.

## How to research

1. **Frame one answerable question.** Reduce the ask to a single question a note can settle.
   Check the repo first: an existing note in `research/`, an ADR in
   `project-management/src/08-DECISIONS/`, or a guide in `code/docs/` may already answer it. Name
   what the answer will feed.
   _Done when the question is one sentence, is not already answered in the repo, is not a
   single-tool lookup Context7 owns, and its Feeds target is named (or "unassigned")._
2. **Follow every claim to its primary source.** Read the source that _owns_ each fact (list
   below). A blog, a Q&A thread or a video is a scout that points at the primary, never the
   citation. Read what you cite: `man <page>` locally; `curl -sL <url>` into a scratch directory
   outside the repo for a web page or PDF; the `.rst` file in the kernel tree for a docs.kernel.org
   page; Context7 for the Rust books, citing the doc.rust-lang.org page it came from. `WebFetch`
   answers through a small summarising model, so it is a scout, not a source. For a long read,
   hand the reading to a subagent with the question and this rule, and keep working.
   _Done when every claim traces to a primary source that was actually opened, pinned by URL plus
   version, tag, commit or retrieval date._
3. **Check the licence before quoting.** Walk the licence ladder (below) for each source you want
   to quote verbatim. The default is to re-author the wording and cite the section; a quotation is
   the exception a licence has to permit. Source files are never committed: a PDF of a standard or
   a book in a public repo is redistribution, so the note pins the URL and version instead.
   _Done when every verbatim quotation has a source whose licence permits it, attribution sits
   beside it, and everything else is re-authored._
4. **Write the note.** Write `research/<SCREAMING-KEBAB-TOPIC>.md` in the shape below.
   _Done when the note exists, its Verdict opens with a bold one-line answer, every claim carries
   a citation, and `## What is not settled` lists what was not checked._
5. **Wire the note to its decision.** The consumer links back to the note by path: an ADR through
   `project-management/workflows/08-decisions/`, an OS profile spec through
   `project-management/workflows/07-os-profile-spec/`, a kernel spec through
   `project-management/workflows/06-kernel-spec/`, or a lesson through a row in the topic's
   `RESOURCES.md`. A primary source the repo will keep citing joins the external-source index in
   `REFERENCES.md`.
   _Done when the consumer references the note by path and the note's **Feeds** field names the
   consumer back._

## What counts as a primary source here

- **Standards.** WG14 drafts on open-std.org: N1570 (C11), N2310 (first C2x draft, marked against
  the C17 text, ISO/IEC 9899:2018), N3096 (C23). N2176, the C17 ballot draft, is password-protected there (checked
  27/09/2026). POSIX: The Open Group Base Specifications.
- **Toolchain manuals.** The GCC, GNU make, GDB and Valgrind manuals; the `man` pages installed on
  the host; the cargo, clippy and rustc books.
- **Kernel.** [docs.kernel.org](https://docs.kernel.org/), the kernel source tree (`Documentation/`,
  `Kconfig` files, `scripts/`), and merged commits or [lore.kernel.org](https://lore.kernel.org/)
  threads for "what landed, and when".
- **Rust.** The Rust Reference, The Rustonomicon, the `std` docs, and the kernel's own Rust
  documentation under docs.kernel.org.
- **Syntek OS building blocks.** The LFS and BLFS books; the pacman, apk and xbps manuals;
  reproducible-builds.org; the TUF specification; the init systems' and bootloaders' own docs.
  Buildroot and the Yocto Project are study references only: Syntek OS is built from scratch
  (`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md`).
- **LLM.** Papers by arXiv ID (cite the abstract page and version); the PyTorch and NVIDIA CUDA
  documentation at a pinned version; model and dataset cards, with their licence terms.
- **UI.** The ratatui, crossterm, gtk4-rs and zbus documentation; the Wayland protocol docs.
- **Security.** The OWASP projects, NIST special publications, MITRE CWE and ATT&CK, and the
  kernel's own security documentation.

The licence ladder below applies to all of these: arXiv papers and NVIDIA's documentation are
re-authored and cited, never quoted.

Secondary sources are scouts: they lead you to the primary, and the citation you keep is always
the primary.

## A lead is not a finding

An outside source (a blog, another repo, another model) earns a **look at the primary source**,
never a direct edit. **Consensus among secondary sources is not corroboration**: they copy one
another, so agreement is one source counted many times. Write-ups routinely say an `int` is 32
bits; the standard guarantees only that `INT_MAX` is at least 32767 (N1570 Section 5.2.4.2.1),
and whether plain `char` is signed is implementation-defined (N1570 Section 6.2.5). On this x86-64
host `int` is 32 bits and `char` is signed; on 64-bit Arm Linux `char` is unsigned. The standard
is what a note cites; the host is what a test observes.

## The licence ladder

Notes are committed to a **public** GPL-2.0-only repo, so a quotation in a note is a publication.

- **May quote, with attribution and a link:** MIT, BSD and ISC texts; MIT-or-Apache-2.0 dual
  texts taken on their MIT side (The Rust Book, and the Reference and Rustonomicon, which ship both
  licence files); kernel files whose SPDX line is GPL-2.0-compatible, and kernel files with no SPDX
  line, which fall under the tree's `COPYING` (GPL-2.0).
- **Re-author, never quote:** share-alike or GPL-incompatible licences, such as the GFDL of the
  GCC, GNU make and GDB manuals, cppreference's CC BY-SA, and Apache-2.0-only texts (which the FSF
  treats as incompatible with GPL-2.0).
- **Re-author, never quote, never commit:** sources that grant no licence, such as ISO C and the
  WG14 drafts, POSIX, K&R and most books and blogs.
- **Check per page:** Linux man pages carry different licences page by page; re-author unless the
  page's own licence has been checked.
- **Unsure?** Re-author.

## The note

```markdown
# {The question as a title} — {the short answer}

**Written**: {DD/MM/YYYY} · **Question from**: {the lesson, milestone or GAPS.md entry that raised it} · **Feeds**: {ADR, OS profile spec, kernel spec or learning topic, by path | unassigned}

## Question

{The single question, verbatim.}

## Verdict

**{One-line answer.}** {Two to four sentences of synthesis: what holds, what it costs, what it means here.}

---

## 1. {Claim} — {conclusion}

| Claim | Primary source |
| --- | --- |
| {finding, re-authored} | [{source}, Section {n}]({url}) ({version or retrieval date}) |

## 2. {Claim} — {conclusion}

## What is not settled

- **{What was not checked}**: {why, and what would settle it}.

---

## Sources

**Standards** — {links} · **Manuals** — {links} · **Kernel** — {links}

**Note on quoting**: no verbatim text is reproduced from any source above; every claim is
re-authored and cited to the source that owns it, per `research/CLAUDE.md`.
```

Where a note does quote a permitted source, the closing line names that quotation and its
licence instead. A durable fact that feeds no decision (a reusable fact about the toolchain)
belongs in `.claude/MEMORY.md`, not a note.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the consumer and follow its `STEPS.md` against its `CHECKLIST.md`:

- `project-management/workflows/08-decisions/`: ADR groundwork; `research/` pairs with it.
- `project-management/workflows/07-os-profile-spec/`: an OS profile spec's choices; `research/` pairs
  with it.
- `project-management/workflows/06-kernel-spec/`: a kernel plan's config, patch or boot choices.

## Cross-references

- `research/CONTEXT.md` · `research/CLAUDE.md`: the folder, the suggested first questions, and the
  citation and licence guardrails.
- `project-management/src/08-DECISIONS/ADR-MS000-TEMPLATE.md`: the ADR a note usually feeds.
- `project-management/src/07-OS-PROFILES/PROFILE-000-TEMPLATE.md` · `PROFILE-MATRIX.md`: the
  Syntek OS profile specs an OS note feeds.
- `project-management/src/06-KERNEL/`: the kernel specs a kernel note feeds.
- `.claude/skills/teach/SKILL.md`: a lesson's `RESOURCES.md` may cite a note.
- `REFERENCES.md`: the repo's index of external primary sources.
- `.claude/MEMORY.md` · `GAPS.md`: durable facts that are not decisions, and open blockers.
- `LICENSE`: the GPL-2.0-only licence every quotation has to sit beside.
