### Proxmox

I use Proxmox as the primary virtualization platform for my home lab. The setup consists of three Proxmox nodes configured as a high-availability (HA) cluster.

For shared storage, I use a Synology NAS with two SSDs configured as RAID 1. Most of my VMs and containers run on this shared SSD storage, which allows workloads to be managed across the entire Proxmox cluster.

I used to use iSCSI for shared storage, but switched to NFS because I wanted to take advantage of the Proxmox snapshot functionality. Most of my virtual hard disks use QCOW2, while some workloads continue to use RAW where it makes sense.

I keep some workloads on local storage instead of on the shared NAS. Security Onion, for example, runs locally on the Proxmox nodes’ SSDs due to its high disk I/O load. This also prevents the shared SSD storage from filling up too quickly.

In addition, I run TrueNAS as a virtual machine on one of the Proxmox nodes. The physical hard drives are passed directly to the TrueNAS VM, allowing TrueNAS to manage the drives directly.

For backups, I use a separate Synology NAS. This keeps the backup storage independent of Proxmox’s main storage.

### Storage Architecture
```text
Proxmox Node 1 ─┐
Proxmox Node 2 ─┼── NFS ──► Synology SSD RAID 1
Proxmox Node 3 ─┘

Proxmox Node 1
      │
      └── TrueNAS VM
             │
             └── HDD Passthrough

Proxmox Cluster ─────────► Backup Synology
```
### Storage Lessons Learned

During an earlier storage setup, I made the mistake of creating a RAID configuration at the Proxmox level and then trying to manage the same disks again inside OpenMediaVault. I accidentally wrote an EXT4 filesystem to a disk that was already part of the existing storage configuration.

This resulted in the complete destruction of the data on that disk.

Since then, I have paid much more attention to **which layer is responsible for managing a disk**. Physical disks are now clearly assigned to their respective storage system, avoiding overlapping RAID, filesystem and virtualization configurations.

This was an important practical lesson in understanding storage abstraction layers and the risks of modifying disks without first verifying which system owns them.


### High Availability

I have configured most of my services using Proxmox HA.

I also set a startup order for the services, since a full reboot of the infrastructure can take up to about 25 minutes. Services required for the network and infrastructure are started first, followed by the other services.

For example:

```text
Infrastructure / Network
        │
        ▼
Core Services
        │
        ▼
Monitoring
        │
        ▼
Other Services
```

### HA Failover Test

I tested the HA functionality by physically disconnecting one of the Proxmox nodes from the network and the power supply.

After about a minute, the HA services automatically restarted on another available Proxmox node.

This was particularly useful for testing a realistic failure scenario, rather than relying solely on the HA configuration.

The main advantage of this configuration is that I can perform maintenance on individual Proxmox nodes while most services remain online. For example, if I need to replace a hard drive or perform maintenance on a node, the workloads can be moved to or restored on another node without requiring a complete service outage.

<img width="990" height="598" alt="Proxmox" src="https://github.com/user-attachments/assets/9a729b31-42e1-4c55-8a42-b1a26241cca5" />


