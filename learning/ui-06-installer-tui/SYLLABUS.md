# Syllabus — ui-06-installer-tui

**Track**: ui · **Phase**: U2 · **Path**: Later · **Detail**: outline · **Prerequisites**: ui-03-tui-architecture-and-testing (all lessons); os-10-profiles-and-installer (the installer backend as a transaction; testing profile images in QEMU); os-02-storage-and-boot-fundamentals (disk images, partitions, file systems)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The installer is the guided front-end to os-10's installer backend, which plans, confirms, applies and verifies an
installation as a transaction. This TUI adds what a person needs on top: a flow they cannot get lost in, a disk choice
they cannot get catastrophically wrong, a profile choice among the seven Syntek OS profiles, input validated before it
reaches the backend, and a way back after a failure. It is marked **Later** because the first edition (server and
homelab) can be installed with the backend's thin CLI; it is an outline until U2 reaches it, when the Build sketches and
sources are filled in and re-verified. The installer lands in the Syntek OS installer repository (created when this
build starts), where os-10's backend lives. Every run targets a VM disk image — never a host disk.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Guided flows as state machines | 1 sitting | yes — flow state machine | — |
| 02 | Choosing a disk safely | 2–3 sittings | yes — disk chooser | Security, Safety |
| 03 | Choosing a profile | 1 sitting | yes — profile picker | — |
| 04 | Validating what the user types | 1 sitting | yes — input validators | Security |
| 05 | Recovering from failure, and testing the installer in QEMU | 2–3 sittings | yes — unattended QEMU run | Efficiency, Safety |

---

## 01 — Guided flows as state machines

- **Objective:** Sam can model an installer's steps as an explicit state machine in which every screen, every
  transition and the back action are defined, and an impossible transition does not compile.
- **Builds on:** ui-03 lesson 01 (model, messages, update); os-10's installer backend (plan → confirm → apply →
  verify).
- **Key ideas:**
  - One enum variant per step, carrying the data gathered so far; transitions are the only way to move.
  - Back never loses entered data; forward is allowed only when the step's input is valid.
  - The final step hands a complete plan to the backend — the TUI never writes to a disk itself.
- **Recall targets:** why an enum with data beats a step number plus loose fields; where validation sits in a
  transition.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — a flow state machine for the installer's
  steps, with `update` tests for every transition; lands in the Syntek OS installer repository (created when this
  build starts).
- **Sources:** (to verify when the topic opens) The Rust Programming Language (Rust 1.92.0), chapter 6 "Enums and
  Pattern Matching" (<https://doc.rust-lang.org/1.92.0/book/ch06-00-enums.html>); os-10's installer backend lesson.
- **Done when:** every transition in the flow is covered by an `update` test, the back action included.

## 02 — Choosing a disk safely

- **Objective:** Sam can build a disk-selection screen whose safeguards make wiping the wrong disk very hard — and, in
  lessons, impossible, because only VM disk images are accepted.
- **Builds on:** lesson 01; os-02 lessons 01–02 (block devices, disk images and loop devices); os-10's
  destructive-action safeguards.
- **Key ideas:**
  - Identify a disk by stable facts — model, size, serial, and whether it holds a mounted or running root — read from
    `lsblk`'s JSON output, not by a `/dev/sdX` name that can change between boots.
  - Show exactly what will be destroyed; confirmation is typed, not a keypress, and defaults to "no".
  - The disk holding the running system is never offered.
  - In every lesson the only valid target is a regular image file attached to a VM.
- **Recall targets:** why a device name is not an identity; which disks are never offered.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — a disk-selection screen over `lsblk` JSON
  that offers only VM disk images, with refusal tests; lands in the Syntek OS installer repository (created when this
  build starts).
- **Security lens:** the installer runs as root in the live system, so the disk list it shows is a trust decision.
- **Safety:** VM disk images only; no host disks; Claude never runs `sudo`.
- **Sources:** (to verify when the topic opens) `man 8 lsblk` (`--json`, util-linux 2.39.3); `man 8 losetup`
  (util-linux 2.39.3); `man 1 qemu-img` (QEMU 8.2.2).
- **Done when:** tests prove the running root and any non-image target are refused, and one full install ran against a
  VM disk image.

## 03 — Choosing a profile

- **Objective:** Sam can present the seven Syntek OS profiles so a person picks the right one, and pass the choice to
  the backend as data.
- **Builds on:** lessons 01–02; os-10 (one base, many profiles); the profile matrix.
- **Key ideas:**
  - Each profile's description comes from the profile specifications, not from text written into the TUI.
  - A profile choice sets defaults the later steps can still change — or cannot, where the profile fixes them.
  - Beginner users need plain words; expert users need the details within one keypress.
- **Recall targets:** where profile text comes from; which later choices a profile may lock.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — a profile picker whose text comes from the
  profile specifications, with a screen test; lands in the Syntek OS installer repository (created when this build
  starts).
- **Sources:** (to verify when the topic opens) `project-management/src/07-OS-PROFILES/PROFILE-MATRIX.md`; os-10's
  profile lessons.
- **Done when:** a screen test shows every profile's summary drawn from the specification data.

## 04 — Validating what the user types

- **Objective:** Sam can validate host names, user names and passwords at the moment they are entered, with messages
  that say what to change.
- **Builds on:** lessons 01–03; ui-02 lesson 06 (accessible feedback).
- **Key ideas:**
  - Host names follow the rules in `hostname(7)`: labels of 1–63 characters, 253 in total, letters, digits and
    hyphens, never a leading hyphen.
  - User-name rules depend on how the system's `useradd` was built: `useradd(8)` gives a strict set and notes a relaxed
    Debian one, so Syntek OS states its own rule and the TUI enforces that rule.
  - Passwords are never logged, echoed or kept longer than needed; the error says what is wrong, not the value.
  - The backend validates again: the TUI's checks are for the person, the backend's for safety.
- **Recall targets:** the host-name rules; why the backend re-validates; what never goes in a log.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — validators for host name, user name and
  password, tested from a table of inputs; lands in the Syntek OS installer repository (created when this build
  starts).
- **Security lens:** input from the installer reaches configuration files written as root — validation is also
  injection prevention.
- **Sources:** (to verify when the topic opens) `man 7 hostname` (Linux man-pages 6.7); `man 8 useradd`, section
  CAVEATS (shadow-utils 4.13).
- **Done when:** a table of valid and invalid inputs passes through the validators with the expected messages.

## 05 — Recovering from failure, and testing the installer in QEMU

- **Objective:** Sam can make a failed installation recoverable from the TUI and run the whole installer end to end in
  QEMU without a person at the keyboard.
- **Builds on:** lessons 01–04; os-10 (the backend's logged state after a failed apply; testing every profile image in
  QEMU).
- **Key ideas:**
  - A failure shows what completed, what did not, and what the backend's log says — then offers retry or start again.
  - Scripted input drives the TUI through a full install inside a VM, so every profile is tested on every change.
  - Disk-image snapshots make each test start from a clean state.
- **Recall targets:** what the user sees after a failed apply; how an unattended test run is made repeatable.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — failure and retry screens, plus an
  unattended install driven by scripted input inside QEMU; lands in the Syntek OS installer repository (created when
  this build starts).
- **Efficiency lens:** installation time and peak memory per profile, recorded against the profile's budget.
- **Safety:** QEMU and VM disk images only; no host disks.
- **Sources:** (to verify when the topic opens) `man 1 qemu-img` (snapshots, QEMU 8.2.2); os-10's QEMU test harness
  lesson.
- **Done when:** an unattended run installs each first-edition profile into a fresh image and the images boot.
