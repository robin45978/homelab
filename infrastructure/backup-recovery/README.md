# Homelab Backup & Disaster Recovery Architecture

This documentation describes the backup and disaster recovery setup of my homelab.

The setup is built around my Proxmox cluster, Synology NAS and Hetzner S3 storage. I mainly use this architecture to keep multiple recovery points while protecting the backups themselves against accidental deletion, ransomware and a complete loss of the local environment.

---

## 1. Proxmox Backup Tiering

I do not back up every VM and LXC with the same retention. The systems are split into three tiers depending on how important they are and how difficult they would be to rebuild.

### 🔴 Tier 1 – Critical

These systems run important services or contain data I do not want to lose.

```text
Docker
CloudPanel
TrueNAS
Paperless
InvoiceNinja
Cloudflare
```

### Retention

```text
Keep Last:      3
Keep Daily:    14
Keep Weekly:    8
Keep Monthly:  12
```

These systems get the longest retention because restoring them quickly is more important than saving storage space.

---

### 🟠 Tier 2 – Important

These systems are important for my security and infrastructure, but are easier to rebuild than the Tier 1 systems.

```text
Wazuh
Rocrail
```

### Retention

```text
Keep Last:      2
Keep Daily:     2
Keep Weekly:    2
Keep Monthly:   4
```

This gives me several recovery points without keeping large amounts of older backups.

---

### 🟢 Tier 3 – Rebuildable

These systems are mainly used for testing, pentesting, security analysis or desktop workloads.

```text
Security Onion
Kali Linux
BlackArch
Windows 11
Ubuntu Desktop
```

I do not keep many full backups of these systems because they can be rebuilt relatively easily.

Security Onion is also intentionally kept to a minimum because the VM can generate a large amount of data.

### Retention

```text
Keep Last:      1
Keep Daily:     0
Keep Weekly:    1
Keep Monthly:   1
```

The idea is simply to have a recent recovery point without wasting backup storage on historical copies of systems that I can rebuild.

<img width="2678" height="1062" alt="Backup-Recovery" src="https://github.com/user-attachments/assets/a8733edc-f92a-4ffd-bca2-f286398538e9" />

---

# 2. 3-2-1 Backup Architecture

My backup setup follows the **3-2-1 principle**, with an additional focus on protecting the backup copies themselves.

```text
Production
    │
    ▼
Proxmox
    │
    ├── VMs
    └── LXCs
    │
    ▼
Synology NAS
    │
    ▼
Hetzner S3
```

### Primary Data

My production workloads run on the local Proxmox infrastructure.

```text
Proxmox
├── Virtual Machines
└── LXC Containers
```

TrueNAS provides additional storage for services such as Nextcloud and Jellyfin.

---

### Local Backup

Proxmox creates scheduled VM and LXC backups and stores them on my Synology NAS.

```text
Proxmox
    │
    │ Proxmox Backup
    ▼
Synology NAS
```

The retention depends on the backup tier described above.

The Synology copy is my main recovery source because it is local and therefore much faster to restore from than the offsite copy.

---

### Offsite Backup

The Synology NAS then replicates the backups to **Hetzner S3** using Hyper Backup.

```text
Synology NAS
    │
    │ Hyper Backup
    ▼
Hetzner S3
```

I chose Hetzner mainly for the offsite separation and because the S3 storage supports the features I need for protecting the backup data.

The local backup is primarily for fast recovery. The Hetzner copy is there for cases where the local infrastructure or NAS is no longer available.

---

## S3 Versioning & Object Lock

The Hetzner S3 bucket uses **Versioning** and **Object Lock**.

Versioning keeps previous versions of objects, while Object Lock provides **WORM (Write Once, Read Many)** protection for a defined retention period.

This is an important part of my setup because the offsite copy should not simply disappear if the local environment is compromised.

```text
Local Backup
     │
     ▼
Hetzner S3
     │
     ├── Versioning
     └── Object Lock / WORM
```

