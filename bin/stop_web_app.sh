#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"

pushd "${ROOT_DIR}" 1> /dev/null || exit

source ".env"

sudo a2dissite "${DOMAIN_NAME}"
sudo systemctl reload apache2
/usr/bin/docker-compose -p "${DOMAIN_NAME}" down --rmi local

popd 1> /dev/null || exit