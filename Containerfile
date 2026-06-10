FROM quay.io/fedora/fedora-bootc:latest

RUN useradd -m -U -s /bin/bash services
RUN mkdir -p /var/lib/systemd/linger && touch /var/lib/systemd/linger/services
RUN mkdir -p /home/services/.ssh && \
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ5mcen2vcOenfR6CUmHu3h+zrV4573xJMo0NMKcfXHD" > /home/services/.ssh/authorized_keys && \
    chown -R services:services /home/services/.ssh && \
    chmod 700 /home/appuser/.ssh && \
    chmod 600 /home/appuser/.ssh/authorized_keys