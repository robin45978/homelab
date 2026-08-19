# Homelab as a Cybersecurity Learning and Testing Environment

In this repository, I’d like to document my home lab. I’ll cover my current setup, its development over nearly 10 years, and my goals and visions for the future.

My guiding principle is to find an open-source solution for everything whenever possible. That’s why I test many different tools and technologies and then decide which solution best fits my setup.

My goal is to build a secure and highly efficient cloud architecture while gaining hands-on experience with various technologies in the fields of networking, virtualization, cloud computing, and cybersecurity.



<br>

## Current Tech Stack

|  Field               | Services                                             |
| -------------------- | ---------------------------------------------------- |
| **Virtualization**   | Proxmox VE (VM & LXC)                                |
| **Network**          | OPNsense, OpenWRT, Fritz!Box, Netgear Managed Switch |
| **Security / SIEM**  | Security Onion, Wazuh                                |
| **Monitoring**       | Grafana, InfluxDB, Uptime Kuma                       |
| **Containers**       | Docker, Portainer                                    |
| **Cloud / Access**   | Cloudflare, Cloudflare Tunnel, Cloudflare Zero Trust |
| **VPN**              | WireGuard                                            |
| **Smart Home**       | Home Assistant                                       |
| **Storage**          | TrueNAS, Synology NAS                                |
| **Cloud**            | Nextcloud                                            |
| **Documents**        | Paperless-ngx, Invoice Ninja                         |
| **Media**            | Jellyfin                                             |
| **DNS**              | AdGuard Home                                         |
| **Dashboard**        | Homarr                                               |
| **Telephone**        | 3CX                                                  |
| **Webhosting**       | WordPress, CloudPanel                                |
| **Password Manager** | Bitwarden                                            |
| **Automation**       | Cron Jobs                                            |
| **Remote desktop Access**    | NoMachine                                            |

<br>

# Dashboard
<img width="905" height="532" alt="Dashboard " src="https://github.com/user-attachments/assets/c64e82f9-c2a9-418f-a52d-40040254f485" />

<img width="901" height="524" alt="Dashboard 2" src="https://github.com/user-attachments/assets/d0f3a847-2c22-4ec9-b25b-9c86f8330c01" />


<br>
<br>

# My Hardware Development Journey — From the Beginning to Today

It all started with a Raspberry Pi and Ubuntu OS. That’s where I ran my first website back then. At the time, I programmed it myself using HTML and CSS ;)

However, that quickly became too limited, and after spending a long time figuring out how operating systems actually run on a PC and how to install them, I switched to Proxmox on a PC.

I configured the initial firewall rules using a Fritzbox and VHosts. This was followed by a small, old firewall, which I set up by installing pfSense via the console port so I could use it.

However, as demands grew and throughput reached 100 Mbit/s, it quickly became clear that this was no longer sufficient. So I virtualized pfSense as a VM on Proxmox and learned about internal subnetting in the process.

Over time, I added a Sophos firewall, which I later switched to OPNsense due to an expired license.

The next problem was that the PC would occasionally crash due to configuration issues, so I introduced high availability to improve system reliability. That’s why I added a second PC and finally another one to ensure quorum was met.

I also added several storage systems to store all the data.

Currently, my home lab consists of a cluster with 3 nodes, a firewall, and several NAS systems running in the background.

Since my connection between the devices is still limited to 1 Gbit/s, I'm avoiding Ceph on purpose and instead using NFS via a shared NAS to ensure high availability. Of course, this doesn't offer all the benefits, but it's currently the best solution for my setup.

The next step will be upgrading to 10 Gbit/s. :)

<img width="990" height="598" alt="Proxmox" src="https://github.com/user-attachments/assets/2680800b-98d4-438f-802c-1e9034ecd33c" />



<br>
<br>

# Technology Changes

Over the years, I've replaced some technologies with other solutions. Below, I'll briefly explain what led me to make those changes.

