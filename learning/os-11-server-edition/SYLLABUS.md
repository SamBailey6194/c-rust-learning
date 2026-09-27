# Syllabus — os-11-server-edition

**Track**: os · **Phase**: P6 · **Path**: Core · **Detail**: full · **Prerequisites**: `os-10-profiles-and-installer`; `os-09-networking-fundamentals` (nftables fundamentals and the isolated lab); `sec-05-applied-cryptography` lessons 04 and 06 (Ed25519 signatures, key management); `sec-04-linux-security-model` lessons 01–02 (users, groups, permissions, capabilities); `os-08-repositories-signing-and-updates` via `os-10`
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The server profile is half of Syntek OS's first edition (with `os-12-homelab-edition`); a "business
server" is this profile. It has no GUI: an admin reaches it over SSH, it updates itself from
`os-08`'s signed repository, and it is only as trustworthy as its accounts, its firewall and its
last restorable backup. Each lesson is one mitigation from the threat model written in lesson 01.
No server hardware has been chosen: every lesson runs in QEMU, and hardware is chosen per profile by
ADR when that decision is due (`GAPS.md` holds the open question). The learning build follows the
LFS 13.1 systemd book, so service and timer units here are systemd's; Syntek OS's own init is chosen
later by ADR, so the jobs themselves stay init-neutral scripts. Small checks land under `code/src/`
(`code/src/os/` is planned — added at P6); the profile's own files land in the Syntek OS
build-system repository, created when that build starts.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The server profile's scope, threat model and budget | 1 sitting | no | Efficiency, Security |
| 02 | Accounts and a sudo policy | 1 sitting | yes — account and sudo checks | Security, Safety |
| 03 | SSH hardening | 1 sitting | yes — sshd policy test | Security, Safety |
| 04 | A host firewall for the server | 1 sitting | yes — ruleset and port probe | Security, Safety |
| 05 | Unattended security updates | 2–3 sittings | yes — signed update job | Efficiency, Security, Safety |
| 06 | Backups and a restore drill | 2–3 sittings | yes — backup and timed restore | Efficiency, Security, Safety |

---

## 01 — The server profile's scope, threat model and budget

- **Objective:** Sam can state what the server edition ships (packages, services, defaults), write
  its threat model and set its resource budget.
