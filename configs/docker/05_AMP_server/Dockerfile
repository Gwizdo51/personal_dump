# start from the official php apache image
FROM php:8.3-apache AS apache_server_img
# set php engine in development mode
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
# add mysqli extension
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
# activate the rewrite mod
RUN a2enmod rewrite
# give all directories and files in /var/www/html to www-data -> www-data IS root, actually
# allow reading and executing (but disallow writing) of everything in /var/www/html for everyone
# -> cannot disallow writing -> i can't edit my own files anymore
# allow reading and executing for everything in /var/www/html for everyone
# RUN chmod -R 777 /var/www/html/* -> doesn't work: nothing is mounted yet
# mount a volume at /var/www/html
VOLUME /var/www/html
# expose SSH port
EXPOSE 80
