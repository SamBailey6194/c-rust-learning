# TIER-{NAME} — {Tier Title}

_Template — copy to `TIER-<NAME>.md`, replace every `{PLACEHOLDER}`, delete the `[EXAMPLE]` rows.
One distribution tier: who it is for, the principles that decide its trade-offs, its value on every
axis of `TIER-MATRIX.md` with a reason and a test, and the hypotheses a QEMU boot can pass or fail.
Values are hypotheses until an ADR decides them or a P6 test confirms them._

| Field | Value |
| --- | --- |
| **Tier** | {beginner / intermediate / experienced} |
| **Status** | {Draft / Specified / Verified} — words owned by `project-management/src/07-DISTRO-TIERS/CLAUDE.md` |
| **Driving milestone** | {`MS###` — short title, or "none yet"} |
| **Matrix** | `project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md` → {tier} column |
| **Date** | {DD/MM/YYYY} |

---

## 1. Target user

{A paragraph in the learner's own words, from the explain-first step: who this person is, what they
already know, what they want from the system, and what would make them give up.}

---

## 2. Principles

The rules of thumb that decide a trade-off when two axes pull against each other.

1. {PLACEHOLDER — e.g. "A default that is safe beats a choice the user is not ready to make."}
2. {PLACEHOLDER}
3. {PLACEHOLDER}

---

## 3. Axis values

One row per axis, spelt exactly as in `TIER-MATRIX.md`. The **Value** cell is copied into the
matrix word for word. **Source** is a research note, a primary source, an ADR — or
"assumption to test".

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

Where two tiers share a value, say so in **Why** ("shared on purpose with ...").

---

## 4. Hypotheses

Every axis that claims a user-facing difference has at least one. Each names the claim, the QEMU
observation that tests it, the pass condition and the phase that tests it.

```text
[EXAMPLE]
H1  Claim:      a first-time user reaches a working shell from first boot by following
                only the on-screen text.
    Test:       boot the tier image with qemu-system-x86_64 on a serial console
                (-nographic, console=ttyS0); read nothing but the screen.
    Passes if:  a shell prompt appears and `uname -r` prints the tier kernel's release.
    Tested at:  P6, the milestone that first boots this tier's image.
```

---

## 5. Kernel config for this tier

{How this tier's kernel differs from the others, and where its fragment will live —
`code/src/kernel/` (planned — added at P4). The build plan and record are in
`project-management/src/06-KERNEL/`.}

---

## 6. Open questions

| Question | Blocks | Where it goes |
| --- | --- | --- |
| {PLACEHOLDER} | {which axis or hypothesis} | {research note / ADR / `GAPS.md` open question} |

---

## Cross-references

- `project-management/src/07-DISTRO-TIERS/TIER-MATRIX.md` — this tier's column
- `project-management/src/01-ROADMAP/ROADMAP.md` — P5 and P6
- `project-management/src/08-DECISIONS/` — ADRs this tier cites
- `research/` — notes this tier cites
