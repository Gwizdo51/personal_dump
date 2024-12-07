# start from the official mysql image
FROM mysql:9.1 AS mysql_image

# expose the standard mysql port
EXPOSE 3306

# set a password for the mysql root user
ENV MYSQL_ROOT_PASSWORD 123456789

# add a health check to only start phpmyadmin when the database is ready
HEALTHCHECK --interval=5s --retries=24 --start-period=60s --timeout=5s \
    CMD ["mysqladmin", "ping"]
