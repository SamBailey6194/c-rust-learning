# Syllabus — kernel-09-virtual-input-devices

**Track**: kernel · **Phase**: P4 · **Path**: Later · **Detail**: outline · **Prerequisites**: kernel-01-build-and-boot-in-qemu (all lessons); kernel-02-modules lesson 06 (a device node and the user-space boundary); kernel-03-syscalls-memory-and-concurrency lessons 01 and 03 (the system call boundary; virtual memory); the scripted recorder's stage 2 `Done` (the Rust port, whose input trait lesson 04 implements); a `KERNEL-PLAN` spec for the recorder guest (`project-management/workflows/06-kernel-spec/`) before the first Build
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

Stage 5a of the scripted demo recorder
(`project-management/src/08-DECISIONS/ADR-MS001-SCRIPTED-RECORDER-STAGED-LEARNING-PROJECT-27-09-2026.md`): the
kernel's input subsystem seen from user space, and a virtual keyboard made through uinput, inside a QEMU guest. The
recorder's earlier stages type through a display server (XTest on X11, a virtual-keyboard protocol on Wayland) or
through QEMU itself (`kernel-11-qemu-display-and-input-control`); this stage goes one level down, to the device
interface those layers read from. It adds an input backend to the recorder only — **no capture-library part**, because
input injection stays in the recorder and the capture library returns frames alone. It is **Later** and **outline**
detail, a leaf that no Core topic lists, and every lesson runs in a QEMU guest only: the host's `/dev/uinput` is live,
and a virtual keyboard there would type into Sam's own session. Guest programs are small, statically linked C, packed
into kernel-01's initramfs the way kernel-02's misc-device test is, under `code/src/kernel/` (planned — added at P4).

Version facts to re-verify on the day (read 27/09/2026): the host's UAPI header `linux/uinput.h` (linux-libc-dev
6.8.0) is at `UINPUT_VERSION` 5, the revision that added `UI_DEV_SETUP` and `UI_ABS_SETUP` in place of writing a
`struct uinput_user_dev`; the pinned tree's own headers are the ones a guest program builds against.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The input subsystem and evdev, from user space | 1 sitting | yes — evdev reader | Security, Safety |
| 02 | A uinput keyboard | 2–3 sittings | yes — uinput keyboard | Security, Safety |
| 03 | An input guest: fragment and initramfs in kernel-01's harness | 1 sitting | yes — input guest | Safety |
| 04 | The recorder's uinput input backend | multi-session build | yes — recorder uinput backend | Efficiency, Safety |

---

## 01 — The input subsystem and evdev, from user space

- **Objective:** Sam can trace a key press from a device driver through the input core to an evdev node, read the
  events a device emits, and say what an event's type, code and value mean.
- **Builds on:** kernel-02-modules lesson 06 (a device node, `read` across the boundary); kernel-03 lesson 01 (the
  system call boundary with `strace`); P2 file I/O and `ioctl`.
- **Key ideas:**
  - Drivers report to the input core, which hands events to handlers; evdev is the generic handler, and each input
    device gets a `/dev/input/eventN` node.
  - Every read returns whole `struct input_event` records: a time stamp, a type (`EV_KEY`, `EV_REL`, `EV_ABS` …), a
    code and a value; a key's value is 1 for press, 0 for release and 2 for autorepeat.
  - `EV_SYN` with `SYN_REPORT` closes a packet: the events before it happened together.
  - `ioctl`s query a device before reading it — its name (`EVIOCGNAME`) and which event types and codes it can emit
    (`EVIOCGBIT`); `EVIOCGRAB` takes a device exclusively.
  - A key code names a **position** (`KEY_A` is where A sits on a US keyboard), not a character; the layout that turns
    positions into characters lives in user space.
- **Recall targets:** what a `SYN_REPORT` separates; the three values of an `EV_KEY` event; why a key code is not a
  character.
