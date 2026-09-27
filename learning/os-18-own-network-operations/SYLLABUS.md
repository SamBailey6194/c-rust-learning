# Syllabus — os-18-own-network-operations

**Track**: os · **Phase**: P6 · **Path**: Later · **Detail**: full · **Prerequisites**: `os-14-router-edition` lessons 01–05 and 07; `os-12-homelab-edition` lessons 04–05; `os-11-server-edition` lessons 03–06; `os-09-networking-fundamentals` lessons 03 and 05–07; `sec-05-applied-cryptography` lessons 06 and 08–12 (lesson 13 for renewal); `sec-01-principles-threat-modelling-and-law` lessons 03 and 05; `project-management/src/08-DECISIONS/ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`
**Status**: Planned · **Checked**: 27/09/2026 (sources re-verified by `/teach` step 3 before each lesson)

This topic runs Sam's own network — the router, the homelab, WireGuard for his roaming devices,
services on his private CA, monitoring, backups and remote help for family — from pieces the os and
sec tracks have already built. It re-teaches no protocol: it joins those pieces, proves each join in
`os-09`'s isolated lab, and only then deploys it to named devices under the graduation path
(`project-management/src/08-DECISIONS/ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`;
the checklist is in `project-management/docs/SAFETY-GUIDE.md`), with the rollback rehearsed before
the change. Sam runs every root step on a real device; Claude never runs `sudo`, never opens a
session to a real device and never holds a credential for one. Real addresses, peers, keys and
topology never enter this repository: real values live only in the private infrastructure
repository (created at the first graduation), which lessons name but never link, cite a path in or
quote from, and private keys stay on the device that made them. Examples use the documentation
ranges (RFC 5737, RFC 3849) and reserved names (RFC 2606, RFC 6761). Every Build lands in
`code/src/os/` (planned — added at P6) for lab scripts, and in the private infrastructure repository
for real values. It is marked **Later**: the first edition does not wait for it.

| # | Lesson | Size | Build | Lenses |
| --- | --- | --- | --- | --- |
| 01 | The graduation path: scope, threat model and what stays private | 1 sitting | no | Security, Safety |
| 02 | An addressing plan beside the ISP router | 1 sitting | yes — double-NAT lab and DHCP hand-over | Security, Safety |
| 03 | The homelab on the router's DNS and DHCP | 2–3 sittings | yes — reservations and local zone | Security, Safety |
| 04 | WireGuard between the router, the homelab and roaming devices | 2–3 sittings | yes — management-only tunnel | Security, Safety |
| 05 | WireGuard keys over time: rotation and revoking a lost device | 1 sitting | yes — revocation drill | Security, Safety |
| 06 | Services on the private CA's certificates | 1 sitting | yes — trust and expiry check | Security, Safety |
| 07 | Monitoring Sam's own machines | 2–3 sittings | yes — Prometheus over the tunnel | Efficiency, Security, Safety |
| 08 | Resilience by configuration | 2–3 sittings | yes — limits and WAN-loss test | Efficiency, Security, Safety |
| 09 | Backup and recovery drills | 2–3 sittings | yes — router restore drill | Efficiency, Security, Safety |
| 10 | Consent-first remote help with existing tools | 2–3 sittings | yes — consent-first session in the lab | Security, Safety |

---

## 01 — The graduation path: scope, threat model and what stays private

- **Objective:** Sam can name the devices in scope by role label, state the conditions a config must
  meet before it graduates, and sort artefacts into public, private or neither.
- **Builds on:** `sec-01-principles-threat-modelling-and-law` lessons 03 and 05 (threat modelling with
  STRIDE; authorisation and the Computer Misuse Act); `os-14-router-edition` lessons 01–05 and 07; the
  graduation-path ADR.
