# Workflow: PR and Merge

**Last Updated**: 27/09/2026

A milestone branch left open drifts away from `main`, and a merge without green checks makes a broken
build the starting point for the next milestone. This workflow takes a verified, reviewed branch through
a pull request, waits for every CI check, merges and prunes, so `main` holds only proven work and the
next milestone starts from solid ground.

## Directory Tree

```text
project-management/workflows/13-pr-and-merge/
├── CONTEXT.md · CLAUDE.md   ← orientation (this file) · operating rules for the workflow
├── STEPS.md                 ← ordered steps, each closing on a "Done when" line
└── CHECKLIST.md             ← the gate ticked before the workflow counts as complete
```

## When to use this

- At the end of every milestone, once `11-verification` has recorded a pass and `12-review-and-reflect`
  has written the review and finding records. The milestone's Status reads `Verifying`.
- For a `pm/`, `docs/` or `ci/` branch, when its change is complete; the milestone-specific steps
  (verification record, status flip) are then skipped.
- Small documentation fixes may skip this workflow and go straight to `main`, within the limits set in
  `project-management/docs/git/BRANCHES.md` → _Straight to `main`_.

## Key concepts

- **Process here, content elsewhere.** The code was reviewed in `12-review-and-reflect` and proved in
  `11-verification`; this workflow owns the route to `main`: branch, pull request, checks, merge,
  prune.
- **One milestone, one branch, one pull request.** The `ms###/<short-kebab>` branch carries the
  milestone's specs, plan, notes, code and records together, so the claim and its evidence are reviewed
  side by side (`project-management/docs/git/BRANCHES.md`).
- **The template is the body.** `.github/PULL_REQUEST_TEMPLATE.md` sets the headings; the build-and-test
  section quotes the summary lines already held in the milestone's `10-PROGRESS` record.
- **Six workflows, seven checks.** `Syntax — C`, `Syntax — Rust` (two jobs, so two checks),
  `Syntax — Shell`, `Markdown — Lint`, `Audit — Docs`, `Audit — Secrets`, each defined in
  `.github/workflows/`. Their names contain an em dash, which matters for branch protection.
- **Merge style follows the branch.** A merge commit for a milestone branch keeps the red, green and
  refactor commits that show how the concept was learned; squash suits a one-change `docs/` or `ci/`
  branch. `project-management/docs/git/PR-AND-CHECKS.md` owns the rule.
- **`Completed` arrives with the merge.** A milestone is `Completed` when it is merged to `main` and its
  verification record exists (`project-management/docs/planning/MILESTONES.md` → _Statuses_). The status
  change rides in the branch's final commit, made once the checks are green, so `main` shows `Completed`
  only once the merge has happened.
- **Prune after merging.** The branch is deleted locally and on GitHub, and stale remote references are
  pruned, so the next milestone's branch is the only one in flight.

## Cross-references

### Governing documents

- `project-management/docs/GIT-GUIDE.md` — the index for branches, commits and pull requests
- `project-management/docs/git/PR-AND-CHECKS.md` — the pull request, the CI checks, merging
- `project-management/docs/git/BRANCHES.md` — branch names and the branch lifecycle
- `project-management/docs/git/COMMITS.md` — staging by explicit path and the message format

### Related reading

- `.github/PULL_REQUEST_TEMPLATE.md` — the pull request body
- `.github/workflows/` — the six CI workflow files
- `how-to/workflows/03-quality-gates/` — the same gates, run locally first
- `project-management/src/10-PROGRESS/` — the verification record the pull request carries
- `project-management/workflows/12-review-and-reflect/` — upstream: the review and findings
- `project-management/workflows/02-milestone-creation/` — where the next milestone, and its branch, begin
