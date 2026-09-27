# Syllabus — ui-10-web-admin-dashboard

**Track**: ui · **Phase**: U3 · **Path**: Later · **Detail**: outline · **Prerequisites**: sec-01-principles-threat-modelling-and-law; sec-04-linux-security-model; os-13-nas-edition or os-14-router-edition (the profile the dashboard serves); ui-07-system-tools-tui lesson 01 (privilege separation) recommended; sec-08-web-application-security recommended for lesson 06
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

The NAS and router profiles run without a desktop, so their day-to-day administration is a small web dashboard served
on the local network. It was moved out of the NAS topic into its own because it plays to Sam's strongest existing
skills — HTML, HTMX and PHP — and because it carries a security topic of its own: an admin login, cross-site request
forgery, and a web process that never runs as root. The lessons build it as a thin web client over the same privileged
helper pattern ui-07 teaches, then test it the way sec-08 tests a web application — only in the isolated lab. It is
marked **Later** and is an outline until U3 opens. This repository has no PHP code track (`code/src/CONTEXT.md`), so
every build lands in the Syntek OS web-dashboard repository (created when this build starts); os-13 and os-14 cite this
topic for their dashboards.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The dashboard's shape: HTMX, PHP and a privileged helper | 1 sitting | yes — dashboard skeleton | Security |
| 02 | Admin authentication and sessions | 2–3 sittings | yes — login and sessions | Security |
| 03 | Cross-site request forgery and state-changing requests | 1 sitting | yes — CSRF defence | Security |
| 04 | Never running as root | 2–3 sittings | yes — hardened service and helper | Security, Safety |
| 05 | Exposing it safely on a NAS or router | 1 sitting | yes — network exposure | Security, Safety |
| 06 | Testing the dashboard in the lab | 2–3 sittings | yes — lab test report | Security, Safety |

---

## 01 — The dashboard's shape: HTMX, PHP and a privileged helper

- **Objective:** Sam can lay out the dashboard's architecture — browser, web server, PHP process, privileged helper —
  and say what each part may do.
- **Builds on:** Sam's existing HTML, HTMX and PHP; ui-07 lesson 01 (an unprivileged front-end and a privileged
  helper); os-13 or os-14 (what the profile needs administered).
- **Key ideas:**
  - htmx lets the server answer with HTML fragments that replace parts of the page (`hx-get`, `hx-post`, `hx-target`,
    `hx-swap`), so the dashboard needs little or no client-side JavaScript of its own.
  - The PHP process runs as its own unprivileged user — PHP-FPM requires every pool to name one.
  - Anything that needs root goes to the helper through its narrow, typed interface; PHP never runs a shell command.
  - The dashboard is another client of the same actions the TUI system tools use.
- **Recall targets:** which component holds which privilege; why PHP never builds a shell command.
- **Build:** yes, outline (sketched in full when U3 opens) — a read-only status page served by an unprivileged PHP-FPM
  pool, in the Syntek OS web-dashboard repository (created when this build starts).
- **Security lens:** the browser, the network and every request are untrusted; the trust boundaries are drawn first
  (sec-01).
