# Mission — ui-07-system-tools-tui

**Started**: not yet · **Family**: ui · **Phase**: U2 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

Settings and system tools — network, users, updates, storage and backups — are among the custom Syntek OS TUI tools
Sam settled on. They are also the tools that can do the most damage, because they change the system itself. This topic
teaches how such a tool is built so that it does not run as root just because one action needs root: an unprivileged
interface, a small privileged helper, D-Bus between them, polkit deciding, and an audit trail of everything
privileged. The screens then bring together what the OS track builds — networking, users and firewall, the secure
update flow and storage — into one place an administrator, or a beginner-profile user, can manage safely.

## Can do it when

- Sam can design a helper interface with named, typed actions and a threat model, and justify each action.
- Sam can call a system D-Bus service from Rust with zbus's blocking API and match it against `busctl`.
- Sam can make one privileged action succeed only after polkit authorises it, in a VM guest.
- Sam can build network, users, updates and storage screens through the helper, with a revert timer on network
  changes and every verification failure blocking an update.
- Every privileged action in a VM guest can be reconstructed from structured journal records.

## Parked for later

- The init and session stack Syntek OS ships (systemd, logind or elogind, or another) — decided by ADR from the
  INIT-SYSTEM-CHOICE research note; os-06-init-and-services teaches the options.
- Backups and a restore drill — os-11-server-edition; a backups screen follows once that exists.
- A web front-end for the same actions on the NAS and router profiles — ui-10-web-admin-dashboard.
