# project-management/docs/git/ — Git Sub-Documents

**Last Updated**: 27/09/2026

The git standard, split into three sub-documents behind the thin index
`project-management/docs/GIT-GUIDE.md`. They follow a change as it travels: the branch it is made on,
the commits it is made of, and the pull request and CI checks that carry it to `main`. They own the
repository's branch and commit conventions; every other file that mentions a branch name or a commit
scope cites them.

## Directory Tree

```text
project-management/docs/git/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · rules for editing these guides
├── BRANCHES.md              ← main + topic branches, the four prefixes, lifecycle, straight-to-main
├── COMMITS.md               ← staging by path, pre-commit gates, Conventional Commits, trailers
└── PR-AND-CHECKS.md         ← the pull request, its template, the six CI checks, merging
```

## Which file owns what

| File | Owns | Read before |
| --- | --- | --- |
| `BRANCHES.md` | The branch model, the `ms###/` `pm/` `docs/` `ci/` prefixes, the lifecycle commands, what counts as a small direct fix | Starting any change |
| `COMMITS.md` | Staging by explicit path, which gates to run, the message format, type and scope values, `Signed-off-by`, `Co-Authored-By` | Every commit |
| `PR-AND-CHECKS.md` | Opening a pull request, what each template section is for, the six check names, the path-filter trap, the merge method | Opening a pull request or editing CI |

**The gate commands themselves** are owned by `how-to/workflows/03-quality-gates/` and the build
targets by `code/docs/BUILD.md`. These files say when to run them and what a commit or merge needs;
they cite the commands rather than defining them.

**The check names** are the `name:` lines of the six workflow files under `.github/workflows/`, em
dash included; branch protection matches their jobs' names, which `PR-AND-CHECKS.md` explains.

## Why the split

The three files are read at three different moments by the same person, and each is short enough to
be read in full at that moment: a branch name at the start of a milestone, the commit rules many times
a session, the pull request and CI rules once at the end.

## Cross-references

- `project-management/docs/GIT-GUIDE.md` — the thin index over this folder
- `project-management/workflows/13-pr-and-merge/` — the procedure that executes the pull request rules
- `.github/PULL_REQUEST_TEMPLATE.md` — the template `PR-AND-CHECKS.md` explains
- `code/workflows/02-tdd-cycle/` — the red, green, refactor rhythm behind the deliberate red commit
