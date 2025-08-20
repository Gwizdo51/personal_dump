# start from the official debian image
# FROM debian:latest AS ssh_server_image
FROM debian:bookworm-20241202 AS ssh_server_image
# install openssh-server and git
RUN apt-get update
RUN apt-get install openssh-server -y
RUN apt-get install git -y
# this directory is needed for openssh-server to work
RUN mkdir /var/run/sshd
# add a user
RUN useradd --create-home --base-dir /home --shell /bin/bash arthur
RUN echo "arthur:arthur" | chpasswd
# clone this repo in arthur's home
USER arthur
WORKDIR /home/arthur
RUN git clone https://github.com/Gwizdo51/personal_dump.git
# go to appropriate branch
# WORKDIR /home/arthur/personal_dump
# RUN git switch docker_notes
# WORKDIR /home/arthur
# create symbolic links for .bashrc and .bash_aliases
RUN rm .bashrc
RUN ln -s personal_dump/code/bash/.bashrc ./
RUN ln -s personal_dump/code/bash/.bash_aliases ./
# reset the user and workdir
USER root
WORKDIR /
# allow root to pull new commits of personal_dump
RUN git config --global --add safe.directory /home/arthur/personal_dump
# expose SSH port
EXPOSE 22/tcp
# launch the server
CMD ["/usr/sbin/sshd", "-D"]
