# GAPS.md — Active Gaps, Blockers & Open Questions

**Last Updated**: 27/09/2026 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB)

Tracks what currently stands between c-rust-learning and its next phases: missing tools,
knowledge gaps, blocked milestones and open questions. **Not** a memory store — feedback,
patterns and observations go in `.claude/MEMORY.md`. Topics deliberately parked for a later
phase go in `DEFERRED.md`.

Resolved entries are marked `✅ CLOSED <date>` and removed on the next tidy pass. A permanent
decision that comes out of an entry is promoted to the doc that owns it — the promotion table is
in `.claude/CLAUDE.md` Section 7, which owns that workflow; it is not restated here.

**Read when planning.** Check this file before a milestone is opened or planned
(`project-management/workflows/02-milestone-creation/`, `09-milestone-plans/`), so a known blocker
is scheduled around rather than discovered mid-milestone.

## Format

Append a new entry at the top, newest first:

```text
## DD/MM/YYYY — <title>

**Type:** <Toolchain gap | Knowledge gap | Blocked milestone | Open question>
**Summary:** …
**Blocked by / Action:** …
```

---

## 27/09/2026 — Sibling repository reboot-purge not yet published — ✅ CLOSED 27/09/2026

**Resolution:** reboot-purge was published at <https://github.com/SamBailey6194/reboot-purge> on
27/09/2026. The "(not yet published)" markers are gone and `how-to/src/HOST-MAINTENANCE.md` carries
its feature signpost again. The host upgrade in Step 4 still runs by hand, because reboot-purge's
interactive upgrade script is on its roadmap and not yet built.

**Type:** Toolchain gap
**Summary:** The how-to layer routes host maintenance (health checks, cleanup, routine
`apt upgrade`) to the sibling repository <https://github.com/SamBailey6194/reboot-purge>, but that
repository has not been published: the URL returns 404 (checked 27/09/2026). Until it exists, every
link to it is marked "(not yet published)" and the host upgrade in
`how-to/workflows/04-toolchain-updates/` Step 4 runs by hand.
**Blocked by / Action:** Publish reboot-purge, public and with at least its README, before this
repository goes public. Then remove the "(not yet published)" markers in `how-to/`, restore the
feature summary in `how-to/src/HOST-MAINTENANCE.md` from its README, and close this entry.

## 27/09/2026 — pahole minimum for P4 is unclear

**Type:** Open question
**Summary:** The kernel's minimal-requirements page (<https://docs.kernel.org/process/changes.html>,
read 27/09/2026) gives two different pahole minimums: its requirements table lists pahole **1.26**,
while its pahole paragraph says BTF generation under `CONFIG_DEBUG_INFO_BTF` needs **v1.22 or
later**. Ubuntu 24.04's `dwarves` package provides pahole **1.25** (`apt-cache policy dwarves`:
candidate `1.25-0ubuntu3`), which satisfies the paragraph but not the table.
**Blocked by / Action:** Settle before the first P4 milestone is planned: with a kernel tree
fetched, read the version check in its own build scripts for the release being built, and try a
build with the P4 config. If 1.25 is refused, choose between disabling `CONFIG_DEBUG_INFO_BTF` in
the P4 config and building pahole from source; record the answer in `how-to/docs/TOOLCHAIN.md`
and the P4 kernel plan, then close this entry.

## 27/09/2026 — Kernel build dependencies not installed

**Type:** Toolchain gap
**Summary:** Building a kernel needs host tools the machine does not have yet. `flex` and `bison`
generate the kernel's lexers and parsers during the build (required since Linux 4.16);
`libelf-dev` supplies libelf, which objtool — built and run during a typical x86_64 kernel
build — links against; `dwarves` supplies `pahole`, which generates BTF type information when
`CONFIG_DEBUG_INFO_BTF` is enabled (the minimum is itself open: see "pahole minimum for P4 is
unclear" above). Already present: `bc`, `cpio`, `busybox-static`,
`libssl-dev`, `libncurses-dev`.
**Blocked by / Action:** Blocks **P4** (kernel internals). Install before the first P4 milestone
is planned — `sudo apt install flex bison libelf-dev dwarves` — record the versions in
`how-to/docs/TOOLCHAIN.md`, then close this entry.

## 27/09/2026 — Rust-for-Linux needs clang/LLVM and bindgen

**Type:** Toolchain gap
**Summary:** The kernel's Rust support is built with a full LLVM toolchain (`make LLVM=1`); the
kernel documentation calls a GCC build of it "very experimental". It also needs `libclang`,
`bindgen` and the `rust-src` component, and a `rustc` the kernel accepts
(<https://docs.kernel.org/rust/quick-start.html>). clang, LLVM and bindgen are not installed;
the pinned workspace toolchain (`code/src/rust/rust-toolchain.toml`) installs rustfmt and clippy
only.
**Blocked by / Action:** Blocks the **P4 Rust-for-Linux track** only — the C module track is
unaffected. Before that milestone: install clang/LLVM and bindgen, add `rust-src` to the kernel
build's toolchain, and run `make LLVM=1 rustavailable` in the kernel tree (which reports exactly
what is missing). Record the versions in `how-to/docs/TOOLCHAIN.md`.

## 27/09/2026 — Distro build approach undecided

**Type:** Open question
**Summary:** How the three distro tiers are built is not yet chosen: from scratch in the style
of Linux From Scratch, with a build system such as Buildroot or the Yocto Project, or derived
from a Debian-based system. The choice shapes the rootfs, package management and installer work
in every tier.
**Blocked by / Action:** Blocks **P6** planning. Answer it with a `/research` note in `research/`
comparing the options against the tier specs in `project-management/src/07-DISTRO-TIERS/`, then
record the decision as an ADR in `project-management/src/08-DECISIONS/` before the first P6
milestone.

## 27/09/2026 — Distro tier definitions are hypotheses

**Type:** Open question
**Summary:** `TIER-BEGINNER.md`, `TIER-INTERMEDIATE.md` and `TIER-EXPERIENCED.md` in
`project-management/src/07-DISTRO-TIERS/` were drafted before any kernel or distro work was
done. What separates the tiers (`TIER-MATRIX.md`) is a first guess, not a finding.
**Blocked by / Action:** Revisit at the P5 exit, with the kernel configs in hand, and again when
P6 is planned. Revise the specs through `project-management/workflows/07-distro-tier-spec/`;
close this entry once the matrix has been checked against real builds.
