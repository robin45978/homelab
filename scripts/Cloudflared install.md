### Cloudflared

Cloudflared wird auf dem Ubuntu Server über das offizielle Cloudflare Repository installiert. Dafür wird zuerst der GPG-Key hinzugefügt und anschließend das Repository eingebunden.

```bash
#Ubuntu 24.04 (Noble Numbat)

# Add cloudflare gpg key
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

# Add this repo to your apt repositories
# Stable
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared noble main' | sudo tee /etc/apt/sources.list.d/cloudflared.list
# Nightly
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://next.pkg.cloudflare.com/cloudflared noble main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

# install cloudflared
sudo apt-get update && sudo apt-get install cloudflared

```

Danach wird der Server mit dem bereits erstellten Cloudflare Tunnel verbunden. Dafür kann der fertige Installationsbefehl aus dem Cloudflare Zero Trust Dashboard verwendet werden:

```bash
sudo cloudflared service install <TUNNEL_TOKEN>
```

Anschließend kann der Status des Tunnels überprüft werden:

```bash
sudo systemctl status cloudflared
```
