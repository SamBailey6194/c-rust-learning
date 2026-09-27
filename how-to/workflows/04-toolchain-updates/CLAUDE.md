@./CONTEXT.md

# CLAUDE.md — how-to/workflows/04-toolchain-updates/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, key
concepts — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Move the toolchain deliberately: the Rust pin through a superseding ADR, host packages through
reboot-purge, and every resulting version back into `how-to/docs/TOOLCHAIN.md`.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. The ADR is written through
  `project-management/workflows/08-decisions/` (use `/research` when the case rests on a release note or
  a kernel requirement). Host upgrades are the learner's, through reboot-purge
  (`how-to/src/HOST-MAINTENANCE.md`).
- **Concrete steps:** see what would change → decide on the Rust pin and write the ADR → move the pin as
  a matched set → upgrade host packages → run every gate → re-record `how-to/docs/TOOLCHAIN.md` from
  `toolchain/check.sh` → commit by explicit path on a branch.
- **Definition of done:** `rust-toolchain.toml`, `Cargo.toml` `rust-version` and `TOOLCHAIN.md` agree; a
  moved pin has an Accepted ADR that supersedes the previous one; `gates/all.sh` exits 0 on the new
  toolchain; `CHECKLIST.md` is fully ticked.

## Guardrails

- **Move the pin only with an ADR.** Editing `channel` without a superseding ADR leaves the recorded
  decision false.
- **Leave `sudo` to the learner.** Claude lists the upgradable packages and explains them; the learner runs
  the upgrade.
- **Never silence a new lint to finish the update.** A lint the new clippy adds is fixed, or argued in the
  ADR's Consequences with a scoped `#[allow(…)]` and a reason beside it.
- **Keep the ADR immutable.** Only the old record's Status and "Superseded by" line change; everything else
  goes in the new ADR.
- **Re-record from real output.** Copy versions from `toolchain/check.sh`, not from memory or release
  notes.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md`; nothing generated.
- **Produced by following it:** a new `project-management/src/08-DECISIONS/ADR-MS###-<DECISION>-DD-MM-YYYY.md`
  when the pin moves, edits to `code/src/rust/rust-toolchain.toml`, `code/src/rust/Cargo.toml` and
  `Cargo.lock`, and a re-recorded `how-to/docs/TOOLCHAIN.md`.
- Commit scopes: `rust` for the pin, `pm` for the ADR, `how-to` for the table
  (`project-management/docs/git/COMMITS.md`).
