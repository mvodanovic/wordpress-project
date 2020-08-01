FROM wordpress:5.4.2-php7.2-apache

RUN a2enmod ssl proxy proxy_http headers && \
    service apache2 restart
