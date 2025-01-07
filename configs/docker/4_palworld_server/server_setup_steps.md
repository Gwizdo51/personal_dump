### Install server

1. add 40G drive to vbox image
2. bridged network access
3. install debian
    - increase swap to 5G
4. remove safe padding on partitions (`tune2fs /dev/XXX -m 0`)
4. install git, docker, curl, htop
4. connect to tailscale VPN
5. connect to git with ssh key
6. setup cron to reset server daily (symbolic link in `/etc/cron.daily/` to `restart_server.sh`)
6. copy the save folder to the SaveGames folder
7. modify Config/LinuxServer/GameUserSettings.ini "DedicatedServerName" line to match the name of the save folder

### Update Palworld version

down -> build -> up
