# project-management/src/13-BUGS/ — Bug Records

**Last Updated**: 27/09/2026

Bug records — one per defect found in the code a milestone built, dated the day it was found. Each record
carries the reproduction, the evidence behind the root cause (a gdb session, a valgrind report, a
sanitiser trace), the fix, and the regression test that was written first and seen to fail before the fix
made it pass. In a learning repository a bug is also a lesson: the root-cause section often names the
misconception behind it, which then becomes a finding. The fix itself lives in `code/src/`; this folder
records the defect, not the patch.

## Directory Tree

```text
project-management/src/13-BUGS/
├── CONTEXT.md · CLAUDE.md               ← orientation · operating rules for this folder
├── BUG-MS000-TEMPLATE.md                ← copy source for every bug record
├── BUG-MS###-<DESC>-DD-MM-YYYY.md       ← one defect in one milestone's code, dated when found
└── BUG-<DESC>-DD-MM-YYYY.md             ← a defect not owned by one milestone (a script, CI, shared mk/ rules)
```

No bug has been recorded yet.

## What each record holds

| Section | Holds |
| --- | --- |
| **Header table** | Milestone, plan, file and line, severity, date found, how it was found, fix state |
| **1–4** | Summary; environment (gcc, flags and `-O` level, valgrind, rustc, kernel and QEMU where relevant); numbered reproduction; expected against actual |
| **5. Root-cause analysis** | The tool evidence, the cause traced to its lines, and any misconception behind it |
| **6. The fix** | The approach and the commit; no diff |
| **7. Regression test** | The test written first, with its red and green output |
| **8–9** | Impact and related records; the verification commands and sign-off |

## When a record is written

When a defect has been isolated — usually by `code/workflows/07-debug/`, which is where this folder's
records come from, whether the defect surfaced during study, in a review
(`project-management/src/11-REVIEWS/`) or at verification (`project-management/src/10-PROGRESS/`). A
trivial slip fixed in the same sitting it was made needs no record; a defect that took a debugger, a
memory tool or more than one attempt to find earns one. A kernel or module defect is reproduced inside
the QEMU guest only.

## Cross-references

- `code/workflows/07-debug/` — the procedure that writes these records
- `code/docs/DEBUGGING.md` — gdb, and reading a crash
- `code/docs/MEMORY-SAFETY.md` — the memory-bug classes and the tools that find them
- `project-management/src/10-PROGRESS/` — the verification a fix sends the milestone back through
- `project-management/src/12-FINDINGS/` — where the misconception behind a bug is recorded
- `project-management/docs/SAFETY-GUIDE.md` — undefined behaviour, and why kernels stay in QEMU
