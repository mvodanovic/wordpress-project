#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

sudo systemctl reload apache2
"${SCRIPT_DIR}/sync_certs.sh)"
sudo systemctl restart frozen-spring

