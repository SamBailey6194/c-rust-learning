# Syllabus — sec-08-web-application-security

**Track**: sec · **Phase**: S2 · **Path**: Later · **Detail**: outline · **Prerequisites**: sec-06 (lab and scope); Sam's existing PHP/JS/HTMX
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic plays to Sam's strongest existing skills — HTML, HTMX, PHP and JavaScript — by teaching
the web vulnerability classes on a deliberately vulnerable training application and then fixing each
class in code Sam writes. It directly protects the NAS and router web dashboard (`ui-10`), which
carries its own admin-authentication and CSRF concerns. All practice runs against the licensed
training target (OWASP Juice Shop) inside the `sec-06` lab, never against a live site. It is an
**outline** topic pending S2, an intercepting proxy and the Juice Shop image (tooling for the lab,
tracked in `GAPS.md` → "Security lab tools and the attacker VM").

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The OWASP Top 10 as a map | 1 sitting | no | Security |
| 02 | Injection and broken access control | 2–3 sittings | no | Security, Safety |
| 03 | Using an intercepting proxy | 1 sitting | no | Security, Safety |
| 04 | Fixing each class in your own code | multi-session build | no | Security |

---

## 01 — The OWASP Top 10 as a map

- **Objective:** Sam can name the OWASP Top 10:2025 web risk categories and place a given bug in
  one.
- **Builds on:** sec-01 (threat modelling); Sam's web experience.
- **Key ideas:**
  - The Top 10 as a prioritised map of common web risks, not an exhaustive list.
  - How each category maps onto a STRIDE threat (sec-01 lesson 03).
  - The categories that most affect a small admin dashboard (A01 Broken Access Control, which
    includes CSRF; A05 Injection; A07 Authentication Failures).
- **Recall targets:** given a described bug, name its Top 10 category.
- **Build:** none yet — defined when S2 opens.
- **Security lens:** the Top 10 is the checklist the dashboard (ui-10) is reviewed against.
- **Sources:** (to verify when S2 opens) OWASP Top 10:2025, <https://owasp.org/Top10/2025/> (A01 lists CWE-352, CSRF).
- **Done when:** Sam classifies a set of example bugs into Top 10 categories.

## 02 — Injection and broken access control

- **Objective:** Sam can explain injection and broken-access-control bugs and demonstrate them on the
  training target.
- **Builds on:** lesson 01; sec-06 lab.
- **Key ideas:**
  - Injection: untrusted input reaching an interpreter (SQL, shell, HTML) — a trust-boundary failure
    (sec-01 lesson 02).
  - Broken access control: missing checks let a user reach what they should not.
  - Each is demonstrated on the licensed training app, then fixed in Sam's own code (lesson 04).
- **Recall targets:** explain how injection crosses a trust boundary and what an access-control check
  must verify.
- **Build:** none yet — defined when S2 opens; practice on OWASP Juice Shop in the lab.
- **Security lens:** these are the highest-impact web classes for an admin tool.
- **Safety:** the vulnerable app runs only in the `sec-06` lab; never a live or third-party site
  (sec-01 lesson 05). Training-platform rules on publishing solutions are respected.
- **Sources:** (to verify when S2 opens) OWASP Juice Shop, <https://owasp.org/www-project-juice-shop/>; OWASP Web Security Testing Guide, <https://owasp.org/www-project-web-security-testing-guide/>.
- **Done when:** Sam demonstrates each class on the training target within scope.

## 03 — Using an intercepting proxy

- **Objective:** Sam can use an intercepting proxy (ZAP — zaproxy.org, formerly OWASP ZAP, now "ZAP by
  Checkmarx" — or Burp Suite Community) to inspect and modify requests against the lab target.
- **Builds on:** lesson 02.
- **Key ideas:**
  - The proxy sits between browser and app; it reveals the requests the UI hides.
  - Intercepting, replaying and modifying requests to test a control — against the lab target only.
  - The proxy is a defender's inspection tool as much as an attacker's.
- **Recall targets:** describe what an intercepting proxy shows that the browser does not.
- **Build:** none yet — defined when S2 opens.
- **Security lens:** seeing the raw request is how a control is actually verified.
- **Safety:** the proxy is pointed only at the lab training target, in scope.
- **Sources:** (to verify when S2 opens) ZAP documentation, <https://www.zaproxy.org/docs/>; Burp Suite documentation, <https://portswigger.net/burp/documentation/desktop>.
- **Done when:** Sam intercepts and modifies a request against the lab target and reads the effect.

## 04 — Fixing each class in your own code

- **Objective:** Sam can fix each studied vulnerability class in a small web application he writes.
- **Builds on:** lessons 01–03; Sam's PHP/JS/HTMX.
- **Key ideas:**
  - Parameterised queries against injection; server-side access-control checks; anti-CSRF tokens;
    output encoding against cross-site scripting.
  - The fix belongs in the code, not the proxy; the training target only shows what to fix.
  - This is the security review the ui-10 dashboard will pass.
- **Recall targets:** for each class, state the code-level fix.
- **Build:** none yet — a small deliberately-then-correctly-written web app; the code path is defined
  when S2 opens (a candidate: a fixtures app that later informs ui-10). Runs only in the lab.
- **Security lens:** fixing in code is the point of the whole topic.
- **Sources:** (to verify when S2 opens) OWASP Cross-Site Request Forgery Prevention Cheat Sheet, <https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html>; OWASP SQL Injection Prevention Cheat Sheet, <https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html>.
- **Done when:** Sam's application resists each class and a test or review confirms the fix.
