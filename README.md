# Homelab
In diesem Repository möchte ich mein Homelab dokumentieren. Dabei gehe ich auf
meine aktuelle Umsetzung, die Entwicklung über fast 10 Jahre sowie meine Ziele
und Visionen für die Zukunft ein.

Mein Grundsatz ist dabei, möglichst für alles eine Open-Source-Lösung zu finden.
Deshalb teste ich viele verschiedene Tools und Technologien und entscheide
anschließend, welche Lösung am besten zu meinem Setup passt.

Mein Ziel ist es, eine sichere und möglichst effiziente Cloud-Architektur
aufzubauen und dabei gleichzeitig verschiedene Technologien aus den Bereichen
Networking, Virtualisierung, Cloud und Cybersecurity praktisch zu erlernen.

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



# Dashboard
<img width="905" height="532" alt="Dashboard " src="https://github.com/user-attachments/assets/c64e82f9-c2a9-418f-a52d-40040254f485" />

<img width="901" height="524" alt="Dashboard 2" src="https://github.com/user-attachments/assets/d0f3a847-2c22-4ec9-b25b-9c86f8330c01" />






# Meine Hardware Entwicklung – Vom Anfang bis Heute

Angefangen hat alles mit einem Raspberry Pi und Ubuntu OS. Dort habe ich meine erste Website damals laufen gehabt. Damals noch mit HTML und CSS selbst programmiert ;)

Das wurde jedoch relativ schnell zu klein und nach langem Herausfinden, wie Betriebssysteme eigentlich auf einem PC laufen und wie man diese installiert, kam der Umstieg zu Proxmox auf einem PC.

Die anfänglichen Firewall-Regeln habe ich mit einer Fritzbox und VHosts konfiguriert. Daraufhin folgte eine kleine alte Firewall, wobei ich über den Console-Port pfSense installierte, um diese nutzen zu können.

Jedoch wurde mit wachsender Anforderung und einem Durchsatz von 100 Mbit/s schnell klar, dass dies nicht mehr ausreichte. Deshalb virtualisierte ich pfSense als VM auf Proxmox und lernte dabei das interne Subnetting.

Mit der Zeit folgte dann eine Sophos Firewall, die ich aufgrund einer abgelaufenen Lizenz auf OPNsense umstellte.

Das nachfolgende Problem war, dass der PC manchmal wegen Fehlkonfigurationen abstürzte, woraufhin ich High Availability einrichtete. Deshalb kam ein zweiter PC dazu und letztendlich noch ein weiterer, damit auch das Quorum bedient ist.

Dazu kamen noch mehrere Storage-Systeme, um die gesamten Daten zu speichern.

Aktuell besteht mein Homelab aus 3 Nodes mit mehreren NAS-Systemen im Hintergrund.

Da meine Leitung zwischen den Geräten noch auf 1 Gbit/s begrenzt ist, benutze ich bewusst kein Ceph, sondern stelle die Hochverfügbarkeit über NFS mittels Shared NAS dar. Natürlich hat man nicht alle Vorteile, jedoch ist dies aktuell die beste Lösung für mein Setup.

Der nächste Schritt wird das Upgrade auf 10 Gbit/s sein. :)






# 🔄 Technologiewechsel

Über die Jahre habe ich einige Technologien durch andere Lösungen ersetzt. Folgend erkläre ich kurz, was mich zu dem Wechsel gebracht hat.

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

Das tolle an in dieser welt ist, dass wirklich  keine Grenzen gesetzt sind. Egal wieviele Stunden man in sei Homelap reinsteckt, einem fällt immer wieder was neues ein, was man verbessern kann. Mir ist bewusst, dass ich nebenbei und alleine natuürlich kein gesamten Enterprise System aufsetzten kann. Jedoch finde ich es unheilich interessant mit der Zret zu gehen und immer wieder mein Setup zu optimieren, der Zeit anzupassen und mein eigenes Wissen erweitern. durxh meinen speziellen Fokus auf Cybersecurity versuche ich immer besser alles zu überwachen und gleichzeitig durch aktives Testen Sichetheitslücken in meinem eigenen System zu finden.

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

Mein Plan ist es langfristig mein Homelab stark an aktuelle Security-Konzepten anzupassen. Dabei werde ich mich zunächst auf das ISO 27001 und auf den BSI IT-Grundschutz (v.a BSI-200-4) fokusieren. Mir geht es hierbei darum, Sichehetskonzepte selbst in kleinem Mass umzusetzen. 


# Projekte


Anbei stelle ich noch ein paar Projekte vor, die ich umgesetzt habe.

## Projekt:cloudflarelogs in Grafana virtualisieren.
MitHilfe von Ki ein Script geschrieben,d ass über Cloudflare Api die Logs abruft. Cronjob führt dieses Script täglich aus 
Die Logs werden dsann inInfluxDb Bucket geschrieben und Grafana ruft diese dann ab. dadurch werden Angriffe auf die Websiten visualsiert, da die Zugriffe ja nur bei Cloudflare ankommen

<img width="917" height="558" alt="Grafana" src="https://github.com/user-attachments/assets/00db953c-e665-4765-87f8-95b7006a06c5" />
<img width="860" height="511" alt="Grafana 2" src="https://github.com/user-attachments/assets/1390da3e-0b0f-4b03-9a65-a40a538fce65" />




Projekt securityOnion:
Der gesamte Netzwerk verkehr wird über den maaged switch geleitet. dabei wird der traffik uf einnen monitoring port gespiegelt, sodass securityonion den gesamten netwertkverkehr mitlesen kann, Erfolgreich getesett durch nmap scan auf einen internen lxc.

Project TrueNAS Scale:
Da ich sehr viele HDD Platten übrig hatte, habe ich diese über ein Proxmox Node direkt in TrueNAs Sclae durchgereciht. mittels raid 1 sind ahabe ich so mehrere terrabyte speicherplatz zur verfügung. dort laufen auch nextcloud und jellyfin drauf diese datasets werden mittels rsync auf ein externen speichergerät zusätlich gesichtert der grund wieso ich nicht dad proxmox backup nutze idt der verschendetete speicher.



Project VPN:
Während ich früher auf opnvpn gesetzt habe, habe ich nach veröffentlichung von wiregaurd direkt umgstellt. zunächst lief es auf einer lxc aber da mir hier die zugriffsverwahltung nicht gefallen hat, laufen jetzt verscheiden wiregaurd server in unterscheidlichen subnetzen direkt auf der opmsense firewall.

Porjekt openwrt auf tplink router.

<img width="990" height="598" alt="Proxmox" src="https://github.com/user-attachments/assets/2680800b-98d4-438f-802c-1e9034ecd33c" />


Zum Schutz der It Sichehreit meine Homelabs kann ich nur sehr begrenzt Screenshots und Hinweise über den genauen Aufbau meines Netzwerkes geben.


OpenWRT

Proxmox

## Geplantes Projekt:  Active Directory Lab
Da ich bereits sehr tief im Netwerkbereich, Firewall und Linux Beeich drinnen bin, möchte ich mich als nächstes im Windows Umfeld verbessern. Mein Ziel ist e ein kleines Test Lap aufzusetzen um die windows enterprsie umgebung besser zu verstehen 




