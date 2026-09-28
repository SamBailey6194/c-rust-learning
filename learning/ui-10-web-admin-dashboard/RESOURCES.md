# Resources — ui-10-web-admin-dashboard

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 The dashboard's shape: HTMX, PHP and a privileged helper | htmx 2.x documentation, <https://htmx.org/docs/>; PHP manual "FPM Configuration", <https://www.php.net/manual/en/install.fpm.configuration.php> (to verify when the topic opens) | — | the Syntek OS web-dashboard repository (created when this build starts) |
| 02 Admin authentication and sessions | PHP `password_hash`, <https://www.php.net/manual/en/function.password-hash.php>; OWASP Password Storage, <https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html>, and Session Management, <https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html> (to verify) | — | the Syntek OS web-dashboard repository |
| 03 Cross-site request forgery and state-changing requests | OWASP CSRF Prevention Cheat Sheet, <https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html>; htmx `hx-headers`, <https://htmx.org/attributes/hx-headers/> (to verify) | — | the Syntek OS web-dashboard repository |
| 04 Never running as root | `man 5 systemd.exec` (systemd 255); OWASP Top 10:2025, <https://owasp.org/Top10/2025/> (to verify) | — | the Syntek OS web-dashboard repository |
| 05 Exposing it safely on a NAS or router | `man 8 nft`; nftables wiki, <https://wiki.nftables.org/wiki-nftables/index.php/Main_Page> (to verify); `sec-05-applied-cryptography` lessons 08–13 (repo topic) | — | the Syntek OS web-dashboard repository |
| 06 Testing the dashboard in the lab | OWASP Top 10:2025, <https://owasp.org/Top10/2025/>; Web Security Testing Guide, <https://owasp.org/www-project-web-security-testing-guide/> (to verify) | — | the Syntek OS web-dashboard repository |
