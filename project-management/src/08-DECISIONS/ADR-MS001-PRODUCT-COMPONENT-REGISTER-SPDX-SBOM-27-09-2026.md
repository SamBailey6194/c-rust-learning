# ADR-MS001: Product component register — an SPDX SBOM per release and a hand-kept ledger, per product

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-PRODUCT-COMPONENT-REGISTER-SPDX-SBOM |
| **Status** | Proposed |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | `research/SBOM-FORMATS-AND-GENERATORS.md` (planned) — SPDX 2.3 against 3.0.x, including the AI and Dataset profiles; CycloneDX's standing; generators and validators for Rust, Python and system packages; whether the NTIA minimum elements of 12/07/2021 have been superseded; this record stays `Proposed` until the note exists |
| **Enforced in** | each product repository's release process (its release checklist and the CI job that builds a release) · `learning/tooling-05-licensing-and-collaboration/SYLLABUS.md` → lesson 08, which teaches the register |

---

## Context

This record answers Sam's question of 27/09/2026 about how the components each product ships are
recorded. His answer was a register in each product repository, made of a generated SPDX software bill
of materials (SBOM) for every release plus a hand-kept ledger, while this repository never becomes a
distributor. It sits beside the other two licence records of the round:
`ADR-MS001-PRODUCT-LICENCES-INBOUND-RULES-27-09-2026.md` (what may enter a product) and
`ADR-MS001-PRODUCT-LICENCES-APPROVED-OUTBOUND-LIST-27-09-2026.md` (what a product may be licensed as).

This is an engineering record of how licences are handled here. It is not legal advice. An SBOM
records obligations; it does not meet them. A GPL source offer, for example, still has to be made.

What stands today:

- **No register exists.** `code/src/rust/deny.toml` calls its own allow list "a policy statement, not
  an inventory": it decides what may enter this workspace, and records nothing about what shipped.
- **The lessons already hold the seeds of one:**
  - `tooling-05` lesson 04's ledger row (source, revision or digest, licence, terms, obligations) for
    every model and dataset
  - `llm-10` lesson 08's dataset card and manifest of source identifiers and content hashes
  - `os-07` lesson 02's package manifest of every file with its hash, mode and type
  - `os-16` lesson 01's package manifest (name, upstream version, applied patches, profiles), which its
    advisory matcher reads
- **SPDX identifiers are already in use.** The Cargo workspace declares `license = "GPL-2.0-only"`
  (`code/src/rust/Cargo.toml`), the licence policy is written in SPDX identifiers
  (`code/src/rust/deny.toml`), and `tooling-05` lesson 03 teaches SPDX expressions.
- **Distribution is where obligations start.** GPL-2.0's binary terms apply only when object code is
  distributed, and this repository's crate exceptions rest on it distributing no binaries
  (`ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md` → Context and Decision). Publishing release SBOMs
  here would make this repository hold a distributor's record for products it does not ship.

Facts checked on 27/09/2026:

- **Host tools.** None of `reuse`, `syft`, `cargo-cyclonedx`, `cargo-sbom`, `trivy` or `pyspdxtools`
  is installed (`command -v`). cargo-deny 0.19.0's `list` subcommand prints the licences in the graph
  and the crates that use them, as human-readable text, JSON or TSV; it writes no SBOM format
  (`cargo deny list --help`).
- **SPDX.** The specification's current line is 3.0 and the previous one 2.3, and SPDX is the
  international standard ISO/IEC 5962:2021 (Sources, item 1). SPDX 3.0.1 defines profiles that include
  Software, Security, Licensing, Build, Lite, AI and Dataset (Sources, item 2), so model weights and
  training data have profiles of their own.
- **CycloneDX.** The latest specification is 1.7, published by Ecma International as ECMA-424
  (Sources, item 3).
- **NTIA minimum elements.** The report was published on 12/07/2021 (Sources, item 4). Its field list,
  and whether a later document supersedes it, were not re-read today; the research note settles both.

Clash check (`project-management/workflows/08-decisions/` Step 3), 27/09/2026:

- **Crate licences** — consistent. This repository keeps no register and still distributes nothing.
- **Inbound rules** — consistent. Their rule 4 requires a ledger row before data or weights enter a
  product; this record defines that ledger.
- **Approved outbound list** — consistent. A release's SBOM is the evidence that the product still
  meets its entry's conditions, such as "no copyleft component in any shipped binary" for the
  proprietary entry.
- **Graduation path** (`ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`) — unaffected. The
  private infrastructure repository ships nothing, so it keeps no register.
- **Remote-help tool** (`ADR-MS001-REMOTE-HELP-TOOL-CONSENT-FIRST-27-09-2026.md`, `Proposed` in the
  same round) — consistent. It is a product repository, so each of its releases carries a register, its
  crypto provider included.
- **Private CA** (`ADR-MS001-PRIVATE-CA-OFFLINE-ROOT-AND-ACME-27-09-2026.md`, `Proposed` in the same
  round) — unaffected. A CA is run, not shipped, so it keeps no register.
- **Capture library** (`ADR-MS001-CAPTURE-LIBRARY-STANDALONE-27-09-2026.md`, the scripted-recorder
  round) — consistent. Its Follow-on ships an SBOM with its first release under this record.

## Options considered

