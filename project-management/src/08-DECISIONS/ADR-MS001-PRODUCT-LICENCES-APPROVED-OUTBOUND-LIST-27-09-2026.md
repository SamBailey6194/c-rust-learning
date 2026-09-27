# ADR-MS001: Product repository licences — the approved outbound list, for code

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-PRODUCT-LICENCES-APPROVED-OUTBOUND-LIST |
| **Status** | Proposed |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | `research/PRODUCT-OUTBOUND-LICENCE-COMPATIBILITY.md` (planned) — Apache-2.0 into GPLv3, GPLv3 with AGPLv3, LGPL libraries in a proprietary binary, Slint's royalty-free terms as they stand, and The Stack v3 and model licences; this record stays `Proposed` until the note exists |
| **Enforced in** | each product repository's licence ADR, which names its entry and the conditions it meets · `learning/tooling-05-licensing-and-collaboration/SYLLABUS.md` → lesson 05 |

---

## Context

This record answers two of Sam's questions of 27/09/2026. The first was how a product repository
chooses its outbound licence: his answer was that each one picks from an approved list when its build
starts. The second was which licences that list holds: his answer was the open licences plus two gated
commercial entries. It also records his answer the same day that the capture-library repository is
GPL-2.0-or-later, which puts that licence on the list. The rules for what may enter a product are a
separate record, `ADR-MS001-PRODUCT-LICENCES-INBOUND-RULES-27-09-2026.md`, whose rule 1 checks every
component against the entry picked here.

This is an engineering record of how licences are handled here. It is not legal advice.

The list covers code only. Model weights take their licence from the model-release repository's own
ADR, and datasets keep their own terms, which narrow the pick (inbound rules, rule 4). The private
infrastructure repository (`ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`) is never
published, so it takes no entry. This repository stays GPL-2.0-only and takes no entry either
(`ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md`).

Facts that force or narrow the list, checked on 27/09/2026:

- **The kernel is GPL-2.0-only** as a whole (Sources, item 1), so the downstream kernel tree, and
  anything that must combine with it, has one possible entry.
- **Apache-2.0 is compatible with GPLv3 but not with GPLv2.** GPLv3 is not compatible with GPLv2 by
  itself, but code under "GPLv2 or later" may be used under GPLv3 to make a combination (Sources,
  item 2). The GNU licences combine freely except where code is only under an older version and the
  project is under a newer one (Sources, item 3 → `#AllCompatibility`).
- **AGPLv3 is GPLv3 plus a network clause.** Its Section 13 lets users who interact with the program
  over a network receive its source. It is not compatible with GPLv2, and it is not strictly
  compatible with GPLv3 either, but Section 13 of each licence lets separate modules under the two be
  combined in one project. The FSF recommends it for software commonly run over a network (Sources,
  item 2).
- **LGPL-2.1 permits linking with non-free modules** and is compatible with GPLv2 and GPLv3 (Sources,
  item 2). Whether that is enough for a proprietary binary is left to the research note.
- **GPL-covered code cannot be incorporated in a proprietary system**, and releasing a contributor's
  code under another licence needs that contributor's permission (Sources, item 3 →
  `#GPLInProprietarySystem`, `#Consider`).
- **Most of the Rust ecosystem is dual-licensed `MIT OR Apache-2.0`** (`code/src/rust/deny.toml` →
  `[licenses]`), so that expression is the convention a Rust library meets its users with.
- **Slint** is offered as `GPL-3.0-only OR LicenseRef-Slint-Royalty-free-2.0 OR
  LicenseRef-Slint-Software-3.0`, and its royalty-free terms exclude embedded systems
  (`ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md` → Context, checked there on 27/09/2026).
- **The production rustls crypto providers carry Apache-2.0 terms**: ring 0.17.14 is
  `Apache-2.0 AND ISC`, and aws-lc-sys 0.45.0 includes `AND Apache-2.0` (Sources, item 4). A product
  that terminates TLS with rustls cannot be GPL-2.0-only.
- **The Stack v2 binds the model trained on it** to Software Heritage's principles, the first of which
  is release under a suitable open licence (Sources, item 5).

Clash check (`project-management/workflows/08-decisions/` Step 3), 27/09/2026:

- **Inbound rules** — consistent. Every entry below is an "outbound entry" in the sense of its rule 1,
  and the gated entries' CLA condition is the CLA route of its rule 2.
- **Crate licences** — unaffected. This repository keeps GPL-2.0-only and its exceptions.
- **GUI toolkit** — the Slint route stays open. `GPL-3.0-only` Slint combines under the
  GPL-3.0-or-later entry, and under AGPL-3.0-or-later through Section 13. Its royalty-free route is a
  `LicenseRef` with a field-of-use limit, so a product taking it enters Slint by a per-component
  exception ADR under inbound rule 1.
