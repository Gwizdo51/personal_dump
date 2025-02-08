# start from the official php apache image
FROM php:8.3-apache AS wakeonlan_server_img
# set php engine in development mode
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
# activate the rewrite mod
RUN a2enmod rewrite
# install wakeonlan
RUN apt-get update
RUN apt-get install wakeonlan -y
# expose SSH port
EXPOSE 80
EXPOSE 9/udp
