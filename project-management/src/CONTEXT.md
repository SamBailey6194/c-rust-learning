# project-management/src/ — Learning Artefact Store

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

Every planning and record artefact of the learning journey lives here: the roadmap that defines the
eighteen phases across six tracks, the milestones cut from it, the sprints that batch them, the specs that say what gets
built, the decisions and plans made before building, and the records written afterwards. The
numbered folders run in four tiers — _plan_ (01–03), _specify_ (04–07), _decide & plan_ (08–09)
and _record_ (10–13). Everything from `02-MILESTONES/` onwards is anchored to a milestone
(`MS###`), so any artefact traces back to the skill it was meant to build and forward to the
evidence that the skill was built.

---

## The four tiers

| Tier | Folders | What happens |
| --- | --- | --- |
| **Plan** | 01–03 | Define the phases and their exit gates, chart a track map, cut milestones from it, batch milestones into study sprints |
| **Specify** | 04–07 | Say what gets built for a milestone: exercise sets, capstone projects, kernel plans and build records, Syntek OS profile specs |
| **Decide & plan** | 08–09 | Record hard-to-reverse choices as ADRs, then plan each milestone — both before study and build starts |
| **Record** | 10–13 | After the work: verification evidence, reviews, findings (what was learned or unlearned), bugs |

The **milestone plan (09) is the page the learner works from.** It points back to its milestone
(02), the specs it needs (04–07) and the decisions it rests on (08); the records (10–13) point back
to the plan.

---

## Directory Tree

```text
project-management/src/
├── CONTEXT.md · CLAUDE.md     ← this pair: the store's map · how to work in it
│
│   ── Plan (01–03) ──
├── 01-ROADMAP/                ← ROADMAP.md (owns the phases) + MAP-<TRACK>.md decision maps
├── 02-MILESTONES/             ← MS###-<TITLE>.md — one learning milestone each (MS001 seeded)
├── 03-STUDY-SPRINTS/          ← SPRINT-##.md — a time-boxed batch of milestones
│
│   ── Specify (04–07) ──
├── 04-EXERCISES/              ← EX-MS###-<TOPIC>.md — exercise-set specs, hints but no solutions
├── 05-PROJECTS/               ← PROJ-MS###-<NAME>.md — capstone project specs
├── 06-KERNEL/                 ← KERNEL-PLAN-MS###-* before a kernel build, KERNEL-IMPL-MS###-* after
├── 07-OS-PROFILES/            ← PROFILE-MATRIX.md + PROFILE-<NAME>.md — seven Syntek OS profiles
│
│   ── Decide & plan (08–09) ──
├── 08-DECISIONS/              ← ADR-MS###-<DECISION>-DD-MM-YYYY.md — five seeded at MS001
├── 09-MILESTONE-PLANS/        ← per-milestone plans, prefixed with their execution order
│
│   ── Record (10–13) ──
├── 10-PROGRESS/               ← per-milestone verification records — the gate results
├── 11-REVIEWS/                ← per-milestone review records
├── 12-FINDINGS/               ← dated findings — misconceptions corrected, lessons carried forward
└── 13-BUGS/                   ← dated bug records — reproduction, root cause, regression test
```

Every numbered folder carries its own `CONTEXT.md` + `CLAUDE.md` pair and a zero-ID template.

---

## The numbers here are frozen

**Append only.** A folder number, once given, is permanent. Every artefact cites other artefacts
by full repo-relative path, and so do commit messages, handoffs and learning notes; git history
keeps those paths for good. Renumbering a folder would silently break every one of those
citations, and nothing would fail loudly enough to notice.

So a new artefact folder takes the **next free number at the end** (`14-...`, `15-...`), even where
that breaks the mirroring between `project-management/workflows/` and this tree. Workflow numbers
are a running order and can be renumbered; these folder numbers are identifiers. The mirroring
is a convenience; the cross-links are the record. The divergence between workflows 10–13 and
folders 10–13 is explained once, in `project-management/REFERENCES.md`.

