# ADR-MS001: Syntek OS — an independent distribution built from scratch, not derived from another

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-SYNTEK-OS-INDEPENDENT-FROM-SCRATCH |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources cited below); the init choice follows in `research/INIT-SYSTEM-CHOICE.md` (planned) |
| **Enforced in** | `project-management/src/01-ROADMAP/ROADMAP.md` → P6 · `project-management/src/07-OS-PROFILES/` · the Syntek OS build-system repository (created when its build starts) |

---

## Context

The scaffold left open how the distribution would be built: from scratch in the Linux From Scratch
style, with a build system such as Buildroot or the Yocto Project, or derived from a Debian-family
base. `GAPS.md` recorded it as "Distro build approach undecided", blocking P6 planning.

In his planning conversation of 27/09/2026 (Q10), Sam settled it: Syntek OS is not a fork of NixOS
(or anything else); he wants a clean distribution. Earlier (Q1) he had asked how to build his own
distribution on the kernel, and (Q9) listed the editions he wants.

Facts checked on 27/09/2026:

- **Linux From Scratch** gives step-by-step instructions for building a customised Linux system
  from source (Sources, item 1). LFS 13.1 was released on 01/09/2026 with binutils 2.47, GCC 16.2.0
  and glibc 2.44; only the systemd edition is maintained, and the System V edition remains at 12.4
  (Sources, item 2). Its companion, Beyond LFS 13.1 (systemd), covers the desktop stacks, including
  KDE Plasma, GNOME, Xfce and LXQt (Sources, item 3).
- **Independent distributions own their package format and tools.** Arch's pacman combines a simple
  binary package format (a bsdtar archive) with the Arch build system (Sources, item 4); Alpine has
  its own apk (Sources, item 5), Void its own XBPS (Sources, item 6), Gentoo its own Portage (Sources,
  item 7).
