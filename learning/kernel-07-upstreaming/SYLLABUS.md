# Syllabus — kernel-07-upstreaming

**Track**: kernel · **Phase**: P5 · **Path**: Later · **Detail**: full · **Prerequisites**: kernel-05-downstream-tree; kernel-03-syscalls-memory-and-concurrency
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Every patch Syntek OS carries costs a rebase on every release; a patch upstream accepts costs nothing more. This topic
teaches the upstream kernel's contribution process end to end — deciding what is worth upstreaming, checking style,
finding the right maintainers and lists, preparing and versioning a series with a cover letter, sending it as plain
text, and responding to review — so the downstream stays small, as the kernel ADR intends
(`project-management/src/08-DECISIONS/ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`). It is **Later** on the
critical path: the first edition ships without it. Series are prepared in **the downstream kernel repository**
(created in kernel-05-downstream-tree); nothing is sent to a public list until Sam has a patch that deserves it, and
Claude never sends anything — the kernel's own rules for AI assistants say the human submits.

Version pins for this syllabus: docs.kernel.org pages were read on 27/09/2026 (documentation build 7.3.0-rc4); the b4
documentation (latest) was read the same day. `git send-email` (Ubuntu package `git-email`) and b4 were not installed
on 27/09/2026, which blocks lesson 04.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Why upstream, and what is upstreamable | 1 sitting | yes — series audit | — |
| 02 | Style and routing: checkpatch.pl, the coding style and get_maintainer.pl | 1 sitting | no | — |
| 03 | Preparing a submission: messages, cover letter and versions | 2–3 sittings | yes — v1 and v2 of a series | — |
| 04 | Sending patches as plain-text email | 1 sitting | no | Safety |
| 05 | Responding to review | 1 sitting | no | — |

---

## 01 — Why upstream, and what is upstreamable

- **Objective:** Sam can sort the downstream series into patches worth upstreaming and patches that will always be
  carried, and say what each costs per release.
- **Builds on:** kernel-05-downstream-tree lessons 04 and 08 (carries and drops).
- **Key ideas:**
  - A carried patch is rebased, rebuilt and re-tested on every release; an upstreamed one arrives with the next tag.
  - Stable fixes must exist in mainline first, so a fix that only Syntek OS carries never comes back through stable.
  - Fixes and hardware support are natural upstream candidates; profile defaults and branding belong in fragments and
    in the downstream, not upstream.
  - Upstream development follows its own calendar: new features go in during the two-week merge window; fixes can go
    at any time.
- **Recall targets:** the cost of carrying compared with upstreaming; which kinds of change upstream accepts and
  which stay downstream; when in the cycle a feature or a fix is sent.
- **Build:** an audit of the downstream series in **the downstream kernel repository**, marking each patch
  upstreamable, downstream-only or droppable, with a reason. Checked by Sam defending each verdict.
