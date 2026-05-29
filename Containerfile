FROM quay.io/fedora/fedora-bootc:latest

# Install system packages
RUN dnf -y install nano cockpit cockpit-podman cockpit-storaged pcp && \
    dnf clean all

# Configure admin user (marmocc)
RUN useradd -m -G wheel marmocc && \
    passwd -l marmocc
    
# Configure service user (services)
RUN useradd -m -s /sbin/nologin services && \
    mkdir -p /var/lib/systemd/linger && \
    touch /var/lib/systemd/linger/services

# Configure SSH key for marmocc
COPY id_ed25519.pub /var/home/marmocc/.ssh/authorized_keys
RUN chown -R marmocc:marmocc /var/home/marmocc/.ssh && \
    chmod 700 /var/home/marmocc/.ssh && \
    chmod 600 /var/home/marmocc/.ssh/authorized_keys

# Configure network
COPY system-connections/ /etc/NetworkManager/system-connections/

RUN systemctl enable cockpit.socket