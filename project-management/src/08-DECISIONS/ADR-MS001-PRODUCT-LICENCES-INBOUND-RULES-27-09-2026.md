# ADR-MS001: Product repository licences — inbound rules for components, contributions, code and data

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-PRODUCT-LICENCES-INBOUND-RULES |
| **Status** | Proposed |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — (extends `ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md` → Decision, second paragraph, and `ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md` → Decision, rule 3, and changes none of their rules) |
| **Superseded by** | — |
| **Research** | `research/PRODUCT-CONTRIBUTIONS-DCO-AND-CLA.md` (planned) — what DCO 1.1 certifies and does not grant, inbound = outbound, the forms a CLA takes and what it needs from a licensor, and DCO enforcement on GitHub; this record stays `Proposed` until the note exists |
| **Enforced in** | each product repository's `deny.toml` (or the equivalent licence check for another ecosystem), its `CONTRIBUTING` file and its licence ADR · routed from `.claude/skills/teach/FAMILIES.md` → Where a lesson's build lands |

---

## Context

This record answers Sam's question of 27/09/2026 about the licence rules for the product
repositories. His answer was to fix only the inbound rules now, and to let each product repository
pick its outbound licence from an approved list when its build starts. It also records his answer the
same day about outside contributions to those repositories. The approved list is a separate record,
`ADR-MS001-PRODUCT-LICENCES-APPROVED-OUTBOUND-LIST-27-09-2026.md`, because it can be reversed without
touching these rules.

This is an engineering record of how licences are handled here. It is not legal advice.

What stands today:

- **This repository's licence exceptions rest on distributing nothing.** The crate ADR admits
  Apache-2.0-only crates by per-crate exception because this repository distributes no binaries, so
  the incompatibility the FSF describes, which arises on distribution, does not arise here
  (`ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md` → Decision). Product repositories exist to
  distribute kernel images, Syntek OS images and packages, tool binaries and model releases, so that
  argument is not available to them.
- **The product rule is procedural only.** The crate ADR says product repositories choose their own
  licences and that `tooling-05-licensing-and-collaboration` teaches how. The tracks ADR's rule 3 says
  their names and licences are Sam's to choose
  (`ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md` → Decision). Neither says what a product
  may take in. The Section 5 rule in `.claude/CLAUDE.md` (GPL-2.0-compatible dependencies, or a
  documented exception) binds this repository only.
- **Contributions here** are accepted under GPL-2.0-only. A `Signed-off-by:` trailer in the Developer
  Certificate of Origin style is welcome but optional (`CONTRIBUTING.md` → Pull requests).
- **Sam's scope for the round** was a licence policy for the product repositories he means to
  commercialise. That is stated intent: no product repository exists yet, and no outbound licence has
  been chosen.
- **The licensor is unnamed.** Whether Sam personally or an organisation holds the copyright in the
  product repositories is an open question, logged in `GAPS.md` in this round.

Facts that force or narrow the choice, checked on 27/09/2026:

- **The kernel is GPL-2.0-only** as a whole. Its user-space API headers carry the Linux-syscall-note,
  so programs that only use system calls are not bound (Sources, item 1). A downstream kernel tree
  therefore has no licence choice to make.
- **Apache-2.0 is compatible with GPLv3 but not with GPLv2**, because of its patent-termination and
  indemnification terms. GPLv3 is not compatible with GPLv2 by itself, but code under "GPLv2 or later"
  may be taken under GPLv3 to make a combination (Sources, item 2).
- **Relicensing needs every author.** A project that took contributions under the GPL needs each
  contributor's permission before it releases their code under another licence. A copyright holder
  may license its own code under several licences in parallel (Sources, item 3).
- **DCO 1.1 grants no licence.** A sign-off certifies that the contributor has the right to submit the
  work under the licence the project indicates, and accepts that the contribution and the sign-off are
  kept on public record. The licence itself comes from elsewhere (Sources, item 4), so a sign-off gives
  a maintainer no right to relicense.
- **Slint**, the toolkit of the Syntek OS GUI products, is offered as `GPL-3.0-only OR
  LicenseRef-Slint-Royalty-free-2.0 OR LicenseRef-Slint-Software-3.0`, and its royalty-free terms
  exclude embedded systems (`ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md` → Context, checked there on
  27/09/2026).
- **The Stack v2 binds the model trained on it.** Its terms bind anyone training on it to Software
  Heritage's principles, the first of which is that the resulting model is released under a suitable
  open licence (Sources, item 5). The Stack v3 is ODC-By 1.0 and has no such clause. Both keep each
  file's original licence and its attribution duty
  (`learning/llm-10-data-pipeline-and-licensing/SYLLABUS.md` → lesson 02).

