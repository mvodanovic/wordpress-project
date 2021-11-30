#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"
LETSENCRYPT_CERTS_DIR="/etc/letsencrypt/live"
CERTS_DIR="ssl"

pushd "${ROOT_DIR}" 1> /dev/null || exit

source ".env"

CRT_DIR_WP="${LETSENCRYPT_CERTS_DIR}/${DOMAIN_NAME}"
CRT_DIR_PMA="${LETSENCRYPT_CERTS_DIR}/${PHPMYADMIN_DOMAIN_NAME}"

sudo systemctl stop "${DOMAIN_NAME}"

sudo rm -f "${CERTS_DIR}/${DOMAIN_NAME}.web.crt"
sudo cp "${CRT_DIR_WP}/fullchain.pem" "${CERTS_DIR}/${DOMAIN_NAME}.web.crt"

sudo rm -f "${CERTS_DIR}/${DOMAIN_NAME}.web.key"
sudo cp "${CRT_DIR_WP}/privkey.pem" "${CERTS_DIR}/${DOMAIN_NAME}.web.key"

sudo rm -f "${CERTS_DIR}/${PHPMYADMIN_DOMAIN_NAME}.web.crt"
sudo cp "${CRT_DIR_PMA}/fullchain.pem" "${CERTS_DIR}/${PHPMYADMIN_DOMAIN_NAME}.web.crt"

sudo rm -f "${CERTS_DIR}/${PHPMYADMIN_DOMAIN_NAME}.web.key"
sudo cp "${CRT_DIR_PMA}/privkey.pem" "${CERTS_DIR}/${PHPMYADMIN_DOMAIN_NAME}.web.key"

sudo systemctl start "${DOMAIN_NAME}"

popd 1> /dev/null || exit