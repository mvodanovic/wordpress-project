#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"

read -r -p 'Please confirm action by writing "purge": ' PURGE_CONFIRM
if [ "$PURGE_CONFIRM" != "purge" ]; then
  echo "Aborting..."
  exit 1
fi


pushd "${ROOT_DIR}" 1> /dev/null || exit

sudo rm -rf database/* logs/* themes/* uploads/*
sudo find plugins -type f -not -name .gitkeep -and -not -name '*.wp_container_inject.php' -delete

popd 1> /dev/null || exit
