# [Install on Windows](https://docs.docker.com/desktop/setup/install/windows-install/)

1. [Install WSL](https://learn.microsoft.com/en-us/windows/wsl/install): `wsl --install`
1. Install Docker Desktop

# [Install Docker engine on Debian](https://docs.docker.com/engine/install/debian/)

cf. `/code/bash/docker_install_script.sh`

## [Rootless mode](https://docs.docker.com/engine/security/rootless/)

1. Install `uidmap`
1. Setup rootless mode in parallel of rootful : (https://stackoverflow.com/a/78225787/16509326) `dockerd-rootless-setuptool.sh install --force`
1. Allow unprivileged apps to expose privileged ports :
    - add 'net.ipv4.ip_unprivileged_port_start=0' to /etc/sysctl.conf
    - run `sudo sysctl --system`

Switch modes with :
- `docker context use default` -> rootful
- `docker context use rootless` -> rootless

See current active mode with `docker context ls`

# Concepts

### Container

A piece of software that behaves like a virtual machine, but only for the purpose it was made for -> an independent OS that does one thing.

The container contains everything it needs to run its application.

### Image

A standardised package that includes all of the files, binaries, libraries, and configurations to run a container.

### Registry

A server used for storing and sharing images (ex: https://hub.docker.com/).

### Repository

A folder of images inside a registry.

# CLI commands

| Action | Command |
|--:|:--|
| create and run a container from an image | `docker run <image_name>` |
| -> same with port forwarding | `docker run -p <host_port>:<container_port> <image_name>` |
| -> publish all exposed ports on random host ports | `docker run -P <image_name>` |
| -> same with interactive shell | `docker run -it <image_name>` |
| -> name the container | `docker run --name <container_name> -it <image_name>` |
| -> delete the container when it exits | `docker run --rm -it <image_name>` |
| -> with a volume mounted | `docker run -v <volume>:<mount_point> <image_name>` |
| -> with a host directory mounted as a volume (modifications are mirrored) | `docker run -v <host_dir_path>:<mount_point> <image_name>` |
| list all containers | `docker ps -a` |
| list all running containers | `docker ps` |
| stop a running container | `docker stop <container_name\|container_ID>` |
| start a stopped container | `docker start <container_name\|container_ID>` |
| start an interactive bash shell running in a container | `docker exec -it <container> bash` |
| search an image | `docker search <image_name>` |
| download an image | `docker pull <image_name>` |
| list all downloaded images | `docker images` |
| build an image from a `Dockerfile`, with a specified name | `docker build <dir_with_dockerfile> -t <username>/<image_name>` |
| -> same with a specified `Dockerfile` path (gives access to parent folders) | `docker build <dir_with_dockerfile> -t <some_tag> -f <path/to/Dockerfile> .` |
| -> same with a specified target within the `Dockerfile` | `docker build <dir_with_dockerfile> --target <target_name> -t <some_tag>` |
| give an name to an image | `docker tag <username>/<image_name> <username>/<image_name>:<tag_name>` |
| publish an image to a registry | `docker push <username>/<image_name>:<tag_name>` |
| build an app from a `compose.yml` file | `docker compose build` |
| -> run an application from a `compose.yml` file | `docker compose up -d` |
| -> stop and remove the containers | `docker compose down` |
| -> stop a application running with `compose` | `docker compose stop` |
| -> start after being stopped | `docker compose start` |
| -> restart an application | `docker compose restart` |
| -> run a one-off command inside a running service | `docker compose exec <service> <command>` |
| -> run a container from a compose file on its own | `docker compose run --rm <service>` |
| create a new image after manual modifications of a container | `docker container commit -m "message" <base_container> <new_image>` |
| view the layers of an image | `docker image history <image>` |
| remove a container | `docker rm [-f] <container_name>` |
| create a volume | `docker volume create <volume>` |
| list all volumes | `docker volume ls` |
| remove a volume (only when not attached) | `docker volume rm <volume>` |
| remove useless stuff (dangling images, stopped containers, unused build cache) | `docker system prune` |
| copy a file from a container to the host | `docker cp <container_id>:/file/path/within/container /host/path/target` |

# `Dockerfile`

A `Dockerfile` is a file that specifies an image, i.e. how a container is built, and what it does. Each line of the Dockerfile creates a new layer to the image.

```Dockerfile
# specify the base image that this Dockerfile extends
FROM <image_name>
# set the working directory (commands are executed here and file paths are relative to here)
WORKDIR <path>
# copy files from the host to the image
COPY <host_path> <image_path>
# run the specified command
RUN <command>
# sets the default user for all subsequent instructions
USER <user_or_uid>
# define a variable
ARG <variable>=<value>
# add an environment variable
ENV <name> <value>
# expose ports to the host
# the protocol defaults to "tcp"
# only serves as documentation, ports still have to be manually exposed on container creation
EXPOSE <port-number>/<protocol>
# define an entrypoint for the image: the container will implicitely run this executable on startup
# (can be overridden in a compose.yml) (overrides ENTRYPOINT from base image)
ENTRYPOINT ["cmd"]
# if ENTRYPOINT, list of arguments to the command in ENTRYPOINT
# if no ENTRYPOINT, command to run on container startup
# (always last instruction, preferably) (overrides CMD from the base image)
CMD ["cmd", "arg1", ...]
```

# `compose.yml`

A single configuration file for everything an application needs:
- the volumes used and where they are mounted
- the different services, how they are built and run
- the ports they commuicate with

```yaml
# specify the persistent volumes used by the application
volumes:
    html_dir_compose: {}

# specify the different containers
services:

    ssh_server:
        # spawn from a Dockerfile
        build:
            context: "./"
            target: "ssh_server" # specified in the Dockerfile with the "AS <target>" instruction
        # mount the persistent volume
        volumes:
        - "html_dir_compose:/mnt"
        # equivalent to the "CMD" instruction of the Dockerfile
        command: "bash -c '/usr/sbin/sshd -D'"
        # expose the ports the container communicates with (<host>:<container>)
        # here, only ssh
        ports:
        - "22:22"

    apache_server:
        # spawn from a vanilla image
        image: "php:8.3-apache"
        # mount (and mirror) a directory from the host
        volumes:
        - "./8_axocamp_MVC:/var/www/html"
        # since the "command" instruction overrides the original CMD from the image, we have to add it at the end of ours
        # to get the original CMD of the image, look at the last layer (here, "apache2-foreground")
        # https://hub.docker.com/layers/library/php/8.3-apache/images/sha256-9e8338661e2abfc1aa17ca678580ddab53b93ea3cf6ef718d502338639f5264b
        command: "bash -c 'mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini && apache2-foreground'"
        # expose HTTP port
        ports:
        - "80:80"
```

# compose.yml "command" vs RUN vs CMD vs ENTRYPOINT

- https://stackoverflow.com/questions/72284462/cmd-in-dockerfile-vs-command-in-docker-compose-yml
- https://www.docker.com/blog/docker-best-practices-choosing-between-run-cmd-and-entrypoint/
