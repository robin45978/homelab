

# Homelab Backup & Disaster Recovery Architecture

This documentation describes the backup and disaster recovery strategy used in my homelab.

The main goals are:

- Protect critical services and data
- Reduce backup storage and I/O usage
- Maintain multiple recovery points
- Protect backups against accidental deletion and ransomware
- Keep rebuildable systems lightweight
- Provide a clear recovery path after a system failure

The backup architecture is based on the 3-2-1 backup principle with additional network segmentation and snapshot-based protection.

---

## 1. Proxmox Backup Tiering

Not every VM or LXC requires the same backup frequency.

I therefore classify my systems into three backup tiers based on their importance, stored data and how easily they can be rebuilt.

### 🔴 Tier 1 – Critical

These systems contain important production services or data and receive the highest backup priority.

```text
Docker
Wazuh
CloudPanel
TrueNAS
Paperless
InvoiceNinja
Cloudflare
Rocrail
````

### Retention

```text
Keep Last:      3
Keep Daily:    14
Keep Weekly:    8
Keep Monthly:  12
```

These systems are backed up frequently because data loss or a long outage would have a significant impact.

---

### 🟠 Tier 2 – Important

Tier 2 is used for systems that are important but do not require the same long-term retention as Tier 1.

For example, systems with important configuration but lower data criticality can be placed here.

### Retention

```text
Keep Last:      2
Keep Daily:     2
Keep Weekly:    2
Keep Monthly:   4
```

This provides several recovery points while keeping storage usage under control.

---

### 🟢 Tier 3 – Rebuildable

These systems are primarily used for testing, pentesting, security analysis or desktop workloads.

```text
Security Onion
Kali Linux
BlackArch
Windows 11
Ubuntu Desktop
```

These systems can generally be rebuilt from installation media and configuration backups.

Because Security Onion can generate large amounts of data, full VM backups are kept to a minimum.

### Retention

```text
Keep Last:      1
Keep Daily:     0
Keep Weekly:    1
Keep Monthly:   1
```

The goal is to keep a recent recovery point without using large amounts of storage for historical full VM backups.



<img width="2678" height="1062" alt="Backup-Recovery" src="https://github.com/user-attachments/assets/a8733edc-f92a-4ffd-bca2-f286398538e9" />


---

# 2. 3-2-1 Backup Architecture

The homelab follows the **3-2-1 backup principle**:

```text
3 copies of important data
2 different storage locations/media
1 copy isolated from the primary environment
```

The architecture consists of:

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
Local Backup NAS
    │
    ▼
Offsite Backup NAS
```

### Primary Data

Production workloads run on the local Proxmox infrastructure.

```text
Proxmox
├── Virtual Machines
└── LXC Containers
```

TrueNAS and the shared SSD storage provide additional production storage for services such as Nextcloud and Jellyfin.

---

### Local Backup

Proxmox performs scheduled backups of VMs and LXC containers to the local Synology NAS.

```text
Proxmox
    │
    │ Proxmox Backup
    ▼
Synology NAS
```

The retention policy depends on the assigned backup tier.

---

### Offsite Backup

Important backups are replicated to a second Synology NAS located at a separate physical location.

```text
Local Synology NAS
        │
        │ Backup Replication
        ▼
Remote Synology NAS
```

This protects against local hardware failure, theft, fire and other site-level incidents.

---

# 3. Network Security & Ransomware Protection

A remote backup system should not simply be exposed as another network share.

The connection between the two locations is therefore isolated using a **site-to-site VPN**.

```text
Site A
Proxmox
   │
Synology NAS
   │
   │
   │ Site-to-Site VPN
   │
   ▼
Site B
Synology NAS
```

OPNsense controls the communication between the two networks.

Firewall rules restrict the VPN connection to only the services required for backup replication.

Unnecessary protocols such as:

```text
SMB
NFS
```

are not exposed across the VPN.

Only the required backup services and ports are permitted.

---

# 4. Snapshot & Ransomware Protection

The remote backup system uses **Btrfs snapshots** to maintain historical recovery points.

Snapshots provide an additional protection layer against:

* Accidental deletion
* File corruption
* Malware
* Ransomware
* Configuration mistakes

