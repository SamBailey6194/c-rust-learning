# References — project-management/ layer

**Last Updated**: 28/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Internal and external references for planning the curriculum, proving mastery, and moving work through
git. Internal tables list what exists in this layer; external entries follow the form
**Name** — URL — how it is used here. Every URL was checked to respond on 27/09/2026.

---

## Internal — Guides

Every guide in `project-management/docs/`, with its purpose.

| File | Purpose |
| --- | --- |
| `project-management/docs/PLANNING-GUIDE.md` | Thin index over `planning/`: the loop, milestones, sprints |
| `project-management/docs/planning/CADENCE.md` | One milestone at a time through verification; sprint length, capacity (13) and grace (16) |
| `project-management/docs/planning/MILESTONES.md` | Milestone format, Gherkin mastery criteria, the FLAGS table, MoSCoW, Fibonacci points, **the status vocabulary** |
| `project-management/docs/planning/SPRINTS.md` | The sprint record, sprint statuses, admission, the backlog register, the Retrospective |
| `project-management/docs/GIT-GUIDE.md` | Thin index over `git/`: branches, commits, pull requests |
| `project-management/docs/git/BRANCHES.md` | `main` plus `ms###/`, `pm/`, `docs/`, `ci/` branches; lifecycle; what may go straight to `main` |
| `project-management/docs/git/COMMITS.md` | Staging by explicit path, pre-commit gates, Conventional Commits types and scopes, trailers |
| `project-management/docs/git/PR-AND-CHECKS.md` | The pull request and its template, the six CI checks, required checks versus path filters, merging |
| `project-management/docs/VERIFICATION-GUIDE.md` | The commands that prove each flag, what clean output looks like, the verification record |
| `project-management/docs/SAFETY-GUIDE.md` | C UB and memory-bug classes, the Rust `unsafe` policy, the kernel QEMU-only rule and why |

---

## Internal — Live Artefacts

Each numbered folder in `project-management/src/`, its tier, and what it holds. The folder's own
`CLAUDE.md` owns its filename pattern.

| Path | Tier | Contents |
| --- | --- | --- |
| `project-management/src/01-ROADMAP/` | plan | `ROADMAP.md` (owns the eighteen phases in six tracks and the "You are here" marker); the five track maps; `MAP-000-TEMPLATE.md` |
| `project-management/src/02-MILESTONES/` | plan | One file per milestone; `MS000-TEMPLATE.md`; `MS001-TOOLCHAIN-READY.md` seeded |
| `project-management/src/03-STUDY-SPRINTS/` | plan | One record per two-week study sprint; `SPRINT-00-TEMPLATE.md` |
| `project-management/src/04-EXERCISES/` | specify | Exercise-set specs per milestone, no solutions; `EX-MS000-TEMPLATE.md` |
| `project-management/src/05-PROJECTS/` | specify | Capstone project specs; `PROJ-MS000-TEMPLATE.md` |
| `project-management/src/06-KERNEL/` | specify | Kernel plans before a build and implementation records after; `KERNEL-PLAN-MS000-TEMPLATE.md`, `KERNEL-IMPL-MS000-TEMPLATE.md` |
| `project-management/src/07-OS-PROFILES/` | specify | `PROFILE-MATRIX.md`, the seven `PROFILE-<NAME>.md` files (beginner, intermediate, expert, server, nas, homelab, router); `PROFILE-000-TEMPLATE.md` |
| `project-management/src/08-DECISIONS/` | decide & plan | Immutable ADRs; `ADR-MS000-TEMPLATE.md` and the five seed ADRs from MS001 |
| `project-management/src/09-MILESTONE-PLANS/` | decide & plan | The plan each milestone is studied from, prefixed by build order; `00-PLAN-MS000-TEMPLATE.md` |
| `project-management/src/10-PROGRESS/` | record | Verification records, the mastery evidence; `MS000-VERIFICATION-TEMPLATE.md` |
| `project-management/src/11-REVIEWS/` | record | Review records; `REVIEW-MS000-TEMPLATE.md` |
| `project-management/src/12-FINDINGS/` | record | Misconceptions corrected, lessons carried forward; `FINDING-MS000-TEMPLATE.md` |
| `project-management/src/13-BUGS/` | record | Defects with reproduction, root cause and regression test; `BUG-MS000-TEMPLATE.md` |

---

## Internal — Workflows

