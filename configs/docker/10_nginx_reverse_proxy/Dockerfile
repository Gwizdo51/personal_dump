# NGINX web server image
FROM nginx:1.29 AS nginx_image
# redirect default and error channels to the appropriate log files
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
# set the working directory
# WORKDIR /var/www
