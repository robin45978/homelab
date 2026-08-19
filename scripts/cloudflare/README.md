## Cloudflare Analytics → InfluxDB

Das Script ruft Cloudflare-Analytics der letzten 7 Tage über die GraphQL API ab und schreibt die Daten in **InfluxDB 2.x** zur Visualisierung in Grafana.

### Voraussetzungen

```bash
sudo apt install curl jq bc
```

### Ausführen

```bash
chmod +x cloudflare-to-influxdb.sh
./cloudflare-to-influxdb.sh
```

Vorher die **Cloudflare- und InfluxDB-Zugangsdaten** im Script konfigurieren.

### Cronjob

Cron öffnen:

```bash
crontab -e
```

Jeden Tag ausführen:

```cron
0 * * * * /opt/scripts/cloudflare-to-influxdb.sh >> /var/log/cloudflare-to-influxdb.log 2>&1
```

Logs prüfen:

```bash
tail -f /var/log/cloudflare-to-influxdb.log
```
