# Workflow: Decisions (ADRs)

**Last Updated**: 28/09/2026

An unrecorded decision gets argued again every time it is met, usually months later and with less
context. An Architecture Decision Record fixes the reasoning at the moment it was made, and because it is
immutable, a change of mind shows up as a new record rather than a silent edit.

## Directory Tree

```text
project-management/workflows/08-decisions/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- **When a hard-to-reverse choice surfaces**, in any workflow: a spec, a plan, a build session. The ADR
  is written then, while the options are fresh, not saved up for the end of the milestone.
- **Once per milestone as the coherence gate**, after the specify workflows (`04` to `07`) and before
  `09-milestone-plans`: every ADR the milestone raised still holds, and no two clash.
- **When an Accepted decision needs to change.** The change is a new ADR that supersedes the old one.

The five seed ADRs (C17, Linux kernel coding style, GNU make, `check.h`, Rust edition 2024 with a pinned
toolchain) were accepted with the scaffold on 27/09/2026, and twelve more were written the same day from
Sam's planning conversation (the roadmap tracks, the downstream kernel, Syntek OS and its profiles and
tools, the LLM, the crate licences, the GUI toolkit and the security track —
`project-management/src/08-DECISIONS/CONTEXT.md` → The planning-conversation set); the networking and
licensing round the same day added more (`project-management/src/08-DECISIONS/CONTEXT.md` → The
networking and licensing round); the scripted-recorder round added two more
(`project-management/src/08-DECISIONS/CONTEXT.md` → The scripted-recorder round). Decisions still ahead
include each profile's kernel line (longterm or stable), Rust-for-Linux feasibility (blocked until
clang/LLVM is installed), bootloader, Syntek OS's own init system, the package format and signing
scheme, each profile's hardware, the private CA's ACME issuer, and each product repository's outbound
licence, picked from the approved list when its build starts.

## Key concepts

- **Five parts.** Status (with the date, milestone, deciders and supersession links, in the header
  table), Context, Options considered (Summary, Pros and Cons for each, "do nothing" included where it
  is realistic), Decision, and Consequences (Positive, Negative, Follow-on), closed by a Sources list.
  `project-management/src/08-DECISIONS/ADR-MS000-TEMPLATE.md` is the scaffold.
- **Immutable once Accepted.** Status runs `Proposed` → `Accepted`, and an Accepted record later
  becomes `Superseded` or `Deprecated` (the template lists the values). After acceptance the only edits
  an ADR receives are that Status flip and its "Superseded by" link. Everything else is a new record.
- **Two-way supersession by full filename.** The new ADR names the old one in "Supersedes"; the old one
  names the new one in "Superseded by". There is no numeric index; the folder is flat.
- **Named for the driving milestone and the date.** `ADR-MS###-<DECISION>-DD-MM-YYYY.md`, where `MS###`
  is the milestone that surfaced the trade-off. A decision needs a real driver, not an abstract worry.
- **The coherence gate.** Decisions made early in a milestone were made before later specs existed. The
  gate re-reads each Context against what came after, and compares the Decision sections pairwise.
- **Research feeds the Context.** A contested option is grounded in a primary-source note,
  `research/<SCREAMING-KEBAB-TOPIC>.md`, cited from the Context section.
- **An ADR argues a trade-off; it does not enforce one.** Enforcement lives in code and guides: compiler
  flags in `code/src/c/mk/flags.mk`, lints in `code/src/rust/Cargo.toml`, rules in `code/docs/`.
- **Not every choice is ADR-worthy.** A choice qualifies when it is hard to reverse, or when a later
  decision would need to supersede it explicitly. Anything smaller belongs in the milestone plan.

## Cross-references

### Governing documents

- `project-management/src/08-DECISIONS/CLAUDE.md` — immutability, naming and the driving-milestone rule
- `project-management/src/08-DECISIONS/ADR-MS000-TEMPLATE.md` — the five-section scaffold

### Related reading

- `project-management/src/08-DECISIONS/ADR-MS001-C-STANDARD-C17-27-09-2026.md` — a seed ADR that names
  the condition for revisiting it (complete C23 support in gcc), which is when a superseding ADR is due
- `research/CONTEXT.md` — how a research note is written and named
- `project-management/workflows/07-os-profile-spec/` — upstream: profile specs surface init,
  package-manager and storage decisions
- `project-management/workflows/09-milestone-plans/` — downstream: the plan cites the settled ADR set
- `GAPS.md` — where a decision blocked on a missing tool or unanswered question is recorded
