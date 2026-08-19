### Homarr

Homarr runs as a Docker container. I created the stack directly in **Portainer** by pasting the Docker Compose configuration.

```yaml
version: "3.8"

services:
  homarr:
    container_name: homarr
    image: ghcr.io/homarr-labs/homarr:latest
    restart: unless-stopped
    ports:
      - "7575:7575"
    volumes:
      - /opt/homarr/appdata:/appdata
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - SECRET_ENCRYPTION_KEY=<your-secret-key>
      - TZ=Europe/Berlin
```

The `SECRET_ENCRYPTION_KEY` is generated locally using:

```bash
openssl rand -hex 32
```

The generated key is then added to the stack in Portainer.

After deployment, Homarr is accessible on **port 7575**.
