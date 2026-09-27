# Syllabus — ui-07-system-tools-tui

**Track**: ui · **Phase**: U2 · **Path**: Later · **Detail**: outline · **Prerequisites**: ui-03-tui-architecture-and-testing (all lessons); os-06-init-and-services (services, supervision, logging); os-09-networking-fundamentals; os-11-server-edition (users and sudo policy, host firewall, unattended updates, backups); sec-04-linux-security-model (users, capabilities, seccomp and the sandbox launcher)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The settings and system tools — network, users, updates and storage — change the system itself, so they need root for
some actions and must not run as root for all of them. This topic teaches the split every such tool uses: an
unprivileged TUI, a small privileged helper with a narrow interface, D-Bus between them (zbus's blocking API, so this
does not wait for async), polkit deciding who may do what, and an audit trail of every privileged action. The screens
then apply what the OS track built: os-09's networking, os-11's users and firewall, os-08's secure update flow and
os-02's storage. It is marked **Later** because the server edition can be administered from the shell first, and it is
an outline until U2 reaches it. The D-Bus and polkit lessons use the LFS 13.1 systemd learning build; which init and
session stack Syntek OS ships is decided later by ADR (INIT-SYSTEM-CHOICE), and the helper's design must survive that
choice. Small concept exercises land as lesson crates here; the tools themselves land in the Syntek OS system-tools
repository (created when this build starts). Privileged code runs only inside VM guests.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Privilege separation: an unprivileged UI and a privileged helper | 2–3 sittings | yes — helper design | Security |
| 02 | D-Bus with zbus's blocking API | 1 sitting | yes — hostname reader | Security |
| 03 | Authorising actions with polkit | 2–3 sittings | yes — polkit-checked action | Security, Safety |
| 04 | The network and users screens | 2–3 sittings | yes — network and users screens | Security, Safety |
| 05 | The updates screen | 1 sitting | yes — updates screen | Security, Safety |
| 06 | The storage screen | 2–3 sittings | yes — storage screen | Safety |
| 07 | Auditing and logging privileged actions | 1 sitting | yes — audit trail | Security |

---

## 01 — Privilege separation: an unprivileged UI and a privileged helper

- **Objective:** Sam can design a system tool as an unprivileged interface and a minimal privileged helper, and justify
  every action the helper exposes.
- **Builds on:** sec-04 (users, capabilities and least privilege); ui-03 lesson 01.
- **Key ideas:**
  - The UI parses keys, draws screens and handles untrusted display data; none of that needs root, so none of it gets
    root.
  - The helper exposes a short list of named actions with typed arguments — never "run this command".
  - Every request is authenticated (who is asking: D-Bus sender credentials, or `SO_PEERCRED` on a Unix socket),
    authorised (lesson 03) and validated before anything happens.
  - The helper runs with the fewest capabilities that do the job, under the service hardening os-06 and sec-04 teach.
- **Recall targets:** what the helper must never accept; the three checks on every request.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — a written helper interface (actions,
  arguments, who may call each) and its threat model; no code yet.
- **Security lens:** the helper is the attack surface; the smaller its interface, the smaller the surface (sec-01).
- **Sources:** (to verify when the topic opens) `man 7 unix` (`SO_PEERCRED`), `man 7 capabilities` (Linux man-pages
  6.7); `man 5 systemd.exec` (`User=`, `NoNewPrivileges=`, `CapabilityBoundingSet=`, systemd 255).
- **Done when:** the interface and threat model are written and every action has a named caller and a validation rule.

## 02 — D-Bus with zbus's blocking API

- **Objective:** Sam can call methods and read properties on a system D-Bus service from Rust with zbus's blocking API,
  and inspect the same calls with `busctl`.
