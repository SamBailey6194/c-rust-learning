---
type: guide
---

# Planning Guide — c-rust-learning

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

A thin index. The planning standard is split across three sub-documents, each serving a different
moment: charting and running the loop, writing a milestone, and opening or closing a study sprint.
Read the one that matches the artefact in front of you.

---

## Sub-documents

| Sub-document | Governs | Serves |
| --- | --- | --- |
| [`project-management/docs/planning/CADENCE.md`](planning/CADENCE.md) | The loop, one milestone at a time through verification, sprint length, capacity and grace | Every PM workflow `01`–`13` |
| [`project-management/docs/planning/MILESTONES.md`](planning/MILESTONES.md) | Milestone format, Gherkin mastery criteria, the FLAGS table, MoSCoW, Fibonacci points, **the status vocabulary** | `project-management/src/02-MILESTONES/` |
| [`project-management/docs/planning/SPRINTS.md`](planning/SPRINTS.md) | The sprint record, admission, the flags union, the backlog register, the mandatory Retrospective | `project-management/src/03-STUDY-SPRINTS/` |

---

## Which one do I need?

- **"How does planning actually run here?"** → `CADENCE.md`. Start here if you are new; the
  one-milestone-at-a-time loop is the thing most likely to be assumed wrong.
- **"What status should this milestone be in?"** → `MILESTONES.md` → _Statuses_. It is the only place
  the vocabulary is defined.
- **Writing or re-sizing an `MS###`** → `MILESTONES.md`.
- **Opening, filling or closing a `SPRINT-##`** → `SPRINTS.md`, with the figures from `CADENCE.md`.

## The one-paragraph version

A phase is charted once into a map (`01`), and milestones are cut from it one at a time. Each
milestone is written with Gherkin mastery criteria that name real commands (`02`), admitted to the
open two-week study sprint until that sprint reaches 13 points (`03`), specified as its flags require
(`04`–`07`), checked against the decision records (`08`) and planned (`09`). Then it is studied and
built (`10`), proved (`11`), reviewed and reflected on (`12`) and merged (`13`) before the next
milestone starts. `Completed` means merged with a verification record, and every sprint closes with a
Retrospective that measures whether 13 points was the right number.

---

## Related

- `project-management/docs/GIT-GUIDE.md` — branches, commits and pull requests for the same loop
- `project-management/docs/VERIFICATION-GUIDE.md` — how the mastery criteria are proved
- `project-management/docs/SAFETY-GUIDE.md` — what a milestone touching memory, `unsafe` or a kernel
  has to plan for
- `project-management/workflows/CONTEXT.md` — the workflow index and the cadence diagram
- `project-management/src/01-ROADMAP/ROADMAP.md` — the phases every map is charted against
