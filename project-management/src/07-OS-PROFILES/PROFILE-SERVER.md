# PROFILE-SERVER — Server Profile (first edition)

**Last Updated**: 27/09/2026 | **Version**: 0.1.0 | **Maintained By**: Sam Bailey
**Language**: British English (en_GB) | **Timezone**: Europe/London

| Field | Value |
| --- | --- |
| **Profile** | server (server family) — the "business server"; part of the first edition with homelab |
| **Status** | Draft — hypotheses to research, then test at P6 (words owned by `project-management/src/07-OS-PROFILES/CLAUDE.md`) |
| **Driving milestone** | none yet — profile milestones are cut at P5 and P6 |
| **Matrix** | `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` → Server column |
| **Date** | 27/09/2026 |

This is a sketch. Every value below is a hypothesis, labelled "assumption to test"; none is a
decision. The server profile is one of seven on one base
(`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`) and,
with homelab, is the **first edition to ship** (`ROADMAP.md` → Critical path). It has no graphical
session (`ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md`).

---

## 1. Target user

Someone running headless services — a web application, a database, a mail relay — who wants them
stable, patched and reachable only over SSH. They manage the machine remotely and expect it to stay
up between deliberate maintenance windows. They give up when an update breaks a service without a
way back, or when the machine exposes something they did not configure.

---

## 2. Principles

1. **Expose the minimum.** SSH in, the services the operator chose out, nothing else.
2. **Updates are safe and reversible.** Security updates apply unattended; a broken update has a
   documented way back.
3. **Everything is a runbook.** Set-up, backup and restore are written down and drilled.

---

## 3. Axis values

| Axis | Value | Why | Source | Tested by |
| --- | --- | --- | --- | --- |
| Target user | Runs headless services and wants them stable and patched | The first-edition user Sam named (Q9 answer: ship server or homelab first) | assumption to test | H1 |
| Installer | Guided text installer; whole-disk or manual | A server operator can partition; the installer need not be graphical | assumption to test | H1 |
| Default desktop / shell | Login shell only; managed over SSH | A server has no display | assumption to test | — |
| Package-manager exposure | CLI exposed; unattended security updates | The operator manages packages; security fixes should not wait | assumption to test | H2 |
| Init system | The base init with service supervision | Services need supervision and dependency ordering | assumption to test | — (shared base init) |
| Kernel config + update cadence | Tuned config; longterm line; unattended security updates | A server values the longest-supported line and fewest surprises | assumption to test | H3 |
| Documentation & guidance level | Reference manual and runbooks | The operator follows and reuses procedures | assumption to test | H1 |
| Rescue / recovery tooling | Previous kernel kept; a documented emergency shell; a restore drill | Recovery has to be practised, not improvised | assumption to test | H4 |
| Network exposure & firewall default | SSH only; host firewall on, deny by default | The smallest attack surface that still lets the operator in | assumption to test | H2 |
| Storage stack | Root plus a data volume; ext4 or Btrfs | Separating data from root makes backup and reinstall cleaner | assumption to test | H4 |
| Hardware target | A business server — VMs and QEMU disk images only until hardware is chosen by ADR | No hardware is chosen yet (Sam's decision after the critique, 27/09/2026) | assumption to test | — |

---

## 4. Hypotheses

```text
H1  Claim:      the server image installs and reaches an SSH login by following the runbook alone.
    Test:       in QEMU on an isolated network, install from the image, then connect over SSH
                from a second guest following the runbook.
    Passes if:  the SSH login succeeds and every command used appears in the runbook.
    Tested at:  P6, the server edition milestone.

H2  Claim:      a freshly installed server exposes only SSH.
    Test:       in QEMU on an isolated network, scan the server from a second guest with nmap
                and run `ss -tulpn` on the server.
    Passes if:  only the SSH port is open; the firewall denies everything else by default.
    Tested at:  P6, the server hardening milestone.

H3  Claim:      an unattended security update applies without operator action and is reversible.
    Test:       in QEMU, stage a security update, let the unattended mechanism apply it, then
                roll back following the runbook.
    Passes if:  the update applies unattended and the rollback returns a working system.
    Tested at:  P6, the server updates milestone.

H4  Claim:      the documented restore drill rebuilds the server from a backup.
    Test:       in QEMU, back up the data volume, destroy the disk image, reinstall and restore
                from the backup following the runbook.
    Passes if:  the restored services run and the data matches, with no step outside the runbook.
    Tested at:  P6, the server backup-and-restore milestone.
```

---

## 5. Kernel config for this profile

A tuned server config on the downstream kernel's longterm line
(`ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`; the line follows
`research/LTS-VS-STABLE-PER-PROFILE.md`, planned). **This is a first-edition fragment**: the base,
server and homelab fragments are P5's exit gate. Its fragment lives in the downstream kernel repository (created in `kernel-05-downstream-tree`
lesson 02; the lesson drafts start under `code/src/kernel/`, planned — added at P4), and its build
plan and record in `project-management/src/06-KERNEL/` at P5.

---

## 6. Open questions

| Question | Blocks | Where it goes |
| --- | --- | --- |
| Which unattended-update mechanism, and how is rollback made reliable? | H3; Package-manager exposure | research note; ADR with the package-manager and update-flow decision |
| Which longterm line, given the services' needs? | Kernel config + update cadence | `research/LTS-VS-STABLE-PER-PROFILE.md` (planned) |
| What hardware the server profile targets | Hardware target | `GAPS.md` Open question; ADR when the topic opens |

---

## Cross-references

- `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` — this profile's column
- `project-management/src/07-OS-PROFILES/PROFILE-HOMELAB.md` — the other first-edition profile
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6, and the critical path
- `project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`
- `GAPS.md` → "Syntek OS profile definitions are hypotheses"
