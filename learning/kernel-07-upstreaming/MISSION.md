# Mission — kernel-07-upstreaming

**Started**: not yet · **Family**: kernel · **Phase**: P5 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

When Sam chose a downstream kernel for Syntek OS, the plan came with a rule of thumb: keep the patch series small and
upstream what you can. Every patch he carries has to be rebased and re-tested on every release; every patch upstream
accepts stops costing him anything. This topic teaches the kernel community's own process for getting a change
accepted — style, routing, a well-formed series, plain-text email and working with reviewers — so that the Syntek OS
kernel can stay close to upstream as it grows. It is off the critical path: the first edition ships without it.

## Can do it when

- Sort the downstream series into upstreamable, downstream-only and droppable patches, with reasons.
- Check a patch with checkpatch.pl and find its maintainers and lists with get_maintainer.pl.
- Prepare a versioned series with a cover letter, a recorded base and a changelog between versions, with sign-offs
  and `Assisted-by:` tags used correctly.
- Send a series as inline plain text and rehearse the send against his own address first (once the tools are
  installed).
- Answer review comments and produce a next version with the reviewers' tags handled correctly.

## Parked for later

- Reporting a security bug to the kernel's security team → sec-16-detection-response-and-disclosure (coordinated
  disclosure) with docs.kernel.org's "Security bugs" page.
- Becoming a maintainer of a kernel subsystem → not planned.
- Upstreaming a Rust driver → kernel-08-rust-for-linux first.
