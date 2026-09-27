# project-management/docs/ — PM Reference Guides

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

The reference guides the PM workflows are judged against: how planning runs and what a milestone and a
sprint look like, how branches, commits and pull requests work, how mastery is proved, and what a
milestone touching memory, `unsafe` or a kernel has to plan for. The workflows in
`project-management/workflows/` sequence the work; these guides decide what "done" means for it, and
neither restates the other.

## Directory Tree

```text
project-management/docs/
├── CONTEXT.md · CLAUDE.md   ← guide index (this file) · rules for editing guides
├── PLANNING-GUIDE.md        ← thin index over planning/
├── planning/                ← CADENCE.md · MILESTONES.md · SPRINTS.md (own pair inside)
├── GIT-GUIDE.md             ← thin index over git/
├── git/                     ← BRANCHES.md · COMMITS.md · PR-AND-CHECKS.md (own pair inside)
├── VERIFICATION-GUIDE.md    ← how mastery is proved; what goes into a 10-PROGRESS record
└── SAFETY-GUIDE.md          ← UB and memory-bug classes, the Rust unsafe policy, kernels in QEMU only
```

## Guides

| Guide | Scope | Read before |
| --- | --- | --- |
| `PLANNING-GUIDE.md` | The loop, sprint capacity, milestone format and flags, **the milestone status vocabulary**, sprints and the Retrospective | Any of workflows `01`–`03`, or writing a status |
| `GIT-GUIDE.md` | Branch prefixes, staging by path, Conventional Commits scopes, trailers, pull requests, the six CI checks | A branch, a commit or a pull request |
| `VERIFICATION-GUIDE.md` | The commands that prove each flag, what clean output looks like, the verification record | `project-management/workflows/11-verification/` |
| `SAFETY-GUIDE.md` | What a milestone plans for C memory bugs, Rust `unsafe` and kernel work | Workflows `04`–`06` for any milestone that allocates, uses `unsafe` or touches a kernel |

The two thin indexes route to sub-documents that each carry their own `CONTEXT.md` · `CLAUDE.md` pair.
Each guide opens with `type: guide` frontmatter and the standard metadata line, and stays within the
instructional-Markdown length cap owned by `code/docs/DOCUMENTATION-LENGTH.md`.

## Cross-references

- `project-management/CONTEXT.md` — the layer these guides belong to
- `project-management/REFERENCES.md` — every guide here with its purpose, and the external sources they cite
- `project-management/workflows/CONTEXT.md` — the procedures these guides govern
- `code/docs/BUILD.md` · `code/docs/MEMORY-SAFETY.md` · `code/docs/RUST-CODING-PRINCIPLES.md` — the
  code-layer guides these route to for build flags, memory bugs and `unsafe`
- `how-to/workflows/03-quality-gates/` — the gate commands the git and verification guides cite
