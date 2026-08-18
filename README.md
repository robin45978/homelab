# homelab
In dem folgenden möchte ich mein Homelap dokumentieren, meine akteulle Umsetzung, meine Entwicklung über die Jahre und die meine Visionsziele für die Zukunft.


## 🛠️ Tech Stack

| Bereich                | Services                                             |
| ---------------------- | ---------------------------------------------------- |
| **Virtualization**     | Proxmox VE (VM & LXC)                                |
| **Network**            | OPNsense,OpenWRT,Fritzbox, Netgear Managed Switch    |
| **Security**           | Security Onion, Wazuh                                |
| **Monitoring**         | Grafana, InfluxDB, Uptime Kuma                       |
| **Containers**         | Docker, Portainer                                    |
| **Cloudflare**         | Cloudflare Zero Trust                                |
| **VPN**                | WireGuard                                            |
| **Smart Home**         | Home Assistant                                       |
| **Cloud / Storage**    | Nextcloud, TrueNAS, Synology NAS                     |
| **Documents**          | Paperless-ngx                                        |
| **Media**              | Jellyfin                                             |
| **Automation**         | Cron Jobs                                            |
DNS Adguard
Dashboard Homarr
Telephone 3CX
Websites WordPress, Cloudpanel


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




meine Hardware entwicklung- Vom Anfang bis professionele homelab umgebung
angefangen hat alles mit raspberrypi und ubuntu os. dort habe ich meine erste website damals laufen gehabt.
umstieg auf einen pc. erweitertz durch kleine alte firewall. fritzbox-firewall-pc. da firewall zu schwach würde mit pfsense, wurde die pfsense als vm uf server umgestellt. dann sophos firewlal  umgerüs5tet azuf opensense zweiten pc und high availibility eingerichtet.Da die ressourcen begrennzt sind und ich nur 1gb/s leitung zwischen nodes habe benutze ich kein ceph sondern über nfs mittels shared nas. natürlich hat man nicht alle vorteile jedoch die beste lösung für mein setup raspberrypi als quorum. dann neuer recher. Aktuell Proxmox Cluster aus 3 Nodes





Ziele:
Interne Subnetze  erweitern und bereiche gezielter umetzten
ansible einrichten um schneller updates einzuspielen
Authentikat einrichten für sso in bestimme services nur im internen netz
kubernetz, dies erfodert jedoch erwtierung meines homelabs
n8n fpr die Automaitsierung von gewissen Workflows





OpenWRT

Proxmox






