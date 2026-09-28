# Syllabus — ui-11-consent-first-remote-help

**Track**: ui · **Phase**: U2 · **Path**: Later · **Detail**: outline · **Prerequisites**: P3 including its async Rust topic; ui-03-tui-architecture-and-testing (all lessons); ui-01-terminal-fundamentals lessons 01, 02 and 06; os-18-own-network-operations lessons 01, 04–05 and 10; os-11-server-edition lesson 03 (SSH hardening); sec-01-principles-threat-modelling-and-law lessons 03–05; sec-04-linux-security-model lessons 02 and 05–07; sec-05-applied-cryptography lessons 05–06 and 08–12; tooling-05-licensing-and-collaboration lessons 05 and 08; recommended: ui-07-system-tools-tui lessons 01 and 07, sec-16-detection-response-and-disclosure lesson 01, sec-17-malware-concepts-and-defence lesson 02
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic builds a remote-help tool that is consent-first by construction, inside the ten constraints of
`project-management/src/08-DECISIONS/ADR-MS001-REMOTE-HELP-TOOL-CONSENT-FIRST-27-09-2026.md` (Proposed): the helped
person starts every session, sees it the whole time, grants control separately, keeps the log and can end it with one
key. Scope is Linux terminal sessions only. Help with existing tools comes first, in
`os-18-own-network-operations` lesson 10; this topic is the tool Sam builds afterwards. Lessons 01–02 build here, and
from lesson 03 the tool lives in the remote-help repository (created when this build starts), so no TLS crate ever
meets this repository's `deny.toml`. Everything is proved between two VM guests on os-09's isolated lab network; a
real session happens only under
`project-management/src/08-DECISIONS/ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md` (its family-device
clause), run by Sam. Lessons 01, 06 and 09 are written in full only after the research notes they name exist, and no
lesson here states what the law means before then. It is marked **Later** and is an outline until U2 reaches it; U2's
exit gate does not wait on it.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | Consent-first remote help: requirements, the law and abuse cases | 1 sitting | no | Security, Safety |
| 02 | The session as a state machine | 2–3 sittings | yes — help-session state machine | Security |
| 03 | Mutual TLS on the private CA, with expiry and revocation | 2–3 sittings | yes — mTLS handshake | Security |
| 04 | The consent prompt and an indicator the helper cannot hide | 2–3 sittings | yes — consent TUI | Security |
| 05 | A shared terminal with no privilege beyond the session | multi-session build | yes — session PTY | Efficiency, Security, Safety |
| 06 | The session log the helped person keeps | 2–3 sittings | yes — session log | Security |
| 07 | Ending cleanly: time limits, teardown and no persistence | 1 sitting | yes — teardown check | Security, Safety |
| 08 | Proving it in the lab: the abuse-case suite | 2–3 sittings | yes — abuse-case suite | Security, Safety |
| 09 | Publishing a dual-use tool, and the first real session | 2–3 sittings | yes — release and consent record | Security, Safety |

---

## 01 — Consent-first remote help: requirements, the law and abuse cases

- **Objective:** Sam can state the tool's requirements, whose consent each kind of access needs, and the abuse cases
  the design must defeat, before any code exists.
