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

<img width="917" height="558" alt="Grafana" src="https://github.com/user-attachments/assets/76d55185-7b9c-4357-b0dc-4b117d2c6e5e" />


### Proxmox

The Proxmox dashboard visualizes metrics from my Proxmox environment, including system and resource usage.

Dashboard:

```text
proxmox-dashboard.json
```

<img width="911" height="496" alt="Proxmox Grafana Dashboard" src="https://github.com/user-attachments/assets/5fd4bccc-2c80-42c8-b69f-0b8d065466d7" />


## Import

The dashboards can be imported directly into Grafana:

**Dashboards → Import → Upload JSON file**

After importing, the corresponding data source needs to be selected.