- **Builds on:** `os-10-profiles-and-installer` lesson 01 (profiles); `sec-01-principles-threat-modelling-and-law`
  lesson 04 (writing a milestone's threat model).
- **Key ideas:**
  - A server edition is defined as much by what it leaves out as by what it ships: no GUI, as few
    listening services as possible, one remote admin path (SSH) and one update path (`os-08`).
  - Assets: the host's integrity, admin credentials, the repository signing trust and the data;
    threats: the network, a compromised service, a stolen or tampered backup.
  - The budget comes first and is measurable in QEMU: idle memory, disk footprint, boot time.
  - Every later lesson in this topic is a mitigation from this model.
- **Recall targets:** list the sockets the server should listen on at first boot and justify each;
  name the assets most at risk and the lesson that protects each.
- **Build:** none — the output is the threat model and budget in the server profile spec, written
  through `project-management/workflows/07-os-profile-spec/`.
- **Efficiency lens:** idle memory, disk and boot-time targets, measured later with `os-10`
  lesson 07's harness.
- **Security lens:** this lesson writes the model the rest of the topic implements.
- **Sources:** the server profile spec (PROFILE-SERVER in `project-management/src/07-OS-PROFILES/`);
  `man 8 ss` (iproute2; listing listening sockets).
- **Done when:** the server profile spec holds a threat model and a budget in Sam's words.

## 02 — Accounts and a sudo policy

- **Objective:** Sam can create admin and service accounts with least privilege and write a sudoers
  policy that grants named commands, checked with visudo.
- **Builds on:** `sec-04-linux-security-model` lessons 01–02 (users, groups, permissions, setuid;
  capabilities); lesson 01.
- **Key ideas:**
  - Each daemon runs as its own system account (`useradd --system`) with no login shell.
  - Admins are named users in an admin group; logging in as root is not the admin path.
  - sudoers is edited through visudo, which checks syntax; drop-in files come in through
    `@includedir`; grant commands, not shells — "all but a few" rules built from `ALL` and negation
    rarely work, as the sudoers manual's security notes explain.
  - `use_pty` (on by default since sudo 1.9.14) stops a program run under sudo keeping access to the
    user's terminal after it exits.
  - sudo logs every command; reading that log is part of the job.
- **Recall targets:** why negated command lists fail; what `useradd --system` changes; how to test a
  policy without locking yourself out.
- **Build:** the server profile's accounts and a sudoers drop-in, applied to a server image, plus a
  check script in `code/src/os/` (planned — added at P6) that runs in the QEMU guest and asserts:
  service accounts have no login shell, `visudo -c` passes, the admin can run the granted command,
  and the admin cannot get a root shell through sudo. The profile files land in the Syntek OS
  build-system repository (created when this build starts).
- **Security lens:** least privilege; one account per service; no shared root password.
- **Safety:** QEMU guest only; keep the serial root console open while testing a sudo policy.
- **Sources:** sudoers(5) for Sudo 1.9.17p2 (the BLFS 13.1 version),
  <https://www.sudo.ws/docs/man/sudoers.man/> (`use_pty`, `@includedir`, SECURITY NOTES); BLFS
  13.1 Sudo, <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/sudo.html>;
  `man 8 useradd` (`--system`); `man 8 visudo`.
- **Done when:** the check script passes in the guest.

## 03 — SSH hardening

- **Objective:** Sam can configure sshd for key-only admin access, prove the effective configuration
  and name the threat each setting answers.
- **Builds on:** lesson 02; `sec-05-applied-cryptography` lesson 04 (public-key signatures with
  Ed25519).
- **Key ideas:**
  - Defaults matter: `PasswordAuthentication` and `KbdInteractiveAuthentication` default to yes and
    `PermitRootLogin` defaults to `prohibit-password` — set each one explicitly.
  - Restrict who may log in (`AllowGroups` for the admin group) and how (`AuthenticationMethods`
    requiring a public key).
  - `sshd -T` prints the effective configuration: test what sshd will do, not what the file says.
  - Host keys identify one machine: an image must not ship them; they are made on first boot
    (`ssh-keygen -A` creates any missing host keys).
  - `MaxAuthTries` and `PerSourcePenalties` cut brute-force noise but do not replace key-only login.
- **Recall targets:** which settings change from their defaults and why; what goes wrong when an
  image ships host keys; how to confirm the effective configuration.
- **Build:** an sshd drop-in for the server profile and a first-boot host-key step, with a test in
  `code/src/os/` (planned — added at P6) run from the host against the QEMU guest through a user-mode
  `hostfwd` bound to 127.0.0.1 with `restrict=on` (the forward still works; the guest gets no other
  route out): key login works, password and root logins are refused, and `sshd -T`
  shows the intended values. The configuration lands in the Syntek OS build-system repository
  (created when this build starts).
- **Security lens:** password guessing, credential stuffing, and a cloned host identity from a
  copied image.
- **Safety:** QEMU guest only; the forwarded port listens on localhost only, and `restrict=on` keeps
  the guest off the host's networks.
- **Sources:** sshd_config(5), OpenBSD-current (17/09/2026), <https://man.openbsd.org/sshd_config>,
  for OpenSSH 10.5p1 as packaged in BLFS 13.1,
  <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/openssh.html>; sshd(8) `-T`,
  <https://man.openbsd.org/sshd>; `man 1 ssh-keygen` (`-A`); `man 1 qemu-system` (`hostfwd`,
  `restrict=on`).
- **Done when:** the test passes and Sam explains each value he set.

## 04 — A host firewall for the server

- **Objective:** Sam can write, check and load an nftables ruleset that drops by default and admits
  only the server's services, and prove it from outside the guest.
- **Builds on:** `os-09-networking-fundamentals` (nftables fundamentals and the isolated lab);
  lesson 01's socket list.
- **Key ideas:**
  - One `inet` table covers IPv4 and IPv6; the input chain's policy is drop; established and related
    traffic is accepted, invalid is dropped, loopback is accepted.
  - IPv6 needs neighbour discovery ICMPv6 accepted, or connectivity breaks.
  - A server that is not a router drops everything in its forward chain.
  - `nft -c` checks a ruleset without applying it; `nft -f` applies a file in one transaction, and a
    file that starts with `flush ruleset` makes that transaction replace the whole ruleset, with no
    moment of half a firewall and no duplicate rules on reload.
  - Proof comes from outside: a probe from the lab sees only the intended ports.
- **Recall targets:** why the loopback and established rules come first; what breaks if ICMPv6
  neighbour discovery is dropped; why a shell script of single rule commands is worse than `nft -f`.
- **Build:** the server profile's ruleset, and a probe script in `code/src/os/` (planned — added at
  P6) run from `os-09`'s lab namespace against the guest, asserting that the open ports match the
  profile spec exactly.