The goal is to keep recovery points that cannot simply be deleted or modified during their retention period, even if the production environment is compromised.

---

# 3. Recovery Objectives

I use different recovery targets depending on how important the system is.

| Tier        |         RPO |   Local RTO | Offsite RTO |
| ----------- | ----------: | ----------: | ----------: |
| Critical    |       ≤ 24h |    ≤ 45 min |  Not tested |
| Important   |       ≤ 48h |        ≤ 2h |  Not tested |
| Rebuildable | Best effort | Best effort |  Not tested |

A typical local VM or LXC restore currently takes around **25 minutes** from starting the restore until the system is available again.

For Tier 1 systems I therefore use a **45-minute local RTO target**. This leaves some additional time for checking the service and fixing issues after the restore.

The offsite RTO is currently not tested. A restore from Hetzner will take longer because the data has to be transferred over the network. This will be validated separately through a dedicated disaster recovery test.

Backup failures are monitored through Proxmox notifications and reported to Discord.

---

# 4. Hardware Redundancy & Cold Standby

Backups are not the only protection in my setup. Some components also have hardware-level protection.

## Shared NAS

The shared NAS uses **RAID 1 with two SSDs**.

```text
          Shared NAS
              │
       ┌──────┴──────┐
       │             │
     SSD 1         SSD 2
       │             │
       └──── Mirror ─┘
```

If one SSD fails, the NAS can continue running while the failed drive is replaced and the RAID is rebuilt.

RAID 1 is only used for **availability and protection against a disk failure**. It is not considered a backup.

The data is still copied to the backup infrastructure.

---

## OPNsense

OPNsense runs on dedicated hardware and is therefore independent from my Proxmox environment.

The configuration is regularly backed up as `config.xml` to Nextcloud.

```text
OPNsense
    │
    ▼
config.xml
    │
    ▼
Nextcloud
```

I also keep a separate system available as a **cold standby**.

```text
             Production
                 │
              OPNsense
                 │
          Hardware failure
                 │
                 ▼
          Cold Standby
                 │
                 ▼
        Restore config.xml
                 │
                 ▼
         Network restored
```

This is not HA because the second system is not running at the same time.

It is simply my manual recovery path if the primary OPNsense hardware fails.

---

## Availability vs. Backup

I keep availability, redundancy and backup separate in the design.

```text
RAID 1
→ protects against disk failure

Cold Standby
→ protects against hardware failure

Local Backups
→ protect against data loss and configuration errors

Offsite Backups
→ protect against loss of the local environment

Snapshots / Isolation
→ add protection against ransomware and accidental deletion
```

RAID and the OPNsense cold standby therefore complement the backup strategy, but neither replaces it.

---

# 5. Disaster Recovery

The recovery process is based on my actual setup rather than assuming that every system needs to be rebuilt from scratch.

For a failed VM or LXC, the first recovery option is the latest valid backup on the Synology NAS.

```text
System Failure
      │
      ▼
Check latest valid backup
      │
      ▼
Restore VM / LXC to Proxmox
      │
      ▼
Verify system and configuration
      │
      ▼
Start services
      │
      ▼
Check application functionality
      │
      ▼
Return system to production
```

For a local failure, the Synology backup is preferred because it provides the fastest restore path.

If the local backup infrastructure itself is unavailable, the recovery path moves to the **Hetzner S3 copy**.

```text
Local failure
      │
      ▼
Synology backup available?
      │
   ┌──┴──┐
  YES    NO
   │      │
   ▼      ▼
Restore  Hetzner S3
from NAS      │
              ▼
          Restore data
              │
              ▼
         Rebuild system
```

For critical systems, I do not consider a backup trustworthy just because the backup job completed successfully. The actual test is whether the VM or LXC can be restored and the service works afterwards.

This gives me a clear recovery path from a normal VM failure up to a complete loss of the local backup environment.