- **Sources:** "How the development process works" (<https://docs.kernel.org/process/2.Process.html>, 2.1 The big
  picture and 2.2 The lifecycle of a patch); stable rules (<https://docs.kernel.org/process/stable-kernel-rules.html>);
  "Posting patches" (<https://docs.kernel.org/process/5.Posting.html>, 5.1 When to post).
- **Done when:** every carried patch has a verdict and a reason.

## 02 — Style and routing: checkpatch.pl, the coding style and get_maintainer.pl

- **Objective:** Sam can check a patch against the kernel's style and find the maintainers and lists who should
  receive it.
- **Builds on:** kernel-02-modules lesson 03 (the kernel coding style, already the house style in
  `code/docs/C-CODING-PRINCIPLES.md`); kernel-05-downstream-tree lesson 03 (patches and trailers).
- **Key ideas:**
  - The tree's scripts/checkpatch.pl checks patches (or, with `-f`, whole files); `--strict` adds the milder checks;
    `--terse` and `--show-types` help when there are many findings. It is a guide, not a replacement for judgement.
  - The MAINTAINERS file maps paths to maintainers, reviewers and lists; the tree's scripts/get_maintainer.pl reads it
    for the paths a patch touches.
  - Routing a patch to the right list matters as much as the patch: the wrong audience means no review.
- **Recall targets:** what checkpatch can and cannot judge; how get_maintainer.pl decides who to copy; what a
  MAINTAINERS entry records.
- **Build:** none — both scripts run over the patches marked upstreamable in lesson 01, and the findings are fixed in
  **the downstream kernel repository**.
- **Sources:** "Checkpatch" (<https://docs.kernel.org/dev-tools/checkpatch.html>, "Options" and "Message Levels");
  "Linux kernel coding style" (<https://docs.kernel.org/process/coding-style.html>); "Submitting patches"
  (<https://docs.kernel.org/process/submitting-patches.html>, "Style-check your changes" and "Select the recipients
  for your patch"); "List of maintainers" (<https://docs.kernel.org/process/maintainers.html>).
- **Done when:** the upstreamable patches are checkpatch-clean or each remaining warning is justified, and Sam names
  the list and maintainers for each.

## 03 — Preparing a submission: messages, cover letter and versions

- **Objective:** Sam can prepare a numbered patch series with a cover letter, record its base, and produce a second
  version whose changes reviewers can see at a glance.
- **Builds on:** lesson 02; kernel-05-downstream-tree lessons 03–04 (`format-patch`, `range-diff`).
- **Key ideas:**
  - A cover letter explains what the series does and why; each patch still stands on its own message.
  - `git format-patch --cover-letter -v <n> --base=<commit>` numbers the version and records the base tree;
    `--range-diff=<previous>` adds the difference from the previous version to the cover letter.
  - Each new version carries a changelog saying what changed since the last and who asked for it.
  - b4's contributor workflow (`b4 prep` to start a series branch and edit its cover letter, `b4 send` to send,
    `b4 trailers -u` to collect review tags) automates the same steps; its prep, send and trailers commands exist from
    b4 0.10.
  - An AI assistant's help is credited with an `Assisted-by:` tag; the `Signed-off-by:` is Sam's alone, because only
    a human can certify the DCO.
- **Recall targets:** what a cover letter must say; what `--base` and `--range-diff` add and why reviewers value them;
  where the version changelog goes.
- **Build:** a v1 and a v2 of one upstreamable series in **the downstream kernel repository**, prepared but not sent.
  Checked by the v2 cover letter showing the range-diff and changelog, and by `git am` applying the v2 cleanly on its
  recorded base.
- **Sources:** "Posting patches" (<https://docs.kernel.org/process/5.Posting.html>, 5.3 Patch preparation and 5.4
  Patch formatting and changelogs); `man git-format-patch` (`--cover-letter`, `--reroll-count`, `--base`,
  `--range-diff`); "Submitting patches" (<https://docs.kernel.org/process/submitting-patches.html>, "Providing base
  tree information" and "Using Assisted-by:"); b4 "prep: preparing your patch series"
  (<https://b4.docs.kernel.org/en/latest/contributor/prep.html>); "AI Coding Assistants"
  (<https://docs.kernel.org/process/coding-assistants.html>).
- **Done when:** both versions exist, apply cleanly, and a reader can see from the v2 cover letter alone what changed.

## 04 — Sending patches as plain-text email

- **Objective:** Sam can send a series as inline plain-text email that applies cleanly at the other end, having first
  sent it to himself.
- **Builds on:** lesson 03.
- **Key ideas:**
  - Kernel patches travel as inline plain text, never as HTML, never `format=flowed`; attachments are frowned upon.
  - `git send-email` sends format-patch output as-is; `--dry-run` shows everything it would do without sending.
  - `b4 send --reflect` sends the series only to Sam's own address, to see exactly what the recipients would receive.
  - Nothing goes to a public list until it has passed checkpatch, built and booted; and Claude never sends anything.
- **Recall targets:** why plain text and inline; how to rehearse a send without reaching anyone; what must be true
  before a real send.
- **Build:** none — the v2 from lesson 03 is sent to Sam's own address only and applied back with `git am` from the
  received mail. **Blocked** until `git send-email` (Ubuntu package `git-email`) or b4 is installed — neither was on
  27/09/2026 (`GAPS.md` → "git send-email and b4 not installed"); Sam installs either himself.
- **Safety:** rehearse against Sam's own address; no address of anyone else, and no email address at all, is ever
  written into this public repository.
- **Sources:** "Email clients info for Linux" (<https://docs.kernel.org/process/email-clients.html>, "General
  Preferences"); "Submitting patches" (<https://docs.kernel.org/process/submitting-patches.html>, "No MIME, no links,
  no compression, no attachments. Just plain text"); `git send-email` (<https://git-scm.com/docs/git-send-email>,
  `--dry-run`); b4 "send: sending in your work" (<https://b4.docs.kernel.org/en/latest/contributor/send.html>,
  "Checking things over with --reflect").
- **Done when:** the self-sent series applies with `git am` exactly as it left.

## 05 — Responding to review

- **Objective:** Sam can take review comments on a series, answer them, and turn them into a next version that
  carries the reviewers' tags correctly.
- **Builds on:** lessons 03–04; the repository's own review loop
  (`project-management/workflows/12-review-and-reflect/`).
- **Key ideas:**
  - Reply to every comment and thank the reviewer; disagree with a technical reason where needed; a comment that
    leads to no code change still earns a code comment or a changelog note, and reposting without answering is how a
    series goes nowhere.
  - `Reviewed-by:` and `Tested-by:` received on the list are added to the next version by the author, and removed —
    with a note in the changelog — if the patch then changes substantially.
  - A new version lists what changed and copies everyone who commented; comments usually arrive within two or three
    weeks, and the guidance is to wait at least a week (longer in a merge window) before resending or asking.
  - What happens after acceptance: the patch moves through a maintainer's tree into mainline, and possibly into stable.
- **Recall targets:** what each review tag means and who gives it; when a tag must be dropped; how long to wait
  before following up.
- **Build:** none — the lesson rehearses a review round on the lesson 03 series with Sam's own written review.
- **Sources:** "Followthrough" (<https://docs.kernel.org/process/6.Followthrough.html>, 6.1 Working with reviewers and
  6.2 What happens next); "Submitting patches" (<https://docs.kernel.org/process/submitting-patches.html>, "Respond
  to review comments", "Don't get discouraged - or impatient" and "Using Reported-by:, Tested-by:, Reviewed-by:,
  Suggested-by: and Fixes:").
- **Done when:** Sam produces a v3 that addresses a written review, with its changelog and tags correct.
