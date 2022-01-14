FROM wordpress:5.8.3-php8.0-apache

RUN a2enmod ssl proxy proxy_http headers && \
    service apache2 restart
