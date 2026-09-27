# Resources — ui-07-system-tools-tui

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Privilege separation: an unprivileged UI and a privileged helper | `man 7 unix` (`SO_PEERCRED`), `man 7 capabilities` (Linux man-pages 6.7); `man 5 systemd.exec` (systemd 255) (to verify when the topic opens) | `code/docs/CODING-PRINCIPLES.md` — Section 2 Linus Torvalds | — |
| 02 D-Bus with zbus's blocking API | zbus 5.19.0 `blocking`, <https://docs.rs/zbus/5.19.0/zbus/blocking/index.html>; D-Bus Specification 0.43, <https://dbus.freedesktop.org/doc/dbus-specification.html>; `man 1 busctl` (systemd 255) (to verify) | `code/docs/RUST-CODING-PRINCIPLES.md` — Section 3 Errors are values | `code/src/rust/crates/msNNN_hostname_reader/` (planned) |
| 03 Authorising actions with polkit | polkit Reference Manual 124, "Writing polkit applications", <https://polkit.pages.freedesktop.org/polkit/polkit-apps.html>; `man 8 polkit`, `man 1 pkcheck` (to verify) | — | the Syntek OS system-tools repository (created when this build starts) |
| 04 The network and users screens | `man 8 ip` (`-json`), `man 8 nft`; `man 5 org.freedesktop.network1` (systemd 255) (to verify) | — | the Syntek OS system-tools repository |
| 05 The updates screen | The Update Framework specification 1.0.36, <https://theupdateframework.github.io/specification/latest/> (to verify) | — | the Syntek OS system-tools repository |
| 06 The storage screen | `man 8 lsblk`, `man 8 findmnt` (util-linux 2.39.3); `man 8 udisks`, `man 1 udisksctl` (udisks 2.10.1) (to verify) | — | the Syntek OS system-tools repository |
| 07 Auditing and logging privileged actions | `man 1 journalctl`, `man 7 systemd.journal-fields` (systemd 255) (to verify) | — | the Syntek OS system-tools repository |
