### Cloudflared

I installed Cloudflared on my Ubuntu server using the official Cloudflare repository. First I added the GPG key and then added the Cloudflare repository. The installation packages are provided by [Cloudflare Package Repository](https://pkg.cloudflare.com/index.html).

```bash
# Ubuntu 24.04 (Noble Numbat)

# Add Cloudflare GPG key
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

# Add Cloudflare repository
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared noble main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

# Install cloudflared
sudo apt update
sudo apt install cloudflared
```

After that I connected the server to my existing Cloudflare Tunnel. For this I used the installation command provided by the **Cloudflare Zero Trust Dashboard**:

```bash
sudo cloudflared service install <TUNNEL_TOKEN>
```

Finally, I checked if the Cloudflared service is running:

```bash
sudo systemctl status cloudflared
```
