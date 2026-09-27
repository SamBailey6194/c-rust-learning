# ADR-MS001: Capture library — a standalone repository under GPL-2.0-or-later, shared by the recorder and a second tool

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-CAPTURE-LIBRARY-STANDALONE |
| **Status** | Proposed |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources and crate checks cited below); `research/PRODUCT-OUTBOUND-LICENCE-COMPATIBILITY.md` (planned) grounds the approved list this record picks from |
| **Enforced in** | the capture-library repository's licence and `deny.toml` (created at the recorder's stage 2) · `.claude/skills/teach/FAMILIES.md` |

---

## Context

This record is Sam's answers of 27/09/2026 on where the scripted recorder's screen capture lives,
which backends it covers, and which outbound licence it takes.

Two tools need the same capture backends: the scripted demo recorder
(`ADR-MS001-SCRIPTED-RECORDER-STAGED-LEARNING-PROJECT-27-09-2026.md`) and a second, private tool,
which this public repository does not name or link. Capture here means frames and a damage hint
(which part of the screen changed) and nothing else: the tape language, input injection, the
timeline, captions and encoding belong to the recorder. The backends Sam named are X11; Wayland,
both the wlroots family (Hyprland) and GNOME and KDE through the xdg-desktop-portal ScreenCast
interface and PipeWire; and QEMU/KVM, through QMP, libvirt, VNC and SPICE.

Every product repository picks its outbound licence from the approved list when its build starts
(`ADR-MS001-PRODUCT-LICENCES-APPROVED-OUTBOUND-LIST-27-09-2026.md`), and its components must be
compatible with that pick (`ADR-MS001-PRODUCT-LICENCES-INBOUND-RULES-27-09-2026.md`). The library's
pick is recorded here, as an entry taken under that list rather than as a policy of its own.

Facts checked on 27/09/2026:

- **An or-later GPL library serves both GPL versions.** The FSF's compatibility matrix allows code
  under "GPLv2 or later" to be used by code under GPLv2 only, GPLv2 or later, and GPLv3 or later; it
  also shows that adding GPLv3 code to a GPLv2-or-later work makes the combination GPLv3 (Sources,
  item 1). The FSF licence list notes that GPLv3 is not compatible with GPLv2 by itself (Sources,
  item 2).
- **The backends' crates mostly pass a permissive allow list.** On crates.io: x11rb 0.14.0 and vnc-rs
  0.6.0 are `MIT OR Apache-2.0`; ashpd 0.13.13, zbus 5.19.0, pipewire 0.10.1, reis 0.7.1 and qapi
  0.15.0 are MIT; the libvirt binding `virt` 0.4.3 is LGPL-2.1; `spice-client` 0.2.0 is GPL-3.0; and
  the crate named `hyprland` is GPL-3.0-or-later (Sources, item 3).
- **This repository's allow list is not the library's.** `code/src/rust/deny.toml` allows MIT,
  BSD-2-Clause, BSD-3-Clause, ISC, Zlib, Unicode-3.0 and BSL-1.0 for third-party crates, and rests
  its narrower exceptions on this repository distributing no binaries (Sources, item 4). A product
  repository does distribute, so it keeps its own allow list.
- **The capture sources are separate programs or IPC.** Xvfb, QEMU, the portal services and libvirt's
  daemon are reached as separate processes over a protocol (X11, QMP, RFB, D-Bus), and ffmpeg is fed
  through a pipe; none is linked into the library.

## Options considered

### Option A — Capture inside the recorder's repository

- **Summary:** the recorder keeps its capture code; the second tool copies what it needs.
- **Pros:** One repository to create at stage 2; no interface to keep stable.
- **Cons:** Two copies drift, and each fix lands twice. The second tool would carry the recorder's
  tape and input code it never uses, or a hand-trimmed fork of it.

### Option B — A standalone capture-library repository both tools consume

- **Summary:** a library repository holding the capture trait and one backend per display path; the
  recorder and the second tool depend on it.
- **Pros:** One implementation per backend, tested once. The trait boundary (start, grab, damage hint,
  stop) keeps input and presentation out of capture, which is the recorder's staging seam anyway.
- **Cons:** A third repository to maintain, and a trait that must stay stable for two consumers.

