## Initial setup & config

* Copy `.env.template` into `.env` and adjust values inside (see: Environment variables)
* Make `database/`, `plugins/`, `themes/`, `uploads/` and `logs/` have `0777` permissions (using chmod)
* Generate CA and client certificates - (run `bin/generate_ca_and_client_certs.sh`)
  * Needed to access WordPress Admin and PhpMyAdmin.
  * It's possible skip these steps and reuse existing certificates.
    In that case those certs have to be copied into `ssl/` with the same names that this script would generate.
* Prepare the host Apache server - (run `bin/deploy_to_host_apache.sh`)
  * If `PORT_HOST_HTTP` and `PORT_HOST_HTTPS` are not `80` and `443`, Apache might need to additionally be manually configured to listen on those ports.
  * This step will also generate self-signed HTTPS certificates if they don't exist yet.
* Configure the firewall - (run `bin/configure_ufw_firewall.sh`)
  * Make sure `FIREWALL_INCOMING_PORTS_ALLOWED` has all the needed values so that you don't lock yourself out of the server.
    The script won't delete any preexisting rules, but it will modify firewall defaults which may cause other services to be inaccessible if not added to the variable.
  * Without this step users could access the exposed Docker ports directly, bypassing the Apache proxy.
    Connecting directly to the MySQL database would also be possible.
* Deploy the systemd service - (run `bin/deploy_systemd_service.sh`)
  * This step will just prepare the service, but it won't start it yet.
* Start the systemd service - (run `sudo systemctl start {DOMAIN_NAME}`)
  * Running this step for the first time might take several minutes since some Docker images need to be pulled / built.
* TODO: Initialize Lets Encrypt certificates using CertBot - (run `bin/initialize_certbot_certificates.sh`)
  * CertBot needs to be installed for this step: https://certbot.eff.org/instructions?ws=apache&os=ubuntu-20
  * Optional, but strongly recommended for real production websites.
  * Not possible for local deployments (without a public domain and not running on ports `80` and `443`).
  * Self-signed certificates from the previous step will be overwritten (i.e. deleted).
  * The website has to be up & running for CertBot to be able to create certificates.


## Environment variables

This section describes all supported variables in the `.env` file.

* `DOMAIN_NAME` - Domain name for the WordPress website.
* `PHPMYADMIN_DOMAIN_NAME` - Domain name for the PhpMyAdmin application.
* `CA_NAME` - Name of the CA, used only to name the certificate file, not used in the actual certificate itself.
* `CA_PASSPHRASE` - Passphrase for the CA, cannot be left blank.
* `CA_ORG_NAME` - Organization name of the CA, part of the certificate metadata.
* `CA_COMMON_NAME` - Common name of the CA, part of the certificate metadata.
* `CLIENT_CERT_COMMON_NAME` - Common name of the client certificate, part of the certificate metadata.
* `CLIENT_CERT_PASSPHRASE` - Passphrase for the client certificate, can be left blank.
* `MYSQL_ROOT_PASSWORD` - Root password for the MySQL database.
* `MYSQL_DATABASE` - MySQL database name for the WordPress website.
* `MYSQL_USER` - MySQL username for the WordPress website.
* `MYSQL_PASSWORD` - MySQL password for the WordPress website.
* `PORT_DOCKER_MYSQL` - Port through which the MySQL database will be exposed to the host machine. Used only for debugging.
* `PORT_DOCKER_WordPress` - HTTPS port through which the WordPress website will be exposed to the host machine. Not used directly by users, Apache proxy passes to this port.
* `PORT_DOCKER_PHPMYADMIN` - HTTP port through which the PhpMyAdmin application will be exposed to the host machine. Not used directly by users, Apache proxy passes to this port.
* `PORT_HOST_HTTPS` - HTTPS port Apache listens on, on the host machine.
* `PORT_HOST_HTTP` - HTTP port Apache listens on, on the host machine.
* `FIREWALL_INCOMING_PORTS_ALLOWED` - When configuring the system firewall, which additional incoming ports to allow; list of items separated by space. `PORT_HOST_HTTP` and `PORT_HOST_HTTPS` are always allowed.


## Start & stop

```
sudo systemctl start {DOMAIN_NAME}
sudo systemctl stop {DOMAIN_NAME}
```


## Configure client auth in browsers for CMS / admin & phpmyadmin

* Install `.pfx` (pkcs12) file as a certificate in browser
* Firefox only: in about:config - `security.tls.enable_post_handshake_auth -> true`
* Currently doesn't work at all with Chrome-based browsers.


## Certificate renewal using Lets Encrypt

* Renewals cen simply be done by running `certbot renew` with the certificates generated with webroot renewal.
* Script `bin/certbot_post_hook.sh` should be run after each successful renewal.
* Running this script can be automated by setting it in `/etc/letsencrypt/renewal/XXX.conf`:
  `renew_hook = /path/to/bin/certbot_post_hook.sh`


## Backup

* Run ``bin/backup.sh` to back up both the DB and all files which aren't WordPress itself
* Directories which are backed up: plugins, themes, uploads


## WordPress update

* First, back up the data (see: Backup)
* Then, modify the Dockerfile with the new WordPress Docker image version
* Finally, restart the service, and log into the web admin
