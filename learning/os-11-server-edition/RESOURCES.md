# Resources — os-11-server-edition

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 The server profile's scope, threat model and budget | the server profile spec (PROFILE-SERVER in `project-management/src/07-OS-PROFILES/`); `man 8 ss` | `project-management/docs/planning/MILESTONES.md` (Threat model, Budget) | — |
| 02 Accounts and a sudo policy | sudoers(5), Sudo 1.9.17p2, <https://www.sudo.ws/docs/man/sudoers.man/>; `man 8 useradd`; `man 8 visudo` | `project-management/docs/SAFETY-GUIDE.md` | `code/src/os/` (planned — added at P6) |
| 03 SSH hardening | sshd_config(5), OpenBSD-current (17/09/2026), <https://man.openbsd.org/sshd_config>; sshd(8), <https://man.openbsd.org/sshd>; `man 1 ssh-keygen` | — | `code/src/os/` (planned — added at P6) |
| 04 A host firewall for the server | nftables wiki "Simple ruleset for a server" (revision 1058), <https://wiki.nftables.org/wiki-nftables/index.php/Simple_ruleset_for_a_server>; `man 8 nft` (1.0.9) | — | `code/src/os/` (planned — added at P6) |
| 05 Unattended security updates | `man 5 systemd.timer` (systemd 255); The Update Framework specification 1.0.36, <https://theupdateframework.github.io/specification/latest/> | — | `code/src/os/` (planned — added at P6) |
| 06 Backups and a restore drill | restic 0.19.1, <https://restic.readthedocs.io/en/v0.19.1/>; BorgBackup 1.4.5, <https://borgbackup.readthedocs.io/en/1.4.5/>; Btrfs "Subvolumes", <https://btrfs.readthedocs.io/en/latest/Subvolumes.html> | — | `code/src/os/` (planned — added at P6) |
