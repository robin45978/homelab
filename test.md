# Homelab

In dem folgenden Repository möchte ich mein Homelab dokumentieren – meine aktuelle Umsetzung, die Entwicklung über die Jahre und meine Ziele und Visionen für die Zukunft.

---

## 🛠️ Tech Stack

| Bereich              | Services                                             |
| -------------------- | ---------------------------------------------------- |
| **Virtualization**   | Proxmox VE (VM & LXC)                                |
| **Network**          | OPNsense, OpenWRT, Fritz!Box, Netgear Managed Switch |
| **Security / SIEM**  | Security Onion, Suricata, Wazuh                      |
| **Monitoring**       | Grafana, InfluxDB, Uptime Kuma                       |
| **Containers**       | Docker, Portainer                                    |
| **Cloud / Access**   | Cloudflare, Cloudflare Tunnel, Cloudflare Zero Trust |
| **VPN**              | WireGuard                                            |
| **Smart Home**       | Home Assistant                                       |
| **Storage**          | TrueNAS, Synology NAS, NFS                           |
| **Cloud**            | Nextcloud                                            |
| **Documents**        | Paperless-ngx, Invoice Ninja                         |
| **Media**            | Jellyfin                                             |
| **DNS**              | AdGuard Home                                         |
| **Dashboard**        | Homarr                                               |
| **Telephone**        | 3CX                                                  |
| **Webhosting**       | WordPress, CloudPanel                                |
| **Password Manager** | Bitwarden                                            |
| **Automation**       | Cron Jobs                                            |
| **Remote Access**    | NoMachine                                            |

---

# 📈 Entwicklung

## Die Anfänge

Angefangen hat alles mit einem **Raspberry Pi und Ubuntu**.

Dort lief unter anderem meine erste eigene Website. Mit der Zeit wurden die Anforderungen größer und der Raspberry Pi durch einen PC bzw. Server ersetzt.

Anschließend wurde die Infrastruktur Schritt für Schritt erweitert.

---

## Firewall & Netzwerk

Am Anfang wurde hauptsächlich die **Fritz!Box** als Firewall verwendet.

Danach kam ein eigener kleiner Firewall-PC hinzu. Als die Leistung für meine Anforderungen nicht mehr ausreichte, bin ich auf **pfSense** umgestiegen.

pfSense wurde anschließend als VM auf dem Server betrieben.

Später habe ich verschiedene Firewall-Lösungen getestet und bin schließlich bei **OPNsense** gelandet.

Gründe für den Wechsel waren unter anderem:

* Open Source
* aktive Community
* Weiterentwicklung
* bessere Möglichkeiten für mein Setup

Mit zwei Firewall-Systemen wurde anschließend auch **High Availability** umgesetzt.

---

## Proxmox

Mit zunehmender Hardware wurde die Infrastruktur auf **Proxmox** umgestellt.

Aktuell besteht mein Homelab aus einem **3-Node-Proxmox-Cluster**.

Da meine Nodes nur über eine begrenzte Netzwerkbandbreite verbunden sind und die vorhandenen Ressourcen begrenzt sind, verwende ich bewusst **kein Ceph**.

Stattdessen nutze ich ein NAS als **NFS Shared Storage**.

Für das Proxmox-Cluster-Quorum wird zusätzlich ein Raspberry Pi verwendet.

---

## Storage

Mein Storage-Setup hat sich ebenfalls mehrfach verändert.

### OpenMediaVault → TrueNAS SCALE

Da über die Jahre viele Festplatten übrig geblieben sind, werden diese heute über einen Proxmox Node an **TrueNAS SCALE** durchgereicht.

Dort wird der Speicher unter anderem für:

* Nextcloud
* Jellyfin
* allgemeine Daten
* Backups

verwendet.

Die Daten werden zusätzlich per **rsync auf ein externes Speichermedium** gesichert.

Ich nutze dafür bewusst nicht Proxmox Backup für alle Daten, da mir der zusätzliche Speicherbedarf dafür in meinem Setup zu hoch ist.

---

# 🔄 Technologiewechsel

Über die Jahre wurden einige Services und Technologien durch andere Lösungen ersetzt.