- **Key ideas:**
  - The path's rules: every test runs in the isolated lab; a config graduates only after its lab
    tests pass, and differs from the lab-proven version only by listed substitutions (keys, addresses,
    names); targets are devices Sam owns, named by role label in the milestone; the rollback is
    rehearsed first; Sam runs every command on a real device; no offensive tooling on the LAN; only
    configuration graduates, never a kernel, module or image.
  - Lab parity: until Syntek OS images run on chosen hardware, each real device keeps the system it
    runs today, and its lab guest mirrors that device's software versions, recorded per device in the
    private inventory.
  - Two audiences: this public repository carries the method, the lab scripts and documentation-range
    examples; the private infrastructure repository carries the real configuration; private keys are
    generated on their device and committed to no repository at all, the private one included.
  - The household threat model: the network carries other people's connectivity and data, so an
    outage or a leak reaches people who did not choose the lesson — a STRIDE pass over the home
    network's data flows, as `sec-01` lesson 03 teaches.
  - **The public journal records inventory labels and dates only** — never an address, a peer, a key,
    a device name or the NAT case.
  - Sections 1 and 17 of the Computer Misuse Act, read from the legislation, set out when access is
    unauthorised; the graduation ADR records why lab-first is a safety rule here, not a legal one.
- **Recall targets:** the graduation conditions in order; which of a set of sample artefacts is
  public, private or in no repository; why the journal holds labels and dates only.
- **Build:** none. A checklist and a device inventory by role label, both private (in the private
  infrastructure repository); the note records only their shape — columns and headings — never their
  contents.
- **Security lens:** topology leaking through a public repository; key custody; the blast radius of
  a mistake on a shared network.
- **Safety:** lab first; real change under the graduation path, run by Sam.
- **Sources:** the graduation-path ADR,
  `project-management/src/08-DECISIONS/ADR-MS001-NETWORK-LAB-FIRST-GRADUATION-PATH-27-09-2026.md`;
  `.claude/CLAUDE.md` Section 5; RFC 5737, <https://www.rfc-editor.org/rfc/rfc5737>; RFC 3849,
  <https://www.rfc-editor.org/rfc/rfc3849>; Computer Misuse Act 1990 sections 1 and 17,
  <https://www.legislation.gov.uk/ukpga/1990/18/section/1> and
  <https://www.legislation.gov.uk/ukpga/1990/18/section/17>.
- **Done when:** Sam sorts the sample artefacts into public, private or neither correctly, unaided.

## 02 — An addressing plan beside the ISP router

- **Objective:** Sam can write an IPv4 and IPv6 addressing plan for the LAN, management, guest and
  tunnel networks, identify which NAT case his connection is in, and hand DHCP over from the ISP
  router to his own.
- **Builds on:** `os-09-networking-fundamentals` lessons 03 and 05 (DHCP from the client's side; the
  isolated lab); `os-14-router-edition` lessons 01–04 (forwarding and NAT, VLANs, DHCP and DNS
  service, IPv6 for routers); lesson 01.
- **Key ideas:**
  - Blocks that do not overlap: the LAN, management, guest and tunnel networks each take a private
    IPv4 block (RFC 1918) that clashes neither with the others nor with the ISP router's own LAN.
  - A Unique Local Address prefix (RFC 4193), generated at random, keeps internal IPv6 addresses
    stable when the ISP's delegated prefix changes.
  - Three NAT cases: a public address on the router's upstream side; double NAT behind the ISP
    router; carrier-grade NAT, recognisable by an upstream address from the shared address space of
    RFC 6598. Each changes what can reach in, and whether a WireGuard endpoint at home is reachable
    at all.
  - NAT mappings for UDP expire when idle (RFC 4787), which is why lesson 04 needs keepalives.
  - One DHCP server per broadcast domain: two servers answering the same LAN hand out conflicting
    leases, so the ISP router's server is switched off, or Sam's router sits on a segment of its own,
    before Sam's router serves.
- **Recall targets:** why no block may overlap the ISP router's LAN; how to tell the three NAT cases
  apart; what goes wrong with two DHCP servers on one segment.
- **Build:** in `os-09`'s lab, a namespace standing in for the ISP router (its own NAT and DHCP), Sam's
  router guest behind it and a management segment, with a test script in `code/src/os/` (planned —
  added at P6) asserting that a LAN guest reaches outbound, that its traffic is forwarded through both
  layers of NAT, and that exactly one DHCP server answers on the LAN after the hand-over.
- **Security lens:** overlapping ranges send traffic to the wrong place; a leftover or rogue DHCP
  server can redirect every client.
