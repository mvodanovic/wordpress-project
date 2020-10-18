#/usr/bin/env bash

SCRIPT_DIR="$(realpath $(dirname "${BASH_SOURCE[0]}"))"

SRC_DIR="/etc/letsencrypt/live/frozen-spring.com"
DST_DIR="$(realpath ${SCRIPT_DIR}/../ssl)"

sudo rm -f "${DST_DIR}/www_frozen-spring_com.web.crt"
sudo cp "$(realpath ${SRC_DIR}/fullchain.pem)" "${DST_DIR}/www_frozen-spring_com.web.crt"
sudo chown marko:marko "${DST_DIR}/www_frozen-spring_com.web.crt"

sudo rm -f "${DST_DIR}/www_frozen-spring_com.key"
sudo cp "$(realpath ${SRC_DIR}/privkey.pem)" "${DST_DIR}/www_frozen-spring_com.key"
sudo chown marko:marko "${DST_DIR}/www_frozen-spring_com.key"
