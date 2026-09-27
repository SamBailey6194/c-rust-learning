@./CONTEXT.md

# CLAUDE.md — project-management/docs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (the guide index,
imported above) → this file → the guide, or the sub-folder's `CONTEXT.md`, that matches the task.

## Purpose (one line)

The PM reference guides — planning, git, verification and safety — that the numbered
`project-management/workflows/` cite when they produce artefacts under `project-management/src/`.

## How to work here

- **Routing:** these are reference guides, not artefacts. Read the relevant guide before its workflow:
  `PLANNING-GUIDE.md` (and its `planning/` sub-documents) before `01`–`03`, `SAFETY-GUIDE.md` before a
  spec workflow `04`–`06` for any milestone touching memory, `unsafe` or a kernel,
  `VERIFICATION-GUIDE.md` before `11-verification`, and `GIT-GUIDE.md` before any branch, commit or pull
  request. Edit a guide only when the convention itself changes.
- **Concrete steps:** edit the owning guide → check no other guide and no workflow now contradicts it →
  keep it within the length cap (`bash code/src/scripts/audits/docs-length.sh`), splitting overflow into
  a `kebab-case/` sub-folder with its own pair and turning the guide into a thin index → update the
  guide table in `CONTEXT.md` and the guide rows in `project-management/REFERENCES.md`.
- **Definition of done:** the guide is accurate and cross-linked to the workflow that uses it; within the
  cap; British English; `CONTEXT.md` and `project-management/REFERENCES.md` both list it with the same
  scope.

## Guardrails

- **Route, do not restate.** Build flags and targets belong to `code/docs/BUILD.md`, memory-bug detail to
  `code/docs/MEMORY-SAFETY.md`, `unsafe` rules to `code/docs/RUST-CODING-PRINCIPLES.md`, gate commands to
  `how-to/workflows/03-quality-gates/`, and the kernel QEMU-only rule to `.claude/CLAUDE.md`. A guide here
  says what the PM stage needs from those rules and cites the owner.
- **Keep each owned fact in one file.** The milestone status vocabulary lives in
  `project-management/docs/planning/MILESTONES.md`, the sprint figures in
  `project-management/docs/planning/CADENCE.md`, the branch and commit rules in
  `project-management/docs/git/`. A second copy anywhere is the first step of two copies disagreeing.
- **Let guides specify and workflows execute.** Do not paste a workflow's steps into a guide; cite the workflow
  by path.
- **Verify technical claims before writing them.** A command, a flag or a tool's output quoted here is
  taught as true; check it against the man page or primary documentation, and say so where it cannot
  be checked.
- **Keep secrets, email addresses, absolute home paths and pasted copyrighted text out.** The
  repository is public.

## Output & naming

- **Hand-written:** every guide here and every sub-document in `planning/` and `git/`; nothing is
  generated.
- Guides `SCREAMING-SNAKE-CASE.md` with `type: guide` frontmatter, the standard metadata line, one `#`
  heading and `---` between major sections; sub-folders `kebab-case/`, each with its own `CONTEXT.md` ·
  `CLAUDE.md` pair.
- Milestones cited as `MS###`, sprints as `SPRINT-##`; dates DD/MM/YYYY; commit scope `pm`.
