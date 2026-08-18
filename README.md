# homelab
In dem folgenden möchte ich mein Homelap dokumentieren, meine akteulle Umsetzung, meine Entwicklung über die Jahre und die meine Visionsziele für die Zukunft.


## 🛠️ Tech Stack

| Bereich                | Services                                             |
| ---------------------- | ---------------------------------------------------- |
| **Virtualization**     | Proxmox VE (VM & LXC)                                |
| **Network**            | OPNsense,OpenWRT,Fritzbox, Netgear Managed Switch    |
| **SIEM**               | Security Onion, Wazuh                                |
| **Monitoring**         | Grafana, InfluxDB, Uptime Kuma                       |
| **Containers**         | Docker, Portainer                                    |
| **Cloudflare**         | Cloudflare Zero Trust                                |
| **VPN**                | WireGuard                                            |
| **Smart Home**         | Home Assistant                                       |
| **Cloud / Storage**    | Nextcloud, TrueNAS, Synology NAS                     |
| **Documents**          | Paperless-ngx, InvoiceNinja                                    |
| **Media**              | Jellyfin                                             |
| **Automation**         | Cron Jobs                                            |
DNS Adguard
Dashboard Homarr
Telephone 3CX
Websites WordPress, Cloudpanel
passwortverwahltung bitwarden

Openwrt auf altem T


Services die ich früer verwendet habe,
3CX Selbs gehjostet, wegen Lizenänderung auf externerr cloud
Plex, Wegen koste n auf jellyfin umgesteigen
Plesk auf cloudpanel gewechslt, obwohl mir plesk besser gefällt, aner nicht opensource
Openvpn auf wireguard umgestiegen bezüglich performance
pfsense umstieg  zu onsense wegen aktiverer Community und opensource
raspberrypi umstiegauf server weil leistung nicht gereicht hat
OpenmediaVault Wechsel zu TrueNAs Scale
pihole umstellung zu adguard home um mehr filtereinstellungen zu haben
akteull kein wazuh da seecurityonion sehr viel ram verbraucht
als effizinetew  übetragungsprotokoll für linux habe ich nomaschien entdeckt, deutlich flüssiger als xdp un novnc und weniger datenervauch wie spice
opensense haproxy aufgelöst für cloudflare tunnel. grund erweitertet ddos schutz und  zero trust



meine Hardware entwicklung- Vom Anfang bis professionele homelab umgebung
angefangen hat alles mit raspberrypi und ubuntu os. dort habe ich meine erste website damals laufen gehabt.
umstieg auf einen pc. erweitertz durch kleine alte firewall. fritzbox-firewall-pc. da firewall zu schwach würde mit pfsense, wurde die pfsense als vm uf server umgestellt. dann sophos firewlal  umgerüs5tet azuf opensense zweiten pc und high availibility eingerichtet.Da die ressourcen begrennzt sind und ich nur 1gb/s leitung zwischen nodes habe benutze ich kein ceph sondern über nfs mittels shared nas. natürlich hat man nicht alle vorteile jedoch die beste lösung für mein setup raspberrypi als quorum. dann neuer recher. Aktuell Proxmox Cluster aus 3 Nodes und erwitertes setup in zwiten standort.





Ziele:
Interne Subnetze  erweitern und bereiche gezielter umetzten
ansible einrichten um schneller updates einzuspielen
IAM umsetzen: Authentikat einrichten für sso in bestimme services nur im internen netz
kubernetz, dies erfodert jedoch erwtierung meines homelabs
n8n fpr die Automaitsierung von gewissen Workflows
Security Onion Alerts bervessernum false true allerts zu entfernen
Grafana,s ecurtiy onion, wazuh alerts in Discord webhook 
Dokumentation meines Setups



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