- **Sources:** (to verify when the topic opens) htmx documentation, htmx 2.x (<https://htmx.org/docs/>); PHP manual,
  "FPM Configuration" (`user`) (<https://www.php.net/manual/en/install.fpm.configuration.php>).
- **Done when:** the status page renders through htmx and the PHP process is shown (`ps`) running as its own user.

## 02 — Admin authentication and sessions

- **Objective:** Sam can build an admin login that stores passwords safely, resists guessing, and manages sessions so
  they cannot be fixed, stolen through script or reused after logout.
- **Builds on:** lesson 01; sec-05-applied-cryptography lesson 01 (what a hash does and does not guarantee) where
  taken; password hashing (Argon2id, bcrypt) is taught here from the OWASP Password Storage Cheat Sheet.
- **Key ideas:**
  - Store only slow, salted password hashes: PHP's `password_hash` offers bcrypt and Argon2id, and OWASP gives
    minimum Argon2id parameters.
  - No default password: the first run forces the admin to set one.
  - Slow down guessing: throttle failed logins without letting an attacker lock the admin out.
  - Sessions: strict mode, a new session ID at login, cookies marked `Secure`, `HttpOnly` and `SameSite`, and a real
    logout.
- **Recall targets:** why a fast hash is wrong for passwords; when a session ID must change.
- **Build:** yes, outline (sketched in full when U3 opens) — login, logout and session handling in the Syntek OS
  web-dashboard repository, with tests for the throttling and the session-ID change.
- **Security lens:** OWASP Top 10:2025 A07, Authentication Failures, is the class this lesson defends against.
- **Sources:** (to verify when the topic opens) PHP manual `password_hash`
  (<https://www.php.net/manual/en/function.password-hash.php>), "Session Runtime Configuration"
  (<https://www.php.net/manual/en/session.configuration.php>) and `session_regenerate_id`
  (<https://www.php.net/manual/en/function.session-regenerate-id.php>); OWASP Password Storage Cheat Sheet
  (<https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html>), Authentication Cheat Sheet
  (<https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html>) and Session Management Cheat
  Sheet (<https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html>).
- **Done when:** the tests pass and Sam explains each session setting's purpose unaided.

## 03 — Cross-site request forgery and state-changing requests

- **Objective:** Sam can stop another site from making an admin's browser change the NAS or router's settings.
- **Builds on:** lesson 02.
- **Key ideas:**
  - A state change is never a `GET`.
  - The synchronizer token pattern: a per-session secret the server checks on every state-changing request, sent as a
    form field or a custom header — never trusted from a cookie alone.
  - With htmx, `hx-headers` attaches the token to every request from a page.
  - `SameSite` cookies are a second layer, not the only one.
- **Recall targets:** why a cookie alone cannot prove intent; where the token travels with htmx.
- **Build:** yes, outline (sketched in full when U3 opens) — token issue and check in the Syntek OS web-dashboard
  repository, with a test that a request without the token is refused.
- **Security lens:** a CSRF against a router's dashboard can reconfigure the network the admin is on.
- **Sources:** (to verify when the topic opens) OWASP Cross-Site Request Forgery Prevention Cheat Sheet
  (<https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html>); htmx
  `hx-headers` (<https://htmx.org/attributes/hx-headers/>) and "Web Security Basics (with htmx)"
  (<https://htmx.org/essays/web-security-basics-with-htmx/>).
- **Done when:** the refusal test passes and a forged request from a second origin in the lab is rejected.

## 04 — Never running as root

- **Objective:** Sam can run the web stack with the least privilege that works and route every privileged action
  through the helper, with the service hardening measured rather than assumed.
- **Builds on:** lessons 01–03; sec-04 (capabilities, namespaces, seccomp, the sandbox launcher); ui-07 lessons 01 and
  07 (helper design, audit trail).
- **Key ideas:**
  - The web server and PHP pool run as dedicated users; the helper is the only privileged process.
  - Service hardening options (`NoNewPrivileges=`, `ProtectSystem=`, `CapabilityBoundingSet=` and others) narrow what
    a compromised process could do.
  - The helper accepts a fixed list of actions with validated arguments and records each in the audit trail.
- **Recall targets:** what an attacker who takes over the PHP process can and cannot do; which component writes the
  audit record.
- **Build:** yes, outline (sketched in full when U3 opens) — hardened service units and the helper's action list in the
  Syntek OS web-dashboard repository, checked in a VM guest.
- **Security lens:** OWASP Top 10:2025 A01, Broken Access Control, and A02, Security Misconfiguration.
- **Safety:** VM guests on an isolated lab network only; Claude never runs `sudo`.
- **Sources:** (to verify when the topic opens) `man 5 systemd.exec` (systemd 255); OWASP Top 10:2025
  (<https://owasp.org/Top10/2025/>).
- **Done when:** in the VM guest, no dashboard process but the helper runs as root, and each hardening option is
  confirmed in effect.

## 05 — Exposing it safely on a NAS or router

- **Objective:** Sam can make the dashboard reachable only where it should be — the management network — over an
  encrypted connection, with login throttled.
- **Builds on:** lessons 02–04; os-09 (addresses, nftables); os-13 or os-14; sec-05 (TLS) where taken.
- **Key ideas:**
  - Listen only on the management interface, and allow it in the firewall only from that network.
  - Serve it over TLS; the certificate choice for a device on a home network is decided when the topic opens.
  - Never expose it to the internet by default; remote administration goes through the router's VPN (os-14).
- **Recall targets:** the two places that decide who can reach the dashboard; why internet exposure is off by default.
- **Build:** yes, outline (sketched in full when U3 opens) — listener, firewall rules and TLS set-up for the dashboard,
  tested from inside and outside the management network in the lab.
- **Security lens:** a dashboard that cannot be reached cannot be attacked from there — the cheapest control first.
- **Safety:** the isolated lab network from os-09 only; never the home network.
- **Sources:** (to verify when the topic opens) `man 8 nft`; the nftables wiki
  (<https://wiki.nftables.org/wiki-nftables/index.php/Main_Page>).
- **Done when:** in the lab, the dashboard answers from the management network and nowhere else.

## 06 — Testing the dashboard in the lab

- **Objective:** Sam can test his own dashboard against the OWASP Top 10 in the isolated lab and write up the
  findings.
- **Builds on:** lessons 01–05; sec-08 (the OWASP Top 10 and an intercepting proxy, on lab targets); sec-12
  (methodology and reporting) where taken.
- **Key ideas:**
  - The dashboard is Sam's own system, so testing it is authorised — and still only inside the lab (sec-01's law and
    scope lesson).
  - Walk the OWASP Top 10:2025 as a checklist against the dashboard, with an intercepting proxy.
  - Each finding becomes a fix and a regression test in the Syntek OS web-dashboard repository.
- **Recall targets:** which Top 10 classes lessons 02–05 defend against; what the scope document says.
- **Build:** yes, outline (sketched in full when U3 opens) — a short test report and the fixes it produced, in the
  Syntek OS web-dashboard repository.
- **Security lens:** OWASP Top 10:2025 as the map; the report follows sec-12's format.
- **Safety:** attack tooling runs in the lab's attacker VM, never on the host; only Sam's own dashboard is tested.
- **Sources:** (to verify when the topic opens) OWASP Top 10:2025 (<https://owasp.org/Top10/2025/>); the Web
  Security Testing Guide (<https://owasp.org/www-project-web-security-testing-guide/>).
- **Done when:** the report lists each Top 10 class as tested, with findings fixed or recorded.
