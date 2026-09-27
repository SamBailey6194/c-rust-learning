# Resources — sec-13-hardening-and-secure-boot

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Hardening baselines | CIS Benchmarks (<https://www.cisecurity.org/cis-benchmarks>; site returns 403 to automated fetch on 27/09/2026 — read in a browser, pin the benchmark and version at lesson open) | — | the Syntek OS build-system repository (created when that build starts); note in this topic folder |
| 02 Auditing with lynis | Lynis (<https://cisofy.com/lynis/>); `lynis --help` (no host `man` page, checked 27/09/2026) | — | note in this topic folder |
| 03 The UEFI Secure Boot chain | shim (<https://github.com/rhboot/shim>, <https://github.com/rhboot/shim/blob/main/README.md>); kernel module signing (<https://docs.kernel.org/admin-guide/module-signing.html>); sbctl (<https://github.com/Foxboron/sbctl>) | — | `code/src/os/` (planned — added at P6), OVMF harness, VM only |
| 04 Signing kernels and bootloaders | `sbsign` (<https://man.archlinux.org/man/sbsign.1>); sbctl (<https://github.com/Foxboron/sbctl>); systemd-boot (<https://www.freedesktop.org/software/systemd/man/latest/systemd-boot.html>; checked via <https://man.archlinux.org/man/systemd-boot.7> when freedesktop.org answers 418, as on 27/09/2026) | — | the Syntek OS build-system repository (created when that build starts) |
| 05 Measured boot and TPM basics | kernel TPM docs (<https://docs.kernel.org/security/tpm/index.html>); `tpm2-tools`/`swtpm` `--help` at lesson open | — | `code/src/os/` (planned — added at P6), VM harness with swtpm |
