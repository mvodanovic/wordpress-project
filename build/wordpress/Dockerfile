FROM wordpress:5.8.1-php7.3-apache

RUN a2enmod ssl proxy proxy_http headers && \
    service apache2 restart
