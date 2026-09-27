# project-management/src/08-DECISIONS/ — Decision Records

**Last Updated**: 27/09/2026

Architecture Decision Records (ADRs): one immutable record per decision that shapes how the C, Rust,
kernel, Syntek OS, UI, LLM or security work is done — the language standard, the coding style, the
build tool, the test harness, the toolchain, the roadmap's tracks, the kernel base, how Syntek OS is
built, the licence gate, the lab rules and the networking and licensing round, and later the init
system and each profile's hardware.
Each record argues a trade-off in the open (the context, honest options, the choice and what it
costs) so that a later reader, including a later version of the learner, can see why the repository
works the way it does and what it would take to change it. An ADR argues; the guide that owns the
rule enforces.

## Directory Tree

```text
project-management/src/08-DECISIONS/
├── CONTEXT.md · CLAUDE.md                                     ← orientation · operating rules for this folder
├── ADR-MS000-TEMPLATE.md                                      ← copy source for every new ADR
├── ADR-MS001-BUILD-SYSTEM-GNU-MAKE-27-09-2026.md              ← plain GNU make, flags and rules in code/src/c/mk/
├── ADR-MS001-C-CODING-STYLE-LINUX-KERNEL-27-09-2026.md        ← Linux kernel style; 80 columns preferred, 100 the repo's hard ceiling
├── ADR-MS001-C-STANDARD-C17-27-09-2026.md                     ← ISO C17 in strict mode; C23 revisited later
├── ADR-MS001-C-TEST-HARNESS-CHECK-H-27-09-2026.md             ← hand-rolled, header-only check.h
├── ADR-MS001-RUST-EDITION-2024-TOOLCHAIN-PIN-27-09-2026.md    ← edition 2024, toolchain pinned to 1.92.0
│   ── Planning conversation, 27/09/2026 ──
├── ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md    ← kernel, OS, UI, LLM and security tracks; interleaved; repo boundary
├── ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md      ← track kernel.org, carry a small series, per-profile configs
├── ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH-27-09-2026.md  ← LFS → BLFS → own build system; no base distribution
├── ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md      ← seven profiles on one base, eleven axes
├── ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md           ← existing desktops per desktop profile; none for servers
├── ADR-MS001-SYNTEK-OS-TOOLS-RUST-TUI-FIRST-27-09-2026.md      ← custom tools in Rust, ratatui TUI first, GUI later
├── ADR-MS001-LLM-SKILLS-NOT-AGENTS-27-09-2026.md               ← Markdown skills with progressive disclosure
├── ADR-MS001-LLM-EFFICIENCY-AND-SECURITY-FIRST-27-09-2026.md   ← a budget and a threat model on every LLM milestone
├── ADR-MS001-LLM-BASE-MODEL-PLUS-ADAPTERS-27-09-2026.md        ← Proposed: one base, LoRA adapters per domain
├── ADR-MS001-LLM-RUST-CRATE-LICENCES-27-09-2026.md             ← GPL-2.0-only here; Apache-2.0-only crates by exception
├── ADR-MS001-GUI-TOOLKIT-GTK4-27-09-2026.md                    ← gtk4-rs for lessons; Slint for the Syntek OS GUI tools
├── ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md        ← authorised, isolated-lab-only offence; no malware; extended by the graduation path (below)
│   ── Networking and licensing round, 27/09/2026 ──
├── ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md  ← labs isolated; a lab-proven config graduates to named devices
├── ADR-MS001-PRIVATE-CA-OFFLINE-ROOT-AND-ACME-27-09-2026.md    ← Proposed: offline root, constrained intermediate by hand; ACME issuer for leaves
└── ADR-MS###-<DECISION>-DD-MM-YYYY.md                         ← pattern for every later decision
```

The folder is flat and keeps no separate index: the tree above is the listing, and the `MS###` and
date in each filename carry its identity. The filename rule is owned by `CLAUDE.md` → Output & naming.

## What each ADR records

| Part | Holds |
| --- | --- |
| **Metadata table** | ID, Status, Date, driving Milestone, Deciders, Supersedes, Superseded by, Research note, where the rule is enforced |
| **Context** | The problem and the facts on the day — tool versions checked on the host, what the primary docs say — stated neutrally |
| **Options considered** | Every realistic option with a summary, pros and cons, including "do nothing" where that is a real choice |
| **Decision** | The option chosen, the deciding factor, and the observable change that would reopen it |
| **Consequences** | Positive, Negative and Follow-on: what gets easier, what it costs, which guide or register changes next |
| **Sources** | Primary sources with URLs and the date each was checked |

Status runs `Proposed` → `Accepted`; an Accepted record later becomes `Superseded` (a newer ADR replaced
it, linked both ways by full filename) or `Deprecated` (the question stopped arising). The scaffold with
its guidance comments is `ADR-MS000-TEMPLATE.md`.