| Workflow path | Purpose |
| --- | --- |
| `project-management/workflows/01-roadmap-map/CONTEXT.md` | Chart a phase's decision frontier once; cut it into milestone slices |
| `project-management/workflows/02-milestone-creation/CONTEXT.md` | Write one milestone with Gherkin mastery criteria, flags and an estimate |
| `project-management/workflows/03-sprint-planning/CONTEXT.md` | Open a study sprint and admit milestones against capacity |
| `project-management/workflows/04-exercise-design/CONTEXT.md` | Specify a milestone's exercise set, tests before solutions |
| `project-management/workflows/05-project-spec/CONTEXT.md` | Specify a capstone project and slice it across milestones |
| `project-management/workflows/06-kernel-spec/CONTEXT.md` | Plan a kernel build or module for QEMU, then record what was built |
| `project-management/workflows/07-os-profile-spec/CONTEXT.md` | Specify a Syntek OS profile as axis values and QEMU-testable hypotheses |
| `project-management/workflows/08-decisions/CONTEXT.md` | Record hard-to-reverse choices as ADRs; check the set still holds |
| `project-management/workflows/09-milestone-plans/CONTEXT.md` | Write the plan the milestone is studied from |
| `project-management/workflows/10-study-and-build/CONTEXT.md` | Learn with `/teach`, then build the exercises test-first |
| `project-management/workflows/11-verification/CONTEXT.md` | Run the mastery commands and write the verification record |
| `project-management/workflows/12-review-and-reflect/CONTEXT.md` | Review the code, record findings, write the sprint Retrospective |
| `project-management/workflows/13-pr-and-merge/CONTEXT.md` | Pull request, every CI check green, merge, milestone `Completed` |

> **Where the numbers diverge.** Workflow numbers mirror the `src/` folder numbers through the
> decide-and-plan tier: workflows `01`–`09` write into folders `01`–`09` of `project-management/src/`.
> From `10` they diverge, because the record folders are numbered for what they hold, not for the
> workflow that writes them. `10-study-and-build` has no `src/` folder of its own; it writes to
> `learning/` and `code/src/`. `11-verification` writes `project-management/src/10-PROGRESS/`;
> `12-review-and-reflect` writes `project-management/src/11-REVIEWS/` and
> `project-management/src/12-FINDINGS/`; `13-pr-and-merge` writes to git and GitHub; and
> `project-management/src/13-BUGS/` is written by `code/workflows/07-debug/`, outside this layer. The
> full workflow ↔ folder ↔ pairing table is owned by the root `REFERENCES.md`; this note is the only
> place the divergence is explained.

---

## Internal — Cross-layer guides this layer cites

| File | Why this layer cites it |
| --- | --- |
| `code/docs/BUILD.md` | Owns the make targets and compiler flags every mastery criterion names |
| `code/docs/TESTING.md` | The `check.h` harness and the Rust test layout behind the Tests flag |
| `code/docs/MEMORY-SAFETY.md` | The memory-bug classes behind the Memory flag |
| `code/docs/RUST-CODING-PRINCIPLES.md` | The `unsafe` policy the safety guide routes to |
| `code/docs/DOCUMENTATION-LENGTH.md` | The 300-line cap on every instructional file here |
| `how-to/workflows/03-quality-gates/` | Owns the gate commands commits and verification run |
| `.claude/CLAUDE.md` | Owns the kernel QEMU-only rule and the public-repository rules |

---

## External — Planning & Estimation

- **MoSCoW prioritisation** — https://www.agilebusiness.org/dsdm-project-framework/moscow-prioritisation.html — Must / Should / Could / Won't, applied to each milestone's priority within its sprint (`project-management/docs/planning/MILESTONES.md`)
- **Story points (Fibonacci)** — https://www.mountaingoatsoftware.com/blog/what-are-story-points — relative sizing on 1, 2, 3, 5, 8, 13, 21; 8 is the largest milestone, 13 or more back to the map
- **User stories (Connextra form)** — https://www.agilealliance.org/glossary/user-stories/ — the shape behind each milestone's "As a learner, I want to [skill], so that [what it unlocks]" line
- **Gherkin reference** — https://cucumber.io/docs/gherkin/reference/ — the Given / When / Then syntax of every milestone's mastery criteria
- **Definition of Done** — https://www.agilealliance.org/glossary/definition-of-done/ — the idea behind every checklist's closing section

---

## External — Decisions

- **Documenting Architecture Decisions (Michael Nygard)** — https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions — the original ADR form (Context, Decision, Status, Consequences) that `project-management/src/08-DECISIONS/` extends with Options considered
- **RFC 5280, X.509 certificate and CRL profile** — https://www.rfc-editor.org/rfc/rfc5280 — basic and name constraints, CRLs and path validation, behind the private-CA ADR
- **RFC 8555, ACME** — https://www.rfc-editor.org/rfc/rfc8555 — automated certificate issuance, the protocol the private CA's leaf issuer speaks
- **SPDX specifications** — https://spdx.dev/use/specifications/ — the SBOM format (2.3 and 3.0.x, ISO/IEC 5962:2021) behind the component-register ADR
- **CycloneDX** — https://cyclonedx.org/specification/overview/ — the other SBOM format (ECMA-424), the component-register ADR's runner-up
- **NTIA, The Minimum Elements for an SBOM (12/07/2021)** — https://www.ntia.gov/report/2021/minimum-elements-software-bill-materials-sbom — the baseline field list the register's research note re-reads
- **Choose a License** — https://choosealicense.com/licenses/ — plain-language summaries of the entries on the approved outbound list
- **Computer Misuse Act 1990, section 3A** — https://www.legislation.gov.uk/ukpga/1990/18/section/3A — making, supplying or obtaining articles for use in an offence; the statute text behind the remote-help ADR
- **CPS legal guidance, Computer Misuse Act** — https://www.cps.gov.uk/legal-guidance/computer-misuse-act — the factors prosecutors weigh for a dual-use article, cited by the remote-help ADR
- **UK GDPR, Article 2** — https://www.legislation.gov.uk/eur/2016/679/article/2 — the purely personal or household activity exclusion, paragraph 2(a), which the remote-help session-records note tests
- **GitHub Acceptable Use Policies: Active Malware or Exploits** — https://docs.github.com/en/site-policy/acceptable-use-policies/github-active-malware-or-exploits — what GitHub allows of dual-use content, before the remote-help repository is published
- **MITRE ATT&CK T1219, Remote Access Tools** — https://attack.mitre.org/techniques/T1219/ — the abuse of remote-access software the remote-help ADR's constraints refuse