- **Safety:** lab first; real change under the graduation path, run by Sam.
- **Sources:** RFC 1918, <https://www.rfc-editor.org/rfc/rfc1918>; RFC 4193,
  <https://www.rfc-editor.org/rfc/rfc4193>; RFC 6598, <https://www.rfc-editor.org/rfc/rfc6598>;
  RFC 4787, <https://www.rfc-editor.org/rfc/rfc4787>; RFC 2131, <https://www.rfc-editor.org/rfc/rfc2131>;
  `man 8 dnsmasq` (dnsmasq 2.91 on the host).
- **Done when:** the assertions pass. **The real NAT case is recorded only in the private
  infrastructure repository**; the public note says only that it was checked.

## 03 — The homelab on the router's DNS and DHCP

- **Objective:** Sam can make the homelab take its address and resolver from the router, through the
  single design that `os-14` lesson 03's ADR draft chose, and prove the homelab serves neither DNS nor
  DHCP.
- **Builds on:** `os-14-router-edition` lesson 03 (DHCP and DNS service, and the design choice);
  `os-09-networking-fundamentals` lessons 03 and 07 (the client's side; the lab-only dnsmasq);
  lesson 02.
- **Key ideas:**
  - A reservation ties a client identifier (a MAC address or DHCP client ID) to a fixed address, so the
    homelab's address is stable without being set statically on the host.
  - Local names go under `home.arpa.` (RFC 8375), the special-use domain for home networks — not
    `.local`, which RFC 6762 Section 3 gives to Multicast DNS.
  - The router can publish lease names in DNS (dnsmasq's `--dhcp-host`, `--domain` and
    `--expand-hosts`; Kea's host reservations), so a device is found by name.
  - DNS rebinding: a public name answering with a private address lets a web page reach LAN devices;
    the resolver refuses such answers (dnsmasq's `--stop-dns-rebind`), with `--rebind-domain-ok` for
    the local zone only.
  - The homelab consumes and serves neither: nothing on it answers on UDP 53, TCP 53 or UDP 67, which
    is the homelab profile's hypothesis H5 (`project-management/src/07-OS-PROFILES/PROFILE-HOMELAB.md`).
  - What the router logs about other people's lookups, and for how long, is set only once the law
    note below exists.
- **Recall targets:** why `home.arpa.` and not `.local`; what a rebinding attack needs and what
  refuses it; how to prove the homelab serves neither protocol.
- **Build:** lab assertions in `code/src/os/` (planned — added at P6): the homelab guest holds its
  reserved lease, a lab name under `home.arpa.` resolves from a LAN guest, an upstream answer that
  maps a public name to a private address is refused, and nothing on the homelab answers on UDP 53,
  TCP 53 or UDP 67.
- **Security lens:** rebinding; rogue DHCP; a second resolver the household does not know about.
- **Safety:** lab first; real change under the graduation path, run by Sam.
- **Sources:** RFC 8375, <https://www.rfc-editor.org/rfc/rfc8375>; RFC 6762 (Section 3),
  <https://www.rfc-editor.org/rfc/rfc6762>; `man 8 dnsmasq` (dnsmasq 2.91 on the host: `--dhcp-host`,
  `--domain`, `--expand-hosts`, `--stop-dns-rebind`, `--rebind-domain-ok`); Kea 3.0.2 reference manual,
  "Host Reservations in DHCPv4" (Section 9.3),
  <https://kea.readthedocs.io/en/kea-3.0.2/arm/dhcp4-srv.html#host-reservations-in-dhcpv4>; the
  HOME-NETWORK-OPERATION-LAW research note (planned — `research/HOME-NETWORK-OPERATION-LAW.md`).
  **Teaching waits on that note** for the query-log retention line.
- **Done when:** the assertions pass and Sam explains why each refusal happens.

## 04 — WireGuard between the router, the homelab and roaming devices

- **Objective:** Sam can connect site peers (the router and the homelab) and roaming peers (a laptop,
  a phone) so that they reach only the management network, over IPv4 and IPv6, and resolve local
  names through the tunnel.
- **Builds on:** `os-14-router-edition` lessons 05 and 07 (WireGuard; administration only from the
  management network); `os-11-server-edition` lesson 03 (SSH hardening); lessons 02–03.
- **Key ideas:**
  - `AllowedIPs` decides which inner addresses a peer may use and where replies go; the router's
    forward chain decides what the tunnel may reach. Both are needed: the firewall is the admission
    control.
  - A roaming peer behind NAT keeps its mapping open with `PersistentKeepalive`, or inbound traffic
    is lost once the UDP mapping expires (lesson 02); the site end needs a reachable `Endpoint`, which
    the NAT case decides.
  - An optional `PresharedKey` per peer mixes a symmetric secret into the handshake on top of the
    Curve25519 exchange.
  - Dual stack: tunnel addresses come from both the IPv4 plan and the ULA prefix.
  - `wg-quick`'s `DNS =` points a roaming peer at the router's resolver, so `home.arpa.` names resolve
    through the tunnel.
  - WireGuard interfaces can be created and keyed inside `os-09`'s unprivileged namespace lab
    (checked 27/09/2026), and an interface keeps its UDP socket in the namespace it was created in.
- **Recall targets:** which of `AllowedIPs` and the forward chain refuses what; why keepalive matters
  behind NAT; where each private key is made.
- **Build:** lab peers with assertions in `code/src/os/` (planned — added at P6): a roaming peer
  reaches the management network, is refused everything else, and loses inbound traffic when
  keepalive is off and its NAT mapping has expired. Each real key is generated on its own device and
  never leaves it.
- **Security lens:** a tunnel is a new door into the LAN; key custody; the least reach per peer.
- **Safety:** lab first; real change under the graduation path, run by Sam.
- **Sources:** `man 8 wg` and `man 8 wg-quick` (wireguard-tools 1.0.20210914 on the host); WireGuard
  whitepaper, <https://www.wireguard.com/papers/wireguard.pdf>; WireGuard, "Routing & Network
  Namespaces", <https://www.wireguard.com/netns/>.
- **Done when:** the three assertions pass and Sam explains each refusal.

## 05 — WireGuard keys over time: rotation and revoking a lost device

- **Objective:** Sam can revoke a lost device's access within minutes, and rotate a peer's key while
  measuring the gap in connectivity.
- **Builds on:** lesson 04; `sec-05-applied-cryptography` lesson 06 (key management).
- **Key ideas:**
  - WireGuard has no certificates and no revocation list: a peer is revoked by removing its public key
    from every peer that trusts it (`wg set … peer … remove`), and from the saved configuration.
  - Static keys identify a peer; session keys are derived at each handshake and replaced
    automatically, so rotation here means replacing a static key.
  - Rotation is an ordered procedure: a new key made on the device, its public key installed on the
    router, the device switched over and verified at that step, then the old key removed. Whether it
    can avoid a gap is measured, not assumed (checked at `/teach` step 3).
  - The lost-device order: revoke first, then read the latest handshakes to see whether the key was
    used after the device went missing, then replace any preshared key it held.
- **Recall targets:** how a WireGuard peer is revoked and why there is no revocation list; static
  against session keys; the lost-device order and why revocation comes first.
- **Build:** a drill script in `code/src/os/` (planned — added at P6) that revokes a lab peer and
  asserts its next handshake fails, then rotates another peer's key and records the connectivity gap.
- **Security lens:** a lost phone holding a tunnel key is a key on the loose; the recorded time to
  revoke is the exposure window.
- **Safety:** lab first; real change under the graduation path, run by Sam.
- **Sources:** `man 8 wg` (wireguard-tools 1.0.20210914 on the host: `set … peer … remove`,
  `show … latest-handshakes`); WireGuard whitepaper, <https://www.wireguard.com/papers/wireguard.pdf>;
  NIST SP 800-57 Part 1 Rev. 5 (cryptoperiods, compromise recovery),
  <https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final>.
- **Done when:** the drill passes, the revocation time and the rotation gap are recorded, and Sam
  states the lost-device order unaided.

## 06 — Services on the private CA's certificates

- **Objective:** Sam can install the private root on his own devices, have services present
  short-lived leaves, and catch a certificate before it expires.
- **Builds on:** `sec-05-applied-cryptography` lessons 08–12 (the offline root, the constrained
  intermediate, short-lived leaves, revocation, trust stores); lessons 03–04.
- **Key ideas:**
  - This lesson consumes `sec-05`'s CA; it designs nothing new. Sam's real root and intermediate are
    made under the graduation path, and their keys enter no repository.
  - Name constraints on the intermediate are what make a home root safe to install: it can sign only
    the home zone's names and addresses, where the client enforces them (`sec-05` lesson 09).
  - Trust stores differ by client — the system store, an NSS database, an application's own file —
    and writing the system store needs root, so Sam runs that step on each device.
  - Leaves are renewed by ACME once the issuer is chosen; until then, hand-issued leaves are enough to
    run the services.
  - The web admin dashboard's certificate (`ui-10-web-admin-dashboard` lesson 05) comes from here.
- **Recall targets:** why a constrained intermediate makes a home root acceptable; which trust store
  each of Sam's clients reads; what the expiry check compares.
- **Build:** in the lab, a trusted and an untrusted client against a service presenting a leaf from
  the lab intermediate, plus an expiry check in `code/src/os/` (planned — added at P6) that fails when
  a leaf is inside its renewal window. Hand-issued leaves from `sec-05` lesson 10 suffice. **Only the
  ACME-renewal half is Blocked** (`GAPS.md` → "No ACME issuer chosen for the private CA").
- **Security lens:** the root key is the master key to every name it covers; short lifetimes limit
  what a stolen leaf is worth.
- **Safety:** lab first; real change under the graduation path, run by Sam.
- **Sources:** RFC 5280, <https://www.rfc-editor.org/rfc/rfc5280>; RFC 8555,
  <https://www.rfc-editor.org/rfc/rfc8555>; `man 8 update-ca-certificates`; `man 1ssl openssl-s_client`
  (OpenSSL 3.0.13 on the host: `-CAfile`, `-servername`, `-verify_return_error`).
- **Done when:** the trusted client connects without a warning, the untrusted one is refused, and the
  expiry check fails on an expiring leaf.

## 07 — Monitoring Sam's own machines

- **Objective:** Sam can have Prometheus scrape node_exporter and `os-12`'s exporter on his own
  machines, over the tunnel or the management network, with alert rules and a stated retention, and
  metrics only.
- **Builds on:** `os-12-homelab-edition` lessons 04–05 (pressure, the exposition format, the exporter);
  `os-11-server-edition` lesson 04 (a host firewall); lesson 04.
- **Key ideas:**
  - Prometheus pulls: it scrapes each target's HTTP endpoint on a schedule, so every exporter listens
    on a management or tunnel address only, and the firewall admits only the Prometheus server.
  - Router series are aggregate only (connection-tracking table fill, interface counters, drops);
    per-peer handshake age is collected only for Sam's own devices, and no series describes anyone
    else's device.
  - Metrics only: no packet capture, flow log or query log of the real LAN;
    `sec-16-detection-response-and-disclosure`'s intrusion detection stays in the lab.
  - Retention is stated, not defaulted: `--storage.tsdb.retention.time` and
    `--storage.tsdb.retention.size`, whichever is reached first.
  - Alert rules load through `rule_files`; a `for:` duration keeps a brief spike from firing.
  - The monitor has a budget of its own, measured like any other service's.
- **Recall targets:** why pull monitoring puts a listener on every host; which series are allowed and
  why; how retention is bounded.
- **Build:** the lab Prometheus configuration and rules, checked by `promtool check config` and
  `promtool check rules`, with assertions in `code/src/os/` (planned — added at P6) that every target
  is up, a scrape from a LAN guest is refused, and one rule fires under a synthetic load. **Blocked**
  (`GAPS.md` → "Monitoring and remote-help tools not installed").
- **Efficiency lens:** Prometheus's resident memory and disk growth per day; each exporter's CPU and
  memory cost.
- **Security lens:** an exporter describes its host to anyone who can reach it; metrics about other
  people's devices are personal data.
- **Safety:** lab first; real change under the graduation path, run by Sam.
- **Sources:** Prometheus, "Configuration",
  <https://prometheus.io/docs/prometheus/latest/configuration/configuration/>; "Storage",
  <https://prometheus.io/docs/prometheus/latest/storage/>; "Alerting rules",
  <https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/>; "promtool",
  <https://prometheus.io/docs/prometheus/latest/command-line/promtool/> (each re-read for the version
  the install route chooses); node_exporter v1.12.1, <https://github.com/prometheus/node_exporter/tree/v1.12.1>;
  the HOME-NETWORK-OPERATION-LAW research note (planned — `research/HOME-NETWORK-OPERATION-LAW.md`).
  **Teaching waits on that note.**
- **Done when:** both `promtool` checks pass, every target is up, the LAN scrape is refused and the
  rule fires.

## 08 — Resilience by configuration

- **Objective:** Sam can set SYN cookies, a connection-tracking limit and per-source nftables limits
  on the router, and show that the LAN keeps working through a WAN outage.
- **Builds on:** `os-14-router-edition` lessons 01 and 07 (forwarding, hardening);
  `os-09-networking-fundamentals` lesson 06 (nftables); lesson 07 (the measured normal).
- **Key ideas:**
  - `tcp_syncookies` lets a host answer a SYN flood without storing state for each half-open
    connection; it is set per network namespace.
  - `nf_conntrack_max` caps the connection-tracking table; it is read-only in a non-initial namespace
    (checked 27/09/2026), so it is set in the router guest's own kernel, not in the namespace lab.
  - Dynamic sets give per-source limits: a rate per source address (`limit rate`) and a cap on its
    concurrent connections (`ct count over`).
  - Limits come from lesson 07's measured normal, with headroom — not from a guess.
  - Nothing fails open: when a limit or the table is full, new connections are dropped rather than let
    through unfiltered, and the LAN's own services keep working with the upstream side down.
- **Recall targets:** what a SYN cookie saves the host from storing; where `nf_conntrack_max` can and
  cannot be set; a per-source rate against a per-source count.
- **Build:** sysctl assertions and WAN-loss assertions in `code/src/os/` (planned — added at P6). The
  limit check sets a deliberately low test threshold and opens a handful of ordinary connections to
  see the limit engage. **No flood, load or stress tool** runs against any device, and nothing ever
  runs against the WAN or the ISP; the load test is parked (`DEFERRED.md`, S3).
- **Efficiency lens:** connection-tracking table fill against its limit, and the memory it costs; the
  router's CPU with the limits loaded.
- **Security lens:** resource exhaustion; a limit that fails open is no limit.
- **Safety:** lab first; real change under the graduation path, run by Sam.
- **Sources:** docs.kernel.org, "IP Sysctl" (`tcp_syncookies`),
  <https://docs.kernel.org/networking/ip-sysctl.html>; docs.kernel.org, "Netfilter Conntrack Sysfs
  variables" (`nf_conntrack_max`), <https://docs.kernel.org/networking/nf_conntrack-sysctl.html>;
  nftables wiki, "Meters" (revision 1088), <https://wiki.nftables.org/wiki-nftables/index.php/Meters>;
  nftables wiki, "Rate limiting matchings" (revision 315),
  <https://wiki.nftables.org/wiki-nftables/index.php/Rate_limiting_matchings>; `man 8 nft` (nftables
  1.0.9 on the host).