- **Key ideas and sources:** written after `research/REMOTE-HELP-CONSENT-AND-THE-COMPUTER-MISUSE-ACT.md` and
  `research/REMOTE-HELP-TOOL-AND-SECTION-3A.md` (both planned) exist. MITRE ATT&CK T1219 (Remote Access Tools,
  <https://attack.mitre.org/techniques/T1219/>) is the abuse framing to verify then.

## 02 — The session as a state machine

- **Objective:** Sam can model a help session as a Rust enum state machine in which every transition is the helped
  side's decision, and prove with tests that control never happens without a grant.
- **Builds on:** lesson 01 (the requirements); P3 enums, pattern matching and tests; ui-03 lesson 01 (the Elm
  Architecture).
- **Key ideas:**
  - The states: request → view consent → optional control grant → active → ended or expired.
  - Every transition is taken by the helped side; the helper can only ask.
  - Nothing listens on the helped side: it dials out once, to a pinned identity.
  - Make the illegal states unrepresentable, so "control without a grant" cannot be constructed rather than being
    checked for.
- **Recall targets:** each state and who may leave it; why the helped side dials out instead of listening.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — a pure crate with no third-party crates,
  `code/src/rust/crates/msNNN_help_session/` (planned); `cargo test` proves there is no control without a grant, that
  a revoked grant returns to view, and that an expired session cannot resume.
- **Security lens:** constraints 1, 2 and 4 of the remote-help ADR start here, as types rather than checks.
- **Sources:** (to verify when the topic opens) The Rust Programming Language, chapters 6 (enums and pattern
  matching) and 11 (tests), <https://doc.rust-lang.org/book/>; the remote-help ADR's constraints.
- **Done when:** the tests pass, and Sam predicts the outcome of any event in any state unaided.

## 03 — Mutual TLS on the private CA, with expiry and revocation

- **Objective:** Sam can make the helped side and the helper authenticate each other with TLS 1.3 client
  certificates from his private CA, and refuse a foreign, expired or revoked identity.
- **Builds on:** lesson 02; sec-05 lessons 05–06 and 08–12 (TLS, key management and the private CA).
- **Key ideas:**
  - Both ends present leaves issued by the lab CA from sec-05; the intermediate is pinned in the tool's own trust
    file, never the system store.
  - Short lifetimes and revocation together: an expired leaf and a revoked leaf are both refused.
  - The crypto provider is constrained by `research/RUST-MTLS-STACK-LICENCES.md` (planned) and by the remote-help
    repository's entry on the approved outbound list; this lesson's text is finished after that note.
  - The first code in the remote-help repository.
- **Recall targets:** which side verifies which certificate; why the system trust store is not used.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — an mTLS handshake between two VM guests,
  in the remote-help repository (created when this build starts), with tests that a leaf from another CA, an expired
  leaf and a revoked leaf are each refused.
- **Security lens:** a pinned intermediate limits who can ever be a helper to what Sam's CA has signed.
- **Safety:** throwaway lab CA and keys only, made outside every repository; two VM guests on the isolated lab.
- **Sources:** (to verify when the topic opens) RFC 8446, Sections 4.3.2 and 4.4.2
  (<https://www.rfc-editor.org/rfc/rfc8446>); RFC 5280 (<https://www.rfc-editor.org/rfc/rfc5280>); rustls docs,
  `WebPkiClientVerifier` and `ConfigBuilder::with_client_auth_cert` (<https://docs.rs/rustls/latest/rustls/>).
- **Done when:** the handshake succeeds only between the two lab identities, and each refusal test passes.

## 04 — The consent prompt and an indicator the helper cannot hide

- **Objective:** Sam can build the helped side's consent screen and a status line that no helper input or output can
  suppress or spoof.
- **Builds on:** lessons 02–03; ui-01 lesson 02 (escape sequences); ui-02 lesson 06 (styling and accessibility);
  ui-03 lesson 04 (testing the rendered screen).
- **Key ideas:**
  - A ratatui consent screen: who is asking, for what kind of access, for how long; view by default, control a
    separate grant.
  - The indicator lives on screen space the session never draws into.
  - Helper output is escape-filtered before it reaches the helped terminal, so it cannot move the cursor over the
    indicator or retitle the window.
  - Readable without colour; the "end now" key is always shown.
- **Recall targets:** which bytes the filter removes and why; where the indicator lives.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — a consent TUI in the remote-help repository,
  tested with ratatui's `TestBackend`, including a hostile-output test that tries to overwrite the indicator.
- **Security lens:** a spoofable indicator is no indicator; constraint 3 is proved by the hostile-output test.
- **Sources:** (to verify when the topic opens) ratatui `TestBackend` (<https://docs.rs/ratatui/latest/ratatui/>);
  `man 4 console_codes`; ECMA-48, 5th edition
  (<https://ecma-international.org/publications-and-standards/standards/ecma-48/>).
- **Done when:** the hostile-output test cannot hide the indicator, and the screen reads correctly without colour.

## 05 — A shared terminal with no privilege beyond the session

- **Objective:** Sam can run the shared session on a pseudoterminal as the helped user, with no new privileges, and
  drop helper input entirely in view mode.
- **Builds on:** lessons 02–04; ui-01 lessons 01 and 06 (pseudoterminals, window size); sec-04 lessons 02 and 05–07
  (capabilities, seccomp, Landlock and the sandbox launcher).
- **Key ideas:**
  - `openpty`, a child shell as the helped user, and `PR_SET_NO_NEW_PRIVS` before it starts.
  - No credential caching: whether sudo's cached credentials reach the new terminal depends on sudoers
    `timestamp_type` (per terminal by default) and is checked in the lab, not assumed.
  - The protocol parser runs sandboxed with sec-04's layers.
  - View mode drops helper input at the source, not in the UI.
- **Recall targets:** why the session runs as the helped user; what `NO_NEW_PRIVS` stops.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — a session PTY in the remote-help repository,
  tested in a VM guest: helper keystrokes are ignored in view mode, and nothing gains a privilege the helped user
  lacks.
- **Efficiency lens:** latency per keystroke and bytes on the wire per keystroke, measured between the two guests.
- **Security lens:** constraint 8; the parser is the remote attack surface, so it holds the least privilege.
- **Safety:** VM guests on the isolated lab only; Claude never runs `sudo`.
- **Sources:** (to verify when the topic opens) `man 7 pty`, `man 3 openpty`, `man 2 prctl` (Linux man-pages 6.7);
  `man 5 sudoers` (`timestamp_type`, sudo 1.9.15p5); the kernel's Landlock and seccomp documentation
  (<https://docs.kernel.org/userspace-api/landlock.html>, <https://docs.kernel.org/userspace-api/seccomp_filter.html>).
- **Done when:** the VM tests pass, and Sam states the measured latency and bytes per keystroke.

## 06 — The session log the helped person keeps

- **Objective:** Sam can build a log, held on the helped device, that shows what the helper saw and did, with its
  entries hash-chained so that altering one breaks the chain after it.
- **Key ideas and sources:** written after `research/REMOTE-HELP-SESSION-RECORDS-AND-UK-GDPR.md` (planned) exists.

## 07 — Ending cleanly: time limits, teardown and no persistence

- **Objective:** Sam can prove a session ends at its limits and leaves nothing behind on the helped device.
- **Builds on:** lessons 02 and 05; os-06 (services, supervision and logging); sec-17 lesson 02 (where Linux
  persistence lives).
- **Key ideas:**
  - A hard maximum in code, and an idle timeout; an ended session cannot resume.
  - No service unit, timer, cron entry, profile hook or autostart entry, ever.
  - Teardown closes the terminal, the connection and every file the session opened.
- **Recall targets:** the persistence locations checked; why "no resume" matters.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — a teardown check: a before-and-after diff of
  sec-17 lesson 02's persistence locations in a VM guest, around a full session.
- **Security lens:** constraints 4 and 6; persistence is what turns a helping tool into an intruder's foothold.
- **Safety:** VM guests only.
- **Sources:** (to verify when the topic opens) `man 5 systemd.unit`, `man 5 systemd.timer` (systemd 255);
  `man 5 crontab`; the XDG Autostart specification (<https://specifications.freedesktop.org/autostart-spec/latest/>).
- **Done when:** the diff is empty after a session that ran to its hard maximum and after one ended early.

## 08 — Proving it in the lab: the abuse-case suite

- **Objective:** Sam can show that every abuse case from lesson 01 fails and is logged, between two VM guests, under a
  written scope.
- **Builds on:** lessons 01–07; sec-01 lessons 03–05 (threat models and written scope); sec-16 lesson 01 (auditd).
- **Key ideas:**
  - Each abuse case becomes a test that must fail safely and leave a log entry on the helped side.
  - A deliberately weakened build is a named, never-shipped target, never installed anywhere but a lab guest.
  - The tool stays visible in `ps`, the journal and auditd throughout.
- **Recall targets:** which constraint each abuse case attacks; why the weakened build exists.
- **Build:** yes, outline (sketched in full when U2 reaches this topic) — an abuse-case suite in the remote-help
  repository, run only in VM guests on the isolated lab.
- **Security lens:** the suite is the evidence the remote-help ADR's constraints hold.
- **Safety:** the harness and the weakened build run in VMs only
  (`project-management/src/08-DECISIONS/ADR-MS001-SECURITY-TRACK-AND-LAB-RULES-27-09-2026.md`, rules 2 and 5); the
  written scope comes first.
- **Sources:** (to verify when the topic opens) NIST SP 800-115 (<https://csrc.nist.gov/pubs/sp/800/115/final>);
  `man 8 auditctl`; MITRE ATT&CK T1219 (<https://attack.mitre.org/techniques/T1219/>).
- **Done when:** every abuse case fails and appears in the helped side's log, and the tool is visible in all three
  places throughout.

## 09 — Publishing a dual-use tool, and the first real session

- **Objective:** Sam can take the remote-help repository public with its non-goals and a `SECURITY.md` once the
  remote-help ADR's Publishing condition holds (the section 3A and GitHub notes exist and the ADR is Accepted), and
  run a first real session on a family device under the graduation path, with a written consent record.
- **Key ideas and sources:** written after `research/REMOTE-HELP-TOOL-AND-SECTION-3A.md` and
  `research/DUAL-USE-TOOLS-ON-GITHUB.md` (both planned) exist. A first public binary release also waits on
  `GAPS.md` → "Export rules for shipping cryptography".
