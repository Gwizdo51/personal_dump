# start from the official php apache image
FROM php:8.3-apache AS wakeonlan_server_img
# set php engine in development mode
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
# copy the new website conf
COPY ./wakeonlan.conf /etc/apache2/sites-available/
# disable / enable the virtual hosts
RUN a2dissite 000-default
RUN a2ensite wakeonlan
# Apache should listen on the 8080 port
RUN rm /etc/apache2/ports.conf
COPY ./ports.conf /etc/apache2/
# activate the rewrite mod
RUN a2enmod rewrite
# RUN service apache2 restart
# install wakeonlan
RUN apt-get update
RUN apt-get install wakeonlan -y
# expose ports
# 8080/TCP for Apache
EXPOSE 8080
# 9/UDP for wakeonlan
EXPOSE 9/udp