- **Done when:** the sysctl, limit and WAN-loss assertions pass, and Sam explains where each value
  came from.

## 09 — Backup and recovery drills

- **Objective:** Sam can back up the router's configuration, the WireGuard keys and the CA material,
  rebuild the router within a measured time, and recover from a lost WireGuard key and a lost
  intermediate.
- **Builds on:** `os-11-server-edition` lesson 06 (backups and a restore drill);
  `sec-05-applied-cryptography` lessons 08–11 (the CA and revocation); lessons 04–06.
- **Key ideas:**
  - What to back up: the router's configuration (already versioned in the private infrastructure
    repository), the private keys that cannot be remade without re-enrolling peers, and the CA's root
    and intermediate material.
  - A key backup is a key: it is encrypted with `os-11` lesson 06's backup tool, kept apart from the
    device, and in no git repository.
  - Three drills: rebuild the router from its configuration and backup; recover from a lost WireGuard
    key (re-key and re-enrol); recover from a lost intermediate (a new one from the offline root,
    leaves re-issued, the old one revoked).
  - Unattended boot to a known-good state: after a power cut the router comes back on its last good
    configuration with nobody at the console.
- **Recall targets:** what must be backed up and what is rebuilt from configuration; why a key backup
  needs the same care as the key; the steps of the lost-intermediate drill.
