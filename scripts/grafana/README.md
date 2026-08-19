# Grafana

I use Grafana to visualize and monitor data from different services in my homelab.

## Dashboards

### Cloudflare Analytics

The Cloudflare Analytics dashboard visualizes data collected from the Cloudflare GraphQL API and stored in InfluxDB.

It includes:

* Requests
* Pageviews
* Bandwidth
* Cached / uncached traffic
* Threats
* Visitors
* Requests by country

Dashboard:

```text
cloudflare-dashboard.json
```

### Proxmox

The Proxmox dashboard visualizes metrics from my Proxmox environment, including system and resource usage.

Dashboard:

```text
proxmox-dashboard.json
```

## Import

The dashboards can be imported directly into Grafana:

**Dashboards → Import → Upload JSON file**

After importing, the corresponding data source needs to be selected.