| Früher               | Heute                  | Grund                      |
| -------------------- | ---------------------- | -------------------------- |
| Raspberry Pi         | Server / Proxmox       | Mehr Leistung benötigt     |
| pfSense              | OPNsense               | Open Source / Community    |
| OpenVPN              | WireGuard              | Performance                |
| OpenMediaVault       | TrueNAS SCALE          | Storage-Anforderungen      |
| Pi-hole              | AdGuard Home           | Mehr Filtermöglichkeiten   |
| Plex                 | Jellyfin               | Kosten                     |
| Plesk                | CloudPanel             | Open Source                |
| Self-hosted 3CX      | Externe 3CX Cloud      | Änderung des Lizenzmodells |
| HAProxy auf OPNsense | Cloudflare Tunnel      | DDoS-Schutz / Zero Trust   |
| WireGuard auf LXC    | WireGuard auf OPNsense | Bessere Zugriffsverwaltung |

---

# 🔐 Security

## Security Onion

Security Onion ist aktuell einer der wichtigsten Bestandteile meines Security-Setups.

Der Netzwerkverkehr wird über meinen Managed Switch geleitet. Über **Port Mirroring** wird der Traffic auf einen Monitoring-Port gespiegelt.

An diesem Port hängt das Monitoring-Interface von Security Onion.

Dadurch kann Security Onion den Netzwerkverkehr analysieren.

### Test

Die Funktion wurde unter anderem mit einem **Nmap-Scan auf einen internen LXC** getestet.

Der Scan konnte anschließend innerhalb von Security Onion erkannt und analysiert werden.

📷 `docs/images/security-onion.png`

---

## Suricata

Innerhalb der Security-Monitoring-Umgebung wird **Suricata** zur Erkennung und Analyse von Netzwerkaktivitäten verwendet.

Aktuell arbeite ich daran, die erzeugten Alerts weiter zu optimieren und unnötige bzw. False-Positive-Alerts zu reduzieren.

---

## Wazuh

Wazuh wurde bereits aufgebaut und getestet.

Aktuell läuft Wazuh jedoch nicht dauerhaft, da **Security Onion bereits einen großen Teil der verfügbaren Ressourcen benötigt**.

Wazuh soll später wieder integriert werden, sobald die Infrastruktur entsprechend erweitert wurde.

---

# 📊 Monitoring

Für das Monitoring nutze ich:

* Grafana
* InfluxDB
* Uptime Kuma

Grafana dient dabei als zentrale Visualisierung.

Uptime Kuma überwacht die Erreichbarkeit meiner verschiedenen Services.

---

# ☁️ Cloudflare Analytics → Grafana

Ein eigenes Projekt ist die Visualisierung meiner **Cloudflare Logs in Grafana**.

Dafür habe ich mit Unterstützung von KI ein Script erstellt, welches die Daten über die **Cloudflare API** abruft.

Ein Cronjob führt das Script regelmäßig aus.

Die Daten werden anschließend in einen **InfluxDB Bucket** geschrieben und von Grafana visualisiert.

Dadurch kann ich beispielsweise Zugriffe und Angriffe auf meine Websites analysieren.

Der Vorteil dabei ist, dass die Requests bereits bei Cloudflare ankommen und dadurch auch blockierte bzw. verdächtige Zugriffe in den Analytics sichtbar werden.

📷 `docs/images/cloudflare-grafana.png`

---

# 🔑 VPN

Früher habe ich **OpenVPN** verwendet.

Nach der Veröffentlichung von WireGuard bin ich aufgrund der besseren Performance auf **WireGuard** umgestiegen.

Ursprünglich lief WireGuard in einem LXC.

Da mir dort die Verwaltung der Zugriffe auf verschiedene Netzwerke nicht optimal gefallen hat, laufen die VPN-Endpunkte mittlerweile direkt auf **OPNsense**.

Dabei existieren unterschiedliche WireGuard-Konfigurationen für verschiedene Netzbereiche.

---

# 🌐 OpenWRT

Ein weiteres Projekt ist die Verwendung eines alten **TP-Link Routers mit OpenWRT**.

Damit kann alte Hardware weiter als Netzwerkkomponente verwendet und für eigene Netzwerkexperimente eingesetzt werden.

📷 `docs/images/openwrt.png`

---

# 🖥️ Remote Access

Für Remote Desktop und ressourcenschonenden Zugriff auf Systeme habe ich **NoMachine** getestet.

