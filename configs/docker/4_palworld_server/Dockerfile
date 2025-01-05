# container used to initialise the server config
# start from the official python image
FROM python:3.12 AS init_server_image
# install python dependencies
RUN pip install pyyaml
# work in /tmp
WORKDIR /tmp
# copy the necessary files
COPY ./gen_palworld_settings.py ./
# specify that a volume is mounted at the directory "./data"
VOLUME /tmp/data
# to run the container solo for debug: docker compose run --rm -i init_server_container
# CMD ["bash"]
# run the python script
CMD ["python", "gen_palworld_settings.py"]

# container used for the server itself
# start from the official PocketPair palserver image
# https://github.com/pocketpairjp/palworld-dedicated-server-docker/pkgs/container/palserver
FROM ghcr.io/pocketpairjp/palserver:latest AS palworld_server_image
# copy the helper.sh to the /pal directory
COPY ./helper.sh /pal/helper.sh
# RUN chown -R user:usergroup /pal/Package/Pal
# RUN chmod a+x /pal/Package/PalServer.sh
# specify that a volume is mounted at the directory "/pal/Package/Pal/Saved"
VOLUME /pal/Package/Pal/Saved
# expose the configured port over UDP
EXPOSE 8211/udp
# launch the server
# ENTRYPOINT is necessary, because it is present in the original Dockerfile
# https://tech.palworldgame.com/settings-and-operation/arguments
ENTRYPOINT ["/pal/helper.sh"]
CMD ["-port=8211", "-useperfthreads", "-NoAsyncLoadingThread", "-UseMultithreadForDS"]
# ENTRYPOINT ["bash"]
# ENTRYPOINT ["/pal/Package/PalServer.sh"]
# CMD ["-port=8211", "-useperfthreads", "-NoAsyncLoadingThread", "-UseMultithreadForDS"]
