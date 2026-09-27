@./CONTEXT.md

# CLAUDE.md — how-to/workflows/05-debugging-environment/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, key
concepts — imported above) → this file → `STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

Diagnose and fix toolchain and host faults (missing tools, wrong versions, ptrace, core dumps, sanitiser
and valgrind clashes) and hand anything that survives a healthy environment to `code/workflows/07-debug/`.

## How to work here

- **Routing:** run `STEPS.md` in order and confirm against `CHECKLIST.md`. Once the environment is proven
  healthy and the fault persists, stop here and route to `code/workflows/07-debug/` (logic bugs, recorded
  under `project-management/src/13-BUGS/`).
- **Concrete steps:** capture the exact error → `toolchain/check.sh` → confirm the versions in play → match
  the symptom in the Step 4 table → fix the environment (learner runs anything privileged) → re-run the
  original command unchanged → route or record.
- **Definition of done:** the original command, unchanged, now runs; the cause is named as environment or
  code; any host setting changed temporarily has been set back; an unfixable gap is in `GAPS.md`.

## Guardrails

- **Diagnose the environment, not the learner's code.** No source edits in this workflow; a code fault is
  handed to `code/workflows/07-debug/` with the evidence gathered here.
- **Leave `sudo` to the learner, and undo temporary changes.** Explain a `sysctl` or package change, let the
  learner run it, and set a temporary setting (such as `ptrace_scope`) back when the session ends.
- **Never loosen a gate to get past an environment fault.** A gate that exits 2 is fixed by fixing the
  environment, not by skipping the gate.
- **Re-run the original command unchanged.** A fix proven with a different command has not been proven.
- **Record what was learned.** A new symptom goes into the Troubleshooting section of
  `how-to/docs/TOOLCHAIN.md`, so the next occurrence takes a minute.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md`; nothing generated.
- **Produced by following it:** at most an edit to the Troubleshooting section of
  `how-to/docs/TOOLCHAIN.md` (scope `how-to`), or a `GAPS.md` entry with **Type:** Toolchain gap.
- Core files and debugger output stay out of the repository.