---

## External — Version Control & CI

- **Conventional Commits 1.0** — https://www.conventionalcommits.org/en/v1.0.0/ — the commit message format in `project-management/docs/git/COMMITS.md`
- **git interpret-trailers** — https://git-scm.com/docs/git-interpret-trailers — why `Refs:`, `Signed-off-by:` and `Co-Authored-By:` go in the final block of the message
- **Developer Certificate of Origin** — https://developercertificate.org/ — what an optional `Signed-off-by:` certifies
- **Linux kernel: Submitting patches** — https://docs.kernel.org/process/submitting-patches.html — the kernel's sign-off rule, practised early from P4
- **GitHub: commits with multiple authors** — https://docs.github.com/en/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/creating-a-commit-with-multiple-authors — how the co-author trailer is credited
- **GitHub: troubleshooting required status checks** — https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/troubleshooting-required-status-checks — the path-filter trap in `project-management/docs/git/PR-AND-CHECKS.md`
- **GitHub Actions workflow syntax** — https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax — triggers, path filters and job names for the six checks
- **Semantic Versioning** — https://semver.org/ — **not used.** Nothing here is released, so there is no version number to bump; the `**Version**: 0.1.0` on guides is document metadata, not a release

---

## External — Verification & Safety

- **GCC instrumentation options** — https://gcc.gnu.org/onlinedocs/gcc/Instrumentation-Options.html — `-fsanitize=address,undefined` and `-fno-sanitize-recover`, behind `make san`
- **GCC static analyser options** — https://gcc.gnu.org/onlinedocs/gcc/Static-Analyzer-Options.html — `-fanalyzer` and its `-Wanalyzer-*` warnings, behind `make lint`
- **Valgrind Memcheck manual** — https://valgrind.org/docs/manual/mc-manual.html — what `make memcheck` reports and what each error means
- **cppreference: undefined behaviour in C** — https://en.cppreference.com/w/c/language/behavior — the language-level definition behind `project-management/docs/SAFETY-GUIDE.md`
- **The Rustonomicon** — https://doc.rust-lang.org/nomicon/ — the reference for what `unsafe` code has to uphold
- **Clippy lint list** — https://rust-lang.github.io/rust-clippy/master/index.html — the lints `cargo clippy --all-targets -- -D warnings` enforces, and restriction lints such as `undocumented_unsafe_blocks` that are not enabled here
- **Linux kernel: building external modules** — https://docs.kernel.org/kbuild/modules.html — `make -C <kernel-build-dir> M=$PWD`, used by kernel specs
- **Linux kernel: debugging with gdb** — https://docs.kernel.org/process/debugging/gdb-kernel-debugging.html — QEMU's `-s` stub, `nokaslr` and `scripts_gdb`
- **Linux kernel: Rust quick start** — https://docs.kernel.org/rust/quick-start.html — `make LLVM=1 rustavailable`, the check before any Rust-for-Linux milestone
- **Linux kernel: minimal requirements** — https://docs.kernel.org/process/changes.html — the build dependencies a kernel milestone lists as blockers
- **QEMU invocation** — https://www.qemu.org/docs/master/system/invocation.html — `-kernel`, `-initrd`, `-append`, `-nographic`, `-snapshot`, `-s -S`
- **Computer Misuse Act 1990, section 17** — https://www.legislation.gov.uk/ukpga/1990/18/section/17 — subsections (5) and (8), when access or an act is unauthorised; the reading behind the graduation-path ADR
- **RFC 5737, IPv4 documentation ranges** — https://www.rfc-editor.org/rfc/rfc5737 — the only IPv4 addresses a network example here may use
- **RFC 3849, IPv6 documentation prefix** — https://www.rfc-editor.org/rfc/rfc3849 — the only IPv6 prefix a network example here may use
- **RFC 2606, reserved DNS names** — https://www.rfc-editor.org/rfc/rfc2606 — `example`, `test` and `invalid` names for examples
