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
