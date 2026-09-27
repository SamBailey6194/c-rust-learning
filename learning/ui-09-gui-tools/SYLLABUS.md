# Syllabus — ui-09-gui-tools

**Track**: ui · **Phase**: U3 · **Path**: Later · **Detail**: outline · **Prerequisites**: ui-08-gui-foundations (all lessons); ui-05-package-manager-tui (a thin client of the package-manager library)
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The beginner profile needs graphical tools, and Syntek OS's own GUI tools are written in Slint. This topic reuses
rather than re-teaches: a GUI is one more thin client of the same libraries the TUIs use (os-07's "library crate plus
thin client" pattern), so the lessons concentrate on what is new — Slint's declarative model, one real tool for the
beginner profile, packaging a desktop application, and testing it with the people it is for. Slint's licence options
(GPL-3.0-only, a royalty-free licence or a commercial one) are none of them compatible with this repository's
GPL-2.0-only, so **no Slint crate enters this repository**: the Slint work lands in the Syntek OS GUI-tools repository
(created when this build starts), which chooses its own licence (tooling-05 lesson 05 teaches how). It is marked
**Later** and is an outline until U3 opens.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | One library, many clients | 1 sitting | no | — |
| 02 | Slint's model: markup, properties, bindings and callbacks | 2–3 sittings | yes — first Slint window | Security |
| 03 | A settings or package tool for the beginner profile | multi-session build | yes — beginner GUI tool | Security, Safety |
| 04 | Packaging a desktop application | 1 sitting | yes — desktop entry and icons | — |
| 05 | Usability testing with friends and family | 2–3 sittings | no | — |

---

## 01 — One library, many clients

- **Objective:** Sam can show that a GUI tool needs no new system logic — it calls the same library API as the CLI and
  the TUI — and list what does change in a GUI client.
- **Builds on:** os-07 (library crate plus thin CLI); ui-05 lesson 01 (the TUI as a thin client); ui-07 lesson 01 (the
  privileged helper).
- **Key ideas:**
  - The library is the contract; the CLI, the TUI and the GUI are three views of it.
  - What changes: the event loop, retained-mode widgets, long operations surfaced as progress in a window, and
    accessibility through the toolkit.
  - What must not change: validation, verification and authorisation stay in the library and the helper, so a GUI
    cannot become the weak client.
- **Recall targets:** which checks live in the library and why a client must not re-implement them.
- **Build:** none — a design note listing the library and helper calls the lesson 03 tool needs.
- **Sources:** (to verify when the topic opens) os-07's library-plus-CLI lesson; ui-05 lesson 01;
  `code/docs/RUST-CODING-PRINCIPLES.md` Section 5.
- **Done when:** the design note maps every screen of the planned tool to an existing library or helper call.

## 02 — Slint's model: markup, properties, bindings and callbacks

- **Objective:** Sam can describe a user interface in the `.slint` language, connect it to Rust through properties
  and callbacks, and explain how bindings keep it up to date.
- **Builds on:** lesson 01; ui-08 lesson 03 (a retained-mode toolkit); ui-03 lesson 01 (model and update).
- **Key ideas:**
  - A `.slint` file declares elements and their properties; Rust code is generated from it, inline with a macro or
    through a build script.
  - Assigning an expression to a property makes a binding, re-evaluated when what it reads changes (Slint's
    reactivity).
  - `in`, `out` and `in-out` properties and callbacks form the boundary between the markup and the Rust logic.
  - Accessibility properties start from `accessible-role`, which must be set before the others.
- **Recall targets:** what makes a property assignment a binding; which side owns state, markup or Rust.
- **Build:** yes, outline (sketched in full when U3 opens) — a first Slint window in the Syntek OS GUI-tools repository
  (created when this build starts); nothing Slint enters this repository.
- **Security lens:** the Syntek OS GUI-tools repository's licence is checked against Slint's options there, before its
  first release (Slint's `LICENSE.md` at the version used).
- **Sources:** (to verify when the topic opens) Slint 1.18.1 documentation — "Slint Language"
  (<https://docs.slint.dev/1.18.1/docs/slint/guide/language/concepts/slint-language/>), "Reactivity"
  (<https://docs.slint.dev/1.18.1/docs/slint/guide/language/concepts/reactivity/>), "Properties"
  (<https://docs.slint.dev/1.18.1/docs/slint/guide/language/coding/properties/>), "Functions and Callbacks"
  (<https://docs.slint.dev/1.18.1/docs/slint/guide/language/coding/functions-and-callbacks/>) and the common
  accessibility properties (<https://docs.slint.dev/1.18.1/docs/slint/reference/common/>); the Rust API
  (<https://docs.rs/slint/1.18.1/slint/>); Slint `LICENSE.md` at v1.18.1
  (<https://github.com/slint-ui/slint/blob/v1.18.1/LICENSE.md>).
- **Done when:** the window's state changes flow through bindings, and Sam explains the markup/Rust boundary unaided.

## 03 — A settings or package tool for the beginner profile

- **Objective:** Sam can build one complete GUI tool for the beginner profile — a package tool over os-07's library or
  a settings tool over ui-07's helper — that a beginner can use without the terminal.
- **Builds on:** lessons 01–02; ui-05 (preview, confirmation, cancellation) or ui-07 (helper, polkit, audit).
- **Key ideas:**
  - Beginner-first wording and defaults, from the beginner profile's specification.
  - The same safety rules as the TUIs: full preview before change, verification failures block, cancellation only at
    consistent points.
  - Accessibility checked with Orca and the keyboard, as in ui-08 lesson 05.
- **Recall targets:** which ui-05 or ui-07 rules carry over unchanged, and why.
- **Build:** yes, outline (sketched in full when U3 opens) — the tool in the Syntek OS GUI-tools repository, tested
  against ui-05's fake backend or ui-07's helper, then in a VM guest running the beginner profile.
- **Security lens:** the GUI calls the privileged helper; it never runs privileged itself.
- **Safety:** changes to a system only inside a VM guest; Claude never runs `sudo`.
- **Sources:** (to verify when the topic opens) `project-management/src/07-OS-PROFILES/PROFILE-BEGINNER.md`; ui-05 and
  ui-07's lessons.
- **Done when:** a person who has never used a terminal completes the tool's main task in the VM guest.

## 04 — Packaging a desktop application

- **Objective:** Sam can make a GUI tool appear correctly in a desktop's menus — desktop entry, icons at every size —
  and ship it as a Syntek OS package.
- **Builds on:** lesson 03; os-07 (the package format).
- **Key ideas:**
  - A `.desktop` file describes how the application appears and starts; `desktop-file-validate` checks it.
  - Icons are looked up by name through the icon theme; provide the sizes and a scalable version the specification
    expects.
  - The package installs these files where the specifications say, so every desktop profile finds them.
- **Recall targets:** the required keys of a desktop entry; how an icon is found by name.
- **Build:** yes, outline (sketched in full when U3 opens) — a desktop entry and icon set for the lesson 03 tool, in the
  Syntek OS GUI-tools repository, validated with `desktop-file-validate`.
- **Sources:** (to verify when the topic opens) Desktop Entry Specification 1.5
  (<https://specifications.freedesktop.org/desktop-entry/latest/>); Icon Theme Specification 0.13
  (<https://specifications.freedesktop.org/icon-theme/latest/>); `man 1 desktop-file-validate`.
- **Done when:** the tool appears with its icon in the menus of two desktop profiles in VM guests.

## 05 — Usability testing with friends and family

- **Objective:** Sam can plan and run a small moderated usability test of a Syntek OS tool with friends or family, with
  informed consent, and turn what he sees into prioritised issues.
- **Builds on:** lessons 03–04; ui-04 lesson 06 (a tool others can join).
- **Key ideas:**
  - Moderated testing: watch a participant attempt realistic tasks, thinking aloud, without being helped.
  - Good tasks set a clear goal and do not hint at how to reach it.
  - Informed consent before any session: who is researching, why, what is recorded and how it is kept.
  - Findings become issues ranked by how often and how badly they stopped someone.
- **Recall targets:** what makes a task leading; what a participant must be told before consenting.
- **Build:** none — a test plan, consent wording and a findings list in the Syntek OS GUI-tools repository's issues.
- **Sources:** (to verify when the topic opens) GOV.UK Service Manual, "Using moderated usability testing"
  (<https://www.gov.uk/service-manual/user-research/using-moderated-usability-testing>) and "Getting informed consent
  for user research" (<https://www.gov.uk/service-manual/user-research/getting-users-consent-for-research>).
- **Done when:** three sessions are complete and each finding is an issue with a severity.
