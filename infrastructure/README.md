## Infrastructure

My homelab is built around a virtualized infrastructure where I run and manage most of my services myself.

The main components are:

* **Proxmox VE** – used for virtualization and running my VMs and containers.
* **OPNsense** – used as my firewall and main network gateway.
* **NAS** – used for centralized storage, backups and shared data.
* **Cloudflare Zero Trust** – used for secure remote access to selected services without directly exposing them to the internet.

The goal is to have a setup where I can run different services in an isolated and controlled environment and manage the infrastructure myself.


The virtualization infrastructure consists of three Proxmox VE nodes:

| Node | CPU | RAM | Local Storage |
|---|---|---:|---:|
| Node 1 | Intel Core i5-7600 | 16 GB | 750 GB SSD |
| Node 2 | Intel Core i5-9500 | 16 GB | 750 GB SSD |
| Node 3 | Intel Pentium Gold 5405U | 20 GB | 500 GB SSD |

The nodes are configured as a Proxmox cluster with High Availability (HA).

Most services are configured for HA so that they can be automatically restarted on another node if a node becomes unavailable.
