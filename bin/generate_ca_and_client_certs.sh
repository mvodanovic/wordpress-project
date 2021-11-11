#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"
CERTS_DIR="ssl"

pushd "${ROOT_DIR}" 1> /dev/null || exit

source ".env"

pushd "${CERTS_DIR}" 1> /dev/null || exit

openssl req -newkey rsa:4096 --passout pass:"${CA_PASSPHRASE}" -keyform PEM -keyout "${CA_NAME}.ca.key" \
  -subj "/O=${CA_ORG_NAME}/CN=${CA_COMMON_NAME}" -new -x509 -days 3650 -outform PEM -out "${CA_NAME}.ca.cer"

openssl genrsa -out "${DOMAIN_NAME}.client.key" 4096
openssl req -subj "/O=${DOMAIN_NAME}/CN=${CLIENT_CERT_COMMON_NAME}" -new -key "${DOMAIN_NAME}.client.key"\
  -out "${DOMAIN_NAME}.client.req"
openssl x509 -req -in "${DOMAIN_NAME}.client.req" --passin pass:"${CA_PASSPHRASE}" -CA "${CA_NAME}.ca.cer"\
  -CAkey "${CA_NAME}.ca.key" -set_serial 101 -extensions client -days 3650 -outform PEM\
  -out "${DOMAIN_NAME}.client.cer"
openssl pkcs12 -export -passout "pass:${CLIENT_CERT_PASSWORD}" -inkey "${DOMAIN_NAME}.client.key"\
  -in "${DOMAIN_NAME}.client.cer" -out "${DOMAIN_NAME}.client.p12"
rm "${DOMAIN_NAME}.client.key" "${DOMAIN_NAME}.client.cer" "${DOMAIN_NAME}.client.req"

popd 1> /dev/null || exit
popd 1> /dev/null || exit