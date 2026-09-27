# ADR-MS001: Network labs stay isolated; a lab-proven config graduates to named devices

| Field | Value |
| --- | --- |
| **ID** | ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH |
| **Status** | Accepted |
| **Date** | 27/09/2026 |
| **Milestone** | MS001 — Toolchain ready · `project-management/src/02-MILESTONES/MS001-TOOLCHAIN-READY.md` |
| **Deciders** | Sam Bailey |
| **Supersedes** | — (extends `ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md` and changes none of its rules) |
| **Superseded by** | — |
| **Research** | — (primary sources cited below); `research/HOME-NETWORK-OPERATION-LAW.md` (planned) grounds the logging limits, and `research/REMOTE-HELP-CONSENT-AND-THE-COMPUTER-MISUSE-ACT.md` (planned) sets what a consent record holds |
| **Enforced in** | `.claude/CLAUDE.md` Section 5 (the non-negotiables) · `project-management/docs/SAFETY-GUIDE.md` → Graduating a lab-proven config · `.claude/skills/teach/FAMILIES.md` |

---

## Context

`.claude/CLAUDE.md` Section 5 says that network and router labs run on isolated virtual networks,
and that real-hardware tests run only on dedicated, wiped hardware named in the milestone — never
the host, never the home network. The networking and licensing round that followed the planning
conversation of 27/09/2026 is about Sam's own connectivity: a router, a homelab, WireGuard,
monitoring and a private CA serving the devices he actually uses. Read literally, Section 5 leaves
no route by which anything proven in the lab can ever reach those devices. This record decides
whether such a route exists and, if it does, on what terms.

Facts checked on 27/09/2026:

- **The rule has no record that argues it.** `project-management/src/07-OS-PROFILES/PROFILE-ROUTER.md`
  cites `ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md` for "never the home network" (in its
  opening paragraph and its Hardware target row), but that record's Decision (rules 1 to 6) covers
  offensive techniques, attack tooling, publishing, exploits, vulnerable builds and malware. It
  does not decide where a defensive network configuration may run.
- **The statute is not what forbids it.** Under the Computer Misuse Act 1990, section 17(5), access
  is unauthorised only where the person is neither entitled to control access of that kind nor has
  consent from someone who is; section 17(8) applies the same test to an act done in relation to a
  computer, measured against whoever has responsibility for the computer and is entitled to decide
  (Sources, item 1). On devices Sam owns and controls, he is that person. The isolation rule for
  network labs is therefore a safety rule — protecting the household and the machine Sam learns on —
  and not a legal one. This is a reading of the statute's text, not legal advice. For a device
  someone else controls, the text turns on that person's consent, which is why remote help below
  needs a written consent record.
- **The home network is shared.** It carries other household members' connectivity and data, so an
  outage or a capture there reaches people who did not choose the lesson. What UK law asks of a
  householder who runs DNS, DHCP, WireGuard and metrics that others depend on is the planned note's
  question (Research row); until it exists, logging stays minimal and is stated per milestone.
- **Isolation can be proved.** `learning/os-09-networking-fundamentals/SYLLABUS.md` lesson 05 builds
  an unprivileged namespace lab with QEMU guests and a self-test showing no route to the home
  network. QEMU's `restrict=on` user-mode network and a libvirt network with no forward element are
  the other isolated forms (Sources, items 2 and 3).
- **Rollback needs a known-good state.** `learning/ui-07-system-tools-tui/SYLLABUS.md` lesson 04
  teaches a confirm-or-revert timer for a network change that cuts the user off, and
  `PROFILE-ROUTER.md` → Axis values makes a documented reset to a known-good config the router's
  rescue tooling. Both assume the known-good config is versioned somewhere.
- **This repository is public.** Real addresses, peers, keys and topology cannot live here
  (`.claude/CLAUDE.md` Section 5, public-repository hygiene); examples use the documentation address
  ranges and names (Sources, items 4 to 6).
