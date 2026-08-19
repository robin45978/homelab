### Scanopy

I run Scanopy as a **Docker Stack** inside my Docker VM. I use it to discover and visualize devices and network connections in my homelab.


```yaml
# Scanopy Docker Stack

name: scanopy

services:
  daemon:
    image: ghcr.io/scanopy/scanopy/daemon:latest
    container_name: scanopy-daemon
    network_mode: host
    privileged: true
    restart: unless-stopped
    environment:
      SCANOPY_LOG_LEVEL: ${SCANOPY_LOG_LEVEL:-info}
      SCANOPY_SERVER_URL: http://127.0.0.1:60072
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:60073/api/health || exit 1"]
      interval: 5s
      timeout: 3s
      retries: 15
    volumes:
      - daemon-config:/root/.config/scanopy/daemon
      - /var/run/docker.sock:/var/run/docker.sock:ro

  postgres:
    image: postgres:17-alpine
    environment:
      POSTGRES_DB: scanopy
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-password}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped
    networks:
      - scanopy

  server:
    image: ghcr.io/scanopy/scanopy/server:latest
    ports:
      - "60072:60072"
    environment:
      SCANOPY_LOG_LEVEL: ${SCANOPY_LOG_LEVEL:-info}
      SCANOPY_DATABASE_URL: postgresql://postgres:${POSTGRES_PASSWORD:-password}@postgres:5432/scanopy
      SCANOPY_WEB_EXTERNAL_PATH: /app/static
      SCANOPY_PUBLIC_URL: ${SCANOPY_PUBLIC_URL:-http://localhost:60072}
      SCANOPY_INTEGRATED_DAEMON_URL: http://host.docker.internal:60073
    volumes:
      - ./data:/data
    extra_hosts:
      - "host.docker.internal:host-gateway"
    depends_on:
      postgres:
        condition: service_healthy
      daemon:
        condition: service_started
    restart: unless-stopped
    networks:
      - scanopy

volumes:
  postgres_data:
  daemon-config:

networks:
  scanopy:
    driver: bridge
    ipam:
      config:
        - subnet: 172.31.0.0/16
          gateway: 172.31.0.1
```