- **Build:** a restore-drill script in `code/src/os/` (planned — added at P6) that rebuilds a lab
  router guest from its configuration and an encrypted backup, checks that the tunnel and the
  services come back, and records the time taken.
- **Efficiency lens:** restore time against the router's budget; backup size.
- **Security lens:** a backup is a second copy of every secret; recovery must not weaken the chain of
  trust.
- **Safety:** lab first; real change under the graduation path, run by Sam.
- **Sources:** the documentation of the tool chosen in `os-11` lesson 06 — restic 0.19.1,
  <https://restic.readthedocs.io/en/v0.19.1/>, or BorgBackup 1.4.5,
  <https://borgbackup.readthedocs.io/en/1.4.5/>; NIST SP 800-34 Rev. 1 (contingency planning),
  <https://csrc.nist.gov/pubs/sp/800/34/r1/upd1/final>; NIST SP 800-57 Part 1 Rev. 5,
  <https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final>; `man 8 wg` (`showconf`).
- **Done when:** all three drills pass in the lab and the rebuild time is recorded against the budget.

## 10 — Consent-first remote help with existing tools

- **Objective:** Sam can help someone over SSH and a shared tmux session through the tunnel — only
  when they ask, while they watch, time-limited, and leaving nothing behind — first between lab
  guests, then in a real session with a consent record.
