# Mission — sec-08-web-application-security

**Started**: not yet · **Family**: sec · **Phase**: S2 · **Milestone**: not yet allocated

## Why

_Drafted from Sam's planning conversation of 27/09/2026 — confirm or rewrite in your own words at
the first lesson._

The NAS and router editions are planned to have a web dashboard, and Sam's strongest existing skills
are HTML, HTMX, PHP and JavaScript — which is exactly the surface web attacks target. This topic uses
that strength: it teaches the common web vulnerability classes on a deliberately vulnerable training
app inside the lab, then has Sam fix each class in code he writes. The result is the security review
the `ui-10` dashboard will need to pass — admin authentication, CSRF protection, injection defence,
never running as root — learned by breaking and fixing rather than by reading a checklist. All
practice stays on the licensed training target inside the isolated lab.

## Can do it when

- Sam can name the OWASP Top 10 categories and classify a bug into one.
- Sam can explain and demonstrate injection and broken access control on the training target.
- Sam can use an intercepting proxy to inspect and modify requests against the lab target.
- Sam can fix each class in a small web application he writes.

## Parked for later

- Building the lab — `sec-06` (a prerequisite).
- The NAS/router dashboard itself — `ui-10`.
- Privilege escalation once a foothold exists — `sec-09`, lab only.
