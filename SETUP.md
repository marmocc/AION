# First Boot Setup

## 1. SSH into the server as `core`
```bash
ssh core@AION
```

## 2. Create user directories and set permissions
```bash
sudo mkdir -p /var/mnt/data/marmocc
sudo chown marmocc:marmocc /var/mnt/data/marmocc
sudo chmod 755 /var/mnt/data/marmocc
```

## 3. Inject secrets into Podman
```bash
printf "BESZEL_SSH_KEY" | sudo podman secret create beszel_ssh_key -
printf "BESZEL_PASSWORD" | podman secret create beszel_password -
printf "CLOUDFLARE_TOKEN" | podman secret create cloudflare_token -
printf "FILESTASH_PASSWORD" | podman secret create filestash_password -
printf "KOPIA_PASSWORD" | sudo podman secret create kopia_password -
```

## 4. Restart containers
```bash
systemctl --user restart cloudflared beszel filestash
sudo systemctl restart beszel-agent kopia
```