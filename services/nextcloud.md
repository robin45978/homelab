# Nextcloud

I have deployed Nextcloud as a TrueNAS SCALE app.

As for storage, I have split the app data, the database, and the user data across my SSD and HDD pools.

### Storage

* **Nextcloud app data → SSD pool**
* **PostgreSQL → SSD pool**
* **Nextcloud user data → HDD pool**

I placed the app data and PostgreSQL on the SSD because Nextcloud and PostgreSQL generate many small read and write operations. Placing the database on the HDD didn’t make sense for the performance I wanted.

The actual user data is stored on the HDD pool, since this is where the majority of storage capacity is required.

### Host Paths

I used  host paths instead of ixVolumes so that I can manage the data sets directly in TrueNAS and know exactly where the data is stored.

```text
SSD pool
├── nextcloud-appdata
└── postgres-data

HDD pool
└── nextcloud-data
```

I also enabled automatic permissions for the storage mounts so that TrueNAS manages the necessary permissions for the apps.

## Collabora


First, I installed Collabora directly as a Nextcloud app for online document editing and collaboration.

However, I noticed significant delays when opening and editing documents. The performance was insufficient for normal use.

Therefore, I moved Collabora to a separate Docker container.

The current configuration looks like this:

```text
Nextcloud
    │
    │ WOPI
    ▼
Docker
    │
    └── Collabora Online
```

Running Collabora separately in Docker reduced the delays, and online document editing became significantly faster.

