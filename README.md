# Homelab
n dem folgenden Repository möchte ich mein Homelab dokumentieren. Dabei werde ich besonders Wert auf meine aktuelle Umsetzung, die Entwicklung über die letzten 9 Jahre und meine Ziele und Visionen für die Zukunft erläutern. dabei lautet mein Grundsatz, dass ich für alles eine Opensource Lösung finden möchte und teste mich deshalb durch viele verscheidene Tools durch.


## 🛠️ Aktueller Tech Stack

| Bereich              | Services                                             |
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




<img width="905" height="532" alt="Dashboard " src="https://github.com/user-attachments/assets/c64e82f9-c2a9-418f-a52d-40040254f485" />

<img width="901" height="524" alt="Dashboard 2" src="https://github.com/user-attachments/assets/d0f3a847-2c22-4ec9-b25b-9c86f8330c01" />






meine Hardware entwicklung- Vom Anfang bis professionele homelab umgebung
angefangen hat alles mit raspberrypi und ubuntu os. dort habe ich meine erste website damals laufen gehabt.
umstieg auf einen pc. erweitertz durch kleine alte firewall. fritzbox-firewall-pc. da firewall zu schwach würde mit pfsense, wurde die pfsense als vm uf server umgestellt. dann sophos firewlal  umgerüs5tet azuf opensense zweiten pc und high availibility eingerichtet.Da die ressourcen begrennzt sind und ich nur 1gb/s leitung zwischen nodes habe benutze ich kein ceph sondern über nfs mittels shared nas. natürlich hat man nicht alle vorteile jedoch die beste lösung für mein setup raspberrypi als quorum. dann neuer recher. Aktuell Proxmox Cluster aus 3 Nodes und erwitertes setup in zwiten standort.


<img width="990" height="598" alt="Proxmox" src="https://github.com/user-attachments/assets/2680800b-98d4-438f-802c-1e9034ecd33c" />





# 🔄 Technologiewechsel

Über die Jahre habe ich einige Technologien durch andere Lösungen ersetzt. Folgend erkläre ich kurz, was mich zu dem Wechsel gebrachthat.

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
| XRDP,Spice, NoVNC    | Nomaschine             | Performance                |


---


# 🚀 Zukunft / Vision

## Netzwerk

* [ ] Interne Subnetze erweitern
* [ ] Netzwerksegmentierung verbessern

## Automation

* [ ] Ansible einrichten
* [ ] Updates automatisieren
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

* [ ] Kubernetes / K3s testen(erfodert Erweiterung meines aktuellen Homelabs)
* [ ] Homelab Hardware erweitern

## Documentation

* [ ] Netzwerk vollständig dokumentieren
* [ ] Backup- und Recovery-Konzept dokumentieren
* [ ] Änderungen und wichtige Entscheidungen dokumentieren

---

# 🛡️ Cybersecurity Ziele

Mein Plan ist es langfristig mein Homelab stark an aktuelle Security-Konzepten anzupassen. Dabei möchte ich mich zunächst afu das IS= 27001 und mich auf den BSI IT-Grundschutz (v.a BSI-200-4) fokusieren. Mir geht es hierbei darum, Sichehetskonzepte selbst umzusetzten.Vor akkem das

 Business Continuity Management.




Cybersecurity Ziele:
Annäherung an das ISO27001
Umsetzung von BSI-200-4


Projekt cloudflare logs in Grafana irtualisieren.
MitHilfe von Ki ein Script geschrieben,d ass über Cloudflare Api die Logs abruft. Cronjob führt dieses Script täglich aus 
Die Logs werden dsann inInfluxDb Bucket geschrieben und Grafana ruft diese dann ab. dadurch werden Angriffe auf die Websiten visualsiert, da die Zugriffe ja nur bei Cloudflare ankommen


Projekt securityOnion:
Der gesamte Netzwerk verkehr wird über den maaged switch geleitet. dabei wird der traffik uf einnen monitoring port gespiegelt, sodass securityonion den gesamten netwertkverkehr mitlesen kann, Erfolgreich getesett durch nmap scan auf einen internen lxc.

Project TrueNAS Scale:
Da ich sehr viele HDD Platten übrig hatte, habe ich diese über ein Proxmox Node direkt in TrueNAs Sclae durchgereciht. mittels raid 1 sind ahabe ich so mehrere terrabyte speicherplatz zur verfügung. dort laufen auch nextcloud und jellyfin drauf diese datasets werden mittels rsync auf ein externen speichergerät zusätlich gesichtert der grund wieso ich nicht dad proxmox backup nutze idt der verschendetete speicher.



Project VPN:
Während ich früher auf opnvpn gesetzt habe, habe ich nach veröffentlichung von wiregaurd direkt umgstellt. zunächst lief es auf einer lxc aber da mir hier die zugriffsverwahltung nicht gefallen hat, laufen jetzt verscheiden wiregaurd server in unterscheidlichen subnetzen direkt auf der opmsense firewall.

Porjekt openwrt auf tplink router.






OpenWRT

Proxmox






