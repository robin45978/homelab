

## Technical Implementation

My monitoring setup is based on several independent components that communicate through HTTP/HTTPS, webhooks and monitoring protocols.

### Uptime Kuma -> Discord

I use Uptime Kuma for service availability monitoring. Uptime Kuma periodically performs health checks against my services using protocols such as HTTP(S), TCP and ICMP.

For example, an HTTP monitor checks whether a service is reachable and returns the expected HTTP status code.

When a monitor changes its state, Uptime Kuma triggers a Discord webhook:

```text
Service
   │
   │ HTTP / TCP / ICMP
   ▼
Uptime Kuma
   │
   │ HTTPS POST
   ▼
Discord Webhook
   │
   ▼
Discord Alert
```

The webhook is configured directly in Uptime Kuma. When an incident occurs, Uptime Kuma sends an HTTP POST request to the Discord webhook endpoint.

<img width="889" height="484" alt="Discord" src="https://github.com/user-attachments/assets/95075618-4519-4105-909f-6116861568ab" />



### Proxmox Error Notifications

I also configured my Proxmox environment to forward important infrastructure events directly to Discord.

The notification is configured through the **Proxmox web interface** using a Discord webhook. No custom script is required.

The basic flow is:

```text
              Proxmox
                 │
                 │ Event / Error
                 ▼
        Proxmox Notification
             System
                 │
                 │ HTTPS POST
                 ▼
         Discord Webhook
                 │
                 ▼
              Discord
```

The notification target uses the Discord webhook URL as the endpoint.

The HTTP request uses:

```text
Header:
Content-Type: application/json
```

The request body is:

````json
{
  "content": "``` {{ escape message }}```"
}
````

`{{ escape message }}` dynamically inserts the Proxmox notification message into the JSON payload and escapes characters that could otherwise break the JSON structure.

This allows Proxmox to send infrastructure events such as errors and important system notifications directly to Discord without requiring an additional notification script or external service.




<img width="893" height="419" alt="Proxmox discord" src="https://github.com/user-attachments/assets/86bd8ee7-d5b7-4f4f-ab39-43d3ee018676" />

### OPNsense Monitoring

I also monitor my **OPNsense firewall** using **Telegraf, InfluxDB v2 and Grafana**.

The data flow is:

```text
              OPNsense
                  │
                  │ Metrics
                  ▼
               Telegraf
                  │
                  │ InfluxDB v2
                  │ Write API
                  ▼
               InfluxDB
                  │
                  │ Query
                  ▼
               Grafana
```

Telegraf is configured to collect metrics from OPNsense and send them to **InfluxDB v2** using the InfluxDB v2 output configuration. Grafana then queries the data from InfluxDB and visualizes it in dashboards.


### Proxmox Monitoring

I use Grafana to visualize my Proxmox Metrics



           METRICS / DATA FLOW

                 Proxmox
                    │
                    │ Metrics
                    ▼
              Metrics Server
                    │
                    │ Write API
                    ▼
                 InfluxDB
                    │
                    │ Query
                    ▼
                 Grafana    

The next step is to configure **Grafana Alerting** so that alerts are automatically sent to Discord.

For example, I want to create alert rules for:

```text
CPU usage > 90%
RAM usage > 90%
Disk usage > 85%
High network traffic
Service availability problems
Missing metrics / monitoring failures
```

The goal is to move from passive monitoring to **active alerting**. Grafana should not only visualize the state of the infrastructure but also automatically notify me when predefined thresholds or conditions are triggered.

