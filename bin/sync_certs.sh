#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

SRC_DIR1="/etc/letsencrypt/live/frozen-spring.com"
SRC_DIR2="/etc/letsencrypt/live/phpmyadmin.frozen-spring.vodanovic.net"
DST_DIR="$(realpath "${SCRIPT_DIR}/../ssl")"

sudo rm -f "${DST_DIR}/www_frozen-spring_com.web.crt"
sudo cp "$(realpath "${SRC_DIR1}/fullchain.pem")" "${DST_DIR}/www_frozen-spring_com.web.crt"
sudo chown marko:marko "${DST_DIR}/www_frozen-spring_com.web.crt"

sudo rm -f "${DST_DIR}/www_frozen-spring_com.key"
sudo cp "$(realpath "${SRC_DIR1}/privkey.pem")" "${DST_DIR}/www_frozen-spring_com.key"
sudo chown marko:marko "${DST_DIR}/www_frozen-spring_com.key"

sudo rm -f "${DST_DIR}/phpmyadmin_frozen-spring_vodanovic_net.web.crt"
sudo cp "$(realpath "${SRC_DIR2}/fullchain.pem")" "${DST_DIR}/phpmyadmin_frozen-spring_vodanovic_net.web.crt"
sudo chown marko:marko "${DST_DIR}/phpmyadmin_frozen-spring_vodanovic_net.web.crt"

sudo rm -f "${DST_DIR}/phpmyadmin_frozen-spring_vodanovic_net.key"
sudo cp "$(realpath "${SRC_DIR2}/privkey.pem")" "${DST_DIR}/phpmyadmin_frozen-spring_vodanovic_net.key"
sudo chown marko:marko "${DST_DIR}/phpmyadmin_frozen-spring_vodanovic_net.key"

