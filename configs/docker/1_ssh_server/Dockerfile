# start from the official debian image
FROM debian:latest AS ssh_server_image

# install openssh-server
RUN apt-get update && apt-get install openssh-server -y
# this directory is needed for openssh-server to work
RUN mkdir /var/run/sshd

# add a user
RUN useradd --create-home --base-dir /home --shell /bin/bash arthur
RUN echo "arthur:arthur" | chpasswd

# expose SSH port
EXPOSE 22/tcp

# launch the server
CMD ["/usr/sbin/sshd", "-D"]