Clash check (`project-management/workflows/08-decisions/` Step 3), 27/09/2026:

- **Crate licences** — extended, not contradicted. Its exceptions and its GPL-2.0-only rule for this
  repository stand. Its "distributes nothing" argument is simply not carried into products (rule 1).
- **Roadmap tracks, rule 3** — extended. Sam still names each repository and picks its licence; this
  record sets the rules that pick is made under.
- **GUI toolkit** — the Slint route stays open. `GPL-3.0-only` Slint combines under a GPL-3.0-or-later
  entry, and the royalty-free route, a `LicenseRef` with a field-of-use limit, enters by a
  per-component exception ADR under rule 1. The GUI ADR's reopening trigger, a product licence that
  makes Slint unusable, is not tripped.
- **Remote-help tool** (`ADR-MS001-REMOTE-HELP-TOOL-CONSENT-FIRST-27-09-2026.md`, `Proposed` in the same
  round) — both production rustls crypto providers carry Apache-2.0 terms: ring 0.17.14 is
  `Apache-2.0 AND ISC`, and aws-lc-sys 0.45.0 includes `AND Apache-2.0` (Sources, item 6). Either fits
  a GPL-3.0-or-later or permissive entry, never GPL-2.0-only. `research/RUST-MTLS-STACK-LICENCES.md`
  (planned) confirms which.
- **Graduation path** (`ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`) — consistent. The
  private infrastructure repository is never published and carries no licence, so these rules do not
  reach it.

## Options considered

### Option A — Fix a proprietary model now

- **Summary:** Decide today that every product is closed source, licensed by a named licensor.
- **Pros:** One answer for every product, serving the commercial intent directly.
- **Cons:** No licensor is named, so nobody could grant the licence. The kernel tree is forced to
  GPL-2.0-only, Slint's royalty-free terms exclude embedded targets such as the router, and a model
  trained on The Stack v2 must be openly licensed. Every contribution would need an agreement before
  any product exists.

### Option B — Dual licensing, with a CLA everywhere

- **Summary:** Every product is offered under the GPL and a commercial licence, and every contributor
  signs a contributor licence agreement (CLA) that grants relicensing rights.
- **Pros:** Both the open and the commercial route stay available for every product, and relicensing
  is always possible.
- **Cons:** A CLA needs a named licensor to grant rights to. It puts a legal agreement in front of
  friends and family before their first pull request, and products that will never be sold pay that
  cost too. The kernel tree still cannot be dual-licensed.

### Option C — Inbound rules only; each product picks its outbound licence from an approved list

- **Summary:** Fix now what may enter a product (components, contributions, code from this
  repository, data and weights), and let each product pick from a list of vetted outbound licences
  when its build starts.
- **Pros:** Every later pick is made under rules argued once. No licence is chosen before the
  product's dependency graph and distribution plan exist, which is the method `tooling-05` lesson 05
  teaches. The commercial routes stay open without being forced.
- **Cons:** Each product repository still writes its own licence ADR, and the list's gated entries
  wait on the open licensor question.

### Option D — Keep the status quo

- **Summary:** Products choose freely when their builds start, as the crate and tracks ADRs say today.
- **Pros:** No work now.
- **Cons:** Nothing stops a product taking in a component, dataset or contribution that rules out the
  licence it wants later. A contribution accepted under a DCO sign-off today cannot be relicensed
  tomorrow without its author.

## Decision

**We will take Option C** (Sam's answer of 27/09/2026 on product licences). The deciding factor is
that what enters a product is what later limits its licence, and an intake cannot be undone, while the
outbound pick can wait for the product's dependency graph and distribution plan. Option B was the
runner-up, because it keeps every route open. It lost because a CLA needs a licensor who is not yet
named, and because it puts a legal agreement in front of family contributors for products that may
never be sold.

The rules, which bind every product repository from its creation:

1. **Components.** Every dependency, vendored file or linked library is compatible with the product's
   outbound entry. That repository's own `deny.toml`, or an equivalent licence check over its lockfile
   for another ecosystem, checks this in CI. A licence that is unknown, `NOASSERTION`,
   source-available, non-commercial or restricted by field of use enters only by a per-component
   exception ADR in that repository. The "distributes nothing" argument behind this repository's crate
   exceptions is not available there.
2. **Contributions.** Outside contributions come in under the product's own licence (inbound =
   outbound), with a DCO 1.1 sign-off on every commit, enforced by a CI check (Sam's answer of
   27/09/2026 on outside contributions). A CLA is used only where the product's list entry needs
   relicensing rights. That need is argued in the product's licence ADR, and a CLA is adopted only once
   the licensor is named.