- **Build:** a small, statically linked evdev reader that prints a device's name, capabilities and events, in
  `code/src/kernel/msNNN-uinput-keyboard/` (planned — added at P4), packed into the guest's initramfs and reused as
  lesson 02's self-test. Checked in the guest on the AT keyboard QEMU's PC machines emulate, with keys sent from
  QEMU's monitor by its `sendkey` command (kernel-01 lesson 06's `Ctrl+a c`).
- **Security lens:** an evdev node is a keylogger's interface. The recorder never reads real input devices — its
  captions come from the tape — and this reader only ever opens devices inside the guest.
- **Safety:** QEMU guest only; the reader is never run against the host's `/dev/input`.
- **Sources:** (to verify when the topic opens) "Introduction" to the input subsystem
  (<https://docs.kernel.org/input/input.html>, the event interface); "Input event codes"
  (<https://docs.kernel.org/input/event-codes.html>); include/uapi/linux/input.h and input-event-codes.h at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/include/uapi/linux/input.h?h=v7.2>);
  QEMU "QEMU Monitor" (<https://www.qemu.org/docs/master/system/monitor.html>, `sendkey`); `man 2 ioctl`.
- **Done when:** the reader lists the guest keyboard's capabilities and prints press, release and `SYN_REPORT` events,
  and Sam predicts the event sequence for a Shift+A chord before reading it.

## 02 — A uinput keyboard

- **Objective:** Sam can create a virtual keyboard through `/dev/uinput`, type a fixed sequence with it, and destroy
  it cleanly.
- **Builds on:** lesson 01; kernel-02-modules lesson 06 (writing to a device node).
- **Key ideas:**
  - A program opens `/dev/uinput`, declares what the device can emit (`UI_SET_EVBIT` for `EV_KEY`, `UI_SET_KEYBIT`
    for each key), describes it (`UI_DEV_SETUP` with an id and a name), then creates it (`UI_DEV_CREATE`).
  - Typing is writing `struct input_event` records: a press, `SYN_REPORT`, a release, `SYN_REPORT`.
  - Consumers need a moment to notice a new device, so the kernel's uinput example pauses after creating it; events
    written before anyone listens are lost.
  - `UI_GET_SYSNAME` names the new device in sysfs, which leads to its event node for a self-test.
  - Pointer motion as `EV_REL` passes through pointer acceleration in user space; a scripted pointer uses `EV_ABS`
    with `UI_ABS_SETUP` instead.
- **Recall targets:** the order of the setup `ioctl`s and why declaration comes before creation; what happens to events
  written before a consumer opens the device; why a scripted pointer avoids `EV_REL`.
- **Build:** a uinput keyboard that types a fixed string and destroys its device, in
  `code/src/kernel/msNNN-uinput-keyboard/` (planned — added at P4), statically linked and packed into the guest's
  initramfs. Checked by lesson 01's reader, run on the new device's event node, printing exactly the expected codes.
- **Security lens:** injecting input is as powerful as the user at the keyboard; the host's `/dev/uinput` is root-only
  (mode 0600, seen 27/09/2026), and the guest keeps it so.
- **Safety:** QEMU guest only — on the host, the same program would type into Sam's session. Root in the throwaway
  guest only; Claude never runs `sudo`.
- **Sources:** (to verify when the topic opens) "uinput module" (<https://docs.kernel.org/input/uinput.html>,
  keyboard events and mouse movements); include/uapi/linux/uinput.h at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/include/uapi/linux/uinput.h?h=v7.2>).
- **Done when:** the virtual keyboard's events read back exactly, and Sam explains each `ioctl` in order and what
  would fail without it.

## 03 — An input guest: fragment and initramfs in kernel-01's harness

- **Objective:** Sam can build a guest kernel with uinput and evdev enabled and boot it in kernel-01's harness so that
  the lesson 02 self-test runs at boot and reports on the serial console.
- **Builds on:** lessons 01–02; kernel-01-build-and-boot-in-qemu lessons 03, 05 and 06 (fragments, the initramfs,
  the scripted boot).
- **Key ideas:**
  - `CONFIG_INPUT_UINPUT` and `CONFIG_INPUT_EVDEV` go in a small fragment merged over kernel-01's QEMU fragment
    (with the AT keyboard driver lesson 01 read, if the base config lacks it); `devtmpfs` then creates `/dev/uinput`
    and the event nodes.
  - `/init` runs the self-test, prints a verdict on `ttyS0` and powers the guest off, so the harness's exit status
    carries the result.
  - The fragment, the QEMU command and the serial evidence are the recorder guest's `KERNEL-PLAN` and `KERNEL-IMPL`
    records (`project-management/src/06-KERNEL/`).
  - A guest program built against the pinned tree's UAPI headers (`make headers_install`) matches the guest kernel,
    whatever the host's headers say.
- **Recall targets:** which two options the self-test needs and what each gives; how the harness tells a passing
  self-test from a failing one.
- **Build:** the input fragment and the self-test `/init`, beside kernel-01's harness in
  `code/src/kernel/msNNN-uinput-keyboard/` (planned — added at P4). Checked by the scripted boot returning 0 on a
  passing self-test and non-zero when a key is dropped on purpose.
- **Safety:** QEMU only, no disk and no network in the guest; nothing installed on the host.
- **Sources:** (to verify when the topic opens) drivers/input/Kconfig and drivers/input/misc/Kconfig at v7.2
  (<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/drivers/input/misc/Kconfig?h=v7.2>,
  `INPUT_UINPUT`); "Exporting kernel headers for use by userspace"
  (<https://docs.kernel.org/kbuild/headers_install.html>); the kernel-01 harness sources.
- **Done when:** the scripted boot passes and fails as predicted, and the serial excerpt is in the `KERNEL-IMPL`.

## 04 — The recorder's uinput input backend

- **Objective:** Sam can add a uinput implementation of the recorder's input trait, so that a tape's key lines type
  into the guest, and show that the capture library is untouched.
- **Builds on:** lessons 01–03; the recorder's stage 2 input trait (the Rust port); P3 FFI and `unsafe`
  (`code/docs/FFI.md`).
- **Key ideas:**
  - The recorder's input trait (key, type, pointer) gains one more implementation; the capture library does not change,
    because input never enters it.
  - Tape key names map to key codes, and key codes are positions, so the guest's layout is pinned in its image as it
    is pinned for every other backend.
  - The recorder on the host cannot open the guest's `/dev/uinput`: the stage 5a spec settles whether the backend runs
    inside the guest or as a small guest agent the recorder drives over `AF_VSOCK`.
  - Every `ioctl` through FFI sits in an `unsafe` block with a `// SAFETY:` comment.
- **Recall targets:** why this stage has no capture-library part; where the layout is pinned and why codes alone are
  not enough.
- **Build:** the uinput input backend in the scripted-recorder repository (created at the recorder's stage 2), with any
  guest-side part packed into the guest's initramfs. Checked by a tape's keys being read back from the virtual
  device's event node by lesson 01's reader, with serial-console evidence in the milestone's `KERNEL-IMPL`.
- **Efficiency lens:** keys per second and press-to-read latency in the guest, and the guest's RAM, recorded as the
  milestone's Budget.
- **Safety:** QEMU guest only; never the host's `/dev/uinput`.
- **Sources:** (to verify when the topic opens) "uinput module" (<https://docs.kernel.org/input/uinput.html>);
  `man 7 vsock`; the Rust book, "Using Trait Objects" (<https://doc.rust-lang.org/book/ch18-02-trait-objects.html>);
  the Rustonomicon, FFI (<https://doc.rust-lang.org/nomicon/ffi.html>).
- **Done when:** a stage-1 tape's key lines type into the guest and read back exactly, the capture library's diff is
  empty, and the Budget is recorded.
