@./CONTEXT.md
@./REFERENCES.md

# CLAUDE.md — how-to/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (tree, key docs and
routing, imported above with `REFERENCES.md`) → this file → the target sub-folder's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The operations layer: set up and record the toolchain, run study sessions and the quality gates, keep the
toolchain current, diagnose the environment, and write the guides that document all of it.

## How to work here

- **Routing:** operational tasks → the matching `how-to/workflows/NN-…/` procedure (`STEPS.md` then
  `CHECKLIST.md`), which points at the governing guide in `how-to/docs/` or runbook in `how-to/src/`.
  Code questions → `code/`; plans, specs, decisions and pull requests → `project-management/`; host
  upkeep → the reboot-purge repository via `how-to/src/HOST-MAINTENANCE.md`.
- **Learn before you build:** an unfamiliar tool or concept met during an operation → `/teach` in the
  `learning/` sandbox (`.claude/skills/teach/SKILL.md`).
- **Session handoff:** the session ends before the procedure does → `/handoff`
  (`.claude/skills/handoff/SKILL.md`).
- **Concrete steps:** edit the relevant `how-to/docs/*.md`, `how-to/src/*.md` or
  `how-to/workflows/NN-…/*.md` → show the raw command first and the `code/src/scripts/` script second →
  run every changed command on this machine → keep instructional Markdown ≤ 300 cloc code lines → update
  this folder's `CONTEXT.md` and `REFERENCES.md` if the structure changed.
- **Definition of done:** guidance matches the scripts and tools it names, as run here; versions agree with
  `how-to/docs/TOOLCHAIN.md`; cross-references resolve; British English; `audits/docs-length.sh`,
  `audits/docs-pairing.sh` and markdownlint clean.

## Guardrails

- **Teach the raw command, then name the script.** The raw `gcc`, `make`, `gdb`, `valgrind` or `cargo`
  command is the lesson; CI and Claude's own verification run the wrapping script.
- **Leave `sudo` to the learner.** Explain privileged commands and wait; Claude never runs them.
- **Treat exit 2 as could-not-run.** A missing tool is never reported as a pass, in any workflow here.
- **Keep kernels in QEMU, OS images in VMs and labs on isolated networks.** The non-negotiables in
  `.claude/CLAUDE.md` govern every P4, P6 and security-track command in this layer: nothing is installed
  or `insmod`-ed on the host, and no kernel tree, image, model weight or dataset is committed.
- **One home per rule.** Versions live in `how-to/docs/TOOLCHAIN.md` and the gate list in
  `how-to/workflows/03-quality-gates/`; cite them rather than copying them.
- **Keep `how-to/src/HOST-MAINTENANCE.md` a pointer.** Host maintenance belongs to reboot-purge.
- **Every directory carrying a `CONTEXT.md` also carries a `CLAUDE.md`.**

## Output & naming

- **Hand-written:** every file in this layer; nothing is generated.
- Documentation files `SCREAMING-SNAKE-CASE.md`; guide sub-folders `kebab-case/`; workflow folders
  `NN-kebab-name/`, numbered as identifiers (next free number: `13`; `07`–`12` are reserved for the
  planned workflows in `how-to/workflows/CONTEXT.md`).
- Commit scope `how-to`, per `project-management/docs/git/COMMITS.md`.
