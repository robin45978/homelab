# WireGuard Dynamic Endpoint Update

The OpenWrt router uses a WireGuard tunnel to connect to an OPNsense firewall. Since the public IP address of the OPNsense firewall can change, the OpenWrt router monitors a DNS record that points to the current public IP.

If the resolved IP address changes, the WireGuard interface is automatically restarted so that the tunnel reconnects to the new endpoint.

## How it works

```text
OPNsense
   │
   │ Public IP changes
   ▼
DNS record
   │
   ▼
OpenWrt
   │
   │ Check every minute
   ▼
IP changed?
   │
   ├── No  → Nothing happens
   │
   └── Yes → Restart WireGuard
```

## Script

The script resolves the configured DNS hostname and compares the result with the previously stored IP address.

```sh
#!/bin/sh

HOST="vpn.example.com"
INTERFACE="wg0"
STATE_FILE="/tmp/wireguard-endpoint-ip"

CURRENT_IP="$(nslookup "$HOST" 2>/dev/null | awk '/^Address:/ {print $2}' | tail -n 1)"

if [ -z "$CURRENT_IP" ]; then
    logger -t wireguard-ddns "DNS lookup failed for $HOST"
    exit 1
fi

LAST_IP="$(cat "$STATE_FILE" 2>/dev/null)"

if [ "$CURRENT_IP" != "$LAST_IP" ]; then
    logger -t wireguard-ddns "Endpoint changed: $LAST_IP -> $CURRENT_IP"

    echo "$CURRENT_IP" > "$STATE_FILE"

    ifdown "$INTERFACE"
    sleep 2
    ifup "$INTERFACE"
fi
```

## Cron Job

The script runs once per minute using OpenWrt's cron service:

```cron
* * * * * /root/check-wireguard.sh
```

The script only restarts WireGuard when the resolved endpoint IP changes.

## Setup

Make the script executable:

```sh
chmod +x /root/check-wireguard.sh
```

Configure the cron job:

```sh
export EDITOR="nano"
crontab -e
```

Add:

```cron
* * * * * /root/check-wireguard.sh
```

Restart the cron service:

```sh
/etc/init.d/cron restart
```

## WireGuard Configuration

The WireGuard peer uses a DNS hostname instead of a static public IP address.

Example:

```text
Interface: wg0
Endpoint: vpn.example.com
Persistent Keepalive: 25s
```

This allows the OpenWrt router to automatically reconnect the WireGuard tunnel if the public IP address of the remote OPNsense firewall changes.
