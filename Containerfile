FROM quay.io/fedora/fedora-coreos:stable

RUN useradd -m -G wheel marmocc && \
    mkdir -p /home/marmocc/.ssh && \
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK0/nWAS+nfgwj13kIfeIQq3UW1Bp6vrbeOCIi8dHkOU marmocc@marmo.cc" \
    > /home/marmocc/.ssh/authorized_keys && \
    chmod 700 /home/marmocc/.ssh && \
    chmod 600 /home/marmocc/.ssh/authorized_keys && \
    passwd -l marmocc

RUN useradd -m -s /sbin/nologin podman && \
    mkdir -p /var/lib/systemd/linger && \
    touch /var/lib/systemd/linger/podman

RUN rpm-ostree install nano pcp cockpit cockpit-podman cockpit-storaged && \
    rpm-ostree cleanup -m

COPY etc/NetworkManager/system-connections/ /etc/NetworkManager/system-connections/
RUN chmod 600 /etc/NetworkManager/system-connections/direct.nmconnection && \
    chmod 600 /etc/NetworkManager/system-connections/router.nmconnection
COPY etc/hostname /etc/hostname

RUN systemctl enable cockpit.socket
RUN ostree container commit