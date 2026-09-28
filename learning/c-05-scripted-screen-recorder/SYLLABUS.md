# Syllabus — c-05-scripted-screen-recorder

**Track**: c · **Phase**: P2 · **Path**: Later · **Detail**: full · **Prerequisites**: P1's exit gate; P2's file descriptors, processes (`fork`, `execve`, `waitpid`), pipes and `dup2`, and `sigaction`; `tooling-03` lesson 05; `sec-01` lesson 04; `libxtst-dev` for lesson 04 (`GAPS.md`); `sec-04` lesson 07 before the fixed-name fixture (lesson 03's follow-up)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic is stage 1 of the scripted demo recorder
(`project-management/src/08-DECISIONS/ADR-MS001-SCRIPTED-RECORDER-STAGED-LEARNING-PROJECT-27-09-2026.md`):
a small C program that reads a tape — a script in the style of vhs, extended for GUI applications —
starts a private Xvfb display and one application, types the tape's keys through XTest, grabs frames,
pipes them to ffmpeg, and writes a timeline beside a silent video. It puts P2's processes, pipes and
signals to work on a real tool, and it is a Later leaf: never part of P2's exit gate, and its
milestones never delay the shell or allocator projects. Every Build below adds one unit to a single
folder, `code/src/c/msNNN-scripted-recorder/` (planned — `NNN` from the stage's project spec,
`PROJ-MS###-SCRIPTED-RECORDER-C.md`, written through `project-management/workflows/05-project-spec/`,
which is the contract; a Build line here is only a candidate), each with `check.h` tests and checked by
`make test`, `make san` and `make memcheck`. The frame grab (lesson 06) is written as a separable
unit, because stage 2 ports it into the capture-library repository's X11 backend. Facts were checked
on this host on 27/09/2026 with Xvfb 2:21.1.12, ffmpeg 6.1.1, libx11-dev 1.8.7, libxext-dev 1.3.4 and
xkb-data 2.41; the XTest development headers (`libxtst-dev`) are not installed, so lesson 04 is
**Blocked** until Sam installs them.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | A tape language: lexing and parsing | 2–3 sittings | yes — tape parser | Security |
| 02 | Starting Xvfb and the app: `fork`, `execve`, `waitpid`, readiness, teardown | 2–3 sittings | yes — launcher | Safety |
| 03 | The first-cut fixture: a throwaway home, a built environment, a private display and cookie | 1 sitting | yes — fixture | Security |
| 04 | Keys through XTest under a pinned gb layout, on a separate connection (Blocked) | 2–3 sittings | yes — XTest input | — |
| 05 | Window focus without a window manager | 1 sitting | yes — focus | — |
| 06 | Capturing frames with XShm, as a separable unit | 2–3 sittings | yes — frame grab | Efficiency |
| 07 | Frames down a pipe to ffmpeg, and backpressure | 2–3 sittings | yes — encoder pipe | Efficiency |
| 08 | Waiting on the screen, not the clock | 1 sitting | yes — `WaitStable` | Efficiency |
| 09 | A timeline: WebVTT and ffmetadata chapters | 1 sitting | yes — timeline writer | — |
| 10 | Captions from the script, geometries as real renders, sections joined by concat | multi-session build | yes — full render | Efficiency, Security |

---

## 01 — A tape language: lexing and parsing

- **Objective:** Sam can write a lexer and a recursive-descent parser in C for a line-oriented tape
  language, with an owner for every allocation, and explain each error it reports by line and column.
- **Builds on:** P1 (strings, structs, multi-file C, `check.h`); P2's dynamic memory and data
  structures with written-down ownership.
- **Key ideas:**
  - The core commands follow vhs's documented grammar — `Output`, `Require`, `Set`, `Type`, key names
    with an optional repeat count, `Ctrl[+Alt][+Shift]+<key>` chords, `Sleep`, `Wait`, `Hide`/`Show`,
    `Screenshot`, `Source`, `Env` — re-implemented from the command reference, never copied from
    vhs's code.
  - Extensions vhs lacks: a `Super` modifier, `Launch`, `Mark "label"`, `WaitStable [timeout]`,
    `Focus`, and the rare `Click` and `MoveTo`.
  - The lexer turns characters into tokens (keywords, quoted strings with escapes, numbers,
    durations such as `500ms`); the parser turns tokens into a command list whose nodes have one
    owner and one free path.
  - An unknown command, an unterminated string or a bad duration stops the render with its line and
    column — never "best effort", because a silently skipped key corrupts a video.
  - vhs's own example tapes are the compatibility corpus: every one must parse.
- **Recall targets:** say whether the lexer or the parser owns a given error; predict how
  `Type "say \"hi\""`, `Ctrl+Alt+T` and `Enter 2` tokenise.
- **Build:** the parser unit — lexer, parser and command list — with `check.h` cases for every
  command, the error positions and the vhs examples. Pure C, no X11 yet.
- **Security lens:** a tape is input; `Source` resolves only relative to the tape's own directory and
  refuses to include itself, so a tape cannot pull in an arbitrary file or loop for ever.
- **Sources:** vhs README → VHS Command Reference, <https://github.com/charmbracelet/vhs> (MIT);
  `code/docs/TESTING.md` (the `check.h` harness).
- **Done when:** every vhs example tape and every extension parses, each malformed case fails with the
  right line and column, and the gates pass.

## 02 — Starting Xvfb and the app: `fork`, `execve`, `waitpid`, readiness, teardown

- **Objective:** Sam can start a private Xvfb and one application as child processes, learn which
  display Xvfb took without sleeping, and reap both on every exit path.
- **Builds on:** P2 processes, pipes and `dup2`, and `sigaction`; `tooling-03` lesson 05 (cleanup on
  every exit path, now in C).
- **Key ideas:**
  - `-displayfd fd` makes the server search for a free display number and write it, newline-ended,
    to a descriptor the parent passed down a pipe: readiness and the display number in one step, with
    no fixed sleep and no guessed display.
  - `-screen 0 WxHx24` sets the geometry, `-nolisten tcp` refuses network clients, `-nocursor` hides
    the cursor, and `-extension RECORD` disables the X RECORD extension; `-tst` would disable XTest,
    which the recorder needs.
  - `execve` takes an explicit environment, so the application's `DISPLAY` is the new display, never
    the host's.
  - A child outlives a killed parent unless told otherwise: `prctl(PR_SET_PDEATHSIG)` in the child,
    `waitpid` in the parent, and a `sigaction` handler that only sets a flag (async-signal-safety).
  - `-std=c17` hides the POSIX declarations until a feature-test macro is defined; the policy is set
    once in `code/docs/BUILD.md` at the stage's first milestone, not in the exercise.
- **Recall targets:** explain how `-displayfd` removes the start-up race; predict whether Xvfb is still
  running after the recorder is killed with SIGKILL, with and without `PR_SET_PDEATHSIG`.
- **Build:** the launcher unit — starts Xvfb with `-displayfd`, then a test client (`xclock` is
  installed), reaps both and reports each child's exit status; `check.h` cases for the argument
  builder and the status decoding.
- **Safety:** a private display only, never the host's `DISPLAY`; nothing runs with `sudo`.
- **Sources:** `man 1 Xvfb` and `man 1 Xserver` (xvfb 2:21.1.12) → `-screen`, `-displayfd`,
  `-nolisten`, `-nocursor`, `-extension`, `-tst`; `man 2 fork`, `man 2 execve`, `man 2 waitpid`,
  `man 2 prctl` (`PR_SET_PDEATHSIG`), `man 2 sigaction`, `man 7 signal`, `man 7 feature_test_macros`.
- **Done when:** the gates pass, killing the recorder at each step leaves no Xvfb or client running
  (checked with `pgrep`), and Sam explains the readiness handshake unaided.

## 03 — The first-cut fixture: a throwaway home, a built environment, a private display and cookie

- **Objective:** Sam can build the clean environment a public video is recorded in, and name what each
  part keeps out of the frame.
- **Builds on:** lesson 02; `sec-01` lesson 04 (a milestone's threat model).
- **Key ideas:**
  - A throwaway home from `mkdtemp`, with the XDG directories inside it, so an application starts
    with fresh settings and no history — no recent files, no account names, no first-run surprises.
  - An environment built from scratch (`PATH`, `HOME`, `DISPLAY`, `XAUTHORITY`, `LANG` and nothing
    else) instead of passing on Sam's own, which carries paths, tokens and his user name.
  - A random cookie (`getrandom`) written with `xauth` into a private authority file, and Xvfb started
    with `-auth`: only clients holding the cookie may connect, so no other local process can read the
    screen or type into it.
  - No notification daemon, a fixed shell prompt, and a fresh profile for each browser or editor.
  - Fixed user and host names need namespaces, which arrive later through `sec-04` lesson 07's
    launcher; whether a public render waits for them is settled in the stage's project spec.
- **Recall targets:** list what a video can leak from an unscrubbed desktop; explain what the cookie
  protects and from whom.
- **Build:** the fixture unit — creates and removes the home, builds the environment and writes the
  authority file; `check.h` cases for the environment builder, and a check that the directory is gone
  after both a clean exit and a failure.
- **Security lens:** a published video is public for good: `.claude/CLAUDE.md` Section 5's
  public-repo hygiene covers it, and the fixture is where that rule is kept.
- **Sources:** `man 1 Xserver` → `-auth`, GRANTING ACCESS; `man 7 Xsecurity`; `man 1 xauth`;
  `man 3 mkdtemp`; `man 2 getrandom`; `man 7 environ`.
- **Done when:** a client without the cookie is refused, the child's environment holds only the listed
  variables, the home is removed on every exit path, and the gates pass.

## 04 — Keys through XTest under a pinned gb layout, on a separate connection (Blocked)

- **Objective:** Sam can turn each character of a `Type` command into the right key presses under a
  pinned layout, and explain why input runs on its own X connection.
- **Builds on:** lessons 01–03.
- **Key ideas:**
  - XTest fakes a key by **keycode**, a physical position, not a character: the layout decides what
    appears, so the recorder pins it with `setxkbmap -layout gb -model pc105` on its own display.
  - The gb and us layouts disagree on `"` and `@`, among others: a tape typed under the wrong layout
    types the wrong character without any error.
  - Character → keysym → keycode with `XKeysymToKeycode`; the shift level comes from
    `XGetKeyboardMapping`. Levels 1–2 (plain and Shift) are covered here; AltGr levels need the XKB
    library, a stretch the stage's spec may include.
  - A character with no keycode in the layout fails the render loudly.
  - A non-zero delay in `XTestFakeKeyEvent` stops the server processing that client's other requests
    until it expires, so input and capture use separate `Display` connections, and the delay is 0.
  - Held keys autorepeat: presses stay short, and the server's `-ardelay` is known.
- **Recall targets:** predict what one keycode types under gb and under us; explain why input and
  capture never share a connection.
- **Build:** **Blocked** — the XTest development headers (`libxtst-dev`) are not installed (`GAPS.md`
  → the scripted recorder's build dependencies). When unblocked, the input unit: `Type`, key names,
  counts and chords through XTest, with `check.h` cases for the character-to-keycode table. Until
  then the lesson is reading and the lookup table, which needs only Xlib.
- **Sources:** XTEST Extension Library, version 2.2,
  <https://www.x.org/releases/current/doc/libXtst/xtestlib.html> → `XTestFakeKeyEvent`; Xlib — C
  Language X Interface, <https://www.x.org/releases/current/doc/libX11/libX11/libX11.html> →
  keyboard encoding (`XKeysymToKeycode`, `XGetKeyboardMapping`); `man 1 setxkbmap`;
  `man 7 xkeyboard-config`; `/usr/share/X11/xkb/symbols/gb` (xkb-data 2.41).
- **Done when:** a tape typing every printable ASCII character produces exactly that text in a test
  client under gb, the same tape under us shows the predicted differences, and the gates pass.

## 05 — Window focus without a window manager

- **Objective:** Sam can make the application's window receive the recorder's keys on a display with
  no window manager, and say why that is not automatic.
- **Builds on:** lessons 02 and 04.
- **Key ideas:**
  - With no window manager, nothing places windows or hands out focus: focus follows the pointer
    root, and a new window appears wherever the application asks.
  - The recorder finds the application's top-level window (a `MapNotify` on the root's
    substructure, or a walk with `XQueryTree`, matched by `WM_CLASS`) and calls `XSetInputFocus` on it.
  - Geometry comes from the application's own flags, since there is no window manager to size it.
  - Running a minimal window manager instead is a design choice with its own costs, weighed in the
    lesson.
- **Recall targets:** explain where keys go on a bare X server before and after `XSetInputFocus`.
- **Build:** the focus unit — waits for the application's window, then focuses it; checked by typing
  into `xmessage` or a test client and reading back the result.
- **Sources:** Xlib manual (link in lesson 04) → `XSetInputFocus`, `XQueryTree`, `MapNotify` events;
  Inter-Client Communication Conventions Manual → `WM_CLASS`,
  <https://www.x.org/releases/current/doc/xorg-docs/icccm/icccm.html>.
- **Done when:** the application receives the keys with no window manager running, and Sam explains
  why without reading the code.

## 06 — Capturing frames with XShm, as a separable unit

- **Objective:** Sam can grab the root window into shared memory and describe the pixel layout he gets
  back, in a unit that depends on nothing else in the recorder.
- **Builds on:** lessons 02 and 05; P2's `mmap` and heap lessons.
- **Key ideas:**
  - `XShmGetImage` fills an image in a System V shared-memory segment, skipping the copy through the
    X socket that `XGetImage` makes; `XGetImage` on a drawable that is not viewable fails with
    `BadMatch`.
  - A 24-bit-depth ZPixmap uses 32 bits per pixel, in a byte order read from the image's
    `byte_order` and colour masks (BGRx is expected here); rows are `bytes_per_line` apart, which can
    exceed the width times four.
  - One 1920x1080 frame is about 8.3 MB; the unit reuses one segment rather than allocating per
    frame, and detaches and removes it on every exit path.
  - The unit's interface is start, grab, stop, and nothing else — the shape stage 2 turns into the
    capture library's trait.
  - Stretch: Xvfb's `-fbdir` exposes the screen as an xwd-format file that can be `mmap`ped directly,
    cursor included; whether it tears mid-draw is unverified.
- **Recall targets:** compute a frame's size from width, height and `bytes_per_line`; explain what
  `XShmGetImage` saves over `XGetImage`.
- **Build:** the frame-grab unit, with its own header and no includes from the rest of the recorder;
  `check.h` cases that grab a known test pattern and compare pixels.
- **Efficiency lens:** time per grab at 1920x1080 and 1080x1920 with `clock_gettime(CLOCK_MONOTONIC)`,
  and peak resident memory.
- **Sources:** `man 3 XShm`; MIT-SHM, the MIT Shared Memory Extension,
  <https://www.x.org/releases/current/doc/xextproto/shm.html>; Xlib manual → `XGetImage`;
  `man 1 Xvfb` → `-fbdir`, FILES; `man 2 shmget`; `man 2 mmap`; `/usr/include/X11/XWDFile.h`.
- **Done when:** a known pattern is read back pixel-exact at both geometries, the segment is gone after
  every exit, and `make san` and `make memcheck` pass (or any Xlib suppression is recorded in
  `code/docs/MEMORY-SAFETY.md`, never in the exercise).

## 07 — Frames down a pipe to ffmpeg, and backpressure

- **Objective:** Sam can feed raw frames to ffmpeg through a pipe and predict what the recorder does
  when the pipe is full and when ffmpeg dies.
- **Builds on:** lessons 02 and 06; P2 pipes and `dup2`.
- **Key ideas:**
  - `pipe`, `fork`, `dup2` onto ffmpeg's standard input, then
    `-f rawvideo -pixel_format bgr0 -video_size WxH -framerate F -i pipe:0`, encoded to
    `-pix_fmt yuv420p` in an MP4 written to a seekable file, not a pipe.
  - rawvideo carries no timestamps, so time is a virtual clock: frame n is at n/F, whatever the wall
    clock says.
  - A full pipe blocks `write`, which delays the next frame rather than dropping one; a short write is
    finished in a loop.
  - A pipe holds 65,536 bytes by default — far less than one frame — and `fcntl(F_SETPIPE_SZ)` raises
    it up to the system limit.
  - If ffmpeg exits, the next write raises SIGPIPE or fails with EPIPE; the recorder ignores the
    signal, handles the error, and reports ffmpeg's exit status.
- **Recall targets:** predict the recorder's behaviour for a slow encoder and for a crashed one; say
  why the virtual clock makes a slow render still correct.
- **Build:** the encoder-pipe unit — writes the frame-grab unit's frames to ffmpeg; checked by
  rendering a known pattern and reading back the frame count and duration with `ffprobe`.
- **Efficiency lens:** 1080p BGRx at 30 frames per second is about 249 MB/s through the pipe; measure
  throughput with the default and a raised pipe size, and whether the encoder keeps up.
- **Sources:** `man 1 ffmpeg-formats` → rawvideo (`pixel_format`, `video_size`, `framerate`);
  `man 1 ffmpeg-protocols` → pipe; `man 7 pipe` → Pipe capacity; `man 2 fcntl` → `F_SETPIPE_SZ`;
  `man 2 pipe`; `man 2 dup2`; `man 2 write`; `man 7 signal`.
- **Done when:** a rendered pattern has exactly the expected frame count and duration, a killed
  ffmpeg ends the render with a clear error and no zombie, and the gates pass.

## 08 — Waiting on the screen, not the clock

- **Objective:** Sam can make a tape wait until the screen has settled, with a timeout that fails the
  render, instead of guessing a sleep.
- **Builds on:** lessons 06 and 07.
- **Key ideas:**
  - `Sleep` guesses how long an application takes; too short records a half-drawn window, too long
    wastes the viewer's time.
  - vhs's `Wait` reads terminal text, which a GUI screen does not offer; `WaitStable [timeout]` hashes
    each grabbed frame and succeeds after a set number of unchanged frames.
  - A timeout fails the render; it never carries on and records whatever is there.
  - The X DAMAGE extension reports which regions changed, a cheaper signal than hashing every frame.
  - A blinking caret or a clock never settles: the fixture turns blinking off, or the wait masks that
    region.
  - ffmpeg's `freezedetect` filter finds frozen stretches in a finished render — a check afterwards,
    not a wait.
- **Recall targets:** explain why a stable-screen wait can hang, and the two ways the recorder avoids
  it.
- **Build:** the `WaitStable` unit on top of the frame grab; checked against a test client that
  changes for a known time, then stops.
- **Efficiency lens:** hashing cost per frame against the DAMAGE route.
- **Sources:** X DAMAGE Extension protocol,
  <https://www.x.org/releases/current/doc/damageproto/damageproto.txt>; `man 1 ffmpeg-filters` →
  freezedetect.
- **Done when:** the wait succeeds within a frame or two of the change ending, a never-settling client
  times out with a clear error, and the gates pass.

## 09 — A timeline: WebVTT and ffmetadata chapters

- **Objective:** Sam can write the timeline a voice-over is recorded against: a timestamp per command
  and a chapter per `Mark`, as a WebVTT file and as ffmetadata chapters.
- **Builds on:** lessons 01 and 07.
- **Key ideas:**
  - The timeline is computed from the parsed tape and the virtual frame clock, never from observed
    input.
  - A WebVTT file starts with `WEBVTT` and holds cues timed `hh:mm:ss.ttt --> hh:mm:ss.ttt`; chapter
    cues carry a chapter title as their text.
  - ffmetadata starts with `;FFMETADATA1` and describes each chapter in a `[CHAPTER]` section with a
    `TIMEBASE`, a `START`, an `END` and a `title`; ffmpeg embeds them in the MP4.
  - The two outputs come from one data structure, so they cannot disagree.
- **Recall targets:** convert a frame number at a given frame rate into a WebVTT timestamp; say why the
  timeline never reads the keyboard.
- **Build:** the timeline-writer unit, pure C beside the parser; `check.h` cases for timestamp
  formatting, chapter boundaries and a tape with no marks.
- **Sources:** WebVTT: The Web Video Text Tracks Format (W3C Candidate Recommendation Draft),
  <https://www.w3.org/TR/webvtt1/> → Section 3.5 WebVTT chapter cues; `man 1 ffmpeg-formats` →
  METADATA.
- **Done when:** the `.vtt` file and the embedded chapters of a test render agree with the tape to the
  frame, and the gates pass.

## 10 — Captions from the script, geometries as real renders, sections joined by concat

- **Objective:** Sam can render one tape, in sections, at two geometries, with captions burned in from
  the script, and re-render one section without touching the others.
- **Builds on:** lessons 01–09.
- **Key ideas:**
  - Captions are generated from the tape's commands and burned in with the `subtitles` filter
    (libass) or `drawtext`; the font is pinned through `fontsdir`. Nothing is read from
    `/dev/input`, and the X RECORD extension stays disabled: the recorder is never a keylogger.
  - Each geometry — 1080x1920 portrait and 1920x1080 landscape — is a fresh render on an Xvfb of that
    size, never a crop; whether a tape may branch per geometry is settled in the stage's spec.
  - One render file per tape section, joined by the concat demuxer under identical encoder settings,
    so re-recording a section re-renders one file.
  - Determinism: depth, fonts, layout, application versions and encoder settings are pinned and
    logged with every render.
  - Renders are build output and are never committed.
- **Recall targets:** explain why a crop is not a portrait render; say what must match for the concat
  demuxer to join sections cleanly.
- **Build:** the full render — a two-section tape at both geometries with its `.vtt` and chapters;
  checked by frame count, chapter times and a viewing against the tape.
- **Efficiency lens:** the stage's Budget — render time, peak resident memory and frames per second —
  measured and recorded in the project spec.
- **Security lens:** every published render passes the fixture checklist from lesson 03 before it
  leaves the machine.
- **Sources:** `man 1 ffmpeg-filters` → subtitles (`fontsdir`), drawtext; `man 1 ffmpeg-formats` →
  concat, METADATA; `man 1 Xvfb` → `-screen`.
- **Done when:** a two-section tape renders at both geometries with a `.vtt` file and ffmetadata
  chapters that match the tape, one section re-renders alone, the gates pass, and the Budget is
  measured.
