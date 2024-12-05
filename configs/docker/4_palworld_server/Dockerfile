# start from the official PocketPair palserver image
FROM ghcr.io/pocketpairjp/palserver:latest AS palworld_server_image

# copy the helper.sh to the /pal directory
COPY ./helper.sh /pal/helper.sh

# expose the configured port over UDP
EXPOSE 8211/udp

# launch the server
ENTRYPOINT ["/pal/helper.sh"]
CMD ["-port=8211", "-useperfthreads", "-NoAsyncLoadingThread", "-UseMultithreadForDS"]
