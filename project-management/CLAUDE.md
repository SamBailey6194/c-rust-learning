@./CONTEXT.md
@./REFERENCES.md

# CLAUDE.md — project-management/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (tree, the four tiers,
gates — imported above) → `REFERENCES.md` (guides, artefact folders, workflows — imported above) → this
file → the target sub-folder's `CONTEXT.md` and `CLAUDE.md`.

## Purpose (one line)

The PM layer — the roadmap, milestones, study sprints, specs, decisions and plans that gate a concept
into study, the records that prove it was learned, the `docs/` guides that define "done", and the
numbered `workflows/` that produce all of it.

## How to work here

- **Routing:** every PM task starts from the matching `project-management/workflows/NN-kebab-name/` procedure
  (`STEPS.md` against `CHECKLIST.md`), which names the governing guide in `project-management/docs/` and
  the target folder in `project-management/src/`. The workflow ↔ folder table is the root
  `REFERENCES.md`; the running order and the cadence are `project-management/workflows/CONTEXT.md`.
- **Explain-first:** any substantial PM artefact (a map, a milestone, a spec, an ADR, a plan) opens with
  the learner: what they already know, where they predict it will go wrong, and the concept explained
  back in their own words (`project-management/workflows/CONTEXT.md` → _Explain-first_; the
  repository-wide default is `.claude/CLAUDE.md` → Section 8). Only mechanical
  touches skip it: a status flip, a date refresh, a link fix.
- **Concrete steps:** open the workflow's `STEPS.md` → Explain-first → copy the target folder's zero-ID
  template to the next free ID → fill it, citing the `MS###` and every artefact it rests on by full
  repo-relative path → tick the workflow's `CHECKLIST.md` → commit by explicit path per
  `project-management/docs/git/COMMITS.md`.
- **Definition of done:** the artefact is in the right numbered folder, named to that folder's pattern,
  linked to its `MS###`; the workflow checklist is fully ticked; any new directory carries a
  `CONTEXT.md` + `CLAUDE.md` pair; British English and DD/MM/YYYY dates throughout.

## Guardrails

- **Run one milestone at a time, all the way through merge.** Do not start the next milestone's study while
  one is `In Progress` or `Verifying`; only `Blocked` or `Parked` releases the slot
  (`project-management/docs/planning/CADENCE.md`).
- **Take the gates in order.** No study before the plan (`09`), no plan before the flagged specs and the
  decision check (`04`–`08`), no `Completed` before a `project-management/src/10-PROGRESS/` record and
  the merge. Do not skip forward to save time; the skipped gate is the lesson.
- **Use only the canonical status words.** Milestone statuses are owned by
  `project-management/docs/planning/MILESTONES.md` → _Statuses_ and sprint statuses by
  `project-management/docs/planning/SPRINTS.md`; never invent a state inside an artefact. A folder's
  own record-local lifecycle (ADR status, a bug's fix state) is separate (`MILESTONES.md` → _Statuses_).
- **Tutor, do not author the learning.** Claude drafts structure and asks questions; the learner's own
  answers go into mastery criteria, explain-backs and findings. An artefact that records Claude's
  understanding instead of the learner's has proved nothing.
- **Kernels and modules run in QEMU only.** Nothing specified here is installed, booted or `insmod`-ed on
  the host, and no kernel tree, build output or disk image is committed (`.claude/CLAUDE.md` owns the
  rule; `project-management/docs/SAFETY-GUIDE.md` explains it).
- **Keep this layer documentation, not code.** Exercise solutions live in `code/src/`; secrets, absolute
  home paths, email addresses and pasted copyrighted text never land anywhere in this public repository.
- **Keep instructional files within the length cap.** Every `CONTEXT.md`, `CLAUDE.md`, guide and workflow
  file here is at most 300 cloc code lines (`code/docs/DOCUMENTATION-LENGTH.md`); an oversized guide splits into
  a thin index plus a `kebab-case/` sub-folder. Artefacts under `src/` are exempt.
- **Never renumber a `src/NN-SCREAMING-SNAKE/` folder.** Folder numbers are frozen and append-only; workflow numbers are
  a running order (`project-management/workflows/CONTEXT.md`).

## Output & naming

- **Hand-written:** every artefact under `src/`, every guide under `docs/`, and each workflow's `STEPS.md`
  and `CHECKLIST.md`. Nothing in this layer is generated.
- **Each `src/` folder's own `CLAUDE.md` → Output & naming owns its filename pattern.** This table is the
  fallback summary, and defers to the folder wherever they differ:

| Folder | Pattern |
| --- | --- |
| `01-ROADMAP/` | `ROADMAP.md` · `MAP-<TRACK>.md` |
| `02-MILESTONES/` | `MS###-<SCREAMING-KEBAB-TITLE>.md` |
| `03-STUDY-SPRINTS/` | `SPRINT-##.md` |
| `04-EXERCISES/` | `EX-MS###-<TOPIC>.md` |
| `05-PROJECTS/` | `PROJ-MS###-<NAME>.md` |
| `06-KERNEL/` | `KERNEL-PLAN-MS###-<DESCRIPTOR>.md` · `KERNEL-IMPL-MS###-<DESCRIPTOR>.md` |
| `07-DISTRO-TIERS/` | `TIER-MATRIX.md` · `TIER-<NAME>.md` |
| `08-DECISIONS/` | `ADR-MS###-<DECISION>-DD-MM-YYYY.md` |
| `09-MILESTONE-PLANS/` | `<exec-order>-PLAN-MS###-<DESCRIPTOR>.md` |
| `10-PROGRESS/` | `MS###-VERIFICATION.md` |
| `11-REVIEWS/` | `REVIEW-MS###-<DESCRIPTOR>.md` |
| `12-FINDINGS/` | `FINDING-MS###-<DESCRIPTOR>-DD-MM-YYYY.md` |
| `13-BUGS/` | `BUG-MS###-<DESCRIPTOR>-DD-MM-YYYY.md` |

- Templates take the zero ID of their own pattern (`MS000-TEMPLATE.md`, `SPRINT-00-TEMPLATE.md`);
  descriptors are `SCREAMING-KEBAB-CASE`; milestone numbers three digits, sprint numbers two; dates
  DD/MM/YYYY in prose and DD-MM-YYYY in filenames.
- Guides `SCREAMING-SNAKE-CASE.md`, guide sub-folders `kebab-case/`, workflow folders `NN-kebab-name/`;
  commit scope `pm`.
