---
type: guide
---

# Git Guide — Commits

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

What to check before a commit, how to stage it, and the shape of the message. Index:
[`project-management/docs/GIT-GUIDE.md`](../GIT-GUIDE.md).

---

## Before every commit

### Step 0 — Stage by explicit path

**Never `git add -A` or `git add .`.** Name every path you are committing:

```bash
git add code/src/c/ms007-dynamic-array/vec.c code/src/c/ms007-dynamic-array/test_vec.c
git status --short
```

A working tree can hold more than the change you mean to make: a scratch file, a half-finished note,
build output that `.gitignore` does not yet cover, or a file a second session or an agent wrote while
you were working. A blanket add sweeps all of it into your commit, where it passes review as though
you had meant it. Naming paths is also a small act of review: you have to know what you changed.

Naming a directory (`git add code/src/c/ms007-dynamic-array/`) counts as explicit when every file in it
is yours; check `git status --short` first.

### Step 1 — Run the gates for what you touched

The command is the lesson, so run the raw command first; the scripts wrap the same commands and are
what CI runs. The full gate set and its order are owned by `how-to/workflows/03-quality-gates/`, and
the targets and flags by `code/docs/BUILD.md`.

| You touched | Raw command | Script |
| --- | --- | --- |
| A C exercise | `make -C code/src/c/ms007-dynamic-array test` (then `san`, `memcheck`, `lint`) | `bash code/src/scripts/c/test.sh` and siblings |
| A Rust crate | `cargo test`, `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings` in `code/src/rust/` | `bash code/src/scripts/rust/test.sh` · `rust/lint.sh` |
| Markdown | `npx --yes markdownlint-cli2 --no-globs <changed files>` from the repository root | `bash code/src/scripts/audits/docs-length.sh` · `audits/docs-pairing.sh` |
| Anything, before a PR | — | `bash code/src/scripts/gates/all.sh` |

A script that exits `2` **could not run** (a tool is missing); that is not a pass, and the commit waits
until the tool is installed or the gap is recorded in `GAPS.md`.

**Two exceptions, both on a milestone branch and both declared in the message:**

- **A deliberate red commit.** A failing test written before its code (`code/workflows/02-tdd-cycle/`)
  may be committed on its own, as long as the message says so
  (`test(c): add failing test for vec_push growth`).
- **A session that has to stop with a gate still failing.** The work may be committed so it syncs and
  the handoff can point at it, with the failing gate named in the body and the day's PROGRESS entry
  saying the same (`feat(c): grow the vector by doubling`, body `WIP: make san still fails, see
  PROGRESS 27/09/2026`).

The branch head a pull request is opened from is always green.

### Step 2 — Read what you are about to commit

```bash
git diff --staged
```

Check for debug `printf`s, commented-out experiments, absolute paths from your machine and anything
that looks like a credential. The repository is public.

### Step 3 — Commit

Only once the gates you ran exit `0`, or the commit is one of the two declared exceptions above.

---

## Commit message format

