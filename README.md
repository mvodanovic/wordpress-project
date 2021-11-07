## Initial setup & config

* Copy `.env.template` into `.env` and adjust values inside
* Make `database/`, `plugins/`, `themes/`, `uploads/` and `logs/` have `0777` permissions (using chmod)
* Copy required certificates into `ssl/` - (run `bin/sync_certs.sh`)


## Quick / local start & stop

```
docker-compose up --build -d
docker-compose down --rmi local
```


## Run as a service

* Copy things from `systemd/` into `/etc/systemd/system/`
* Adjust paths in `frozen-spring.service`
* Run `sudo systemctl --now enable frozen-spring.service; sudo systemctl enable docker-cleanup.timer`


## Run behind Apache 2 proxy

* Install Apache 2: `sudo apt install apache2`
* `sudo a2enmod ssl proxy proxy_http headers; sudo systemctl restart apache2.service`
* Copy `apache2/frozen-spring.conf` into `/etc/apache2/sites-available/`
* Adjust paths inside
* Run `sudo a2ensite frozen-spring; sudo systemctl reload apache2.service`


## Configure client auth in browsers for CMS / admin & phpmyadmin

* Install `.pfx` (pkcs12) file as a certificate in browser
* Firefox only: in about:config - `security.tls.enable_post_handshake_auth -> true`


## Configure firewall - using ufw (TODO)

* Configure docker in `/etc/default/docker`: `DOCKER_OPTS="--iptables=false"`
* Restart docker service

```
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```


## Certificate renewal using Let's Encrypt

* Renewals cen simply be done by running `certbot renew` with the certificates generated with webroot renewal.
* Script `bin/certbot_post_hook.sh` should be run after each successful renewal.
* Running this script can be automated by setting it in `/etc/letsencrypt/renewal/XXX.conf`:
  `renew_hook = /path/to/bin/certbot_post_hook.sh`


## Backup

* Run ``bin/backup.sh` to back up both the DB and all files which aren't Wordpress istelf
* Directories which are backed up: plugins, themes, uploads
