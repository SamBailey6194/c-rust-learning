# TIER-EXPERIENCED — Experienced Tier

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

| Field | Value |
| --- | --- |
| **Tier** | experienced |
| **Status** | Draft — hypotheses to research, then test at P6 (words owned by `project-management/src/07-DISTRO-TIERS/CLAUDE.md`) |
| **Driving milestone** | none yet — tier milestones are cut at P5 and P6 |
| **Matrix** | `project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md` → Experienced column |
| **Date** | 27/09/2026 |

This is a sketch. Every value below is a hypothesis written before any research, labelled
"assumption to test"; none is a decision. It exists now so that P1 to P5 have a concrete
destination, and it is expected to change. Of the three tiers it is the closest to what the learner
builds anyway in P4 and P5, which makes it the likeliest to be finished first.

---

## 1. Target user

Someone who builds software from source, reads kernel configs and init scripts, and wants to know
and control every component on the system. They want a small, legible base they assemble
themselves. They give up when the system does something they did not ask for, or when a component
cannot be rebuilt or replaced.

---

## 2. Principles

1. **Nothing runs that the user did not choose.** The default system starts the minimum needed to
   reach a shell.
2. **Every component can be rebuilt from what is documented.** The kernel, the init and the
   packages come with the commands that produce them.
3. **Document the what, trust the user with the why.** Reference over tutorial.

---

## 3. Axis values

| Axis | Value | Why | Source | Tested by |
| --- | --- | --- | --- | --- |
| Target user | Builds from source; reads kernel configs and init scripts | The tier the learner will themselves have become by P6 | assumption to test | H1 |
| Installer | No installer: a documented manual install | Doing each install step by hand is the point for this user | assumption to test | H1 |
| Default desktop / shell | Login shell only | Anything more is the user's choice to add | assumption to test | H3 |
| Package-manager exposure | Fully exposed, including building packages from source | The user wants to see and change how packages are made | assumption to test | H2 |
| Init system | A minimal init (candidates: busybox init or the P5 C init) | A small init the user can read end to end; reuses P5 work | assumption to test | H3 |
| Kernel config + update cadence | Minimal config the user rebuilds; stable branch; user builds each update | The user owns the kernel config and decides every change | assumption to test | H2 |
| Documentation & guidance level | Terse reference: man pages and one handbook | The user looks things up rather than follows along | assumption to test | H1 |
| Rescue / recovery tooling | Busybox rescue shell in the initramfs; recovery documented, done by hand | The user can repair from a shell; the tier provides the shell and the notes | assumption to test | H1 |

---

## 4. Hypotheses

```text
H1  Claim:      the system can be installed by following the manual-install document alone.
    Test:       boot the live initramfs in QEMU with an empty disk image attached; follow the
                document to partition, populate and make the disk bootable; power off; boot
                QEMU from the disk alone, without -kernel or -initrd.
    Passes if:  the disk boots to a login prompt, and every command typed appears in the document.
    Tested at:  P6, the experienced installer milestone.

H2  Claim:      rebuilding and booting a changed kernel takes only the documented commands.
    Test:       in QEMU, change one option in the tier's kernel fragment, rebuild with the
                documented commands, reboot.
    Passes if:  `uname -v` shows the new build, and the changed option is visible in
                /proc/config.gz (needs CONFIG_IKCONFIG and CONFIG_IKCONFIG_PROC).
    Tested at:  P6, the experienced kernel-update milestone.

H3  Claim:      the default system starts no service the user did not enable.
    Test:       boot the image in QEMU; run `ps` at the first prompt.
    Passes if:  every user-space process listed is init, the login or shell, or one the
                documentation names as enabled by default.
    Tested at:  P6, the experienced init milestone.
```

---

## 5. Kernel config for this tier

The smallest of the three: a minimal config (a trimmed `defconfig`, or built up from `tinyconfig`)
for QEMU's virtual hardware, which the user is expected to rebuild. Its fragment lives under
`code/src/kernel/` (planned — added at P4), and its build plan and record in
`project-management/src/06-KERNEL/` at P5.

---

## 6. Open questions

| Question | Blocks | Where it goes |
| --- | --- | --- |
| Does the experienced tier ship a binary package repository at all, or only build recipes? | Package-manager exposure; H2 | ADR with the package-manager decision |
| Which bootloader makes H1's "boot from the disk alone" step documentable in a few commands? | Installer; H1 | research note, then ADR |
| busybox init or the hand-written P5 C init as the default? | Init system; H3 | ADR at P6, after the P5 init milestone |
| Which distro base? | every axis | `GAPS.md` → "27/09/2026 — Distro build approach undecided"; ADR at P6 (shared with all tiers) |

---

## Cross-references

- `project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md` — this tier's column
- `project-management/src/07-DISTRO-TIERS/TIER-INTERMEDIATE.md` — the neighbouring tier
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6
- `GAPS.md` → "27/09/2026 — Distro tier definitions are hypotheses" — the open question this sketch is the subject of
- `GAPS.md` → "27/09/2026 — Distro build approach undecided" — the distro-base question every axis waits on
