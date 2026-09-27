# Mission — ui-10-web-admin-dashboard

**Started**: not yet · **Family**: ui · **Phase**: U3 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at the first lesson._

The server-family profiles run without a desktop, and the plan Sam settled on allows a web dashboard for the NAS and
router profiles. It is the one Syntek OS tool that starts from what he already knows best — HTML, HTMX and PHP — so
the new learning is the security that a device's admin page demands: a login that resists guessing, requests another
site cannot forge, a web process that never runs as root, a page reachable only from the right network, and a test of
his own work in the lab. The planning conversation flagged the router edition as a real security responsibility; this
dashboard is where that responsibility meets a browser.

## Can do it when

- Sam can draw the dashboard's architecture and say which component holds which privilege.
- The admin login stores Argon2id or bcrypt hashes, throttles guessing, and changes the session ID at login.
- Every state-changing request carries a CSRF token that is checked, and a forged request is refused.
- In a VM guest, no dashboard process but the helper runs as root, with the service hardening confirmed.
- The dashboard is reachable only from the management network in the lab, over TLS.
- A lab test against the OWASP Top 10:2025 is written up, with its findings fixed or recorded.

## Parked for later

- The NAS and router editions themselves — os-13-nas-edition and os-14-router-edition.
- The web security classes in general, practised on deliberately vulnerable targets — sec-08-web-application-security.
- Multi-factor authentication for the admin login — a later lesson once the single-factor login is sound.
