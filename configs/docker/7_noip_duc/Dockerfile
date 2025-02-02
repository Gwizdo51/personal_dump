# source: https://www.noip.com/support/knowledgebase/install-linux-3-x-dynamic-update-client-duc
FROM debian:latest AS noip_duc_image
RUN apt update
RUN apt-get install wget -y
WORKDIR /tmp
RUN wget --content-disposition https://www.noip.com/download/linux/latest
RUN tar xf noip-duc_3.3.0.tar.gz
WORKDIR /tmp/noip-duc_3.3.0/binaries
RUN apt install ./noip-duc_3.3.0_amd64.deb
WORKDIR /tmp
RUN rm -r noip-duc_3.3.0