- **Remote-help tool** (`ADR-MS001-REMOTE-HELP-TOOL-CONSENT-FIRST-27-09-2026.md`, `Proposed` in the same
  round) — its provider licence has to fit the product's entry. GPL-3.0-or-later, AGPL-3.0-or-later and
  `MIT OR Apache-2.0` all admit an Apache-2.0 provider; `research/RUST-MTLS-STACK-LICENCES.md`
  (planned) confirms which one it takes.
- **Capture library** (`ADR-MS001-CAPTURE-LIBRARY-STANDALONE-27-09-2026.md`, the scripted-recorder
  round) — its GPL-2.0-or-later pick is on this list.
- **Component register** (`ADR-MS001-PRODUCT-COMPONENT-REGISTER-SPDX-SBOM-27-09-2026.md`, `Proposed` in
  the same round) — consistent. A release's SBOM is the evidence that a product still meets its entry's
  conditions.
- **Graduation path** (`ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`) and **private CA**
  (`ADR-MS001-PRIVATE-CA-OFFLINE-ROOT-AND-ACME-27-09-2026.md`) — unaffected. The private infrastructure
  repository takes no entry, and a CA is run, not shipped.
- **Scripted recorder** (`ADR-MS001-SCRIPTED-RECORDER-STAGED-LEARNING-PROJECT-27-09-2026.md`, the
  scripted-recorder round) — consistent. The recorder links the GPL-2.0-or-later capture library, so
  under that entry's conditions it cannot take the proprietary entry.

## Options considered

### Option A — Open licences only

- **Summary:** GPL-2.0-only (forced for the kernel tree), GPL-3.0-or-later, AGPL-3.0-or-later for
  network-served products, and `MIT OR Apache-2.0`.
- **Pros:** Every entry is a well-understood open licence. No licensor, CLA or commercial terms are
  needed, and family contributors only ever sign off.
- **Cons:** Closes the commercial routes the round was scoped for. A product that later needs one
  cannot get there without every contributor's agreement.

### Option B — Option A plus two gated commercial entries

- **Summary:** Option A, plus a proprietary entry and a dual GPL-3.0-or-later and commercial entry,
  each usable only when stated conditions are met.
- **Pros:** Keeps the commercial routes open, but only behind the conditions that make them workable:
  a named licensor, CLAs where relicensing is needed, and no component or dataset that forbids closed
  distribution.
- **Cons:** More entries to keep current. The gated entries cannot be used until the licensor is named,
  and their conditions rest on facts the research note still has to confirm.

### Option C — Minimal list

- **Summary:** GPL-2.0-only for the kernel tree and GPL-3.0-or-later for everything else.
- **Pros:** The smallest list; one copyleft family throughout.
- **Cons:** No permissive entry for libraries meant for wide reuse, no copyleft that reaches a
  network-served product, and no commercial route.

### Option D — No list (the status quo)

- **Summary:** Each product repository chooses any licence when its build starts.
- **Pros:** No work now; the widest freedom per product.
- **Cons:** The inbound rules check components against "the product's outbound entry", which then has
  no vetted set to come from. Every product re-argues the same compatibility facts from scratch.

## Decision

