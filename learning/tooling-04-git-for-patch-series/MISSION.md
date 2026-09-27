# Mission — tooling-04-git-for-patch-series

**Started**: not yet · **Family**: tooling · **Phase**: P1 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

Sam asked whether he could "use the standard Linux kernel as a base and create a downstream,
bringing in updates via upstream", and chose exactly that for Syntek OS: upstream Linux plus a
small series of his own patches, carried onto each new stable or longterm release rather than a
fork. That makes git, as much as C, the daily tool of kernel maintenance — commits a reviewer can
follow, a series rebased release after release, a clear view of what changed between two versions
of it, patches exchanged in the kernel's format with an honest sign-off, and a bisect when a
release breaks something. Learning these moves now, on small repositories, turns them into habits
before a kernel tree arrives.

## Can do it when

- Sam can walk from `HEAD` to a commit, its tree and a blob with `git cat-file`, and say what a
  branch and a tag point at.
- Sam can split mixed changes into logical commits with `git add -p` and fold a fixup into its
  target with `git rebase -i --autosquash`.
- Sam can move a series onto a new base with `--onto`, resolve a conflict, and have `git rerere`
  replay it next time.
- Sam can read a `git range-diff` between two versions of a series and explain every line.
- Sam can produce a numbered series with a cover letter, apply it elsewhere with `git am`, and
  explain what his `Signed-off-by` certifies.
- Sam can bisect a regression by hand and with `git bisect run`, with "could not run" mapped to
  skip.
- Sam can build or review a second branch in its own worktree and remove it cleanly.

## Parked for later

- Sending patches by email and answering review (`git send-email`, b4) — `kernel-07`.
- The kernel.org stable remotes and tags, and carrying a real series across releases —
  `kernel-05`.
- Bisecting a kernel regression inside QEMU — `kernel-06`.
- Reviewing someone else's pull request — `tooling-05`.
