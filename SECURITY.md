# Security Policy

## What this repository is

c-rust-learning is a **personal learning repository**: C and Rust exercises, study notes, and —
from phase P4 onwards — custom Linux kernel configurations and distro builds meant to run inside
QEMU. **Nothing here is production software.** It runs no service, hosts no data and has no
users, and no release is supported in the sense of receiving security fixes.

Exercise code is written while learning, so it will contain bugs, including memory-safety bugs
that the exercises exist to find and fix. A bug in an exercise is best reported as an ordinary
issue — that is a correction, and it is welcome (see `CONTRIBUTING.md`).

## What is worth reporting privately

- A **secret or personal data** committed to the repository by mistake.
- A **script, hook or CI workflow** here that would harm the machine of someone who cloned and
  ran it as documented.
- **Guidance in the docs that is unsafe to follow** — for example, instructions that would
  install a custom kernel or module on a host rather than in QEMU.

## Reporting

**Please do not open a public issue for any of the above.** Use GitHub's private vulnerability
reporting instead:

1. Open the repository's **Security** tab on GitHub.
2. Choose **Report a vulnerability**.

That opens a private advisory visible only to you and the maintainer. GitHub's guide to the
process: <https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability>.

Please include the file path, what happens, and how to reproduce it. This is maintained by one
person in their own time, so responses are best-effort rather than on a fixed timetable; you
will hear back once the report has been read.

## Out of scope

- Vulnerabilities in the upstream Linux kernel, QEMU, gcc, Rust or any other upstream project —
  report those to the upstream project through its own process.
- Bugs in exercise code that affect nobody but the person running it — open a normal issue.
