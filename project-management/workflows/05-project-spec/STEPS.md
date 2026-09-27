---
workflow: 05-project-spec
phase: specify
skills: [research]
---

# Project Spec — Steps

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

---

## Key references

Consult `project-management/REFERENCES.md` (valgrind, GCC and Rust sources) as you work through these
steps:

| Step | Section |
| --- | --- |
| 1 | The milestone in `project-management/src/02-MILESTONES/`; the phase in `project-management/src/01-ROADMAP/ROADMAP.md` |
| 2 | `project-management/src/05-PROJECTS/CLAUDE.md` — naming, status words; `PROJ-MS000-TEMPLATE.md` |
| 3 | `.claude/skills/research/SKILL.md` — reference behaviour that needs a primary source |
| 4 | `project-management/docs/planning/MILESTONES.md` → _Estimation_ |
| 5 | `project-management/docs/SAFETY-GUIDE.md` · `code/docs/MEMORY-SAFETY.md` · `code/docs/FFI.md` |
| 7 | `project-management/docs/git/COMMITS.md` — scope `pm`, staging by explicit path |

---

## Steps

### Step 1 — Explain-first on what the program needs

Check the entry condition: the milestone's `Project` flag is not `N/A`. If a spec for this project
already exists (a later part), open it and go to Step 4 to update its milestone table. Otherwise ask the
learner: what the finished program does in one sentence, what they think it needs internally, which
real program it should behave like, and which part they expect to be hardest. The answers seed the
summary, the parts table and the risks.

_Done when the learner's description, reference program and predicted hardest part are recorded._

### Step 2 — Copy the template and fix the scope

```bash
cp project-management/src/05-PROJECTS/PROJ-MS000-TEMPLATE.md \
   project-management/src/05-PROJECTS/PROJ-MS020-UNIX-SHELL.md
```

Fill the header (first milestone, phase, track, code location, `Status: Draft`, date) and the summary.
Then write **in scope** and **out of scope** side by side. For a P2 shell, for example: pipelines and
redirection in; job control and scripting out, with the reason. The out-of-scope list is the fence the
project will lean on when it starts to grow.

_Done when both scope lists are written and the learner agrees with the out-of-scope reasons._

### Step 3 — Write the interface or behaviour, and the parts

A library project gives its public header or `pub` API with each function's contract; a program gives
its command-line behaviour, input, output and exit statuses. Name the **reference behaviour** that
expected results come from (`dash` or `bash` for a shell, the man page and C17 for a libc function, the
C project's own test suite for a Rust port), and research anything that rests on memory. Then list the
parts and what each is responsible for; a map, not a design.

_Done when every expected behaviour has a source, and every part has one responsibility._

### Step 4 — Cut the milestones

Fill the milestone table in build order: one row per part, with what finishing it proves. A part that
would be more than 8 points is split again. Only the current milestone has a number; later rows read `—`
until `02-milestone-creation` cuts them, one at a time, and back-fills the number here. Add the later
parts as slices on the track's map if they are not already there.

_Done when every part is a milestone-sized row, and the current milestone's row names its `MS###`._

### Step 5 — Write acceptance and the test strategy

Write the acceptance scenarios `A1`, `A2`, ... in Gherkin with exact commands, including one for the
test suite and memory gates of every C part. Fill the test strategy: unit, behaviour against the
reference, and memory. **An allocator project states its memory-testing plan**, because valgrind
intercepts any globally exported `malloc` and `free` (the learner's own included) and AddressSanitizer
brings its own replacement allocator. The usual options, one of which the spec picks and justifies:

1. Develop and test the allocator under prefixed names (`my_malloc`, `my_free`) so the ordinary gates
   still see the memory it hands out, and export the real names only in a final part tested separately.
2. Mark blocks for memcheck with the client requests in `<valgrind/valgrind.h>`
   (`VALGRIND_MALLOCLIKE_BLOCK`, `VALGRIND_FREELIKE_BLOCK`), which tell it where a custom allocator's
   blocks begin and end.
3. Run valgrind with `--soname-synonyms=somalloc=nouserintercepts`, which stops it replacing the
   executable's own allocation functions, and write down what that run can no longer detect.

_Done when every scenario names a command and a result, and every C part names its memory gates._

### Step 6 — Stretch goals, risks, resource budget, threat model, status and links

List stretch goals explicitly as not required for done; each is a candidate for a later milestone or
`DEFERRED.md`. Fill the risks with a likelihood and a fallback. **For a project whose Budget is not
`N/A`** (never `N/A` for a kernel-config, OS or LLM project), fill `## 8. Resource budget` — each
resource the project must stay within and the tool that measures it — and fill `## 9. Threat model`
with the assets, threats and mitigations, or the non-negotiable it runs under (`.claude/CLAUDE.md`
Section 5). Record any hard-to-reverse design choice through `08-decisions`. Then check the folder's
definition of done, set `Status: Ready`, and link the spec from the current milestone by full path.

_Done when the spec is `Ready`, its budget and threat model are filled (or `N/A` with a reason), and it
is linked from every milestone it spans so far._

### Step 7 — Commit by explicit path

On the milestone branch:

```bash
git add project-management/src/05-PROJECTS/PROJ-MS020-UNIX-SHELL.md \
        project-management/src/02-MILESTONES/MS020-SHELL-PARSER.md
git commit -m "docs(pm): specify the Unix shell project"
```

_Done when `git status` shows nothing from this workflow left uncommitted._

---

## Update context files

If this workflow created files or folders, or settled a new convention:

1. Add every new file or folder to the directory tree in the nearest `CONTEXT.md`.
2. Add any new artefact type or external source to `project-management/REFERENCES.md`.
3. Refresh `**Last Updated**` in every `CONTEXT.md` you modified.
4. If the session ends before Completion, run `/handoff` to write
   `handoffs/HANDOFF-<SCREAMING-KEBAB-DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete. Next, as flagged:
`project-management/workflows/06-kernel-spec/` or `07-os-profile-spec/`, then `08-decisions/`.
