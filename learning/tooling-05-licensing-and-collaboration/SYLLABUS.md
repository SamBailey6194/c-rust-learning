# Syllabus — tooling-05-licensing-and-collaboration

**Track**: tooling · **Phase**: P1 · **Path**: Core · **Detail**: full · **Prerequisites**: none (lessons 01–07 before U2 opens and before L4; lesson 08 before a product repository's first release; lesson 06 uses `tooling-04` lesson 05, lesson 07 uses `tooling-04` lessons 04 and 07)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Syntek OS will ship other people's code, friends and family will contribute to its tools, and the
language model will be trained on data and weights that carry terms of their own. This topic
teaches the licence and collaboration literacy each of those needs, anchored in this repository's
own decisions: it is GPL-2.0-only (`LICENSE`), its crate licences are gated by
`code/src/rust/deny.toml`, an Apache-2.0-only crate a lesson needs enters only as a documented
per-crate exception, and each product repository chooses its own licence
(`project-management/src/08-DECISIONS/ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md`, extended by
`ADR-MS001-PRODUCT-LICENCES-INBOUND-RULES-27-09-2026.md`). Lesson 01 comes before `kernel-05`;
lesson 02 before `ui-08` and `llm-14`; lessons 01–07 before U2 opens (the first outside
contributors) and before `llm-10` (training data); lesson 08 before any product's first release. The
lessons teach reading a licence and recording an engineering decision; they are not legal advice.
The FSF's pages on gnu.org timed out from this host on 27/09/2026, so they are cited through the
Internet Archive's copies of 22/09/2026 and 26/09/2026.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Copyleft against permissive, and what GPL-2.0-only requires when binaries are distributed | 1 sitting | no | — |
| 02 | Licence compatibility with GPL-2.0-only, checked by `cargo deny` | 2–3 sittings | yes — exception drill | Security |
| 03 | SPDX identifiers and REUSE | 1 sitting | yes — SPDX headers | — |
| 04 | Licences of datasets and model weights | 1 sitting | no | Security |
| 05 | Choosing a licence for a product repository | 1 sitting | no | — |
| 06 | Contributor infrastructure: CONTRIBUTING, DCO sign-off, labels and required checks | 2–3 sittings | yes — contributor kit | Security |
| 07 | Reviewing a contributor's pull request | 1 sitting | no | Security |
| 08 | Software bills of materials and the component ledger | 2–3 sittings | yes — SBOM drill | Security |

---

## 01 — Copyleft against permissive, and what GPL-2.0-only requires when binaries are distributed

- **Objective:** Sam can explain how a copyleft licence differs from a permissive one, and list what
  GPL-2.0-only obliges when a binary — a kernel image, a Syntek OS image — is handed to someone.
- **Builds on:** this repository's `LICENSE` and Sam's experience publishing public repositories.
- **Key ideas:**
  - A permissive licence (Expat, often called MIT; the modified BSD licence; ISC) lets anyone reuse
    the code, even in a closed product, as long as the notice travels with it; a copyleft licence
    requires a distributed work based on the code to be licensed as a whole on the same terms.
  - The GPL covers copying, distribution and modification; running the program is not restricted
    (Section 0), so obligations start when something is distributed.
  - Verbatim copies keep the notices and a copy of the licence (Section 1); modified files carry
    dated change notices, and the whole distributed work is under the GPL, while mere aggregation on
    one medium does not extend it (Section 2).
  - A binary goes out with the complete corresponding source, or a written offer valid for at least
    three years, or — for noncommercial distribution only — the offer that came with it (Section 3).
  - "Complete source code" includes the scripts used to control compilation and installation, so a
    distributed kernel image brings its build scripts along, not only the patched C.
  - "Only" matters: code licensed "version 2 or any later version" lets the recipient choose a later
    GPL (Section 9), and SPDX spells the two `GPL-2.0-only` and `GPL-2.0-or-later`; the kernel is
    GPL-2.0-only, with a syscall note so programs that merely use system calls are not affected.
- **Recall targets:** for Sam handing a friend a Syntek OS image on a USB stick, list what has to go
  with it; say what distinguishes `GPL-2.0-only` from `GPL-2.0-or-later` and why the kernel's choice
  binds the downstream tree.
- **Build:** none — the output is a note mapping each Section 3 route to a way Syntek OS could be
  released.
- **Sources:** `LICENSE` (the GPL-2.0 text, verbatim) → Sections 0, 1, 2, 3 and 9; SPDX
  `GPL-2.0-only`, <https://spdx.org/licenses/GPL-2.0-only.html>; Linux kernel licensing rules,
  <https://docs.kernel.org/process/license-rules.html>; FSF, "Various Licenses and Comments about
  Them" → Expat, Modified BSD, ISC, GPLv2 (Internet Archive copy of 26/09/2026),
  <https://web.archive.org/web/20260926203802/https://www.gnu.org/licenses/license-list.html>.
- **Done when:** Sam states the three Section 3 routes and what "complete source code" covers for a
  kernel image, unaided, and his note is ready for `kernel-05`'s GPLv2-obligations lesson to cite.

## 02 — Licence compatibility with GPL-2.0-only, checked by `cargo deny`

- **Objective:** Sam can say whether code under Apache-2.0, GPL-3.0 or CDDL can be combined with
  GPL-2.0-only code, read a `cargo deny` licence rejection, and write the per-crate exception this
  repository's rules require.
- **Builds on:** lesson 01.
- **Key ideas:**
  - Two licences are compatible when one combined work can satisfy both at once. The FSF lists
    Apache-2.0 as incompatible with GPLv2 — its patent-termination and indemnification terms are
    requirements GPLv2 does not allow — but compatible with GPLv3; the Apache Software Foundation
    agrees, and notes that the compatibility runs one way.
  - GPLv2 and GPLv3 are not compatible by themselves; code under "GPLv2 or later" can be taken
    under v3 to make a combination, but GPL-2.0-only code cannot.
  - The FSF lists CDDL 1.0 as incompatible with the GPL, so GPL and CDDL modules cannot legally be
    linked — the reason OpenZFS is a hard question for the NAS profile (`os-13`).
  - An SPDX `OR` offers a choice: `MIT OR Apache-2.0` passes this repository's allow-list on its MIT
    side, while `Apache-2.0` alone does not.
  - `cargo deny check licenses` (0.19.0) reports a refused crate as `error[rejected]` with "license
    is not explicitly allowed", and prints the path by which the crate enters the graph (checked on
    27/09/2026 against a scratch crate).
  - The remedies, in order: a compatible alternative; or, where a lesson needs the crate, a
    per-crate `exceptions` entry in `code/src/rust/deny.toml` — never a line in `allow` — citing the
    crate-licence ADR (`ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md` in
    `project-management/src/08-DECISIONS/`). The exception rests on this repository distributing no
    binaries; it does not make the combination GPL-2.0-compatible, so a product repository that ships
    binaries decides afresh (lesson 05).
