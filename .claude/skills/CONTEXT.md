# .claude/skills/ — Skill Roster and When-to-Load Table

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

The repo's own Claude Code skills: four session mechanics that shape how a study session runs,
rather than what gets built. Each skill is one folder holding one `SKILL.md` in the
[Agent Skills format](https://agentskills.io/specification), reached either by Sam typing
`/<name>` or by Claude matching the work against the skill's `description`. This file is the
roster and the only when-to-load table; the authoring rules are in `.claude/skills/CLAUDE.md`.

## Directory Tree

```text
.claude/skills/
├── CONTEXT.md · CLAUDE.md   ← this roster and table · the skill-authoring rules
├── teach/                   ← /teach <topic>: one lesson, mission → level → sources → recall + build → review
│   └── SKILL.md             ← the six-step loop and the MISSION, RESOURCES and PROGRESS formats
├── wait-what/               ← /wait-what [level]: the last explanation missed, so re-pitch it
│   └── SKILL.md             ← the levels, the re-pitch steps and the teaching detour
├── research/                ← /research: one question, primary sources, a cited note in research/
│   └── SKILL.md             ← the source list, the licence ladder and the note format
└── handoff/                 ← /handoff: compact the session into handoffs/, then stop
    └── SKILL.md             ← the seven steps, the handoff format and what stays out
```

## Which skill, when

| Skill | Load when | Writes to |
| --- | --- | --- |
| `teach` | Sam types `/teach <topic>`, asks to learn, practise or revise a C, Rust, kernel or tooling concept, or a topic's `PROGRESS.md` has a review due | `learning/<track>-NN-<topic>/`; Sam's code in `code/src/` |
| `wait-what` | Sam types `/wait-what`, optionally with a level: the last explanation did not land. User-invoked only | nothing; a detour handoff is written by `handoff` |
| `research` | Sam types `/research`, or a decision (an ADR, a TIER spec, a kernel spec, a contested lesson source) needs synthesis across primary sources | `research/<SCREAMING-KEBAB-TOPIC>.md` |
| `handoff` | Sam types `/handoff`, a hook reports the context window filling, the day ends, or other work takes over mid-task | `handoffs/HANDOFF-<SCREAMING-KEBAB>-DD-MM-YYYY.md` |

## How the four connect

- **A session starts** from the newest handoff in `handoffs/`, or with `/teach` for a new concept
  or a due review (`how-to/workflows/02-daily-study-session/`).
- **An explanation misses** → `/wait-what` re-pitches it; a knowledge gap becomes a
  `HANDOFF-TEACH-<TOPIC>` handoff and a `/teach` session.
- **A question needs a decision** → `/research` writes a note that feeds an ADR
  (`project-management/workflows/08-decisions/`), a TIER spec
  (`project-management/workflows/07-distro-tier-spec/`) or a lesson's `RESOURCES.md`.
- **A session ends before its work does** → `/handoff` writes the bridge and stops.

Every workflow `STEPS.md` and `CHECKLIST.md` names its skills in a `skills:` frontmatter list drawn
from `teach`, `handoff` and `research`, or `[]`. `wait-what` is user-invoked only, so no workflow
lists it.

## Glossary

- **Skill**: one folder, one `SKILL.md`, one remit, reached by `/<name>` or a `description` match.
- **Session mechanic**: a skill that changes how a session runs (all four here), as opposed to a
  workflow, which is a numbered procedure with a checklist under a layer's `workflows/`.
- **Governing procedure**: the workflow a skill hands its work to, named in the skill's
  `## Governing procedures` section.
- **Tutor mode**: Sam writes the code; Claude asks, explains and guides (`.claude/CLAUDE.md`).

## Do not use for

- Multi-step procedures with checklists → `code/workflows/CONTEXT.md`,
  `how-to/workflows/CONTEXT.md`, `project-management/workflows/CONTEXT.md`
- The commands a skill runs → `how-to/docs/CLI-TOOLING.md`
- Build flags and make targets → `code/docs/BUILD.md`

## Cross-references

- `.claude/CLAUDE.md`: the manual; read order, tutor mode, non-negotiables, registers.
- `.claude/CONTEXT.md`: the `.claude/` layer this folder sits in.
- `.claude/hooks/CONTEXT.md`: the two hooks that prompt `/handoff` as the context window fills.
- `learning/CONTEXT.md` · `research/CONTEXT.md` · `handoffs/CONTEXT.md`: the three folders these
  skills write.
- `project-management/workflows/10-study-and-build/`: the PM workflow `teach` runs inside.
- `REFERENCES.md`: the root index of every layer, guide and workflow.