- **Buildroot** targets embedded systems and deliberately does not generate binary packages that can
  be installed on a running target (its manual's FAQ, Section 11.7), so a distribution with a package
  manager would be fighting its design (Sources, item 8).
- **The Yocto Project** helps developers create custom Linux-based systems for embedded products
  (Sources, item 9) — powerful, but its layers and BitBake recipes are a framework to learn in their
  own right, and its target is embedded devices rather than desktops, servers and a NAS.
- **A derived base** (for example a Debian system installed with debootstrap, Sources, item 10)
  inherits that distribution's package manager, release cadence and decisions.
- **Ideas worth borrowing without deriving.** NixOS configures a whole system declaratively and
  keeps previous configurations in the boot menu so the user can roll back to one (Sources, item
  11); Reproducible Builds defines an independently verifiable path from source to binary, with
  `SOURCE_DATE_EPOCH` as the standard timestamp variable (Sources, items 12 and 13).

## Options considered

### Option A — From scratch: LFS, then BLFS, then an automated build system

- **Summary:** Build a first system by hand from the LFS 13.1 systemd book in a VM, extend it with
  BLFS, then turn the book steps into recipes and a build system of Syntek OS's own, with its own
  package format, package manager and signed repositories.
- **Pros:** Every layer is understood because every layer was built. Nothing is inherited that has
  to be un-learned. The package manager becomes a Rust project that fits the P3 and U2 work.
- **Cons:** The most work of any option, and the maintenance never ends: every package is Syntek
  OS's to update and track for security fixes. LFS is not a distribution; the automation is Sam's to
  design.

### Option B — Buildroot

- **Summary:** Generate a root filesystem image from a menuconfig.
- **Pros:** Fast to a bootable image; excellent for small, fixed systems such as a router.
- **Cons:** No binary packages on the target by design — at odds with a distribution that installs
  and updates packages.

### Option C — The Yocto Project

- **Summary:** Build a custom distribution with BitBake and layers.
- **Pros:** Industrial-strength reproducibility and cross-building.
- **Cons:** A large framework whose own concepts come before the operating system's; aimed at
  embedded products.

### Option D — Derive from Debian or Arch

- **Summary:** Start from an existing base system and customise it.
- **Pros:** Thousands of packages and security tracking on day one.
- **Cons:** Not independent: the package manager, the release model and most decisions are
  inherited. Contradicts the decision Sam made in Q10.

### Option E — Derive from NixOS

- **Summary:** Build Syntek OS as a NixOS configuration or fork, using Sam's existing Nix
  experience.
- **Pros:** Declarative configuration and rollback come for free; Sam already knows Nix.
- **Cons:** It is a fork or a configuration of NixOS, which Sam ruled out in Q10.

## Decision

**We will take Option A: Syntek OS is an independent distribution, built from scratch — LFS, then
BLFS, then an automated build system of its own.** The deciding factor is Sam's requirement of a
clean distribution (Q10): only Option A owns every layer above the kernel. Buildroot was the
runner-up for the router profile's style of image, and lost because Syntek OS needs a package
manager on the running system.

The learning build follows the LFS 13.1 systemd book (Sam's decision after the critique,
27/09/2026). **Syntek OS's own init system is chosen later**, by an ADR fed by the
INIT-SYSTEM-CHOICE research note; writing a minimal init in C remains a lesson
(`os-06-init-and-services`).

This answer changes only if the maintenance cost proves unsustainable for the first edition (for
example, security tracking across the package set cannot keep pace), which would be argued in a new
ADR.

## Consequences

- **Positive:** Closes the open question in `GAPS.md` ("Distro build approach undecided"). The OS
  track's first half is concrete and well documented (the LFS and BLFS books). The package manager
  and repository signing become real projects rather than configuration.
- **Negative:** Every package is Syntek OS's to build, update and track. A non-systemd Syntek OS
  would depart from the maintained LFS book at system configuration.
- **Follow-on:**
  - To confirm — borrowing ideas without a base (declarative system configuration, reproducible
    builds, atomic upgrade and rollback) was the conversation's recommendation; each is taught in
    the OS track (`os-05-build-system-and-reproducibility`, `os-07-package-manager`,
    `os-10-profiles-and-installer`) and adopted by its own ADR when designed.
  - `DEFERRED.md` carries the entry for Syntek OS's own init choice; `research/INIT-SYSTEM-CHOICE.md`
    (planned) feeds that ADR.
  - The Syntek OS build system, package manager and installer live in the Syntek OS build-system,
    package-manager and installer repositories when their builds start
    (`ADR-MS001-ROADMAP-KERNEL-OS-UI-LLM-TRACKS-27-09-2026.md`).

## Sources

1. **Linux From Scratch** — <https://www.linuxfromscratch.org/lfs/> — what LFS is, checked
   27/09/2026
2. **LFS news** — <https://www.linuxfromscratch.org/news.html> — LFS 13.1 released 01/09/2026 and its
   toolchain versions; the System V edition held at 12.4; also the 13.1-systemd book at
   <https://www.linuxfromscratch.org/lfs/view/stable-systemd/>, checked 27/09/2026
3. **Beyond Linux From Scratch 13.1 (systemd)** —
   <https://www.linuxfromscratch.org/blfs/view/stable-systemd/> — the KDE, GNOME, Xfce and LXQt
   parts, checked 27/09/2026
4. **ArchWiki, pacman** — <https://wiki.archlinux.org/title/Pacman> — pacman's package format and
   build system, checked 27/09/2026
5. **Alpine Linux documentation, apk** —
   <https://docs.alpinelinux.org/user-handbook/0.1a/Working/apk.html>, checked 27/09/2026
6. **The Void Linux Handbook, XBPS** — <https://docs.voidlinux.org/xbps/index.html>, checked
   27/09/2026
7. **Gentoo Handbook (AMD64)** — <https://wiki.gentoo.org/wiki/Handbook:AMD64> — Portage, checked
   27/09/2026
8. **The Buildroot user manual** — <https://buildroot.org/downloads/manual/manual.html> — Section
   11.7, why Buildroot does not generate binary packages, checked 27/09/2026
9. **Yocto Project overview** — <https://docs.yoctoproject.org/overview-manual/yp-intro.html>,
   checked 27/09/2026
10. **Debian wiki, Debootstrap** — <https://wiki.debian.org/Debootstrap>, checked 27/09/2026
11. **NixOS manual** — <https://nixos.org/manual/nixos/stable/> — declarative configuration and
    rolling back, checked 27/09/2026
12. **Reproducible Builds** — <https://reproducible-builds.org/>, checked 27/09/2026
13. **Reproducible Builds, `SOURCE_DATE_EPOCH`** —
    <https://reproducible-builds.org/docs/source-date-epoch/>, checked 27/09/2026
14. **Sam's planning conversation, 27/09/2026** — Q10 (the decision), Q1 and Q9 (context)