The objective is to prevent a compromise of the primary environment from immediately destroying every available backup.

The remote backup therefore acts as an additional recovery layer rather than simply being another network share.

---

# 5. Disaster Recovery

The backup strategy is designed around the assumption that individual systems can fail completely.

The general recovery process is:

```text
System Failure
      │
      ▼
Identify latest valid backup
      │
      ▼
Restore VM / LXC
      │
      ▼
Verify system integrity
      │
      ▼
Start services
      │
      ▼
Verify application functionality
      │
      ▼
Return system to production
```

For critical systems, recovery should be tested periodically instead of assuming that a backup is valid.

A backup is only considered reliable if it can successfully be restored.

---

# 6. Recovery Priorities

Recovery follows the same priority model as the backup strategy.

```text
1. Network / Infrastructure
   └── OPNsense / Proxmox

2. Critical Security & Infrastructure
   ├── Wazuh
   ├── Docker
   └── CloudPanel

3. Critical Applications
   ├── Paperless
   ├── InvoiceNinja
   ├── Vaultwarden
   └── other production services

4. Storage / Data Services
   ├── TrueNAS
   └── required datasets

5. Monitoring / Analysis
   └── Security Onion

6. Lab / Desktop Systems
   ├── Kali
   ├── BlackArch
   ├── Windows 11
   └── Ubuntu Desktop
```

This ensures that the most important infrastructure is restored first.


## Recovery Objectives

Recovery objectives are defined separately for local and offsite recovery.

| Tier | RPO | Local RTO | Offsite RTO |
|---|---:|---:|---:|
| Critical | ≤ 24h | ≤ 45 min |  Not tested |
| Important | ≤ 48h | ≤ 2h |  Not tested |
| Rebuildable | Best effort | Best effort |  Not tested |

A typical local VM/LXC restore currently takes approximately 25 minutes from starting the restore until the system is available again.

A 45-minute RTO target is therefore used for critical local restores, providing additional time for service verification and troubleshooting.

Offsite recovery is expected to take significantly longer due to network transfer and remote storage access. The offsite RTO is therefore defined separately and will be validated through dedicated disaster recovery tests.

Backup failures are monitored through Proxmox notifications and reported to Discord.



---

# 7. Backup Philosophy

The strategy is intentionally **not based on backing up everything equally**.

Critical data receives long retention and frequent backups, while rebuildable systems receive minimal retention.

This reduces:

* Backup storage consumption
* Backup duration
* Network traffic
* I/O load

while maintaining strong protection for the systems that actually require it.

The overall objective is:

```text
Critical systems
    → frequent + long retention

Important systems
    → moderate retention

Rebuildable systems
    → minimal backup + rebuild capability
```

This provides a balance between **availability, storage efficiency, security and recoverability**.


# 8. Hardware Redundancy & Cold Standby

In addition to the backup strategy, critical infrastructure has additional hardware-level protection.

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
````

If one SSD fails, the NAS can continue operating while the failed drive is replaced and the RAID is rebuilt.

RAID 1 is used for **availability and hardware fault tolerance**, not as a backup.

The data is still replicated to the backup infrastructure.

---

## OPNsense

OPNsense runs on dedicated hardware and is therefore not dependent on the Proxmox environment.

The OPNsense configuration is regularly backed up as `config.xml` to Nextcloud.

```text
OPNsense
    │
    ▼
config.xml
    │
    ▼
Nextcloud
```

A dedicated replacement system is also available as a **cold standby**.

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

This is not considered High Availability because the standby system does not operate simultaneously with the production firewall.

Instead, it provides a **manual disaster recovery path** in case the primary OPNsense hardware fails.

---

## Availability vs. Backup

The infrastructure intentionally separates **availability, redundancy and backup**.

```text
RAID 1
→ protects against disk failure

Cold Standby
→ protects against hardware failure

Local Backups
→ protect against data loss and configuration errors

Offsite Backups
→ protect against site-level disasters

Snapshots / Isolation
→ protect against ransomware and accidental deletion
```

RAID and cold standby therefore complement the 3-2-1 backup strategy but do not replace it.