[Conventional Commits 1.0](https://www.conventionalcommits.org/en/v1.0.0/):

```text
<type>(<scope>): <summary in the imperative, no full stop>

<body: what changed and why, wrapped at 72 columns>

Refs: MS007
Signed-off-by: {YOUR NAME} <{YOUR ADDRESS}>
Co-Authored-By: {AGENT NAME AND MODEL} <{AGENT ADDRESS}>
```

- **Summary:** imperative mood ("add", not "added"), no trailing full stop, short enough that the whole
  first line stays within about 72 characters.
- **Body:** optional for a one-line change, expected for anything a future reader would ask "why?"
  about. Explain the reason; the diff already shows the what.
- **Trailers** go in the last paragraph, one per line, after a blank line: git only treats a final
  block of `Key: value` lines as trailers. All three shown are optional; use the ones that apply.

### Type values

| Type | When to use |
| --- | --- |
| `feat` | New working code: an exercise solved, a crate, a script, a kernel module |
| `fix` | A defect in existing code (pairs with a `13-BUGS` record when it earned one) |
| `test` | Tests only, including a deliberate red test |
| `refactor` | Restructure without changing behaviour (the tests prove it) |
| `docs` | Documentation, notes and PM artefacts |
| `build` | Makefiles, `mk/` includes, `Cargo.toml`, the toolchain pin |
| `ci` | `.github/workflows/` |
| `style` | Formatting only (`cargo fmt`, whitespace), no logic change |
| `chore` | Housekeeping: `.gitignore`, editor and lint configuration |

### Scope values

| Scope | Covers |
| --- | --- |
| `c` | C exercises and projects under `code/src/c/` |
| `rust` | Crates under `code/src/rust/` |
| `kernel` | All kernel work, wherever it lives: `06-KERNEL` plans and records, config fragments, modules |
| `os` | All Syntek OS work: `07-OS-PROFILES` specs, the matrix, os lessons, `code/src/os/` (planned — added at P6) |
| `ui` | TUI and GUI tools: the ui crates and lessons |
| `llm` | LLM work: `code/src/python/` (planned — added at L1), `code/src/cuda/` (planned — added at L2), the LLM crates, llm lessons |
| `sec` | Security-track work, wherever it lives: sec lessons, lab scope documents, the deliberately vulnerable exercises |
| `pm` | The rest of `project-management/`: maps, milestones, sprints, specs, ADRs, plans, records, guides |
| `learning` | Concept notes and progress under `learning/` |
| `research` | Research notes under `research/` |
| `how-to` | The `how-to/` layer |
| `code` | The `code/` layer's guides, workflows and `code/src/scripts/` |
| `docs` | Root documents (`README.md`, `CONTRIBUTING.md`, registers) and cross-layer docs |
| `ci` | `.github/` |
| `claude` | `.claude/` (manual, skills, hooks) and `handoffs/` |

Pick the scope of the layer the change is **for**: an exercise spec written for a C milestone is
`docs(pm)`, and the exercise code it describes is `feat(c)`. Kernel, Syntek OS, UI, LLM and security
work are the exception: they span layers, so they are scoped by subject (`docs(kernel)` for a kernel
plan, `feat(kernel)` for a module; `docs(os)` for a profile spec, `feat(os)` for a build recipe;
`feat(ui)` for a TUI crate; `feat(llm)` for training or inference code; `docs(sec)` for a lab scope
document, `feat(sec)` for a mitigation exercise) and stay easy to find in the log.

There is no breaking-change marker (`!` or a `BREAKING CHANGE:` footer) in use: nothing here is
released or versioned (`project-management/REFERENCES.md` → Semantic Versioning, not used).

---

## Trailers

### `Signed-off-by` — optional, the kernel habit

The Linux kernel accepts patches only with a `Signed-off-by:` line certifying the Developer's
Certificate of Origin (https://docs.kernel.org/process/submitting-patches.html). This repository does
not require it, but P4 onwards is practice for that world, so the habit is welcome early.
`git commit -s` adds the line for you from your `user.name` and `user.email` configuration; nothing
about it is written into this repository. An agent never adds `Signed-off-by`: only a human can
certify the DCO. Patches bound for the kernel — the downstream kernel repository or upstream — credit
an assistant with an `Assisted-by:` tag in the kernel's own format, not `Co-Authored-By:`
(https://docs.kernel.org/process/coding-assistants.html → Signed-off-by and Developer Certificate of
Origin; Attribution).

### `Co-Authored-By` — when an agent wrote the change

A commit an agent wrote ends with a co-author trailer naming the agent and model, in the form
`Co-Authored-By: {AGENT NAME AND MODEL} <{AGENT ADDRESS}>`. The agent fills both values at commit time
from its own instructions. **Neither value is pinned here**: a model name written into a rule goes
stale on the next release, and from then on every commit misattributes itself. The same applies to a
generated-by footer in a pull request body. GitHub reads the trailer and credits the co-author on the
commit.

---

## Example

```text
feat(c): grow the dynamic array by doubling

vec_push reallocates to twice the capacity when full, so a run of n
pushes costs O(n) copies in total. A failed realloc leaves the original
buffer untouched and returns -1, which test_vec.c now checks.

Refs: MS007
```

---

## Related

- [`project-management/docs/git/BRANCHES.md`](BRANCHES.md) — which branch the commit belongs on
- [`project-management/docs/git/PR-AND-CHECKS.md`](PR-AND-CHECKS.md) — what CI runs on the pushed commits
- `how-to/workflows/03-quality-gates/` — the gate commands and their order
- `code/workflows/02-tdd-cycle/` — the red, green, refactor rhythm that shapes a milestone's commits