- **Recall targets:** classify `MIT OR Apache-2.0`, `Apache-2.0`, `GPL-3.0-only` and `CDDL-1.0`
  against the allow-list and say why; explain why an exception names one crate instead of widening
  `allow`.
- **Build:** exception drill — on a throwaway branch, add one Apache-2.0-only crate to a practice
  crate at `code/src/rust/crates/msNNN_<snake>/` (planned: `NNN` from its milestone), run
  `cargo deny check licenses` in `code/src/rust/` and read the rejection, then add a per-crate
  exception citing the ADR and run it again. Checked by: the licence check fails before the entry
  and passes after it, then `code/src/scripts/rust/audit.sh` runs the whole policy and anything else
  it reports is read, not waved through. The branch is deleted afterwards unless an `EX-MS###` spec
  keeps the crate.
- **Security lens:** `cargo add` only edits the manifest, and the next build runs the new crate's
  build script on this machine; run `cargo deny check` straight after adding a crate and before
  building (the header of `code/src/rust/deny.toml` says why).
- **Sources:** FSF licence list → Apache 2.0, GPLv3, CDDL (Internet Archive copy of 26/09/2026),
  <https://web.archive.org/web/20260926203802/https://www.gnu.org/licenses/license-list.html>;
  Apache Software Foundation, "GPL compatibility", <https://www.apache.org/licenses/GPL-compatibility.html>;
  cargo-deny licences configuration (documents the latest release; the host runs 0.19.0, where the
  `exceptions` form was checked), <https://embarkstudios.github.io/cargo-deny/checks/licenses/cfg.html>;
  `code/src/rust/deny.toml`.