| Previous            | Current               | Reason                       |
| ------------------- | --------------------- | ---------------------------- |
| Raspberry Pi        | Server / Proxmox      | More performance needed      |
| pfSense             | OPNsense              | Open source / community      |
| OpenVPN             | WireGuard             | Better performance           |
| OpenMediaVault      | TrueNAS SCALE         | Storage requirements         |
| Pi-hole             | AdGuard Home          | More filtering options       |
| Plex                | Jellyfin              | Cost                         |
| Plesk               | CloudPanel            | Open source                  |
| Self-hosted 3CX     | External 3CX Cloud    | Licensing model changed      |
| HAProxy on OPNsense | Cloudflare Tunnel     | DDoS protection / Zero Trust |
| WireGuard on LXC    | WireGuard on OPNsense | Better access management     |
| XRDP, SPICE, NoVNC  | NoMachine             | Better performance           |



---

<br>

# Future / Vision

The great thing about this world is that there really are no limits. No matter
how many hours you put into your home lab, you’ll always come up with
something new that you can improve.

I realize that, obviously, I can’t set up an entire
enterprise system on my own in my spare time. However, I find it incredibly interesting to
keep up with trends and continually optimize my setup, adapting it to the times
and expanding my own knowledge.

With my specific focus on cybersecurity, I’m constantly trying to get better at
monitoring everything while simultaneously using active testing (e.g., with Burp Suite or nmap) to find security vulnerabilities in
my own system.

<br>

# Cybersecurity Goals

My long-term plan is to adapt my home lab closely to current security concepts. In order to do so, I’m guided by established security standards and concepts such as ISO/IEC 27001 and the BSI IT-Grundschutz, particularly BSI 200-4. My goal here is to implement security concepts even on a small scale and, of course, to meet the CIA objectives.

<br>

# Projects

Here are a few more projects I’ve worked on.

## Security Onion

Security Onion is currently one of the most important components of my security setup.

The network traffic is routed through my managed switch. Through port mirroring, the traffic is mirrored to a monitoring port.

The Security Onion monitoring interface is connected to this port.

This allows Security Onion to analyze the network traffic.

Test:
I tested the feature using an Nmap scan on an internal LXC.
The scan was subsequently detected by Security Onion and classified as a threat.


<img width="898" height="487" alt="SecurityOnion" src="https://github.com/user-attachments/assets/d928edd7-ce9e-4123-9673-c1258191e5c0" />




## Visualizing Cloudflare Logs in Grafana

I've developed a Bash script that retrieves the logs via the Cloudflare API.
A cron job runs this script daily.

The logs are then written to an InfluxDB bucket and retrieved by
Grafana. This allows me to visualize traffic and attacks on my websites,
since the requests first arrive at Cloudflare.

<img width="917" height="558" alt="Grafana" src="https://github.com/user-attachments/assets/00db953c-e665-4765-87f8-95b7006a06c5" />
<img width="860" height="511" alt="Grafana 2" src="https://github.com/user-attachments/assets/1390da3e-0b0f-4b03-9a65-a40a538fce65" />




## TrueNAS Scale:

Since I had a lot of spare HDDs, I connected them directly to TrueNAS Scale via a Proxmox node. Using RAID 1, I now have several terabytes of storage space available.

Among other things, Nextcloud and Jellyfin run on TrueNAS. The corresponding datasets are also backed up to an external storage device via rsync.

The reason I don’t use Proxmox Backup for this is the additional storage space it requires, which I want to avoid in my setup.


<img width="914" height="461" alt="TrueNAS" src="https://github.com/user-attachments/assets/c526829b-7216-4d55-a03b-5a65e9cf07f7" />




## Planned Project: Active Directory Lab
Since I already have a lot of experience with networks, firewalls, and Linux,
I would like to focus on developing my skills in the Windows environment next.

My goal is to set up a small test lab to gain a better understanding of a Windows Enterprise
environment.

<br>

# Roadmap

### 🌐 Network
- [ ] Expand subnets and segmentation
- [ ] Upgrade to 10 Gbit/s

### ⚙️ Automation
- [ ] Ansible
- [ ] n8n
- [ ] Automated updates

### 🔐 IAM
- [ ] Authentik / SSO
- [ ] Centralized user and permissions management

### 🛡️ Security
- [ ] Optimize SecurityOnion alerts
- [ ] Centralized security alerts

### 🖥️ Infrastructure
- [ ] Kubernetes / K3s
- [ ] Expand home lab

### 📚 Documentation
- [ ] Fully document network and infrastructure
- [ ] Document backup & recovery

<br>

# Contact
- LinkedIn: Robin Lorenz
- GitHub: robin45978


<br>

**Note:** To protect the IT security of my home lab, some information and configurations
are not publicly documented.