**We will take Option B, with one entry added: GPL-2.0-or-later** (Sam's answers of 27/09/2026 on the
approved list and on the capture-library repository's licence). The deciding factor is that it keeps
the commercial routes the round was scoped for while making each one conditional on the facts that
make it workable. Option A was the runner-up. It lost because a route closed now can only be reopened
later with every contributor's agreement.

The approved list:

| Entry (SPDX) | For | Conditions |
| --- | --- | --- |
| `GPL-2.0-only` | The downstream kernel tree, and anything that must combine with GPL-2.0-only code, such as kernel modules | Forced by the kernel's licence. Every component is GPLv2-compatible; no Apache-2.0-only component enters by any route, because the product distributes |
| `GPL-2.0-or-later` | A library meant to be consumed by products under more than one GPL entry (first user: the capture-library repository) | Components stay GPLv2-compatible, so a GPL-2.0-only consumer can still take it. A distributed binary that links it carries GPL terms as a whole, so the proprietary entry cannot use it |
| `GPL-3.0-or-later` | The default copyleft entry for products, including the Syntek OS tools and GUI products built on Slint's `GPL-3.0-only` licence | Apache-2.0 components are allowed. Code under it cannot be combined back into GPL-2.0-only code |
| `AGPL-3.0-or-later` | Products commonly used over a network, such as the web dashboard or a served model | A modified version offered over a network offers its source to its users (Section 13). Not for code that must combine with GPL-2.0-only code |
| `MIT OR Apache-2.0` | Libraries and small tools where the widest reuse is the goal, following the Rust ecosystem's convention | Covers the product's own source. A distributed binary that links a copyleft component carries that component's terms, and the product's register says so |
| Proprietary (gated) | A closed-source product under a licence the licensor writes | A named licensor. No copyleft component in any shipped binary (whether a weak-copyleft library counts is for the research note). No outside contribution without a CLA. No model trained on The Stack v2 |
| `GPL-3.0-or-later` plus a commercial licence (gated, dual) | A product offered openly and also sold | A named licensor. A CLA from every outside contributor, granting the licensor the right to relicense. The commercial licence covers only code the licensor holds or may relicense, so third-party copyleft components stay out of the commercial build |

How a product uses the list: its licence ADR, written through `project-management/workflows/08-decisions/`
when its build starts, names one entry and records which of that entry's conditions it meets, and how.
A licence ADR that picks a gated entry cannot be `Accepted` while the licensor is unnamed.

To move to `Accepted`: `research/PRODUCT-OUTBOUND-LICENCE-COMPATIBILITY.md` confirms the facts the
entries' conditions rest on, and Sam signs off.

This answer changes if a product needs an entry that is not on the list, if the research finds a gated
entry's conditions unworkable, or if the licensor answer rules out the gated entries. Each would be
argued in a new ADR.

## Consequences

- **Positive:** Every product's licence ADR starts from a vetted list instead of a blank page.
  Network-served products have a copyleft that reaches their users, libraries have a permissive entry,
  and the commercial routes stay possible behind stated conditions.
- **Negative:** Seven entries to keep current, two of them unusable until the licensor is named. A
  product under `MIT OR Apache-2.0` that links a GPL-2.0-or-later library still ships a binary under
  GPL terms. The proprietary entry rules out every GPL-licensed component, including Slint's GPL route.
- **Follow-on:**
  - `learning/tooling-05-licensing-and-collaboration/SYLLABUS.md` lesson 05 teaches picking from this
    list and recording the conditions met, with a closed-source desktop tool as a worked case.
  - The capture-library repository records the first pick, GPL-2.0-or-later, in
    `ADR-MS001-CAPTURE-LIBRARY-STANDALONE-27-09-2026.md`. The model-release repository picks the weights'
    licence in its own ADR.
  - `GAPS.md` logs three open questions with this round, each not legal advice: the licensor and
    copyright holder (it blocks the gated entries and any CLA); the trademark policy for the Syntek OS
    name (`research/SYNTEK-OS-TRADEMARK-POLICY.md`, planned, before the first public Syntek OS image);
    and export rules for shipping cryptography (`research/CRYPTOGRAPHY-EXPORT-RULES.md`, planned, before
    any product's first public binary). None of them is decided here.

## Sources

1. **Linux kernel licensing rules** — <https://docs.kernel.org/process/license-rules.html> — the kernel
   as a whole is GPL-2.0-only, checked 27/09/2026
2. **FSF, Various licenses and comments about them** —
   <https://www.gnu.org/licenses/license-list.html> — Apache-2.0, GPLv3, AGPLv3 and LGPLv2.1 entries:
   compatibility, the Section 13 combination and the recommendation for network software. Read through
   the Internet Archive's copy of 27/09/2026,
   <https://web.archive.org/web/20260927045041/https://www.gnu.org/licenses/license-list.html>
3. **FSF, Frequently Asked Questions about the GNU Licenses** —
   <https://www.gnu.org/licenses/gpl-faq.html> → `#AllCompatibility`, `#GPLInProprietarySystem` and
   `#Consider`. Read through the Internet Archive's copy of 27/09/2026,
   <https://web.archive.org/web/20260927055157/https://www.gnu.org/licenses/gpl-faq.html>
4. **crates.io API** — `https://crates.io/api/v1/crates/<name>` for ring (0.17.14) and aws-lc-sys
   (0.45.0), the latest stable versions — their licence expressions, checked 27/09/2026
5. **Software Heritage, statement on large language models for code (19/10/2023)** —
   <https://www.softwareheritage.org/2023/10/19/swh-statement-on-llm-for-code/> — release of a model
   trained on the archive under a suitable open licence, checked 27/09/2026
6. **Choose a License** — <https://choosealicense.com/licenses/> — plain-language summaries of the
   copyleft and permissive entries, including AGPLv3's network-use condition, checked 27/09/2026
7. **Sam's answers in the networking and licensing round, 27/09/2026** — each product picks its
   outbound licence from an approved list; the list holds the open licences and two gated commercial
   entries; the capture-library repository is GPL-2.0-or-later
