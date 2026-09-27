# ADR-MS001: Syntek OS — seven profiles on one base, compared on eleven axes

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-SYNTEK-OS-PROFILES-ON-ONE-BASE |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — |
| **Superseded by** | — |
| **Research** | — (primary sources cited below); the profile definitions are researched in `research/SYNTEK-OS-PROFILE-DEFINITIONS.md` (planned) |
| **Enforced in** | `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md` (the axis set and the seven columns) · every `project-management/src/07-OS-PROFILES/PROFILE-<NAME>.md` · `project-management/src/07-OS-PROFILES/CLAUDE.md` (keep seven profiles) |

---

## Context

The scaffold specified three "distro tiers" — beginner, intermediate and experienced — compared on
eight fixed axes: target user, installer, default desktop or shell, package-manager exposure, init
system, kernel config and update cadence, documentation and guidance level, and rescue and recovery
tooling. All three were Draft hypotheses.

In his planning conversation of 27/09/2026 Sam widened the set (Q9): beginner, intermediate and
expert systems for laptops and PCs, and server, NAS, homelab and router versions. He then said which
desktops each desktop profile could reuse and that the server family needs none (Q11). The
conversation's answers recommended treating the editions as profiles of one base, with one build
system and one package set so a fix reaches every edition, and shipping one edition first — server
or homelab (Q9 and Q10 answers).

Facts that shape the choice, checked on 27/09/2026:

- **The kernel differs by profile through configuration, not source.** The kernel ships
  `scripts/kconfig/merge_config.sh`, which merges a list of config fragments (Sources, item 1), and
  in-tree fragments such as `kernel/configs/hardening.config`, described as basic hardening,
  self-protection and attack-surface-reduction options (Sources, item 2). The Kconfig documentation
  also describes `KCONFIG_ALLCONFIG` mini-configs that force a subset of options (Sources, item 3).
- **Profiles may want different kernel lines.** kernel.org's longterm lines receive only important
  fixes for years; stable lines move with each mainline release (Sources, item 4). Servers and a
  router value the first; desktops with new hardware the second.
- **The eight axes were drawn for desktop tiers.** None of them asks what a system exposes on the
  network by default, how it pools and protects disks, or what hardware it targets — the questions
  that separate a router from a NAS from a homelab server.
- **No hardware is chosen yet** for any profile (Sam's decision after the critique, 27/09/2026):
  every lesson runs in VMs and QEMU first, and hardware is chosen per profile by ADR when that topic
  opens.

## Options considered

### Option A — Seven profiles on one base

- **Summary:** One base system, one build system and one package set. A profile is a named package
  set, a set of defaults, a kernel fragment on top of the base fragment, and its installer choices.
- **Pros:** A fix, a security update or a new package reaches every profile. The first edition's
  build system is the one every later edition uses. Profiles stay comparable, because they differ
  only where a matrix cell says so.
- **Cons:** The base has to suit a router and a beginner's laptop at once, so base decisions (C
  library, init, package format) are harder to make. A change to the base is tested against seven
  profiles.

### Option B — Separate distributions per edition

- **Summary:** A desktop distribution, a server distribution and a router distribution, each with
  its own build.
- **Pros:** Each can make locally optimal choices.
- **Cons:** Three build systems and three package sets to maintain — the cost Syntek OS can least
  afford as a one-person, independent distribution.

### Option C — Keep the three tiers; add the server family later

- **Summary:** Finish the desktop tiers first; treat server editions as a later product.
- **Pros:** A smaller first scope.
- **Cons:** Contradicts the recommended first edition (server or homelab) and Sam's own list; the
  server family's axes would be retro-fitted to a matrix that never asked about them.

### Option D — Fewer profiles

- **Summary:** Merge server and homelab, or beginner and intermediate.
- **Pros:** Fewer columns to keep in step.
- **Cons:** Sam named seven; merging hides differences he intends (a homelab runs containers and VMs
  a business server may not).

### Axis set — keep eight, or add three

- **Keep the eight:** no change to the existing tier contents, but the server family's defining
  choices end up buried in "Kernel config" or "Target user" cells.
- **Add three named axes — Network exposure & firewall default, Storage stack, Hardware target:**
  every profile answers them, so a router's closed-by-default firewall, a NAS's storage layers and a
  laptop's power needs become visible, comparable cells.

## Decision

**We will take Option A — seven profiles on one base, build system and package set — and compare
them on eleven axes: the eight scaffold axes plus Network exposure & firewall default, Storage
stack and Hardware target.** The deciding factor is maintenance: one base is the only way a single
maintainer keeps seven editions patched. The three new axes are added because without them the
matrix cannot show the differences the server family exists for.

The seven profiles and their spellings are fixed: `beginner`, `intermediate`, `expert` (the old
"experienced" tier, renamed to Sam's word), `server`, `nas`, `homelab`, `router`. "Business server"
is the `server` profile. An eighth profile needs a new ADR and a `ROADMAP.md` change.

This answer changes if one profile's needs force a second base (for example, a router image that
cannot share the base's C library or init), which would be argued in a new ADR.

## Consequences

- **Positive:** `project-management/src/07-OS-PROFILES/` holds one matrix in two tables — desktop
  profiles and the server family — with identical axis rows, and one `PROFILE-<NAME>.md` per profile.
  The old tier contents carry into the three desktop profiles unchanged in substance.
- **Negative:** Seven Draft specs to keep in step with the matrix. Base decisions become harder,
  because each one is tested against all seven profiles.
- **Follow-on:**
  - To confirm — the first edition is **server and homelab** (the conversation's recommendation);
    `ROADMAP.md`'s critical path assumes it.
  - Hardware per profile is chosen by its own ADR when the profile's topic opens; until then every
    profile's Hardware target value is "VMs and QEMU disk images only", and `GAPS.md` holds one open
    question for all of them.
  - Each profile's kernel line (longterm or stable) is a Draft value until
    `research/LTS-VS-STABLE-PER-PROFILE.md` (planned) reports
    (`ADR-MS001-KERNEL-DOWNSTREAM-OF-UPSTREAM-27-09-2026.md`).
  - The desktop choice per profile follows `ADR-MS001-SYNTEK-OS-DESKTOPS-REUSED-27-09-2026.md`.

## Sources

1. **Linux source, `scripts/kconfig/merge_config.sh`** —
   <https://raw.githubusercontent.com/torvalds/linux/master/scripts/kconfig/merge_config.sh> — merges
   a list of config fragments, checked 27/09/2026 (the GitHub mirror; git.kernel.org served a bot
   challenge to scripted fetches)
2. **Linux source, `kernel/configs/hardening.config`** —
   <https://raw.githubusercontent.com/torvalds/linux/master/kernel/configs/hardening.config> — the
   in-tree hardening fragment, checked 27/09/2026
3. **Kconfig make config** — <https://docs.kernel.org/kbuild/kconfig.html> — `KCONFIG_ALLCONFIG`
   mini-configs, checked 27/09/2026
4. **kernel.org, Active kernel releases** — <https://www.kernel.org/category/releases.html> — stable
   and longterm lines, checked 27/09/2026
5. **Sam's planning conversation, 27/09/2026** — Q9 (the seven profiles, in Sam's words) and Q11
   (desktops per profile); the answers to Q9 and Q10 recommended one base and a server or homelab
   first edition