07 was renamed from `07-DISTRO-TIERS/` to `07-OS-PROFILES/` on 27/09/2026 (the ROADMAP ADR,
`project-management/src/08-DECISIONS/ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md`); the
**number is unchanged**, so no cross-link that cited the folder by its number broke, and a rename of a
`src/` folder's name (not its number) is the rare exception the ADR authorised.

---

## Zero-ID templates

Each folder's template takes the zero ID of its own pattern — `MS000-TEMPLATE.md`,
`SPRINT-00-TEMPLATE.md`, `EX-MS000-TEMPLATE.md`, `MAP-000-TEMPLATE.md` — and sits beside the real
files. Zero is reserved for templates, so a template sorts first and reads as a template. Real
IDs are allocated next-free; a retired ID leaves a gap, and the gap stays, because backfilling it
would make an old citation point at new work.

---

## Where each artefact lives

Orientation only: the filename pattern for each folder is owned by that folder's `CLAUDE.md` →
Output & naming. The workflow-to-folder table is owned by the root `REFERENCES.md`.

| Artefact | Folder | Written by |
| --- | --- | --- |
| `ROADMAP.md`, `MAP-<TRACK>.md` | `01-ROADMAP/` | `project-management/workflows/01-roadmap-map/` |
| `MS###-<TITLE>.md` | `02-MILESTONES/` | `project-management/workflows/02-milestone-creation/` |
| `SPRINT-##.md` | `03-STUDY-SPRINTS/` | `project-management/workflows/03-sprint-planning/` |
| `EX-MS###-<TOPIC>.md` | `04-EXERCISES/` | `project-management/workflows/04-exercise-design/` |
| `PROJ-MS###-<NAME>.md` | `05-PROJECTS/` | `project-management/workflows/05-project-spec/` |
| `KERNEL-PLAN-MS###-*`, `KERNEL-IMPL-MS###-*` | `06-KERNEL/` | `project-management/workflows/06-kernel-spec/` |
| `PROFILE-<NAME>.md`, `PROFILE-MATRIX.md` | `07-OS-PROFILES/` | `project-management/workflows/07-os-profile-spec/` |
| `ADR-MS###-<DECISION>-DD-MM-YYYY.md` | `08-DECISIONS/` | `project-management/workflows/08-decisions/` |
| milestone plans | `09-MILESTONE-PLANS/` | `project-management/workflows/09-milestone-plans/` |
| verification records | `10-PROGRESS/` | `project-management/workflows/11-verification/` |
| reviews, findings | `11-REVIEWS/`, `12-FINDINGS/` | `project-management/workflows/12-review-and-reflect/` |
| bug records | `13-BUGS/` | `code/workflows/07-debug/` |

Descriptors are `SCREAMING-KEBAB-CASE`; dates are DD/MM/YYYY in prose and DD-MM-YYYY in filenames;
milestone numbers are three digits, sprint numbers two.

---

## How a milestone moves through the store

```text
ROADMAP.md phase → MAP-<TRACK>.md slice → MS### → SPRINT-##
  → specs as flagged: 04 exercises, 05 project, 06 kernel, 07 OS profile
  → 08 ADRs → 09 plan → study and build (learning/ + code/src/)
  → 10 verification → 11 review, 12 findings, 13 bugs → next milestone
```

One milestone runs through verification before the next one starts; the cadence and its reasons
are in `project-management/docs/planning/CADENCE.md`.

---

## Cross-references

- `project-management/CONTEXT.md` — the layer overview: docs, src and workflows together
- `project-management/REFERENCES.md` — the workflow-numbering divergence note and layer sources
- `REFERENCES.md` — the root index; owns the PM workflow-to-folder table
- `project-management/workflows/CONTEXT.md` — the running-order procedures that write here
- `project-management/docs/PLANNING-GUIDE.md` — cadence, milestones and sprints
- `project-management/docs/planning/MILESTONES.md` — the milestone status vocabulary (its only owner)
- `project-management/src/01-ROADMAP/ROADMAP.md` — the phases every artefact here serves
