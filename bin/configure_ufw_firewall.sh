#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"
SYSTEMD_DOCKER_SERVICE_FILE="/lib/systemd/system/docker.service"
SEARCH_STRING="^ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock$"
REPLACE_STRING="ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --iptables=false"

pushd "${ROOT_DIR}" 1> /dev/null || exit

source ".env"

# Make Docker service not change firewall rules on its own.
sudo sed -i "s#${SEARCH_STRING}#${REPLACE_STRING}#" "${SYSTEMD_DOCKER_SERVICE_FILE}"
sudo systemctl daemon-reload
sudo systemctl restart docker.service

# Configure ufw firewall.
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw default allow routed
sudo ufw allow from 127.0.0.0/8
sudo ufw allow "${PORT_HOST_HTTP}"
sudo ufw allow "${PORT_HOST_HTTPS}"
for port in ${FIREWALL_INCOMING_PORTS_ALLOWED}; do
    sudo ufw allow "${port}"
done

popd 1> /dev/null || exit