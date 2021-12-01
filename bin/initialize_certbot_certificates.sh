#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"
CERTBOT_CERTS_DIR="/etc/letsencrypt/renewal"
CERTBOT_RENEWAL_HOOK="${ROOT_DIR}/bin/certbot_post_hook.sh"

pushd "${ROOT_DIR}" 1> /dev/null || exit

source ".env"

sudo certbot certonly --register-unsafely-without-email --webroot -w "/var/www/letsencrypt" -d "${DOMAIN_NAME}" -d "www.${DOMAIN_NAME}"
sudo sed -i "/^renew_hook =/d" "${CERTBOT_CERTS_DIR}/${DOMAIN_NAME}.conf"
sudo sed -i "/^fullchain = .*/a renew_hook = ${CERTBOT_RENEWAL_HOOK}" "${CERTBOT_CERTS_DIR}/${DOMAIN_NAME}.conf"

sudo certbot certonly --register-unsafely-without-email --webroot -w "/var/www/letsencrypt" -d "${PHPMYADMIN_DOMAIN_NAME}"
sudo sed -i "/^renew_hook =/d" "${CERTBOT_CERTS_DIR}/${PHPMYADMIN_DOMAIN_NAME}.conf"
sudo sed -i "/^fullchain = .*/a renew_hook = ${CERTBOT_RENEWAL_HOOK}" "${CERTBOT_CERTS_DIR}/${PHPMYADMIN_DOMAIN_NAME}.conf"

"${CERTBOT_RENEWAL_HOOK}"

popd 1> /dev/null || exit