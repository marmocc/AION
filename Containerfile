FROM quay.io/fedora/fedora-bootc:latest

# Install system packages
RUN dnf -y install nano cockpit cockpit-podman cockpit-storaged pcp && \
    dnf clean all

# User definitions
RUN useradd -M -G wheel -d /var/home/marmocc marmocc && \
    passwd -l marmocc && \
    useradd -M -s /sbin/nologin podman

# Persistent configuration
COPY usr/ /usr/

# Enable services
RUN systemctl enable cockpit.socket