- **Done when:** the licence check fails then passes as described, and Sam explains aloud why the
  exception is scoped to one crate and what it leaves undecided.

## 03 — SPDX identifiers and REUSE

- **Objective:** Sam can write a correct SPDX licence expression, place an `SPDX-License-Identifier`
  line in each kind of file, and say what REUSE compliance would add to a repository.
- **Builds on:** lessons 01–02.
- **Key ideas:**
  - An SPDX identifier is the exact short name from the SPDX License List (3.29.0, 16/09/2026); since
    list 3.0 the GNU licences are written `-only` or `-or-later`, and bare `GPL-2.0` is deprecated.
  - Expressions combine identifiers: `OR` offers a choice, `AND` means both apply, `WITH` attaches an
    exception (`GPL-2.0-only WITH Linux-syscall-note`), a trailing `+` means "or later", and
    parentheses set precedence.
  - A file declares its licence with one `SPDX-License-Identifier:` line in a comment near the top;
    the kernel's rules put it on the first line, or the second after a `#!` line, in a comment style
    chosen per file type.
  - REUSE 3.3 asks for copyright and licence information on every covered file — a comment header, a
    `.license` file beside an uncommentable file, or a `REUSE.toml` — and each licence's text in a
    `LICENSES/` folder named by identifier; a root `LICENSE` file is not itself covered.
  - This repository has a root `LICENSE` and `license = "GPL-2.0-only"` in its Cargo workspace, and
    no per-file headers; adopting headers or REUSE across the repository would be an ADR, not a side
    effect of a lesson. The `reuse` linter is not installed on this host (checked 27/09/2026).
- **Recall targets:** write the expression for a crate offered under MIT or Apache-2.0 and for a
  GPL-2.0-only header with the syscall note; say where the identifier goes in a script with a
  shebang; choose and justify a comment style for a `.c` file in this repository, given that the
  kernel uses `//` for the line and this repository's C style prefers `/* */`.
- **Build:** SPDX headers — add a `GPL-2.0-only` identifier line to the lesson's own exercise files
  only (`tooling-03`'s `verify.sh` and the C exercise beside it, `code/src/c/msNNN-<kebab>/`,
  planned), in the comment style each file type needs. Checked by a search that lists no file in
  that folder without the line, by `make` still building it warning-free, and by `reuse lint` if Sam
  installs it.
- **Sources:** SPDX License List 3.29.0, <https://spdx.org/licenses/>; SPDX specification 2.3, Annex D
  (licence expressions), <https://spdx.github.io/spdx-spec/v2.3/SPDX-license-expressions/>; REUSE
  specification 3.3, <https://reuse.software/spec-3.3/>; Linux kernel licensing rules → License
  identifier syntax, <https://docs.kernel.org/process/license-rules.html>.
- **Done when:** Sam writes both expressions correctly unaided, the headers are in place and the
  exercise still passes its gates.

## 04 — Licences of datasets and model weights

- **Objective:** Sam can find and read the licence and terms attached to a dataset or a set of model
  weights, and record what they allow for training, fine-tuning and redistribution.
- **Builds on:** lessons 01–03.
- **Key ideas:**
  - Code, weights and data are three things with three licences: an MIT training script can produce
    weights under a restrictive licence, trained on data whose terms bind again.
  - On Hugging Face the card's metadata carries a `license:` field using the Hub's own lower-case
    identifiers (`apache-2.0`, `cc-by-4.0`, `llama3.1`, `gemma`, `openrail` and others), not SPDX
    expressions; `license: other` points to a `license_name` and a LICENSE file in the repository.
  - Several model licences on that list (the Llama community licences, the Gemma terms, the OpenRAIL
    family) are custom terms, often with use restrictions, and a gated repository adds terms accepted
    by clicking.
  - The OSI's Open Source AI Definition 1.0 asks for the parameters, the code and sufficiently
    detailed data information under OSI-approved terms; "open weights" is a narrower claim.
  - A dataset can aggregate many licences: The Stack v2's terms require honouring each file's
    original licence (attribution included, via the provenance fields), following Software
    Heritage's principles for training, keeping a copy updated as removals are made, and an agreement
    with Software Heritage and INRIA for bulk download.
  - The habit: a ledger row for every model and dataset — source, revision or digest, licence,
    terms, obligations — which `llm-01` and `llm-10` both rely on.
