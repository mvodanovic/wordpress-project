#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"

UFW_AFTER_RULES_FILE="/etc/ufw/after.rules"
read -r -d '' UFW_AFTER_RULES << EOM

# BEGIN UFW AND DOCKER
*filter
:ufw-user-forward - [0:0]
:ufw-docker-logging-deny - [0:0]
:DOCKER-USER - [0:0]
-A DOCKER-USER -j ufw-user-forward

-A DOCKER-USER -j RETURN -s 10.0.0.0/8
-A DOCKER-USER -j RETURN -s 172.16.0.0/12
-A DOCKER-USER -j RETURN -s 192.168.0.0/16

-A DOCKER-USER -p udp -m udp --sport 53 --dport 1024:65535 -j RETURN

-A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 10.0.0.0/8
-A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 172.16.0.0/12
-A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 192.168.0.0/16
-A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 10.0.0.0/8
-A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 172.16.0.0/12
-A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 192.168.0.0/16

-A DOCKER-USER -j RETURN

-A ufw-docker-logging-deny -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "[UFW DOCKER BLOCK] "
-A ufw-docker-logging-deny -j DROP

COMMIT
# END UFW AND DOCKER
EOM

pushd "${ROOT_DIR}" 1> /dev/null || exit

source ".env"

if ! sudo grep -q "# BEGIN UFW AND DOCKER" "${UFW_AFTER_RULES_FILE}"; then
  echo "${UFW_AFTER_RULES}" | sudo tee -a "${UFW_AFTER_RULES_FILE}"
  sudo ufw reload
fi

sudo ufw allow "${PORT_HOST_HTTP}"
sudo ufw allow "${PORT_HOST_HTTPS}"
for port in ${FIREWALL_INCOMING_PORTS_ALLOWED}; do
    sudo ufw allow "${port}"
done
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

popd 1> /dev/null || exit