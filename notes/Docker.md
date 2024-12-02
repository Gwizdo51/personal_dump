# [Install on Windows](https://docs.docker.com/desktop/setup/install/windows-install/)

1. [Install WSL](https://learn.microsoft.com/en-us/windows/wsl/install): `wsl --install`
2. Install Docker Desktop

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
| list all containers | `docker ps -a` |
| list all running containers | `docker ps` |
| stop a running container | `docker stop <container_name\|container_ID>` |
| start a stopped container | `docker start <container_name\|container_ID>` |
| start an interactive bash shell running in a container | `docker exec -it <container> bash` |
| search an image | `docker search <image_name>` |
| download an image | `docker pull <image_name>` |
| list all downloaded images | `docker images` |
| build an image from a `Dockerfile`, with a specified name | `docker build <dir_with_dockerfile> -t <username>/<image_name>` |
| -> same with a specified `Dockerfile` path (gives access to parent folders) | `docker build -t <some_tag> -f <path/to/Dockerfile> .` |
| give an name to an image | `docker tag <username>/<image_name> <username>/<image_name>:<tag_name>` |
| publish an image to a registry | `docker push <username>/<image_name>:<tag_name>` |
| run a `compose.yml` file | `docker compose up -d --build` |
| stop a application running with `compose` | `docker compose down` |
| create a new image after manual modifications of a container | `docker container commit -m "message" <base_container> <new_image>` |
| view the layers of an image | `docker image history <image>` |
| remove a container | `docker rm [-f] <container_name>` |
| create a volume | `docker volume create <volume>` |
| list all volumes | `docker volume ls` |
| remove a volume (only when not attached) | `docker volume rm <volume>` |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |

# Dockerfile

A `Dockerfile` is a file that specifies an image, i.e. how a container is built, and what it does. Each line of the Dockerfile creates a new layer to the image.

```Dockerfile
# specify the base image that this Dockerfile extends
FROM <image_name>
# set the working directory, where files are copied and commands are executed
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
# expose a port to the host
EXPOSE <port-number>
```