- **Recall targets:** for one model card, name the three licences involved and what the weights'
  licence restricts; explain why "open weights" is not the same claim as open source AI.
- **Build:** none — the output is a licence-ledger table in the lesson note, for one open coding
  model Sam is considering for `llm-01` and for The Stack v2.
- **Security lens:** gated downloads need an access token and may share contact details with the
  publisher; the token stays out of the repository (`llm-10` handles credentials).
- **Sources:** Hugging Face Hub, Licenses, <https://huggingface.co/docs/hub/repositories-licenses>;
  Model Cards, <https://huggingface.co/docs/hub/model-cards>; Dataset Cards,
  <https://huggingface.co/docs/hub/datasets-cards>; The Stack v2 dataset card → Terms of Use and the
  `license_type` field, <https://huggingface.co/datasets/bigcode/the-stack-v2>; OSI, The Open Source
  AI Definition 1.0, <https://opensource.org/ai/open-source-ai-definition>; Creative Commons
  Attribution 4.0 legal code, <https://creativecommons.org/licenses/by/4.0/legalcode.en>.
- **Done when:** both ledger rows are complete, and each obligation in them is traced to a line of
  the card or the terms.

## 05 — Choosing a licence for a product repository

- **Objective:** Sam can choose and justify a licence for a new product repository from its
  dependency graph, its distribution plan and what contributors expect, and record the choice as an
  ADR.
- **Builds on:** lessons 01–04.
- **Key ideas:**
  - Licences are per repository: this learning repository stays GPL-2.0-only, and each product
    repository — named and licensed by Sam when its build starts — chooses its own, recorded as an
    ADR, one decision per record, from the approved list and under the inbound rules
    (`ADR-MS001-PRODUCT-LICENCES-APPROVED-OUTBOUND-LIST-27-09-2026.md`,
    `ADR-MS001-PRODUCT-LICENCES-INBOUND-RULES-27-09-2026.md`).
  - Some choices are forced: a downstream kernel tree carries the kernel's GPL-2.0-only.
  - The dependency graph narrows the rest: a repository that links Apache-2.0-only crates and ships
    binaries cannot be GPL-2.0-only, but can be GPL-3.0-or-later or permissive (lesson 02).
  - A closed-source product is possible only through the list's gated proprietary entry and its
    conditions: a named licensor, no copyleft component in any shipped binary, no outside
    contribution without a CLA, and no model trained on The Stack v2.
  - The goal decides between what survives: copyleft keeps contributors' improvements open, a
    permissive licence maximises reuse, closed reuse included.
  - Two viewpoints to weigh: the FSF recommends copyleft for most software and the Apache License
    2.0 for small programs, taking 300 lines as its benchmark; choosealicense.com starts from "use
    your community's licence", "simple and permissive" or "sharing improvements".
  - Syntek OS's own products are written with Slint in their own repositories, where Slint's licence
    options are checked — not here; weights and datasets are licensed separately (lesson 04).
- **Recall targets:** for a downstream kernel tree, a Rust TUI file manager, an LLM inference
  server and a closed-source desktop tool, name the constraint that dominates each licence choice
  and where it comes from.
- **Build:** none — the output is a draft ADR, written through `project-management/workflows/08-decisions/`
  from `project-management/src/08-DECISIONS/ADR-MS000-TEMPLATE.md` when the first product repository
  (the file manager's, when `ui-04`'s build starts) is created. It starts from the approved list,
  names one entry and records which of that entry's conditions the repository meets, and how.
- **Sources:** FSF, "How to Choose a License for Your Own Work" (Internet Archive copy of
  22/09/2026), <https://web.archive.org/web/20260922042447/http://www.gnu.org/licenses/license-recommendations.html>;
  Choose a License, <https://choosealicense.com/>; FSF licence list (Internet Archive copy of
  26/09/2026), <https://web.archive.org/web/20260926203802/https://www.gnu.org/licenses/license-list.html>;
  Linux kernel licensing rules, <https://docs.kernel.org/process/license-rules.html>.
