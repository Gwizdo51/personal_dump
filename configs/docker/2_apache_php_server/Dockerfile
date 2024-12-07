# start from the official php apache image
FROM php:8.3-apache AS apache_server_img
# set php engine in development mode
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
# expose SSH port
EXPOSE 80
