# Paperless-ngx Installation

I installed **Paperless-ngx** using the official installation script directly from the server console. The script guides through the setup and creates the required Docker Compose configuration. ([GitHub][1])

### 1. Run the installation script

```bash
bash -c "$(curl --location --silent --show-error https://raw.githubusercontent.com/paperless-ngx/paperless-ngx/main/install-paperless-ngx.sh)"
```

During the installation, I configured the database, port, URL, OCR language and other settings.

### 2. Generated files

The installation creates the required configuration files:

```text
docker-compose.yml
docker-compose.env
.env
```

The official Compose setup uses `docker-compose.env` for Paperless configuration and `.env` for Docker Compose settings. ([GitHub][1])

### 3. Example `.env`

```env
COMPOSE_PROJECT_NAME=paperless
```

### 4. Example `docker-compose.env`

```env
USERMAP_UID=1000
USERMAP_GID=1000

PAPERLESS_SECRET_KEY=<your-secret-key>
PAPERLESS_URL=https://paperless.example.com
PAPERLESS_TIME_ZONE=Europe/Berlin
PAPERLESS_OCR_LANGUAGE=deu
```


### 5. Start Paperless-ngx

```bash
docker compose pull
docker compose up -d
```

Check the running containers:

```bash
docker compose ps
```

Paperless-ngx is then available through the configured web port.

[1]: https://github.com/paperless-ngx/paperless-ngx/blob/dev/docs/setup.md "paperless-ngx/docs/setup.md at dev · paperless-ngx/paperless-ngx · GitHub"
[2]: https://github.com/paperless-ngx/paperless-ngx/blob/dev/docker/compose/docker-compose.env "paperless-ngx/docker/compose/docker-compose.env at dev · paperless-ngx/paperless-ngx · GitHub"
