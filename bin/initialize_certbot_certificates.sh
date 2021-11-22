#!/usr/bin/env bash

# TODO: unfinished

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"

pushd "${ROOT_DIR}" 1> /dev/null || exit

source ".env"

sudo certbot run --register-unsafely-without-email --test-cert --webroot -i apache -w "/var/www/html" -d "${DOMAIN_NAME}"

popd 1> /dev/null || exit