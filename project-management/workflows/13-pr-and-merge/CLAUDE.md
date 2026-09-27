@./CONTEXT.md

# CLAUDE.md — project-management/workflows/13-pr-and-merge/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (when to use, the CI
checks, merge style — imported above) → this file → `STEPS.md` then `CHECKLIST.md` →
`project-management/docs/git/PR-AND-CHECKS.md`.

## Purpose (one line)

Take a finished branch to `main`: confirm the records, run the local gates, open the pull request from
the template, wait for the CI checks, mark the milestone `Completed` last, merge, and prune.

## How to work here

- **Routing:** run `STEPS.md` in order against `CHECKLIST.md`. Read
  `project-management/docs/GIT-GUIDE.md` and its three sub-guides in `project-management/docs/git/`
  before Step 1; the local gates follow `how-to/workflows/03-quality-gates/`.
- **Concrete steps:** confirm the verification, review and finding records and a clean tree → run
  `gates/all.sh` and the markdown lint → push → `gh pr create` from the template → `gh pr checks --watch`
  until all seven checks are green → read the diff one last time → set the milestone to `Completed` in the
  final commit and watch the checks once more → `gh pr merge` with the branch's merge method → confirm
  `MERGED`, delete the branch and prune → hand on to the next milestone.
- **Definition of done:** the pull request merged into `main` with all seven checks green; the branch is
  gone locally and on GitHub; `main` shows the milestone `Completed` with its verification record;
  `CHECKLIST.md` is fully ticked.

## Guardrails

- **Merge only when every check is green** (seven, from six workflows). A red, pending or missing check is a reason to stop, never to use
  `--admin` or to merge through the web UI's override.
- **Fix a failing check on the branch with a new commit.** Rewriting pushed history hides what the check
  caught; a follow-up commit records it.
- **Treat exit 2 from a local gate as not ready.** A tool that could not run proves nothing; install it or
  record the gap in `GAPS.md` before opening the pull request.
- **Keep kernel trees, images and build output out of the diff.** Kernel source, build products and disk
  images are never committed (`.claude/CLAUDE.md` owns the rule); read the file list before merging.
- **Ask before any destructive git command.** Deleting a branch with `-D`, force-pushing or resetting
  needs the learner's explicit go-ahead in the session.
- **Copy check names; never retype them.** They contain an em dash, and a retyped name is a required check
  that never reports.

## Output & naming

- **Produces:** a pull request titled as a Conventional Commits summary with the milestone in it (for
  example `feat(c): MS### <short description>`), its merge into `main`, and the milestone's `Completed`
  status.
- Branch names follow `project-management/docs/git/BRANCHES.md`: `ms###/<short-kebab>`, `pm/<desc>`,
  `docs/<desc>`, `ci/<desc>`.
- Commit messages and trailers follow `project-management/docs/git/COMMITS.md`.
