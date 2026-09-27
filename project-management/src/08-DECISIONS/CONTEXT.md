# project-management/src/08-DECISIONS/ — Decision Records

**Last Updated**: 27/09/2026

Architecture Decision Records (ADRs): one immutable record per decision that shapes how the C, Rust,
kernel or distro work is done — the language standard, the coding style, the build tool, the test
harness, the toolchain, and later the kernel base, the init system and the tier defaults. Each record
argues a trade-off in the open (the context, honest options, the choice and what it costs) so that a
later reader, including a later version of the learner, can see why the repository works the way it
does and what it would take to change it. An ADR argues; the guide that owns the rule enforces.

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

## When an ADR is written

At the moment a decision surfaces — while specifying a milestone, designing an exercise set, planning a
kernel build — rather than at the end. `project-management/workflows/08-decisions/` is the coherence
pass: it checks that a milestone's ADRs still hold and agree with one another before the milestone plan in
`project-management/src/09-MILESTONE-PLANS/` is written against them. A choice whose options rest on
factual claims is grounded first in a primary-source note under `research/`, which the ADR cites.

## Cross-references

- `project-management/workflows/08-decisions/` — the procedure that writes and checks ADRs
- `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` — the milestone behind the five defaults
- `project-management/src/09-MILESTONE-PLANS/` — plans cite the ADRs they rest on
- `research/` — primary-source notes that ground a contested option
- `how-to/workflows/04-toolchain-updates/` — the route by which the Rust pin is bumped and superseded
- `how-to/docs/TOOLCHAIN.md` — the toolchain versions the defaults were decided against
- `REFERENCES.md` — the root index; owns the PM workflow-to-folder table
