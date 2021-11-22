#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"
SYSTEMD_TEMPLATE_FILE="systemd/web-service-template.service"

pushd "${ROOT_DIR}" 1> /dev/null || exit

source ".env"

SYSTEMD_DST_FILE="/etc/systemd/system/${DOMAIN_NAME}.service"

sudo cp "${SYSTEMD_TEMPLATE_FILE}" "${SYSTEMD_DST_FILE}"
sudo sed -i "s#{DOMAIN_NAME}#${DOMAIN_NAME}#" "${SYSTEMD_DST_FILE}"
sudo sed -i "s#{ROOT_DIR}#${ROOT_DIR}#" "${SYSTEMD_DST_FILE}"

sudo systemctl daemon-reload
sudo systemctl enable "${DOMAIN_NAME}"

popd 1> /dev/null || exit