- **Builds on:** `os-11-server-edition` lesson 03 (SSH hardening); lessons 04–05 (the tunnel, revoking
  a peer); `sec-01-principles-threat-modelling-and-law` lesson 05 (authorisation).
- **Key ideas:**
  - Seven consent properties: the helped person asks; consent is per session, viewing before any
    control; they watch everything; the session has a time limit; they can end it at any moment; the
    helper has least privilege; nothing is left behind.
  - `authorized_keys` options scope the helper's key: `expiry-time=` stops it being accepted after the
    session window, `from=` limits where it may connect from, and `restrict` switches off forwarding,
    PTY allocation and `~/.ssh/rc`, so the session re-enables only `pty`, which tmux needs.
  - tmux's `server-access` lets the helped person make the helper read-only (`-r`) and revoke access,
    which detaches the helper at once (`-d`).
  - The helped side keeps the record, with `script` or tmux logging; `script` logs output only by
    default, and logging input would also capture any password typed during the session.
  - A session-only WireGuard peer, added for the session and removed after it (lesson 05).
  - **Whose consent is needed, and what the record holds, come from the research note below, not from
    this syllabus.** Filled consent records and session logs stay on the helped device, and on Sam's
    machine only if the helped person agrees; they enter no git repository, and only a blank template
    may live in the private infrastructure repository.
  - The Rust tool that builds these properties in is `ui-11-consent-first-remote-help`.
