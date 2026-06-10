FROM quay.io/fedora/fedora-bootc:latest

ARG HOST_NAME="AION"
ARG USER_NAME="services"
ARG USER_SSH_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ5mcen2vcOenfR6CUmHu3h+zrV4573xJMo0NMKcfXHD"

RUN echo "${HOST_NAME}" > /etc/hostname
RUN useradd -m -U -s /bin/bash "${USER_NAME}"
RUN mkdir -p /var/lib/systemd/linger && touch "/var/lib/systemd/linger/${USER_NAME}"
RUN mkdir -p "/home/${USER_NAME}/.ssh" && \
    echo "${USER_SSH_KEY}" > "/home/${USER_NAME}/.ssh/authorized_keys" && \
    chown -R "${USER_NAME}:${USER_NAME}" "/home/${USER_NAME}/.ssh" && \
    chmod 700 "/home/${USER_NAME}/.ssh" && \
    chmod 600 "/home/${USER_NAME}/.ssh/authorized_keys"

COPY ./quadlets/rootful/ /etc/containers/systemd/
RUN mkdir -p "/home/${USER_NAME}/.config/containers/systemd/"
COPY ./quadlets/rootless/ /home/${USER_NAME}/.config/containers/systemd/
RUN chmod 755 /etc/containers/systemd/*
RUN chown -R "${USER_NAME}:${USER_NAME}" "/home/${USER_NAME}/.config"
RUN chmod -R 755 "/home/${USER_NAME}/.config"

RUN mkdir -p /etc/NetworkManager/system-connections/
COPY ./network/ /etc/NetworkManager/system-connections/
RUN chmod 600 /etc/NetworkManager/system-connections/*

RUN bootc container lint