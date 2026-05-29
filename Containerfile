FROM quay.io/fedora/fedora-bootc:latest

# Create my user, set SSH key, and fix permissions, also locks password login
RUN useradd -m -G wheel marmocc && \
    mkdir -p /home/marmocc/.ssh && \
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK0/nWAS+nfgwj13kIfeIQq3UW1Bp6vrbeOCIi8dHkOU marmocc@marmo.cc" \
    > /home/marmocc/.ssh/authorized_keys && \
    chown -R marmocc:marmocc /home/marmocc/.ssh && \
    chmod 700 /home/marmocc/.ssh && \
    chmod 600 /home/marmocc/.ssh/authorized_keys && \
    passwd -l marmocc

# Create lingering podman user for rootless containers
RUN useradd -m -s /sbin/nologin podman && \
    mkdir -p /var/lib/systemd/linger && \
    touch /var/lib/systemd/linger/podman

# Install nano, cockpit, pcp (Performance Metrics for Cockpit)
RUN dnf -y install nano cockpit cockpit-podman cockpit-storaged pcp && \
    dnf clean all

# Pull the network configurations and hostname
COPY etc/NetworkManager/system-connections/ /etc/NetworkManager/system-connections/
RUN chmod 600 /etc/NetworkManager/system-connections/direct.nmconnection && \
    chmod 600 /etc/NetworkManager/system-connections/router.nmconnection
COPY etc/hostname /etc/hostname

# Enable services
RUN systemctl enable cockpit.socket