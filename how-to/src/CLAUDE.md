@./CONTEXT.md

# CLAUDE.md — how-to/src/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `how-to/CONTEXT.md` → this folder's `CONTEXT.md`
(runbook index, imported above) → this file → `how-to/docs/GUIDE-CRAFT.md` before editing a runbook.

## Purpose (one line)

The long-form operator runbooks — `MACHINE-SETUP.md` (the full host setup) and the `HOST-MAINTENANCE.md`
pointer stub — written in full on the six-part spine and exempt from the 300-line cap.

## How to work here

- **Routing:** a new or restructured runbook follows `how-to/workflows/06-write-a-guide/` under
  `how-to/docs/GUIDE-CRAFT.md`. Host maintenance belongs to the reboot-purge repository
  (`https://github.com/SamBailey6194/reboot-purge`, not yet published — `GAPS.md`); changes to it
  happen there, not here.
- **Concrete steps:** edit the runbook → keep the spine (Purpose → Prerequisites → Steps → Failure modes →
  Rollback → Verification) → run every changed step on this machine and paste real output → update this
  folder's `CONTEXT.md` and `how-to/REFERENCES.md` if a file is added or removed.
- **Definition of done:** the runbook has been executed from its stated prerequisites (Part B of
  `MACHINE-SETUP.md` excepted until P4); every quoted output is real; versions agree with
  `how-to/docs/TOOLCHAIN.md`; this folder's pair stays ≤ 300 cloc code lines.

## Guardrails

- **Write runbooks in full; keep this pair short.** The exemption covers `how-to/src/*.md`, not this
  `CONTEXT.md` and `CLAUDE.md`.
- **Keep `HOST-MAINTENANCE.md` a pointer.** Never add maintenance procedures to it; they belong to
  reboot-purge.
- **Leave `sudo` to the learner.** Runbooks mark privileged lines as the learner's; Claude does not run them.
- **Flag destructive commands on the line above them**, and say what is lost.
- **Label untested parts.** Anything not yet run (the P4 additions) says so in its heading or first line.
- **Cite versions, do not own them.** `how-to/docs/TOOLCHAIN.md` owns the recorded versions; a runbook
  quotes the output it saw on the date in its metadata.

## Output & naming

- **Hand-written:** every file here; nothing generated.
- Runbooks are `SCREAMING-SNAKE-CASE.md` with the two-line metadata block and no frontmatter; a future
  sub-folder here would be `kebab-case/` with its own pair.
- Commit scope `how-to`.