- **Recall targets:** the seven properties and the mechanism that enforces each; what each
  `authorized_keys` option does; why the log records output only.
- **Build:** helper and helped lab guests, with assertions in `code/src/os/` (planned — added at P6)
  that the helper's key is refused after its expiry time, `server-access -d` detaches the helper, and
  nothing remains afterwards (no key, peer, account or process). **Blocked** (tmux is not installed;
  `GAPS.md` → "Monitoring and remote-help tools not installed"). Teaching also waits on the
  REMOTE-HELP-CONSENT-AND-THE-COMPUTER-MISUSE-ACT research note (planned —
  `research/REMOTE-HELP-CONSENT-AND-THE-COMPUTER-MISUSE-ACT.md`).
- **Security lens:** a remote-access tool is an abuse vector, and the consent properties are its
  mitigations; a helper key left behind is a back door.
- **Safety:** lab first; real change under the graduation path, run by Sam.
- **Sources:** Computer Misuse Act 1990 section 17, <https://www.legislation.gov.uk/ukpga/1990/18/section/17>;
  sshd(8), "AUTHORIZED_KEYS FILE FORMAT", <https://man.openbsd.org/sshd>; tmux(1) (`server-access`),
  <https://man.openbsd.org/tmux>; `man 1 script` (util-linux 2.39.3 on the host: `--log-out`,
  `--log-in`); the REMOTE-HELP-CONSENT-AND-THE-COMPUTER-MISUSE-ACT research note (planned).
- **Done when:** the lab assertions pass, and the first real session runs with its consent record kept
  as above.
