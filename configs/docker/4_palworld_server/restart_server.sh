#!/bin/sh

compose_file_path="/srv/personal_dump/configs/docker/4_palworld_server/compose.yml"

# stop the server
docker compose -f ${compose_file_path} down

# rebuild the images (pull a new version when available)
docker compose -f ${compose_file_path} build

# clean docker cache
docker system prune -f

# restart the server with the new image
docker compose -f ${compose_file_path} up -d
