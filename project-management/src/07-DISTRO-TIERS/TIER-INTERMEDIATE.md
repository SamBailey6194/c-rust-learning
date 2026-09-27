# TIER-INTERMEDIATE — Intermediate Tier

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

| Field | Value |
| --- | --- |
| **Tier** | intermediate |
| **Status** | Draft — hypotheses to research, then test at P6 (words owned by `project-management/src/07-DISTRO-TIERS/CLAUDE.md`) |
| **Driving milestone** | none yet — tier milestones are cut at P5 and P6 |
| **Matrix** | `project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md` → Intermediate column |
| **Date** | 27/09/2026 |

This is a sketch. Every value below is a hypothesis written before any research, labelled
"assumption to test"; none is a decision. It exists now so that P1 to P5 have a concrete
destination, and it is expected to change.

---

## 1. Target user

Someone who uses a terminal every day and has run a mainstream distribution, but has not built one.
They want to understand what their system is doing and change it — partition the disk their way,
choose what runs at boot, read what a package will change before it changes it. They give up when
the system hides a mechanism they want to see, or when documentation says which command to type but
not what it does.

---

## 2. Principles

1. **Show the mechanism, keep the guard rails.** The package manager and the service files are in
   plain view; destructive actions still ask for confirmation.
2. **Explain, then instruct.** Documentation says what a tool does before it says how to use it.
3. **Recovery is a documented skill.** Things will break; the manual says how to fix them from a
   shell.

---

## 3. Axis values

| Axis | Value | Why | Source | Tested by |
| --- | --- | --- | --- | --- |
| Target user | Uses a terminal daily; has run a mainstream distro | The middle tier bridges "uses Linux" and "builds Linux" | assumption to test | H2 |
| Installer | Guided text installer with manual partitioning | The user wants control over layout but not to type every step | assumption to test | H1 |
| Default desktop / shell | Login shell; an optional lightweight window manager | The terminal is home; a graphical session is a choice, not a default | assumption to test | H1 |
| Package-manager exposure | Package manager CLI exposed, with confirmation prompts | Seeing what a transaction changes is part of understanding the system | assumption to test | H2 |
| Init system | Same as beginner, shared on purpose | One init to document and test for the two tiers most likely to meet service files | assumption to test | — (no user-facing difference from beginner) |
| Kernel config + update cadence | Trimmed config for common and virtual hardware; longterm or stable; user-started updates | Fewer drivers to reason about; the user decides when the kernel changes | assumption to test | H3 |
| Documentation & guidance level | Reference manual plus how-tos that explain what each tool does | The user reads to understand, and comes back to look things up | assumption to test | H2 |
| Rescue / recovery tooling | Previous kernel kept; a documented initramfs emergency shell | The user can type a repair if the manual shows them how | assumption to test | H3 |

---

## 4. Hypotheses

```text
H1  Claim:      the installer's manual partitioning produces exactly the layout the user asked for.
    Test:       in QEMU, install to an empty disk image with a written layout (partitions,
                sizes, mount points); after first boot run `lsblk` and `findmnt`.
    Passes if:  the `lsblk` and `findmnt` output matches the written layout on every row.
    Tested at:  P6, the intermediate installer milestone.

H2  Claim:      a user who has run another distro can install, query and remove a package
                using only the tier's manual.
    Test:       in QEMU, with only the manual open, install a named package, list its files,
                then remove it.
    Passes if:  all three succeed, and the manual section used for each is recorded.
    Tested at:  P6, the intermediate package milestone.

H3  Claim:      the documented emergency-shell steps repair a broken root mount.
    Test:       in QEMU, corrupt the root entry in /etc/fstab, reboot, follow the manual
                from the initramfs emergency shell.
    Passes if:  the system boots normally afterwards, and no step outside the manual was needed.
    Tested at:  P6, the intermediate rescue milestone.
```

---

## 5. Kernel config for this tier

Narrower than beginner: common physical hardware plus the virtual devices QEMU presents, on a
longterm or stable branch. Its fragment lives under `code/src/kernel/` (planned — added at P4), and
its build plan and record in `project-management/src/06-KERNEL/` at P5.

---

## 6. Open questions

| Question | Blocks | Where it goes |
| --- | --- | --- |
| Which "common hardware" does the trimmed config cover, and how is that measured without real hardware? | Kernel config + update cadence | research note; the P5 tier-config milestone |
| Does the emergency shell come from the init system's own rescue target or from a hand-built initramfs? | Rescue / recovery tooling; H3 | ADR with the init-system decision |
| Which distro base and package manager? | Package-manager exposure; Installer | `GAPS.md` → "27/09/2026 — Distro build approach undecided"; ADR at P6 (shared with all tiers) |

---

## Cross-references

- `project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md` — this tier's column
- `project-management/src/07-DISTRO-TIERS/TIER-BEGINNER.md`, `TIER-EXPERIENCED.md` — the neighbouring tiers
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6
- `GAPS.md` → "27/09/2026 — Distro tier definitions are hypotheses" — the open question this sketch is the subject of
- `GAPS.md` → "27/09/2026 — Distro build approach undecided" — the distro-base question every axis waits on
