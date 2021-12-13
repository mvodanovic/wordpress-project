#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"
CERTS_DIR="ssl"

pushd "${ROOT_DIR}" 1> /dev/null || exit

source ".env"

pushd "${CERTS_DIR}" 1> /dev/null || exit

if [ ! -f "${CA_COMMON_NAME}.ca.crt" ]; then
  openssl req -newkey rsa:4096 --passout pass:"${CA_PASSPHRASE}" -keyform PEM -keyout "${CA_COMMON_NAME}.ca.key" \
    -subj "/O=${CA_ORG_NAME}/CN=${CA_COMMON_NAME}" -new -x509 -days 3650 -outform PEM -out "${CA_COMMON_NAME}.ca.crt"
fi

if [ ! -f "${DOMAIN_NAME}.client.p12" ]; then
  openssl genrsa -out "${DOMAIN_NAME}.client.key" 4096
  openssl req -subj "/O=${CLIENT_CERT_ORG_NAME}/CN=${DOMAIN_NAME}" -new -key "${DOMAIN_NAME}.client.key"\
    -out "${DOMAIN_NAME}.client.req"
  openssl x509 -req -in "${DOMAIN_NAME}.client.req" --passin pass:"${CA_PASSPHRASE}" -CA "${CA_COMMON_NAME}.ca.crt"\
    -CAkey "${CA_COMMON_NAME}.ca.key" -set_serial 101 -extensions client -days 3650 -outform PEM\
    -out "${DOMAIN_NAME}.client.crt"
  openssl pkcs12 -export -passout "pass:${CLIENT_CERT_PASSPHRASE}" -inkey "${DOMAIN_NAME}.client.key"\
    -in "${DOMAIN_NAME}.client.crt" -out "${DOMAIN_NAME}.client.p12"
  rm "${DOMAIN_NAME}.client.key" "${DOMAIN_NAME}.client.crt" "${DOMAIN_NAME}.client.req"
fi

popd 1> /dev/null || exit
popd 1> /dev/null || exit