### Option A — A per-product SPDX SBOM for every release, plus a hand-kept ledger

- **Summary:** Each product repository generates an SPDX SBOM for every release from its build, and
  keeps a ledger by hand for what no generator can see: data, model weights and firmware.
- **Pros:** The record is made where the release is made, from the build itself. SPDX matches the
  identifiers already in use and taught, and its AI and Dataset profiles cover weights and data. The
  ledger extends a row format the lessons already teach.
- **Cons:** No generator or validator is installed yet. A hand-kept ledger can drift from the release
  unless the release checks it.

### Option B — Leave it to each product, undecided

- **Summary:** Each product repository decides at its first release whether and how to record its
  components.
- **Pros:** No work now; each product fits its own ecosystem.
- **Cons:** The inbound rules' ledger row and the outbound list's conditions have no agreed evidence
  behind them, and each product re-argues the format.

### Option C — One register kept in this repository

- **Summary:** This repository holds every product's SBOMs and ledgers in one place.
- **Pros:** One place to read everything.
- **Cons:** It would make this repository hold a distributor's record for binaries it does not ship,
  against the premise of its own crate exceptions. It would also drift from the product repositories,
  where the releases actually happen.

### Option D — CycloneDX instead of SPDX

- **Summary:** As Option A, but each release's SBOM is written in CycloneDX.
- **Pros:** A widely used format, published as an Ecma standard, with its own tooling.
- **Cons:** Breaks continuity with the SPDX identifiers this repository already uses and teaches. Its
  coverage of data and weights against SPDX's has not been compared yet.

## Decision

**We will take Option A** (Sam's answer of 27/09/2026 on the component register). The deciding factor
is that a release is where obligations arise and where the facts about its contents exist, so the
record is generated there, in a format this repository already speaks. Option D was the runner-up. It
lost on continuity with the SPDX identifiers in use and taught here. The research note's comparison
of the two formats is what would reopen it.

The rules:

1. **An SPDX SBOM is generated for every release.** It is generated, never typed. The SPDX version,
   the generator and the validator are fixed at that product's first release, from the research note.
2. **A ledger is kept by hand** for data, model weights and firmware. It extends `tooling-05`
   lesson 04's row with an SPDX element ID, a digest, the use made of the item, its redistribution
   terms and its obligations.
3. **Both ship with every release.** A Syntek OS release's register is published in the Syntek OS
   package archive beside its images and packages, a model release's in the model-release repository
   beside its weights, and every other product's beside its release.
4. **A release fails** if any component lacks a concluded licence, or any data, weight or firmware
   item lacks a ledger row.
5. **This repository teaches the register and keeps none.**

To move to `Accepted`: `research/SBOM-FORMATS-AND-GENERATORS.md` pins the SPDX version and names at
least one maintained generator and validator for each ecosystem a product ships (Rust, Python and
system packages), and Sam signs off.

This answer changes if the research shows that SPDX cannot carry the ledger's fields, or that no
maintained generator or validator exists for an ecosystem a product ships, or if this repository ever
starts distributing binaries, images or packages. Each would be argued in a new ADR.

## Consequences

- **Positive:** Every release says what it contains and under which terms, so a licence obligation or
  a vulnerability can be traced to the exact component shipped. `os-16` lesson 01's advisory matcher
  gets a real input, and the ledger covers what generators cannot see.
- **Negative:** Each product repository maintains a release step and a ledger. The generator half of
  the lesson is blocked until a generator is installed, and a hand-kept ledger needs the release check
  (rule 4) to stay true.
- **Follow-on:**
  - `learning/tooling-05-licensing-and-collaboration/SYLLABUS.md` gains lesson 08 (software bills of
    materials and the component ledger), taught before any product's first release.
  - `GAPS.md` gains the toolchain gap "No SBOM generator or REUSE linter installed", which blocks the
    generator half of that lesson, and `how-to/docs/TOOLCHAIN.md` lists the tools as not installed
    until the research note chooses them.
  - The first product release applies rules 1 to 4, and its release checklist names this record.

## Sources

1. **SPDX specifications** — <https://spdx.dev/use/specifications/> — 3.0 current and 2.3 previous;
   SPDX as ISO/IEC 5962:2021, checked 27/09/2026
2. **SPDX specification 3.0.1** — <https://spdx.github.io/spdx-spec/v3.0.1/> — the profiles it
   defines, AI and Dataset among them, checked 27/09/2026
3. **CycloneDX specification overview** — <https://cyclonedx.org/specification/overview/> — version
   1.7 and its publication as ECMA-424, checked 27/09/2026
4. **NTIA, The Minimum Elements for a Software Bill of Materials (SBOM)** —
   <https://www.ntia.gov/report/2021/minimum-elements-software-bill-materials-sbom> — published
   12/07/2021; its field list was not re-read, checked 27/09/2026
5. **Host commands, 27/09/2026** — `command -v` for reuse, syft, cargo-cyclonedx, cargo-sbom, trivy and
   pyspdxtools (none installed); `cargo deny --version` (0.19.0); `cargo deny list --help` (output
   formats human, JSON and TSV)
6. **Sam's answers in the networking and licensing round, 27/09/2026** — a register per product
   repository: a generated SPDX SBOM per release plus a hand-kept ledger; this repository never becomes
   a distributor
