# ADR-MS000: {Decision Title}

_Template — copy to `ADR-MS###-<DECISION>-DD-MM-YYYY.md`, replace every `{PLACEHOLDER}`, delete the
`[EXAMPLE]` lines and the guidance comments. One ADR records one decision. Once Accepted it is
immutable: a change of course is a new ADR that supersedes this one, never an edit to it._

<!-- Filename: ADR-MS###-<DECISION>-DD-MM-YYYY.md — the milestone that surfaced the decision, the
     decision in SCREAMING-KEBAB-CASE naming the choice (e.g. C-STANDARD-C17), and the date it was
     made. Flat folder, no index. The rule is owned by this folder's CLAUDE.md → Output & naming.
     Status values: Proposed → Accepted; an Accepted record later becomes Superseded (a newer ADR
     replaced it) or Deprecated (the question no longer arises). -->

| Field | Value |
| --- | --- |
| **ID** | ADR-MS###-{DECISION} |
| **Status** | Proposed |
| **Date** | {DD/MM/YYYY} — the day the decision was made |
| **Milestone** | MS### — {milestone title} · `project-management/src/02-MILESTONES/MS###-{TITLE}.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — _(or the full filename of the ADR this one replaces)_ |
| **Superseded by** | — _(or the full filename of the ADR that later replaced this one)_ |
| **Research** | — _(or `research/{TOPIC}.md`, the primary-source note behind a contested choice)_ |
| **Enforced in** | {the guide or file that carries the rule, e.g. `code/docs/BUILD.md`} |

---

## Context

<!-- The forces at play: the problem, the constraints, and the facts in effect on the day. State it
     neutrally enough that a reader who disagrees with the outcome still recognises the problem.
     Tool and standard facts are checked on the day (`<tool> --version`, `man <tool>`, the primary
     docs) and cited under Sources — never recalled from memory. Say plainly what could not be
     verified. -->

{What is being decided, and why now? What does the installed toolchain support today? What do the
later phases in `project-management/src/01-ROADMAP/ROADMAP.md` need from this choice?}

- [EXAMPLE] Host fact, checked {DD/MM/YYYY}: `{command}` reports `{output}`.
- [EXAMPLE] Primary-source fact: {what the documentation says, paraphrased} (Sources, item 1).

## Options considered

<!-- Every realistic option, argued fairly — including "do nothing" or "keep the status quo" where
     that is a real choice. Enough that the Decision reads as a choice, not a decree. Two options is
     the minimum; one option is not a decision. -->

### Option A — {name}

- **Summary:** {what this option is, in one or two sentences}
- **Pros:** {what it gives the learner and the later phases}
- **Cons:** {costs, risks, what it rules out}

### Option B — {name}

- **Summary:** {what this option is}
- **Pros:** {benefits}
- **Cons:** {costs, risks, trade-offs}

### Option C — Do nothing / keep the status quo

- **Summary:** {what happens if no decision is taken}
- **Pros:** {usually: no work now}
- **Cons:** {what drifts, breaks or stays inconsistent}

## Decision

<!-- The option chosen, stated plainly, and WHY it beat the others. This is the load-bearing
     section: name the deciding factor, and say what would have to change for the answer to flip —
     that sentence is what a future superseding ADR will test. -->

**We will take Option {X}.** {The deciding factor, and why the runner-up lost.}

{What would change this answer: the trigger for revisiting it, stated as an observable fact.}

## Consequences

<!-- Positive, negative and follow-on. What becomes easier, what becomes harder, where the rule is
     enforced, and what work the decision creates. -->

- **Positive:** {what improves}
- **Negative:** {what is accepted as a cost, and any mitigation}
- **Follow-on:** {guides to update, gaps to register in `GAPS.md`, topics to park in `DEFERRED.md`,
  the milestone or phase where this is next looked at}

## Sources

<!-- One bullet per primary source: **Name** — URL — what it established, and the date it was
     checked. Cite and link; do not paste copyrighted text. -->

- [EXAMPLE] **{Source name}** — {https://...} — {the fact it established}, checked {DD/MM/YYYY}

<!-- When this record is superseded: set Status to Superseded, fill "Superseded by" with the new
     ADR's full filename, and leave everything else exactly as it was. The new ADR fills its own
     "Supersedes" row with this file's full filename. -->