## The five scaffold defaults

The five `ADR-MS001-...` records were accepted on 27/09/2026 together with the repository skeleton,
before the first exercise, under milestone MS001 (Toolchain ready). They are defaults chosen with the
evidence available that day — the host toolchain recorded in `how-to/docs/TOOLCHAIN.md` — and each
says so in its Context. A later change of mind arrives as a new ADR that supersedes one of them; the
original stays exactly as written, so the reasoning that held at the time remains readable.

| ADR | Rule enforced in |
| --- | --- |
| C standard — C17 | `code/src/c/mk/flags.mk` · `code/docs/BUILD.md` |
| C coding style — Linux kernel | `code/docs/C-CODING-PRINCIPLES.md` · `.editorconfig` |
| Build system — GNU make | `code/src/c/mk/exercise.mk` · `code/docs/BUILD.md` |
| C test harness — check.h | `code/src/c/include/check.h` · `code/docs/TESTING.md` |
| Rust edition 2024 and toolchain pin | `code/src/rust/rust-toolchain.toml` · `code/docs/RUST-CODING-PRINCIPLES.md` |

## The planning-conversation set

Twelve more `ADR-MS001-...` records were written on 27/09/2026 from Sam's planning conversation,
which widened the mission to a downstream kernel, Syntek OS, its TUI and GUI tools, a language model
and a security track. MS001 is their driving milestone because it was the only one open; they shape
later phases, not MS001's gates. Accepted records cite the conversation's question number; anything
the conversation only recommended is listed under Follow-on as "to confirm". One is `Proposed`.

| ADR | Rule enforced in |
| --- | --- |
| Roadmap tracks | `project-management/src/01-ROADMAP/ROADMAP.md` · `project-management/docs/planning/MILESTONES.md` |
| Kernel downstream of upstream | `project-management/src/01-ROADMAP/ROADMAP.md` → P5 · `project-management/src/06-KERNEL/` |
| Syntek OS from scratch | `project-management/src/01-ROADMAP/ROADMAP.md` → P6 · `project-management/src/07-OS-PROFILES/` |
| Profiles on one base | `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` · `project-management/src/07-OS-PROFILES/CLAUDE.md` |
| Desktops reused | `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` → Default desktop / shell |
| Tools in Rust, TUI first | `project-management/src/01-ROADMAP/ROADMAP.md` → U1 to U3 · `code/src/rust/deny.toml` |
| Skills, not agents | `project-management/src/01-ROADMAP/ROADMAP.md` → L1 and L5 |
| Efficiency and security first | `project-management/docs/planning/MILESTONES.md` · `.claude/CLAUDE.md` Section 5 |
| Base model plus adapters (Proposed) | `project-management/src/01-ROADMAP/ROADMAP.md` → L6, once Accepted |
| Crate licences | `code/src/rust/deny.toml` |
| GUI toolkit | `code/src/rust/deny.toml` · `project-management/src/01-ROADMAP/ROADMAP.md` → U3 |
| Security track and lab rules | `.claude/CLAUDE.md` Section 5 · `project-management/docs/SAFETY-GUIDE.md` |

## The networking and licensing round

Written on 27/09/2026 from Sam's answers in the networking and licensing round that followed the
planning conversation; MS001 drives them for the same reason. Each record states in words the
question it answers. Records waiting on a research note stay `Proposed`.

| ADR | Rule enforced in |
| --- | --- |
| Network lab first, graduation path | `.claude/CLAUDE.md` Section 5 · `project-management/docs/SAFETY-GUIDE.md` → Graduating a lab-proven config |
| Private CA (Proposed) | `learning/sec-05-applied-cryptography/SYLLABUS.md` · `learning/ui-10-web-admin-dashboard/SYLLABUS.md` |

## When an ADR is written

At the moment a decision surfaces — while specifying a milestone, designing an exercise set, planning a
kernel build — rather than at the end. `project-management/workflows/08-decisions/` is the coherence
pass: it checks that a milestone's ADRs still hold and agree with one another before the milestone plan in
`project-management/src/09-MILESTONE-PLANS/` is written against them. A choice whose options rest on
factual claims is grounded first in a primary-source note under `research/`, which the ADR cites.

## Cross-references

- `project-management/workflows/08-decisions/` — the procedure that writes and checks ADRs
- `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` — the milestone behind every record here so far
- `project-management/src/09-MILESTONE-PLANS/` — plans cite the ADRs they rest on
- `research/` — primary-source notes that ground a contested option
- `how-to/workflows/04-toolchain-updates/` — the route by which the Rust pin is bumped and superseded
- `how-to/docs/TOOLCHAIN.md` — the toolchain versions the defaults were decided against
- `REFERENCES.md` — the root index; owns the PM workflow-to-folder table
