#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

TS="$(date +%Y-%m-%dT%H-%M-%S)"

ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"
BACKUPS_DIR="backups"

BACKUP_DB="${BACKUPS_DIR}/bkp-${TS}.sql"
BACKUP_DB_LOG="${BACKUP_DB}.log"

BACKUP_SOURCE_DIRS="plugins themes uploads"
BACKUP_FILES="${BACKUPS_DIR}/bkp-${TS}.tar.gz"

pushd "${ROOT_DIR}" 1> /dev/null || exit

source ".env"

echo "Backup timestamp: ${TS}"

mysqldump --column-statistics=0 -h 127.0.0.1 -P "${HOST_PORT_MYSQL}" -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" > "${BACKUP_DB}" 2> "${BACKUP_DB_LOG}"
gzip "${BACKUP_DB}"

# shellcheck disable=SC2086
tar -czf "${BACKUP_FILES}" ${BACKUP_SOURCE_DIRS}

popd 1> /dev/null || exit
