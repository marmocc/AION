FROM quay.io/fedora/fedora-bootc:latest

ARG USER_NAME="services"
ARG USER_SSH_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ5mcen2vcOenfR6CUmHu3h+zrV4573xJMo0NMKcfXHD"

RUN useradd -m -U -s /bin/bash "${USER_NAME}"
RUN mkdir -p /var/lib/systemd/linger && touch "/var/lib/systemd/linger/${USER_NAME}"
RUN mkdir -p "/home/${USER_NAME}/.ssh" && \
    echo "${USER_SSH_KEY}" > "/home/${USER_NAME}/.ssh/authorized_keys" && \
    chown -R "${USER_NAME}:${USER_NAME}" "/home/${USER_NAME}/.ssh" && \
    chmod 700 "/home/${USER_NAME}/.ssh" && \
    chmod 600 "/home/${USER_NAME}/.ssh/authorized_keys"