@./CONTEXT.md

# CLAUDE.md — how-to/docs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `how-to/CONTEXT.md` → this folder's `CONTEXT.md`
(guide index, imported above) → this file → the guide you need.

## Purpose (one line)

The operational reference guides — `TOOLCHAIN.md` (versions, prerequisites, troubleshooting),
`CLI-TOOLING.md` (commands by intent) and `GUIDE-CRAFT.md` (how guides are written) — each ≤ 300 cloc code
lines.

## How to work here

- **Routing:** these are references, not procedures. A procedure belongs in `how-to/workflows/NN-…/`,
  linking here; a long-form runbook in `how-to/src/`. Authoring follows
  `how-to/workflows/06-write-a-guide/` under `GUIDE-CRAFT.md`.
- **Concrete steps:** edit the guide → verify every command on this machine and paste real output → keep
  the file ≤ 300 cloc code lines (split into a thin index plus a `kebab-case/` sub-folder with its own pair
  if not) → update this folder's `CONTEXT.md` and `how-to/REFERENCES.md` if a guide is added or removed.
- **Definition of done:** every non-P4 command ran here as written; version numbers match
  `code/src/scripts/toolchain/check.sh`; cross-references resolve; British English;
  `audits/docs-length.sh` and markdownlint clean.
- **Routing frontmatter:** every guide here opens with `type: guide`.

## Guardrails

- **Record versions only in `TOOLCHAIN.md`.** Other guides cite it; a version changes there only through
  `how-to/workflows/04-toolchain-updates/`.
- **Show the raw command first, then the script.** The raw command is what the learner is learning; the
  script is what CI and Claude run.
- **Label anything unrunnable as a P4 preview.** Kernel and QEMU commands are not presented as tested until
  the planned P4 workflows run them.
- **Keep guides current with the scripts.** A command a script no longer accepts is worse than no command;
  check `--help` when a script changes.
- **Never exceed 300 cloc code lines.** Split with a thin index instead.

## Output & naming

- **Hand-written:** every guide here; nothing generated.
- Guides are `SCREAMING-SNAKE-CASE.md` with `type: guide` frontmatter and the family footer
  ``_Part of the `how-to/docs/` documentation family._``; a split guide's sub-folder is `kebab-case/`.
- Commit scope `how-to`.
