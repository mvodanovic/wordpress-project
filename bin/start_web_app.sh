#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"
APACHE_TEMPLATE_FILE_WP="apache2-templates/wordpress-docker.conf"
APACHE_TEMPLATE_FILE_PMA="apache2-templates/phpmyadmin-docker.conf"
APACHE_DST_FILE_WP="build/apache2/wordpress-in-docker.000-default.conf"
APACHE_DST_FILE_PMA="build/apache2/phpmyadmin-in-docker.000-default.conf"

pushd "${ROOT_DIR}" 1> /dev/null || exit

source ".env"

sudo cp "${APACHE_TEMPLATE_FILE_WP}" "${APACHE_DST_FILE_WP}"
sudo sed -i "s#{DOMAIN_NAME}#${DOMAIN_NAME}#" "${APACHE_DST_FILE_WP}"

sudo cp "${APACHE_TEMPLATE_FILE_PMA}" "${APACHE_DST_FILE_PMA}"
sudo sed -i "s#{PHPMYADMIN_DOMAIN_NAME}#${PHPMYADMIN_DOMAIN_NAME}#" "${APACHE_DST_FILE_PMA}"

/usr/bin/docker-compose -p "${DOMAIN_NAME}" up --build -d --remove-orphans
sudo a2ensite "${DOMAIN_NAME}"
sudo systemctl reload apache2

popd 1> /dev/null || exit