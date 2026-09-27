@./CONTEXT.md

# CLAUDE.md — handoffs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (anatomy and
lifecycle, imported above) → this file → the `handoff` skill (`.claude/skills/handoff/SKILL.md`).

## Purpose (one line)

The committed home for `/handoff` session-continuity documents, kept as a live set and safe to
publish.

## How to work here

- **Routing:** all writes here run through the `handoff` skill
  (`.claude/skills/handoff/SKILL.md`); a teaching detour is offered by `wait-what` and written by
  `handoff`.
- **Concrete steps:** `/handoff` writes `HANDOFF-<SCREAMING-KEBAB>-DD-MM-YYYY.md` with the goal,
  what is done, what is in-flight (`path:line`), the next action, what the next session loads, and
  the artefacts by path → prints the path and stops → the next session reads it first → the file
  is deleted once its **Next** action has landed.
- **Definition of done:** a fresh session can resume from the handoff alone; every artefact is a
  repo-relative path or a commit hash; the hygiene grep in the skill's step 6 prints nothing.

## Guardrails

- **A handoff carries live continuity only.** Durable knowledge goes to its home instead: recall
  results → `learning/<topic>/PROGRESS.md`; feedback, patterns and state → `.claude/MEMORY.md`;
  blockers → `GAPS.md`; parked topics → `DEFERRED.md`; decisions → an ADR.
- **Reference, never paste.** Point at milestones, ADRs, `PROGRESS.md` files, research notes,
  commits and diffs by repo path or hash; do not copy their content in.
- **Public repo: no absolute paths, no session IDs, no email addresses, no secrets.** A local-only
  location (a scratch directory, a transcript) is named by what it is, never by its path. A
  handoff that fails the hygiene grep is fixed before it is written, not after it is committed.
- **Prune once resumed.** The session that lands a handoff's **Next** action deletes the handoff
  in the same change; a handoff superseded by a newer one for the same work is deleted when the
  newer one is written. Git history keeps both.
- **British English (en_GB)**; `DD-MM-YYYY` in filenames, `DD/MM/YYYY` in prose.

## Output & naming

- **Hand-written** via `/handoff`; nothing here is generated.
- Files `HANDOFF-<SCREAMING-KEBAB>-DD-MM-YYYY.md`, the descriptor naming the work (for example a
  milestone and its subject); teaching detours `HANDOFF-TEACH-<TOPIC>-DD-MM-YYYY.md`, the topic
  being the `learning/` slug in capitals.
- Handoff files are exempt from pairing and length checks; this `CONTEXT.md` and `CLAUDE.md` pair
  is checked.
