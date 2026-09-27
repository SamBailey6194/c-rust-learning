# PROFILE-{NAME} — {Profile Title}

_Template — copy to `PROFILE-<NAME>.md`, replace every `{PLACEHOLDER}`, delete the `[EXAMPLE]` rows.
One Syntek OS profile: who it is for, the principles that decide its trade-offs, its value on every
one of the eleven axes of `PROFILE-MATRIX.md` with a reason and a test, and the hypotheses a QEMU
boot can pass or fail. Values are hypotheses until an ADR decides them or a P6 test confirms them.
All profiles share one base (`project-management/src/08-DECISIONS/ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE-27-09-2026.md`)._

| Field | Value |
| --- | --- |
| **Profile** | {beginner / intermediate / expert (desktop) — or server / nas / homelab / router (server family)} |
| **Status** | {Draft / Specified / Verified} — words owned by `project-management/src/07-OS-PROFILES/CLAUDE.md` |
| **Driving milestone** | {`MS###` — short title, or "none yet"} |
| **Matrix** | `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` → {profile} column |
| **Date** | {DD/MM/YYYY} |

---

## 1. Target user

{A paragraph in the learner's own words, from the explain-first step: who this person is, what they
already know, what they want from the system, and what would make them give up.}

---

## 2. Principles

The rules of thumb that decide a trade-off when two axes pull against each other.

1. {PLACEHOLDER}
2. {PLACEHOLDER}
3. {PLACEHOLDER}

---

## 3. Axis values

One row per axis, spelt exactly as in `PROFILE-MATRIX.md`. The **Value** cell is copied into the
matrix word for word. **Source** is a research note, a primary source, an ADR — or "assumption to
test".

| Axis | Value | Why | Source | Tested by |
| --- | --- | --- | --- | --- |
| Target user | {...} | {...} | {...} | {H#} |
| Installer | {...} | {...} | {...} | {H#} |
| Default desktop / shell | {...} | {...} | {...} | {H#} |
| Package-manager exposure | {...} | {...} | {...} | {H#} |
| Init system | {...} | {...} | {...} | {H#} |
| Kernel config + update cadence | {...} | {...} | {...} | {H#} |
| Documentation & guidance level | {...} | {...} | {...} | {H#} |
| Rescue / recovery tooling | {...} | {...} | {...} | {H#} |
| Network exposure & firewall default | {...} | {...} | {...} | {H#} |
| Storage stack | {...} | {...} | {...} | {H#} |
| Hardware target | {...} | {...} | {...} | {H#} |

Where two profiles share a value, say so in **Why** ("shared on purpose with ...").

---

## 4. Hypotheses

Every axis that claims a user-facing difference has at least one. Each names the claim, the QEMU
observation that tests it, the pass condition and the phase that tests it.

```text
[EXAMPLE]
H1  Claim:      a first-time user reaches a working session from first boot by following
                only the on-screen text.
    Test:       boot the profile image with qemu-system-x86_64 on a serial console
                (-nographic, console=ttyS0); read nothing but the screen.
    Passes if:  a shell prompt appears and `uname -r` prints the profile kernel's release.
    Tested at:  P6, the milestone that first boots this profile's image.
```

---

## 5. Kernel config for this profile

{How this profile's kernel differs from the others, and where its fragment will live — the
downstream kernel repository (created in `kernel-05-downstream-tree` lesson 02; lesson drafts start
under `code/src/kernel/`, planned — added at P4)
(`project-management/src/08-DECISIONS/ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`). Say
whether it is a first-edition fragment (base, server, homelab) or a Later one. The build plan and
record are in `project-management/src/06-KERNEL/`.}

---

## 6. Open questions

| Question | Blocks | Where it goes |
| --- | --- | --- |
| {PLACEHOLDER} | {which axis or hypothesis} | {research note / ADR / `GAPS.md` open question} |

---

## Cross-references

- `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` — this profile's column
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6
- `project-management/src/08-DECISIONS/` — ADRs this profile cites
- `research/` — notes this profile cites
