#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"
CERTS_DIR="ssl"
APACHE_TEMPLATE_FILE="apache2-templates/host.conf"

pushd "${ROOT_DIR}" 1> /dev/null || exit

source ".env"

APACHE_DST_FILE="/etc/apache2/sites-available/${DOMAIN_NAME}.conf"

sudo cp "${APACHE_TEMPLATE_FILE}" "${APACHE_DST_FILE}"
sudo sed -i "s#{DOMAIN_NAME}#${DOMAIN_NAME}#" "${APACHE_DST_FILE}"
sudo sed -i "s#{PORT_HOST_HTTP}#${PORT_HOST_HTTP}#" "${APACHE_DST_FILE}"
sudo sed -i "s#{PORT_HOST_HTTPS}#${PORT_HOST_HTTPS}#" "${APACHE_DST_FILE}"
sudo sed -i "s#{PORT_DOCKER_WORDPRESS}#${PORT_DOCKER_WORDPRESS}#" "${APACHE_DST_FILE}"
sudo sed -i "s#{ROOT_DIR}#${ROOT_DIR}#" "${APACHE_DST_FILE}"
sudo sed -i "s#{CA_COMMON_NAME}#${CA_COMMON_NAME}#" "${APACHE_DST_FILE}"
sudo sed -i "s#{PHPMYADMIN_DOMAIN_NAME}#${PHPMYADMIN_DOMAIN_NAME}#" "${APACHE_DST_FILE}"
sudo sed -i "s#{PORT_DOCKER_PHPMYADMIN}#${PORT_DOCKER_PHPMYADMIN}#" "${APACHE_DST_FILE}"

if [ ! -f "${CERTS_DIR}/${DOMAIN_NAME}.web.crt" ]; then
  openssl genrsa -out "${CERTS_DIR}/${DOMAIN_NAME}.web.key" 3072
  openssl req -new -out "${CERTS_DIR}/${DOMAIN_NAME}.web.csr" -sha256\
    -subj "/CN=${DOMAIN_NAME}"\
    -addext "subjectAltName = DNS:${DOMAIN_NAME}, DNS:www.${DOMAIN_NAME}"\
    -key "${CERTS_DIR}/${DOMAIN_NAME}.web.key"
  openssl x509 -req -in "${CERTS_DIR}/${DOMAIN_NAME}.web.csr" -days 3650\
    -signkey "${CERTS_DIR}/${DOMAIN_NAME}.web.key"\
    -out "${CERTS_DIR}/${DOMAIN_NAME}.web.crt" -outform PEM
  rm "${CERTS_DIR}/${DOMAIN_NAME}.web.csr"
fi

if [ ! -f "${CERTS_DIR}/${PHPMYADMIN_DOMAIN_NAME}.web.crt" ]; then
  openssl genrsa -out "${CERTS_DIR}/${PHPMYADMIN_DOMAIN_NAME}.web.key" 3072
  openssl req -new -out "${CERTS_DIR}/${PHPMYADMIN_DOMAIN_NAME}.web.csr" -sha256\
    -subj "/CN=${PHPMYADMIN_DOMAIN_NAME}" -key "${CERTS_DIR}/${PHPMYADMIN_DOMAIN_NAME}.web.key"
  openssl x509 -req -in "${CERTS_DIR}/${PHPMYADMIN_DOMAIN_NAME}.web.csr" -days 3650\
    -signkey "${CERTS_DIR}/${PHPMYADMIN_DOMAIN_NAME}.web.key"\
    -out "${CERTS_DIR}/${PHPMYADMIN_DOMAIN_NAME}.web.crt" -outform PEM
  rm "${CERTS_DIR}/${PHPMYADMIN_DOMAIN_NAME}.web.csr"
fi

sudo a2enmod proxy ssl proxy_http headers
sudo systemctl restart apache2

popd 1> /dev/null || exit