### Option C — The library inside the second tool's repository

- **Summary:** the second, private tool holds the capture code, and the recorder consumes it from there.
- **Pros:** No extra repository.
- **Cons:** A public recorder would depend on code in a repository that is not public, so its
  lessons could not show the capture code they teach.

## Decision

**We will take Option B (Sam's answer of 27/09/2026).** Capture lives in the capture-library
repository, created at the recorder's stage 2 when the capture trait is defined, and consumed by the
recorder and by the second, private tool. Its scope is X11; Wayland (Hyprland and the wlroots family;
GNOME and KDE through the portal and PipeWire); and QEMU/KVM (QMP, libvirt, VNC and SPICE).

**Licence pick: GPL-2.0-or-later** (Sam's answer of 27/09/2026), the approved list's entry for a
library meant to be consumed by products under more than one GPL entry; the capture library is its
first user. The deciding factor for the or-later wording is that consumers under GPL-2.0-only and
under GPL-3.0-or-later can both link it (Sources, item 1).

The deciding factor for Option B is that the backends are the expensive, subtle part of both tools,
and one tested implementation beats two drifting ones. Option A was the runner-up, because it defers
the repository, and lost because it makes the second tool depend on a copy.

This answer changes if a planned consumer needs terms the GPL-2.0-or-later entry cannot give it, or if
the two tools' needs diverge so far that the shared trait costs more than it saves; either is argued
in a new ADR.

## Consequences

- **Positive:** Each backend is written and tested once. The staging of the recorder carries over
  unchanged: each backend stage adds one implementation of the library's trait, and the recorder
  adds the matching input.
- **Negative:** Components are narrowed by the pick. A GPL-3.0 crate (`spice-client`, the `hyprland`
  crate) or an Apache-2.0-only crate would take the combined library to GPLv3 terms and shut out a
  GPL-2.0-only consumer, so none is used; the LGPL-2.1 `virt` crate and any SPICE binding crate need
  an allow-list decision in the library's own `deny.toml` before they enter.
- **For every consumer:** a program distributed as a binary that links the library is covered by the
  GPL as a whole, so its own licence must be GPL-compatible; an approved-list entry that admits no
  copyleft component in a shipped binary cannot link the library at all. This is a reading of the
  licences, not legal advice.
- **No DRM/KMS backend, ever.** DRM/KMS capture is learning-only under the staging record, so the
  library never gains it and no consumer ships it.
- **Follow-on:**
  - The approved-list ADR carries the GPL-2.0-or-later entry, added in the same round as this record.
  - `.claude/skills/teach/FAMILIES.md` names the placeholder "the capture-library repository"; the
    second tool gets no placeholder at all.
  - `learning/tooling-05-licensing-and-collaboration/` lessons 01, 02 and 05 come before the
    repository is created, and lesson 08 (software bills of materials) before its first release,
    which ships an SBOM under `ADR-MS001-PRODUCT-COMPONENT-REGISTER-SPDX-SBOM-27-09-2026.md`.
  - Before this record is Accepted, Sam confirms the consumer consequence above for every planned
    consumer.

## Sources

1. **FSF, Frequently Asked Questions about the GNU Licenses** — compatibility matrix,
   <https://www.gnu.org/licenses/gpl-faq.html#AllCompatibility> — gnu.org did not answer on
   27/09/2026, so read through
   <https://web.archive.org/web/20260927055157/https://www.gnu.org/licenses/gpl-faq.html>
2. **FSF, Various licenses and comments about them** — <https://www.gnu.org/licenses/license-list.html>
   — GPLv3 not compatible with GPLv2 by itself; read through
   <https://web.archive.org/web/20260927045041/https://www.gnu.org/licenses/license-list.html> on
   27/09/2026
3. **crates.io API** — `https://crates.io/api/v1/crates/<name>` for x11rb, vnc-rs, ashpd, zbus,
   pipewire, reis, qapi, virt, spice-client and hyprland — latest versions and licence fields, checked
   27/09/2026
4. **`code/src/rust/deny.toml`** — the licence allow list and its "distributes no binaries" reasoning,
   read 27/09/2026
5. **Sam's answers of 27/09/2026** — a standalone capture library consumed by both tools, its backend
   scope, and its GPL-2.0-or-later licence