- **Done when:** Sam writes one paragraph per hypothetical repository, each naming its dominant
  constraint and the source behind it.

## 06 — Contributor infrastructure: CONTRIBUTING, DCO sign-off, labels and required checks

- **Objective:** Sam can set a repository up so a friend can contribute: guidelines they will see,
  a sign-off rule, labels that lead newcomers to starter issues, and checks that must pass before a
  merge.
- **Builds on:** lessons 01 and 05; `tooling-04` lesson 05 (sign-off and the DCO).
- **Key ideas:**
  - GitHub links a CONTRIBUTING file from `.github/`, the root or `docs/` (in that order of
    precedence) when someone opens an issue or a pull request; this repository's `CONTRIBUTING.md`
    is the worked example of a learning repository's version.
  - A repository that takes outside work states the licence contributions are accepted under, and can
    require a DCO sign-off on every commit, enforced by a CI check that fails without one.
  - A DCO sign-off certifies the contributor's right to submit the work; it grants no licence and no
    right to relicense. A product whose list entry needs relicensing rights uses a CLA instead, argued
    in its licence ADR and only once the licensor is named (inbound rules, rule 2).
  - GitHub's default labels include `good first issue`, which also fills the repository's contribute
    page, and `help wanted`.
  - Branch protection can require status checks before merging; a required check must never also be
    path-filtered, and is matched by its job name, copied from a finished run.
  - Required approving reviews need more than one maintainer, because a pull request's author cannot
    approve it.
  - A pull request from a fork runs CI without the repository's secrets and with a read-only token, a
    first-time contributor's run can wait for a maintainer's approval, and checking out a fork's code
    under `pull_request_target` can hand it write access or secrets, so it is avoided.
- **Recall targets:** explain how a path-filtered required check leaves a pull request pending for
  ever; say what a DCO sign-off gives a maintainer that a sentence in CONTRIBUTING does not, and what
  it does not grant.