Dabei ist mir aufgefallen, dass es sich für meinen Anwendungsfall deutlich flüssiger anfühlt als einige andere Lösungen und dabei weniger Netzwerkressourcen benötigt.

---

# 🏠 Self-Hosted Services

Aktuell laufen unter anderem:

* Nextcloud
* Paperless-ngx
* Invoice Ninja
* Jellyfin
* Home Assistant
* Homarr
* AdGuard Home
* Bitwarden
* 3CX
* WordPress
* CloudPanel
* Grafana
* InfluxDB
* Uptime Kuma
* Docker / Portainer

---

# 🚀 Zukunft / Vision

## Netzwerk

* [ ] Interne Subnetze erweitern
* [ ] Bereiche gezielter voneinander trennen
* [ ] Netzwerksegmentierung verbessern
* [ ] OpenWRT weiter einsetzen und testen

## Automation

* [ ] Ansible einrichten
* [ ] Updates automatisieren
* [ ] Deployments vereinfachen
* [ ] n8n für bestimmte Workflows einsetzen

## IAM

* [ ] Authentik einrichten
* [ ] SSO für ausgewählte interne Services
* [ ] Zentrale Authentifizierung
* [ ] Rollen und Berechtigungen zentral verwalten

## Security

* [ ] Security Onion Alerts optimieren
* [ ] False Positives reduzieren
* [ ] Security Onion / Wazuh weiter integrieren
* [ ] Security Alerts zentral sammeln
* [ ] Alerts über Discord Webhooks ausgeben

## Infrastructure

* [ ] Proxmox weiter automatisieren
* [ ] Terraform weiter ausbauen
* [ ] Kubernetes / K3s testen
* [ ] Homelab Hardware erweitern

## Documentation

* [ ] Netzwerk vollständig dokumentieren
* [ ] Services dokumentieren
* [ ] Infrastruktur dokumentieren
* [ ] Backup- und Recovery-Konzept dokumentieren
* [ ] Änderungen und wichtige Entscheidungen dokumentieren

---

# 🛡️ Cybersecurity Ziele

Langfristig möchte ich mein Homelab stärker an professionellen Security-Konzepten ausrichten.

### ISO 27001

Annäherung an die Anforderungen und Prozesse von **ISO 27001**.

### BSI IT-Grundschutz

Auseinandersetzung mit dem **BSI IT-Grundschutz**, insbesondere BSI-200-4 für das Business Continuity Management.

Dabei möchte ich nicht einfach Standards „nachbauen“, sondern verstehen, wie sich solche Konzepte auf eine kleinere Infrastruktur übertragen lassen.

---

# 🔬 Aktuelle Projekte

| Projekt                                   | Status                 |
| ----------------------------------------- | ---------------------- |
| Cloudflare Analytics → InfluxDB → Grafana | 🟢                     |
| Security Onion Network Monitoring         | 🟢                     |
| Suricata IDS                              | 🟢                     |
| Proxmox 3-Node Cluster                    | 🟢                     |
| NFS Shared Storage                        | 🟢                     |
| TrueNAS SCALE                             | 🟢                     |
| WireGuard auf OPNsense                    | 🟢                     |
| OpenWRT                                   | 🟢                     |
| Grafana Monitoring                        | 🟢                     |
| Uptime Kuma                               | 🟢                     |
| Wazuh                                     | 🟡 aktuell deaktiviert |
| Authentik / IAM                           | 🔵 geplant             |
| Ansible                                   | 🔵 geplant             |
| n8n                                       | 🔵 geplant             |
| Kubernetes / K3s                          | 🔵 geplant             |

---

# 📚 Was ich mit dem Homelab lerne

Durch den Aufbau und die Weiterentwicklung des Homelabs beschäftige ich mich praktisch mit:

* Linux
* Networking
* Firewalls
* Virtualisierung
* Storage
* Network Security
* SIEM / Security Monitoring
* IDS
* VPN
* Cloudflare / Zero Trust
* Docker
* Monitoring
* Automation
* Infrastructure as Code

Der Fokus liegt dabei darauf, die Systeme selbst aufzubauen, Probleme zu lösen und die Auswirkungen verschiedener technischen Entscheidungen praktisch zu verstehen.
