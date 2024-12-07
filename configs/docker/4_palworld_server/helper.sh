#!/bin/sh
# unceremoniously stolen (and repaired -> LF EOL) from https://github.com/pocketpairjp/palworld-dedicated-server-docker
sudo chown -R user:usergroup /pal/Package/Pal/Saved
exec /bin/sh /pal/Package/PalServer.sh "$@"
