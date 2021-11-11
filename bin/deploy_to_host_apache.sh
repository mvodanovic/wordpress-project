#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"
APACHE_TEMPLATE_FILE="apache2/host-template.conf"

pushd "${ROOT_DIR}" 1> /dev/null || exit

source ".env"

APACHE_DST_FILE="/etc/apache2/sites-available/${DOMAIN_NAME}.conf"

sudo cp "${APACHE_TEMPLATE_FILE}" "${APACHE_DST_FILE}"
sudo sed -i "s#{DOMAIN_NAME}#${DOMAIN_NAME}#" "${APACHE_DST_FILE}"
sudo sed -i "s#{HOST_PORT_WORDPRESS}#${HOST_PORT_WORDPRESS}#" "${APACHE_DST_FILE}"
sudo sed -i "s#{ROOT_DIR}#${ROOT_DIR}#" "${APACHE_DST_FILE}"
sudo sed -i "s#{CA_NAME}#${CA_NAME}#" "${APACHE_DST_FILE}"
sudo sed -i "s#{PHPMYADMIN_DOMAIN_NAME}#${PHPMYADMIN_DOMAIN_NAME}#" "${APACHE_DST_FILE}"
sudo sed -i "s#{HOST_PORT_PHPMYADMIN}#${HOST_PORT_PHPMYADMIN}#" "${APACHE_DST_FILE}"

popd 1> /dev/null || exit