3. **Code leaving this repository** keeps GPL-2.0-only in its new home unless every author of it agrees
   to the new licence. Sam may relicense code he wrote himself; code a contributor gave under
   `CONTRIBUTING.md` needs that contributor's agreement.
4. **Data and weights** enter a product only with a ledger row
   (`ADR-MS001-PRODUCT-COMPONENT-REGISTER-SPDX-SBOM-27-09-2026.md`), and their terms narrow the outbound
   pick: a model trained on The Stack v2 must be openly licensed. A custom, use-restricted model licence
   needs a per-item exception ADR. Whether The Stack v2 or v3 is used stays with `llm-10` lesson 02.

To move to `Accepted`: `research/PRODUCT-CONTRIBUTIONS-DCO-AND-CLA.md` confirms what rule 2 relies on
(what a DCO sign-off does and does not give a maintainer, and what a CLA needs from a licensor), and
Sam signs off.

This answer changes if this repository starts distributing binaries, images or packages (the crate
ADR's own trigger), if the licensor answer changes the CLA route, or if the research shows that a DCO
sign-off does not give what rule 2 relies on. Each would be argued in a new ADR.

## Consequences

- **Positive:** Every product starts under intake rules argued once, so no component, dataset or
  contribution quietly rules out the licence it picks later. Family contributors sign off rather than
  sign an agreement, unless a product's distribution plan truly needs relicensing rights.
- **Negative:** Each product repository carries its own licence check, sign-off check and licence ADR,
  and every non-standard licence costs an exception ADR there. The CLA route stays closed until the
  licensor is named.
- **Follow-on:**
  - `project-management/src/08-DECISIONS/CONTEXT.md` carries the back-links from the two extended
    records, in its tree comments and its round table. The Accepted records themselves are not edited
    (Sam's answer of 27/09/2026 on how an extended record points to its extension).
  - `.claude/skills/teach/FAMILIES.md` routes product licences to this record, and
    `learning/tooling-05-licensing-and-collaboration/SYLLABUS.md` lessons 05 and 06 teach the pick and
    the contribution rules, including what a DCO sign-off does not grant.
  - `GAPS.md` logs the open licensor question, which blocks only the CLA route and the gated entries of
    the approved list.
  - Each product repository's first licence ADR, written through `project-management/workflows/08-decisions/`
    when its build starts, applies rules 1 to 4.

## Sources

1. **Linux kernel licensing rules** — <https://docs.kernel.org/process/license-rules.html> — the kernel
   as a whole is GPL-2.0-only; the Linux-syscall-note keeps programs that only use the syscall
   interface outside its terms, checked 27/09/2026
2. **FSF, Various licenses and comments about them** —
   <https://www.gnu.org/licenses/license-list.html> — Apache-2.0 compatible with GPLv3 only; GPLv3 not
   compatible with GPLv2 by itself; "GPLv2 or later" code usable under GPLv3. Read through the Internet
   Archive's copy of 27/09/2026,
   <https://web.archive.org/web/20260927045041/https://www.gnu.org/licenses/license-list.html>
3. **FSF, Frequently Asked Questions about the GNU Licenses** —
   <https://www.gnu.org/licenses/gpl-faq.html> → `#Consider` (relicensing a contributor's code needs
   their permission) and `#ReleaseUnderGPLAndNF` (a copyright holder may license its code in
   parallel). Read through the Internet Archive's copy of 27/09/2026,
   <https://web.archive.org/web/20260927055157/https://www.gnu.org/licenses/gpl-faq.html>
4. **Developer Certificate of Origin, version 1.1** — <https://developercertificate.org/> — what a
   sign-off certifies, and that the certificate itself grants no licence, checked 27/09/2026
5. **Software Heritage, statement on large language models for code (19/10/2023)** —
   <https://www.softwareheritage.org/2023/10/19/swh-statement-on-llm-for-code/> — the three principles,
   the first being release of the resulting model under a suitable open licence, checked 27/09/2026
6. **crates.io API** — `https://crates.io/api/v1/crates/<name>` for ring (0.17.14) and aws-lc-sys
   (0.45.0), the latest stable versions — their licence expressions, checked 27/09/2026
7. **Sam's answers in the networking and licensing round, 27/09/2026** — fix the inbound rules only and
   pick outbound licences from an approved list per product; a DCO sign-off by default and a CLA only
   where relicensing rights are needed and a licensor is named; the commercial intent, stated as intent