- **Build:** contributor kit — lands in the Syntek OS file-manager repository (created when `ui-04`'s build
  starts, the first project friends and family can join; its name and licence are Sam's to choose):
  a CONTRIBUTING file stating the licence of contributions, a sign-off check in CI, the label set,
  and branch protection requiring the CI checks. Checked by a practice pull request that cannot merge
  while unsigned or red, and can once signed off and green. Until that repository exists, the lesson
  reads this repository's own `CONTRIBUTING.md`, `.github/PULL_REQUEST_TEMPLATE.md` and CI.
- **Security lens:** CI runs contributors' code; secrets stay out of fork-triggered runs, and a
  maintainer reads a first-time contributor's changes before approving their workflow run.
- **Sources:** GitHub Docs, "Setting guidelines for repository contributors",
  <https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/setting-guidelines-for-repository-contributors>;
  "Managing labels", <https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels>;
  "About protected branches", <https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches>;
  "Events that trigger workflows" → `pull_request`, `pull_request_target`,
  <https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows>;
  "Approving workflow runs from forks", <https://docs.github.com/en/actions/how-tos/manage-workflow-runs/approve-runs-from-forks>;
  Developer Certificate of Origin 1.1, <https://developercertificate.org/>;
  `project-management/docs/git/PR-AND-CHECKS.md` → Required checks and path filters.
- **Done when:** Sam explains each setting in the kit and the failure it prevents, and — once the
  Syntek OS file-manager repository exists — the practice pull request behaves as stated.

## 07 — Reviewing a contributor's pull request

- **Objective:** Sam can review a friend's pull request in the repository's tutor style: check it out
  locally, run the gates, check licence and sign-off, and write comments that explain why.
- **Builds on:** lesson 06; `tooling-04` lessons 04 (range-diff) and 07 (worktrees).
- **Key ideas:**
  - Approve a change once it definitely improves the health of the code, even if it is not perfect;
    mark optional polish `Nit:` so the author knows it is optional.
  - Check the branch out locally (`gh pr checkout`, into a worktree) and run the gates yourself
    rather than relying on a green tick alone.
  - Before approving: the sign-off is present, any new dependency passes `cargo deny`, no code of
    unknown origin or licence has been pasted in, and changes to CI files or scripts get the closest
    reading, because they change what runs.
  - Write each comment as a pointer and a question — the reason, and the guide section that holds
    the rule — the way `code/workflows/05-review/` reviews Sam's own code.
  - GitHub offers comment, approve and request changes; after the author pushes a new version,
    `git range-diff` shows what changed between the two.
- **Recall targets:** list what is checked before approving and why each matters; explain what
  `Nit:` signals and when a reviewer should approve despite open nits.
- **Build:** none — a practice review of a pull request Sam opens against a throwaway repository of
  his own, or against the Syntek OS file-manager repository once it exists.
- **Security lens:** a pull request can change CI and scripts, and so what runs with the
  repository's permissions; read those files first.
- **Sources:** Google Engineering Practices, "The Standard of Code Review",
  <https://google.github.io/eng-practices/review/reviewer/standard.html>, and "How to write code
  review comments", <https://google.github.io/eng-practices/review/reviewer/comments.html>; GitHub
  Docs, "About pull request reviews",
  <https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/about-pull-request-reviews>;
  GitHub CLI manual, `gh pr checkout`, <https://cli.github.com/manual/gh_pr_checkout>, and
  `gh pr review`, <https://cli.github.com/manual/gh_pr_review>.
- **Done when:** Sam's practice review covers every check above, each comment gives its reason, and
  a second version of the pull request is compared with `git range-diff` before approval.

## 08 — Software bills of materials and the component ledger

- **Objective:** Sam can say what an SBOM records and what it does not, write a minimal SPDX document
  that matches a crate graph, compare SPDX with CycloneDX, and extend lesson 04's ledger to data,
  weights and firmware.
- **Builds on:** lessons 02–05.
- **Key ideas:**
  - A release's inventory lists each component with its version, supplier, package URL (purl), hash,
    licence expression and its relationships to the others.
  - An SBOM records obligations; it does not meet them — a GPL source offer still has to be made.
  - SPDX 2.3 against the 3.0 profiles (among them AI and Dataset), and CycloneDX as the other format.
  - A declared licence is what the supplier states; a concluded licence is what the SBOM's author
    found; `NOASSERTION` records that nothing was concluded.
  - An SBOM is generated, never typed: `cargo metadata` and `cargo deny list` read the real graph.
  - REUSE describes a source tree; an SBOM describes a released artefact. This repository publishes
    none (`project-management/src/08-DECISIONS/ADR-MS001-PRODUCT-COMPONENT-REGISTER-SPDX-SBOM-27-09-2026.md`).
- **Recall targets:** name the fields an SBOM entry carries and which of them a generator cannot fill;
  explain why a ledger row is still needed for data, weights and firmware; say why this repository
  keeps no register.
- **Build:** SBOM drill — on lesson 02's throwaway branch, run `cargo deny list --format json` in
  `code/src/rust/`, write a minimal SPDX JSON document for the practice crate by hand, validate it with
  the validator the SBOM research note chooses (planned — `research/SBOM-FORMATS-AND-GENERATORS.md`),
  then diff it against a generated one. The generator half is **Blocked** (`GAPS.md` → "No SBOM
  generator or REUSE linter installed"). Checked by: the validator passes, every crate `cargo tree`
  lists appears once, and a planted missing licence fails.
- **Security lens:** a release's SBOM is what `os-16` lesson 01's advisory matcher reads, so a
  component missing from it is a vulnerability nobody is told about.
- **Sources:** the SPDX specifications (2.3 and 3.0.x, pinned by the research note),
  <https://spdx.dev/use/specifications/>; CycloneDX specification overview,
  <https://cyclonedx.org/specification/overview/>; NTIA, "The Minimum Elements for a Software Bill of
  Materials (SBOM)" (12/07/2021), <https://www.ntia.gov/report/2021/minimum-elements-software-bill-materials-sbom>;
  REUSE specification 3.3, <https://reuse.software/spec-3.3/>; `cargo deny list --help` (0.19.0).
- **Done when:** the hand-written document validates and matches the graph, and Sam explains which
  parts of the register are generated and which are kept by hand.
