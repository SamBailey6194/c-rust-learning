# Resources — os-12-homelab-edition

| Lesson | Primary source (pinned) | House guide | Code |
| --- | --- | --- | --- |
| 01 Containers on the kernel's primitives | OCI Runtime Specification v1.3.0, <https://github.com/opencontainers/runtime-spec/blob/v1.3.0/bundle.md>; crun 1.30.1, <https://github.com/containers/crun/tree/1.30.1>; docs.kernel.org "Control Group v2", <https://docs.kernel.org/admin-guide/cgroup-v2.html>; `man 7 namespaces`, `man 7 user_namespaces` | — | `code/src/os/` (planned — added at P6) |
| 02 Container images, registries and digests | OCI Image Format Specification v1.1.1, "Descriptors", <https://github.com/opencontainers/image-spec/blob/v1.1.1/descriptor.md> | `code/docs/RUST-CODING-PRINCIPLES.md`; `code/docs/TESTING.md` | `code/src/rust/crates/msNNN_oci_digest/` (planned) |
| 03 Virtual machines with KVM | docs.kernel.org "Running nested guests with KVM", <https://docs.kernel.org/virt/kvm/x86/running-nested-guests.html>; BLFS 13.1 qemu-11.1.1, <https://www.linuxfromscratch.org/blfs/view/13.1-systemd/postlfs/qemu.html>; `man 1 qemu-system` (8.2.2) | — | `code/src/os/` (planned — added at P6) |
| 04 Monitoring: what the kernel already reports | docs.kernel.org "PSI - Pressure Stall Information", <https://docs.kernel.org/accounting/psi.html>; docs.kernel.org "Control Group v2" | `code/docs/RUST-CODING-PRINCIPLES.md` | `code/src/rust/crates/msNNN_pressure_status/` (planned) |
| 05 Monitoring: collecting and alerting | Prometheus "Exposition formats", <https://prometheus.io/docs/instrumenting/exposition_formats/>; node_exporter v1.12.1, <https://github.com/prometheus/node_exporter/tree/v1.12.1> | `code/docs/TESTING.md` | `code/src/rust/crates/msNNN_pressure_status/` (planned) |