- **No hardware is chosen for any profile** (`GAPS.md` → "No hardware chosen for the Syntek OS
  profiles"), so no Syntek OS router or homelab image exists to deploy.
- **Sam's answers of 27/09/2026.** On where network config may run: lab first, then a graduation
  path to named devices he owns, with rollback and no offensive tooling on the LAN, and the real
  config kept in a new private repository. On remote help: the lab first, then real sessions on
  family devices with recorded consent. In the same round he took the recommended answers on what
  may graduate (configuration only), whether the study host is a target (userspace configuration
  only), where filled consent records and session logs live (in no git repository), and what a real
  device runs before Syntek OS images exist (whatever it runs today, mirrored in the lab).

Clash check (`project-management/workflows/08-decisions/STEPS.md` Step 3), against the Accepted set:

- **`ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md`** — this record extends it and changes none
  of its rules. Its rule 1 (techniques only inside isolated labs with no route to the home LAN)
  still binds every experiment, and rule 6 below keeps offensive tooling off the real network
  altogether.
- **The Section 5 kernel bullet** (custom kernels and modules in QEMU only, never on the host) — rule
  8 below keeps kernels, modules and images out of scope, so the study host receives userspace
  configuration only.

## Options considered

### Option A — Lab only, permanently (the status quo)

- **Summary:** Every network config stays in the lab; nothing reaches a real device.
- **Pros:** No risk to the household; Section 5 stays literally true; nothing private to keep.
- **Cons:** The round's purpose — Sam's own connectivity — cannot be reached, and the lab work never
  meets the conditions it is meant to prepare for. Sam would configure his real devices anyway,
  without a checklist.

### Option B — Lab first, then a graduation path, with the real config in a private repository

- **Summary:** Every experiment runs in the lab. A config that passes its lab tests may enter
  service on named devices Sam owns, with a rehearsed rollback, applied by Sam, its real values kept
  in a private git repository.
- **Pros:** Real connectivity, built from tested pieces. The private repository's git history is
  the versioned known-good state that rollback needs. The public repository keeps the lessons and
  none of the values.
- **Cons:** A private repository to secure — it is still hosted, and a slip to public would leak
  topology. A checklist to run for every change. The lab has to mirror what each device runs.

### Option C — As B, but the real config kept only on the devices

- **Summary:** The same path, with no repository for real values; each device holds its own config.
- **Pros:** Nothing about the real network is hosted anywhere.
- **Cons:** No versioned known-good state off the device: a failed device takes its only good config
  with it. No diff between the lab-proven and the deployed config. Rollback depends on whatever
  local snapshots each device happens to support.

### Option D — Relax Section 5 so that labs may run on the home network

- **Summary:** Experiments run directly on the real network and devices.
- **Pros:** No lab parity to maintain; the fastest feedback.
- **Cons:** Every mistake lands on the household. Tests, and later the security track's exercises,
  would share a network with people who never agreed to them. It removes the isolation premise the
  lab-rules record depends on.

## Decision

**We will take Option B.** A test and a graduation are different things. A **test** exercises a
config to find out whether it works, and runs only in the isolated lab — or, for real hardware, on
dedicated wiped hardware named in the milestone. A **graduation** puts a config already proven in
the lab into service on a named device. Nothing is learned by experiment on a real device. The
rules:

1. Every lesson, test and experiment runs in the isolated lab. Real-hardware tests stay on
   dedicated, wiped hardware named in the milestone — never the host, never the home network.
2. A config graduates only after its lab tests pass, and it differs from the lab-proven version
   only by a listed set of substitutions (keys, addresses, names).
3. Targets are devices Sam owns, each named by a role label in the milestone. The study host is a
   target for userspace configuration only: a WireGuard peer, the private CA's root in its trust
   store, a metrics exporter. **Remote-help sessions — never configuration — may reach family
   devices named in the milestone, each with a written consent record from whoever controls the
   device.** The consent-first tool built later is argued in
   `ADR-MS001-REMOTE-HELP-TOOL-CONSENT-FIRST-27-09-2026.md`; what the consent record must hold is set
   by `research/REMOTE-HELP-CONSENT-AND-THE-COMPUTER-MISUSE-ACT.md` (planned), not here.
4. Every graduation has a rollback, rehearsed in the lab first. A change that can cut remote access
   runs behind a confirm-or-revert timer, with console access to hand.
5. Sam runs every command on a real device. Claude never runs `sudo`, never opens a session to a
   real device and never holds a credential for one.
6. No offensive tooling on the real LAN: no scans, floods, fuzzing or capture of other people's
   traffic. A graduated config is verified by inspection on the device itself (`nft list ruleset`,
   `ss -tulpn`, `wg show`).
7. The real configuration lives in the private infrastructure repository. This repository may name
   it, but never links it, cites a path in it or quotes from it. Private keys are generated on their
   device and committed to no repository, the private one included. Filled consent records and
   session logs stay on the helped device, and on Sam's machine only if the helped person agrees;
   they enter no git repository, and only a blank consent template may live in the private
   infrastructure repository.
8. Only configuration graduates: nftables rules, WireGuard, DNS and DHCP service configuration, CA
   trust anchors and metrics exporters, onto whatever operating system each device already runs.
   Until Syntek OS images run on chosen hardware, each named device keeps its current system and its
   lab guest mirrors that device's software versions (lab parity). Kernels, modules and OS images
   never graduate under this record.

The deciding factor is that Option A cannot reach the round's purpose, and that between B and C the
private repository's git history is the versioned known-good state rule 4's rollback needs. D lost
outright: the lab's isolation is what makes mistakes, and later attack tooling, acceptable at all.

This answer reopens if a graduation harms the household despite the checklist, or if something can
be shown only on the real network; either would be argued in a new ADR.

## Consequences

- **Positive:** Section 5's network-lab rule gains the record that argues it, and a lab-proven
  config has exactly one route to Sam's own devices. `PROFILE-ROUTER.md` can cite this record
  instead of the lab-rules one, and the real-device steps of the networking and remote-help lessons
  have something that authorises them.
- **Negative:** A private repository to secure: it is still hosted, so a slip to public or a
  revealing name would leak topology — mitigated by keeping keys in no repository and naming devices
  by role label only. A checklist to run for every change. The OS-images half of Section 5 (images,
  installers and partitioning in VMs) is still argued by no record; rule 8 leaves it untouched.
- **Follow-on:**
  - `.claude/CLAUDE.md` Section 5's network bullet is reworded to route a lab-proven config through
    this path; `project-management/docs/SAFETY-GUIDE.md` gains the graduation checklist, which it
    owns; `.claude/skills/teach/FAMILIES.md` names the private infrastructure repository and routes
    the os family's real-device steps here.
  - `project-management/src/07-OS-PROFILES/PROFILE-ROUTER.md` and
    `learning/os-14-router-edition/SYLLABUS.md` re-cite this record for the home-network rule.
  - `learning/os-18-own-network-operations/` teaches running Sam's own network under this path.
    `research/HOME-NETWORK-OPERATION-LAW.md` lands before its lessons 03 and 07 are taught, and
    `research/REMOTE-HELP-CONSENT-AND-THE-COMPUTER-MISUSE-ACT.md` before its lesson 10 and before any
    real remote-help session.
  - `ADR-MS001-REMOTE-HELP-TOOL-CONSENT-FIRST-27-09-2026.md` argues the consent-first tool; rule 3's
    family-device clause is the envelope it works inside.
  - The first milestone that graduates a config records its lab evidence and rollback rehearsal in
    `project-management/src/10-PROGRESS/`, naming devices by role label only.

## Sources

1. **Computer Misuse Act 1990, section 17 (Interpretation)** —
   <https://www.legislation.gov.uk/ukpga/1990/18/section/17> — subsections (5) and (8), when access
   or an act is unauthorised, checked 27/09/2026
2. **QEMU invocation, `-netdev user,restrict=on`** — <https://www.qemu.org/docs/master/system/invocation.html>,
   checked 27/09/2026
3. **libvirt network XML format, isolated network config** — <https://libvirt.org/formatnetwork.html>,
   checked 27/09/2026
4. **RFC 5737, IPv4 Address Blocks Reserved for Documentation** — <https://www.rfc-editor.org/rfc/rfc5737>,
   checked 27/09/2026
5. **RFC 3849, IPv6 Address Prefix Reserved for Documentation** — <https://www.rfc-editor.org/rfc/rfc3849>,
   checked 27/09/2026
6. **RFC 2606, Reserved Top Level DNS Names** — <https://www.rfc-editor.org/rfc/rfc2606>, checked
   27/09/2026
7. **Sam's answers of 27/09/2026, networking and licensing round** — where network config may run;
   remote help on family devices; and the recommended answers he took on what may graduate, the
   study host, where consent records live and lab parity
