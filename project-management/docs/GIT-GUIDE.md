---
type: guide
---

# Git Guide — c-rust-learning

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

A thin index. The git standard is split across three sub-documents that follow a change as it travels
(branch, commit, pull request), so the file you open is decided by the operation in front of you.

---

## Sub-documents

| Sub-document | Governs | Read before |
| --- | --- | --- |
| [`project-management/docs/git/BRANCHES.md`](git/BRANCHES.md) | The `main`-plus-topic-branch model, the four prefixes, the branch lifecycle, what may go straight to `main` | Starting a milestone or any other change |
| [`project-management/docs/git/COMMITS.md`](git/COMMITS.md) | Staging by explicit path, the pre-commit gates, Conventional Commits types and scopes, the `Signed-off-by` and `Co-Authored-By` trailers | Every commit |
| [`project-management/docs/git/PR-AND-CHECKS.md`](git/PR-AND-CHECKS.md) | Opening a pull request, the template, the six CI checks, required checks versus path filters, merging | Opening a pull request or editing a CI workflow |

---

## Which one do I need?

- **"What do I call this branch?"** → `BRANCHES.md`.
- **"What has to pass, and what does the message look like?"** → `COMMITS.md`.
- **"Why is this check pending forever?"** → `PR-AND-CHECKS.md` → _Required checks and path filters_.
- **"Can this go straight to `main`?"** → `BRANCHES.md` → _Straight to `main`_. Almost always no.

## The one-paragraph version

Each milestone lives on one `ms###/<short-kebab>` branch from the moment it is written to the moment it
merges; planning work owned by no milestone uses `pm/`, other documentation `docs/`, and tooling `ci/`.
Every commit stages its files by name, runs the gates for what it touched, and follows Conventional
Commits with one of twelve scopes; a `Signed-off-by` line is optional practice for kernel work, and an
agent's commits carry a co-author trailer. The branch reaches `main` through a pull request that passes
the six CI checks, and merges with a merge commit so the red → green → refactor history survives.

---

## Related

- `project-management/docs/PLANNING-GUIDE.md` — the loop the branches and pull requests follow
- `project-management/docs/VERIFICATION-GUIDE.md` — the evidence a milestone's pull request carries
- `project-management/workflows/13-pr-and-merge/` — the procedure that opens and merges the pull request
- `how-to/workflows/03-quality-gates/` — the gate commands every commit and every CI run share
