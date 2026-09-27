@./CONTEXT.md

# CLAUDE.md — project-management/src/10-PROGRESS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (what a record holds
and where it sits — imported above) → this file → `project-management/docs/VERIFICATION-GUIDE.md` →
`project-management/workflows/11-verification/STEPS.md`.

## Purpose (one line)

The evidence store — one `MS###-VERIFICATION.md` per milestone, recording every gate's command, exit
code and pasted output, so the milestone's mastery can be rerun and checked.

## How to work here

- **Routing:** records are written only through `project-management/workflows/11-verification/`
  (`STEPS.md` + `CHECKLIST.md`), which runs the gates in the order `how-to/workflows/03-quality-gates/`
  sets and the memory checks through `code/workflows/06-memory-check/`.
- **Concrete steps:** milestone to `Verifying` → capture `bash code/src/scripts/toolchain/check.sh` →
  clean, committed tree → run each running flag's raw command, then its script → capture exit codes and
  summary lines → debugger and QEMU evidence where flagged → explain-back with no notes →
  `bash code/src/scripts/gates/all.sh` → copy `MS000-VERIFICATION-TEMPLATE.md` to the name below and
  fill it → fill the plan's As-Built summary → set the status the record supports.
- **Definition of done:** every running flag has a row with a command, an exit code and pasted evidence;
  every `N/A` flag is listed with its reason; the reproduction commands run in order from a clean
  checkout; every gap names its register entry; the status line uses the owned vocabulary; no
  `{PLACEHOLDER}` remains; British English; dates DD/MM/YYYY.

## Guardrails

- **Paste evidence; never paraphrase it.** "Tests pass" is a claim. The command, its exit code and the
  line it printed are evidence. Record only what the output actually shows.
- **Exit 2 is not a pass.** A gate that could not run has proved nothing; it goes under Outstanding gaps
  with a `GAPS.md` entry, and the record supports `Blocked`, not `Verifying`.
- **Rerun everything after any code change.** A partial rerun proves only the part that was rerun; the
  record always describes one complete run at one commit.
- **Overwrite; do not append.** One current record per milestone. Git holds earlier runs; a second
  dated block in the same file makes the reader guess which one counts.
- **Leave `Completed` to the merge.** A record supports `Verifying`, `In Progress` or `Blocked`;
  `Completed` is set by `project-management/workflows/13-pr-and-merge/` once the branch is merged.
- **Keep kernels in QEMU.** QEMU evidence comes from the guest's serial console; nothing is installed or
  loaded on the host (`.claude/CLAUDE.md` owns the rule).
- **Scrub pasted output before committing.** Replace absolute home paths with repo-relative ones and
  remove anything secret or personal; the repository is public.

## Output & naming

- **Hand-written:** every `MS###-VERIFICATION.md`, copied from the template, with output pasted from the
  run.
- **Template:** `MS000-VERIFICATION-TEMPLATE.md` — the copy source; keep it, never fill it in or rename it.
- **Generated:** none — the scripts print the evidence, and a person or Claude copies it in.
- Filename `MS###-VERIFICATION.md`: the milestone number, three digits, zero-padded; no descriptor and no
  date, because there is exactly one current record per milestone.
- Inside a record: exit codes as printed (`0`, `1`, `2`); artefacts by full repo-relative path in
  backticks; dates DD/MM/YYYY.
