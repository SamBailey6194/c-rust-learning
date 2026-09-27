@./CONTEXT.md

# CLAUDE.md — how-to/workflows/06-write-a-guide/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, the two
homes, key concepts — imported above) → this file → `how-to/docs/GUIDE-CRAFT.md` → `STEPS.md` then
`CHECKLIST.md`.

## Purpose (one line)

Add or restructure an operational guide — a reference in `how-to/docs/` or a runbook in `how-to/src/` —
under the rules in `how-to/docs/GUIDE-CRAFT.md`, proven by running it and wired into the indexes.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`, with `how-to/docs/GUIDE-CRAFT.md` open. Code
  standards go to `code/docs/`; study notes to `learning/` (`/teach`); a factual question to `research/`
  (`/research`); host maintenance to the reboot-purge repository.
- **Concrete steps:** place it → draft against the reference shape or the runbook spine → verify every
  command and claim against a primary source → execute it from its stated prerequisites → length and lint
  → wire it into the indexes → commit by explicit path.
- **Definition of done:** the guide was run start to finish and corrected from what happened; every
  quoted output is real; `how-to/docs/` guides are ≤ 300 cloc code lines; the file is listed in its
  folder `CONTEXT.md` tree, `how-to/REFERENCES.md` and the root `REFERENCES.md`; markdownlint is clean.

## Guardrails

- **Run it before you publish it.** Step 4 is not optional; prose review cannot find a missing
  prerequisite.
- **Write to the standard of the home you chose.** A `how-to/docs/` file over 300 lines is split into a
  thin index plus a `kebab-case/` sub-folder with its own pair; a `how-to/src/` runbook takes the full
  spine.
- **Quote real output, never expected output.** Paste what the command printed on this machine.
- **Keep `HOST-MAINTENANCE.md` a pointer.** Host maintenance is reboot-purge's; never grow it into a
  runbook here.
- **No absolute home paths, emails or secrets.** Paths in a guide are repo-relative or system paths
  (`/usr/…`, `/proc/…`); the repository is public.
- **Mark P4 content as P4.** Kernel and QEMU material written before P4 is labelled as a preview and not
  presented as a tested procedure.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md`; nothing generated.
- **Produced by following it:** a `SCREAMING-SNAKE-CASE.md` guide in `how-to/docs/` (with `type: guide`
  frontmatter) or `how-to/src/`, plus its index entries; a split guide adds a `kebab-case/` sub-folder in
  `how-to/docs/` with its own `CONTEXT.md` and `CLAUDE.md`.
- Commit scope `how-to`; branch `docs/<desc>` per `project-management/docs/git/BRANCHES.md`.
