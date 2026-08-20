## Wazuh Security Monitoring

I set up Wazuh as the central SIEM platform for my homelab. It collects and analyzes security events from my Linux and Windows systems as well as network and infrastructure devices.

### Endpoint Monitoring

I installed the Wazuh Agent on my supported Linux, Windows and Proxmox systems.

The agents monitor things like:

* SSH login attempts and failed authentications
* Windows login events
* `sudo` and privileged actions
* System and authentication logs
* File Integrity Monitoring
* Installed software and vulnerabilities
* CVEs and vulnerable packages
* Agent connectivity and health

Wazuh automatically assigns severity levels to detected events:

```text
0–6    Low
7–11   Medium
12–14  High
15+    Critical
```

I use these levels to prioritize security events instead of treating every log entry as an incident.

### OPNsense Syslog Integration

For **OPNsense**, I don't install a Wazuh Agent because it is an appliance. Instead, I forward its logs directly to the Wazuh Manager using Syslog.

My current OPNsense configuration is:

```text
Enabled:      Yes
Transport:    TCP
Wazuh Server: 
Port:         514
RFC5424:      Enabled

Applications: All
Levels:       Emergency → Notice
Facilities:   All
```

I initially chose **all applications and facilities** so I can see what information OPNsense actually provides to Wazuh. I can later reduce the amount of logs if unnecessary events create too much noise.

This allows me to centralize events such as:

* Firewall activity
* Authentication events
* VPN activity
* System events
* Network-related events



### NAS Systems

I use the same approach for my **TrueNAS and Synology systems**.

Instead of modifying the appliance operating system and installing an unsupported Wazuh Agent, the systems can forward relevant logs via **Syslog** to Wazuh.

```text
TrueNAS ────┐
Synology ───┤
OPNsense ───┘
             │
           Syslog
             │
             ▼
       Wazuh Manager
```





### Syslog Configuration

Wazuh can directly receive Syslog events from network devices, firewalls and other appliances without requiring a Wazuh Agent.

The Wazuh Manager is configured as a Syslog receiver using TCP port `514`.

```xml
<!-- /var/ossec/etc/ossec.conf -->

<remote>
  <connection>syslog</connection>
  <port>514</port>
  <protocol>tcp</protocol>
  <allowed-ips>REMOTE_DEVICE_IP/32</allowed-ips>
  <local_ip>WAZUH_MANAGER_IP</local_ip>
</remote>
````

After changing the configuration:

```bash
sudo systemctl restart wazuh-manager

```

The remote device can then send its Syslog events directly to the Wazuh Manager.

Official documentation:
[https://documentation.wazuh.com/current/user-manual/capabilities/log-data-collection/syslog.html](https://documentation.wazuh.com/current/user-manual/capabilities/log-data-collection/syslog.html)






### Overall Architecture



The goal is to have **one central place for security monitoring**, where I can investigate authentication failures, suspicious activity, vulnerabilities and infrastructure events across my homelab instead of checking every system individually.