- **Builds on:** lesson 01; P3 traits and error handling.
- **Key ideas:**
  - D-Bus: a bus daemon, services with well-known names, objects at paths, interfaces with methods, properties and
    signals.
  - zbus is asynchronous at heart; its blocking API (on by default) wraps each call and must not be used inside an async
    context.
  - A read-only first client: `org.freedesktop.hostname1`'s properties need no privilege.
  - `busctl introspect` and `busctl call` show the same interface from the shell — the command is the lesson.
- **Recall targets:** name, path, interface and member in one call; why the blocking API must stay out of async code.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — a lesson crate that reads the host name
  properties over the system bus, `code/src/rust/crates/msNNN_hostname_reader/` (planned), checked by `cargo test` on
  its parsing and by hand against `busctl`; `cargo deny check` straight after adding zbus (MIT).
- **Security lens:** a D-Bus service is a privilege boundary: each method is an entry point a less-privileged caller
  can reach.
- **Sources:** (to verify when the topic opens) zbus 5.19.0 `blocking` module
  (<https://docs.rs/zbus/5.19.0/zbus/blocking/index.html>) and the zbus book (<https://z-galaxy.github.io/zbus/>);
  D-Bus Specification (<https://dbus.freedesktop.org/doc/dbus-specification.html>, version 0.43); `man 1 busctl`,
  `man 5 org.freedesktop.hostname1` (systemd 255).
- **Done when:** the crate prints the same properties `busctl` shows, and Sam names each part of a call unaided.

## 03 — Authorising actions with polkit

- **Objective:** Sam can let an unprivileged user perform exactly one privileged action after polkit authorises it, and
  explain the policy that decides.
- **Builds on:** lessons 01–02.
- **Key ideas:**
  - polkit is the decider: a privileged mechanism asks it whether the calling subject may perform a named action.
  - Actions are declared in a `.policy` file with implicit authorisations (for example `auth_admin` versus
    `auth_self`); polkit's own guidance prefers `auth_admin*` by default on multi-user systems.
  - The mechanism checks on every call; the UI never decides for itself.
  - `pkcheck` shows the decision from the shell; the mechanism must still work, safely, when polkit is unavailable.
- **Recall targets:** who asks polkit, and about whom; why the default leans to `auth_admin`.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — a VM-only exercise in which the TUI sets the
  static host name through `org.freedesktop.hostname1`, which is polkit-authorised, first as an unauthorised user
  (refused) and then with authorisation.
- **Security lens:** a policy that is too coarse turns one allowed action into many; polkit's guidance notes that an
  action often has more to do with the object acted on than with the operation, so design actions around objects.
- **Safety:** privileged actions only in a VM guest; Sam runs any `sudo` needed to install a policy; Claude never runs
  `sudo`.
- **Sources:** (to verify when the topic opens) polkit Reference Manual, version 124, "Writing polkit applications"
  (<https://polkit.pages.freedesktop.org/polkit/polkit-apps.html>); `man 8 polkit`, `man 1 pkcheck`;
  `man 5 org.freedesktop.hostname1` (systemd 255) — `SetStaticHostname()` and its polkit note.
- **Done when:** the refusal and the authorised change both happen in the VM, and Sam reads the `.policy` entry aloud
  and explains it.

## 04 — The network and users screens

- **Objective:** Sam can show and change network configuration and local users through the helper, with every change
  previewed and reversible where the OS allows.
- **Builds on:** lessons 01–03; os-09 (addresses, routes, DNS, nftables); os-11 (users, sudo policy, host firewall).
- **Key ideas:**
  - Read state from structured sources (`ip -json`, or the network daemon's D-Bus interface chosen in os-11) rather
    than scraping text.
  - A network change that cuts the user off needs a confirm-or-revert timer.
  - User changes go through the same validation as the installer (ui-06 lesson 04); passwords never pass through logs.
- **Recall targets:** why a network change needs an automatic revert; where user-name rules come from.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — network and users screens backed by helper
  actions; lands in the Syntek OS system-tools repository (created when this build starts).
- **Security lens:** every helper action here edits security-relevant state (firewall, sudo policy); each has a named
  polkit action and an audit record (lesson 07).
- **Safety:** VM guests on os-09's isolated lab network only.
- **Sources:** (to verify when the topic opens) `man 8 ip` (`-json`, iproute2); `man 8 nft`; `man 5
  org.freedesktop.network1` (systemd 255).
- **Done when:** a change that breaks connectivity reverts on its own in the VM, and the users screen refuses invalid
  names with a clear message.

## 05 — The updates screen

- **Objective:** Sam can show available updates and apply them through os-08's secure update flow, reusing the
  package-manager front-end's preview and cancellation rules.
- **Builds on:** ui-05 (preview, confirmation, progress, cancellation); os-08 (the secure update flow); os-11
  (unattended security updates).
- **Key ideas:**
  - The updates screen is another client of os-07's library, run through the helper — not a second update mechanism.
  - Verification failures block, exactly as in ui-05 lesson 03.
  - Manual updates and os-11's unattended ones must not run at once; the screen shows which is active.
- **Recall targets:** why this screen reuses the library instead of calling the CLI; what happens if an unattended
  update is running.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — an updates screen in the Syntek OS system-tools
  repository, tested against ui-05's fake backend.
- **Security lens:** freeze and rollback protection hold whichever screen starts the update.
- **Safety:** VM guests only.
- **Sources:** (to verify when the topic opens) The Update Framework specification 1.0.36
  (<https://theupdateframework.github.io/specification/latest/>); os-08's secure update flow lesson.
- **Done when:** an update applied from the screen in a VM guest matched its preview, and a tampered repository was
  refused.

## 06 — The storage screen

- **Objective:** Sam can show disks, file systems and usage, and perform a small set of safe storage actions (mount,
  unmount, check usage) through the helper.
- **Builds on:** lessons 01–03; os-02 (block devices, file systems, fstab, LUKS2 concepts); ui-06 lesson 02 (stable
  disk identity).
- **Key ideas:**
  - Read state from `lsblk` JSON and `findmnt`, or from udisks's D-Bus interface, which already routes privileged
    actions through polkit.
  - Destructive actions (format, repartition) stay out of the system tools and belong to the installer's safeguards.
  - Show usage in a way that reads without colour (ui-02 lesson 06).
- **Recall targets:** which storage actions the tool offers and which it deliberately does not.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — a storage screen in the Syntek OS system-tools
  repository, exercised against VM disk images.
- **Safety:** VM disk images only; never a host disk.
- **Sources:** (to verify when the topic opens) `man 8 lsblk`, `man 8 findmnt` (util-linux 2.39.3); `man 8 udisks`
  (its authorisation checks are polkit-based), `man 1 udisksctl` (udisks 2.10.1).
- **Done when:** the screen shows a VM guest's disks correctly and mounts and unmounts a scratch image through the
  helper.

## 07 — Auditing and logging privileged actions

- **Objective:** Sam can record every privileged action — who asked, what, the arguments, the polkit decision and the
  outcome — as structured log entries, and query them.
- **Builds on:** lessons 01–06; os-06 (logging).
- **Key ideas:**
  - An audit record is written by the helper, not the UI, because only the helper knows what actually happened.
  - Structured fields beat free text: they can be filtered with `journalctl`.
  - Secrets never enter a record; arguments that might hold them are redacted.
  - Failed and refused requests are recorded too — they are the interesting ones.
- **Recall targets:** which component writes the record and why; what is redacted.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — structured audit records from the helper,
  queried with `journalctl` in the VM guest.
- **Security lens:** the audit trail is what sec-16's detection and response lessons read later.
- **Sources:** (to verify when the topic opens) `man 1 journalctl`, `man 7 systemd.journal-fields` (systemd 255).
- **Done when:** a day of actions in the VM guest can be reconstructed from the journal alone.
