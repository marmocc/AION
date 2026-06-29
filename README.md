# First Boot Setup

## 1. SSH into the server as `core`
```bash
ssh core@AION
```

## 2. Inject secrets into Podman
```bash
printf "CLOUDFLARE_TOKEN" | podman secret create cloudflare_token -
printf "FILESTASH_PASSWORD" | podman secret create filestash_password -
```

## 3. Restart containers
```bash
systemctl --user restart cloudflared filestash
```