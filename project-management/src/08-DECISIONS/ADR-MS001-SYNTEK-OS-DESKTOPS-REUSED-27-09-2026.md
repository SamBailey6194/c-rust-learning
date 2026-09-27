# ADR-MS001: Syntek OS — reuse existing desktop environments; write no desktop of its own

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources cited below) |
| **Enforced in** | `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` → Default desktop / shell · `project-management/src/07-OS-PROFILES/PROFILE-BEGINNER.md`, `PROFILE-INTERMEDIATE.md`, `PROFILE-EXPERT.md` |

---

## Context

The desktop profiles (beginner, intermediate and expert —
`ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`) need a graphical session; the server
family (server, NAS, homelab, router) does not. The scaffold's beginner tier left "a graphical
session, if feasible and testable" as an open question.

In his planning conversation of 27/09/2026 (Q11), Sam said he is happy to use existing GUIs, and
that friends and family could build the custom tools. The answer suggested candidates per profile:
KDE Plasma or GNOME for beginners, Xfce or COSMIC for intermediate users, a Wayland tiling compositor
such as Sway or Hyprland for experts, none for the server family, and perhaps a web dashboard for the
NAS and router.

Facts checked on 27/09/2026:

- **Beyond Linux From Scratch 13.1 (systemd)** — the book the OS track follows after LFS — has parts
  for KDE (Frameworks 6 and Plasma), GNOME (including gnome-shell 50.4), Xfce (including Xfdesktop
  4.20.2) and LXQt, and packages the Wayfire compositor (Sources, item 1). It has no instructions for
  COSMIC, Sway or Hyprland, so those would need recipes Syntek OS writes itself.
- **The candidates describe themselves** as: Xfce, a lightweight desktop environment aiming to be
  fast and low on resources (Sources, item 2); COSMIC, a Wayland-native desktop environment built in
  Rust (Sources, item 3); Sway, a tiling Wayland compositor and drop-in replacement for i3 (Sources,
  item 4); Hyprland, a dynamic-tiling Wayland compositor (Sources, item 5); KDE Plasma and GNOME, the
  two full desktops (Sources, items 6 and 7).
- **Syntek OS's custom effort is already committed elsewhere:** the package manager, installer, file
  manager and system tools (`ADR-MS001-SYNTEK-OS-TOOLS-RUST-TUI-FIRST-27-09-2026.md`), on top of the
  kernel, the OS build and the model.

## Options considered

### Option A — Reuse existing desktops, one family per desktop profile

- **Summary:** Package and configure existing desktop environments and compositors; each desktop
  profile ships the one that suits its user; the server family ships none.
- **Pros:** The effort goes into packaging, integration and defaults — distribution work — rather
  than into a desktop. Users meet a desktop that has documentation and a community.
- **Cons:** Large dependency trees to build and keep patched (Plasma and GNOME especially). Where
  BLFS has no instructions (COSMIC, Sway, Hyprland), Syntek OS writes and maintains the recipe.

### Option B — Write Syntek OS's own desktop shell or compositor

- **Summary:** A custom Wayland compositor and shell.
- **Pros:** A distinctive product; deep Wayland learning.
- **Cons:** Competes for the same years as the kernel, the OS and the model; no user benefits until
  it is complete.

### Option C — No graphical session in any profile

- **Summary:** TUI-only across all seven profiles.
- **Pros:** The smallest build; everything testable over a serial console.
- **Cons:** Contradicts the beginner profile's purpose and Sam's own list of desktop editions.

### Option D — One desktop for all three desktop profiles

- **Summary:** Choose one environment and vary only its defaults.
- **Pros:** One desktop stack to build and patch.
- **Cons:** An expert who wants a tiling compositor and a beginner who wants a conventional desktop
  are served by different software, which is why the profiles exist.

## Decision

**We will take Option A: Syntek OS reuses existing desktop environments and compositors, chosen per
desktop profile, and the server family ships no graphical session.** The deciding factor is where
the custom effort goes: into the tools and the distribution, not into re-creating a desktop. Option
D was the runner-up for its smaller build, and lost because the profiles' users want different
desktops.

This answer changes only if no existing desktop can meet a profile's needs, which would be argued in
a new ADR.

## Consequences

- **Positive:** The beginner profile's open question ("is a graphical session feasible?") becomes a
  packaging question with BLFS instructions behind it. The graphics stack is taught once
  (`os-15-desktop-editions`) and cited by the GUI lessons.
- **Negative:** Desktop stacks are the largest part of any desktop profile's package set; security
  tracking across them is a real cost.
- **Follow-on:**
  - To confirm — the exact desktop per profile (beginner KDE Plasma or GNOME; intermediate Xfce or
    COSMIC; expert Sway or Hyprland) was the conversation's suggestion. Each profile file lists the
    candidates as a Draft value; the choice is made when `os-15-desktop-editions` opens, by an ADR
    per profile if it is hard to reverse.
  - To confirm — a web dashboard for the NAS and router profiles is taught in
    `ui-10-web-admin-dashboard`; whether those profiles ship one is decided there.
  - Desktop-profile work is Later on `ROADMAP.md`'s critical path; the first edition (server and
    homelab) needs none of it.

## Sources

1. **Beyond Linux From Scratch 13.1 (systemd), table of contents** —
   <https://www.linuxfromscratch.org/blfs/view/stable-systemd/> — the KDE, GNOME, Xfce and LXQt parts
   and the Wayfire package; no COSMIC, Sway or Hyprland, checked 27/09/2026
2. **Xfce** — <https://www.xfce.org/>, checked 27/09/2026
3. **COSMIC (System76)** — <https://system76.com/cosmic>, checked 27/09/2026
4. **Sway** — <https://swaywm.org/>, checked 27/09/2026
5. **Hyprland** — <https://hypr.land/>, checked 27/09/2026
6. **KDE Plasma** — <https://kde.org/plasma-desktop/>, checked 27/09/2026
7. **GNOME** — <https://www.gnome.org/>, checked 27/09/2026
8. **Sam's planning conversation, 27/09/2026** — Q11 (the decision and the suggested candidates)