- **Security lens:** default deny; the ruleset is part of the profile, reviewed like code.
- **Safety:** isolated virtual network only (`os-09`'s lab), never the home LAN.
- **Sources:** nftables wiki, "Simple ruleset for a server" (revision 1058),
  <https://wiki.nftables.org/wiki-nftables/index.php/Simple_ruleset_for_a_server>; nftables wiki,
  "Atomic rule replacement" (revision 693),
  <https://wiki.nftables.org/wiki-nftables/index.php/Atomic_rule_replacement>; `man 8 nft`
  (nftables 1.0.9 on the host: `-c`, `-f`).
- **Done when:** the probe script passes, and fails when an extra port is opened in the guest.

## 05 — Unattended security updates

- **Objective:** Sam can schedule unattended security updates that apply only verified updates from
  `os-08`'s repository, record what changed, and recover when an update fails.
- **Builds on:** `os-08-repositories-signing-and-updates` (the secure update flow; freeze and
  rollback threats); `os-07-package-manager` lesson 06 (transactions and rollback);
  `os-06-init-and-services` lesson 04 (supervision).
- **Key ideas:**
  - Unattended does not mean unverified: the job runs `os-08`'s flow — signature, freshness and
    rollback checks — and refuses anything that fails them.
  - Scheduling in the learning build is a systemd timer; `Persistent=` catches up a run missed while
    the machine was off, and `RandomizedDelaySec=` adds a random delay so many machines do
    not all hit the mirror at once.
  - Updates that need a reboot (kernel, C library) are staged and reported, and reboot only in an
    agreed window.
  - A failed transaction rolls back (`os-07`) and raises an alert naming the package and the reason.
- **Recall targets:** what the job refuses and why; how a timer catches up after downtime; what
  happens to a half-applied update.
- **Build:** the update job plus its timer and service units for the server image, tested in
  `os-09`'s lab against a local signed repository serving (a) a valid update, (b) a tampered package
  and (c) old, replayed metadata: (a) applies, (b) and (c) are refused. The test harness is in
  `code/src/os/` (planned — added at P6); the job and units land in the Syntek OS build-system
  repository (created when this build starts).
- **Efficiency lens:** download size and time; the job's memory peak read from its cgroup's
  `memory.peak`.
- **Security lens:** tampering, freeze and rollback attacks (`os-08`'s threat model); the job runs
  with only the privilege the package manager needs.
- **Safety:** isolated network and a local repository only.
- **Sources:** `man 5 systemd.timer` (systemd 255: `Persistent=`, `RandomizedDelaySec=`);
  `man 5 systemd.service`; The Update Framework specification 1.0.36 (the attacks it defends
  against: arbitrary installation, indefinite freeze, rollback),
  <https://theupdateframework.github.io/specification/latest/>; docs.kernel.org, "Control Group
  v2" (`memory.peak`), <https://docs.kernel.org/admin-guide/cgroup-v2.html>.
- **Done when:** the three cases behave as stated and the job's log explains each outcome.

## 06 — Backups and a restore drill

- **Objective:** Sam can back up a server's data with an encrypted, deduplicating backup tool,
  verify the backup, and prove it by restoring into a fresh VM within a measured time.
- **Builds on:** `os-02-storage-and-boot-fundamentals` lesson 04 (filesystems);
  `sec-05-applied-cryptography` lessons 03 and 06 (symmetric encryption, key management);
  `os-10-profiles-and-installer` lesson 02 (a machine configuration rebuilds everything that is not
  data).
- **Key ideas:**
  - A snapshot is not a backup: it shares its blocks with the original, so the same disk fault or
    mistake takes both.
  - Back up data and the machine configuration; the configuration rebuilds the rest.
  - Candidates: restic and BorgBackup, both encrypted and deduplicating with their own integrity
    checks (`restic check`, `borg check`); if one ships in the edition, an ADR chooses it.
  - A backup is proven only by a restore: rebuild a fresh VM, restore, compare, and time it.
  - Losing the repository key loses every backup; the key is kept apart from the server.
- **Recall targets:** why a snapshot is not a backup; what the restore drill proves that a check does
  not; where the backup key lives.
- **Build:** a backup job for the server image writing to a second virtual disk or a lab host, and a
  restore-drill script in `code/src/os/` (planned — added at P6) that builds a fresh VM from the
  lesson's machine configuration, restores into it and compares the data with the original. The job
  itself lands in the Syntek OS build-system repository (created when this build starts).
- **Efficiency lens:** backup size after deduplication, backup time and restore time.
- **Security lens:** encryption at rest; key custody; a compromised backup target.
- **Safety:** VM disk images and the isolated lab only.
- **Sources:** restic 0.19.1 documentation, <https://restic.readthedocs.io/en/v0.19.1/> ("Preparing
  a new repository", "Restoring from backup", "Checking integrity and consistency"); BorgBackup
  1.4.5 documentation, <https://borgbackup.readthedocs.io/en/1.4.5/>; Btrfs documentation,
  "Subvolumes" (a snapshot is not a backup), <https://btrfs.readthedocs.io/en/latest/Subvolumes.html>;
  `man 1 rsync` (the plain-copy baseline).
- **Done when:** the drill restores the data into a fresh VM, the comparison is clean, and the
  restore time is recorded against the budget.
